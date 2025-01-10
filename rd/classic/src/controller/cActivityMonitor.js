Ext.define('Rd.controller.cActivityMonitor', {
    extend: 'Ext.app.Controller',
    actionIndex: function(pnl){
        var me = this;
        
        if (me.populated) {
            return; 
        }
        me.ui   = Rd.config.tabVouchers; 
        pnl.add({ 
            xtype       : 'tabpanel',
            border      : false,
            itemId      : 'tabActivityMonitor',
            plain       : true,
            cls         : 'subTab', //Make darker -> Maybe grey
            layout      : 'fit', 
            items       : [
                { 'title' : i18n('sAccounting_data'),       xtype: 'gridRadaccts',     padding     : Rd.config.gridSlim },
                { 'title' : i18n('sAuthentication_data'),   xtype: 'gridRadpostauths', padding     : Rd.config.gridSlim }
            ]
        });
        pnl.on({activate : me.gridActivate,scope: me});       
        me.populated = true;
    },

    views:  [
        'activityMonitor.gridRadaccts',     'activityMonitor.gridRadpostauths',
        'components.winCsvColumnSelect',    'components.pnlUsageGraph'
    ],
    stores: [ 'sRadaccts',  'sRadpostauths'  ],
    models: [ 'mRadacct',   'mRadpostauth', 'mUserStat' ],
    selectedRecord: null,
    specific_nas : undefined,
    config: {
        urlExportCsvAcct    : '/cake4/rd_cake/radaccts/export_csv',
        urlExportCsvAuth    : '/cake4/rd_cake/radpostauths/export_csv',
        urlKickActive       : '/cake4/rd_cake/radaccts/kick_active.json',
        urlCloseOpen        : '/cake4/rd_cake/radaccts/close_open.json'
    },
    refs: [
        {  ref: 'grid',                 selector:   'gridRadaccts'} ,
        {  ref: 'gridRadpostauths',     selector:   'gridRadpostauths'},
        {  ref: 'btnconnected',         selector:   '#connected' }
    ],
    init: function() {
        var me = this;
        if (me.inited) {
            return;
        }
        me.inited = true;  
        me.getStore('sRadaccts').addListener('metachange',  me.onStoreRadacctsMetachange,   me);
        
        //me.getGrid.addListener('metachange',  me.onStoreRadacctsMetachange,   me);
        me.control({
            '#tabActivityMonitor'    : {
                destroy:      me.appClose
            },
            'gridRadaccts #reload': {
                click:      me.reload
            },
            'gridRadaccts #reload menuitem[group=refresh]'   : {
                click:      me.acctReloadOptionClick
            },
            'gridRadaccts #connected': {
                click:      me.reload
            },
            'gridRadaccts #btnInfo': {
                click:      me.btnInfo
            },
            'gridRadaccts #csv'  : {
                click:      me.csvExportAcct
            },
            'gridRadaccts #graph'  : {
                click:      me.usageGraph
            },
            'gridRadaccts #kick'  : {
                click:      me.kickActive
            },
            'gridRadaccts #close'  : {
                click:      me.closeOpen
            },
            'gridRadaccts'   : {
              //  select:      me.select
            },
            'gridRadaccts'   : {
              //  activate:      me.reload
            },
            'gridRadaccts #cmbTimezone': {
                afterrender : me.reload,
                change      : me.reload
            },
            'gridRadpostauths #reload': {
                click:      me.reloadPostAuths
            },
            'gridRadpostauths'   : {
                activate:      me.gridActivate
            },
            'gridRadpostauths #reload menuitem[group=refresh]'   : {
                click:      me.authReloadOptionClick
            },
            'gridRadpostauths #csv'  : {
                click:      me.csvExportAuth
            },
            'pnlRadius #reload': {
                click:      me.radiusReload
            },
            'pnlRadius #reload menuitem[group=refresh]'   : {
                click:      me.radiusReloadOptionClick
            },
            'pnlRadius': {
                activate:       me.radiusActivate
            },
            'pnlRadius  cmbNas': {
                change:         me.cmbNasChange
            },
            '#winCsvColumnSelectAcct #save': {
                click:  me.csvExportSubmitAcct
            },
            '#winCsvColumnSelectAuth #save': {
                click:  me.csvExportSubmitAuth
            }
        });

    },
    reload: function(){
        var me      = this;
        var btn     = me.getGrid().down('#connected');
        var tz      = me.getGrid().down('#cmbTimezone');
        var info    = me.getGrid().down('#btnInfo'); 
         
        var only_connected  = true; //We only show the connected ones by default
        var extra_info  = false;
        if(btn){
            only_connected = btn.pressed; //Default only active
            if(btn.pressed){
               btn.setGlyph(Rd.config.icnLightbulb);
               info.enable();               
            }else{
                btn.setGlyph(Rd.config.icnTime); 
                info.setPressed(false); //release it only here
                info.disable();
                me.getGrid().down('#clmPuExtraValue').disable();
                me.getGrid().down('#clmPuExtraName').disable();
                me.getGrid().down('#clmPuSite').disable();
                me.getGrid().down('#clmPuActive').disable(); 
            }
        }
        
        if(info){
            extra_info = info.pressed; //Default only active
        }
                   
        me.getStore('sRadaccts').getProxy().setExtraParam('only_connected', only_connected);
        me.getStore('sRadaccts').getProxy().setExtraParam('timezone_id',tz.getValue());
        me.getStore('sRadaccts').getProxy().setExtraParam('extra_info',extra_info);
        me.getStore('sRadaccts').reload();
    },
    btnInfo: function(){
        var me  = this;
        var btn = me.getGrid().down('#btnInfo');
        if(btn.pressed){
            console.log("Info Button Pressed");
            me.getGrid().down('#clmPuExtraValue').enable();
            me.getGrid().down('#clmPuExtraName').enable();
            me.getGrid().down('#clmPuSite').enable();
            me.getGrid().down('#clmPuActive').enable();
        }else{
            console.log("Info Button Released");  
            me.getGrid().down('#clmPuExtraValue').disable();
            me.getGrid().down('#clmPuExtraName').disable();
            me.getGrid().down('#clmPuSite').disable();
            me.getGrid().down('#clmPuActive').disable(); 
        }
        me.reload();  
    },    
    onStoreRadacctsMetachange: function(store,meta_data) {
        var me          = this;
        var totalIn     = Ext.ux.bytesToHuman(meta_data.totalIn);
        var totalOut    = Ext.ux.bytesToHuman(meta_data.totalOut);
        var totalInOut  = Ext.ux.bytesToHuman(meta_data.totalInOut);
        me.getGrid().down('#totals').update({'in': totalIn, 'out': totalOut, 'total': totalInOut, total_connected: meta_data.totalCount });
    },
    gridActivate: function(g){
        var me = this;
        //g.getStore().load();
    },
    //Post auths related
    reloadPostAuths: function(){
        var me =this;
        me.getStore('sRadpostauths').reload();
    },
    appClose:   function(){
        var me          = this;
        me.populated    = false;
        if(me.autoReloadAcct != undefined){
            clearInterval(me.autoReloadAcct);   //Always clear
        }
        if(me.autoReloadAuth != undefined){
            clearInterval(me.autoReloadAuth);   //Always clear
        }
        if(me.autoReloadRadius != undefined){
            clearInterval(me.autoReloadRadius);   //Always clear
        }
    },
    acctReloadOptionClick: function(menu_item){
        var me      = this;
        var n       = menu_item.getItemId();
        var b       = menu_item.up('button'); 
        var interval= 30000; //default
        clearInterval(me.autoReloadAcct);   //Always clear
        b.setGlyph(Rd.config.icnTime);

        if(n == 'mnuRefreshCancel'){
            b.setGlyph(Rd.config.icnReload);
            return;
        }
        
        if(n == 'mnuRefresh1m'){
           interval = 60000
        }

        if(n == 'mnuRefresh5m'){
           interval = 360000
        }
        me.autoReloadAcct = setInterval(function(){        
            me.reload();
        },  interval);  
    },
    authReloadOptionClick: function(menu_item){
        var me      = this;
        var n       = menu_item.getItemId();
        var b       = menu_item.up('button'); 
        var interval= 30000; //default
        clearInterval(me.autoReloadAuth);   //Always clear
        b.setGlyph(Rd.config.icnTime);
        
        if(n == 'mnuRefreshCancel'){
            b.setGlyph(Rd.config.icnReload);
            return;
        }
        
        if(n == 'mnuRefresh1m'){
           interval = 60000
        }

        if(n == 'mnuRefresh5m'){
           interval = 360000
        }
        me.autoReloadAuth = setInterval(function(){        
            me.reloadPostAuths();
        },  interval);  
    },
    radiusReload: function(button){
        var me = this;
        var panel = button.up('pnlRadius');

        var params = {};
        panel.down('#status').update({mesg: 'fetching the latest info'});
        if(me.specific_nas != undefined){
            console.log(me.specific_nas);
            params.nas_id = me.specific_nas;
        }

        //Get the latest
        Ext.Ajax.request({
            url: '/cake4/rd_cake/free-radius/index.json',
            method: 'GET',
            params: params,
            success: function(response){
                var jsonData    = Ext.JSON.decode(response.responseText);
                if(jsonData.success){
                    panel.authBasicStore.loadData(jsonData.items.auth_basic);
                    panel.authDetailStore.loadData(jsonData.items.auth_detail);
                    panel.acctDetailStore.loadData(jsonData.items.acct_detail);
                    panel.down('#status').update({mesg: 'idle'}); //Clear the info
                }
            },
            scope: me
        });
    },
    radiusActivate: function(pnl){
        var me = this;
        var button = pnl.down("#reload");
        me.radiusReload(button);
    },
    radiusReloadOptionClick: function(menu_item){
        var me      = this;
        var n       = menu_item.getItemId();
        var b       = menu_item.up('button'); 
        var interval= 30000; //default
        clearInterval(me.autoReloadRadius);   //Always clear
        b.setGlyph(Rd.config.icnTime);

        if(n == 'mnuRefreshCancel'){
            b.setGlyph(Rd.config.icnReload);
            return;
        }
        
        if(n == 'mnuRefresh1m'){
           interval = 60000
        }

        if(n == 'mnuRefresh5m'){
           interval = 360000
        }
        me.autoReloadRadius = setInterval(function(){        
            me.radiusReload(b);
        },  interval);  
    },
    cmbNasChange:   function(cmb){
        var me      = this;
        var value   = cmb.getValue();
        var s       = cmb.getStore();
        //Test to see if there is a record in the store with this ID
        var r       = s.getById(value);
        if(r != null){
           me.specific_nas = value;
        }
    },
    csvExportAcct: function(button,format) {
        var me          = this;
        var columns     = me.getGrid().columnManager.columns;
        var col_list    = [];
        Ext.Array.each(columns, function(item,index){
            if(item.dataIndex != ''){
                var chk = {boxLabel: item.text, name: item.dataIndex, checked: true};
                col_list[index] = chk;
            }
        }); 

        if(!Ext.WindowManager.get('winCsvColumnSelectAcct')){
            var w = Ext.widget('winCsvColumnSelect',{id:'winCsvColumnSelectAcct',columns: col_list});
            w.show();         
        }
    },
    csvExportSubmitAcct: function(button){

        var me      = this;
        var win     = button.up('window');
        var form    = win.down('form');

        var chkList = form.query('checkbox');
        var c_found = false;
        var columns = [];
        var c_count = 0;
        Ext.Array.each(chkList,function(item){
            if(item.getValue()){ //Only selected items
                c_found = true;
                columns[c_count] = {'name': item.getName()};
                c_count = c_count +1; //For next one
            }
        },me);

        if(!c_found){
            Ext.ux.Toaster.msg(
                        i18n('sSelect_one_or_more'),
                        i18n('sSelect_one_or_more_columns_please'),
                        Ext.ux.Constants.clsWarn,
                        Ext.ux.Constants.msgWarn
            );
        }else{     
            //next we need to find the filter values:
            var filters     = [];
            var f_count     = 0;
            var f_found     = false;
            var filter_json ='';
            
            var filter_collection = me.getGrid().getStore().getFilters();     
            if(filter_collection.count() > 0){
                var i = 0;
                while (f_count < filter_collection.count()) { 

                    //console.log(filter_collection.getAt(f_count).serialize( ));
                    f_found         = true;
                    var ser_item    = filter_collection.getAt(f_count).serialize( );
                    ser_item.field  = ser_item.property;
                    filters[f_count]= ser_item;
                    f_count         = f_count + 1;
                    
                }     
            }
               
            var col_json        = "columns="+encodeURIComponent(Ext.JSON.encode(columns));
            var extra_params    = Ext.Object.toQueryString(Ext.Ajax.getExtraParams());
            var append_url      = "?"+extra_params+'&'+col_json;
            if(f_found){
                filter_json = "filter="+encodeURIComponent(Ext.JSON.encode(filters));
                append_url  = append_url+'&'+filter_json;
            }
            window.open(me.getUrlExportCsvAcct()+append_url);
            win.close();
        }
    },

    csvExportAuth: function(button,format) {
        var me          = this;
        var columns     = me.getGridRadpostauths().columnManager.columns;
        var col_list    = [];
        Ext.Array.each(columns, function(item,index){
            if(item.dataIndex != ''){
                var chk = {boxLabel: item.text, name: item.dataIndex, checked: true};
                col_list[index] = chk;
            }
        }); 

        if(!Ext.WindowManager.get('winCsvColumnSelectAuth')){
            var w = Ext.widget('winCsvColumnSelect',{id:'winCsvColumnSelectAuth',columns: col_list});
            w.show();         
        }
    },
    csvExportSubmitAuth: function(button){

        var me      = this;
        var win     = button.up('window');
        var form    = win.down('form');

        var chkList = form.query('checkbox');
        var c_found = false;
        var columns = [];
        var c_count = 0;
        Ext.Array.each(chkList,function(item){
            if(item.getValue()){ //Only selected items
                c_found = true;
                columns[c_count] = {'name': item.getName()};
                c_count = c_count +1; //For next one
            }
        },me);

        if(!c_found){
            Ext.ux.Toaster.msg(
                        i18n('sSelect_one_or_more'),
                        i18n('sSelect_one_or_more_columns_please'),
                        Ext.ux.Constants.clsWarn,
                        Ext.ux.Constants.msgWarn
            );
        }else{     
            //next we need to find the filter values:
            var filters     = [];
            var f_count     = 0;
            var f_found     = false;
            var filter_json ='';
            
            var filter_collection = me.getGrid().getStore().getFilters();     
            if(filter_collection.count() > 0){
                var i = 0;
                while (f_count < filter_collection.count()) { 

                    //console.log(filter_collection.getAt(f_count).serialize( ));
                    f_found         = true;
                    var ser_item    = filter_collection.getAt(f_count).serialize( );
                    ser_item.field  = ser_item.property;
                    filters[f_count]= ser_item;
                    f_count         = f_count + 1;
                    
                }     
            }
           
            var col_json        = "columns="+encodeURIComponent(Ext.JSON.encode(columns));
            var extra_params    = Ext.Object.toQueryString(Ext.Ajax.getExtraParams());
            var append_url      = "?"+extra_params+'&'+col_json;
            if(f_found){
                filter_json = "filter="+encodeURIComponent(Ext.JSON.encode(filters));
                append_url  = append_url+'&'+filter_json;
            }
            window.open(me.getUrlExportCsvAuth()+append_url);
            win.close();
        }
    },
   
    closeOpen : function(button){

        var me      = this;
        var grid    = button.up('grid');
        //Find out if there was something selected
        if(grid.getSelectionModel().getCount() == 0){ 
             Ext.ux.Toaster.msg(
                        i18n('sSelect_an_item'),
                        i18n('sFirst_select_an_item'),
                        Ext.ux.Constants.clsWarn,
                        Ext.ux.Constants.msgWarn
            );
        }else{

            //________________
            var extra_params    = {};
            var s               = grid.getSelectionModel().getSelection();
            Ext.Array.each(s,function(record){
                var r_id = record.getId();
                extra_params[r_id] = r_id;
            });
     
            Ext.Ajax.request({
                url: me.getUrlCloseOpen(),
                method: 'GET',
                params: extra_params,
                success: function(response){
                    var jsonData    = Ext.JSON.decode(response.responseText);
                    if(jsonData.success){
                        Ext.ux.Toaster.msg(
                                    i18n('sItem_updated'),
                                    i18n('sItem_updated_fine'),
                                    Ext.ux.Constants.clsInfo,
                                    Ext.ux.Constants.msgInfo
                        );
                        me.reload();    
                    }   
                },
                scope: me
            });
            //_____________________ 

  
        }


    },

    kickActive: function(button){

        var me      = this;
        var grid    = button.up('grid');
        //Find out if there was something selected
        if(grid.getSelectionModel().getCount() == 0){ 
             Ext.ux.Toaster.msg(
                i18n('sSelect_an_item'),
                i18n('sFirst_select_an_item'),
                Ext.ux.Constants.clsWarn,
                Ext.ux.Constants.msgWarn
            );
        }else{
            Ext.ux.Toaster.msg(
                'Sending request',
                'Please be patient',
                Ext.ux.Constants.clsInfo,
                Ext.ux.Constants.msgInfo
            );
            button.setDisabled(true);
            //________________
            var extra_params    = {};
            var s               = grid.getSelectionModel().getSelection();
            Ext.Array.each(s,function(record){
                var r_id = record.getId();
                extra_params[r_id] = r_id;
            });
    
            Ext.Ajax.request({
                url: me.getUrlKickActive(),
                method: 'GET',
                params: extra_params,
                success: function(response){
                    button.setDisabled(false);
                    var jsonData    = Ext.JSON.decode(response.responseText);
                    if(jsonData.success){
                    
                        if(jsonData.data !== undefined){
                            //Data should contain: 'title', 'message' and type
                            var typeCls = Ext.ux.Constants.clsInfo; //Default is Info
                            var typeMsg = Ext.ux.Constants.msgInfo;
                            if(jsonData.data.type == 'warn'){
                                typeCls = Ext.ux.Constants.clsWarn;
                                typeMsg = Ext.ux.Constants.msgWarn;
                            }
                            if(jsonData.data.type == 'error'){
                                typeCls = Ext.ux.Constants.clsError;
                                typeMsg = Ext.ux.Constants.msgError;
                            }
                            
                            Ext.ux.Toaster.msg(
                                jsonData.data.title,
                                jsonData.data.message,
                                typeCls,
                                typeMsg
                            );                     
                        }else{ //If there's nothing specified
                    
                            Ext.ux.Toaster.msg(
                                i18n('sItem_updated'),
                                i18n('sItem_updated_fine'),
                                Ext.ux.Constants.clsInfo,
                                Ext.ux.Constants.msgInfo
                            );
                            
                        }
                        me.reload();    
                    }   
                },
                failure: function (response, options) {
                    button.setDisabled(false);
                    var jsonData = Ext.JSON.decode(response.responseText);
                    Ext.Msg.show({
                        title       : "Error",
                        msg         : response.request.url + '<br>' + response.status + ' ' + response.statusText+"<br>"+jsonData.message,
                        modal       : true,
                        buttons     : Ext.Msg.OK,
                        icon        : Ext.Msg.ERROR,
                        closeAction : 'destroy'
                    });
                },
                scope: me
            });
            //_____________________
        }
    },
    usageGraph : function(button){

        var me      = this;
        var grid    = button.up('grid');
        //Find out if there was something selected
        if(grid.getSelectionModel().getCount() == 0){ 
             Ext.ux.Toaster.msg(
                i18n('sSelect_an_item'),
                i18n('sFirst_select_an_item'),
                Ext.ux.Constants.clsWarn,
                Ext.ux.Constants.msgWarn
            );
        }else{
            var selected    =  grid.getSelectionModel().getSelection();
            var count       = selected.length;         
            Ext.each(grid.getSelectionModel().getSelection(), function(sr,index){

                //Check if the node is not already open; else open the node:
                var tp          = grid.up('tabpanel');

                var graph_tab_name  = sr.get('username');
                graph_tab_name      = graph_tab_name.replace("@","_");//Replece @
                graph_tab_name      = graph_tab_name.toLowerCase();//Make lower case
                var username        = sr.get('username');
               

                var graph_id    = 'graphTab_'+graph_tab_name;
                var grapht      = tp.down('#'+graph_id);
                if(grapht){
                    tp.setActiveTab(graph_id); //Set focus on  Tab
                    return;
                }
                var dd              = Ext.getApplication().getDashboardData();
                var timezone_id     = dd.user.timezone_id;
                
                //Tab not there - add one
                tp.add({ 
                    title       : graph_tab_name,
                    itemId      : graph_id,
                    closable    : true,
                    iconCls     : 'graph',
                    glyph       : Rd.config.icnGraph, 
                    layout      :  'fit', 
                    xtype       : 'tabpanel',
                    margin      : '0 0 0 0',
                    plain       : true,
                    border      : false,
                    tabPosition : 'top',
                    cls         : 'subTab', 
                    timezone_id : timezone_id,           
                    items       :   [
                        {
                            title   : "Daily",
                            itemId  : "daily",
                            xtype   : 'pnlUsageGraph',
                            span    : 'daily',
                            layout  : 'fit',
                            username: username,
                            timezone_id : timezone_id,
                            type    : 'activity_viewer'
                        },
                        {
                            title   : "Weekly",
                            itemId  : "weekly",
                            xtype   : 'pnlUsageGraph',
                            span    : 'weekly',
                            layout  : 'fit',
                            username: username,
                            timezone_id : timezone_id,
                            type    : 'activity_viewer'
                        },
                        {
                            title   : "Monthly",
                            itemId  : "monthly",
                            layout  : 'fit',
                            xtype   : 'pnlUsageGraph',
                            span    : 'monthly',
                            username: username,
                            timezone_id : timezone_id,
                            type    : 'activity_viewer'
                        }
                    ]
                });
                tp.setActiveTab(graph_id); //Set focus on Add Tab
            });

        }
    }
});
