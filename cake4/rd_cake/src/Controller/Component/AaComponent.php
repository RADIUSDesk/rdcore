<?php
//----------------------------------------------------------
//---- Author: Dirk van der Walt
//---- License: GPL v3
//---- Description: A component used to determine Authentication and Authorization of a request
//---- Date: 26-AUG-2022
//------------------------------------------------------------

namespace App\Controller\Component;
use Cake\Controller\Component;
use Cake\Core\Configure;
use Cake\Core\Configure\Engine\PhpConfig;
use Cake\ORM\TableRegistry;


class AaComponent extends Component {


    //-- Jun 2024 -- view or admin permissions for cloud
    public function rights_on_cloud(){
        //Rights on a cloud can be admin or view or false
        return $this->_rights_on_cloud();    
    }

	public function user_for_token_with_cloud(){
        return $this->_check_if_valid(true);
    }
  
    public function user_for_token(){
        return $this->_check_if_valid(false);
    }

    public function fail_no_rights($message=false){
        $this->_fail_no_rights($message);
    }

    public function admin_check($controller,$hard_fail=true){

        //Check if the supplied token belongs to a user that is part of the Configure::read('group.admin') group
        //-- Authenticate check --
        $token_check = $this->_check_if_valid(false);
        if(!$token_check){
            return false;
        }else{

            if($token_check['group_name'] == Configure::read('group.admin')){ 
                return true;
            }else{
                if($hard_fail){
                    $this->_fail_no_rights();
                }
                return false;
            }
        }
    }

    public function ap_check($controller,$hard_fail=true){
        //-- Authenticate check --
        $token_check = $this->_check_if_valid($controller);
        if(!$token_check){
            return false;
        }else{

            if($token_check['group_name'] == Configure::read('group.ap')){ 
                return true;
            }else{
                if($hard_fail){
                    $this->_fail_no_rights();
                }
                return false;
            }
        }
    }
    
    public function realmCheck($returnNames = false){
    
        $controller = $this->getController();
        $request    = $controller->getRequest();   
        $token      = $request->getData('token') ?? $request->getQuery('token');
        $result     = $this->_find_token_owner($token);
        $user_id    = $result['user']['id'];
        $cloud_id   = $request->getData('cloud_id') ?? $request->getQuery('cloud_id');
        $realmsTable= TableRegistry::get('Realms');
        $realmAdmins= TableRegistry::get('RealmAdmins');
        $realm_list = [];
        
        $realms     = $realmsTable->find()->where(['Realms.cloud_id' => $cloud_id])->all();
        foreach($realms as $realm){
            $realmAdmin = $realmAdmins->find()->where(['RealmAdmins.realm_id' => $realm->id, 'RealmAdmins.user_id' => $user_id])->count();
            if($realmAdmin > 0){
                if($returnNames){
                    $realm_list[] = $realm->name;
                }else{
                    $realm_list[] = $realm->id;
                }
            }
        }
        
        if(count($realm_list) > 0){
            return $realm_list;
        }        
        return false;   
    }
    
    //-------------
    
    private function _rights_on_cloud(){
    
        $controller = $this->getController();
        $request = $controller->getRequest();
        $token = $request->getData('token') ?? $request->getQuery('token');
        if (!$token || strlen($token) != 36) {
            return false;
        }
        $result = $this->_find_token_owner($token);
        if (!$result['success']) {
            return false;
        }
        $user = $result['user'];
        $cloud_id = $request->getData('cloud_id') ?? $request->getQuery('cloud_id');
        if (!$cloud_id) {
            return false;
        }
        switch ($user['group_name']) {
            case Configure::read('group.admin'):
                return 'admin';
            case Configure::read('group.ap'):
                $clouds = TableRegistry::get('Clouds');
                $is_owner = $clouds->find()->where(['Clouds.id' => $cloud_id, 'Clouds.user_id' => $user['id']])->first();
                if ($is_owner) {
                    return 'admin';
                }
                $cloud_admins = TableRegistry::get('CloudAdmins');
                $c_a = $cloud_admins->find()->where(['CloudAdmins.user_id' => $user['id'], 'CloudAdmins.cloud_id' => $cloud_id])->first();
                if ($c_a) {
                    return $c_a->permissions;
                }
                return false;
            default:
                return false;
        }
        
    }   
       
