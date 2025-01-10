<?php

//----------------------------------------------------------
//---- Author: Dirk van der Walt
//---- License: GPL v3
//---- Description: 
//---- Date: 31-12-2016
//------------------------------------------------------------

namespace App\Controller\Component;
use Cake\Controller\Component;
use Cake\Core\Configure;
use Cake\Core\Configure\Engine\PhpConfig;
use Cake\ORM\TableRegistry;

class CommonQueryFlatComponent extends Component {
     
    //Some default configs
    public $available_to_siblings   = true; //Default is true
    public $sort_by                 = 'name';
    
     public function build_simple_cloud_query($query,$user){   
    	$user_id = $user['id'];  	
    	//---Access Providers- Special where clause--
    	if($user['group_name'] == Configure::read('group.ap')){    		      		
			$clouds_OR_list		= [['Clouds.user_id' => $user_id]]; //This is the basic search item
			$ca   = TableRegistry::get('CloudAdmins');
			$q_ca = $ca->find()->where(['CloudAdmins.user_id'=>$user_id])->all();//The access provider (ap) might also be admin to other clouds
			foreach($q_ca as $e_ca){
				array_push($clouds_OR_list,['Clouds.id' => $e_ca->cloud_id]);
			}      	
			$query->where(['OR' => $clouds_OR_list]);
    	}
    	$query->order(['name' => 'ASC']);
    	//---END--- 
    }
    
    public function cloud_with_system($query,$cloud_id,$contain_array = ['Users'], $model = null, $allowOverride = true, $sort = null){     	
      
    	$query->where(['OR'=>[["cloud_id" => -1],["cloud_id" => $cloud_id]]]);
    	$query->contain($contain_array);
    	$this->_common_sort($query, $this->sort_by, null, $allowOverride);
    	$where_clause = $this->_common_filter($model);
		$query->where($where_clause);
    }
    
    public function get_filter_conditions($model = null){
        if($model){
            return $this->_common_filter($model);
        }
        return $this->_common_filter();
    }
    
