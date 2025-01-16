<?php

namespace App\Controller;
use Cake\I18n\FrozenTime;
use Cake\Core\Configure;
use Cake\Utility\Inflector;
use Cake\ORM\Query;

class RadacctsController extends AppController {

    protected $main_model 	= 'Radaccts';
    protected $workingModel = 'Radaccts'; //Can be Radaccts or RadacctHistories
    
    protected $time_zone    = 'UTC'; //Default for timezone 
    protected $fields  	    = [
        'total_in' => 'sum(acctinputoctets)',
        'total_out' => 'sum(acctoutputoctets)',
        'total' => 'sum(acctoutputoctets) + sum(acctinputoctets)',
    ];
    
    public function initialize():void{
        parent::initialize();
        $this->loadModel($this->main_model);
        $this->loadModel('RadacctHistories');
        $this->loadModel('Users');
        $this->loadModel('PermanentUsers');
        $this->loadModel('Timezones');
        $this->loadComponent('Aa');
        $this->loadComponent('Kicker');
        $this->loadComponent('Counters');
        $this->loadComponent('TimeCalculations');
    }

	//---- Return the usage for a user/MAC combination
	public function getUsage(){
		if(
			(null !== $this->request->getQuery('username')) or
			(null !== $this->request->getQuery('mac'))
		){

			//Some defaults 
			$data_used	= null;
			$data_cap	= null;
			$time_used	= null;
			$time_cap	= null;

//			$new_entry = true;

			//We need a civilized way to tell the query if there are NO accountig data yet BUT there is a CAP (time_cap &| data_cap)! 

			//$data_used	= 10000;
			//$data_cap	= 50000;
			//$time_used	= 100;
			//$time_cap	= 200;

			$username 	= $this->request->getQuery('username');
			$mac		= $this->request->getQuery('mac');

			$this->loadModel('MacUsages');

			$q_m_u	= $this->MacUsages->find()->where(['MacUsages.username' => $username, 'MacUsages.mac'=> $mac])->first();

			if($q_m_u){
				$data_used	= $q_m_u->data_used;
				$data_cap	= $q_m_u->data_cap;
				$time_used	= $q_m_u->time_used;
				$time_cap	= $q_m_u->time_cap;
				$new_entry 	= false;
			}else{
				//Check what type of user it is since there was no record under MacUsage table...
				$type 			= 'unknown';
                $this->loadModel('Radchecks');

                $q_r	= $this->Radchecks->find()->where(['Radchecks.username' => $username,'Radchecks.attribute' => 'Rd-User-Type'])->first();

				if($q_r){
				    $type = $q_r->value;
				}

				$new_entry = false;

				if($type == 'user'){

					$q_u = $this->PermanentUsers->find()->where(['PermanentUsers.username' => $username])->first();

					if($q_u){
						$data_used	= $q_u->data_used;
						$data_cap	= $q_u->data_cap;
						$time_used	= $q_u->time_used;
						$time_cap	= $q_u->time_cap;
						if(($time_cap == null) && ($data_cap == null)){
							$new_entry = true;
						}
					}
				}

				if($type == 'voucher'){
				    $this->loadModel('Vouchers');

					$q_v = $this->Vouchers->find()->where(['Vouchers.name' => $username])->first();

					if($q_v){
						$data_used	= $q_v->data_used;
						$data_cap	= $q_v->data_cap;
						$time_used	= $q_v->time_used;
						$time_cap	= $q_v->time_cap;
						if(($time_cap == null) && ($data_cap == null)){
							$new_entry = true;
						}
					}
				}

				if($type == 'device'){
				    $this->loadModel('Devices');

					$q_v = $this->Devices->find()->where(['Devices.name' => $username])->first();

					if($q_v){
						$data_used	= $q_v->data_used;
						$data_cap	= $q_v->data_cap;
						$time_used	= $q_v->time_used;
						$time_cap	= $q_v->time_cap;
						if(($time_cap == null) && ($data_cap == null)){
							$new_entry = true;
						}
					}
				}
			}

			//If we don't have any data yet for this user ..we just specify its cap and 0 used....
			if($new_entry){
			
				$profile = $this->_find_user_profile($username);
            	if($profile){
					$counters = $this->Counters->return_counter_data_for_username($profile,$username);
					if(array_key_exists('time', $counters)){
						$time_cap = $counters['time']['value'];
						$time_used= 0;
					}
					if(array_key_exists('data', $counters)){
						$data_cap = $counters['data']['value'];
						$data_used= 0;
					}
				}
			}

			$data = ['data_used' => $data_used, 'data_cap' => $data_cap, 'time_used' => $time_used, 'time_cap' => $time_cap];
      
			$this->set([
                'success'   => true,
                'data'      => $data
            ]);
            $this->viewBuilder()->setOption('serialize', true);

		}else{
			$this->set([
                'success'   => false,
                'message'   => "Require a valid MAC address and username in the query string",
            ]);
            $this->viewBuilder()->setOption('serialize', true);
		}
	}


