Ext.define('Rd.view.clouds.vcCloudRealmEdit', {
    extend  : 'Ext.app.ViewController',
    alias   : 'controller.vcCloudRealmEdit',
    config: {
        urlView  : '/cake4/rd_cake/cloud-realms/view.json',
        urlSave  : '/cake4/rd_cake/cloud-realms/save.json'
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
        }
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
        form.setLoading();               
        form.load({
            url         : me.getUrlView(), 
            method      : 'GET',
            params      : { id: id, role: role },
            success : function(a,b){  
		        form.setLoading(false);
                var a  = me.getView().down('#tagAdmin');
                a.setValue(b.result.data.admin);
            }
        });            
    }
});