    public function build_cloud_query($query,$cloud_id = 0,$contain_array = [], $model = null, $allowOverride = true, $sort = null){ 
    
    	$model  = is_null($model) ? $this->getConfig('model') : $model;
    	$m_cid  = "$model.cloud_id"; 
    	
    	if($model == 'Devices'){ //With devices we use the PermanentUsers as filter
    		$m_cid = "PermanentUsers.cloud_id";
    	}
    	
    	if($model == 'TopUpTransactions'){ //With devices we use the PermanentUsers as filter
    		$m_cid = "TopUps.cloud_id";
    	}
    	
    	if($model == 'Nodes'){ //With devices we use the PermanentUsers as filter
    		$m_cid = "Meshes.cloud_id";
    	}
    	
    	if($model == 'Aps'){ //With devices we use the PermanentUsers as filter
    		$m_cid = "ApProfiles.cloud_id";
    	}
    	
    	if($model == 'PrivatePskEntries'){ //With private_psk_entries we use the PrivatePsks as filter
    		$m_cid = "PrivatePsks.cloud_id";
    	}
    	    	
    	$query->where([$m_cid => $cloud_id]);
    	
    	//$realmIds = [47,48];
    	//$query->where(['PermanentUsers.realm_id IN' => $realmIds]);
   	
    	$query->contain($contain_array);
        if(!is_null($sort)){
            $this->sort_by = $sort;
        }
        if(is_null($model)){
       		$this->_common_sort($query, $this->sort_by, null, $allowOverride);
        } else {
            $this->_common_sort($query, $this->sort_by, $model, $allowOverride);
        }
        $where_clause = $this->_common_filter($model);       
        $query->where($where_clause);  
    }
    
           
     private function _common_sort($query, $default_column = 'name', $model = null, $allowSortOverride =  true){

        //Defaults
        $model  = is_null($model) ? $this->getConfig('model') : $model;
        $sort   = $model.'.'.$default_column;
        $dir    = 'ASC';
        
        $req_q 	= $this->getController()->getRequest()->getQuery(); //q_data is the query data

        //This is to owerride the default sort order
        if($this->getConfig('sort_by') && $allowSortOverride == true){
            $sort = $this->getConfig('sort_by');
        }
        
       if(isset($req_q['sort'])){        
		    $sort_array = json_decode($req_q['sort']);
		    if(is_array($sort_array)){
		    	if(isset($sort_array[0])){
					$first_item = $sort_array[0];
					$sort 	= $first_item->property;
					$dir	= $first_item->direction;
				}      
		    }else{

			    if($req_q['sort'] == 'owner'){
			        $sort = 'Users.username';
			    }elseif(
			        ($req_q['sort'] == 'nodes_down')||
			        ($req_q['sort'] == 'nodes_up')
			    ){
			        $sort = $model.'.last_contact';
			    }else{
			        $sort = $model.'.'.$req_q['sort'];
			    }
			    
			    //Special case for IP Address
			    if($req_q['sort'] == 'static_ip'){
			        $sort = 'INET_ATON(static_ip)';
			    }
			    
			    //Special case for Meshes
			    if($req_q['sort'] == 'mesh'){
			        $sort = 'Meshes.name';
			    }
			    
			    //Special case for Ap Profiles
			    if($req_q['sort'] == 'ap_profile'){
			        $sort = 'ApProfiles.name';
			    }
			    
			    //Special case for Devices / PermanentUser
			    if($req_q['sort'] == 'permanent_user'){
			        $sort = 'PermanentUsers.username';
			    }
			    
			    //Special case for Devices / PermanentUser
			    if($req_q['sort'] == 'vlan'){
			        $sort = 'RealmVlans.vlan';
			    }
			    
			    
			    //Special case for PrivatePsks
			    if($req_q['sort'] == 'ppsk_name'){
			        $sort = 'PrivatePsks.name';
			    }
			    
			    				    
			    $dir  = isset($req_q['dir']) ? $req_q['dir'] : $dir;
				    				
			}
		}
		
		//print_r($sort);
		//print_r($dir);
		$query->order([$sort => $dir]);
    }
    
      
    private function _common_filter($model = null){

        $where_clause   = [];
        $model          = is_null($model) ? $this->getConfig('model') : $model;
        
        $req_q 			= $this->getController()->getRequest()->getQuery(); //q_data is the query data

        if(isset($req_q['filter'])){
            $filter = json_decode($req_q['filter']); 
                  
            foreach($filter as $f){ 
            
                //Strings (like)
                if($f->operator == 'like'){
                    if($f->property == 'owner'){
                        if($this->getConfig('model') == 'Users'){ //For Access Providers
                            array_push($where_clause,array("Owners.username LIKE" => '%'.$f->value.'%'));  
                        }else{
                            array_push($where_clause,array("Users.username LIKE" => '%'.$f->value.'%'));
                        }   
                    }elseif($f->property == 'permanent_user'){ //For Devices                       
                        array_push($where_clause,array("PermanentUsers.username LIKE" => '%'.$f->value.'%'));                     
                    }elseif($f->property == 'mesh'){ //For Meshes                      
                        array_push($where_clause,array("Meshes.name LIKE" => '%'.$f->value.'%'));
                    }elseif($f->property == 'ap_profile'){ //For ApProfiles                      
                        array_push($where_clause,array("ApProfiles.name LIKE" => '%'.$f->value.'%'));
                    }elseif($f->property == 'ppsk_name'){ //For PrivatePskEntries                      
                        array_push($where_clause,array("PrivatePsks.name LIKE" => '%'.$f->value.'%'));
                    }else{
                    
                        $col = $model.'.'.$f->property;
                        array_push($where_clause,array("$col LIKE" => '%'.$f->value.'%'));
                    }
                }
                
                //Bools
                if($f->operator == '=='){
                     $col = $model.'.'.$f->property;
                     if($f->property == 'for_system'){
                     	if($f->value == true){
                     	    if($model = 'PrivatePskEntries'){
                                array_push($where_clause,['PrivatePsks.cloud_id' => -1]);
                            }else{                    	
                     		    array_push($where_clause,array($model.'.cloud_id' => -1));
                     	    }
                     	}
                     }else{
                     	array_push($where_clause,array("$col" => $f->value));
                     }
                }
                
                if($f->operator == 'in'){
                    $list_array = array();
                    foreach($f->value as $filter_list){
                        $col = $model.'.'.$f->property;
                        array_push($list_array,array("$col" => "$filter_list"));
                    }
                    array_push($where_clause,array('OR' => $list_array));
                }
                
                if(($f->operator == 'gt')||($f->operator == 'lt')||($f->operator == 'eq')){
                    //date we want it in "2018-03-12"
                    $col = $model.'.'.$f->property;
                    
                    if($f->property == 'vlan'){
                        $col = 'RealmVlans'.'.'.$f->property;
                    }
                    
                    $date_array = ['created', 'modified'];
                    if(in_array($f->property,$date_array)){
                        if($f->operator == 'eq'){
                            array_push($where_clause,array("DATE($col)" => $f->value));
                        }

                        if($f->operator == 'lt'){
                            array_push($where_clause,array("DATE($col) <" => $f->value));
                        }
                        if($f->operator == 'gt'){
                            array_push($where_clause,array("DATE($col) >" => $f->value));
                        }
                    }else{
                        if($f->operator == 'eq'){
                            array_push($where_clause,array("$col" => $f->value));
                        }

                        if($f->operator == 'lt'){
                            array_push($where_clause,array("$col <" => $f->value));
                        }
                        if($f->operator == 'gt'){
                            array_push($where_clause,array("$col >" => $f->value));
                        }
                    }
                }
            }
        }
        
        if(isset($req_q['tree_tag_id'])){
            $tree_tag_id = $req_q['tree_tag_id'];
            //$tree_tag_id = 269;
            if($tree_tag_id !== '0'){ //The root value (0)we simply ignore = no filter

                //See which level we are at
                $tree_tags = TableRegistry::get('TreeTags');

                $children  = $tree_tags->find('children', ['for' => $tree_tag_id]);
                $tree_tag_clause = [];
                foreach($children as $i){
                    array_push($tree_tag_clause,array('Meshes.tree_tag_id' => $i->id));
                }
               
                if(count($tree_tag_clause) > 0){      
                    array_push($where_clause,array('OR' => $tree_tag_clause));  
                }else{
                    array_push($where_clause,['Meshes.tree_tag_id' => $tree_tag_id]);  
                }
                
            }
        }
        
        //=== Combo Filter if present ====
        if(isset($req_q['query'])){
            $query = $req_q['query'];
            if($query !== '[null]'){
                if($model == 'PermanentUsers'){
                    array_push($where_clause,[$model.".username LIKE" => '%'.$query.'%']);
                }else{
                    array_push($where_clause,[$model.".name LIKE" => '%'.$query.'%']);
                }
            } 
        } 
        //================================
        
        return $where_clause;
    }  
}

