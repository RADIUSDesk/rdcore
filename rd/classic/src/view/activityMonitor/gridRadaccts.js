Ext.define('Rd.view.activityMonitor.gridRadaccts' ,{
    extend:'Ext.grid.Panel',
    alias : 'widget.gridRadaccts',
    multiSelect: true,
    store : 'sRadaccts',
    stateful: true,
    stateId: 'StateGridRadaccts',
    stateEvents:['groupclick','columnhide'],
    border: false,
    requires: [
        'Rd.view.components.ajaxToolbar'
    ],
    viewConfig: {
        loadMask:true
    },
    urlMenu: '/cake4/rd_cake/radaccts/menu-for-grid.json',
    plugins     : 'gridfilters',  //*We specify this
    initComponent: function(){
        var me      = this;             
        me.bbar     = [
            {
                xtype       : 'pagingtoolbar',
                store       : me.store,
                dock        : 'bottom',
                displayInfo : true,
                plugins     : {
                    'ux-progressbarpager': true
                }
            }
        ];

        me.tbar     = Ext.create('Rd.view.components.ajaxToolbar',{'url': me.urlMenu});

        me.columns  = [
         //   {xtype: 'rownumberer',stateId: 'StateGridRadaccts1'},
            { text: i18n('sAcct_session_id'),dataIndex: 'acctsessionid',tdCls: 'gridTree', flex: 1,filter: {type: 'string'},    hidden: true,stateId: 'StateGridRadaccts2'},
            { text: i18n('sAcct_unique_id'),dataIndex: 'acctuniqueid',  tdCls: 'gridTree', flex: 1,filter: {type: 'string'},    hidden: true,stateId: 'StateGridRadaccts3'},
            { text: i18n('sUsername'),      dataIndex: 'username',      tdCls: 'gridMain x-selectable', flex: 1,filter: {type: 'string'},stateId: 'StateGridRadaccts4' },
            { text: i18n('sGroupname'),     dataIndex: 'groupname',     tdCls: 'gridTree', flex: 1,filter: {type: 'string'},    hidden: true,stateId: 'StateGridRadaccts5'},
            { text: i18n('sRealm'),         dataIndex: 'realm',         tdCls: 'gridTree x-selectable', flex: 1,filter: {type: 'string'},stateId: 'StateGridRadaccts6'},
            { text: i18n('sNAS_IP_Address'),dataIndex: 'nasipaddress',  tdCls: 'gridTree', flex: 1,filter: {type: 'string'},    hidden: true, stateId: 'StateGridRadaccts7'},
            { text: i18n('sNAS_Identifier'),dataIndex: 'nasidentifier', tdCls: 'gridTree', flex: 1,filter: {type: 'string'},stateId: 'StateGridRadaccts8'},
            { text: i18n('sNAS_port_id'),   dataIndex: 'nasportid',     tdCls: 'gridTree', flex: 1,filter: {type: 'string'},    hidden: true,stateId: 'StateGridRadaccts9'},
            { text: i18n('sNAS_port_type'), dataIndex: 'nasporttype',   tdCls: 'gridTree', flex: 1,filter: {type: 'string'},    hidden: true,stateId: 'StateGridRadaccts10'},
            { 
                text        : i18n('sStart_time'),
                dataIndex   : 'acctstarttime', 
                tdCls       : 'gridTree', 
                flex        : 1,
                xtype       : 'datecolumn',   
                format      :'Y-m-d H:i:s',
                filter      : {type: 'date',dateFormat: 'Y-m-d'},stateId: 'StateGridRadaccts11'
            },
            { 
                text        : i18n('sStop_time'),   
                dataIndex   : 'acctstoptime',  
                tdCls       : 'gridTree', 
                flex        : 1,
                filter      : {type: 'date',dateFormat: 'Y-m-d'},
                renderer    : function(value,metaData, record){
                    if(record.get('active') == true){
                        var human_value = record.get('online_human')
                        return "<div class=\"fieldGreen\">"+human_value+" "+i18n('sOnline')+"</div>";
                    }else{
                        return value;
                    }              
                },stateId: 'StateGridRadaccts12'
            },
            {   text: i18n('sSession_time'), dataIndex: 'acctsessiontime', tdCls: 'gridTree', flex: 1,filter: {type: 'string'},
                renderer    : function(value){
                    return Ext.ux.secondsToHuman(value);            
                },stateId: 'StateGridRadaccts13'
            }, //Format
            { text: i18n('sAccount_authentic'), dataIndex: 'acctauthentic',     tdCls: 'gridTree', flex: 1,filter: {type: 'string'},    hidden: true,stateId: 'StateGridRadaccts14'},
            { text: i18n('sConnect_info_start'), dataIndex: 'connectinfo_start',tdCls: 'gridTree', flex: 1,filter: {type: 'string'}, hidden: true,stateId: 'StateGridRadaccts15'},
            { text: i18n('sConnect_info_stop'), dataIndex: 'connectinfo_stop',  tdCls: 'gridTree', flex: 1,filter: {type: 'string'}, hidden: true,stateId: 'StateGridRadaccts16'},
            { text: i18n('sData_in'), dataIndex: 'acctinputoctets',    tdCls: 'gridTree', flex: 1,filter: {type: 'string'},
                renderer: function(value){
                    return Ext.ux.bytesToHuman(value)              
                },stateId: 'StateGridRadaccts17'
            }, //Format!
            { text: i18n('sData_out'), dataIndex: 'acctoutputoctets',    tdCls: 'gridTree', flex: 1,filter: {type: 'string'},
                renderer: function(value){
                    return Ext.ux.bytesToHuman(value)              
                },stateId: 'StateGridRadaccts18'
            }, //Format!
            { text: i18n('sCalled_station_id'), dataIndex: 'calledstationid',    tdCls: 'gridTree', flex: 1,filter: {type: 'string'},    hidden: true,stateId: 'StateGridRadaccts19'},
            { text: i18n('sCalling_station_id_MAC'), dataIndex: 'callingstationid',    tdCls: 'gridTree x-selectable', flex: 1,filter: {type: 'string'},stateId: 'StateGridRadaccts20'}, 
            { text: i18n('sTerminate_cause'), dataIndex: 'acctterminatecause',    tdCls: 'gridTree', flex: 1,filter: {type: 'string'},   hidden: true,stateId: 'StateGridRadaccts21'},
            { text: i18n('sService_type'), dataIndex: 'servicetype',    tdCls: 'gridTree', flex: 1,filter: {type: 'string'}, hidden: true,stateId: 'StateGridRadaccts22'},
            { text: i18n('sFramed_protocol'), dataIndex: 'framedprotocol',    tdCls: 'gridTree', flex: 1,filter: {type: 'string'}, hidden: true,stateId: 'StateGridRadaccts23'},
            { text: i18n('sFramed_ipaddress'), dataIndex: 'framedipaddress',  tdCls: 'gridTree x-selectable', flex: 1,filter: {type: 'string'},stateId: 'StateGridRadaccts24'},
            { text: i18n('sAcct_start_delay'), dataIndex: 'acctstartdelay',  tdCls: 'gridTree', flex: 1,filter: {type: 'string'}, hidden: true,stateId: 'StateGridRadaccts25'},
            { text: i18n('sAcct_stop_delay'), dataIndex: 'acctstopdelay',  tdCls: 'gridTree', flex: 1,filter: {type: 'string'}, hidden: true,stateId: 'StateGridRadaccts26'},
            { text: i18n('sX_Ascend_session_svr_key'), dataIndex: 'xascendsessionsvrkey',  tdCls: 'gridTree', flex: 1,filter: {type: 'string'}, hidden: true,stateId: 'StateGridRadaccts27'},
            { text: 'Operator-Name', dataIndex: 'operator_name',  tdCls: 'gridTree', flex: 1,filter: {type: 'string'}, hidden: true,stateId: 'StateGridRadaccts28'},
            {   
                text        : "<i class=\"fa fa-info-circle\"></i> "+'Account Active',  
                dataIndex   : 'pu_active',  
                tdCls       : 'gridTree',   
                xtype       : 'templatecolumn', 
                tpl         : new Ext.XTemplate(
                    "<tpl if='pu_active == true'><div class=\"fieldGreen\"><i class=\"fa fa-check-circle\"></i> "+i18n("sYes")+"</div></tpl>",
                    "<tpl if='pu_active == false'><div class=\"fieldRed\"><i class=\"fa fa-times-circle\"></i> "+i18n("sNo")+"</div></tpl>"
                ),
                flex    : 1,
                filter  : {
                        type            : 'boolean',
                        defaultValue    : false,
                        yesText         : 'Yes',
                        noText          : 'No'
                },             
                hidden  : true,
                stateId : 'StateGridRadaccts29',
                disabled: true,
                itemId  : 'clmPuActive'
            },
            {   
                text    : "<i class=\"fa fa-info-circle\"></i> "+'Site',  
                dataIndex: 'pu_site',  
                tdCls   : 'gridTree', 
                flex    : 1,
                filter  : {type: 'string'},        
                hidden  : true,
                stateId : 'StateGridRadaccts30',
                disabled: true,
                itemId  : 'clmPuSite'
            },
            {   
                text    : "<i class=\"fa fa-info-circle\"></i> "+'Extra Name',  
                dataIndex: 'pu_extra_name',  
                tdCls   : 'gridTree x-selectable', 
                flex    : 1,
                filter  : {type: 'string'},       
                hidden  : true,
                stateId : 'StateGridRadaccts31',
                disabled: true,
                itemId  : 'clmPuExtraName'
            },
            {   
                text    : "<i class=\"fa fa-info-circle\"></i> "+'Extra Value',  
                dataIndex: 'pu_extra_value',  
                tdCls   : 'gridTree x-selectable', 
                flex    : 1,
                filter  : {type: 'string'},        
                hidden  : true,
                stateId : 'StateGridRadaccts32',
                disabled: true,
                itemId  : 'clmPuExtraValue'
            } 
        ];

        me.callParent(arguments);
    }
});
