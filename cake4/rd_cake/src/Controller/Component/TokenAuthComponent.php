<?php
//----------------------------------------------------------
//---- Author: Dirk van der Walt
//---- License: GPL v3
//---- Description: A component that is intended to be called by the Aa component to determine the owner of the token
//---- should be passed along with the request. If the token is not valid, an error will be reported through the controller.
//---- this component is suppose to work hand-in-hand with the TokenAcl and Aa component which will determine the rights of the user
//---- Date: 27-JUL-2022
//------------------------------------------------------------

namespace App\Controller\Component;
use Cake\Controller\Component;

use Cake\ORM\TableRegistry;

class TokenAuthComponent extends Component {
  
    public function check_if_valid($controller){
        //First we will ensure there is a token in the request
        $controller = $this->_registry->getController();
        $request 	= $controller->getRequest();
        $r_data		= $request->getData();
        $q_data		= $request->getQuery();
        
        $token = false;

        if(isset($r_data['token'])){
            $token = $r_data['token'];
        }elseif(isset($q_data['token'])){ 
            $token = $q_data['token'];
        }
        
        
        if($token != false){
            if(strlen($token) != 36){
                $result = array('success' => false, 'message' => array('message'    => __('Token in wrong format')));
            }else{
                //Find the owner of the token
                $result = $this->find_token_owner($token);
            }
        }else{
            $result = array('success' => false, 'message' => array('message'        => __('Token missing')));
        }

        //If it failed - set the controller up
        if($result['success'] == false){
            $controller->set(array(
                'success'   => $result['success'],
                'message'   => $result['message'],
                '_serialize' => array('success', 'message')
            ));
            return false;
        }else{
            return $result['user']; //Return the user detail
        }   
    }

    protected function find_token_owner($token){
    
        $users  = TableRegistry::get('Users');
        $user   = $users->find()->contain(['Groups'])->where(['Users.token' => $token])->first();

        if(!$user){
            return array('success' => false, 'message' => array('message' => __('No user for token')));
        }else{

            //Check if account is active or not:
            if($user->active==0){
                return array('success' => false, 'message' => array('message' => __('Account disabled')));
            }else{
                $user = array(
                    'id'            => $user->id,
                    'group_name'    => $user->group->name,
                    'group_id'      => $user->group->id,
                    'monitor'       => $user->monitor,
                );  
                return array('success' => true, 'user' => $user);
            }
        }
    }
    
}