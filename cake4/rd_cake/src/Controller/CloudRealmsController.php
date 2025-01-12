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
        
            $query  = $this->Clouds->find();
        
            //ap group filter on user_id / admin group no filter
        	if($user['group_name'] == Configure::read('group.ap')){       		
				$clouds_OR_list	= [['Clouds.user_id' => $user_id]]; //This is the basic search item
				$q_ca = $this->{'CloudAdmins'}->find()->where(['CloudAdmins.user_id'=>$user_id])->all();//The access provider (ap) might also be admin to other clouds
				foreach($q_ca as $e_ca){
					array_push($clouds_OR_list,['Clouds.id' => $e_ca->cloud_id]);
				}      	
        		$query  = $this->{'Clouds'}->find();
    			$query->where(['OR' => $clouds_OR_list]);
        	}         
            $query->order(['Clouds.name' => 'ASC'])->contain(['Users','CloudAdmins.Users']); 	//Pull in the Users and Cloud Admins for clouds (root level)       	   	       	     	
             
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
                        array_push($admin_rights, ['username' => $username, 'cloud_wide' => $cloudAdmin->cloud_wide]);
                    }
                    if($cloudAdmin->permissions == 'granular'){                       
                        array_push($operator_rights, ['username' => $username, 'cloud_wide' => $cloudAdmin->cloud_wide]);
                    }
                    if($cloudAdmin->permissions == 'view'){                       
                        array_push($viewer_rights, ['username' => $username, 'cloud_wide' => $cloudAdmin->cloud_wide]);
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
		$cloud_id   = 0;
		
		if($level == 'Clouds'){	
		    $reply_id       = 'Clouds_'.$reply_id;
		    $cloud_id       = $reply_id;    
		    $cloudAdmins    = $this->{'CloudAdmins'}->find()->where(['cloud_id' => $id, 'permissions' => $permissions,'cloud_wide' => 1])->all();
		    foreach($cloudAdmins as $cloudAdmin){
		        array_push($admins,$cloudAdmin->user_id);		    
		    }
		}
		
		if($level == 'Realms'){	
		    $realmAdmins    = $this->{'RealmAdmins'}->find()->where(['realm_id' => $id, 'permissions' => $permissions])->all();
		    $realm          = $this->{'Realms'}->find()->where(['Realms.id' => $id])->first();
		    $reply_id       = intval($reply_id);
		    if($realm){
		        $cloud_id = $realm->cloud_id;
		    }
		    foreach($realmAdmins as $realmAdmin){
		        array_push($admins,$realmAdmin->user_id);		    
		    }
		}
		  
        $items = [
            'id'    => $reply_id,
            'role'  => $role,
            'level' => $level,
            'c_id'  => $cloud_id,
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
		
		    //-----------------------------------------------------------------------
		    //---We have to implement restrictions to Access Providers
		    
            if($user['group_name'] == Configure::read('group.ap')){ 
                
                $apAllow = false;
                
                //--- IF the cloud is owned by the Access Provider we can continiue)
                $cloud = $this->Clouds->find()->where(['Clouds.id' => $id])->first();
                if($cloud){
                    //Owner of the Cloud can change permissions
                    if($cloud->user_id == $user['id']){
                        $apAllow = true;
                        
                    }else{
                    
                        //See what rights the Access Provicer have on this cloud                   
                        $cloudAdmin = $this->CloudAdmins->find()->where(['CloudAdmins.cloud_id' => $id, 'user_id' => $user['id'],'cloud_wide' => 1])->first();                        
                        $apAllow    = $this->_checkPermissions($cloudAdmin, $permissions);
                        if($apAllow){
                            //Don't allow the user['id'] to 'step down' other Admins on the same cloud
                            $requestData['admin'] = $this->_sanitizeAdminsPermissions($requestData['admin'], $id,$permissions); 
                        }
                                           
                    }  
                }                
                if(!$apAllow){                
                    $this->set([
                        'success'   => $apAllow,
                        'message'   => 'No Rights For This Action'
                    ]);
                    $this->viewBuilder()->setOption('serialize', true); 
                    return;           
                }                                                     
            }
            //----------------------------------------------------------------------------------------------------
				
		    $this->{'CloudAdmins'}->deleteAll(['CloudAdmins.cloud_id' => $id, 'permissions' => $permissions,'cloud_wide' => 1]);
		    if (array_key_exists('admin', $requestData)) {
                if(!empty($requestData['admin'])){
                    foreach($requestData['admin'] as $e){
                        if($e != ''){
                            $e_ca = $this->{'CloudAdmins'}->newEntity(['cloud_id' => $id,'user_id' => $e,'permissions' => $permissions]);
            				$this->{'CloudAdmins'}->save($e_ca);
            				$this->_cloudLevelCleanup($id,$e,$permissions);
            				$this->_removeRealmAdminsForCloud($id,$e); //If it was an 'upgrade'
                        }    
                    }
                }
            }          		    
		}
		
		if($level == 'Realms'){
				
		    // Implement restrictions for Access Providers
            if ($user['group_name'] === Configure::read('group.ap')) { 
                $apAllow = false;
                $c_id = $this->request->getData('c_id');

                // Check if the cloud exists and if the user is the owner
                $cloud = $this->Clouds->find()->where(['Clouds.id' => $c_id])->first();
                if ($cloud && $cloud->user_id === $user['id']) {
                    $apAllow = true;
                } else {
                    // Check Access Provider rights at the cloud level
                    $cloudAdmin = $this->CloudAdmins->find()
                        ->where(['CloudAdmins.cloud_id' => $c_id, 'user_id' => $user['id'], 'cloud_wide' => 1])
                        ->first();

                    $apAllow = $this->_checkPermissions($cloudAdmin, $permissions);

                    // If no cloud-level rights, check realm-level rights
                    if (!$apAllow) {
                        $realmAdmin = $this->RealmAdmins->find()
                            ->where(['RealmAdmins.realm_id' => $id, 'user_id' => $user['id']])
                            ->first();

                        $apAllow = $this->_checkPermissions($realmAdmin, $permissions);

                        if ($apAllow) {
                            // Sanitize admins to exclude cloud-level admins
                            $requestData['admin'] = $this->_sanitizeAdmins($requestData['admin'], $c_id);
                        }
                    }
                }

                if (!$apAllow) {
                    $this->set([
                        'success' => false,
                        'message' => 'No Rights For This Action'
                    ]);
                    $this->viewBuilder()->setOption('serialize', true);
                    return;
                }
            }
							
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
            $this->_doCloudWideFlag($requestData);		    
		}
        
        $this->set([
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
          
    }
    
    private function _doCloudWideFlag($requestData){    
        $cloud_id = $requestData['c_id'];
        $realms = $this->{'Realms'}->find()->where(['Realms.cloud_id' => $cloud_id])->all();    
        foreach($realms as $realm){        
            $realmAdmins = $this->{'RealmAdmins'}->find()->where(['realm_id' => $realm->id]);
            foreach($realmAdmins as $realmAdmin){         
                $this->_clearOrCreateCloudWide($cloud_id,$realmAdmin->user_id,$realmAdmin->permissions);
            }
        }        
        $this->_removeUnusedCloudAdmin($requestData);         
    }
    
    private function _clearOrCreateCloudWide($cloud_id,$user_id,$permissions){   
        $cloudAdmin = $this->{'CloudAdmins'}->find()->where(['cloud_id' => $cloud_id, 'user_id' => $user_id])->first();
        if($cloudAdmin){
            $this->{'CloudAdmins'}->patchEntity($cloudAdmin, ['cloud_wide' => 0,'permissions' => $permissions]);
            $this->{'CloudAdmins'}->save($cloudAdmin);
        }else{
            $newCloudAdmin = $this->{'CloudAdmins'}->newEntity(['cloud_id' => $cloud_id, 'user_id' => $user_id,'cloud_wide' => 0,'permissions' => $permissions]);
            $this->{'CloudAdmins'}->save($newCloudAdmin);       
        }    
    }
    
    private function _removeUnusedCloudAdmin($requestData){
        $cloud_id = $requestData['c_id'];
        $cloudAdmins = $this->{'CloudAdmins'}->find()->where(['cloud_id' => $cloud_id, 'cloud_wide' => 0])->all();
        
        foreach($cloudAdmins as $cloudAdmin){
            if(!$this->_hasRealmAdmins($cloudAdmin->cloud_id, $cloudAdmin->user_id)){
                $this->{'CloudAdmins'}->deleteAll(['CloudAdmins.cloud_id' => $cloudAdmin->cloud_id, 'user_id' => $cloudAdmin->user_id]);            
            }
        }   
    }
    
    private function _removeRealmAdminsForCloud($cloud_id,$user_id){
        $this->{'CloudAdmins'}->deleteAll(['CloudAdmins.cloud_id' => $cloud_id, 'user_id' => $user_id,'cloud_wide' => 0]); 
        $realms = $this->{'Realms'}->find()->where(['Realms.cloud_id' => $cloud_id])->all();
        foreach($realms as $realm){
            $this->{'RealmAdmins'}->deleteAll(['realm_id' => $realm->id, 'user_id' => $user_id]);
        }    
    }
    
    private function _hasRealmAdmins($cloud_id,$user_id){
    
        $realms = $this->{'Realms'}->find()->where(['Realms.cloud_id' => $cloud_id])->all();
        $user_entries = 0;
        foreach($realms as $realm){
            $count = $this->{'RealmAdmins'}->find()->where(['realm_id' => $realm->id,'user_id' => $user_id])->count();
            $user_entries = $user_entries + $count;
        }
        if($user_entries > 0){
            return true;
        }   
        return false;
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
    
    private function _checkPermissions($adminEntity, $requestedPermission){

        if (!$adminEntity) {
            return false;
        }

        switch ($adminEntity->permissions) {
            case 'admin':
                return true;

            case 'granular':
                return in_array($requestedPermission, ['granular', 'view'], true);

            case 'view':
                return $requestedPermission === 'view';

            default:
                return false;
        }
    }
    
    private function _sanitizeAdmins(array $admins, $cloudId){

        $saneAdmins = [];

        foreach ($admins as $admin) {
            $cloudAdmin = $this->CloudAdmins->find()
                ->where(['CloudAdmins.cloud_id' => $cloudId, 'user_id' => $admin, 'cloud_wide' => 1])
                ->first();

            if (!$cloudAdmin) {
                $saneAdmins[] = $admin;
            }
        }

        return $saneAdmins;
    }
    
    private function _sanitizeAdminsPermissions(array $admins, $cloudId, $adminPermission){
    
        $saneAdmins = [];
        foreach ($admins as $admin) {
            $cloudAdmin = $this->CloudAdmins->find()
                ->where(['CloudAdmins.cloud_id' => $cloudId, 'user_id' => $admin, 'cloud_wide' => 1])
                ->first();

            if ($cloudAdmin) {            
                if($adminPermission !== $cloudAdmin->permissions){
                    if($adminPermission == 'admin'){ //Admin can step granular and view up
                        $saneAdmins[] = $admin;
                    }
                    if(($adminPermission == 'granular')&&($cloudAdmin->permissions == 'view')){ //Operator can step view up
                        $saneAdmins[] = $admin;
                    }
                }else{
                    $saneAdmins[] = $admin; //Same level   
                }
            }else{
                $saneAdmins[] = $admin; //New Entry
            }
        }

        return $saneAdmins;    
    }
        
}
