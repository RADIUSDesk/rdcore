<?php

namespace App\Controller;
use App\Controller\AppController;
use Cake\Core\Configure;
use Cake\Core\Configure\Engine\PhpConfig;
use Cake\Utility\Inflector;
use Cake\Mailer\Mailer;

class PermanentUsersController extends AppController{

    public $base            = "Access Providers/Controllers/PermanentUsers/";
    protected $main_model   = 'PermanentUsers';

    public function initialize():void{  
        parent::initialize();
        $this->loadModel('PermanentUsers'); 
        $this->loadModel('Users');
        $this->loadModel('Realms');
        $this->loadModel('Profiles');
        $this->loadModel('Radaccts'); 
        $this->loadModel('RealmVlans'); 
                      
        $this->loadComponent('Aa');
        $this->loadComponent('GridButtonsFlat');
        $this->loadComponent('CommonQueryFlat', [ //Very important to specify the Model
            'model'     => 'PermanentUsers',
            'sort_by'   => 'PermanentUsers.username'
        ]); 
        
        $this->loadComponent('JsonErrors'); 
        $this->loadComponent('TimeCalculations');
        $this->loadComponent('Formatter');
        $this->loadComponent('MailTransport');
        $this->loadComponent('RdLogger');
        $this->loadComponent('IspPlumbing');       
    }

