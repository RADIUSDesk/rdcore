<?php

namespace App\Controller;
use App\Controller\AppController;

use Cake\Core\Configure;
use Cake\Core\Configure\Engine\PhpConfig;

use Cake\Utility\Inflector;


class AccessProvidersController extends AppController{
  
    public $base  = "Access Providers/Controllers/AccessProviders/";
    
    protected $owner_tree = [];
    
    protected $main_model = 'Users';
    
    protected $rights = [
        'cmp_admins'            => 'AccessProviders/index',
        'cmp_realms'            => 'Realms/index',
        'cmp_permanent_users'   => 'PermanentUsers/index',
        'cmp_vouchers'          => 'Vouchers/index',
        'cmp_profiles'          => 'Profiles/index',
        'cmp_radius'            => 'DynamicClients/index',
        'cmp_mesh_desk'         => 'Meshes/index',
        'cmp_ap_desk'           => 'ApProfiles/index',
        //'cmp_alerts'            => 'ApProfiles/index',
        'cmp_login_pages'       => 'DynamicDetails/index',
        'cmp_wizards'           => 'Wizards/index',
        'cmp_openvpn_servers'   => 'OpenvpnServers/index',
        'cmp_traffic_classes'   => 'TrafficClasses/index', //This will imply also Facebook XWF
        'cmp_unknown_dynamic_clients'   => 'UnknownDynamicClients/index',
        'cmp_unknown_nodes'     => 'UnknownNodes/index',
    ];
    protected   $acl_base = "Access Providers/Controllers/";
  
    public function initialize():void{  
        parent::initialize();  
          
        $this->loadModel('Users'); 
        $this->loadModel('Groups');
		$this->loadModel('UserSettings');  
        $this->loadComponent('Aa');
        $this->loadComponent('GridButtonsFlat');           
        $this->loadComponent('WhiteLabel'); 
        $this->loadComponent('TimeCalculations');
        $this->loadComponent('JsonErrors');     
    }
       
    public function exportCsv(){
    
    	if(!$this->Aa->admin_check($this)){   //Only for admin users!
            return;
        }
        
        $req_q    	= $this->request->getQuery(); //q_data is the query data             
        $ap_name    = Configure::read('group.ap');             
        $query		= $this->{$this->main_model}->find()->where(['Groups.name' => $ap_name])->contain(['Groups']);       
        $q_r    	= $query->all();
        
        $heading_line   = [];
        if(isset($req_q['columns'])){
            $columns = json_decode($req_q['columns']);
            foreach($columns as $c){
                array_push($heading_line,$c->name);
            }
        }
        
        $data = [
            $heading_line
        ];
        
        foreach($q_r as $i){

            $columns    = [];
            $csv_line   = [];
            if(isset($req_q['columns'])){
                $columns = json_decode($req_q['columns']);
                foreach($columns as $c){
                	$column_name = $c->name;                  
               		array_push($csv_line,$i->{$column_name});  
                }
                array_push($data,$csv_line);
            }
        }     
        $this->setResponse($this->getResponse()->withDownload('AccessProviders.csv'));
        $this->viewBuilder()->setClassName('CsvView.Csv');       
        $this->set([
            'data' => $data,
        ]);       
        $this->viewBuilder()->setOption('serialize', true); 
    }
    
    public function apTagList(){
    
    	$user = $this->Aa->user_for_token($this);
		if(!$user){   //If not a valid user
			return;
		}
		
		$user_id 	= $user['id'];		
		$items 		= [];		
		
		$ap_name    = Configure::read('group.ap');
		$e_group    = $this->{'Groups'}->find()->where(['Groups.name' => $ap_name])->first();
		if($e_group){
			$group_id 	= $e_group->id;
			$q_r 		= $this->{'Users'}->find()->where(['Users.group_id' => $group_id])->order(['Users.username' => 'ASC'])->all();
			foreach($q_r as $e){
			
				//-- JAN 2025 we also list the user themself else when they save the list they remove themself from it.
				//if($e->id !== $user_id){
                    array_push($items, ['id' => $e->id, 'name' => $e->username]);
				//}			
			}	
		}
		
		$this->set([
            'items' 		=> $items,
            'success' 		=> true
        ]);
        $this->viewBuilder()->setOption('serialize', true);  
    }
    
