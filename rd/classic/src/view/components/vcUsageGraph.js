Ext.define('Rd.view.components.vcUsageGraph', {
    extend  : 'Ext.app.ViewController',
    alias   : 'controller.vcUsageGraph', 
    onPnlUsageGraphActivate: function(pnl){
        var me = this;
        me.getView().down('#chrtUsage').getStore().load();
    },  
    onBtnReloadClick: function(button){
        var me 		        = this;
        me.getView().down('#chrtUsage').getStore().load();
    },
    onDayChange: function(sel_day){
        var me      = this; 
        me.getView().down('#chrtUsage').getStore().getProxy().setExtraParam('day',sel_day.getRawValue());
        me.getView().down('#chrtUsage').getStore().load();
    },
    onCmbTimezonesChange: function(cmb){
        var me 		        = this;
        me.getView().down('#chrtUsage').getStore().getProxy().setExtraParam('timezone_id',cmb.getValue());
        me.getView().down('#chrtUsage').getStore().load();
    }    
});
