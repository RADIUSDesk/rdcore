<?php

namespace App\Controller;


//use Cake\I18n\Time;
use Cake\I18n\FrozenTime;
use Cake\Core\Configure;
use Cake\Core\Configure\Engine\PhpConfig;

class DataUsagesController extends AppController {

    public $main_model              = 'DataUsage';
    public $base                    = "Access Providers/Controllers/DataUsage/";    
    protected   $type               = false;
    protected   $item_name          = false;
    protected   $base_search        = false;
    protected   $data_limit_active  = false;
    protected   $start_of_month     = 1;
    protected   $time_zone          = 'UTC'; //Default for timezone
   // protected   $time_zone            = 'Africa/Johannesburg';
    protected   $mac                = false;
    protected   $dailies_stopped    = false;

    protected $fields   = [
        'data_in' => 'sum(acctinputoctets)',
        'data_out' => 'sum(acctoutputoctets)',
        'data_total' => 'sum(acctoutputoctets) + sum(acctinputoctets)'
    ];
    
    public function initialize():void
    {
        parent::initialize();
        $this->loadModel('UserStats');
        $this->loadModel('UserStatsDailies');
        $this->loadModel('UserSettings');
        $this->loadModel('Vouchers');
        $this->loadModel('PermanentUsers');
        $this->loadModel('Devices');
        $this->loadModel('DynamicClients');
        $this->loadModel('Timezones');

        $this->loadComponent('TimeCalculations');
        $this->loadComponent('Formatter');
        $this->loadComponent('MacVendors');
        $this->loadComponent('Aa');
    }

