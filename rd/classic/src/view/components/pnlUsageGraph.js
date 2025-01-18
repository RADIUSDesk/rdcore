Ext.define('Rd.view.components.pnlUsageGraph', {
    extend  : 'Ext.panel.Panel',
    alias   : 'widget.pnlUsageGraph',
    margins : '0 0 0 0',
    plain   : true,
    border  : false,
    //The following attributes will influence the query for the stats
    type        : 'permanent', //Can be permanent, voucher, device, nas, realm or 'activity_viewer'
    span        : 'daily', //Can be daily weekly or monthly
    username    : false, //if device = mac; if nas = nas_id if realm = realm_id
    timezone_id:  316, //London by default
    requires    : [   
        'Rd.view.components.vcUsageGraph'
    ],
    controller  : 'vcUsageGraph',
    listeners:{
        activate : 'onPnlUsageGraphActivate',
    },
    initComponent: function(){
        var me   = this;  
        me.tbar  = [
            { 
                xtype   : 'buttongroup',
                items : [
                    { 
                        xtype       : 'button', 
                        glyph       : Rd.config.icnReload,   
                        scale       : 'large', 
                        itemId      : 'reload',
                        ui          : 'button-orange',  
                        tooltip     : i18n('sReload'),
                        listeners   : {
                            click       : 'onBtnReloadClick'
                        }
                    },
                    {
                        xtype       : 'datefield',
                        width       : 300,
                        fieldLabel  : 'Day',
                        name        : 'day',
                        itemId      : 'day',
                        value       : new Date(),
                        format      : "d/m/Y",
                        labelClsExtra: 'lblRdReq',
                        labelAlign  : 'left',
                        labelWidth  : 50,
                        padding     :'7 0 0 0',
                        margin      : 0,
                        labelSeparator: '',
                        listeners   : {
                            change : 'onDayChange'
                        }
                    },
                    {
                        'xtype'         : 'cmbTimezones', 
                        'width'         : 300, 
                        'itemId'        : 'cmbTimezone',
                        'name'          : 'timezone_id', 
                        'labelClsExtra' : 'lblRdReq',
                        'labelWidth'    : 75, 
                        'padding'       :'7 0 0 0',
                        'margin'        : 0,
                        'value'         : me.timezone_id,
                         listeners   : {
                            change : 'onCmbTimezonesChange'
                        }
                    }
                ]              
            },
            '|',
            {   
                xtype   : 'component', 
                itemId  : 'totals',  
                //tpl     : i18n('tpl_In_{in}_Out_{out}_Total_{total}'), 
                //tpl     : '<h2>In {in} Out {out} Total {total}</h2>',
                tpl     : [
                    "<div>",
                    "<label class='lblTipItem'>IN  <span style='color:#5c5f63;'>{in}</span></label>",
                    "<div style='clear:both;'></div>",
                    "<label class='lblTipItem'>OUT  <span style='color:#5c5f63;'>{out}</span></label>",
                    "<div style='clear:both;'></div>",
                    "<label class='lblTipItem'>TOTAL  <span style='color:#5c5f63;'>{total}</span></label>",
                    "</div>"
                ],
                style   : 'margin-right:5px', 
                cls     : 'lblRd' 
            }
        ];       
        me.store    = Ext.create('Ext.data.Store',{
            model: 'Rd.model.mUserStat',
            proxy: {
                type        : 'ajax',
                format      : 'json',
                extraParams : { 'username' : me.username, 'type' : me.type, 'span' : me.span, 'timezone_id' : me.timezone_id },
                url         : '/cake4/rd_cake/user-stats/index.json',
                reader      : {
                    keepRawData     : true,
                    type            : 'json',
                    rootProperty    : 'items',
                    messageProperty : 'message'
                }
            },
            listeners   : {
                beforeload  : function(s){
                    chart.setLoading(true);
                },
                load        : function(s){
                    chart.setLoading(false);
                    var rawData     = chart.getStore().getProxy().getReader().rawData;
                    var totalIn     = Ext.ux.bytesToHuman(rawData.totalIn);
                    var totalOut    = Ext.ux.bytesToHuman(rawData.totalOut);
                    var totalInOut  = Ext.ux.bytesToHuman(rawData.totalInOut);
                    me.down('#totals').update({'in': totalIn, 'out': totalOut, 'total': totalInOut });
                }
            },
            autoLoad: false   
        });

    var chart = Ext.create('Ext.chart.CartesianChart',{
             insetPadding: {
                top     : 20,
                left    : 20,
                right   : 20,
                bottom  : 20
            },
            itemId: 'chrtUsage',
            width: '100%',
            store       : me.store,
            legend: {
                docked      : 'bottom'
            },
            axes: [
                {
                    type        : 'numeric',
                    position    : 'left',
                    adjustByMajorUnit: true,
                    grid        : true,
                    fields      : ['data_in', 'data_out'],
                    renderer    : function(axis, label, layoutContext) {
                        return Ext.ux.bytesToHuman(label);
                    },
                    minimum: 0,
                    label       : Rd.config.rdGraphLabel
                }, {
                    type        : 'category',
                    position    : 'bottom',
                    grid        : false,
                    fields      : ['time_unit'],
                    label       : Rd.config.rdGraphLabel
                }
            ],
            interactions: ['itemhighlight'],
            series: [
                {
                    type    : 'bar',
                    title   : [ 'Data In', 'Data out' ],
                    xField  : 'time_unit',
                    yField  : ['data_in', 'data_out'],
                    stacked : true,
                    colors  : Rd.config.rdGraphBarColors, // Custom color set
                    style   : {
                        opacity: 0.80
                    },
                    highlight: {
                        fillStyle: 'yellow'
                    },
                    tooltip: {
                        renderer: function (tooltip, record, item) {
                            var di = Ext.ux.bytesToHuman(record.get("data_in"));
                            var dout = Ext.ux.bytesToHuman(record.get("data_out"));
                            tooltip.setHtml("Data in <b>"+di+"</b><br>Data out <b>"+dout+"</b>");    
                            
                        }
                    }
                }
            ]
        });
        
        me.items = chart;
        me.callParent(arguments);
    }
});
