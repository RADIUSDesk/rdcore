Ext.define('Rd.view.clouds.treeCloudRealms' ,{
    extend      :'Ext.tree.Panel',
    useArrows   : true,
    alias       : 'widget.treeCloudRealms',
    rowLines    : true,
    border      : false,
    rootVisible : true,
    emptyText   : "Please Add Some Clouds",
    rootVisible : true,
    columns: [
        {
            xtype       : 'treecolumn', //this is so we know which column will show the tree
            text        : i18n('sName'),
            tdCls       : 'gridMain',
            flex        : 1,
            sortable    : true,
            dataIndex   : 'text'
        },
        {
            text        : i18n('sComment'),
            flex        : 1,
            dataIndex   : 'comment',
            sortable    : false,
            tdCls       : 'gridTree',
            hidden      : true
        },
        { 
            text    : "<i class=\"fa fa-key\"></i> Admin Rights",
            sortable: false,
            tdCls   : 'gridTree',
            xtype   :  'templatecolumn', 
            tpl:    new Ext.XTemplate(
                        '<tpl for="admin_rights">',
                            "<div style=\"text-align: left;font-size:16px;\"><i class=\"fa fa-cloud\"></i>  {username}</div>",
                        '</tpl>'
                    ),
            dataIndex: 'admin_rights',
            flex        : 1
        },
        { 
            text    : "<i class=\"fa fa-wrench\"></i> Operator Rights",
            sortable: false,
            tdCls   : 'gridTree',
            xtype   :  'templatecolumn', 
            tpl:    new Ext.XTemplate(
                        '<tpl for="operator_rights">',
                            "<div style=\"text-align: left;font-size:16px;\"><i class=\"fa fa-cloud\"></i>  {username}</div>",
                        '</tpl>'
                    ),
            dataIndex: 'operator_rights',
            flex        : 1
        },
        { 
            text    : "<i class=\"fa fa-eye\"></i> View Rights",
            sortable: false,
            tdCls   : 'gridTree',
            xtype   :  'templatecolumn', 
            tpl:    new Ext.XTemplate(
                        '<tpl for="viewer_rights">',
                            "<div style=\"text-align: left;font-size:16px;\"><i class=\"fa fa-cloud\"></i>  {username}</div>",
                        '</tpl>'
                    ),
            dataIndex: 'viewer_rights',
            flex        : 1
        }
    ],
    tbar: [  
        {
            xtype : 'buttongroup',
            title : null,
            items : [    
                { xtype: 'button',  glyph: Rd.config.icnReload, scale: 'large', itemId: 'reload',tooltip: i18n('sReload'),
                    ui : 'button-orange'
                },
                { xtype: 'button',  glyph: Rd.config.icnEdit,   scale: 'large', itemId: 'edit',tooltip: i18n('sEdit'),
                    ui : 'button-blue'
                },
                { xtype: 'button',  glyph: Rd.config.icnExpand, scale: 'large', itemId: 'expand', tooltip: i18n('sExpand')},
                { 
                    xtype       : 'button',   
                    toggleGroup : 'radius_network', 
                    enableToggle : true, 
                    scale       : 'large', 
                    itemId      : 'network',                    
                    ui          : 'button-metal',
                    glyph       : Rd.config.icnSitemap,
                    tooltip     : 'Network'
                },
                { 
                    xtype       : 'button',   
                    toggleGroup : 'radius_network', 
                    enableToggle : true, 
                    scale       : 'large', 
                    itemId      : 'radius',
                    pressed     : true,                  
                    ui          : 'button-metal',
                    glyph       : Rd.config.icnKey,
                    tooltip     : 'Cloud and Realm Rights'
                }        
            ]
        },
        {
            xtype   : 'container',
            html    : '<h1>Cloud and realm rights</h1>'       
        }
    ],
    initComponent: function(){
        var me      = this;     
        var store   = Ext.create('Ext.data.TreeStore', {
            autoLoad    : false,
            root        : {
                expanded    : true,
                text        : "My Clouds",
                name        : "My Clouds",
                owner       : null
            },
            proxy       : {
                type    : 'ajax',
                url     : '/cake4/rd_cake/cloud-realms/index.json',
                reader  : {
                    type            : 'json',
                    rootProperty    : 'items',
                    successProperty : 'success',
                    totalProperty   : 'total'
                }
            },         
            rootProperty: 'items'
        });       
        me.store = store;
        me.callParent(arguments);      
    }
});
