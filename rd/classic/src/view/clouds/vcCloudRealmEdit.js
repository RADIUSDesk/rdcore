Ext.define('Rd.view.clouds.vcCloudRealmEdit', {
    extend  : 'Ext.app.ViewController',
    alias   : 'controller.vcCloudRealmEdit',
    config: {
        urlView  : '/cake4/rd_cake/cloud-realms/view.json',
        urlSave  : '/cake4/rd_cake/cloud-realms/edit.json'
    }, 
    control: {
        'winCloudRealmEdit' : {
            afterrender : 'winAfterRender'
        },
        '#btnAdmin'    : {
            click   : 'btnAdminClick'
        },
        '#btnOperator'    : {
            click   : 'btnOperatorClick'
        },
        '#btnViewer'    : {
            click   : 'btnViewerClick'
        },
        '#save': {
            click   : 'btnSave'
        },
    },
    btnAdminClick : function(){
        var me = this;
        me.loadForm();
    },
    btnOperatorClick : function(){
        var me = this;
        me.loadForm();
    },
    btnViewerClick : function(){
        var me = this;
        me.loadForm();
    },
    winAfterRender  : function(){
        var me = this;
        me.loadForm();
    },
    loadForm    : function(){
        var me = this;
        var role = 'admin';
        if(me.getView().down('#btnOperator').pressed){
            role = 'operator';
        }
        if(me.getView().down('#btnViewer').pressed){
            role = 'viewer';
        }
        var form    = me.getView().down('form'); 
        var id      = me.getView().record.get('id');
        var level   = me.getView().record.get('tree_level');
        form.setLoading();               
        form.load({
            url         : me.getUrlView(), 
            method      : 'GET',
            params      : { id: id, role: role, level : level },
            success : function(a,b){  
		        form.setLoading(false);
                var a  = me.getView().down('#tagAdmin');
                a.setValue(b.result.data.admin);
            }
        });            
    },
    btnSave:function(button){
        var me      = this;
        var form    = me.getView().down('form');
    
        form.submit({
            clientValidation    : true,
            url                 : me.getUrlSave(),
            success             : function(form, action) {
                me.getView().store.reload();                           
                Ext.ux.Toaster.msg(
                    i18n('sItems_modified'),
                    i18n('sItems_modified_fine'),
                    Ext.ux.Constants.clsInfo,
                    Ext.ux.Constants.msgInfo
                );
                me.getView().close();
            },
            failure             : Ext.ux.formFail
        });
    }  
});
