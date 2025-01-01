Ext.define('Rd.view.clouds.vcClouds', {
    extend  : 'Ext.app.ViewController',
    alias   : 'controller.vcClouds',
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
                console.log("Gooi Hom");
                var w = Ext.widget('winCloudRealmEdit',{id:'winCloudRealmEditId'});
                w.show();         
            
/*

                //Check if the node is not already open; else open the node:
                var tp          = me.getTreeClouds().up('tabpanel');
                var sr          = me.selectedRecord;
                var parent_id   = me.selectedRecord.get('parent_id');
                var id          = sr.getId();
                
                if(parent_id == 'root'){
               
                    var tab_id      = 'cloudTab_'+id;
                    var nt          = tp.down('#'+tab_id);
                    if(nt){
                        tp.setActiveTab(tab_id); //Set focus on  Tab
                        return;
                    }

                    var tab_name    = me.selectedRecord.get('name');
                    //Tab not there - add one
                    tp.add({ 
                        title       : 'Cloud '+tab_name,
                        itemId      : tab_id,
                        closable    : true,
                        glyph       : Rd.config.icnEdit, 
                        xtype       : 'pnlCloudEdit',
                        cloud_id    : id
                    });
                    tp.setActiveTab(tab_id); //Set focus on Add Tab

                }else{             
                    if(!Ext.WindowManager.get('winCloudEditId')){
                        var parent_id = me.selectedRecord.get('parent_id');
                        var w = Ext.widget('winCloudEdit',{id:'winCloudEditId'});
                        w.show();  
                        w.down('form').loadRecord(me.selectedRecord);
                        //Set the parent ID
                        w.down('hiddenfield[name="parent_id"]').setValue(me.selectedRecord.parentNode.getId());
                    }
                }
*/ 
               
            }
        }
    },
});