    private function _check_if_valid($with_cloud=true){
        //First we will ensure there is a token in the request
        $controller = $this->getController();
        $request 	= $controller->getRequest();
        $r_data		= $request->getData();
        $q_data		= $request->getQuery();    
        $token 		= false;
        $cloud_id	= false;

		//==IS TOKEN PRESENT AND VALID==
        if(isset($r_data['token'])){
            $token = $r_data['token'];
        }elseif(isset($q_data['token'])){ 
            $token = $q_data['token'];
        }       
        
        if($token != false){
            if(strlen($token) != 36){
                $result = ['success' => false, 'message' => __('Token in wrong format')];
            }else{
                //Find the owner of the token
                $result = $this->_find_token_owner($token);
            }
        }else{
            $result = ['success' => false, 'message' => __('Token missing')];
        }
        //==END IS TOKEN PRESENT AND VALID==
        
        if($with_cloud == true){
		    //==IS cloud_id PRESENT AND VALID==
		    if(isset($r_data['cloud_id'])){
		        $cloud_id = $r_data['cloud_id'];
		    }elseif(isset($q_data['cloud_id'])){ 
		        $cloud_id = $q_data['cloud_id'];
		    }
		    
		    //-----!!!---
		    if(isset($q_data['settings_cloud_id'])){ //Override for settings Window
		   		$cloud_id  = $q_data['settings_cloud_id'];
		   	}
		   	//----!!!----
		          
		    if($cloud_id == false){
		    	$result = ['success' => false, 'message' => __('Cloud ID Missing')];
		    }
		    		    
		    //==END IS cloud_id PRESENT AND VALID==
		}
        
        //If it failed - set the controller up
        if($result['success'] == false){
        	$controller = $this->getController();
        	$controller->set([
                'success'   => $result['success'],
                'message'   => $result['message']
            ]);
			$controller->viewBuilder()->setOption('serialize', true);
            return false;
        }else{
        	if($result['user']['group_name'] == Configure::read('group.admin')){         	
            	return $result['user']; //Admin does not have any problems :-)
           	}elseif($result['user']['group_name'] == Configure::read('group.ap')){
           		if($with_cloud == true){
		       		$user_id = $result['user']['id'];
		       		if($this->_can_manage_cloud($user_id,$cloud_id)){
		       			return $result['user']; //User are allowed on Cloud
		       		}else{
		       			$this->fail_no_rights();
		       			return false;
		       		}
		      	}else{
		      		return $result['user']; //No need to check the cloud_id
		      	}
           	}else{
           		$this->fail_no_rights();
           		return false;
           	}
        }   
    }
      
    private function _can_manage_cloud($user_id,$cloud_id){
    
    	$clouds			= TableRegistry::get('Clouds');
    	
    	$is_owner		= $clouds->find()->where(['Clouds.id' => $cloud_id, 'Clouds.user_id' => $user_id])->first();
    	if($is_owner){
    		return true;
    	}
    	  
    	$cloud_admins  	= TableRegistry::get('CloudAdmins');
    	$count = $cloud_admins->find()->where(['CloudAdmins.user_id' => $user_id,'CloudAdmins.cloud_id' => $cloud_id])->count();
    	if($count > 0){
    		return true;
    	}
    	return false;
    }
    
    private function _find_token_owner($token){
    
        $users  = TableRegistry::get('Users');
        $user   = $users->find()->contain(['Groups'])->where(['Users.token' => $token])->first();

        if(!$user){
            return ['success' => false, 'message' =>  __('No user for token')];
        }else{

            //Check if account is active or not:
            if($user->active==0){
                return ['success' => false, 'message' =>  __('Account disabled')];
            }else{
                $user = [
                    'id'            => $user->id,
                    'group_name'    => $user->group->name,
                    'group_id'      => $user->group->id
                ];  
                return ['success' => true, 'user' => $user];
            }
        }
    }
    
    private function _fail_no_rights($message = ''){
        if(empty($message)){
            $message = __('You do not have rights for this action');
        }
        $controller = $this->getController();       
    	$controller->set([
        	'success'       => false,
        	'message'       => $message
        ]);
		$controller->viewBuilder()->setOption('serialize', true);
    }
    
}