    //-------- BASIC CRUD -------------------------------
    public function exportCsv(){

        //__ Authentication + Authorization __
        $user = $this->_ap_right_check();
        if(!$user){
            return;
        }

        //Build query
        $user_id    = $user['id'];

        $query = $this->{$this->workingModel}->find();

        $this->_build_common_query($query, $user);

        $q_r = $query->all();

        //Headings
        $heading_line   = [];
        if(null !== $this->request->getQuery('columns')){
            $columns = json_decode($this->request->getQuery('columns'));
            foreach($columns as $c){             
                array_push($heading_line,$c->name);
            }
        }
        $data = [
            $heading_line
        ];

        //Results
        foreach($q_r as $i){
            $columns    = [];
            $csv_line   = [];
            if(null !== $this->request->getQuery('columns')){
                $columns = json_decode($this->request->getQuery('columns'));
                foreach($columns as $c){
                    $column_name = $c->name;
                    if($column_name == 'user_type'){
                        $user_type = 'unknown'; 
                        //Find device type
                       /* if(count($i['Radcheck']) > 0){
                            foreach($i['Radcheck'] as $rc){
                                if($rc['attribute'] == 'Rd-User-Type'){
                                    $user_type = $rc['value'];   
                                }
                            }
                        }*/
                        array_push($csv_line,$user_type);
                    }else{
                        array_push($csv_line,$i->$column_name);
                    } 
                }
                array_push($data,$csv_line);
            }
        }
        
        $this->setResponse($this->getResponse()->withDownload('RadiusAccounting.csv'));
        $this->viewBuilder()->setClassName('CsvView.Csv');    
        $this->set([
        	'data' => $data
        ]);     
        $this->viewBuilder()->setOption('serialize', true);  
        
    }
    
