<?php
//----------------------------------------------------------
//---- Author: Dirk van der Walt
//---- License: GPL v3
//---- Description: 
//---- Date: 29-05-2013
//------------------------------------------------------------

namespace App\Controller\Component;

use Cake\Controller\Component;
use Cake\Core\Configure;
use Cake\ORM\TableRegistry;
use Cake\Http\Client;


class KickerComponent extends Component {

    protected $radclient;
    //protected $pod_command = '/etc/MESHdesk/pod.lua';
    protected $pod_command 	= 'chilli_query logout mac';
    protected $podMdHostapd = '/etc/MESHdesk/utils/hostapd_disconnect.lua';
    
    //--NAS TYPES--
    protected   $typeAccel      = 'AccelRadiusdesk';
    protected	$typeCoovaMd 	= 'CoovaMeshdesk';
    protected	$typeHostaMd 	= 'private_psk';
    protected   $typeJuniper    = 'Juniper';
    protected	$typeMtApi 	    = 'Mikrotik-API';


    
    protected	$node_action_add = 'http://127.0.0.1/cake4/rd_cake/node-actions/add.json';
    protected	$ap_action_add = 'http://127.0.0.1/cake4/rd_cake/ap-actions/add.json';
    
   	protected $components = ['MikrotikApi'];
    
    public function initialize(array $config):void{
        //Please Note that we assume the Controller has a JsonErrors Component Included which we can access.
        $this->DynamicClients           = TableRegistry::get('DynamicClients');
        $this->DynamicClientSettings    = TableRegistry::get('DynamicClientSettings');
        $this->Nas           			= TableRegistry::get('Nas');
        $this->NaSettings               = TableRegistry::get('NaSettings');
        $this->MeshExitCaptivePortals   = TableRegistry::get('MeshExitCaptivePortals'); 
        $this->MeshExits                = TableRegistry::get('MeshExits'); 
        $this->Nodes                    = TableRegistry::get('Nodes');
        $this->NodeActions              = TableRegistry::get('NodeActions');
        
        //Accel
        $this->AccelServers             = TableRegistry::get('AccelServers');
        $this->AccelSessions            = TableRegistry::get('AccelSessions');
         
    }

    public function kick($ent,$token){
        //---Location of radclient----
        $nasidentifier  = $ent->nasidentifier;
        $radacctid      = $ent->radacctid;
                
     	//First we try to locate the client under dynamic_clients
     	$dc = $this->DynamicClients->find()
     		->where(['DynamicClients.nasidentifier' => $nasidentifier])
     		->contain(['DynamicClientSettings'])
     		->first();
     		
     	if($dc){
     	   	    
     	    if($dc->type == $this->typeAccel){ //It is type AccelRadiusdesk -> try to locate the session and set the disconnect flag of the session
     	        $this->kickAccelSession($ent);
     	    }
     	
     	    //--------------------
     		if($dc->type == $this->typeCoovaMd){ //It is type CoovaMeshdesk => Now try and locate AP to send command to 
     		
     			//We have a convention of nasidentifier for meshdesk => mcp_<captive_portal_id> and apdesk => ap_<ap id>_cp_<captive_portal_id>
     			if(preg_match('/^mcp_/' ,$nasidentifier)){ //MESHdesk     		
     				$this->kickMeshNodeUser($ent,$dc->cloud_id,$token);
     			}
     			
     			if(preg_match('/^ap_/' ,$nasidentifier)){ //APdesk		
     				$this->kickApUser($ent,$dc->cloud_id,$token); 			
     			}
     			sleep(1); //Give MQTT time to do its thing....  			
     		}
     		
     		//-------------------
     		if($dc->type = $this->typeHostaMd){
     		
     		    //MESHdesk / AP Profile **(m/a)** _ **id** _ **entry_id** _ **radio_number** _ **node id / ap id** 
     		    $o = $ent->operator_name;
     		
     			if(preg_match('/^m_hosta_/' ,$o)){ //MESHdesk     		
     				$this->kickMeshHostaMac($ent,$dc->cloud_id,$token);
     			}
     			
     			if(preg_match('/^a_hosta_/' ,$o)){ //APdesk		
     				$this->kickApHostaMac($ent,$dc->cloud_id,$token); 			
     			}
     			sleep(1); //Give MQTT time to do its thing....    		
     		}
     	
     		
     		if($dc->type == $this->typeJuniper){ //SEND IT A POD
     	        $this->kickJuniperSession($ent);
     	    }
     		    		
     		if($dc->type == $this->typeMtApi){ 
     		
     			//We need to determine the API Connection details    		
     			$mt_data = [];
     			foreach($dc->dynamic_client_settings as $s){ 
					if(preg_match('/^mt_/',$s->name)){
						$name = preg_replace('/^mt_/','',$s->name);
						$value= $s->value;
						if($name == 'port'){
							$value = intval($value); //Requires integer 	
						}
						$mt_data[$name] = $value;				
					}			        
				}
				
				if($mt_data['proto'] == 'https'){
					$mt_data['ssl'] = true;
					if($mt_data['port'] ==8728){
						//Change it to Default SSL port 8729
						$mt_data['port'] = 8729;
					}
				}         
				unset($mt_data['proto']); 
				$this->MikrotikApi->kickRadius($ent,$mt_data);   		   		
     		}     		  		   	
     	}
             
        return $data = [];       
    }
    
    private function kickAccelSession($ent){
    
        $sid    = $ent->acctsessionid;    
        $e_srv  = $this->{'AccelSessions'}->find()->where(['AccelSessions.sid' => $sid])->first(); //Short and sweet :-)
        if($e_srv){
            $e_srv->disconnect_flag = 1;
            $e_srv->setDirty('modified', true);
            $this->{'AccelSessions'}->save($e_srv);
        }    
    }
    
