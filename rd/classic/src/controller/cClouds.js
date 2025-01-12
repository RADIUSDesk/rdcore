Ext.define('Rd.controller.cClouds', {
    extend: 'Ext.app.Controller',
    actionIndex: function(pnl,itemId){
        var me      = this;
        var item    = pnl.down('#'+itemId);
        var added   = false;
        if(!item){         
            pnl.add({         
                xtype   : 'tabpanel',
                itemId  : itemId,
                cls     : 'subSubTab',
                border	: false,
                plain	: true,
                tabBar: {
                    items: [
                        { 
                            xtype   : 'btnOtherBack'
                        }              
                   ]
                },
                items   : [           
                    {
                        title   : 'Clouds',
                        xtype   : 'pnlCloudsMain',
                        border  : false,
                        plain   : true,
                        padding : Rd.config.gridSlim,
                        glyph   : "xf0c2@FontAwesome",
                        tabConfig : {
                            ui  : 'tab-metal'
                        }
                    }
                ]
            });
            //pnl.on({activate : me.reload,scope: me});
            added = true;
        }
        return added;
    }, 
    views:  [
        'clouds.pnlCloudsMain',
        'clouds.treeClouds',         
        'clouds.winCloudEdit',
        'clouds.winCloudAdd',
        'clouds.pnlCloudEdit',
        'components.btnOtherBack'
    ],
    stores: [],
    models: [],
    selectedRecord: null,
    config: {
        urlAdd          : '/cake4/rd_cake/clouds/add.json',
        urlDelete       : '/cake4/rd_cake/clouds/delete.json',
		urlEdit         : '/cake4/rd_cake/clouds/edit.json',
		urlMapPrefView  : '/cake4/rd_cake/meshes/map_pref_view.json'
    },
    refs: [
         {  ref:    'treeClouds',selector:   'treeClouds'}
    ],
    init: function() {
        var me = this;
        if (me.inited) {
            return;
        }
        me.inited = true;

        me.control({
            '#tabClouds' : {
                destroy   :      me.appClose   
            },
            'treeClouds #reload': {
                click:      me.reload
            },
            'treeClouds #add': {
                click:      me.add
            },
            'treeClouds #edit': {
                click:      me.edit
            },
            'treeClouds #delete': {
                click:      me.del
            },
            'treeClouds #expand': {
                click:      me.expand
            },
            'treeClouds #map': {
                click:      me.mapAddTag
            },
            'treeClouds #map_clear': {
                click:      me.mapClear
            },         
            'winCloudAdd #save':{
                click:      me.addSubmit
            },
            'winCloudEdit #save':{
                click:      me.editSubmit
            },
            'treeClouds'   : {
                select:  me.treeItemSelect
            }
        });
    },
    appClose:   function(){
        var me          = this;
        me.populated    = false;
    },
    reload: function(){
        var me =this;
        console.log("Reload Clouds");
        me.getTreeClouds().getStore().reload();
    }, 
    add:    function(){
        var me = this;
        //See if there are anything selected... if not, inform the user
        var sel_count = me.getTreeClouds().getSelectionModel().getCount();
        if(sel_count == 0){
            Ext.ux.Toaster.msg(
                        i18n('sSelect_a_node'),
                        'First select a node of the tree under which to add an entry',
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
                var id = me.selectedRecord.getId();
                if(!Ext.WindowManager.get('winCloudAddId')){
                    var parent_id   = me.selectedRecord.getId();
                    var name        = me.selectedRecord.get('name'); 
                    var level       = me.selectedRecord.get('tree_level'); 
                    var title       = 'Add Cloud';
                    if(level == 'Clouds'){
                        title = 'Add Site';
                    }
                    if(level == 'Sites'){
                        title = 'Add Network';
                    } 
                    if(level == 'Networks'){
                        Ext.ux.Toaster.msg(
                            'Only 3 levels Deep',
                            'The Grouping can only be three levels deep',
                            Ext.ux.Constants.clsWarn,
                            Ext.ux.Constants.msgWarn
                        );
                    }else{                                                    
                        var w = Ext.widget('winCloudAdd',{id:'winCloudAddId','parentId': parent_id,'parentDisplay': name, title:  title});
                        w.show();         
                    }
                }
            }
        }       
    },
    addSubmit: function(button){
        var me       = this;
        var win     = button.up('window');
        var form    = win.down('form');
        form.submit({
            clientValidation: true,
            url: me.getUrlAdd(),
            success: function(form, action) {
                win.close();
                me.getTreeClouds().getStore().load();
                Ext.ux.Toaster.msg(
                    i18n('sNew_item_created'),
                    i18n('sItem_created_fine'),
                    Ext.ux.Constants.clsInfo,
                    Ext.ux.Constants.msgInfo
                );
            },
            failure: Ext.ux.formFail
        });
    },
        
    edit:   function(){
        var me = this;
        //See if there are anything selected... if not, inform the user
        var sel_count = me.getTreeClouds().getSelectionModel().getCount();
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


                //Check if the node is not already open; else open the node:
                var tp          = me.getTreeClouds().up('tabpanel');
                var sr          = me.selectedRecord;
                var parent_id   = me.selectedRecord.get('parent_id');
                var level       = me.selectedRecord.get('tree_level'); 
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
                         if(level == 'Sites'){
                            title = 'Edit Site';
                        } 
                        if(level == 'Networks'){
                            title = 'Edit Network';
                        }
                                        
                        var parent_id = me.selectedRecord.get('parent_id');
                        var w = Ext.widget('winCloudEdit',{id:'winCloudEditId', title: title});
                        w.show();  
                        w.down('form').loadRecord(me.selectedRecord);
                        //Set the parent ID
                        w.down('hiddenfield[name="parent_id"]').setValue(me.selectedRecord.parentNode.getId());
                    }
                }
            }
        }
    },
    editSubmit: function(button){
        var me      = this;
        var win     = button.up('window');
        var form    = win.down('form');
        form.submit({
            clientValidation: true,
            url: me.getUrlEdit(),
            success: function(form, action) {
                win.close();
                me.getTreeClouds().getStore().load();
                Ext.ux.Toaster.msg(
                    i18n('sItem_updated'),
                    i18n('sItem_updated_fine'),
                    Ext.ux.Constants.clsInfo,
                    Ext.ux.Constants.msgInfo
                );
            },
            failure: Ext.ux.formFail
        });
    },

    del:   function(){
        var me      = this;     
        //Find out if there was something selected
        if(me.getTreeClouds().getSelectionModel().getCount() == 0){
             Ext.ux.Toaster.msg(
                        i18n('sSelect_an_item'),
                        i18n('sFirst_select_an_item'),
                        Ext.ux.Constants.clsWarn,
                        Ext.ux.Constants.msgWarn
            );
        }else{
            Ext.MessageBox.confirm(i18n('sConfirm'), i18n('sAre_you_sure_you_want_to_do_that_qm'), function(val){
                if(val== 'yes'){

                    Ext.each(me.getTreeClouds().getSelectionModel().getSelection(), function(item){
                            //console.log(item.getId());
                            item.remove(true);
                    });
                    me.getTreeClouds().getStore().sync({
                        success: function(batch,options){
                            Ext.ux.Toaster.msg(
                                i18n('sItem_deleted'),
                                i18n('sItem_deleted_fine'),
                                Ext.ux.Constants.clsInfo,
                                Ext.ux.Constants.msgInfo
                            ); 
                        },
                        failure: function(batch,options){
                             Ext.ux.Toaster.msg(
                                i18n('sProblems_deleting_item'),
                                batch.proxy.getReader().rawData.message.message,
                                Ext.ux.Constants.clsWarn,
                                Ext.ux.Constants.msgWarn
                            );
                        }
                    });

                }
            });
        }
    },   
    treeItemSelect:  function(grid,record){
        var me = this;
        me.selectedRecord = record;
        var tb =  me.getTreeClouds().down('toolbar[dock=top]');

        var edit = record.get('update');
        if(edit == true){
            if(tb.down('#edit') != null){
                tb.down('#edit').setDisabled(false);
            }
            if(tb.down('#map') != null){
                tb.down('#map').setDisabled(false);
            }
        }else{
            if(tb.down('#edit') != null){
                tb.down('#edit').setDisabled(true);
            }
            if(tb.down('#map') != null){
                tb.down('#map').setDisabled(true);
            }
        }

        var del = record.get('delete');
        if(del == true){
            if(tb.down('#delete') != null){
                tb.down('#delete').setDisabled(false);
            }
        }else{
            if(tb.down('#delete') != null){
                tb.down('#delete').setDisabled(true);
            }
        }
    },
    expand: function(){
        var me = this;
        //See if there are anything selected... if not, inform the user
        var sel_count = me.getTreeClouds().getSelectionModel().getCount();
        if(sel_count == 0){
            Ext.ux.Toaster.msg(
                        i18n('sSelect_a_node'),
                        i18n('sFirst_select_a_node_to_expand'),
                        Ext.ux.Constants.clsWarn,
                        Ext.ux.Constants.msgWarn
            );
        }else{
            me.getTreeClouds().expandNode(me.selectedRecord,true); 
        }
    }
});