    public function indexWithSpan(){
      
        //__ Authentication + Authorization __
        $user = $this->_ap_right_check();
        if(!$user){
            return;
        }

        $user_id	= $user['id'];      
        $now    	= FrozenTime::now(); 
        $day    	= $now->year.'-'.$now->month.'-'.$now->day;  
        $span   	= 'daily';      //Can be daily weekly or monthly
        $type       = 'permanent';
       
        if($this->request->getQuery('day')){
            //Format will be: 2013-09-18T00:00:00
            $pieces = explode('T',$this->request->getQuery('day'));
            $day = $pieces[0];
        }      
        
        //==== TIMEZONE ======
        $tz = 'UTC';     
        if($this->request->getQuery('timezone_id') != null){
            $tz_id = $this->request->getQuery('timezone_id');
            $ent = $this->{'Timezones'}->find()->where(['Timezones.id' => $tz_id])->first();
            if($ent){
                $tz = $ent->name;
            }
        }        
        $time 		= new FrozenTime("$day 00:00:00", $tz);
        
        //=== Span ====        
        if($this->request->getQuery('span')){
        	$span = $this->request->getQuery('span');
        }
        
        $slot_start = $time->startOfDay(); //Default is daily
        $slot_end	= $time->endOfDay();
        
       	if($span	== 'weekly'){
        	$slot_start = $time->startOfWeek();
        	$slot_end	= $time->endOfWeek();	       
        }
        
        if($span	== 'monthly'){
        	$slot_start = $time->startOfMonth();
        	$slot_end	= $time->endOfMonth();	       
        }
               
        $conditions = [];
    	array_push($conditions,["acctstarttime >=" => $slot_start]);
    	array_push($conditions,["acctstarttime <=" => $slot_end]);
    	
    	//==== type === (can be cloud, dynamic_client, realm, permanent, voucher, device
    	if($this->request->getQuery('type')){
			$type = $this->request->getQuery('type');
    	}
    	
    	if($type == 'cloud'){
    	
    		//====== CLOUD's Realms FILTER =====  
		  	$this->loadModel('Realms'); 	
		  	$realm_clause = [];
		  	$found_realm  = false;
		 	$q_realms  = $this->{'Realms'}->find()->where(['Realms.cloud_id' => $this->request->getQuery('cloud_id')])->all();
		  	foreach($q_realms as $r){
		  		$found_realm = true;
		      	array_push($realm_clause, [$this->workingModel.'.realm' => $r->name]);
		 	}
		 	if($found_realm){
		 		array_push($conditions, ['OR' => $realm_clause]);
		 	}else{
		 		$this->Aa->fail_no_rights("No Realms owned by this cloud"); //If the list of realms for this cloud is empty reject the request
		    	return false;
		 	}      
		    //====== END Realm FILTER =====     	    	
    	}
    	
    	if($type == 'realm'){
    		$this->loadModel('Realms');
    		$e_realm = $this->{'Realms'}->find()->where(['Realms.id' => $this->request->getQuery('username')])->first();
    		if($e_realm){
    			array_push($conditions,["realm" => $e_realm->name]);
    		} 	
    	}
    	
    	if($type == 'dynamic_client'){
    		$this->loadModel('DynamicClients');
    		$e_dc = $this->DynamicClients->find()->where(['DynamicClients.id' => $this->request->getQuery('username')])->first();
    		if($e_dc){
    			array_push($conditions,["nasidentifier" => $e_dc->nasidentifier]);
    		} 	
    	}
    	
    	if(($type == 'permanent')||($type == 'voucher')){
    		array_push($conditions,["username" => $this->request->getQuery('username')]);
    	}
    	
    	if($type == 'device'){
    		array_push($conditions,["callingstationid" => $this->request->getQuery('username')]);
    	}
    	   	
    	$t_q = $this->{$this->workingModel}->find()->where($conditions)->select($this->fields)->first();	
    		      
        $total 		= $this->{$this->workingModel}->find()->where($conditions)->count();
        $e_radaccts = $this->{$this->workingModel}->find()->where($conditions)->order([' acctstarttime' => 'DESC'])->all();       
        $items		= [];
        
        foreach($e_radaccts as $e_ra){  
        
        	$e_ra->user_type      = 'unknown';
            $e_ra->online_human   = '';

            if($e_ra->acctstoptime == null){
                $online_time    	  = time()-strtotime($e_ra->acctstarttime);
                $e_ra->active         = true; 
                $e_ra->online_human   = $this->TimeCalculations->time_elapsed_string($e_ra->acctstarttime,false,true);
            }else{
                $online_time    	  = $e_ra->acctstoptime->setTimezone($tz)->format('Y-m-d H:i:s');
                $e_ra->active         = false;
                $e_ra->online_human   = $this->TimeCalculations->time_elapsed_string($e_ra->acctstarttime,false,true);                        
           	}
           
           $e_ra->acctstarttime 	= $e_ra->acctstarttime->setTimezone($tz)->format('Y-m-d H:i:s');
           $e_ra->acctstoptime		= $online_time;
           
            
        	array_push($items,$e_ra);        
        }
     
        $this->set([
        	'items'			=> $items,
            'success'       => true,
            'metaData'      => [
                'totalIn'       => $t_q->total_in,
                'totalOut'      => $t_q->total_out,
                'totalInOut'    => $t_q->total,
            ]
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }
       
    public function index(){
        //-- Required query attributes: token;
        //-- Optional query attribute: sel_language (for i18n error messages)
        //-- also LIMIT: limit, page, start (optional - use sane defaults)
        //-- FILTER <- This will need fine tunning!!!!
        //-- AND SORT ORDER <- This will need fine tunning!!!!

        //__ Authentication + Authorization __
        $user = $this->_ap_right_check();
        if(!$user){
            return;
        }

        $user_id        = $user['id'];         
        $only_connected = $this->request->getQuery('only_connected');
       
        if($only_connected == 'false'){
            $this->workingModel = 'RadacctHistories';
        }                     
        $query      = $this->{$this->workingModel}->find();

        if(!$this->_build_common_query($query, $user)){
        	return;
        }
        
        //==== TIMEZONE ======
        $tz = 'UTC';
        
        if($this->request->getQuery('timezone_id') != null){
            $tz_id = $this->request->getQuery('timezone_id');
            $ent = $this->{'Timezones'}->find()->where(['Timezones.id' => $tz_id])->first();
            if($ent){
                $tz = $ent->name;
            }
        }
        
        //===== PAGING (MUST BE LAST) ======
        $limit  = 50;   //Defaults
        $page   = 1;
        $offset = 0;

        if(null !== $this->request->getQuery('limit')){
            $limit  = $this->request->getQuery('limit');
            $page   = $this->request->getQuery('page');
            $offset = $this->request->getQuery('start');
        }

        $query->page($page);
        $query->limit($limit);
        $query->offset($offset);
        
        $total      = $query->count();
        $q_r        = $query->all();
                
        $totalIn    = 0;
        $totalOut   = 0;
        $totalInOut = 0;
        $activeData = false;
        
        if($this->workingModel == $this->main_model){
            $activeData = true;
            $query_total = $this->{$this->workingModel}->find();
            if(!$this->_build_common_query($query_total, $user,true)){
        	    return;
            }       
            $t_q    = $query_total->select($this->fields)->first();
            if($t_q){
                $totalIn    = $t_q->total_in;
                $totalOut   = $t_q->total_out;
                $totalInOut = $t_q->total;
            }
        }

        $items  = [];
        foreach($q_r as $i){
              
            $i->user_type     = 'unknown';
            $i->online_human  = '';

            if($i->acctstoptime == null){
                $online_time        = time()-strtotime($i->acctstarttime);
                $i->active          = true; 
                $i->online_human    = $this->TimeCalculations->time_elapsed_string($i->acctstarttime,false,true);
            }else{
                $online_time    = $i->acctstoptime->setTimezone($tz)->format('Y-m-d H:i:s');
                $i->active      = false;
            }           
            $i->acctstarttime   = $i->acctstarttime->setTimezone($tz)->format('Y-m-d H:i:s');
            $i->id              = $i->radacctid;
            $i->acctstoptime    = $online_time;
            
            if($i->permanent_user){
            
                $i->pu_active   = $i->permanent_user->active;
                $i->pu_site     = $i->permanent_user->site;
                $i->pu_extra_name = $i->permanent_user->extra_name;
                $i->pu_extra_value = $i->permanent_user->extra_value;
            }
                                          
            array_push($items,$i);
           
        } 
                       
        $this->set([
            'items'         => $items,
            'success'       => true,
            'totalCount'    => $total,
            'totalIn'       => $totalIn,
            'totalOut'      => $totalOut,
            'totalInOut'    => $totalInOut,
            'metaData'      => [
                'activeData'    => $activeData,
                'totalIn'       => $totalIn,
                'totalOut'      => $totalOut,
                'totalInOut'    => $totalInOut,
                'totalCount'    => $total
            ]
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }

    public function delete($id = null) {
		if (!$this->request->is('post')) {
			throw new MethodNotAllowedException();
		}

        //__ Authentication + Authorization __
        $user = $this->_ap_right_check();
        if(!$user){
            return;
        }
        $req_d			= $this->request->getData();

        //FIXME We need to find a creative wat to determine if the Access Provider can delete this accounting data!!!
	     if(isset($req_d['id'])){
            //$this->_voucher_status_check($req_d['id']);
            $this->{$this->workingModel}->query()->delete()->where(['radacctid' => $req_d['id']])->execute();
        }else{                          //Assume multiple item delete
            foreach($req_d as $d){ 
                //$this->_voucher_status_check($d['id']);
                $this->{$this->workingModel}->query()->delete()->where(['radacctid' => $d['id']])->execute();
            }         
        }

        $fail_flag = false;
        if($fail_flag == true){
            $this->set([
                'success'   => false,
                'message'   => __('Could not delete some items'),
            ]);
            $this->viewBuilder()->setOption('serialize', true);
        }else{
            $this->set([
                'success' => true
            ]);
            $this->viewBuilder()->setOption('serialize', true);
        }
	}
	
	
	public function kickActiveUsername(){
		//__ Authentication + Authorization __
        $user = $this->_ap_right_check();
        if(!$user){
            return;
        }
        
        //It should have a token if it made it to here :-)
        $q_data		= $this->request->getQuery();
        $token 		= $q_data['token'];
        $username 	= $q_data['username'];
		$data		= [];
		
		
		$e_username = $this->{$this->workingModel}->find()->where(['username' => $username,'acctstoptime IS NULL'])->all();
		foreach($e_username as $ent){
			$data = $this->Kicker->kick($ent,$token); //Sent it to the Kicker (We include the token in order to make API calls if needed
		}	
		$this->set([
            'success'       => true,
            'data'          => $data
        ]);
        $this->viewBuilder()->setOption('serialize', true);
	
	}
	

    public function kickActive(){
    
        //__ Authentication + Authorization __
        $user = $this->_ap_right_check();
        if(!$user){
            return;
        }
        
        //It should have a token if it made it to here :-)
        $q_data	= $this->request->getQuery();
        $token 	= $q_data['token'];

        
        $some_session_closed    = false;
        $count                  = 0;
        $msg                    = 'Could not locate session';
        $data                   = ['title' => 'Session Not Found', 'message' => $msg, 'type' =>'warn'];
        $req_q      			= $this->request->getQuery();

        foreach(array_keys($req_q) as $key){
            if(preg_match('/^\d+/',$key)){
                $ent = $this->{$this->workingModel}->find()->where(['radacctid' => $key])->first();
                $count++;               
                if($ent->acctstoptime !== null){
                    $some_session_closed = true;
                }else{
                    $data = $this->Kicker->kick($ent,$token); //Sent it to the Kicker (We include the token in order to make API calls if needed
                }
            }
        }  
        
        if($count >0){      
            $data = ['title' => 'Disconnect Sent', 'message' => 'Disconnect Instructions Sent', 'type' =>'info'];
        }   

        if(($some_session_closed)&&($count>0)){
            $msg = 'Sessions Is already Closed';
            if($count > 1){
                $msg = 'Some Sessions Are already Closed';
            }
            $data = ['title' => 'Session Closed Already', 'message' => $msg, 'type' =>'warn'];
        }
    
        $this->set([
            'success'       => true,
            'data'          => $data
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }

    public function closeOpen(){

        //__ Authentication + Authorization __
        $user = $this->_ap_right_check();
        if(!$user){
            return;
        }       
        $req_q    = $this->request->getQuery();
        foreach(array_keys($req_q) as $key){
            if(preg_match('/^\d+/',$key)){
                $qr = $this->{$this->workingModel}->find()->where(['radacctid' => $key])->first();
                if($qr){
                    if($qr->acctstoptime == null){
                        $now = date('Y-m-d h:i:s');
                        $d['acctstoptime'] = $now;
						$this->{$this->workingModel}->patchEntity($qr,$d);
                        $this->{$this->workingModel}->save($qr);
                    }
                }  
            }
        }

        $this->set([
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }

    //--------- END BASIC CRUD ---------------------------

    //----- Menus ------------------------
    public function menuForGrid(){

        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }

        $timezone_id    = 316; //London by default  
        $e_user         = $this->{'Users'}->find()->where(['Users.id' => $user['id']])->first();
        if($e_user->timezone_id){
            $timezone_id = $e_user->timezone_id;
        } 

        $scale = 'large';

        $menu = [
                ['xtype' => 'buttongroup','title' => null, 'items' => [
                    ['xtype' =>  'splitbutton',  'glyph' => Configure::read('icnReload'), 'scale'   => $scale, 'itemId'    => 'reload',   'tooltip'    => __('Reload'),
                        'menu'  => [
                            'items' => [
                                '<b class="menu-title">'.__('Reload every').':</b>',
                              //  array( 'text'   => _('Cancel auto reload'),   'itemId' => 'mnuRefreshCancel', 'group' => 'refresh', 'checked' => true ),
                                ['text'  => __('30 seconds'),      'itemId'    => 'mnuRefresh30s', 'group' => 'refresh','checked' => false ],
                                ['text'  => __('1 minute'),        'itemId'    => 'mnuRefresh1m', 'group' => 'refresh' ,'checked' => false],
                                ['text'  => __('5 minutes'),       'itemId'    => 'mnuRefresh5m', 'group' => 'refresh', 'checked' => false ],
                                ['text'  => __('Stop auto reload'),'itemId'    => 'mnuRefreshCancel', 'group' => 'refresh', 'checked' => true]
                            ]
                        ]
                ],
                [
                    'xtype' => 'tbseparator'
                ],
                [
                        'xtype'         => 'button',
                         
                        //To list all
                        //'glyph'         => Configure::read('icnWatch'),
                        //'pressed'       => false,
                        
                        //To list only active
                        'glyph'         => Configure::read('icnLight'),
                        'pressed'       => true,
                                
                        'scale'         => $scale,
                        'itemId'        => 'connected',
                        'enableToggle'  => true,
                         
                        'ui'            => 'button-green',  
                        'tooltip'       => __('Show only currently connected')
                ],
                [
                    'xtype' => 'tbseparator'
                ],
                [
                    'xtype'         => 'cmbTimezones', 
                    'width'         => 200, 
                    'itemId'        => 'cmbTimezone',
                    'name'          => 'timezone_id', 
                    'fieldLabel'    => '',
                    'padding'       => '7 0 0 0',
                    'margin'        => 0,
                    'value'         => $timezone_id
                ],
                [
                    'xtype' => 'tbseparator'
                ],
                [
                        'xtype'         => 'button',
                        'glyph'         => Configure::read('icnInfoCircle'),
                        'pressed'       => false,                               
                        'scale'         => $scale,
                        'itemId'        => 'btnInfo',
                        'enableToggle'  => true,
                        'tooltip'       => __('Include more info (loads slower)')
                ],               
                ]],
                ['xtype' => 'buttongroup','title' => null, 'items' => [
                    ['xtype' => 'button', 'glyph'     => Configure::read('icnCsv'), 'scale' => $scale, 'itemId' => 'csv',      'tooltip'=> __('Export CSV')],
                    ['xtype' => 'button', 'glyph'     => Configure::read('icnGraph'), 'scale' => $scale, 'itemId' => 'graph',    'tooltip'=> __('Usage graph')],
                ]],
                ['xtype' => 'buttongroup','title' => null, 'items' => [
                    ['xtype' => 'button', 'glyph'     => Configure::read('icnKick'),'scale' => $scale, 'itemId' => 'kick', 'tooltip'=> __('Kick user off')],
                    ['xtype' => 'button', 'glyph'     => Configure::read('icnClose'),'scale' => $scale, 'itemId' => 'close','tooltip'=> __('Close session')],
                ]],
                [
                    'xtype'   => 'component', 
                    'itemId'  => 'totals',  
                     'tpl'    => [
                        "<div style='font-size:larger;width:400px;'>",
                        "<ul class='fa-ul'>",
                        "<li style='padding:2px;'>",
                        "<span class='fa-li' style='font-family:FontAwesome;'>&#xf1c0</span> {in} in {out} out {total} total</span></li>",
                        "<li style='padding:2px;'><i class='fa-li fa fa-arrow-right'></i> {total_connected} items</li>",
                        "</ul>",
                        "</div>"                    
                    ],
                    'data'   =>  [],
                    'cls'    => 'lblRd'
                ]               
        ];
        

        $this->set([
            'items'         => $menu,
            'success'       => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }

    //______ END EXT JS UI functions ________

  	function _build_common_query($query, $user,$totals=false){ //We add the $totals flag. If it is set to true; we do not do the sort part (breaks with Postgresql)

        $where = [];
        $joins = [];     
        $req_q = $this->request->getQuery();
               
		//Make sure there is a cloud id
        if(!isset($req_q['cloud_id'])){
        	$this->Aa->fail_no_rights("Required Cloud ID Missing");
        	return false;
       	}      	
                      
        //====== Only_connectd filter ==========
        $only_connected = false;
        $extra_info     = false;
        if($this->request->getQuery('only_connected')){
            if($this->request->getQuery('only_connected') == 'true'){
                $only_connected = true;
                array_push($where,$this->workingModel.".acctstoptime IS NULL");
            }
        } 
        
        if($this->request->getQuery('extra_info')){
            if($this->request->getQuery('extra_info') == 'true'){
                $extra_info = true;
            }
        } 
                         
        //===== SORT =====
        //Default values for sort and dir
        $sort   = $this->workingModel.'.username';
        $dir    = 'DESC';
        

        if($this->request->getQuery('sort')){
            //Permanent users (extra info)
            if((str_starts_with($this->request->getQuery('sort'), 'pu_'))&&($extra_info)){
                $pu_sort = $this->request->getQuery('sort');
                $pu_sort = str_replace('pu_','',$pu_sort);
                $sort = 'PermanentUsers.'.$pu_sort;                   
            }else{                  
                $sort = $this->workingModel.'.'.$this->request->getQuery('sort');
            }
            //Here we do a trick if we only list active connections since we can't order by null
            if(($sort == 'acctstoptime') && ($only_connected)){
                $sort = 'acctstarttime';
            }
            $dir  = $this->request->getQuery('dir');
        }
        
        if(!$totals){        
            $query->order([$sort => $dir]);
        }

        //==== END SORT ===

        //======= For a specified username filter *Usually on the edit of user / voucher ======
        if($this->request->getQuery('username')){
            $un = $this->request->getQuery('username');
            array_push($where,[ $this->workingModel.".username" => $un]);
        }

        //======= For a specified callingstationid filter *Usually on the edit of device ======
        if($this->request->getQuery('callingstationid')){
            $cs_id = $this->request->getQuery('callingstationid');
            array_push($where, [$this->workingModel.".callingstationid" => $cs_id]);
        }

        //====== REQUEST FILTER =====
        if($this->request->getQuery('filter')){
            $req_q 	= $this->request->getQuery(); 
            $filter = json_decode($req_q['filter']); 

            foreach($filter as $f){
                                      
                //Strings
                if($f->operator == 'like'){
                    //Permanent Users' properties will start with pu_
                    if((str_starts_with($f->property, 'pu_'))&&($extra_info)){
                        $pu_col = $f->property;
                        $pu_col = str_replace('pu_','',$pu_col);
                        $col = 'PermanentUsers.'.$pu_col;                   
                    }else{                 
                        $col = $this->workingModel.'.'.$f->property;
                    }
                    array_push($where, ["$col LIKE" => '%'.$f->value.'%']);
                }
                
                //Bools
                if($f->operator == '=='){
                    if(($f->property == 'pu_active')&&($extra_info)){
                        array_push($where, ["PermanentUsers.active" => $f->value]);
                    }
                }
                //Date
                if(($f->operator == 'gt')||($f->operator == 'lt')||($f->operator == 'eq')){
                    //date we want it in "2013-03-12"
                    $col = $this->workingModel.'.'.$f->property;
                    if($f->operator == 'eq'){
                        array_push($where, ["DATE($col)" => $f->value]);
                    }

                    if($f->operator == 'lt'){
                        array_push($where, ["DATE($col) <" => $f->value]);
                    }
                    if($f->operator == 'gt'){
                        array_push($where, ["DATE($col) >" => $f->value]);
                    }
                }
                //Lists
                if($f->operator == 'in'){
                    if($f->property == 'user_type'){
                        $list_array = [];
                        foreach($f->value as $filter_list){
                            array_push($list_array, ["Radchecks.attribute" => "Rd-User-Type", "Radchecks.value" => $filter_list]);
                        }
                        array_push($joins, [
                            'table'         => 'radcheck',
                            'alias'         => 'Radcheck',
                            'type'          => 'LEFT',
                            'conditions'    =>  ['(Radchecks.username = callingstationid) OR (Radchecks.username = username)']
                        ]);

                        $query->join($joins);

                        array_push($where, ['OR' => $list_array]);
                    }
                }
            }
        }
        //====== END REQUEST FILTER =====
                
        if($only_connected){
            if($extra_info){     
                $query->contain('PermanentUsers', function (Query $q) {
                    return $q
                        ->select(['active', 'site','ppsk','extra_name','extra_value']);
                });
            }
         }
           
        //====== CLOUD's Realms FILTER =====  
      	$this->loadModel('Realms'); 	
      	$realm_list = [];
      	$found_realm  = false;
     	$q_realms  = $this->{'Realms'}->find()->where(['Realms.cloud_id' => $req_q['cloud_id']])->all();
      	foreach($q_realms as $r){
      		$found_realm  = true;
          	$realm_list[] = $r->name;
          	$apRealmList  = $this->Aa->realmCheck(true);
          	if($apRealmList){
          	    $realm_list = $apRealmList;
          	}        	
     	}
     	if($found_realm){ 	
     		array_push($where, ["$this->workingModel.realm IN" => $realm_list]);
     	}else{
     		$this->Aa->fail_no_rights("No Realms owned by this cloud"); //If the list of realms for this cloud is empty reject the request
        	return false;
     	}      
        //====== END Realm FILTER =====        
        
        $query->where($where);  
                
        return true;
    }

   
    private function _voucher_status_check($id){

        //Find the count of this username; if zero check if voucher; if voucher change status to 'new';
        $q_r = $this->{$this->workingModel}->find()->contain(['Radchecks'])->where(['radacctid' => $id])->first();
        if($q_r){
            $user_type = 'unknown';
            $un = $q_r->username;
            //Get the user type
            if(count($q_r->radchecks) > 0){
                foreach($q_r->radchecks as $rc){
                    if($rc->attribute == 'Rd-User-Type'){
                        $user_type = $rc->value;
                    }
                }
            }
            //Check if voucher
            if($user_type == 'voucher'){
                $this->loadModel('Vouchers');

                $count = $this->{$this->workingModel}->find()->where(['username' => $un])->count();
                if($count == 1){
                    $qr = $this->Vouchers->find()->where(['Vouchers.name' => $un])->first();
                    if($qr){
                        $dseries = [];
                        $dseries['id'] = $qr->id;
                        $dseries['status'] = 'new';
                        $dseries['perc_data_used'] = null;
                        $dseries['perc_time_used'] = null;

                        $voucherEntity = $this->Vouchers->newEnity($dseries);
                        $this->Vouchers->save($voucherEntity);

                    }
                }
            }
        }
    }

	private function _find_user_profile($username){
        $this->loadModel('Radchecks');
        $profile = false;
        $q_r = $this->Radchecks->find()->where(['Radchecks.username' => $username,'Radchecks.attribute' => 'User-Profile'])->first();
        if($q_r){
            $profile = $q_r->value;
        }
        return $profile;
    }


}
