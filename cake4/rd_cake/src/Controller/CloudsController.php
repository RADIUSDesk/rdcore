<?php
/**
 * Created by G-edit.
 * User: dirkvanderwalt
 * Date: 27/09/2017
 * Time: 00:00
 */

namespace App\Controller;
use Cake\Core\Configure;
use Cake\Core\Configure\Engine\PhpConfig;
use Cake\I18n\FrozenTime;

class CloudsController extends AppController {

    public $base = "Access Providers/Controllers/Clouds/";
    protected $owner_tree = [];
    protected $main_model = 'Clouds';
    
    protected $tree_level_0 = 'Clouds';
    protected $tree_level_1 = 'Sites';
    protected $tree_level_2 = 'Networks';
    
    protected $cls_level_0  = 'x-fa fa-cloud';
    protected $cls_level_1  = 'x-fa fa-building';
    protected $cls_level_2  = 'x-fa fa-sitemap';
    
    protected $meta_data    = [];
    protected $network_ids  = [];
    protected $timespan     = 'now';
    
    private $blue       = '#627dde';
    private $l_red      = '#fb6002';
    private $d_red      = '#dc1a1a';
    private $l_green    = '#4bd765';
    private $d_green    = "#117c25";
    private $green      = '#01823d';    //Green until dead time then grey
    private $dark_blue  = '#0a3cf6';    //Blue until dead time then grey
    private $grey       = '#505351';    //Green until dead time then grey
    private $blue_grey  = '#adbcf6';    //Blue until dead time then blue_grey
    private $yellow     = '#f8d908';
    private $thickness  = 9;
    private $gw_size    = 20;
    private $node_size  = 10;
    
    protected $fields       = [
        'data_in'       => 'sum(tx_bytes)',
        'data_out'      => 'sum(rx_bytes)',
        'data_total'    => 'sum(tx_bytes) + sum(rx_bytes)'
    ];
    
    protected $time_zone    = 'UTC'; //Default for timezone