     //____ BASIC CRUD Manager ________
    public function index(){

        if(!$this->Aa->admin_check($this)){   //Only for admin users!
            return;
        }
        
        $req_q    	= $this->request->getQuery(); 
        $ap_name    = Configure::read('group.ap');             
        $query		= $this->{$this->main_model}->find()->where(['Groups.name' => $ap_name])->contain(['Groups']);     
        //===== PAGING (MUST BE LAST) ======
        $limit  = 50; 
        $page   = 1;
        $offset = 0;
        if(isset($req_q['limit'])){
            $limit  = $req_q['limit'];
            $page   = $req_q['page'];
            $offset = $req_q['start'];
        }
        
        $query->page($page);
        $query->limit($limit);
        $query->offset($offset);

        $total  = $query->count();       
        $q_r    = $query->all();
        $items  = [];
        
        foreach($q_r as $i){            
            $row        = [];
            $fields     = $this->{$this->main_model}->getSchema()->columns();
            foreach($fields as $field){
                $row["$field"]= $i->{"$field"};             
                if($field == 'created'){
                    $row['created_in_words'] = $this->TimeCalculations->time_elapsed_string($i->{"$field"});
                }
                if($field == 'modified'){
                    $row['modified_in_words'] = $this->TimeCalculations->time_elapsed_string($i->{"$field"});
                }   
            }
            array_push($items,$row);
        }
        $this->set([
            'items' 		=> $items,
            'success' 		=> true,
            'totalCount' 	=> $total
        ]);
        $this->viewBuilder()->setOption('serialize', true); 
    }
   
    public function add(){

        if(!$this->Aa->admin_check($this)){   //Only for admin users!
            return;
        }
        $req_d		= $this->request->getData();
  
        $check_items = [
			'active'
		];
        foreach($check_items as $i){
            if(isset($req_d[$i])){
                $req_d[$i] = 1;
            }else{
                $req_d[$i] = 0;
            }
        }    

        //Get the language and country
        $country_language   = explode( '_', $req_d['language'] );
        $country            = $country_language[0];
        $language           = $country_language[1];

        $req_d['language_id'] = $language;
        $req_d['country_id']  = $country;

        //Get the group ID for AP's
        $ap_name    = Configure::read('group.ap');
        $q_r        = $this->Groups->find()->where(['Groups.name' => $ap_name])->first();
        $group_id   = $q_r->id;
        $req_d['group_id'] = $group_id;

        //Zero the token to generate a new one for this user:
        $req_d['token'] = '';

        //The rest of the attributes should be same as the form..
        $entity = $this->{$this->main_model}->newEntity($req_d); 
        if($this->{$this->main_model}->save($entity)){
            $this->set([
                'success' => true
            ]);
            $this->viewBuilder()->setOption('serialize', true); 
        }else{
            $message = 'Error';
            $errors = $entity->errors();
            $a = [];
            foreach(array_keys($errors) as $field){
                $detail_string = '';
                $error_detail =  $errors[$field];
                foreach(array_keys($error_detail) as $error){
                    $detail_string = $detail_string." ".$error_detail[$error];   
                }
                $a[$field] = $detail_string;
            }   
            $this->set([
                'errors'    => $a,
                'success'   => false,
                'message'   => ['message' => __('Could not create item')]
            ]);
            $this->viewBuilder()->setOption('serialize', true); 
        }   
    }
    
