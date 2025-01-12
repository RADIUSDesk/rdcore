Ext.define('Rd.view.clouds.vcCloudsMain', {
    extend  : 'Ext.app.ViewController',
    alias   : 'controller.vcCloudsMain',
    config: {
        urlView  : '/cake4/rd_cake/clouds/view.json',
        urlSave  : '/cake4/rd_cake/clouds/save-cloud.json'
    }, 
    control: {
        'treeClouds #radius'    : {
            click   : 'btnRadiusClick'
        },
        'treeCloudRealms #network'    : {
            click   : 'btnNetworkClick'
        },
        'treeCloudRealms #reload': {
            click   : 'reloadCloudRealms'
        },
        'treeCloudRealms #edit': {
            click   : 'edit'
        },
        'treeCloudRealms'   : {
                select:  'treeItemSelect'
        }
    },
    onPnlActivate: function(pnl){
        var me = this;
        console.log("Panel Clouds Activate")     
    },
    btnRadiusClick: function(){
        var me = this;
        me.getView().getLayout().setActiveItem(1);
        me.getView().down('treeCloudRealms').down('#radius').setPressed();
    },
    btnNetworkClick: function(){
        var me = this;
        me.getView().getLayout().setActiveItem(0);
        me.getView().down('treeClouds').down('#network').setPressed();
    },
    reloadCloudRealms: function(){
        var me = this;
        me.getView().down('treeCloudRealms').getStore().reload();    
    },
    edit:   function(){
        var me = this;
        //See if there are anything selected... if not, inform the user
        var sel_count = me.getView().down('treeCloudRealms').getSelectionModel().getCount();
        if(sel_count == 0){
            Ext.ux.Toaster.msg(
                        i18n('sSelect_an_item'),
                        i18n('sFirst_select_an_item'),
                        Ext.ux.Constants.clsWarn,
                        Ext.ux.Constants.msgWarn
            );
        }else{
            if(sel_count > 1){
                Ext.ux.Toaster.msg(
                        i18n('sLimit_the_selection'),
                        i18n('sSelection_limited_to_one'),
                        Ext.ux.Constants.clsWarn,
                        Ext.ux.Constants.msgWarn
                );
            }else{
            
                var sr  = me.selectedRecord;
                var id  = sr.getId();
                var s   = me.getView().down('treeCloudRealms').getStore();
                var w   = Ext.widget('winCloudRealmEdit',{id:'winCloudRealmEditId',record:sr,store:s});
                w.show();             
            }
        }
    },
    treeItemSelect:  function(grid,record){
        var me = this;
        me.selectedRecord = record;
        var tb =  me.getView().down('treeCloudRealms').down('toolbar[dock=top]');
        var edit = record.get('update');
        if(edit == true){
            if(tb.down('#edit') != null){
                tb.down('#edit').setDisabled(false);
            }
        }else{
            if(tb.down('#edit') != null){
                tb.down('#edit').setDisabled(true);
            }
        }
    }
});