    private function kickJuniperSession($ent){
    
        //-- Sample Disconnect ---
        //echo "Acct-​Session-​ID='2040',User-Name='zaguy@zarealm.co.za'" |radclient -c '1' -n '3' -r '3' -t '3' -x '127.0.0.1:3799' 'disconnect' 'testing123'       
        $sessionid = $ent->acctsessionid;
        $username  = $ent->username;
        $ip        = $ent->nasipaddress;
        $secret    = 'testing123';
        shell_exec("echo \"Acct-Session-ID='$sessionid',User-Name='$username'\" |radclient -c '1' -n '3' -r '3' -t '3' -x '$ip:3799' 'disconnect' '$secret'");
    }
    
   
         
    private function kickMeshNodeUser($ent,$cloud_id,$token){      
  		$cp = $this->MeshExitCaptivePortals->find()->where(['MeshExitCaptivePortals.radius_nasid' => $ent->nasidentifier])->first();            
        if($cp){
            $exit_id = $cp->mesh_exit_id;
            $exit = $this->MeshExits->find()->where(['MeshExits.id' => $exit_id])->first();
            if($exit){
                $mesh_id    = $exit->mesh_id;
                $gw_nodes   = $this->Nodes->find()->where(['Nodes.gateway !=' => 'none','Nodes.mesh_id' => $mesh_id])->all();
                foreach($gw_nodes as $node){
                    $node_id 	= $node->id;
                    $command 	= $this->pod_command.' '.$ent->callingstationid;
                    $a_data 	= [
                    	'node_id' 	=> $node_id,
                    	'command' 	=> $command, 
                    	'action'	=> 'execute',
						'cloud_id'	=> $cloud_id,
						'token'		=> $token,
						'sel_language'	=> '4_4'
                  	];                  	
                  	$http 		= new Client();
					$response 	= $http->post(
					  $this->node_action_add,
					  json_encode($a_data),
					  ['type' => 'json']
					);                  	                   
                }
            }              
        }       
    }
    
    private function kickApUser($ent,$cloud_id,$token){  
    	//The nasidentifier will be in the format of ap_<ap id>_cp_<cp number>
    	//We just care about the ap id since we will send the logout command to that ap
    	$command 	= $this->pod_command.' '.$ent->callingstationid;
    	$nasid		= $ent->nasidentifier;
    	//remove the _cp_<number>
    	$ap_id      = preg_replace("/_cp_.*/",'', $nasid);
    	//remove the ap_
    	$ap_id      = preg_replace("/^ap_/",'', $ap_id);
    	if($ap_id){
    		$command 	= $this->pod_command.' '.$ent->callingstationid;
            $a_data 	= [
            	'ap_id' 	=> $ap_id,
            	'command' 	=> $command, 
            	'action'	=> 'execute',
				'cloud_id'	=> $cloud_id,
				'token'		=> $token,
				'sel_language'	=> '4_4'
          	];                  	
          	$http 		= new Client();
			$response 	= $http->post(
			  $this->ap_action_add,
			  json_encode($a_data),
			  ['type' => 'json']
			);   	
    	}      
    }
    
    //--- HOSTAPD ----
    //---ubus call hostapd.three1 del_client "{'addr':'0c:c6:fd:7b:8b:aa', 'reason':5, 'deauth':true, 'ban_time':0}"
    //---
    private function kickMeshHostaMac($ent,$cloud_id,$token){
        //m_ <id> _ <entry_id> _ <radio_number> _ <node id>
        $node_id  = preg_replace("/^m_hosta_(\d+)_(\d+)_(\d+)_/",'', $ent->operator_name);
        $entry_id = preg_replace("/^m_hosta_(\d+)_/",'', $ent->operator_name); 
        $entry_id = preg_replace("/_(\d+)_(\d+)/",'', $entry_id);    
        
        if($node_id){
    		$command 	= $this->podMdHostapd.' '.$ent->callingstationid.' '.$entry_id;
            $a_data 	= [
            	'node_id' 	=> $node_id,
            	'command' 	=> $command, 
            	'action'	=> 'execute',
				'cloud_id'	=> $cloud_id,
				'token'		=> $token,
				'sel_language'	=> '4_4'
          	];                  	
          	$http 		= new Client();
			$response 	= $http->post(
			  $this->node_action_add,
			  json_encode($a_data),
			  ['type' => 'json']
			);   	
    	}   
    }
        
    private function kickApHostaMac($ent,$cloud_id,$token){
        //a_ <id> _ <entry_id> _ <radio_number> _ <ap id>
        $ap_id   = preg_replace("/^a_hosta_(\d+)_(\d+)_(\d+)_/",'', $ent->operator_name);
        $entry_id = preg_replace("/^a_hosta_(\d+)_/",'', $ent->operator_name); 
        $entry_id = preg_replace("/_(\d+)_(\d+)/",'', $entry_id);      
        if($ap_id){
    		$command 	= $this->podMdHostapd.' '.$ent->callingstationid.' '.$entry_id;
            $a_data 	= [
            	'ap_id' 	=> $ap_id,
            	'command' 	=> $command, 
            	'action'	=> 'execute',
				'cloud_id'	=> $cloud_id,
				'token'		=> $token,
				'sel_language'	=> '4_4'
          	];                  	
          	$http 		= new Client();
			$response 	= $http->post(
			  $this->ap_action_add,
			  json_encode($a_data),
			  ['type' => 'json']
			);   	
    	}   
    }

}