    public function exportCsv(){

        $user = $this->_ap_right_check();
        if(!$user){
            return;
        }
        
        $req_q 		= $this->request->getQuery();
        $cloud_id 	= $req_q['cloud_id'];              
        $query 		= $this->{$this->main_model}->find();           
        $this->CommonQueryFlat->build_cloud_query($query,$cloud_id);    
        $q_r    	= $query->all();

        //Headings
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
                    if($column_name == 'cleartext_password'){
                        $cleartext_password = $this->{$this->main_model}->getCleartextPassword($i->username);
                        array_push($csv_line,$cleartext_password);
                    }else{
                        array_push($csv_line,$i->{$column_name});  
                    }
                }
                array_push($data,$csv_line);
            }
        }
         
        $this->setResponse($this->getResponse()->withDownload('PermanentUsers.csv'));
        $this->viewBuilder()->setClassName('CsvView.Csv');
        $this->set([
            'data' => $data
        ]);         
        $this->viewBuilder()->setOption('serialize', true);
                  
    } 

    public function index(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
        $right    = $this->Aa->rights_on_cloud();

      	$req_q    = $this->request->getQuery(); //q_data is the query data
        $cloud_id = $req_q['cloud_id'];
        $query 	  = $this->{$this->main_model}->find();      
        $this->CommonQueryFlat->build_cloud_query($query,$cloud_id,['Realms','RealmVlans']);
        
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

        //Get more detail on the activity
        $usernames = [0];
        foreach ($q_r as $user) {
            $usernames[] = $user->username;
        }

        $last_session_query = $this->{'Radaccts'}->find('all', [
            'fields' => [
                'username' => 'username',
                'last_acctstarttime' => 'max(acctstarttime)',
            ],
            'group' => 'username'
        ]);

        $last_session_query = $this->{'Radaccts'}->find()
            ->join([
                'last_session' => [
                    'table' => $last_session_query,
                    'type' => 'inner',
                    'conditions' => [
                        'last_session.username = Radaccts.username', 
                        'last_session.last_acctstarttime = Radaccts.acctstarttime'
                    ]
                ]
            ])
            ->where(['Radaccts.username IN' => $usernames])
            ->select([
                'username' => 'Radaccts.username', 
                'acctstarttime' => 'acctstarttime',
                'acctstoptime' => 'acctstoptime',
                'framedipaddress' => 'framedipaddress'
            ]);

        $last_session_list = $last_session_query->toList();
        $last_session_dict = array();
        foreach ($last_session_list as $row) {
            $last_session_dict[$row['username']] = $row;
        }

        foreach($q_r as $i){
        
            $row            = [];
            $fields         = $this->{$this->main_model}->getSchema()->columns();
            foreach($fields as $field){
                $row["$field"]= $i->{"$field"};   
                if($field == 'created'){
                    $row['created_in_words'] = $this->TimeCalculations->time_elapsed_string($i->{"$field"});
                }
                if($field == 'modified'){
                    $row['modified_in_words'] = $this->TimeCalculations->time_elapsed_string($i->{"$field"});
                }
                if($field == 'last_accept_time'){
                    if($i->{"$field"}){
                        $row['last_accept_time_in_words'] = $this->TimeCalculations->time_elapsed_string($i->{"$field"});
                    }else{
                        $row['last_accept_time_in_words'] = __("Never");
                    }
                } 
                if($field == 'last_reject_time'){
                    if($i->{"$field"}){
                        $row['last_reject_time_in_words'] = $this->TimeCalculations->time_elapsed_string($i->{"$field"});
                    }else{
                        $row['last_reject_time_in_words'] = __("Never");
                    }
                }    
            }
            
            //Unset password and token fields
            unset($row["password"]);
            unset($row["token"]);
            
            //Get more detail on the activity
            if (array_key_exists($i->username, $last_session_dict)) {
                $last_session = $last_session_dict[$i->username];
                if(!$last_session->acctstoptime){
                    $row['last_seen']['status'] = 'online';
                    $row['last_seen']['span']   = $this->TimeCalculations->time_elapsed_string($last_session->acctstarttime,false,true);                
                }else{
                    $row['last_seen']['status'] = 'offline';
                    $row['last_seen']['span']   = $this->TimeCalculations->time_elapsed_string($last_session->acctstoptime,false,true);
                }
                $row['framedipaddress'] = $last_session->framedipaddress;
            }else{
                $row['last_seen'] = ['status' => 'never'];
            }

            $actions_enabled = true;                       
            if($right == 'view'){  
                $actions_enabled = false;                  
            }             
            $row['update']	= $actions_enabled;
			$row['delete']  = $actions_enabled; 
			$row['extra']   = $actions_enabled; 
			                  						
			$row['vlan']    = 'Default VLAN';
			if($i->realm_vlan){
			    $row['vlan'] = $i->realm_vlan->vlan;
			}
			
            array_push($items,$row); 
                 
        }
             
        $this->set(array(
            'items'         => $items,
            'success'       => true,
            'totalCount'    => $total,
            'metaData'		=> [
            	'total'	=> $total
            ]
        ));
        $this->viewBuilder()->setOption('serialize', true);
    }
    
    public function add(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
    
    	$req_d		= $this->request->getData();
          
        //---Get the language and country---
        $country_language                   = Configure::read('language.default');
        if($this->request->getData('language')){
            $country_language    = $this->request->getData('language');
        }
        $country_language   = explode( '_', $country_language);
        $country            = $country_language[0];
        $language           = $country_language[1];
        $req_d['language_id'] = $language;
        $req_d['country_id']  = $country;
        
        //---Set Realm related things--- 
        $realm_entity           = $this->Realms->entityBasedOnPost($this->request->getData());
        if($realm_entity){
            $req_d['realm']   = $realm_entity->name;
            $req_d['realm_id']= $realm_entity->id;
            
            //Test to see if we need to auto-add a suffix
            $suffix                 =  $realm_entity->suffix; 
            $suffix_permanent_users = $realm_entity->suffix_permanent_users;
            
            //Auto populate the email field if it looks like the username is an email address
            if ((filter_var($req_d['username'], FILTER_VALIDATE_EMAIL))&&($req_d['email']== '')) {
                $req_d['email'] = $req_d['username'];
            }
                        
            if(($suffix != '')&&($suffix_permanent_users)){
                $req_d['username'] = $req_d['username'].'@'.$suffix;
            }
        
        }else{
            $this->JsonErrors->errorMessage('realm or realm_id not found in DB or not supplied');
            return;
        }
        
        //---Set profile related things---
        $profile_entity = $this->Profiles->entityBasedOnPost($this->request->getData());
        if($profile_entity){
            $req_d['profile']   = $profile_entity->name;
            $req_d['profile_id']= $profile_entity->id;
        }else{
            $this->JsonErrors->errorMessage('profile or profile_id not found in DB or not supplied');
            return;
        }
        
        //Zero the token to generate a new one for this user:
        $req_d['token'] = '';

        //Set the date and time
        $extDateSelects = [
                'from_date',
                'to_date'
        ];
        foreach($extDateSelects as $d){
            if(isset($req_d[$d])){
                $newDate = date_create_from_format('m/d/Y', $req_d[$d]);
                $req_d[$d] = $newDate;
            }  
        }
        
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
        
        //The rest of the attributes should be same as the form..
        $entity = $this->{$this->main_model}->newEntity($req_d);
         
        if($this->{$this->main_model}->save($entity)){
            $reply_data         = $req_d;
            $reply_data['id']   = $entity->id;
            $this->set(array(
                'success' => true,
                'data'    => $reply_data
            ));
            $this->viewBuilder()->setOption('serialize', true);
        }else{
        	$additional = [];
        	if($entity->getInvalidField('username')){
        		$additional['invalid_username'] = $entity->getInvalidField('username');
        	}
        	        
            $message = __('Could not create item');
            $this->JsonErrors->entityErros($entity,$message,$additional);
        }      
    }
    
    public function import(){
    
        $user = $this->_ap_right_check();
        if(!$user){
            return;
        }
        
        $c_l        = Configure::read('language.default');
        $c_l        = explode( '_', $c_l);
        $country    = $c_l[0];
        $language   = $c_l[1];
        $cloud_id   = $this->request->getData('cloud_id');                
        $tmpName    = $_FILES['csv_file']['tmp_name'];
        $csvAsArray = array_map('str_getcsv', file($tmpName)); 
        $user_list  = [];
        
               
        foreach ($csvAsArray as $index => $row) { 
            if(($index == 0)&&($row[0] == 'username')){ //Skip the first line if start with username
                continue; 
            }
            $row_data =  $this->_testCsvRow($row);       
            if($row_data){    
                //Add user
                $row_data['cloud_id']    = $cloud_id;
                $row_data['language_id'] = $language;
                $row_data['country_id']  = $country; 
                $row_data['active']      = 1;                
                //print_r($row_data);
                $entity = $this->{'PermanentUsers'}->newEntity($row_data);
                if($this->{'PermanentUsers'}->save($entity)){ //after the fact
                    if($row_data['auto_mac'] === true){
                        $this->{'PermanentUsers'}->setAutoMac($entity->username,true);
                    }
                }                  
            }        
        }
          
        $this->set([
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);      
    }
    
    private function _testCsvRow($row){
         
        $row_data   = [];
        $username   = $row[0];
        $password   = $row[1];
        $realm      = $row[2];
        $profile    = $row[3];
        
        $row_data['name']     = $row[4];
        $row_data['surname']  = $row[5]; 
              
        $static_ip  = $row[6];
        
        $row_data['site']   = $row[7];
         
        $ppsk       = $row[8];
        $vlan       = $row[9];
        $auto_mac   = $row[10];
         
               
        if (!isset($username) || strlen($username) < 2) {
            return false;
        }
        
        if (!isset($password) || strlen($password) < 4) {
            return false;
        }
        
        $row_data['username']    = $username;
        $row_data['password']    = $password;
                            
        if (($realm !== null)&&(strlen($realm) >= 1)) {
            $r_data['realm']        = $realm;
            $realm_entity           = $this->Realms->entityBasedOnPost($r_data);
            if($realm_entity){
                $row_data['realm']   = $realm_entity->name;
                $row_data['realm_id']= $realm_entity->id;
                
                //Test to see if we need to auto-add a suffix
                $suffix                 =  $realm_entity->suffix; 
                $suffix_permanent_users = $realm_entity->suffix_permanent_users;
                
                //Auto populate the email field if it looks like the username is an email address
                if (filter_var($row_data['username'], FILTER_VALIDATE_EMAIL)) {
                    $row_data['email'] = $row_data['username'];
                }
                            
                if(($suffix != '')&&($suffix_permanent_users)){
                    $row_data['username'] = $row_data['username'].'@'.$suffix;
                }
            }else{
                return false;
            }       
        }  
        
        if (($profile !== null)&&(strlen($profile) >= 1)) {
            $p_data['profile']  = $profile;
            $profile_entity     = $this->Profiles->entityBasedOnPost($p_data);
            if($profile_entity){
                $row_data['profile']   = $profile_entity->name;
                $row_data['profile_id']= $profile_entity->id;
            }else{
                return false;
            }       
        }
        
        if(isset($static_ip) && strlen($static_ip) >= 1){
            if (!filter_var($static_ip, FILTER_VALIDATE_IP)) {
                return false;
            }else{
                $row_data['static_ip']  = $static_ip;
            }
        }
        
        if(isset($ppsk) && strlen($ppsk) >= 8){
            $row_data['ppsk']  = $ppsk;    
        }
        
        //--Special keyword--
        if(isset($vlan) && $vlan == 'next_available'){
            $r_vlans = $this->{'RealmVlans'}->find()
                        ->where(['RealmVlans.realm_id' =>$row_data['realm_id']])
                        ->contain(['PermanentUsers'])
                        ->order(['vlan' => 'ASC'])
                        ->all();
            if($r_vlans){
                $found_one = false;         
                foreach($r_vlans as $v){
                    if ($v->permanent_users === []) { //Give it the next in line
                        $row_data['realm_vlan_id']  = $v->id;
                        $found_one = true;
                        break;
                    }                 
                }
                if(!$found_one){
                    return false; //skip it if we could not find a VLAN
                }                     
            }else{
                return false;
            }                 
        }
        
        //--Normal VLAN--
        if(isset($vlan) && is_numeric($vlan)){
            $r_vlan = $this->{'RealmVlans'}->find()
                        ->where(['RealmVlans.realm_id' =>$row_data['realm_id'], 'RealmVlans.vlan' => $vlan])
                        ->first();
            if($r_vlan){     
              $row_data['realm_vlan_id']  = $r_vlan->id;             
            }else{
                return false;
            }                 
        }
        
        //Auto MAC
        $row_data['auto_mac']  = false;
        if(isset($auto_mac) && ($auto_mac === 'true')){
            $row_data['auto_mac']  = true;
        }       
             
        //It made it to the end              
        return $row_data;   
    }
    
    public function delete() {
    
    	$user = $this->_ap_right_check();
        if(!$user){
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

    public function viewBasicInfo(){
    	
  		$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
       
        $entity     = $this->{$this->main_model}->get( $this->request->getQuery('user_id'));
        $username   = $entity->username;
        $items      = [];
        
        $fields         = $this->{$this->main_model}->getSchema()->columns();
        
        foreach($fields as $i){
            if($entity->{$i} !== null){
                $items[$i] = $entity->{$i};
            }
        }
        
        $items['created']   = $this->TimeCalculations->time_elapsed_string($entity->created,false,false);    
        if($entity->last_reject_time){
            $items['last_reject_time']  = $this->TimeCalculations->time_elapsed_string($entity->last_reject_time,false,false);
        }
        
        if($entity->last_accept_time){
            $items['last_accept_time']  = $this->TimeCalculations->time_elapsed_string($entity->last_accept_time,false,false);
        }
        
        if($entity->data_cap){
            $items['data_cap'] = $this->Formatter->formatted_bytes($items['data_cap']);
        }
        
        if($entity->data_used){
            $items['data_used'] = $this->Formatter->formatted_bytes($items['data_used']);
        }
             
        if($entity->time_cap){
            $items['time_cap'] = $this->Formatter->formatted_seconds($items['time_cap']);
        }
        
        if($entity->time_used){
            $items['time_used'] = $this->Formatter->formatted_seconds($items['time_used']);
        }
        
        unset($items['password']);
        unset($items['token']);

        if(($entity->from_date)&&($entity->to_date)){
            $items['always_active'] = false;
            $items['from_date']    = $items['from_date']->format("m/d/Y");
            $items['to_date']      = $items['to_date']->format("m/d/Y");
        }else{
            $items['always_active'] = true;
        }

        $this->set([
            'data'   => $items, //For the form to load we use data instead of the standard items as for grids
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }

    public function editBasicInfo(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        } 
       
        //---Set Realm related things--- 
        $req_d		= $this->request->getData();
        
        $realm_entity           = $this->Realms->entityBasedOnPost($req_d);
        if($realm_entity){
            $req_d['realm']   = $realm_entity->name;
            $req_d['realm_id']= $realm_entity->id;
            //FIXME WE HAVE TO CHECK AND CHANGE USERNAME IF CHANGE ...
        
        }else{
            $message = __('realm or realm_id not found in DB or not supplied');
            $this->JsonErrors->errorMessage($message);
            return;
        }
        
        //---Set profile related things---
        $profile_entity = $this->Profiles->entityBasedOnPost($req_d);
        if($profile_entity){
            $req_d['profile']   = $profile_entity->name;
            $req_d['profile_id']= $profile_entity->id;
        }else{
            $message = __('profile or profile_id not found in DB or not supplied');
            $this->JsonErrors->errorMessage($message);
            return;
        }
        
        //Zero the token to generate a new one for this user:
        unset($req_d['token']);
        
        
        $check_items = [
			'always_active'
		];

        foreach($check_items as $i){
            if(isset($req_d[$i])){
            	if($req_d[$i] == null){
            		$req_d[$i] = 0;
            	}else{
                	$req_d[$i] = 1;
                }
            }else{
                $req_d[$i] = 0;
            }
        }
        
        //If it is expiring; set it in the correct format
        if($req_d['always_active'] == 0){
            //Set the date and time
		    $extDateSelects = [
		            'from_date',
		            'to_date'
		    ];
		    foreach($extDateSelects as $d){
		        if(isset($req_d[$d])){
		            $newDate = date_create_from_format('m/d/Y', $req_d[$d]);
		            $req_d[$d] = $newDate;
		        }  
		    }
        }else{
        	$req_d['from_date'] = null;
        	$req_d['to_date'] = null;    
        }   
        
        $entity = $this->{$this->main_model}->get($req_d['id']);
        $this->{$this->main_model}->patchEntity($entity, $req_d);
     
        if ($this->{$this->main_model}->save($entity)) {
        
        	$this->IspPlumbing->disconnectIfActive($entity);
        	
            $this->set([
                'success' => true
            ]);
            $this->viewBuilder()->setOption('serialize', true);
        } else {
            $message = __('Could not update item');
            $this->JsonErrors->entityErros($entity,$message);
        }
    }

    public function viewPersonalInfo(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
       
       	$req_q      = $this->request->getQuery(); //q_data is the query data
     	$items      = [];
        //TODO Check if the owner of this user is in the chain of the APs
        if(isset($req_q['user_id'])){
            $entity         = $this->{$this->main_model}->get($req_q['user_id']);
            $include_items  = ['name','surname','phone','address', 'email','language_id','country_id','id'];
            foreach($include_items as $i){
                $items[$i] = $entity->{$i};
            }
            $items['language'] = $items['country_id'].'_'.$items['language_id'];
        }
        $this->set(array(
            'data'   => $items, //For the form to load we use data instead of the standard items as for grids
            'success' => true
        ));
        $this->viewBuilder()->setOption('serialize', true);
    }

    public function editPersonalInfo(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
       
        //TODO Check if the owner of this user is in the chain of the APs
        $req_d		= $this->request->getData();
        unset($req_d['token']);
        //Get the language and country
        $country_language   = explode( '_', $req_d['language'] );
        $country            = $country_language[0];
        $language           = $country_language[1];

        $req_d['language_id'] = $language;
        $req_d['country_id']  = $country;

        $entity = $this->{$this->main_model}->get($req_d['id']);
        $this->{$this->main_model}->patchEntity($entity, $req_d);
     
        if ($this->{$this->main_model}->save($entity)) {
            $this->set(array(
                'success' => true
            ));
            $this->viewBuilder()->setOption('serialize', true);
        } else {
            $message = __('Could not update item');
            $this->JsonErrors->entityErros($entity,$message);
        }
    }

    public function privateAttrIndex(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
        
        $username   = $this->request->getQuery('username');
        $items      =  $this->{$this->main_model}->privateAttrIndex($username);

        $this->set(array(
            'items'         => $items,
            'success'       => true
        ));
        $this->viewBuilder()->setOption('serialize', true);
    }

    public function privateAttrAdd(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
       
        $req_d  = $this->request->getData();
        $entity =  $this->{$this->main_model}->privateAttrAdd($this->request);
        $errors = $entity->getErrors();
        if($errors){
            $message = __('Could not create item');
            $this->JsonErrors->entityErros($entity,$message);
        }else{        
            $req_d['id'] = $entity->id;
            $this->set(array(
                'items'     => $req_d,
                'success'   => true
            ));
            $this->viewBuilder()->setOption('serialize', true);
        }
    }

    public function privateAttrEdit(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
        
        $entity =  $this->{$this->main_model}->privateAttrEdit($this->request);
        $req_d  = $this->request->getData(); 
        
        //== START NEW FEATURE ==
        //===Check if we need to zero the accounting when adjusting Rd-Total-Time or Rd-Total-Data (New feature Nov 2022)
        //== if you also post 'accounting_zero' then we will clear the accounting records 
        if(($req_d['attribute'] == 'Rd-Total-Time')||($req_d['attribute'] == 'Rd-Total-Data')){
        	//if(true){
        	if(isset($req_d['accounting_zero'])){
        		$req_q    	= $this->request->getQuery();
        		if(isset($req_q['username'])){
        				$e_pu = $this->{'PermanentUsers'}->find()->where(['PermanentUsers.username' => $req_q['username']])->first();
        				if($e_pu){
							$username 	= $e_pu->username;
							$realm		= $e_pu->realm;
							$this->{'Radaccts'}->deleteAll(['Radaccts.username' => $username,'Radaccts.realm' => $realm]);
						}
        		}
        	}
		}
        //== END NEW FEATURE ==        
   
        $errors = $entity->getErrors();
        if($errors){
            $message = __('Could not edit item');
            $this->JsonErrors->entityErros($entity,$message);
        }else{        
            $req_d['id'] = $entity->id;
            $this->set(array(
                'items'     => $req_d,
                'success'   => true
            ));
            $this->viewBuilder()->setOption('serialize', true);
        }
    }

    public function privateAttrDelete(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
    
        if($this->{$this->main_model}->privateAttrDelete($this->request)){
            $message = __('Could not delete some items');
            $this->JsonErrors->errorMessage($message);  
        }else{
            $this->set(array(
                'success'   => true
            ));
            $this->viewBuilder()->setOption('serialize', true);
        }
    }

    public function restrictListOfDevices(){
        $user = $this->_ap_right_check();
        if(!$user){
            return;
        }

        $user_id  = $user['id'];
        $req_q    = $this->request->getQuery();

        if((isset($req_q['username']))&&(isset($req_q['restrict']))){
            $username = $req_q['username'];
            if($req_q['restrict'] == 'true'){
                $this->{$this->main_model}->setRestrictListOfDevices($username,true);      
            }else{
                $this->{$this->main_model}->setRestrictListOfDevices($username,false);
            }
        }
        $this->set(array(
            'success' => true
        ));
        $this->viewBuilder()->setOption('serialize', true);
    }

    public function autoMacOnOff(){
        $user = $this->_ap_right_check();
        if(!$user){
            return;
        }
        $user_id    = $user['id'];
        $req_q    = $this->request->getQuery();

        if((isset($req_q['username']))&&(isset($req_q['auto_mac']))){
            $username = $req_q['username'];
            if($req_q['auto_mac'] == 'true'){
                $this->{$this->main_model}->setAutoMac($username,true);     
            }else{
                $this->{$this->main_model}->setAutoMac($username,false);
            }
        }

        $this->set(array(
            'success' => true
        ));
        $this->viewBuilder()->setOption('serialize', true);
    }
    
    public function enableDisable(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
        
        $req_d      = $this->request->getData(); 
        $rb         = $req_d['rb'];
        $d          = [];

        if($rb == 'enable'){
            $d['active'] = 1;
        }else{
            $d['active'] = 0;
        }
        
        if(isset($req_d['id'])){
        	$entity = $this->{$this->main_model}->get($req_d['id']);
           	$this->{$this->main_model}->patchEntity($entity, $d);
            $this->{$this->main_model}->save($entity);       
        }

        foreach(array_keys($req_d) as $key){
            if(preg_match('/^\d+/',$key)){
                $entity = $this->{$this->main_model}->get($key);
                $this->{$this->main_model}->patchEntity($entity, $d);
                $this->{$this->main_model}->save($entity);             
                $this->IspPlumbing->disconnectIfActive($entity);             
            }
        }
        
        $this->set([
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }

    public function viewPassword(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }

        $success    = false;
        $value      = false;
        $activate   = false;
        $expire     = false;

		$req_q      = $this->request->getQuery();

        if(isset($req_q['user_id'])){

            $q_r = $this->{$this->main_model}->get($req_q['user_id']);
            if($q_r){
               if($q_r->from_date ){
                 $activate = $q_r->from_date->format("m/d/Y");   
               }
               if($q_r->to_date ){
                 $expire = $q_r->to_date->format("m/d/Y");   
               }
            }
            $pw = $this->{$this->main_model}->getCleartextPassword($q_r->username);

            if($pw){
                $value = $pw;
            }

            $success = true;
        }
        $this->set(array(
            'success'   => $success,
            'value'     => $value,
            'activate'  => $activate,
            'expire'    => $expire
        ));
        $this->viewBuilder()->setOption('serialize', true);

    }

    public function changePassword(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }

		$req_d      = $this->request->getData();
        unset($req_d['token']);

        //Set the date and time
        $extDateSelects = [
                'from_date',
                'to_date'
        ];
        foreach($extDateSelects as $d){
            if(isset($req_d[$d])){
                $newDate = date_create_from_format('m/d/Y', $req_d[$d]);
                $req_d[$d] = $newDate;
            }  
        }

        $entity = $this->{$this->main_model}->get($req_d['user_id']);
        unset($req_d['user_id']);

        $this->{$this->main_model}->patchEntity($entity, $req_d);

        if ($this->{$this->main_model}->save($entity)) {
            $this->set(array(
                'success' => true
            ));
            $this->viewBuilder()->setOption('serialize', true);
        } else {
            $message = __('Could not change password');
            $this->JsonErrors->entityErros($entity,$message);
        }           
    }
    
     public function emailUserDetails(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }

        $data   = $this->request->getData();
        $to     = $data['email'];
        $message= $data['message']; 
        
        $query  = $this->{$this->main_model}->find()->contain(['Radchecks']);
        $entity = $query->where(['PermanentUsers.id' => $data['id']])->first();   
        
        if($entity){
        
            $password = false;       
            foreach($entity->radchecks as $rc){
                if($rc->attribute == 'Cleartext-Password'){
                    $password = $rc->value;
                    break;
                }
            }
            
            $username       = $entity->username;
            $profile        = $entity->profile;
            $extra_name     = $entity->extra_name;
            $extra_value    = $entity->extra_value;
            
            $meta_data      = $this->MailTransport->setTransport($data['cloud_id']);           
            $success        = false;
                      
            if($meta_data !== false){         
                $email 	= new Mailer(['transport'   => 'mail_rd']);
                $from   = $meta_data['from'];
                $email->setSubject('User credentials')
                    ->setFrom($from)
                    ->setTo($to)
                    ->setViewVars(compact( 'username', 'password','profile','extra_name','extra_value','message'))
                    ->setEmailFormat('html')
                    ->viewBuilder()
                    	->setTemplate('user_detail_admin')
                		->setLayout('user_notify');                   

                $email->deliver();
               
                $settings_cloud_id = $this->MailTransport->getCloudId();
            	$this->RdLogger->addEmailHistory($settings_cloud_id,$to,'user_detail',"$username $password $message");
               
                $success    = true;
                $this->set([
                    'data'          => $data,
                    'success'       => $success
                ]);
                $this->viewBuilder()->setOption('serialize', true);  
            }else{                     
                $this->set([
                    'data'          => $data,
                    'success'       => $success,
                    'message'       => 'Email Disabled / Not Configured',
                ]);
                $this->viewBuilder()->setOption('serialize', true); 
            }            
        }       
    }
   
    public function menuForGrid(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
        $right = $this->Aa->rights_on_cloud();
             
        $menu = $this->GridButtonsFlat->returnButtons(false,'permanent_users',$right);
        $this->set(array(
            'items'         => $menu,
            'success'       => true
        ));
        $this->viewBuilder()->setOption('serialize', true);
    }

    function menuForUserDevices(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
    
        $settings = ['listed_only' => false,'add_mac' => false];
        
        $req_q    = $this->request->getQuery();

        if(isset($req_q['username'])){
            $username = $req_q['username'];
            $settings = $this->{$this->main_model}->deviceMenuSettings($username,true);     
        }

        //Empty by default
        $menu = array(
                array('xtype' => 'buttongroup','title' => false, 'items' => array(
                    array( 'xtype'=>  'button', 'glyph'   => Configure::read('icnReload'), 'scale' => 'large', 'itemId' => 'reload',   'tooltip'   => __('Reload'),'ui' => 'button-orange'),
                    array( 
                        'xtype'         => 'checkbox', 
                        'boxLabel'      => 'Connect only from listed devices', 
                        'itemId'        => 'chkListedOnly',
                        'checked'       => $settings['listed_only'], 
                        'cls'           => 'lblRd',
                        'margin'        => 0
                    ),
                    array( 
                        'xtype'         => 'checkbox', 
                        'boxLabel'      => 'Auto-add device after authentication', 
                        'itemId'        => 'chkAutoAddMac',
                        'checked'       => $settings['add_mac'], 
                        'cls'           => 'lblRd',
                        'margin'        => 0
                    )
            )) 
        );

        $this->set(array(
            'items'         => $menu,
            'success'       => true
        ));
        $this->viewBuilder()->setOption('serialize', true);
    }

    function menuForAccountingData(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }

        $menu = $this->GridButtonsFlat->returnButtons(false,'fr_acct_and_auth');
        $this->set(array(
            'items'         => $menu,
            'success'       => true
        ));
        $this->viewBuilder()->setOption('serialize', true);
    }

    function menuForAuthenticationData(){
    
    	$user = $this->_ap_right_check();
        if(!$user){
            return;
        }
      
        $menu = $this->GridButtonsFlat->returnButtons(true,'fr_acct_and_auth');
        $this->set(array(
            'items'         => $menu,
            'success'       => true
        ));
        $this->viewBuilder()->setOption('serialize', true);
    }
}

?>