    public function initialize():void{
        parent::initialize();
        
        $this->loadModel('Clouds');
        $this->loadModel('Sites');
        $this->loadModel('Networks');
        
        $this->loadModel('Users');
        $this->loadModel('Meshes');
        $this->loadModel('Nodes');
        $this->loadModel('Aps');
        $this->loadModel('Timezones');
        $this->loadModel('NodeStations');
        $this->loadModel('NodeStationHourlies');
        $this->loadModel('ApStations');
        $this->loadModel('ApStationHourlies');
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
    
    public function indexCmb(){
       
    	$user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        $user_id = $user['id'];		                     
        $query   = $this->{$this->main_model}->find();
            
		//---Access Providers- Special where clause--
    	if($user['group_name'] == Configure::read('group.ap')){ 
    		      		
			$clouds_OR_list		= [['Clouds.user_id' => $user_id]]; //This is the basic search item
			$q_ca = $this->{'CloudAdmins'}->find()->where(['CloudAdmins.user_id'=>$user_id])->all();//The access provider (ap) might also be admin to other clouds
			foreach($q_ca as $e_ca){
				array_push($clouds_OR_list,['Clouds.id' => $e_ca->cloud_id]);
			}      	
			$query->where(['OR' => $clouds_OR_list]);
    	}
    	//---END---        	   
    	
    	$query->order(['name' => 'ASC']);
    	$q_r 	= $query->all();
    	$items 	= [];
    	foreach($q_r as $e){
    		array_push($items,$e);
    	}
        $this->set([
            'items' => $items,
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);   	   
    }
    
    public function indexNetworkOverview(){
     
        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        
        $this->_setTimeZone();
        $timespan    = $this->request->getQuery('timespan');
        
        if($timespan){
            $this->timespan = $timespan;
        }
        
        //HERE WE START OFF - We find all the CLOUDS
        //So if not specifies it iwii list ALL the Clouds (that the user can see)
        $tree_level = $this->tree_level_0;  //Clouds   
        $l_model    = $this->main_model;    //Clouds
        $node       = null;
        $tt_level   = 0;
        $conditions = [];
        
        $req_q      = $this->request->getQuery();
               
        if(isset($req_q['node'])){
            $node       = $req_q['node'];
            $node_id    = preg_replace('/^(\w+)_/', '', $node);
            $level      = preg_replace('/_(\d+)/', '', $node);        
            if($level == 'Clouds'){
                //For Cloud level we need to find all the SITES containing the CLOUD ID
                $l_model    = $this->tree_level_1; //Sites
                $tree_level = $this->tree_level_1; //Sites
                $cloud_id   = $node_id;
                $conditions = ['Sites.cloud_id' => $cloud_id];
                $tt_level   = 1;
            }
                  
            if($level == 'Sites'){
                //For Site level we need to find all the Networks containing the Site ID
                $l_model    = $this->tree_level_2; //Networks
                $tree_level = $this->tree_level_2; //Networks
                $site_id    = $node_id;
                $conditions = ['Networks.site_id' => $site_id];
                $tt_level   = 2;
            }
            
            if($level == 'Networks'){
                //For Network level we need to find all the MESHES and APs containing the Network ID as tree_tag_id 
                $l_model    = $this->tree_level_2; //Networks
                $tree_level = $this->tree_level_2; //Networks
                $site_id    = $node_id;
                $conditions = [];
                $tt_level   = 3;
            }
            $this->_meta_data_for_level_and_id($level,$node_id,$tt_level);          
        }
        
        $query  = $this->{$l_model }->find();
                
        if($level == '0'){ //Level 0 == 'root' = includes all belonging to Access Provider
            $this->CommonQueryFlat->build_simple_cloud_query($query, $user);
        }else{
            $query->where($conditions);
        } 
           
        $this->meta_data['level_stats'] = $this->_fetchLevelStats($user,$level,$node_id);    //This will prime the $this->network_ids array for subsequent queries     
        $this->_infoBuilding();
        $data = [];
          
          
        //MESHdesk
        $nodes          = $this->meta_data['total_nodes'];
        $nodes_online   = $this->meta_data['total_nodes_online']; 
        $nodes_offline  = ($nodes - $nodes_online);
        $data['meshdesk']['online'] = [
            [
                'name'  => "$nodes_online ONLINE",
                'data1' => $nodes_online
            ] 
            ,[
                 'name' => "$nodes_offline OFFLINE",
                 'data1'=> "$nodes_offline"
             ]        
        ];

        $data_graph_mesh = $this->_build_data_graph('mesh');
        $data['meshdesk']['graph'] = $data_graph_mesh;
        $data['meshdesk']['totals']                 = $this->meta_data;
        $data['meshdesk']['totals']['data_total']   = $this->Formatter->formatted_bytes($this->mesh_data_total);
        $data['meshdesk']['totals']['data_in']      = $this->Formatter->formatted_bytes($this->mesh_data_in);
        $data['meshdesk']['totals']['data_out']     = $this->Formatter->formatted_bytes($this->mesh_data_out);
        $data['meshdesk']['totals']['users']        = $this->mesh_user_total;
        
        
        //APdesk
        $aps          = $this->meta_data['total_aps'];
        $aps_online   = $this->meta_data['total_aps_online']; 
        $aps_offline  = ($aps - $aps_online);
        $data['apdesk']['online'] = [
            [
                'name'  => "$aps_online ONLINE",
                'data1' => $aps_online
            ] 
            ,[
                 'name' => "$aps_offline OFFLINE",
                 'data1'=> "$aps_offline"
             ]        
        ];
        
        $data_graph_ap = $this->_build_data_graph('ap');
        $data['apdesk']['graph'] = $data_graph_ap;
        $data['apdesk']['totals']                   = $this->meta_data;
        $data['apdesk']['totals']['data_total']     = $this->Formatter->formatted_bytes($this->ap_data_total);
        $data['apdesk']['totals']['data_in']        = $this->Formatter->formatted_bytes($this->ap_data_in);
        $data['apdesk']['totals']['data_out']       = $this->Formatter->formatted_bytes($this->ap_data_out);
        $data['apdesk']['totals']['users']          = $this->ap_user_total;
                        
        $this->set([
            'data'      => $data,
            'metaData'  => $this->meta_data,
            'success'   => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);   
    
    }
    
    private function _build_data_graph($for_who = 'mesh'){
    
        $this->graph_item = $for_who;
        $span       = $this->timespan;  
        $ft_now = FrozenTime::now();
        $graph_items = []; 
        if($span == 'now'){
            $graph_items    = $this->_getHourlyGraph($ft_now);
        }
        if($span == 'daily'){
            $graph_items = $this->_getDailyGraph($ft_now);
        }
        if($span == 'weekly'){
            $graph_items = $this->_getWeeklyGraph($ft_now);
        }
        return $graph_items;
    }
      
    public function indexNetworkMap(){

        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        
        $this->_setTimeZone();
        $timespan    = $this->request->getQuery('timespan');
        
        if($timespan){
            $this->timespan = $timespan;
        }
        
        //HERE WE START OFF - We find all the CLOUDS
        //So if not specifies it iwii list ALL the Clouds (that the user can see)
        $tree_level = $this->tree_level_0;  //Clouds   
        $l_model    = $this->main_model;    //Clouds
        $node       = null;
        $tt_level   = 0;
        $conditions = [];       
        $req_q      = $this->request->getQuery();
               
        if(isset($req_q['node'])){
            $node       = $req_q['node'];
            $node_id    = preg_replace('/^(\w+)_/', '', $node);
            $level      = preg_replace('/_(\d+)/', '', $node); 
            
            //This is a special one ... going past the Network level
            if($level == 'MarkerNetworks'){
                $items          = [];
                $connections    = [];
                
                $network = $this->{'Networks'}->find()->where(['Networks.id' => $node_id])->first();
                if($network){
                    $lat = $network->lat;
                    $lng = $network->lng;
                    
                    //=== MESHES ===
                    $meshes = $this->{'Meshes'}->find()->where(['Meshes.tree_tag_id' => $node_id])->all();
                    $mesh_ids = [0]; //set to zero so its not empty
                    if($meshes){
                        $mesh_ids = [];
                        foreach($meshes as $mesh){
                            array_push($mesh_ids,$mesh->id);
                        }
                    }                    
                    $nodes_where = ['Nodes.mesh_id IN' => $mesh_ids];
                    $nodes = $this->{'Nodes'}->find()->where($nodes_where)
                        ->contain('NodeNeighbors',function ($q) {
                            $back= (FrozenTime::now())->subHours(1);
                            return $q
                                ->where(['modified >=' => $back]);
                                
                        })
                        ->all();
                    $inc = 0;
                    
                    $now            = FrozenTime::now();
                    $dead_after     = $this->_getDefaultDeadAfter();      
                    $cut_off_time   = $now->subSecond($dead_after);
                    
                     //Some defaults for the spiderweb
                    $thickness  = 9;    //The bigger the metric; ther thinner this line
                    $opacity    = 1;    //The older a line is the more opacity it will have (tend to zero)
                    $cut_off    = 3 * $dead_after;
                    $one_hour   = 3600000;

                    
                    //Build a hash of nodes with their detail for lookup
                    $neighbor_hash = [];
    
                    foreach ($nodes as $node) {
                        if ($node->lat != null) {  //Only those with co-ordinates
                            $id = $node->id;
                            $neighbor_hash[$id]=$node;
                        }
                    } 
                    
                    foreach($nodes as $node){
                        $node_lat = $node->lat;
                        $node_lon = $node->lon;
                        $gateway = false;
                        if(($node->gateway == 'lan')||($node->gateway == '3g')||($node->gateway == 'wifi')){           
                            $gateway = true;      
                        }
                        
                        
                        $down_flag = true;
                        if($node->last_contact > $cut_off_time){
                            $down_flag = false;   
                        }
                        
                        $not_placed = false;
                        
                        if(($node_lat == null)||($node_lon == null)){
                            $node_lat = $lat+$inc;      
                            $node_lon = $lng+$inc;
                            $inc = $inc+0.001;
                            $not_placed = true;
                        }
                        
                        array_push($items,[  
                            'id'        => 'NodeMarker'.'_'.$node->id, 
                            'name'      => $node->name,
                            'mac'       => $node->mac, 
                            'text'      => $node->name,
                            'lat'       => $node_lat,
                            'lng'       => $node_lon,
                            'level'     => 'NodeMarker',
                            'down_flag' => $down_flag,
                            'not_placed'=> $not_placed,
                            'gateway'   => $gateway 
                        ]);
                        
                  $i = $node;
                   $noden_id    = $i->id;      
                        if (count($i->node_neighbors)>0) {
                $gw = $i->node_neighbors[0]['gateway'];

                foreach ($i->node_neighbors as $n) {
                
                    $n_id   = $n->neighbor_id;
                    $metric = $n->metric;
                    $last   = strtotime($n->modified);
                    $now    = time();

                    //It might be so old that we do not bother drawing it
                    if ($last <= ($now - $cut_off)) {
                        continue;
                    }

                    //print_r($n);
                    if ((array_key_exists($n_id, $neighbor_hash)) &&  (array_key_exists($noden_id, $neighbor_hash))
                    ) {
                        $from_lat   = $neighbor_hash[$noden_id]['lat'];
                        $from_lng   = $neighbor_hash[$noden_id]['lon'];
                        $to_lat     = $neighbor_hash[$n_id]['lat'];
                        $to_lng     = $neighbor_hash[$n_id]['lon'];
                        $metric         = $n->metric;
                        $weight         = round((1/$metric*$this->thickness), 2);

                        //What color the line must be
                        $green_cut  = $now - $dead_after;
                        $grey_cut   = $now - $cut_off;
                        
                        if ($last >= $green_cut) {
                            $c = $this->green;
                            if (($n->hwmode == '11a')||($n->hwmode == '11na')) {
                                $c = $this->dark_blue;
                            }

                            //How clear the line must be
                            $green_range    = $now - $green_cut;
                            $green_percent  = ($last- $green_cut)/$green_range;
                            $o_val          = ($green_percent * 0.5)+0.5;
                            $o_val          = round($o_val, 2);
                        } else {
                            //How clear the line must be
                            $c              = $this->grey;
                            if (($n->hwmode == '11a')||($n->hwmode == '11na')) {
                                $c = $this->blue_grey;
                            }
                            $grey_range     = $green_cut - $grey_cut;
                            $grey_percent   = ($last- $grey_cut)/$grey_range;
                            $o_val          = ($grey_percent * 0.5)+0.5;
                            $o_val          = round($o_val, 2);
                        }

                        array_push($connections, array(
                            'from'  => array(
                                'lat'   => $from_lat,
                                'lng'   => $from_lng
                            ),
                            'to'    => array(
                                'lat'   => $to_lat,
                                'lng'   => $to_lng
                            ),
                            'weight'    => $weight,
                            'color'         => $c,
                            'opacity'   => $o_val,
                            'metric'    => $metric
                        ));
                    }
                }
            }
                        
                        
                        
                                              
                        
                    }
                    
                    //===APs====
                    $aps = $this->{'Aps'}->find()->where(['Aps.tree_tag_id' => $node_id])->all();
                    foreach($aps as $ap){
                        $ap_lat = $ap->lat;
                        $ap_lon = $ap->lon;
                        $down_flag = true;
                        if($ap->last_contact > $cut_off_time){
                            $down_flag = false;   
                        }
                        
                        $not_placed = false;
                        
                        if(($ap_lat == null)||($ap_lon == null)){
                            $ap_lat = $lat+$inc;      
                            $ap_lon = $lng+$inc;
                            $inc = $inc+0.001;
                            $not_placed = true;
                        }
                        
                        array_push($items,[  
                            'id'        => 'ApMarker'.'_'.$ap->id, 
                            'name'      => $ap->name,
                            'mac'       => $ap->mac, 
                            'text'      => $ap->name,
                            'lat'       => $ap_lat,
                            'lng'       => $ap_lon,
                            'level'     => 'ApMarker',
                            'down_flag' => $down_flag,
                            'not_placed'=> $not_placed,
                            'gateway'   => true  
                        ]);                      
                        
                    }     
                }
                
                $this->set([
                    'items'     => $items,
                    'connections' => $connections,
                    'success'   => true
                ]);
                $this->viewBuilder()->setOption('serialize', true);            
                return;
            }
            
                   
            if($level == 'Clouds'){
                //For Cloud level we need to find all the SITES containing the CLOUD ID
                $l_model    = $this->tree_level_1; //Sites
                $tree_level = $this->tree_level_1; //Sites
                $cloud_id   = $node_id;
                $conditions = ['Sites.cloud_id' => $cloud_id];
                $tt_level   = 1;
            }
                  
            if($level == 'Sites'){
                //For Site level we need to find all the Networks containing the Site ID
                $l_model    = $this->tree_level_2; //Networks
                $tree_level = $this->tree_level_2; //Networks
                $site_id    = $node_id;
                $conditions = ['Networks.site_id' => $site_id];
                $tt_level   = 2;
            }
            
            if($level == 'Networks'){
                $tt_level   = 3;
                $tree_level = $this->tree_level_2; //Networks
            }
            $this->_meta_data_for_level_and_id($level,$node_id,$tt_level);          
        }
        
        //== META INFO ===
        $this->meta_data['level_stats'] = $this->_fetchLevelStats($user,$level,$node_id);     
        //print_r($this->network_ids);         
        $this->_infoBuilding();    
        
        //=== ITEMS FOR MAP====
        $query  = $this->{$l_model }->find();            
        if($level == '0'){ //Level 0 == 'root' = includes all belonging to Access Provider
            $this->CommonQueryFlat->build_simple_cloud_query($query,$user); //AP QUERY is sort of different in a way
        }else{
            if(($level == 'Clouds')||($level == 'Sites')){
                $query->where($conditions);
            }      
        }
        
        $items = [];
        $total = 0;
        if(($level == '0')||($level == 'Clouds')||($level == 'Sites')){
            $q_r    = $query->all();
            $total  = $query->count();                      
            foreach($q_r as $i){            
                $id         = $i->id;
                $alias      = $i->name;
                $lat        = $i->lat;
                $lng        = $i->lng;   
                $down_flag  = $this->_isSomethingDown($tree_level,$id);         
                array_push($items,[  
                    'id'        => $tree_level.'_'.$id, 
                    'name'      => $alias, 
                    'text'      => $alias,
                    'lat'       => $lat,
                    'lng'       => $lng,
                    'level'     => $tree_level,
                    'down_flag' => $down_flag
                    
                ]); 
            }     
        }
        
        if($level == 'Networks'){
        
            $network = $this->{'Networks'}->find()->where(['Networks.id' => $node_id])->first();
            if($network){
                $id         = $network->id;
                $alias      = $network->name;
                $lat        = $network->lat;
                $lng        = $network->lng;   
                $down_flag  = $this->_isSomethingDown($tree_level,$id);         
                array_push($items,[  
                    'id'        => $tree_level.'_'.$id, 
                    'name'      => $alias, 
                    'text'      => $alias,
                    'lat'       => $lat,
                    'lng'       => $lng,
                    'level'     => $tree_level,
                    'down_flag' => $down_flag
                    
                ]);      
            }        
        }
                                  
        $this->set(array(
            'items'     => $items,
            'total'     => $total,
            'metaData'  => $this->meta_data,
            'success'   => true
        ));
        $this->viewBuilder()->setOption('serialize', true);
    }
    
    public function mapNodeSave(){
    
        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        $req_q      = $this->request->getQuery();
        
        if(isset($req_q['id'])){
            $node       = $req_q['id'];
            $node_id    = preg_replace('/^(\w+)_/', '', $node);
            $level      = preg_replace('/_(\d+)/', '', $node);
            
            if($level == 'NodeMarker'){
                $lat = $req_q['lat'];
                $lng = $req_q['lng'];
                $node = $this->{'Nodes'}->find()->where(['Nodes.id' => $node_id])->first();
                if($node){
                    $this->{'Nodes'}->patchEntity($node,['lat' => $lat, 'lon' => $lng]);
                    $this->{'Nodes'}->save($node);
                }
            }
            
            if($level == 'ApMarker'){
                $lat = $req_q['lat'];
                $lng = $req_q['lng'];
                $ap = $this->{'Aps'}->find()->where(['Aps.id' => $node_id])->first();
                if($ap){
                    $this->{'Aps'}->patchEntity($ap,['lat' => $lat, 'lon' => $lng]);
                    $this->{'Aps'}->save($ap);
                }
            }     
                   
        }
      
        $this->set([
            'success'   => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }
      
    public function mapNodeDelete(){
    
        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        $req_q      = $this->request->getQuery();
        
        if(isset($req_q['id'])){
            $node       = $req_q['id'];
            $node_id    = preg_replace('/^(\w+)_/', '', $node);
            $level      = preg_replace('/_(\d+)/', '', $node);
            
            if($level == 'NodeMarker'){
                $node = $this->{'Nodes'}->find()->where(['Nodes.id' => $node_id])->first();
                if($node){
                    $this->{'Nodes'}->patchEntity($node,['lat' => null, 'lon' => null]);
                    $this->{'Nodes'}->save($node);
                }
            }
            
            if($level == 'ApMarker'){
                $ap = $this->{'Aps'}->find()->where(['Aps.id' => $node_id])->first();
                if($ap){
                    $this->{'Aps'}->patchEntity($ap,['lat' => null, 'lon' => null]);
                    $this->{'Aps'}->save($ap);
                }
            }   
                   
        }
      
        $this->set([
            'success'   => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }
    
    public function indexOnline(){

        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        
        
        $tree_level = $this->tree_level_0;     
        $l_model    = $this->main_model;
        $c_model    = $this->tree_level_1;
        $node       = null;
        
        $tt_level   = 0;
        $conditions = [];
        $req_q      = $this->request->getQuery(); 
        
        
        if(isset($req_q['node'])){
            $node       = $req_q['node'];
            $node_id    =  preg_replace('/^(\w+)_/', '', $node);
            $level      =  preg_replace('/_(\d+)/', '', $node);         
            if($level == 'Clouds'){
                $l_model    = $this->tree_level_1; //Sites
                $tree_level = $this->tree_level_1; //Sites
                $c_model    = $this->tree_level_2;
                $cloud_id   = $node_id;
                $conditions = ['Sites.cloud_id' => $cloud_id];
                $tt_level   = 1;
            }
                  
            if($level == 'Sites'){
                $l_model    = $this->tree_level_2; //Networks
                $tree_level = $this->tree_level_2; //Networks
                $site_id    = $node_id;
                $conditions = ['Networks.site_id' => $site_id];
                $tt_level   = 2;
            }
        }
        
        $query  = $this->{$l_model }->find();
        
        if($level == 'root'){
            $this->CommonQueryFlat->build_simple_cloud_query($query, $user); //AP QUERY is sort of different in a way
        }else{
            $query->where($conditions);
        }
         
        $q_r    = $query->all();
        $total  = $query->count();
        
        
        if($tt_level ==0){
            $icon_cls = $this->cls_level_0;
        }
        
        if($tt_level ==1){
            $icon_cls = $this->cls_level_1;
        }
        
        if($tt_level ==2){
            $icon_cls = $this->cls_level_2;
        }

        $items = [];
        foreach($q_r as $i){

            $id         = $i->id;
            $parent_id  = $node;
            $alias      = $i->name;
            $lat        = $i->lat;
            $lng        = $i->lng;
            
            $leaf       = true;
            $child_find = ['Sites.cloud_id' => $id];
            
            if($level == 'Clouds'){
                $child_find = ['Networks.site_id' => $id];
            }
            if(($tree_level == 'root')||($tree_level == 'Clouds')||($tree_level == 'Sites')){
                $children = $this->{$c_model}->find()->where($child_find)->count();
                
                if($children >0){
                    $leaf       = false;
                }
            }
            
            $down_flag = $this->_isSomethingDown($tree_level,$id);
            $cls = "txtGreen";
            if($down_flag){
                $cls = "txtOrange";  
            }

            if(isset($req_q['location'])){
                if($req_q['location'] == 'map'){
                    if(($lat == null)||($lng == null)){
                        $cls = "txtOrange";
                    }
                }
            }
                     
            array_push($items,[
                'id'        => $tree_level.'_'.$id, 
                'name'      => $alias, 
                'text'      => $alias, 
                'cls'       => $cls,
                'parent_id' => $parent_id,
                'leaf'      => $leaf,
                'iconCls'   => "$icon_cls $cls",
                'tree_level'=> $tree_level
            ]); 
        }
            
        $this->set(array(
            'items' => $items,
            'total' => $total,
            'success' => true
        ));
        $this->viewBuilder()->setOption('serialize', true);
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
		
        
        $tree_level = $this->tree_level_0;     
        $l_model    = $this->main_model;
        $c_model    = $this->tree_level_1;
        $node       = null;
        
        $tt_level   = 0;
        $conditions = [];
        
        
        if(isset($req_q['node'])){
            $node       = $req_q['node'];
            $node_id    =  preg_replace('/^(\w+)_/', '', $node);
            $level      =  preg_replace('/_(\d+)/', '', $node);         
            if($level == 'Clouds'){
                $l_model    = $this->tree_level_1; //Sites
                $tree_level = $this->tree_level_1; //Sites
                $c_model    = $this->tree_level_2;
                $cloud_id   = $node_id;
                $conditions = ['Sites.cloud_id' => $cloud_id];
                $tt_level   = 1;
            }
                  
            if($level == 'Sites'){
                $l_model    = $this->tree_level_2; //Networks
                $tree_level = $this->tree_level_2; //Networks
                $site_id    = $node_id;
                $conditions = ['Networks.site_id' => $site_id];
                $tt_level   = 2;
            }
        }
        
        $query  = $this->{$l_model }->find();
        
        if($level == 'root'){
        	
        	//ap group filter on user_id / admin group no filter
        	if($user['group_name'] == Configure::read('group.ap')){       		
				$clouds_OR_list		= [['Clouds.user_id' => $user_id]]; //This is the basic search item
				$q_ca = $this->{'CloudAdmins'}->find()->where(['CloudAdmins.user_id'=>$user_id])->all();//The access provider (ap) might also be admin to other clouds
				foreach($q_ca as $e_ca){
					array_push($clouds_OR_list,['Clouds.id' => $e_ca->cloud_id]);
				}      	
        		$query  = $this->{'Clouds'}->find();
    			$query->where(['OR' => $clouds_OR_list]);
        	}        	      	
        	$query->contain(['Users']); //Pull in the Users and Cloud Admins for clouds (root level) 	     	       	     	
       
        }else{
            $query->where($conditions);
        }
         
        $q_r    = $query->order([$l_model.'.name' => 'ASC'])->all();
        $total  = $query->count();
        
        if($tt_level ==0){
            $icon_cls = $this->cls_level_0;
        }
        
        if($tt_level ==1){
            $icon_cls = $this->cls_level_1;
        }
        
        if($tt_level ==2){
            $icon_cls = $this->cls_level_2;
        }

        $items = [];
        foreach($q_r as $i){
        
            $id         = $i->id;
            $parent_id  = $node;
            $alias      = $i->name;
            $lat        = $i->lat;
            $lng        = $i->lng;          
            $owner_id   = false;
            $owner      = null;
            $admin_rights		= null;
            $view_rights		= null;
            $cloud_id	= null;
              
            if($level == 'root'){         
                $owner_id 	= $i->user_id;
                if($owner_id == $user_id){
               		$owner 		= $i->user->username." (me)";
                }else{
                	$owner 		= $i->user->username;
                }
                $cloud_id = $i->id;
            }
            
            if($level == 'Clouds'){
                $cloud_id = $i->cloud_id;
                $ent_cloud = $this->{'Clouds'}->find()->where(['id' => $cloud_id])->first();
                if($ent_cloud){
                    $owner_id = $ent_cloud->user_id;    
                } 
            }
            
            if($level == 'Sites'){
                $site_id = $i->site_id;
                $ent_site = $this->{'Sites'}->find()->where(['id' => $site_id])->first();
                if($ent_site){
                    $cloud_id = $ent_site->cloud_id;
                    $ent_cloud = $this->{'Clouds'}->find()->where(['id' => $cloud_id])->first();
                    if($ent_cloud){
                        $owner_id = $ent_cloud->user_id;    
                    }     
                }           
            }
            
            $action_flags = [];
            $action_flags['update'] = true;
		    $action_flags['delete'] = true; 
		             
            $created_in_words   = $this->TimeCalculations->time_elapsed_string($i->{'created'});
            $modified_in_words  = $this->TimeCalculations->time_elapsed_string($i->{'modified'});

            $leaf       = true;
            $child_find = ['Sites.cloud_id' => $id];
            
            if($level == 'Clouds'){
                $child_find = ['Networks.site_id' => $id];
            }
            if(($tree_level == 'root')||($tree_level == 'Clouds')||($tree_level == 'Sites')){
                $children = $this->{$c_model}->find()->where($child_find)->count();
                
                if($children >0){
                    $leaf       = false;
                }
            }
                      
            if($tree_level == 'Clouds'){    
                $owner_id = $i->user_id;
            }
               
            array_push($items,[
                'id'        => $tree_level.'_'.$id,
                'cloud_id'	=> $cloud_id,
                'name'      => $alias, 
                'text'      => $alias, 
                'owner'     => $owner,
                'parent_id' => $parent_id,
                'leaf'      => $leaf,
                'lat'       => $lat,
                'lng'       => $lng,
                'iconCls'   => "$icon_cls txtM3",
                'tree_level'=> $tree_level,
                'created'   => $i->{'created'},
                'modified'  => $i->{'modified'},
                'created_in_words'   => $created_in_words,
                'modified_in_words'  => $modified_in_words,
                'update'    => true,
			    'delete'    => true
            ]); 
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
        
        $data   = $this->request->getQuery();
        
        $cloud_id=false; 
        
        if(isset($data['edit_cloud_id'])){
        	$edit_cloud_id = $data['edit_cloud_id'];
    		if(preg_match("/^Clouds_/", $edit_cloud_id)){
				$cloud_id = preg_replace('/^Clouds_/', '', $edit_cloud_id);
			}
    	}
    	$qr = [];
    	if($cloud_id){    	
    		$qr = $this->{'Clouds'}->find()->where(['Clouds.id' => $cloud_id])->first();    	
    	}           
    	$this->set([
    		'data'	=> $qr,
            'success' => true
        ]);
     	$this->viewBuilder()->setOption('serialize', true);
    
    }
    
    public function add(){
 
        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        
        $user_id    = $user['id'];
    
        if ($this->request->is('post')) {
        
        	$data 				= $this->request->getData(); 
        	$data['user_id'] 	= $user_id;
        	  
            $l_model    = $this->main_model;   
            $node       = $data['parent_id'];
            $node_id    = preg_replace('/^(\w+)_/', '', $node);
            $level      = preg_replace('/_(\d+)/', '', $node);        
            
            if($level == 'Clouds'){
                $l_model 			=  $this->tree_level_1; //Sites
                $data['cloud_id'] 	= $node_id;
            }
            
            if($level == 'Sites'){
                $l_model 			=  $this->tree_level_2; //Networks 
                $data['site_id'] 	= $node_id; 
            } 
            
            $entity = $this->{$l_model}->newEntity($data); 
            if ($this->{$l_model}->save($entity)) {
                $this->set([
                    'success' 	=> true,
                    'data'		=> $entity
                ]);
                $this->viewBuilder()->setOption('serialize', true);
            } else {
                $message = __('Could not update item');
                $this->JsonErrors->entityErros($entity,$message);
            }    
        }
    }
      
    public function saveCloud(){

        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        $req_d		= $this->request->getData();       
        if ($this->request->is('post')) { 
            $level 		= 'Clouds';    
            $node_id 	= $req_d['id'];          
            $entity 	= $this->{$level}->find()->where(['id' =>$node_id])->first();            
            if($entity){
                $this->{$level}->patchEntity($entity, $req_d); 
                if ($this->{$level}->save($entity)) {                		          	                
                    $this->set([
                        'success' 	=> true
                    ]);
                    $this->viewBuilder()->setOption('serialize', true);
                } else {
                    $message = __('Could not update item');
                    $this->JsonErrors->entityErros($entity,$message);
                }   
            }
        }
    }
        
    public function edit(){

        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        $req_d		= $this->request->getData();

        if ($this->request->is('post')) { 
            $node       = $req_d['id'];
            $node_id    = preg_replace('/^(\w+)_/', '', $node);
            $level      = preg_replace('/_(\d+)/', '', $node);
            
            if($level == 'Sites'){
                unset($req_d['cloud_id']); //Else it overrides the parent 
            }
            
            $req_d['id'] = $node_id;           
            $entity = $this->{$level}->find()->where(['id' =>$node_id])->first();
            
            if($entity){
                $this->{$level}->patchEntity($entity, $req_d); 
                if ($this->{$level}->save($entity)) {
                		          	                
                    $this->set([
                        'success' => true,
                        'data'	  => $entity	
                    ]);
                    $this->viewBuilder()->setOption('serialize', true);
                } else {
                    $message = __('Could not update item');
                    $this->JsonErrors->entityErros($entity,$message);
                }   
            }
        }
    }
   
    public function delete(){
    /*
        if(!$this->Aa->admin_check($this)){   //Only for admin users!
            return;
        } 
        */
        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        $req_d		= $this->request->getData();

        if(isset($req_d['id'])){   //Single item delete
            $node       =  $req_d['id'];
            $node_id    =  preg_replace('/^(\w+)_/', '', $node);
            $level      =  preg_replace('/_(\d+)/', '', $node);                 
            $entity = $this->{$level}->find()->where(['id' => $node_id])->first(); 
            if($entity){
                $this->{$level}->delete($entity);
            }
        }
        $this->set(array(
            'success' => true
        ));
        $this->viewBuilder()->setOption('serialize', true);
    }
    
    public function mapDelete(){
        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        $req_q    = $this->request->getQuery();
        
        if(isset($req_q['id'])){    
            $node       =  $req_q['id'];
            $node_id    =  preg_replace('/^(\w+)_/', '', $node);
            $level      =  preg_replace('/_(\d+)/', '', $node);                 
            $entity     = $this->{$level}->get($node_id);
            $lat        = null;
            $lng        = null;
            $this->{$level}->patchEntity($entity,['lat' => $lat,'lng' => $lng]);
            $this->{$level}->save($entity);    
        }
        $this->set(array(
            'success' => true
        ));
        $this->viewBuilder()->setOption('serialize', true);  
    }
    
    
    public function mapOverviewDelete(){
        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        
        $req_q    = $this->request->getQuery();
        
        if(isset($req_q['id'])){    
            $node       =  $req_q['id'];
            $node_id    =  preg_replace('/^(\w+)_/', '', $node);
            $level      =  preg_replace('/_(\d+)/', '', $node);                 
            $entity     = $this->{$level}->get($node_id);
            $lat        = null;
            $lng        = null;
            $this->{$level}->patchEntity($entity,['lat' => $lat,'lng' => $lng]);
            $this->{$level}->save($entity);
            
            if($level == $this->tree_level_0){
                //Sites
                $site_ids   = [];
                $sites      = $this->{'Sites'}->find()->where(['Sites.cloud_id' => $node_id]);
                foreach($sites as $s){
                    array_push($site_ids,$s->id);
                    $this->{'Sites'}->patchEntity($s,['lat' => $lat,'lng' => $lng]);
                    $this->{'Sites'}->save($s);
                }
                //networks
                $network_ids    = [];
                $networks       = $this->{'Networks'}->find()->where(['Networks.site_id IN' => $site_ids]);
                foreach($networks as $n){
                    array_push($network_ids,$n->id);
                    $this->{'Networks'}->patchEntity($n,['lat' => $lat,'lng' => $lng]);
                    $this->{'Networks'}->save($n);
                }    
            }
            
            if($level == $this->tree_level_1){
                //networks
                $network_ids    = [];
                $networks       = $this->{'Networks'}->find()->where(['Networks.site_id' => $node_id]);
                foreach($networks as $n){
                    array_push($network_ids,$n->id);
                    $this->{'Networks'}->patchEntity($n,['lat' => $lat,'lng' => $lng]);
                    $this->{'Networks'}->save($n);
                }    
            }
                
        }
        $this->set(array(
            'success' => true
        ));
        $this->viewBuilder()->setOption('serialize', true);  
    }
    
    public function mapOverviewSave(){
        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        
        $req_q    = $this->request->getQuery();
        
        if(isset($req_q['id'])){
            if((isset($req_q['lat']))&&(isset($req_q['lng']))){      
                $node       =  $req_q['id'];
                $node_id    =  preg_replace('/^(\w+)_/', '', $node);
                $level      =  preg_replace('/_(\d+)/', '', $node);                 
                $entity     = $this->{$level}->get($node_id);
                $lat        = $req_q['lat'];
                $lng        = $req_q['lng'];
                $this->{$level}->patchEntity($entity,['lat' => $lat,'lng' => $lng]);
                $this->{$level}->save($entity); 
                
                //IF $level is Clouds; find al the sites and networks who has lat or lng set to null and implicitly also put them on the map
                if($level == $this->tree_level_0){
                    //Sites
                    $site_ids   = [];
                    $sites      = $this->{'Sites'}->find()->where(['Sites.cloud_id' => $node_id,'Sites.lat IS NULL']);
                    foreach($sites as $s){
                        array_push($site_ids,$s->id);
                        $this->{'Sites'}->patchEntity($s,['lat' => $lat,'lng' => $lng]);
                        $this->{'Sites'}->save($s);
                    }
                    //networks
                    $network_ids    = [];
                    $networks       = $this->{'Networks'}->find()->where(['Networks.site_id IN' => $site_ids,'Networks.lat IS NULL']);
                    foreach($networks as $n){
                        array_push($network_ids,$n->id);
                        $this->{'Networks'}->patchEntity($n,['lat' => $lat,'lng' => $lng]);
                        $this->{'Networks'}->save($n);
                    }    
                }
                
                if($level == $this->tree_level_1){
                    //networks
                    $network_ids    = [];
                    $networks       = $this->{'Networks'}->find()->where(['Networks.site_id' => $node_id,'Networks.lat IS NULL']);
                    foreach($networks as $n){
                        array_push($network_ids,$n->id);
                        $this->{'Networks'}->patchEntity($n,['lat' => $lat,'lng' => $lng]);
                        $this->{'Networks'}->save($n);
                    }    
                }
                
                              
            } 
        }
        
        $this->set([
            'success'       => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }  
    
    public function mapSave(){
        $user = $this->Aa->user_for_token($this);
        if(!$user){   //If not a valid user
            return;
        }
        
        $req_q    = $this->request->getQuery();
        
        if(isset($req_q['id'])){
            if((isset($req_q['lat']))&&(isset($req_q['lng']))){      
                $node       =  $req_q['id'];
                $node_id    =  preg_replace('/^(\w+)_/', '', $node);
                $level      =  preg_replace('/_(\d+)/', '', $node);                 
                $entity     = $this->{$level}->get($node_id);
                $lat        = $req_q['lat'];
                $lng        = $req_q['lng'];
                $this->{$level}->patchEntity($entity,['lat' => $lat,'lng' => $lng]);
                $this->{$level}->save($entity);      
            } 
        }
        
        $this->set([
            'success'       => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    } 
    private function _meta_data_for_level_and_id($level,$id,$tt_level){
        $config_level = $tt_level-1;
        if($level == '0'){  
            $this->meta_data['text']    = '** ALL CLOUDS **';
            $this->meta_data['fa_icon'] = 'home';
            $this->meta_data['level']   = $config_level;
            $this->meta_data['level_name']   = 'HOME';
        }else{
        
            $contain = [];
            if($level == 'Networks'){
                $contain = ['Sites' => ['Clouds']];
            }
            if($level == 'Sites'){
                $contain = ['Clouds'];
            }
            $qr = $this->{$level}->find()->where([$level.'.id' => $id])->contain($contain)->first();
            
            if($qr){
                if($level == 'Networks'){
                    $this->meta_data['site']  =    $qr->site->name;
                    $this->meta_data['cloud'] =    $qr->site->cloud->name;  
                }
                if($level == 'Sites'){
                    $this->meta_data['cloud'] =    $qr->cloud->name;  
                }
                $this->meta_data['text']        = $qr->name;
                $this->meta_data['level_name']  = $this->{'tree_level_'.$config_level};
                $this->meta_data['fa_icon']     = preg_replace('/.*fa-/', '', $this->{'cls_level_'.$config_level});
                $this->meta_data['level']       = $config_level;            
            }   
        }
    }
    
    private function _fetchLevelStats($user,$level,$id){
    
        $ret_arr        = [];
        $network_ids    = [0];
        
        if($level == "0"){ //Root level
            $query  = $this->{'Clouds'}->find();
            $this->CommonQueryFlat->build_simple_cloud_query($query, $user); //AP QUERY is sort of different in a way
            
            //Clouds
            $clouds     = $query->all();
            $cloud_ids  = [];
            $cloud_count= 0;
            foreach($clouds as $c){
                $cloud_count = $cloud_count+1;
                array_push($cloud_ids,$c->id);                
            }
            
            array_push($ret_arr,[
                "name"      => $this->tree_level_0,
                "fa_icon"   => preg_replace('/.*fa-/', '', $this->{'cls_level_0'}),
                "count"     => $cloud_count
            ]);
            
            //Sites
            $site_ids   = [];
            $site_count = 0;
            
            if($cloud_count > 0){
                $sites  = $this->{'Sites'}->find()->where(['cloud_id IN' => $cloud_ids])->all();
                foreach($sites as $s){
                    $site_count = $site_count+1;
                    array_push($site_ids,$s->id);                 
                } 
            }
            
            array_push($ret_arr,[
                "name"      => $this->tree_level_1,
                "fa_icon"   => preg_replace('/.*fa-/', '', $this->{'cls_level_1'}),
                "count"     => $site_count
            ]);
            
            //Networks
            $network_ids   = [0];
            $network_count = 0;
            if($site_count > 0){
                $networks  = $this->{'Networks'}->find()->where(['site_id IN' => $site_ids])->all();
                foreach($networks as $n){
                    $network_count = $network_count+1;
                    array_push($network_ids,$n->id);  
                }  
            }
            
            array_push($ret_arr,[
                "name"      => $this->tree_level_2,
                "fa_icon"   => preg_replace('/.*fa-/', '', $this->{'cls_level_2'}),
                "count"     => $network_count
            ]);       
        }
        
        if($level == $this->tree_level_0){ //Sites for Cloud
            $site_ids   = [];
            $site_count = 0;
            $sites  = $this->{'Sites'}->find()->where(['cloud_id' => $id])->all();
            foreach($sites as $s){
                $site_count = $site_count+1;
                array_push($site_ids,$s->id);                 
            } 
            array_push($ret_arr,[
                "name"      => $this->tree_level_1,
                "fa_icon"   => preg_replace('/.*fa-/', '', $this->{'cls_level_1'}),
                "count"     => $site_count
            ]);
            
            //Networks
            $network_ids   = [0];
            $network_count = 0;
            if($site_count > 0){
                $networks  = $this->{'Networks'}->find()->where(['site_id IN' => $site_ids])->all();
                foreach($networks as $n){
                    $network_count = $network_count+1;
                    array_push($network_ids,$n->id);  
                }  
            }
         
            array_push($ret_arr,[
                "name"      => $this->tree_level_2,
                "fa_icon"   => preg_replace('/.*fa-/', '', $this->{'cls_level_2'}),
                "count"     => $network_count
            ]);       
         }     
         
        if($level == $this->tree_level_1){ //Networks for Site
            //Networks
            $network_ids    = [0];
            $network_count  = 0;
            $networks       = $this->{'Networks'}->find()->where(['site_id' => $id])->all();
            foreach($networks as $n){
                $network_count = $network_count+1;
                array_push($network_ids,$n->id);  
            } 
            array_push($ret_arr,[
                "name"      => $this->tree_level_2,
                "fa_icon"   => preg_replace('/.*fa-/', '', $this->{'cls_level_2'}),
                "count"     => $network_count
            ]);       
        }
        
        if($level == $this->tree_level_2){ //Networks for Site
            $network_ids    = [];
            array_push($network_ids,$id);
        }       
    
        $this->network_ids = $network_ids;                
        return $ret_arr;
    }
    
    private function _isSomethingDown($level,$id){
    
        $something_down = false;
        
        $now            = FrozenTime::now();
        $dead_after     = $this->_getDefaultDeadAfter();      
        $cut_off        = $now->subSecond($dead_after);       
        $tree_tag_ids   = $this->_getTreeTagIds($level,$id);    

        $meshes_where   = ['tree_tag_id IN' => $tree_tag_ids,'Meshes.enable_overviews' => 1]; 
        $meshes         = $this->{'Meshes'}->find()->select(['id'])->where($meshes_where)->all();
        $node_mesh_ids  = [];
        foreach($meshes as $mesh){ 
            array_push($node_mesh_ids,$mesh->id);      
        }
        $nodes_count    = 0;
        $nodes_online   = 0;
        if(count($node_mesh_ids)>0){
            $nodes_count = $this->{'Nodes'}->find()->where(['mesh_id IN' => $node_mesh_ids,'Nodes.enable_overviews' => 1])->count();
            $nodes_online = $this->{'Nodes'}->find()->where(['mesh_id IN' => $node_mesh_ids,'last_contact >=' => $cut_off,'Nodes.enable_overviews' => 1])->count();
        }
        
        if($nodes_count > 0){
            if($nodes_online < $nodes_count){
                $something_down = true;
            }   
        }
        
        $aps_count      = $this->{'Aps'}->find()->where(['tree_tag_id IN' => $tree_tag_ids,'Aps.enable_overviews' => 1])->count();
        $aps_online     = $this->{'Aps'}->find()->where(['tree_tag_id IN' => $tree_tag_ids,'last_contact >=' => $cut_off,'Aps.enable_overviews' => 1])->count();
        
        if($aps_count > 0){
            if($aps_online < $aps_count){
                $something_down = true;
            }   
        } 
        return $something_down;
    }
    
    //This will get a list of network ids (tree_tag_ids) for the specified $leven and $id //Root = 0,0
    private function _getTreeTagIds($level,$id){

        $tree_tag_ids = [0]; //Put 0 by default else query fails
    
        if(($level == 0)&&($id == 0)){ //Root Node; get everything
            
        }
                    
        if($level == $this->tree_level_0){ //Clouds      
            $conditions = ['Sites.cloud_id' => $id];     
            $sites      = $this->{'Sites'}->find()->where($conditions)->all();
            $site_ids   = [];
            
            foreach($sites as $s){
                array_push($site_ids,$s->id);
            }

            if(count($site_ids)>0){
                $networks       = $this->{'Networks'}->find()->where(['Networks.site_id IN' => $site_ids])->all();
               // if($networks){
                    $tree_tag_ids = [];
                    foreach($networks as $n){
                        array_push($tree_tag_ids,$n->id);
                    }
              //  }    
            }            
        }
                 
        if($level == $this->tree_level_1){ //Sites       
            $conditions = ['Networks.site_id' => $id];
            $networks = $this->{'Networks'}->find()->where($conditions)->all();
            if(count($networks)>0){
                $tree_tag_ids = [];
                foreach($networks as $n){
                    array_push($tree_tag_ids,$n->id);
                }
            }
                    
        }
        
        if($level == $this->tree_level_2){ //Networks (This one does not need extra queries)
            $tree_tag_ids = [$id];   
        }
        
        return $tree_tag_ids; 
    }
    
    private function _infoBuilding(){    
        $nodes_count    = 0;
        $meshes_count   = 0;
        $tree_tag_ids   = $this->network_ids;
        //Mesh Count     
        $meshes_where = ['tree_tag_id IN' => $tree_tag_ids,'Meshes.enable_overviews' => 1];
        $meshes_count = $this->{'Meshes'}->find()->where($meshes_where)->count();
        
        $ft_day = FrozenTime::now();
        $cut_off = $ft_day->subDay(1);
        
        if($this->timespan == 'now'){
            $dead_after = $this->_getDefaultDeadAfter();      
            $cut_off    = $ft_day->subSecond($dead_after);
        }  
        
        if($this->timespan == 'daily'){
            $cut_off = $ft_day->subDay(1);
        }         
        if($this->timespan == 'weekly'){
            $cut_off = $ft_day->subDay(7);
        }
        if($this->timespan == 'monthly'){
            $cut_off = $ft_day->subDay(30);
        }
        $meshes_online = $this->{'Meshes'}->find()
            ->where(['tree_tag_id IN' => $tree_tag_ids,'last_contact >=' => $cut_off,'Meshes.enable_overviews' => 1])
            ->count();         
        //Node Count
        $meshes         = $this->{'Meshes'}->find()->select(['id'])->where($meshes_where)->all();
        $node_mesh_ids  = [];
        foreach($meshes as $mesh){ 
            array_push($node_mesh_ids,$mesh->id);      
        }
        $nodes_count    = 0;
        $nodes_online   = 0;
        if(count($node_mesh_ids)>0){
            $nodes_count = $this->{'Nodes'}->find()->where(['mesh_id IN' => $node_mesh_ids,'Nodes.enable_overviews' => 1])->count();
            $nodes_online = $this->{'Nodes'}->find()->where(['mesh_id IN' => $node_mesh_ids,'last_contact >=' => $cut_off,'Nodes.enable_overviews' => 1])->count();
        }
        
        $aps_count      = $this->{'Aps'}->find()->where(['tree_tag_id IN' => $tree_tag_ids,'Aps.enable_overviews' => 1])->count();
        $aps_online     = $this->{'Aps'}->find()->where(['tree_tag_id IN' => $tree_tag_ids,'last_contact >=' => $cut_off,'Aps.enable_overviews' => 1])->count();
                
        $this->meta_data['total_networks']          = $meshes_count;
        $this->meta_data['total_networks_online']   = $meshes_online;
        $this->meta_data['total_nodes']             = $nodes_count;  
        $this->meta_data['total_nodes_online']      = $nodes_online;
        $this->meta_data['total_aps']               = $aps_count; 
        $this->meta_data['total_aps_online']        = $aps_online;     
    }
    
    private function _getDefaultDeadAfter(){   
        $this->loadModel('UserSettings');   
        $q_r = $this->{'UserSettings'}->find()->where(['user_id' => -1])->all();
        $dead_after = 900;
        if($q_r){
            foreach($q_r as $s){
                //ALL Captive Portal Related default settings will be 'cp_<whatever>'
                if(preg_match('/^cp_/',$s->name)){
                    $name           = preg_replace('/^cp_/', '', $s->name);
                    $data[$name]    = $s->value;     
                }               
                if($s->name == 'heartbeat_dead_after'){
                    $dead_after = $s->value;
                } 
            }
        }
        return $dead_after;
    }
    
    private function _getHourlyGraph($ft_now){
        $items          = [];
        $start          = 0;
        $hour_end       = $ft_now;   
        $slot_start     = $ft_now->subHour(1); 
        $table          = 'NodeStations';
        
        $grand_start    = $slot_start;
        $grand_end      = $ft_now;
  
        $tree_tag_ids   = $this->network_ids; 
        if(count($tree_tag_ids)==0){
            $tree_tag_ids = [0];
        }    
        $nodes_list     = [0];
        
        if($this->graph_item == 'mesh'){
            $meshes_where = ['Meshes.tree_tag_id IN' => $tree_tag_ids,'Nodes.enable_overviews' => 1];
            $nodes = $this->{'Nodes'}->find()->where($meshes_where)->contain('Meshes')->all();
            foreach($nodes as $n){
                array_push($nodes_list,$n->id);
            }
            $base_search = ['node_id IN' => $nodes_list];
        }
                    
        $aps_list       = [0];
        if(($this->graph_item == 'ap')||($this->graph_item == 'ap_device')){
            $table = 'ApStations';
            $aps_where = ['Aps.tree_tag_id IN' => $tree_tag_ids,'Aps.enable_overviews' => 1];
            $aps = $this->{'Aps'}->find()->where($aps_where)->all();
            foreach($aps as $a){
                array_push($aps_list,$a->id);
            }
            $base_search = ['ap_id IN' => $aps_list];
        }
        
        while($slot_start < $hour_end){
            $slot_start_h_m = $slot_start->i18nFormat("E\nHH:mm",$this->time_zone);
            $slot_end       = $slot_start->addMinute(10)->subSecond(1);  
            $where          = $base_search;
            array_push($where, ["modified >=" => $slot_start]);
            array_push($where, ["modified <=" => $slot_end]);   
            $slot_start     = $slot_start->addMinute(10); 
            $q_r            = $this->{$table}->find()->select($this->fields)->where($where)->first();

            if($q_r){
                $d_in   = $q_r->data_in;
                $d_out  = $q_r->data_out;
                array_push($items, ['id' => $start, 'time_unit' => $slot_start_h_m, 'data_in' => $d_in, 'data_out' => $d_out,'slot_start_txt' => $slot_start_h_m]);
            }
            $start++;
        }
        
        //Total Data
        $where          = $base_search;
        array_push($where, ["modified >=" => $grand_start]);
        array_push($where, ["modified <=" => $grand_end]);    
        $q_r = $this->{$table}->find()->select($this->fields)->where($where)->first();
        $data_grand_total   = 0;
        $data_in            = 0;
        $data_out           = 0;
        if($q_r->data_in){
            $data_grand_total   = $q_r->data_in+$q_r->data_out;
            $data_in            = $q_r->data_in;
            $data_out           = $q_r->data_out;
        }
        $users_grand_total = $this->{$table}->find()->distinct(['mac_address_id'])->where($where)->count();
        
        if($this->graph_item == 'mesh'){
            $this->mesh_data_total  = $data_grand_total;
            $this->mesh_data_in     = $data_in;
            $this->mesh_data_out    = $data_out;
            $this->mesh_user_total  = $users_grand_total;
        }
        
        if($this->graph_item == 'ap'){
            $this->ap_data_total    = $data_grand_total;
            $this->ap_data_in       = $data_in;
            $this->ap_data_out      = $data_out;
            $this->ap_user_total    = $users_grand_total;
        }     
        return(['items' => $items]);
    }
          
    private function _getDailyGraph($ft_now){
    
        $items          = [];
        $start          = 0;
        $day_end        = $ft_now;//->i18nFormat('yyyy-MM-dd HH:mm:ss');    
        $slot_start     = $ft_now->subHour(24);
        $slot_start     = $slot_start->minute(00);
        
        $grand_start    = $slot_start;
        $grand_end      = $ft_now;
         
        $table          = 'NodeStations';
        
        $tree_tag_ids   = $this->network_ids;
        if(count($tree_tag_ids)==0){
            $tree_tag_ids = [0];
        }        
        $nodes_list     = [0];
        
        if($this->graph_item == 'mesh'){
            $meshes_where = ['Meshes.tree_tag_id IN' => $tree_tag_ids,'Nodes.enable_overviews' => 1];
            $nodes = $this->{'Nodes'}->find()->where($meshes_where)->contain('Meshes')->all();
            foreach($nodes as $n){
                array_push($nodes_list,$n->id);
            }
            $base_search = ['node_id IN' => $nodes_list];
        }
        
        $aps_list       = [0];
        if(($this->graph_item == 'ap')||($this->graph_item == 'ap_device')){
            $table = 'ApStations';
            $aps_where = ['Aps.tree_tag_id IN' => $tree_tag_ids,'Aps.enable_overviews' => 1];
            $aps = $this->{'Aps'}->find()->where($aps_where)->all();
            foreach($aps as $a){
                array_push($aps_list,$a->id);
            }
            $base_search = ['ap_id IN' => $aps_list];
        }       
        
        while($slot_start < $day_end){  
            $slot_start_h_m = $slot_start->i18nFormat("E\nHH:mm",$this->time_zone);
            $slot_end       = $slot_start->addHour(1)->subSecond(1);   
            $where          = $base_search;
            array_push($where, ["modified >=" => $slot_start]);
            array_push($where, ["modified <=" => $slot_end]);    
            $slot_start     = $slot_start->addHour(1);
             
            $dataIn         = 0;
            $dataOut        = 0;
            
            //-- Raw---
            $stations  = $this->{$table}->find()->select($this->fields)->where($where)->first();        
            if($stations){
                $dataIn = $dataIn + $stations->data_in;
                $dataOut= $dataOut + $stations->data_out;                          
            }
            
            //--Hourlies--
            if($table == 'NodeStations'){
                $tHourlies = 'NodeStationHourlies';
            }
            if($table == 'ApStations'){
                $tHourlies = 'ApStationHourlies';
            }
            $stations_h  = $this->{$tHourlies}->find()->select($this->fields)->where($where)->first();        
            if($stations_h){
                $dataIn = $dataIn + $stations_h->data_in;
                $dataOut= $dataOut + $stations_h->data_out;                          
            }                       
            array_push($items, ['id' => $start, 'time_unit' => $slot_start_h_m, 'data_in' => $dataIn, 'data_out' => $dataOut]);     
            $start++;
        }
        
        //Total Data
        $where          = $base_search;
        array_push($where, ["modified >=" => $grand_start]);
        array_push($where, ["modified <=" => $grand_end]);    
        //--RAW--  
        $q_r = $this->{$table}->find()->select($this->fields)->where($where)->first();
        $data_grand_total   = 0;
        $data_in            = 0;
        $data_out           = 0;
        if($q_r->data_in){
            $data_grand_total   = $data_grand_total+$q_r->data_in+$q_r->data_out;
            $data_in            = $data_in+$q_r->data_in;
            $data_out           = $data_out+$q_r->data_out;
        }
        //$users_grand_total = $this->{$table}->find()->distinct(['mac_address_id'])->where($where)->count();
        
        //--Hourlies--
        if($table == 'NodeStations'){
            $tHourlies = 'NodeStationHourlies';
        }
        if($table == 'ApStations'){
            $tHourlies = 'ApStationHourlies';
        }
        $q_hourlies = $this->{$tHourlies}->find()->select($this->fields)->where($where)->first();
        if($q_hourlies->data_in){
            $data_grand_total   = $data_grand_total+$q_hourlies->data_in+$q_hourlies->data_out;
            $data_in            = $data_in+$q_hourlies->data_in;
            $data_out           = $data_out+$q_hourlies->data_out;
        }
        $users_grand_total = $this->{$tHourlies}->find()->distinct(['mac_address_id'])->where($where)->count(); //FIXME This can be more accurate but will create performance knock       
        
        if($this->graph_item == 'mesh'){
            $this->mesh_data_total  = $data_grand_total;
            $this->mesh_data_in     = $data_in;
            $this->mesh_data_out    = $data_out;
            $this->mesh_user_total = $users_grand_total;
        }
        
        if($this->graph_item == 'ap'){
            $this->ap_data_total    = $data_grand_total;
            $this->ap_data_in       = $data_in;
            $this->ap_data_out      = $data_out;
            $this->ap_user_total = $users_grand_total;
        }     
        
        return(['items' => $items]);
    }
    
     private function _getWeeklyGraph($ft_day){

        $items          = [];  
        $slot_start     = $ft_day->startOfWeek(); //Prime it 
        $count          = 0;
        $week_end       = $ft_day;
          
        //$slot_start     = $ft_day->subHour(24*7);
        $slot_start     = $ft_day->subHour(24*7)->hour(00)->minute(00)->second(00);
        $slot_start     = $slot_start->minute(00);
        $table          = 'NodeStations';
        
        $grand_start    = $slot_start;
        $grand_end      = $ft_day;
        
        $tree_tag_ids   = $this->network_ids;
        if(count($tree_tag_ids)==0){
            $tree_tag_ids = [0];
        }        
        $nodes_list     = [0];
        
        if($this->graph_item == 'mesh'){
            $meshes_where = ['Meshes.tree_tag_id IN' => $tree_tag_ids,'Nodes.enable_overviews' => 1];
            $nodes = $this->{'Nodes'}->find()->where($meshes_where)->contain('Meshes')->all();
            foreach($nodes as $n){
                array_push($nodes_list,$n->id);
            }
            $base_search = ['node_id IN' => $nodes_list];
        }      
        
        $aps_list       = [0];
        if(($this->graph_item == 'ap')||($this->graph_item == 'ap_device')){
            $table = 'ApStations';
            $aps_where = ['Aps.tree_tag_id IN' => $tree_tag_ids,'Aps.enable_overviews' => 1];
            $aps = $this->{'Aps'}->find()->where($aps_where)->all();
            foreach($aps as $a){
                array_push($aps_list,$a->id);
            }
            $base_search = ['ap_id IN' => $aps_list];
        }
       
        while($slot_start < $week_end){
        
            $where          = $base_search; 
            $slot_start_h_m = $slot_start->i18nFormat("dd E\nHH:mm",$this->time_zone);
            $slot_end       = $slot_start->addDay(1)->subSecond(1); //Our interval is one day      
            array_push($where, ["modified >=" => $slot_start]);
            array_push($where, ["modified <=" => $slot_end]);    
            $slot_start     = $slot_start->addDay(1);                                     
            $dataIn         = 0;
            $dataOut        = 0;
            
            //-- Raw---
            $stations  = $this->{$table}->find()->select($this->fields)->where($where)->first();        
            if($stations){
                $dataIn = $dataIn + $stations->data_in;
                $dataOut= $dataOut + $stations->data_out;                          
            }
            
            //--Hourlies--
            if($table == 'NodeStations'){
                $tHourlies = 'NodeStationHourlies';
            }
            if($table == 'ApStations'){
                $tHourlies = 'ApStationHourlies';
            }
            $stations_h  = $this->{$tHourlies}->find()->select($this->fields)->where($where)->first();        
            if($stations_h){
                $dataIn = $dataIn + $stations_h->data_in;
                $dataOut= $dataOut + $stations_h->data_out;                          
            }                       
            array_push($items, ['id' => $count, 'time_unit' => $slot_start_h_m, 'data_in' => $dataIn, 'data_out' => $dataOut]);                                  
               
            $count++;
        }
        
        //Total Data
        $where          = $base_search;
        array_push($where, ["modified >=" => $grand_start]);
        array_push($where, ["modified <=" => $grand_end]);  
        
        //--RAW--  
        $q_r = $this->{$table}->find()->select($this->fields)->where($where)->first();
        $data_grand_total   = 0;
        $data_in            = 0;
        $data_out           = 0;
        if($q_r->data_in){
            $data_grand_total   = $data_grand_total+$q_r->data_in+$q_r->data_out;
            $data_in            = $data_in+$q_r->data_in;
            $data_out           = $data_out+$q_r->data_out;
        }
        //$users_grand_total = $this->{$table}->find()->distinct(['mac_address_id'])->where($where)->count();
        
        //--Hourlies--
        if($table == 'NodeStations'){
            $tHourlies = 'NodeStationHourlies';
        }
        if($table == 'ApStations'){
            $tHourlies = 'ApStationHourlies';
        }
        $q_hourlies = $this->{$tHourlies}->find()->select($this->fields)->where($where)->first();
        if($q_hourlies->data_in){
            $data_grand_total   = $data_grand_total+$q_hourlies->data_in+$q_hourlies->data_out;
            $data_in            = $data_in+$q_hourlies->data_in;
            $data_out           = $data_out+$q_hourlies->data_out;
        }
        $users_grand_total = $this->{$tHourlies}->find()->distinct(['mac_address_id'])->where($where)->count(); //FIXME This can be more accurate but will create performance knock       
        
        if($this->graph_item == 'mesh'){
            $this->mesh_data_total  = $data_grand_total;
            $this->mesh_data_in     = $data_in;
            $this->mesh_data_out    = $data_out;
            $this->mesh_user_total  = $users_grand_total;
        }
        
        if($this->graph_item == 'ap'){
            $this->ap_data_total    = $data_grand_total;
            $this->ap_data_in       = $data_in;
            $this->ap_data_out      = $data_out;
            $this->ap_user_total    = $users_grand_total;
        }  
         
        return(['items' => $items]);
    }
    
    private function _setTimezone(){ 
        //New way of doing things by including the timezone_id
        if($this->request->getQuery('timezone_id') != null){
            $tz_id = $this->request->getQuery('timezone_id');
            $ent = $this->{'Timezones'}->find()->where(['Timezones.id' => $tz_id])->first();
            if($ent){
                $this->time_zone = $ent->name;
            }
        }
    }   
    
}