    public function view(){


        if(!$this->Aa->admin_check($this)){   //Only for admin users!
            return;
        }
        
        $items 		= [];
        $req_q    = $this->request->getQuery();
        if(isset($req_q['ap_id'])){
			$ap_id = $req_q['ap_id'];
            $q_r = $this->{$this->main_model}->find()->where([$this->main_model.'.id' => $ap_id])->first();
            if($q_r){
                $items['id']        = $q_r->id;
                $items['username']  = $q_r->username;
                $items['name']      = $q_r->name;
                $items['surname']   = $q_r->surname;
                $items['phone']     = $q_r->phone;
                $items['address']   = $q_r->address;
                $items['email']     = $q_r->email;
                $items['active']    = $q_r->active;
                $language           = $q_r->country_id.'_'.$q_r->language_id;
                $items['language']  = $language;
                $items['timezone_id']  = $q_r->timezone_id;
                $items['api_key']   = $q_r->token;
                
                // Get the alert_activate and alert_frequency
				$this->loadModel('UserSettings');
				$items['alert_activate'] = 0;
				$items['alert_frequency'] = 1;
				$q_alert = $this->UserSettings->find()->where(['UserSettings.user_id' => $ap_id,"UserSettings.name" => "alert_activate"])->first();
				if($q_alert) {
					if(intval($q_alert->value) > 0){
						$items['alert_activate'] = 'alert_activate';
					} else {
						$items['alert_activate'] = 0;
					}
				}
				$q_freq = $this->UserSettings->find()->where(['UserSettings.user_id' => $ap_id,"UserSettings.name" => "alert_frequency"])->first();
				if($q_freq) {
					$items['alert_frequency'] = $q_freq->value;
				}			
                $wl         = $this->WhiteLabel->detail($req_q['ap_id']);   
                $items      = array_merge($items, $wl);
                   
            }
        }
        
        $this->set([
            'data'      => $items,
            'success'   => true
        ]);
        $this->viewBuilder()->setOption('serialize', true); 
    }
  
    public function edit(){
    
       	if(!$this->Aa->admin_check($this)){   //Only for admin users!
            return;
        } 
          
        $this->viewBuilder()->setLayout('ext_file_upload');
    
        //__ Authentication + Authorization __
        //We need to unset a few of the values submitted:
        $req_d		= $this->request->getData();
        unset($req_d['token']);
        unset($req_d['password']);
        
        $ap_id = $req_d['id'];

        $check_items = [
			'active',
			'wl_active',
			'wl_img_active',
			'alert_activate'
		];
        foreach($check_items as $i){
            if(isset($req_d[$i])){
                $req_d[$i] = 1;
            }else{
                $req_d[$i] = 0;
            }
        }    

        //Get the language and country
        $country_language   = explode( '_', $req_d['language'] );

        $country            = $country_language[0];
        $language           = $country_language[1];

        $req_d['language_id'] = $language;
        $req_d['country_id']  = $country;
        
        $e_user = $this->{$this->main_model}->get($ap_id);
        $this->{$this->main_model}->patchEntity($e_user, $req_d);
        
		$this->loadModel('UserSettings');

		// Set the Alerts email threshold and frequency
		if(!array_key_exists('alert_activate',$req_d)){
			$req_d['alert_activate'] = 0;
		}
		if(!array_key_exists('alert_frequency', $req_d)){
			$req_d['alert_frequency'] = 1;
		}
		$this->UserSettings->deleteAll(['user_id' => $ap_id,'name' => 'alert_activate']);
		$this->UserSettings->deleteAll(['user_id' => $ap_id,'name' => 'alert_frequency']);
		$us_entity = $this->UserSettings->newEmptyEntity();
		$us_entity->user_id    = $ap_id;
		$us_entity->name       = 'alert_activate';
		$us_entity->value      = $req_d['alert_activate'];
		$this->UserSettings->save($us_entity);
		$us_entity = $this->UserSettings->newEmptyEntity();
		$us_entity->user_id    = $ap_id;
		$us_entity->name       = 'alert_frequency';
		$us_entity->value      = $req_d['alert_frequency'];
		$this->UserSettings->save($us_entity);
		
        //The White Label stuff ONLY if it is enabled Site Wide
        
        if(Configure::read('whitelabel.active') == true){
            $looking_for    = ['wl_active','wl_header','wl_h_bg','wl_h_fg','wl_footer','wl_img_active','wl_img_file'];
        
            //Only if it is enabled do we do it
            if($req_d['wl_active'] == 1){
            
                $new_logo = false;
            
                //Check if there came some image with it
                if(isset($_FILES['wl_img_file_upload'])){
                    if($_FILES['wl_img_file_upload']['size'] > 0){    
                        $path_parts     = pathinfo($_FILES['wl_img_file_upload']['name']);
                        $unique         = time();
                        $filename       = $unique.'.'.$path_parts['extension'];
                        $dest           = WWW_ROOT."img/access_providers/".$filename;
                        move_uploaded_file ($_FILES['wl_img_file_upload']['tmp_name'] , $dest);
                        $new_logo       = true;
                    }
                    
                    if($new_logo == true){
                        $this->UserSettings->deleteAll(['user_id' => $ap_id,'name' => 'wl_img_file']);
                        $entity = $this->UserSettings->newEmptyEntity();
                        $entity->user_id    = $ap_id;
                        $entity->name       = 'wl_img_file';
                        $entity->value      = $filename;
                        $this->UserSettings->save($entity);
                    }
                }   
            
                foreach($looking_for as $i){    
                    //Delete old one
                    if(($i == 'wl_img_file')&&($new_logo == true)){
                        continue; //We skip it if we added a new file
                    }
                      
                    $this->UserSettings->deleteAll(['user_id' => $ap_id,'name' => $i]);
                    //Add a New ONE
                    $entity             = $this->UserSettings->newEmptyEntity();
                    $entity->user_id    = $ap_id;
                    $entity->name       = $i;
                    $entity->value      = $req_d["$i"];
                    $this->UserSettings->save($entity);
                }
            }else{
                //Only disable it
                $this->UserSettings->deleteAll(['user_id' => $ap_id,'name' => 'wl_active']);
                $entity = $this->UserSettings->newEmptyEntity();
                $entity->user_id    = $ap_id;
                $entity->name       = 'wl_active';
                $entity->value      = 0;
                $this->UserSettings->save($entity);
            }  
        }
       
        if ($this->{$this->main_model}->save($e_user)) {
            $this->set([
                'success' => true
            ]);
            $this->viewBuilder()->setOption('serialize', true); 
        } else {
            $message = 'Error';
            
            $errors = $e_user->errors();
            $a = [];
            foreach(array_keys($errors) as $field){
                $detail_string = '';
                $error_detail =  $errors[$field];
                foreach(array_keys($error_detail) as $error){
                    $detail_string = $detail_string." ".$error_detail[$error];   
                }
                $a[$field] = $detail_string;
            }
            
            $this->set([
                'errors'    => $a,
                'success'   => false,
                'message'   => __('Could not create item')
            ]);
            $this->viewBuilder()->setOption('serialize', true); 
        }
        
    }
   
    
    public function menuForGrid(){   
        $menu = $this->GridButtonsFlat->returnButtons(false,'access_providers');
        $this->set([
            'items'         => $menu,
            'success'       => true
        ]);
        $this->viewBuilder()->setOption('serialize', true); 
    }
    
