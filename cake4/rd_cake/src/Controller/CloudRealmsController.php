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
          
            $query      = $this->Clouds->find()->contain(['Users']); 	      	
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
                $i->tree_level= "Clouds";
                $i->cloud_id  =	$i->id;
                $i->id        = 'Clouds_'.$i->id; 
                $i->leaf	  = $leaf; 
                $i->admin_rights = [
                    [ 'username' => 'Koos'      ],
                    [ 'username' => 'Bertie'    ],
                    [ 'username' => 'Clinton'   ],
                    [ 'username' => 'Koos'      ]
                ];    
                array_push($items,$i); 
            }
        }
        
        if(preg_match("/^Clouds_/", $node)){
		    $cloud_id   = preg_replace('/^Clouds_/', '', $node);
		    $realms     = $this->Realms->find()->where(['Realms.cloud_id' => $cloud_id])->all();

		    foreach($realms as $realm){
		        $total++;
		        $realm->parent_id   = $node;
		        $realm->text        = $realm->name;
		        $realm->iconCls     = "x-fa fa-leaf txtM3";
		        $realm->leaf        = true;
		        $realm->admin_rights = [
                    [ 'username' => 'Koos'      ],
                    [ 'username' => 'Bertie'    ],
                    [ 'username' => 'Clinton'   ]
                ]; 
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
    
}
