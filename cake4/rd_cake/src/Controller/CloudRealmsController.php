<?php
/**
 * Created by G-edit.
 * User: dirkvanderwalt
 * Date: 01/01/2025
 * Time: 00:00
 */

namespace App\Controller;
use Cake\Core\Configure;
use Cake\Core\Configure\Engine\PhpConfig;
use Cake\I18n\FrozenTime;

class CloudRealmsController extends AppController {

    protected $owner_tree = [];
    protected $main_model = 'Clouds';
    
    protected $tree_level_0 = 'Clouds';
    protected $tree_level_1 = 'Realms';
    
    protected $cls_level_0  = 'x-fa fa-cloud';
    protected $cls_level_1  = 'x-fa fa-building';

    
    protected $meta_data    = [];
    protected $network_ids  = [];
    
    public function initialize():void{
        parent::initialize();
        
        $this->loadModel('Clouds');
        $this->loadModel('Realms');   
        $this->loadModel('Users');
        
        $this->loadModel('CloudAdmins');
        $this->loadModel('RealmAdmins');    
        $this->loadComponent('CommonQueryFlat', [ //Very important to specify the Model
            'model'     => 'Clouds',
            'sort_by'   => 'Clouds.id'
        ]);
        
        $this->loadComponent('Aa');       
        $this->loadComponent('JsonErrors'); 
        $this->loadComponent('TimeCalculations');
        $this->loadComponent('Formatter');
    }
    
      
    public function index(){

		$user = $this->Aa->user_for_token($this);
		if(!$user){   //If not a valid user
			return;
		}
		
		$user_id = $user['id'];
		$req_q   = $this->request->getQuery(); 
        
        //Only ap's or admins
        $fail_flag = true; 
		if(($user['group_name'] == Configure::read('group.admin'))||($user['group_name'] == Configure::read('group.ap'))){				
			$fail_flag = false;	
		}
		
		if($fail_flag){
			return;
		}
		  
        $node       = $this->request->getQuery('node');  
        $items      = [];
        $total      = 0;  

        if($node === 'root'){
          
            $query      = $this->Clouds->find()->order(['Clouds.name' => 'ASC'])->contain(['Users']); 	      	
            $query->contain(['Users','CloudAdmins.Users']); //Pull in the Users and Cloud Admins for clouds (root level) 	     	       	     	
             
            $q_r    = $query->all();
            $total  = $query->count();      
            
            foreach($q_r as $i){
            
                $leaf         = true;
                $realm_count  = $this->Realms->find()->where(['Realms.cloud_id' => $i->id])->count();
                if($realm_count > 0){
                    $leaf = false;
                }          
            
                $i->parent_id =	"root";
                $i->text      = $i->name;
                $i->iconCls   = "x-fa fa-cloud txtM3";
                $i->tree_level= 'Clouds';
                $i->cloud_id  =	$i->id;
                $i->id        = 'Clouds_'.$i->id; 
                $i->leaf	  = $leaf;
                $i->update    = true;
                
                $admin_rights       = [];
                $operator_rights    = [];
                $viewer_rights      = [];
                foreach($i->cloud_admins as $cloudAdmin){
                    $username = $cloudAdmin->user->username;
                                       
                    if($cloudAdmin->permissions == 'admin'){
                        array_push($admin_rights, ['username' => $username]);
                    }
                    if($cloudAdmin->permissions == 'granular'){                       
                        array_push($operator_rights, ['username' => $username]);
                    }
                    if($cloudAdmin->permissions == 'view'){                       
                        array_push($viewer_rights, ['username' => $username]);
                    }               
                }                               
                $i->admin_rights    = $admin_rights;
                $i->operator_rights = $operator_rights;
                $i->viewer_rights   = $viewer_rights;    
                array_push($items,$i); 
            }
        }
        
        if(preg_match("/^Clouds_/", $node)){
		    $cloud_id   = preg_replace('/^Clouds_/', '', $node);
		    $realms     = $this->Realms->find()->where(['Realms.cloud_id' => $cloud_id])->contain(['RealmAdmins.Users'])->all();

		    foreach($realms as $realm){
		        $total++;
		        $realm->parent_id   = $node;
		        $realm->text        = $realm->name;
		        $realm->iconCls     = "x-fa fa-leaf txtM3";
		        $realm->leaf        = true;
		        $realm->tree_level  = 'Realms';
		        $realm->update      = true;
		        
		        $admin_rights       = [];
                $operator_rights    = [];
                $viewer_rights      = [];
                foreach($realm->realm_admins as $realmAdmin){
                    $username = $realmAdmin->user->username;
                    if($realmAdmin->permissions == 'admin'){
                        array_push($admin_rights, ['username' => $username]);
                    }
                    if($realmAdmin->permissions == 'granular'){                       
                        array_push($operator_rights, ['username' => $username]);
                    }
                    if($realmAdmin->permissions == 'view'){                       
                        array_push($viewer_rights, ['username' => $username]);
                    }               
                }                               
                $realm->admin_rights    = $admin_rights;
                $realm->operator_rights = $operator_rights;
                $realm->viewer_rights   = $viewer_rights;
		        array_push($items,$realm);	    
		    }	    		    
	    }   
                       
        $this->set([
            'items' => $items,
            'total' => $total,
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }
    
    public function view(){
    
        $user = $this->Aa->user_for_token($this);
		if(!$user){   //If not a valid user
			return;
		}
		
		$user_id = $user['id'];
		$req_q   = $this->request->getQuery();
		
		$level   = $this->request->getQuery('level');
		$role    = $this->request->getQuery('role'); //role can be admin / operator / viewer
		$id      = $this->request->getQuery('id');
		
		$permissions = 'admin';
		if($role == 'operator'){	  
		    $permissions = 'granular';
		}
		
		if($role == 'viewer'){
		    $permissions = 'view';
		}
				
		
		if(preg_match("/^Clouds_/", $id)){
		    $id   = preg_replace('/^Clouds_/', '', $id);
		}
		$reply_id   = $id;	
		$admins     = [];
		
		if($level == 'Clouds'){	
		    $reply_id       = 'Clouds_'.$reply_id;	    
		    $cloudAdmins    = $this->{'CloudAdmins'}->find()->where(['cloud_id' => $id, 'permissions' => $permissions])->all();
		    foreach($cloudAdmins as $cloudAdmin){
		        array_push($admins,$cloudAdmin->user_id);		    
		    }
		}
		
		if($level == 'Realms'){	
		    $realmAdmins    = $this->{'RealmAdmins'}->find()->where(['realm_id' => $id, 'permissions' => $permissions])->all();
		    foreach($realmAdmins as $realmAdmin){
		        array_push($admins,$realmAdmin->user_id);		    
		    }
		}
		  
        $items = [
            'id'    => $reply_id,
            'role'  => $role,
            'level' => $level,
            'admin' => $admins
        ];
           
        $this->set([
            'data'  => $items,
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);   
    }
    
    public function edit(){
    
        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        
        $requestData    = $this->request->getData();  
        $role           = $requestData['role'];
        $permissions    = 'admin';
        
        if($role == 'operator'){
            $permissions = 'granular';
        }
        if($role == 'viewer'){
            $permissions = 'view';
        }
        
        $id     = $requestData['id'];
        $level  = $requestData['level'];
        
        if(preg_match("/^Clouds_/", $id)){
		    $id   = preg_replace('/^Clouds_/', '', $id);
		}
		
		if($level == 'Clouds'){		
		    $this->{'CloudAdmins'}->deleteAll(['CloudAdmins.cloud_id' => $id, 'permissions' => $permissions]);
		    if (array_key_exists('admin', $requestData)) {
                if(!empty($requestData['admin'])){
                    foreach($requestData['admin'] as $e){
                        if($e != ''){
                            $e_ca = $this->{'CloudAdmins'}->newEntity(['cloud_id' => $id,'user_id' => $e,'permissions' => $permissions]);
            				$this->{'CloudAdmins'}->save($e_ca);
            				$this->_cloudLevelCleanup($id,$e,$permissions);
                        }    
                    }
                }
            }		    
		}
		
		if($level == 'Realms'){		
		    $this->{'RealmAdmins'}->deleteAll(['RealmAdmins.realm_id' => $id, 'permissions' => $permissions]);
		    if (array_key_exists('admin', $requestData)) {
                if(!empty($requestData['admin'])){
                    foreach($requestData['admin'] as $e){
                        if($e != ''){
                            $e_ca = $this->{'RealmAdmins'}->newEntity(['realm_id' => $id,'user_id' => $e,'permissions' => $permissions]);
            				$this->{'RealmAdmins'}->save($e_ca);
            				$this->_realmLevelCleanup($id,$e,$permissions);
                        }    
                    }
                }
            }		    
		}
        
        $this->set([
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
          
    }
    
    private function _cloudLevelCleanup($cloud_id, $user_id, $permissions){

        // Define permissions to delete for each level
        $permissionsToDelete = [
            'admin'     => ['granular', 'view'],
            'granular'  => ['admin', 'view'],
            'view'      => ['admin', 'granular'],
        ];

        // Check if the provided permission exists in the mapping
        if (isset($permissionsToDelete[$permissions])) {
            // Loop through the permissions to delete
            foreach ($permissionsToDelete[$permissions] as $perm) {
                $this->CloudAdmins->deleteAll([
                    'cloud_id'      => $cloud_id,
                    'user_id'       => $user_id,
                    'permissions'   => $perm
                ]);
            }
        }
    }
    
    private function _realmLevelCleanup($realm_id, $user_id, $permissions){

        // Define permissions to delete for each level
        $permissionsToDelete = [
            'admin'     => ['granular', 'view'],
            'granular'  => ['admin', 'view'],
            'view'      => ['admin', 'granular'],
        ];

        // Check if the provided permission exists in the mapping
        if (isset($permissionsToDelete[$permissions])) {
            // Loop through the permissions to delete
            foreach ($permissionsToDelete[$permissions] as $perm) {
                $this->RealmAdmins->deleteAll([
                    'realm_id'      => $realm_id,
                    'user_id'       => $user_id,
                    'permissions'   => $perm
                ]);
            }
        }
    }    
    
}