    public function clientUsageForRealm(){

        $data   = [];   
        $day    = $this->request->getQuery('day'); //day will be in format 'd/m/Y'
        
        if($day){
            $ft_day = FrozenTime::createFromFormat('d/m/Y',$day);     
        }else{
            $ft_day = FrozenTime::now();
        }     
        
        $this->base_search = $this->_base_search();
        
         //Feedback on requested query     
        $data['query_info']['date']          = $ft_day->i18nFormat('yyyy-MM-dd');
        $data['query_info']['date_human']    = $ft_day->timeAgoInWords();
        $historical                         = true;    
        if($ft_day->isToday()){
            $historical = false;
        }
        $data['query_info']['historical']    = $historical;
        $data['query_info']['date_human']    = $ft_day->timeAgoInWords();
        $data['query_info']['type']          = $this->type;
        $data['query_info']['item_name']     = $this->item_name;
        $data['query_info']['mac']           = $this->mac;
             
        //Try to determine the timezone if it might have been set ....       
        $this->_setTimeZone();
        $data['query_info']['timezone']      = $this->time_zone;
        
        //Always get the top data wether its realm or nas..
        $data['daily']['top']   = $this->_getTopClients($ft_day,'day');
        $data['weekly']['top']  = $this->_getTopClients($ft_day,'week');
        $data['monthly']['top'] = $this->_getTopClients($ft_day,'month');

        $data['daily']['graph']     = $this->_getDailyGraph($ft_day);
        $data['daily']['totals']    = $this->_getTotal($ft_day,'day');

        $data['weekly']['totals']   = $this->_getTotal($ft_day,'week');
        $data['weekly']['graph']    =  $this->_getWeeklyGraph($ft_day);

        //_____ MONTHLY ___
        $data['monthly']['graph']   =  $this->_getMonthlyGraph($ft_day);
        $data['monthly']['totals']  = $this->_getTotal($ft_day,'month');

        if($this->type == 'nas_id'){
            $data['client_detail'] = $this->_getClientDetail();
        }


        $this->set([
            'data' => $data,
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }

    //--Read (the whole lot)
    public function usageForRealm() {
        $data   = [];      
        $day    = $this->request->getQuery('day'); //day will be in format 'd/m/Y'
        
        if($day){
            $ft_day = FrozenTime::createFromFormat('d/m/Y',$day);     
        }else{
            $ft_day = FrozenTime::now();
        }     
        
        //Get the basic search
        $this->base_search = $this->_base_search();
        //See if there is a dailies timestamp
        $e_us = $this->{'UserSettings'}->find()->where(['UserSettings.user_id' => -1,'UserSettings.name' => 'UserStatsDailiesStoppedAt'])->first(); 
        
        if($e_us){
            $this->dailies_stopped = FrozenTime::createFromTimestamp($e_us->value);
        }
        //print_r($this->dailies_stopped);
 
        
        //Feedback on requested query     
        $data['query_info']['date']          = $ft_day->i18nFormat('yyyy-MM-dd');
        $data['query_info']['date_human']    = $ft_day->timeAgoInWords();
        $data['query_info']['date_human']    = $ft_day->timeAgoInWords();
        $data['query_info']['type']          = $this->type;
        $data['query_info']['item_name']     = $this->item_name;
        $data['query_info']['mac']           = $this->mac;
        
        //print_r($data);
        //exit;
        
               
        //Try to determine the timezone if it might have been set ....       
        $this->_setTimeZone();
        $data['query_info']['timezone']      = $this->time_zone;
        
        $historical     = true;  
        $tz_adjusted    = FrozenTime::createFromTimestamp($ft_day->timestamp,$this->time_zone);
        //print_r($tz_adjusted->i18nFormat('yyyy-MM-dd HH:mm:ss'));
        if($tz_adjusted->isToday()||$tz_adjusted->isTomorrow()){
            $historical = false;
        }
        $data['query_info']['historical']    = $historical;
        
        $data['daily']['top_ten']   = $this->_getTopTen($ft_day,'day');
        $data['weekly']['top_ten']  = $this->_getTopTen($ft_day,'week');
        $data['monthly']['top_ten'] = $this->_getTopTen($ft_day,'month');
            
        if($this->type == 'realm'){ 
            if($historical == false){ //Only when its live data
                //Also the active sessions
                $active_sessions = [];
                $this->loadModel('Radaccts');
                $q_acct = $this->Radaccts->find()->where([
                    $this->base_search,
                    'Radaccts.acctstoptime IS NULL'
                ])
                ->select(['radacctid','callingstationid', 'acctstarttime', 'username'])
                ->all();
                $active_total = 0;
                foreach($q_acct as $i){
                    $online_time    = time()-strtotime($i->acctstarttime);
                    $active         = true; 
                    $online_human   = $this->TimeCalculations->time_elapsed_string($i->acctstarttime,false,true);
                    array_push($active_sessions, [
                        'id'                => intval($i->radacctid),
                        'username'          => $i->username,
                        'callingstationid'  => $i->callingstationid,
                        'online_human'      => $online_human,
                        'online'            => $online_time
                    ]);
                    $active_total++;
                }
                $data['daily']['active_sessions'] = $active_sessions;
                $data['daily']['active_total']    = $active_total;
            }          
        }
        
        //____ Get some Dope on the user if it is a user
        if($this->type == 'user'){         
            $data['user_detail']                = $this->_getUserDetail();
            //--We leave this out since Click-To-Connect users wreak havoc
            //$data['daily']['user_devices']      = $this->_getUserDevices($ft_day,'day');
            //$data['weekly']['user_devices']     = $this->_getUserDevices($ft_day,'week');
            //$data['monthly']['user_devices']    = $this->_getUserDevices($ft_day,'month');   
        }
        
        if($this->type == 'device'){    
            $data['user_detail']                = $this->_getUserDetail();
        }
        
        //________ DAILY _________ 
        $data['daily']['graph']     = $this->_getDailyGraph($ft_day);
        $data['daily']['totals']    = $this->_getTotal($ft_day,'day');
             
        //______ WEEKLY ____
        $data['weekly']['graph']    =  $this->_getWeeklyGraph($ft_day);
        $data['weekly']['totals']   = $this->_getTotal($ft_day,'week');
       
        //_____ MONTHLY ___
        $data['monthly']['graph']   =  $this->_getMonthlyGraph($ft_day);
        $data['monthly']['totals']  = $this->_getTotal($ft_day,'month');
        
        $this->set([
            'data' => $data,
            'success' => true
        ]);
        $this->viewBuilder()->setOption('serialize', true);
    }
    
    public function macsForUser(){
                    
        $day    = $this->request->getQuery('day'); //day will be in format 'd/m/Y'
        if(!$day){
             $this->set([
                'items' => [],
                'totalCount'  => [],
                'success' => true
            ]);
            $this->viewBuilder()->setOption('serialize', true);  
            return;
        }
        
        if($day){
            $ft_day = FrozenTime::createFromFormat('d/m/Y',$day);     
        }else{
            $ft_day = FrozenTime::now();
        }
        
        $span    = $this->request->getQuery('span'); //day will be in format 'd/m/Y' 
        
        //Get the basic search
        $this->base_search = $this->_base_search();
        //See if there is a dailies timestamp
        $e_us = $this->{'UserSettings'}->find()->where(['UserSettings.user_id' => -1,'UserSettings.name' => 'UserStatsDailiesStoppedAt'])->first(); 
        
        if($e_us){
            $this->dailies_stopped = FrozenTime::createFromTimestamp($e_us->value);
        } 
            
        $devices        = [];
        $where          = $this->base_search;
        $where_current  = $where;
        $table          = 'UserStats'; //By default use this table
        
        //VERY IMPORTANT
        $this->_setTimeZone();
    
        if($span == 'day'){
            $slot_start_txt     = $ft_day->startOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
            $slot_end_txt       = $ft_day->endOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
        }
        
        if($span == 'week'){
            $table              = 'UserStatsDailies'; //By default use this table
            $slot_start_txt     = $ft_day->startOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
            $slot_end_txt       = $ft_day->endOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
            if($this->dailies_stopped ){
                if(($ft_day->startOfWeek() < $this->dailies_stopped)&&($ft_day->endOfWeek()>$this->dailies_stopped)){
                    $table      = 'UserStats';
                }
            }
        }
                     
        if($span == 'month'){  
            $table          = 'UserStatsDailies';                                
            if($this->data_limit_active){ 
                //FIXME For later          
                $slot_start = FrozenTime::createFromTimestamp($this->_start_of_month($this->start_of_month,$this->start_hour,$this->start_minute));
                $end_time   = $slot_start; 
                $slot_end   = $end_time->addMonth(1)->subMinute(1); 
            }else{
                $slot_start         = $ft_day->startOfMonth();
                $slot_start_txt     = $ft_day->startOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                $slot_end_txt       = $ft_day->endOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
            }
            
            if($this->dailies_stopped ){
                if(($slot_start < $this->dailies_stopped)&&($slot_start->addMonth(1)->subSecond(1)>$this->dailies_stopped)){
                    $table      = 'UserStats';                      
                }
            }   
        }
         
        $query = $this->{$table}->find();
        $time_start = $query->func()->CONVERT_TZ([
            "'$slot_start_txt'"     => 'literal',
            "'$this->time_zone'"    => 'literal',
            "'+00:00'"              => 'literal',
        ]);

        $time_end = $query->func()->CONVERT_TZ([
            "'$slot_end_txt'"       => 'literal',
            "'$this->time_zone'"    => 'literal',
            "'+00:00'"              => 'literal',
        ]); 
        
        array_push($where, ["timestamp >=" => $time_start]);    
        array_push($where, ["timestamp <=" => $time_end]);        
        $limit  = 10;
        $page   = 1;
        $offset = 0;
        
        $req_q    = $this->request->getQuery();
        
        if(isset($req_q['limit'])){
            $limit  = $req_q['limit'];
            $page   = $req_q['page'];
            $offset = $req_q['start'];
        }
        
        $fields = $this->fields;
        array_push($fields, 'username','callingstationid'); 
        
        $count = $this->{$table}->find()->select($fields)
            ->where($where)
            ->order(['data_total' => 'DESC'])
            ->group(['callingstationid'])
            ->count();   
        
        $q_r = $this->{$table}->find()->select($fields)
            ->where($where)
            ->order(['data_total' => 'DESC'])
            ->group(['callingstationid'])
            ->limit($limit)
            ->page($page)
            ->offset($offset)
            ->all();
        
        $id = intval($offset);
        foreach($q_r as $tt){
            $username   = $tt->username;
            $mac        = $tt->callingstationid;
            $data_in    = $tt->data_in;
            $data_out   = $tt->data_out;
            $data_total = $tt->data_total;
            
                       
            array_push($devices, 
                [
                    'id'            => $id,
                    'username'      => $username,
                    'mac'           => $mac,
                    'data_in'       => $data_in,
                    'data_out'      => $data_out,
                    'data_total'    => $data_total,
                    'type'          => 'device',
                    'mac'           => $tt->callingstationid,
                    'vendor'        => $this->MacVendors->vendorFor($tt->callingstationid)
                ]
            );
            $id++;
        }
                      
        $this->set([
            'items'         => $devices,
            'metaData'      => [
                'totalCount'    => $count  
            ] ,
            'totalCount'    => $count,
            'success'       => true
        ]);
		$this->viewBuilder()->setOption('serialize', true);  
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
     
    private function _getTotal($ft_day,$span){
    
        $totals         = [];
        $where          = $this->base_search;
        
        $table          = 'UserStats'; //By default use this table
        $mix_table      = false;
        
        //FIXME REMOVE WHEN FOUND
        //$slot_start_txt     = $ft_day->startOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
        //$slot_end_txt       = $ft_day->endOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
            
        if($span == 'day'){
        
            if($this->dailies_stopped ){
                if($ft_day->endOfDay() < $this->dailies_stopped ){
                    $table          = 'UserStatsDailies';
                }
            }
            $slot_start_txt     = $ft_day->startOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
            $slot_end_txt       = $ft_day->endOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
        }
        
       
        
        if($span == 'week'){      
            if($this->dailies_stopped ){
            
                //Default
                $slot_start_txt     = $ft_day->startOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                $slot_end_txt       = $ft_day->endOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');    
            
                //If we passed on to the next week and have not run our dailies
                if($this->dailies_stopped >= $ft_day->startOfWeek()){
                    $table              = 'UserStats';               
                }else{
                    $table              = 'UserStatsDailies'; 
                }  
            
                if(($ft_day->startOfWeek() < $this->dailies_stopped)&&($ft_day->endOfWeek()>$this->dailies_stopped)){
                    $mix_table = true;
                    $daily_slot_start_txt   = $ft_day->startOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $daily_slot_end_txt     = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $slot_start_txt         = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $slot_end_txt           = $ft_day->endOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                }
                
                if($ft_day->endOfWeek() <= $this->dailies_stopped){
                    $table              = 'UserStatsDailies';
                }
           
                
            }else{
                $slot_start_txt     = $ft_day->startOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                $slot_end_txt       = $ft_day->endOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');       
            }
        }
        
        if($span == 'month'){          
            if($this->data_limit_active){ 
                $slot_start         = $this->_start_of_month($ft_day,$this->start_of_month,$this->start_hour,$this->start_minute);
                
                if($this->dailies_stopped ){
                    if(($slot_start < $this->dailies_stopped)&&($slot_start->addMonth(1)->subSecond(1)>$this->dailies_stopped)){
                        $mix_table = true;
                        $daily_slot_start_txt   = $slot_start->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $daily_slot_end_txt     = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_start_txt         = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_end_txt           = $slot_start->addMonth(1)->subSecond(1)->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    }
                    
                    if($slot_start->addMonth(1)->subSecond(1) < $this->dailies_stopped){
                        $table              = 'UserStatsDailies';
                        $slot_start_txt     = $slot_start->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_end_txt       = $slot_start->addMonth(1)->subSecond(1)->i18nFormat('yyyy-MM-dd HH:mm:ss');      
                    }                    
                }else{
                    $slot_start_txt     = $slot_start->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $slot_end_txt       = $slot_start->addMonth(1)->subSecond(1)->i18nFormat('yyyy-MM-dd HH:mm:ss');
                }                 
            }else{
            
                if($this->dailies_stopped ){
                    if(($ft_day->startOfMonth() < $this->dailies_stopped)&&($ft_day->endOfMonth()>$this->dailies_stopped)){
                        $mix_table = true;
                        $daily_slot_start_txt   = $ft_day->startOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $daily_slot_end_txt     = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_start_txt         = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_end_txt           = $ft_day->endOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    } 
                    
                    if($ft_day->endOfMonth() < $this->dailies_stopped){
                        $table              = 'UserStatsDailies';
                        $slot_start_txt     = $ft_day->startOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_end_txt       = $ft_day->endOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');      
                    }
                    
                     //This should happen on the frist of the new month when dailies have not yet moved to the next month
                    //We will however not need ant Dailies rollu up here since there will not be any for the new month
                    if((!$this->dailies_stopped->subSecond(1)->isThisMonth())&&($ft_day->endOfMonth() > $this->dailies_stopped)){ 
                        $table          = 'UserStats';
                        $slot_start_txt = $ft_day->startOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_end_txt   = $ft_day->endOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');            
                    }     
                                         
                                   
                }else{            
                    $slot_start_txt     = $ft_day->startOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $slot_end_txt       = $ft_day->endOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                }
            }
        }       
        
        if($mix_table){      
            $totals['data_in']      = 0;
            $totals['data_out']     = 0;
            $totals['data_total']   = 0;
            
            //First lot from user_stats_dailies 
            $where_dailies = $where;      
            
            $query = $this->{'UserStatsDailies'}->find();
            $time_start = $query->func()->CONVERT_TZ([
                "'$daily_slot_start_txt'"     => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);

            $time_end = $query->func()->CONVERT_TZ([
                "'$daily_slot_end_txt'"       => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]); 
            
            
            array_push($where_dailies, ["timestamp >=" => $time_start]);     
            array_push($where_dailies, ["timestamp <" => $time_end]);
                        
            $q_r_dailies = $this->{'UserStatsDailies'}->find()->select($this->fields)->where($where_dailies)->first();
            if($q_r_dailies){
                $totals['data_in']      = $q_r_dailies->data_in;
                $totals['data_out']     = $q_r_dailies->data_out;
                $totals['data_total']   = $q_r_dailies->data_total;
            }
            
            $query = $this->{'UserStats'}->find();
            $time_s = $query->func()->CONVERT_TZ([
                "'$slot_start_txt'"     => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);

            $time_e = $query->func()->CONVERT_TZ([
                "'$slot_end_txt'"       => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]); 
            
            //Rest from user_stats
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') >" => $slot_start_txt]);
            array_push($where, ["timestamp >"   => $time_s]); 
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') <=" => $slot_end_txt]);
            array_push($where, ["timestamp <="  => $time_e]);
           
            $q_r = $this->{'UserStats'}->find()->select($this->fields)->where($where)->first();
            if($q_r){
                $totals['data_in']      = $totals['data_in'] + $q_r->data_in;
                $totals['data_out']     = $totals['data_out'] + $q_r->data_out;
                $totals['data_total']   = $totals['data_total'] +$q_r->data_total;
            }       
        
        }else{
        
            $query = $this->{$table}->find();
            $time_start = $query->func()->CONVERT_TZ([
                "'$slot_start_txt'"     => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);

            $time_end = $query->func()->CONVERT_TZ([
                "'$slot_end_txt'"       => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]); 
        
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') >=" => $slot_start_txt]);
            array_push($where, ["timestamp >=" => $time_start]); 
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') <=" => $slot_end_txt]);
            array_push($where, ["timestamp <=" => $time_end]);
        
            $q_r = $this->{$table}->find()->select($this->fields)->where($where)->first();
            if($q_r){
                $totals['data_in']      = $q_r->data_in;
                $totals['data_out']     = $q_r->data_out;
                $totals['data_total']   = $q_r->data_total;
            } 
        } 
        
        $totals['type']         = $this->type;
        $totals['item_name']    = $this->item_name;      
        return $totals;    
    }
    
    private function _getUserDevices($ft_day,$span){
    
        $devices        = [];
        $where          = $this->base_search;
        $id             = 1;
        
        $table          = 'UserStatsDailies'; //By default use this table
    
        if($span == 'day'){
            $slot_start_txt     = $ft_day->startOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
            $slot_end_txt       = $ft_day->endOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
        }
        
        if($span == 'week'){  
            $table              = 'UserStatsDailies'; //By default use this table       
            $slot_start_txt     = $ft_day->startOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
            $slot_end_txt       = $ft_day->endOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
        }
        
        
        if($span == 'month'){  
            $table          = 'UserStats'; //By default use this table        
            if($this->data_limit_active){ 
                //FIXME For later          
                $slot_start = FrozenTime::createFromTimestamp($this->_start_of_month($this->start_of_month,$this->start_hour,$this->start_minute));
                $end_time   = $slot_start; 
                $slot_end   = $end_time->addMonth(1)->subMinute(1); 
            }else{
                $slot_start_txt     = $ft_day->startOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                $slot_end_txt       = $ft_day->endOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
            }
        }
        
        $query = $this->{$table}->find();
        $time_start = $query->func()->CONVERT_TZ([
            "'$slot_start_txt'"     => 'literal',
            "'$this->time_zone'"    => 'literal',
            "'+00:00'"              => 'literal',
        ]);

        $time_end = $query->func()->CONVERT_TZ([
            "'$slot_end_txt'"       => 'literal',
            "'$this->time_zone'"    => 'literal',
            "'+00:00'"              => 'literal',
        ]); 
        
        //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') >=" => $slot_start_txt]);
        array_push($where, ["timestamp >=" => $time_start]);    
        //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') <=" => $slot_end_txt]);
        array_push($where, ["timestamp <=" => $time_end]);
        
        //print_r($where);
        
        //Get a list of the unique MACs
        $ent_macs = $this->{$table}->find()
                ->select(['callingstationid'])
                ->distinct(['callingstationid'])
                ->where($where)
                ->limit(10) //FIXME Else it chokes!
                ->all();
        
        foreach($ent_macs as $mac){
            $clean_where = $where;
            array_push($clean_where,["callingstationid" =>$mac->callingstationid]);
            
            $q_r = $this->{$table}->find()->select($this->fields)->where($clean_where)->first();
            array_push($devices,[
                'id'            => $id,
                'data_in'       => $q_r->data_in, 
                'data_out'      => $q_r->data_out,
                'data_total'    => $q_r->data_total,
                'username'      => $this->item_name,
                'type'          => 'device',
                'mac'           => $mac->callingstationid,
                'vendor'        => $this->MacVendors->vendorFor($mac->callingstationid)
            ]);
            $id++;
        }
        return $devices; 
    }

    private function _getTopClients($ft_day,$span){

        $this->loadModel('DynamicClients');
        $top        = [];
        $where      = $this->base_search;
        $table      = 'UserStats'; //By default use this table
        $mix_table  = false;
        
        if($this->type == 'nas_id'){ //Now we have to find the realm this user /device belongs to
            $ent_us = $this->UserStats->find()
                ->where(['nasidentifier' => $this->item_name])
                ->order(['timestamp' => 'DESC'])
                ->first();
            if($ent_us){
                $where = ['realm' => $ent_us->realm]; 
            }
        }
       
        if($span == 'day'){    
            if($this->dailies_stopped ){
                if($ft_day->endOfDay() < $this->dailies_stopped ){
                    $table          = 'UserStatsDailies';
                }
            }
            $slot_start_txt     = $ft_day->startOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
            $slot_end_txt       = $ft_day->endOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
        }
        
        if($span == 'week'){      
            if($this->dailies_stopped ){
                if(($ft_day->startOfWeek() < $this->dailies_stopped)&&($ft_day->endOfWeek()>$this->dailies_stopped)){
                    $mix_table = true;
                    $daily_slot_start_txt   = $ft_day->startOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $daily_slot_end_txt     = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $slot_start_txt         = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $slot_end_txt           = $ft_day->endOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                }
                
                if($ft_day->endOfWeek() < $this->dailies_stopped){
                    $table          = 'UserStatsDailies';
                    $slot_start_txt     = $ft_day->startOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $slot_end_txt       = $ft_day->endOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');      
                }
            }else{
                $slot_start_txt     = $ft_day->startOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                $slot_end_txt       = $ft_day->endOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');       
            }
        }

        if($span == 'month'){  //This one we have to tread differently
        
            //First get all the RADIUS Clients for the month
            $slot_start_txt     = $ft_day->startOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss'); //Go to start of month
            $slot_end_txt       = $ft_day->endOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss'); //Go to end of month
            
            if(($ft_day->endOfMonth() < $this->dailies_stopped)){       
                $table  = 'UserStatsDailies'; //Only if its in the history
            }
                
            $query = $this->{'UserStats'}->find();
                                
            $time_start = $query->func()->CONVERT_TZ([
                "'$slot_start_txt'"     => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
            
            $time_end = $query->func()->CONVERT_TZ([
                "'$slot_end_txt'"       => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
            
            array_push($where, ["timestamp >=" => $time_start]);
            array_push($where, ["timestamp <=" => $time_end]);      
            
            $fields = $this->fields;
            array_push($fields, 'nasidentifier');

            $q_r = $this->UserStats->find()->select($fields)
                    ->where($where)
                    ->order(['data_total' => 'DESC'])
                    ->group(['nasidentifier'])
                    ->all();
           
            $id = 1;
            
            //Now get their 'real' usage since some might have a reset date other than the start of month
            foreach($q_r as $tt){
                $nas        = $tt->nasidentifier;      
                $ent_nas    = $this->{'DynamicClients'}->find()->where(['DynamicClients.nasidentifier' => $nas])->first();		
                if($ent_nas){
                    $nas_name   = $ent_nas->name;
                    $d_limit = false;
                    if($ent_nas->data_limit_active){
                        $slot_start     = $this->_start_of_month(
                            $ft_day,
                            $ent_nas->data_limit_reset_on,
                            $ent_nas->data_limit_reset_hour,
                            $ent_nas->data_limit_reset_minute
                        );
                        $slot_start_txt = $slot_start->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_end_txt   = $slot_start->addMonth(1)->subSecond(1)->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $d_limit = true;
                    }else{
                        $slot_start_txt     = $ft_day->startOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_end_txt       = $ft_day->endOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    }
                    $new_where = $where;
                    
                    $query = $this->{'UserStats'}->find();
                    $time_start = $query->func()->CONVERT_TZ([
                        "'$slot_start_txt'"     => 'literal',
                        "'$this->time_zone'"    => 'literal',
                        "'+00:00'"              => 'literal',
                    ]);
                    
                    $time_end = $query->func()->CONVERT_TZ([
                        "'$slot_end_txt'"       => 'literal',
                        "'$this->time_zone'"    => 'literal',
                        "'+00:00'"              => 'literal',
                    ]); 
                    
                    //array_push($new_where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') >=" => $slot_start_txt]);
                    array_push($new_where, ["timestamp >=" => $time_start]);
                    //array_push($new_where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') <=" => $slot_end_txt]); 
                    array_push($new_where, ["timestamp <=" => $time_end]);      
                    array_push($new_where, ['nasidentifier' => $nas]);
                    
                    $q_us = $this->UserStats->find()->select($fields)
                        ->where($new_where)
                        ->order(['data_total' => 'DESC'])
                        ->group(['nasidentifier'])
                        ->first();
                    if($q_us){
                        array_push($top,
                            [
                                'nasid'         => $nas,
								'nasname'		=> $nas_name,
								'data_limit'    => $d_limit,
                                'data_in'       => $q_us->data_in,
                                'data_out'      => $q_us->data_out,
                                'data_total'    => $q_us->data_total,
                            ]
                        );
                    }   
                }
            }
            return $top;     
        }else{
        
            $query = $this->{'UserStats'}->find();
            $time_start = $query->func()->CONVERT_TZ([
                "'$slot_start_txt'"     => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
            
            $time_end = $query->func()->CONVERT_TZ([
                "'$slot_end_txt'"       => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
        
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') >=" => $slot_start_txt]);
            array_push($where, ["timestamp >=" => $time_start]);
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') <=" => $slot_end_txt]);
            array_push($where, ["timestamp <=" => $time_end]); 

            $fields = $this->fields;
            array_push($fields, 'nasidentifier');

            $q_r = $this->UserStats->find()->select($fields)
                    ->where($where)
                    ->order(['data_total' => 'DESC'])
                    ->group(['nasidentifier'])
                    ->all();

            $id = 1;
            foreach($q_r as $tt){
                $nas        = $tt->nasidentifier;
                
                $nas_name   = "(UNKNOWN)";
                $ent_nas    = $this->{'DynamicClients'}->find()->where(['DynamicClients.nasidentifier' => $nas])->first();
                if($ent_nas){
                    $nas_name   = $ent_nas->name;
                }
                
                $d_limit = false;
                if($ent_nas->data_limit_active){
                    $d_limit = true;
                }
                   
                array_push($top,
                    [
                        'nasid'         => $nas,
                        'nasname'		=> $nas_name,
                        'data_limit'    => $d_limit,
                        'data_in'       => $tt->data_in,
                        'data_out'      => $tt->data_out,
                        'data_total'    => $tt->data_total,
                    ]
                );
                $id++;
            }
            return $top;
        }
    }

    private function _getTopTen($ft_day,$span){
    
        $top_ten        = [];
        $limit          = 10;
        $where          = $this->base_search;
        $table          = 'UserStats'; //By default use this table
        $mix_table      = false;
        
        if(($this->type == 'user')||($this->type == 'device')){ //Now we have to find the realm this user /device belongs to
            $ent_us = $this->{$table}->find()
                ->where(['username' => $this->item_name])
                ->order(['timestamp' => 'DESC'])
                ->first();
            if($ent_us){
                $where = ['realm' => $ent_us->realm]; 
            }
        }
        
        //FIXME REMOVE WHEN FOUND
        //$slot_start     = $ft_day->startOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
        //$slot_end       = $ft_day->endOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss'); 
                 
        if($span == 'day'){    
            if($this->dailies_stopped ){
                if($ft_day->endOfDay() < $this->dailies_stopped ){
                    $table          = 'UserStatsDailies';
                }
            }
            $slot_start     = $ft_day->startOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
            $slot_end       = $ft_day->endOfDay()->i18nFormat('yyyy-MM-dd HH:mm:ss');
        }
        
        if($span == 'week'){     
            if($this->dailies_stopped){
            
                //Default
                $slot_start     = $ft_day->startOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                $slot_end       = $ft_day->endOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');    
            
                //If we passed on to the next week and have not run our dailies
                if($this->dailies_stopped >= $ft_day->startOfWeek()){
                    $table              = 'UserStats';               
                }else{
                    $table              = 'UserStatsDailies'; 
                }            
            
                if(($ft_day->startOfWeek() < $this->dailies_stopped)&&($ft_day->endOfWeek()>$this->dailies_stopped)){
                    $mix_table          = true;
                    $daily_slot_start   = $ft_day->startOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $daily_slot_end     = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $slot_start         = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $slot_end           = $ft_day->endOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                }
                
                if($ft_day->endOfWeek() < $this->dailies_stopped){
                    $table          = 'UserStatsDailies';   
                }
            }else{
                $slot_start     = $ft_day->startOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                $slot_end       = $ft_day->endOfWeek()->i18nFormat('yyyy-MM-dd HH:mm:ss');       
            }
        }
           
        if($span == 'month'){ 
                      
            if($this->data_limit_active){ 

                $slot_start         = $this->_start_of_month($ft_day,$this->start_of_month,$this->start_hour,$this->start_minute);               
                if($this->dailies_stopped ){
                    if(($slot_start < $this->dailies_stopped)&&($slot_start->addMonth(1)->subSecond(1)>$this->dailies_stopped)){
                        $mix_table = true;
                        $daily_slot_start   = $slot_start->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $daily_slot_end     = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_start         = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_end           = $slot_start->addMonth(1)->subSecond(1)->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    }
                    
                    if($slot_start->addMonth(1)->subSecond(1) < $this->dailies_stopped){
                        $table              = 'UserStatsDailies';
                        $slot_start     = $slot_start->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_end       = $slot_start->addMonth(1)->subSecond(1)->i18nFormat('yyyy-MM-dd HH:mm:ss');      
                    }                    
                }else{
                    $slot_start     = $slot_start->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $slot_end       = $slot_start->addMonth(1)->subSecond(1)->i18nFormat('yyyy-MM-dd HH:mm:ss');
                }                 
            }else{
                if($this->dailies_stopped ){
                    //print_r($this->dailies_stopped);
                    if(($ft_day->startOfMonth() < $this->dailies_stopped)&&($ft_day->endOfMonth()>$this->dailies_stopped)){
                        $mix_table = true;
                        $daily_slot_start   = $ft_day->startOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $daily_slot_end     = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_start         = $this->dailies_stopped->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_end           = $ft_day->endOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    } 
                    
                    if($ft_day->endOfMonth() < $this->dailies_stopped){
                        $table          = 'UserStatsDailies';
                        $slot_start     = $ft_day->startOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_end       = $ft_day->endOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');      
                    }                    
             
                    //This should happen on the frist of the new month when dailies have not yet moved to the next month
                    //We will however not need ant Dailies rollu up here since there will not be any for the new month
                    //We also have to sub a second else it falls within the month but again without dailies yet
                    if((!$this->dailies_stopped->subSecond(1)->isThisMonth())&&($ft_day->endOfMonth() > $this->dailies_stopped)){ 
                        $table          = 'UserStats';
                        $slot_start     = $ft_day->startOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                        $slot_end       = $ft_day->endOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');            
                    }                                      
                                   
                }else{            
                    $slot_start     = $ft_day->startOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                    $slot_end       = $ft_day->endOfMonth()->i18nFormat('yyyy-MM-dd HH:mm:ss');
                }
            }
        } 
        
        $fields = $this->fields;
        array_push($fields, 'username','callingstationid');      
        
        
        if($mix_table){                
            //First lot from user_stats_dailies 
            $where_dailies = $where;           
            $query = $this->{'UserStatsDailies'}->find();
            $time_start = $query->func()->CONVERT_TZ([
                "'$daily_slot_start'"     => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
            
            $time_end = $query->func()->CONVERT_TZ([
                "'$daily_slot_end'"       => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
            
            //array_push($where_dailies, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') >=" => $daily_slot_start]);
            array_push($where_dailies, ["timestamp >=" => $time_start]);
            //array_push($where_dailies, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') <" => $daily_slot_end]);
            array_push($where_dailies, ["timestamp <" => $time_end]); 
            
            //print_r($where_dailies);
                         
            $q_r_dailies = $this->{'UserStatsDailies'}->find()->select($fields)
                ->where($where_dailies)
                ->order(['data_total' => 'DESC'])
                ->group(['username'])
                ->limit($limit)
                ->all();
                
            if($q_r_dailies){
                $id = 1;
                foreach($q_r_dailies as $tt){
                    $username   = $tt->username;
                    $mac        = $tt->callingstationid;
                    array_push($top_ten, 
                        [
                            'id'            => $id,
                            'username'      => $username,
                            'mac'           => $mac,
                            'data_in'       => $tt->data_in,
                            'data_out'      => $tt->data_out,
                            'data_total'    => $tt->data_total,
                        ]
                    );
                    $id++;
                } 
            }
            
            //print_r($slot_start);
            //print_r($slot_end);
            
            //Rest from user_stats
            $query = $this->{'UserStats'}->find();
            $time_start = $query->func()->CONVERT_TZ([
                "'$slot_start'"     => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
            
            $time_end = $query->func()->CONVERT_TZ([
                "'$slot_end'"       => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
                       
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') >=" => $slot_start]);
            array_push($where, ["timestamp >=" => $time_start]);
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') <=" => $slot_end]);
            array_push($where, ["timestamp <=" => $time_end]); 
            
            $q_r = $this->{'UserStats'}->find()->select($fields)
                ->where($where)
                ->order(['data_total' => 'DESC'])
                ->group(['username'])
                ->limit($limit)
                ->all();
                
            foreach($q_r as $tt){
                $username   = $tt->username;
                $mac        = $tt->callingstationid;
                $count      = 0;
                $not_found  = true;
                foreach($top_ten as $tt_daily){                
                    if(($tt_daily['username'] == $username)&&($tt_daily['mac']==$mac)){
                        $not_found = false;
                        $top_ten[$count]['data_in'] = $top_ten[$count]['data_in']+$tt->data_in;
                        $top_ten[$count]['data_out'] = $top_ten[$count]['data_out']+$tt->data_out;
                        $top_ten[$count]['data_total'] = $top_ten[$count]['data_total']+$tt->data_total;
                    }
                    $count++;
                }
                //Add if not found (even if it means we'll end up with more than 10 for now)
                if($not_found){
                    array_push($top_ten, 
                        [
                            'id'            => $id,
                            'username'      => $username,
                            'mac'           => $mac,
                            'data_in'       => $tt->data_in,
                            'data_out'      => $tt->data_out,
                            'data_total'    => $tt->data_total,
                        ]
                    );
                    $id++;
                }           
            }   
        
        }else{
        
            $query = $this->{$table}->find();
            $time_start = $query->func()->CONVERT_TZ([
                "'$slot_start'"     => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
            
            $time_end = $query->func()->CONVERT_TZ([
                "'$slot_end'"       => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
        
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') >=" => $slot_start]);
            array_push($where, ["timestamp >=" => $time_start]);
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') <=" => $slot_end]);
            array_push($where, ["timestamp <=" => $time_end]);
              
            $q_r = $this->{$table}->find()->select($fields)
                ->where($where)
                ->order(['data_total' => 'DESC'])
                ->group(['username'])
                ->limit($limit)
                ->all();
        
            $id = 1;
            foreach($q_r as $tt){
                $username   = $tt->username;
                $mac        = $tt->callingstationid;
                array_push($top_ten, 
                    [
                        'id'            => $id,
                        'username'      => $username,
                        'mac'           => $mac,
                        'data_in'       => $tt->data_in,
                        'data_out'      => $tt->data_out,
                        'data_total'    => $tt->data_total,
                    ]
                );
                $id++;
            } 
        } 
        return $top_ten;
    }
    
    private function _getDailyGraph($ft_day){
    
        $items          = [];
        $start          = 0;
        $base_search = $this->base_search;
        $day_end        = $ft_day->endOfDay();//->i18nFormat('yyyy-MM-dd HH:mm:ss');    
        $slot_start     = $ft_day->startOfDay(); //Prime it 
        while($slot_start < $day_end){
        
            $slot_start_txt     = $slot_start->i18nFormat('yyyy-MM-dd HH:mm:ss');
            //print_r($slot_start_txt);
            //print_r("\n");
            $slot_end_txt       = $slot_start->addHour(1)->subSecond(1)->i18nFormat('yyyy-MM-dd HH:mm:ss');
            
            $where              = $base_search;
            
            $query = $this->{'UserStats'}->find();
            $time_start = $query->func()->CONVERT_TZ([
                "'$slot_start_txt'"     => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
            
            $time_end = $query->func()->CONVERT_TZ([
                "'$slot_end_txt'"       => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
                 
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') >=" => $slot_start_txt]);
            array_push($where, ["timestamp >=" => $time_start]);
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') <=" => $slot_end_txt]);
            array_push($where, ["timestamp <=" => $time_end]);
            
            $slot_start         = $slot_start->addHour(1);
            
            $q_r = $this->UserStats->find()->select($this->fields)->where($where)->first();

            if($q_r){
                $d_in   = $q_r->data_in;
                $d_out  = $q_r->data_out;
                array_push($items, ['id' => $start, 'time_unit' => $start, 'data_in' => $d_in, 'data_out' => $d_out]);
            }
            $start++;
        }
        return(['items' => $items]);
    }
    
    private function _getWeeklyGraph($ft_day){

        $items          = [];
        $week_end       = $ft_day->endOfWeek();//->i18nFormat('yyyy-MM-dd HH:mm:ss');    
        $slot_start     = $ft_day->startOfWeek(); //Prime it 
        $count          = 0;
        $base_search    = $this->base_search;
        $days           = ["Monday", "Tuesday","Wednesday", "Thusday", "Friday", "Saturday", "Sunday"];
       
        while($slot_start < $week_end){
        
            //Logic to determine which table to use
            $table = 'UserStats';
            if($this->dailies_stopped ){
                if($this->dailies_stopped > $slot_start){
                    $table = 'UserStatsDailies';
                }else{
                    $table = 'UserStats';
                }
            }

            $where              = $base_search; 
            $slot_start_txt     = $slot_start->i18nFormat('yyyy-MM-dd HH:mm:ss');
            $slot_end_txt       = $slot_start->addDay(1)->subSecond(1)->i18nFormat('yyyy-MM-dd HH:mm:ss'); //Our interval is one day
            
            
            $query = $this->{$table}->find();
            $time_start = $query->func()->CONVERT_TZ([
                "'$slot_start_txt'"     => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
            
            $time_end = $query->func()->CONVERT_TZ([
                "'$slot_end_txt'"       => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
            
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') >=" => $slot_start_txt]);
            array_push($where, ["timestamp >=" => $time_start]);
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') <=" => $slot_end_txt]);
            array_push($where, ["timestamp <=" => $time_end]);
            
            $slot_start         = $slot_start->addDay(1);
                       
            $q_r                = $this->{$table}->find()->select($this->fields)->where($where)->first();
            
            if($q_r){
                $d_in   = $q_r->data_in;
                $d_out  = $q_r->data_out;
                $d      = $days[$count];
                array_push($items, ['id' => $count, 'time_unit' => $d, 'data_in' => $d_in, 'data_out' => $d_out]);
            }
            $count++;
        }
        return(['items' => $items]);
    }
    
    private function _getMonthlyGraph($ft_day){
        $items          = [];        
        if($this->data_limit_active){
            $slot_start  = $this->_start_of_month($ft_day,$this->start_of_month,$this->start_hour,$this->start_minute);
            $month_end   = $slot_start->addMonth(1)->subSecond(1);
        }else{
            $month_end      = $ft_day->endOfMonth();//->i18nFormat('yyyy-MM-dd HH:mm:ss');    
            $slot_start     = $ft_day->startOfMonth(); //Prime it 
        }
        
        $base_search    = $this->base_search;
        $id_counter     = 1;
       
        while($slot_start < $month_end){
        
            //Logic to determine which table to use
            $table = 'UserStats';
            if($this->dailies_stopped ){
                if($this->dailies_stopped > $slot_start){
                    $table = 'UserStatsDailies';
                }else{
                    $table = 'UserStats';
                }
            }
                   
            $where              = $base_search;  
            $slot_start_txt     = $slot_start->i18nFormat('yyyy-MM-dd HH:mm:ss');
            $slot_end_txt       = $slot_start->addDay(1)->subSecond(1)->i18nFormat('yyyy-MM-dd HH:mm:ss'); //Our interval is one day
            
            $query = $this->{$table}->find();
            $time_start = $query->func()->CONVERT_TZ([
                "'$slot_start_txt'"     => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
            
            $time_end = $query->func()->CONVERT_TZ([
                "'$slot_end_txt'"       => 'literal',
                "'$this->time_zone'"    => 'literal',
                "'+00:00'"              => 'literal',
            ]);
                       
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') >=" => $slot_start_txt]);
            array_push($where, ["timestamp >=" => $time_start]);
            //array_push($where, ["CONVERT_TZ(timestamp,'+00:00','".$this->time_zone."') <=" => $slot_end_txt]);
            array_push($where, ["timestamp <=" => $time_end]);

            //debug($this->{$table}->find()->select($this->fields)->where($where));
            $q_r = $this->{$table}->find()->select($this->fields)->where($where)->first();
            if($q_r){
                $d_in   = $q_r->data_in;
                $d_out  = $q_r->data_out;
                array_push($items, ['id' => $id_counter, 'time_unit' => $slot_start->day, 'data_in' => $d_in, 'data_out' => $d_out]);
            }
            $slot_start = $slot_start->addDay(1);
            $id_counter ++;
        }
        return(['items' => $items]);
    } 
    
    private function _base_search(){

        $type               = 'realm';
        $base_search        = [];
        $username           = $this->request->getQuery('username');
        $cloud_id           = $this->request->getQuery('cloud_id');        
        $this->item_name    = $username;

        if(null !== $this->request->getQuery('type')){
            $type = $this->request->getQuery('type');
            //Permanent users an vouchers
            if(($type == 'permanent')||($type == 'voucher')||($type == 'user')||($type == 'activity_viewer')){
                array_push($base_search, ['username' => $username]);
            }
            //Devices
            if($type == 'device'){
                $this->mac = $this->request->getQuery('mac');
                array_push($base_search, ['callingstationid' => $this->mac,'username' => $username]);
            }
            //Realms
            if($type == 'realm'){
                $this->loadModel('Realms');
                
                //Get the data form ALL the realms for this cloud id
                if($username == 0){
                    $realm_list = [];
                    $el_realms = $this->Realms->find()->where(['Realms.cloud_id' => $cloud_id])->all();
                    foreach($el_realms as $r){
                        array_push($realm_list,$r->name);
                    }
                    //Override if there is a reduced list
                    $apRealmList  = $this->Aa->realmCheck(true);
                  	if($apRealmList){
                  	    $realm_list = $apRealmList;
                  	}
                    
                    array_push($base_search, ['realm IN' => $realm_list]);                 
                }
                
                //Thisa is for a specific realm (make sure it is a valid ID)
                if($username > 0){
                    $q_r = $this->Realms->find()->where(['Realms.id' => $username])->first();                          
                    if($q_r){ 
                        $realm_name = $q_r->name;
                        $this->item_name= $realm_name;
                        array_push($base_search, ['realm' => $realm_name]);
                    }
                }             
            }            
            //Nas
            if($type == 'nas'){
                $this->loadModel('Nas');

                $q_r = $this->Nas->find()->where(['Nas.id' => $username])->first();
                if($q_r){ 
                    $nas_identifier = $q_r->nasidentifier;
                    $this->item_name= $nas_identifier;
                    array_push($base_search, ['nasidentifier' => $nas_identifier]);
                }
            }
            
            //Dynamic clients
            if($type == 'dynamic_client'){
                $this->loadModel('DynamicClients');

                $q_r = $this->DynamicClients->find()->where(['DynamicClients.id' => $username])->first();

                if($q_r){
                    $nas_identifier = $q_r->nasidentifier;
                    $this->item_name= $nas_identifier; 
                    array_push($base_search, ['nasidentifier' => $nas_identifier]);
                }
            }
            
            //Specific NAS 
            if($type == 'nas_id'){
                $this->loadModel('DynamicClients');

                $q_r = $this->DynamicClients->find()->where(['DynamicClients.nasidentifier' => $username])->first();

                if($q_r){     
                    $nas_identifier = $q_r->nasidentifier;
                    $this->item_name= $nas_identifier;
                    if($q_r->data_limit_active){
                        $this->data_limit_active = $q_r->data_limit_active;
                        $this->start_of_month    = $q_r->data_limit_reset_on;
                        $this->start_hour        = $q_r->data_limit_reset_hour; 
                        $this->start_minute      = $q_r->data_limit_reset_minute;  
                    }
                    array_push($base_search, ['nasidentifier' => $nas_identifier]);
                }
            }          
            $this->type = $type;   
        }    
        return $base_search;
    }    
    
    private function _getUserDetail(){
    
        $found = false;
    
        $user_detail = [];
        $username = $this->item_name;
        
        if($this->_isValidMac($username)){
        
        }
        
        //Test to see if it is a Voucher
        $q_v = $this->Vouchers->find()->where(['Vouchers.name' => $username])->first();
       // print_r($q_v);
        if($q_v){
        
            $user_detail['username'] = $username;
            
            $user_detail['type']    = 'voucher';
            $user_detail['profile'] = $q_v->profile;
            $user_detail['created'] = $this->TimeCalculations->time_elapsed_string($q_v->created,false,false);
            $user_detail['status']  = $q_v->status;
            if(!(is_null($q_v->last_reject_time))){
                $user_detail['last_reject_time'] = $this->TimeCalculations->time_elapsed_string($q_v->last_reject_time,false,false);
                $user_detail['last_reject_message'] = $q_v->last_reject_message;
            }
            
            if(!(is_null($q_v->last_accept_time))){
                $user_detail['last_accept_time'] = $this->TimeCalculations->time_elapsed_string($q_v->last_accept_time,false,false);
            }
            
            if(!(is_null($q_v->data_cap))){
                $user_detail['data_cap'] = $this->Formatter->formatted_bytes($q_v->data_cap);
            }
            
            if(!(is_null($q_v->data_used))){
                $user_detail['data_used'] = $this->Formatter->formatted_bytes($q_v->data_used);
            }
            
            if(!(is_null($q_v->perc_data_used))){
                $user_detail['perc_data_used'] = $q_v->perc_data_used;
            }
            
            if(!(is_null($q_v->time_cap))){
                $user_detail['time_cap'] = $this->Formatter->formatted_seconds($q_v->time_cap);
            }
            
            if(!(is_null($q_v->time_used))){
                $user_detail['time_used'] = $this->Formatter->formatted_seconds($q_v->time_used);
            }
            
            if(!(is_null($q_v->perc_time_used))){
                $user_detail['perc_time_used'] = $q_v->perc_time_used;
            }
            $found = true;
   
        }
        
        if(!$found){
            $q_pu = $this->PermanentUsers->find()->where(['PermanentUsers.username' => $username])->first();

           // print_r($q_pu);
            if($q_pu){ 
                $user_detail['username']    = $username;
                $user_detail['type']        = 'user';
                $user_detail['profile']     = $q_pu->profile;
                $user_detail['created']     = $this->TimeCalculations->time_elapsed_string($q_pu->created,false,false);
                if(!(is_null($q_pu->last_reject_time))){
                    $user_detail['last_reject_time'] = $this->TimeCalculations->time_elapsed_string($q_pu->last_reject_time,false,false);
                    $user_detail['last_reject_message'] = $q_pu->last_reject_message;
                }
            
                if(!(is_null($q_pu->last_accept_time))){
                    $user_detail['last_accept_time'] = $this->TimeCalculations->time_elapsed_string($q_pu->last_accept_time,false,false);
                }
            
                if(!(is_null($q_pu->data_cap))){
                    $user_detail['data_cap'] = $this->Formatter->formatted_bytes($q_pu->data_cap);
                }
            
                if(!(is_null($q_pu->data_used))){
                    $user_detail['data_used'] = $this->Formatter->formatted_bytes($q_pu->data_used);
                }
            
                if(!(is_null($q_pu->perc_data_used))){                
                    $user_detail['perc_data_used'] = $q_pu->perc_data_used;
                }
            
                if(!(is_null($q_pu->time_cap))){
                    $user_detail['time_cap'] = $this->Formatter->formatted_seconds($q_pu->time_cap);
                }
            
                if(!(is_null($q_pu->time_used))){
                    $user_detail['time_used'] = $this->Formatter->formatted_seconds($q_pu->time_used);
                }
            
                if(!(is_null($q_pu->perc_time_used))){
                    $user_detail['perc_time_used'] = $q_pu->perc_time_used;
                }
                $found = true;
            
            }     
        }
        
        if($this->type == 'device'){
        
            $device_history = [];
            $id = 1;
        
            $ent_us = $this->UserStats->find()
                ->select(['nasidentifier'])
                ->distinct(['nasidentifier'])
                ->where($this->base_search)
                ->all();
                
            foreach($ent_us as $us){
                $clean_where = $this->base_search;
                array_push($clean_where,["nasidentifier" =>$us->nasidentifier]);
                $q_r = $this->UserStats->find()
                    ->select(['timestamp'])
                    ->where($clean_where)
                    ->order(['timestamp' => 'DESC'])
                    ->first();
                    
                $q_c = $this->DynamicClients->find()->where(['DynamicClients.nasidentifier' => $us->nasidentifier])->first();
                $nasname = "UNKNOWN";
                if($q_c){
                    $nasname = $q_c->name;
                }
                    
                array_push($device_history,[
                    'id'                => $id,
                    'nasname'           => $nasname,
                    'nasidentifier'     => $us->nasidentifier, 
                    'last_seen'         => $q_r->timestamp,
                    'last_seen_human'   => $q_r->timestamp->timeAgoInWords()
                ]);
                  
                $id++;  
            }
        
            $user_detail['type']    =  'device';
            $user_detail['mac']     = $this->mac; 
            $user_detail['vendor']  = $this->MacVendors->vendorFor($this->mac);
            $user_detail['device_history'] =  $device_history; 
        }
           
        return $user_detail;
    }
    
    private function _getClientDetail(){
    
        $found = false;
    
        $client_detail = [];
        $nasid = $this->item_name;
        
        $this->loadModel('DynamicClients');
        
        $ent_dc = $this->{'DynamicClients'}->find()->where(['DynamicClients.nasidentifier' => $nasid])->first();
        if($ent_dc){
            $fields     = $this->{'DynamicClients'}->getSchema()->columns();
            foreach($fields as $field){
                $client_detail[$field] = $ent_dc->{"$field"};
            }
        
            if(!(is_null($ent_dc->last_contact))){
                $client_detail['last_contact'] = $this->TimeCalculations->time_elapsed_string($ent_dc->last_contact,false,false);
            }
            
            if($ent_dc->data_limit_active){
                $d_limit_bytes = $this->_getBytesValue($ent_dc->data_limit_amount,$ent_dc->data_limit_unit);
                $client_detail['data_cap'] = $this->Formatter->formatted_bytes($d_limit_bytes);
                if($ent_dc->data_used >0){
                    $client_detail['perc_data_used'] =  round(($ent_dc->data_used /$d_limit_bytes*100),2) ;
                    if($client_detail['perc_data_used'] > 100){
                        $client_detail['perc_data_used'] = 100;
                    }
                    
                }else{
                    $client_detail['perc_data_used'] = 0;
                }
                $client_detail['data_used'] = $this->Formatter->formatted_bytes($client_detail['data_used']);
            }
            
        } 
        return $client_detail;
    }

    private  function _isValidMac($mac){
        return (preg_match('/([a-fA-F0-9]{2}[:|\-]?){6}/', $mac) == 1);
    }
    
    private function _start_of_month($ft_day,$r_day,$r_hour,$r_min){  
        #Get the day of the month for this frozen-time selection
        $day_of_month = $ft_day->day;               
        //We do the follwoing if reset day is for instance 31 but the month only has 30 days (or 28 for that matter)
        $last_day_of_month = $ft_day->endOfMonth()->day;
        if($r_day > $last_day_of_month){
            $r_day = $last_day_of_month;
        }
          
        $dt_reset  = $ft_day
            ->year($ft_day->year)
            ->month($ft_day->month)
            ->day($r_day)
            ->hour($r_hour)
            ->minute($r_min);
        
        if($ft_day->timestamp < $dt_reset->timestamp){  
            #We use the previous month 
            //When adding or subtracting months, if the resulting time is a date that does not exist, 
            //the result of this operation will always be the last day of the intended month.
            $dt_reset = $dt_reset->subMonth();
        }
        return $dt_reset;  
    } 
    
     private function _getBytesValue($total_data,$unit){
    
        if(strpos($unit, 'kb') !== false){
           $total_data = $total_data * 1024; 
        }
        if(strpos($unit, 'mb') !== false){
           $total_data = $total_data * 1024 * 1024; 
        }
        if(strpos($unit, 'gb') !== false){
           $total_data = $total_data * 1024 * 1024 * 1024; 
        }
        if(strpos($unit, 'tb') !== false){
           $total_data = $total_data * 1024 * 1024 * 1024 * 1024; 
        }     
        return $total_data;
    }  
}
