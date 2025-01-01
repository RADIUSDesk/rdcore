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
    glyph       : Rd.config.icnEdit,
    requires: [
        'Rd.view.clouds.tagAccessProviders'
    ],
    initComponent: function() {
        var me = this;
        this.items = [
            {
                xtype   : 'form',
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
                        xtype:  'hiddenfield',
                        name:   'parent_id',
                        hidden: true
                    },
                    {
                        xtype       :  'hiddenfield',
                        name        :   'id',
                        hidden      : true
                    },
                    {
                        xtype       : 'radiogroup',
                        columns     : 3,
                        fieldLabel  : 'Right',
                        vertical    : true,
                        items: [
                            { boxLabel: 'Admin',    name: 'role', inputValue: 'admin', checked: true },
                            { boxLabel: 'Operator', name: 'role', inputValue: 'operator'},
                            { boxLabel: 'Viewer',   name: 'role', inputValue: 'viewer' }
                        ]
                    },
                    {
                        xtype       : 'tagAccessProviders',
                        fieldLabel  : 'Admin',
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
        this.callParent(arguments);
    }
});
