Ext.define('Rd.view.clouds.winCloudAdd', {
    extend      : 'Ext.window.Window',
    alias       : 'widget.winCloudAdd',
    closable    : true,
    draggable   : true,
    resizable   : true,
    border      : false,
    layout      : 'fit',
    autoShow    : false,
    width       : 450,
    height      : 380,
    glyph       : Rd.config.icnAdd,
    parentId    : undefined,
    parentDisplay: undefined,
    initComponent: function() {

        var me  = this;
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
                defaults: {
                    anchor      : '100%'
                },
                items: [
                    {
                        itemId  : 'parent_id',
                        xtype   : 'textfield',
                        name    : 'parent_id',
                        hidden  : true,
                        value   : me.parentId
                    },
                    {
                        xtype       : 'displayfield',
                        fieldLabel  : i18n('sParent_node'),
                        value       : me.parentDisplay,
                        labelClsExtra: 'lblRdReq'
                    },
                    {
                        xtype       : 'textfield',
                        fieldLabel  : 'Name',
                        name        : 'name',
                        allowBlank  :false,
                        blankText   : i18n('sEnter_a_value'),
                        labelClsExtra: 'lblRdReq'
                    },
                    {
                        xtype       : 'textfield',
                        grow        : true,
                        name        : 'lat',
                        fieldLabel  : 'Lat'
                    },
                    {
                        xtype       : 'textfield',
                        grow        : true,
                        name        : 'lng',
                        fieldLabel  : 'Lng'
                    }
                 ],
                 buttons : [
                    {
                        text        : i18n('sSave'),
                        scale       : 'large',
                        action      : 'save',
                        itemId      : 'save',
                        glyph       : Rd.config.icnNext,
                        formBind    : true,
                        margin      : '0 20 40 0'
                    }
                ]
            }
        ];
        this.callParent(arguments);
    }
});
