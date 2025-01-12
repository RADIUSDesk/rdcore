Ext.define('Rd.view.clouds.pnlCloudsMain', {
    extend	: 'Ext.panel.Panel',
    alias	: 'widget.pnlCloudsMain',
    border	: false,
    plain	: true,
    cls     : 'subTab',
    layout  : 'card',
    requires: [
        'Rd.view.clouds.treeClouds',
        'Rd.view.clouds.treeCloudRealms',
        'Rd.view.clouds.winCloudRealmEdit',
        'Rd.view.clouds.vcCloudsMain',
    ],
    listeners       : {
        activate : 'onPnlActivate' //Trigger a load of the settings (This is only on the initial load)
    },
    controller  : 'vcCloudsMain',
    items   : [
        {
            xtype   : 'treeClouds',
            margin  : 7
        },
        {
            xtype   : 'treeCloudRealms',
            margin  : 7
        }   
    ]
});