    public function delete($id = null) {
    
    	if(!$this->Aa->admin_check($this)){   //Only for admin users!
            return;
        }
    
		if (!$this->request->is('post')) {
			throw new MethodNotAllowedException();
		}
		$req_d		= $this->request->getData();
	    if(isset($req_d['id'])){   //Single item delete      
            $entity     = $this->{$this->main_model}->get($req_d['id']);
            $this->{$this->main_model}->delete($entity);  
        }else{                          //Assume multiple item delete
            foreach($req_d as $d){
                $entity     = $this->{$this->main_model}->get($d['id']);               
               	$this->{$this->main_model}->delete($entity);
            }
        }
        $this->set([
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true); 
	}
	
	public function changePassword(){
	
		if(!$this->Aa->admin_check($this)){   //Only for admin users!
            return;
        }

        $success 	= false;
        $req_d		= $this->request->getData();
        if(isset($req_d['user_id'])){
            $entity = $this->{$this->main_model}->get($req_d['user_id']); 
            $data = [
                'password'  => $req_d['password'],
                'token'     => ''
            ];
            $this->{$this->main_model}->patchEntity($entity, $data);
            $this->{$this->main_model}->save($entity);
            $success               = true;  
        }

        $this->set([
            'success' => $success
        ]);
        $this->viewBuilder()->setOption('serialize', true); 
    }
    
    public function enableDisable(){ 
    
    	if(!$this->Aa->admin_check($this)){   //Only for admin users!
            return;
        }      

		$req_d	= $this->request->getData();
        $rb  	= $req_d['rb'];
        if($rb == 'enable'){
            $active = 1;
        }else{
            $active = 0;
        }
        foreach(array_keys($req_d) as $key){
            if(preg_match('/^\d+/',$key)){  
                $entity = $this->{$this->main_model}->get($key);
                $entity->active = $active;
                $this->{$this->main_model}->save($entity);  
            }
        }
        $this->set([
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true); 
    }
	
}
