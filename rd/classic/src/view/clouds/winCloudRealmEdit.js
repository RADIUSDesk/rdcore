Ext.define('Rd.view.clouds.winCloudRealmEdit', {
    extend      : 'Ext.window.Window',
    alias       : 'widget.winCloudRealmEdit',
    closable    : true,
    draggable   : true,
    resizable   : true,
    border      : false,
    layout      : 'fit',
    autoShow    : false,
    width       : 550,
    height      : 350,
    requires: [
        'Rd.view.clouds.tagAccessProviders',
        'Rd.view.clouds.vcCloudRealmEdit'
    ],
    controller  : 'vcCloudRealmEdit',
    initComponent: function() {
        var me = this;
        
        var level = me.record.get('tree_level');
        var name  = me.record.get('name');
        if(level == 'Clouds'){
            me.glyph = Rd.config.icnCloud;
            me.title = 'Cloud level : ' + name;
        }
        if(level == 'Realms'){
            me.glyph = Rd.config.icnRealm;
            me.title = 'Realm level : ' + name;
        }
        	     
        me.items = [
            {
                xtype           : 'form',
                
                fieldDefaults   : {
                    msgTarget       : 'under',
                    labelClsExtra   : 'lblRd',
                    labelAlign      : 'left',
                    labelSeparator  : '',
                    labelClsExtra   : 'lblRd',
                    margin          : 15,
                    labelWidth		: 130
                },
                defaults    : {
                    anchor          : '100%'
                },
                defaultType: 'textfield',
                items: [
                    {
                        xtype       : 'hiddenfield',
                        name        : 'id',
                        hidden      : true
                    },
                    {
                        xtype       : 'hiddenfield',
                        name        : 'role',
                        hidden      : true
                    },
                    {
                        xtype       : 'hiddenfield',
                        name        : 'level',
                        hidden      : true
                    },
                     {
                        xtype       : 'hiddenfield',
                        name        : 'c_id',
                        hidden      : true
                    },
                    {
                        xtype       : 'radiogroup',
                        fieldLabel  : 'Right',
                        labelClsExtra: 'lblRd',
                        layout: {
				            type	: 'hbox',
				            align	: 'middle',
				            pack	: 'stretchmax',
				            padding	: 0,
				            margin	: 0
			            },
                        defaultType: 'button',
        				defaults: {
				            enableToggle: true,
				            toggleGroup: 'type',
				            allowDepress: false,					
			            },             
                        items: [
				            { text: 'Admin',    itemId: 'btnAdmin',     glyph: Rd.config.icnKey,        flex:1, ui : 'default-toolbar', 'margin' : '0 5 0 0', pressed: true },
				            { text: 'Operator', itemId: 'btnOperator',  glyph: Rd.config.icnConfigure,  flex:1, ui : 'default-toolbar', 'margin' : '0 5 0 5' },
				            { text: 'Viewer', 	itemId: 'btnViewer',    glyph: Rd.config.icnEye,        flex:1, ui : 'default-toolbar', 'margin' : '0 0 0 5' }
			            ]
                    },
                    {
                        xtype       : 'tagAccessProviders',
                        fieldLabel  : 'Admins',
                        name        : 'admin[]',
                        itemId      : 'tagAdmin'
                    }
                   ],
                buttons: [
                    {
                        itemId: 'save',
                        text    : i18n('sSave'),
                        scale: 'large',
                        iconCls: 'b-next',
                        glyph: Rd.config.icnNext,
                        margin: '0 20 40 0'
                    }
                ]
            }
        ];
        me.callParent(arguments);
    }
});
