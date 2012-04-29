﻿Ext.define('zvsMobile.view.DeviceDetailsThermo', {
    extend: 'Ext.Panel',
    xtype: 'DeviceDetailsThermo',

    constructor: function (config) {
        var self = this;

        self.RepollTimer;
        self.deviceID = 0;
        Ext.apply(config || {}, {
            xtype: 'panel',
            layout: 'vbox',
            scrollable: 'vertical',
            items: [{
                xtype: 'panel',
                id:'ThermoTPL',
                tpl: new Ext.XTemplate(
							    '<div class="device_info">',
							        '<div id="level_temp_img" class="imageholder {type}"></div>',
							        '<div id="level_temp_details" class="level">{level_txt}</div>',
								        '<h1>{name}</h1>',
								        '<h2>{type_txt}<h2>',
								        '<div class="overview">',
                                        '<strong>Currently: </strong>{level}&deg; F<br />',
                                        '<strong>Operating State: </strong>{op_state}<br />',
                                        '<strong>Fan State: </strong>{fan_state}<br />',
                                        '<strong>Energy Mode: </strong>',
                                        '<tpl if="esm == 0">',
                                              'Energy Savings Mode',
                                         '<tpl else>',
                                             'Comfort Mode',
                                         '</tpl>',
                                        '<br /><br />',
                                        '<strong>Mode: </strong>{mode}<br />',
                                        '<strong>Fan Mode: </strong>{fan_mode}<br />',
                                        '<strong>Heat Point: </strong>{heat_p}&deg; F<br />',
                                        '<strong>Cool Point: </strong>{cool_p}&deg; F<br /><br />',
                                        '<tpl if="groups">',
                                            '<strong>Groups: </strong>{groups}<br />',
                                        '</tpl>',
								        '<strong>Updated: </strong>{last_heard_from}',
                                    '</div>',
							    '</div>')
            }, {
                xtype: 'button',
                text: 'Energy Mode',
                ui: 'confirm',
                margin: 5,
                handler: function () {
                    console.log('AJAX: SendCmd ESM');
                    Ext.Ajax.request({
                        url: zvsMobile.app.BaseURL() + '/device/' + self.deviceID + '/command/',
                        method: 'POST',
                        params: {
                            u: Math.random(),
                            name: 'SETENERGYMODE',
                            arg: 0,
                            type: 'device_type'
                        },
                        success: function (response, opts) {
                            var result = JSON.parse(response.responseText);
                            if (result.success) {
                                self.delayedReload();
                                //Ext.Msg.alert('Thermostat Command', 'Thermostat set to Energy Savings Mode');
                            }
                            else {
                                Ext.Msg.alert('Thermostat Command', 'Communication Error!');
                            }
                        }
                    });
                }
            }, {
                xtype: 'button',
                text: 'Comfort Mode',
                ui: 'confirm',
                margin: '5 5 30 5',
                handler: function () {
                    console.log('AJAX: SendCmd Confort');
                    Ext.Ajax.request({
                        url: zvsMobile.app.BaseURL() + '/device/' + self.deviceID + '/command/',
                        method: 'POST',
                        params: {
                            u: Math.random(),
                            name: 'SETCONFORTMODE',
                            arg: 0,
                            type: 'device_type'
                        },
                        success: function (response, opts) {
                            var result = JSON.parse(response.responseText);
                            if (result.success) {
                                self.delayedReload();
                                //Ext.Msg.alert('Thermostat Command', 'Thermostat set to Comfort Mode');
                            }
                            else {
                                Ext.Msg.alert('Thermostat Command', 'Communication Error!');
                            }
                        }
                    });
                }
            }, {
                xtype: 'button',
                text: 'Change Mode',
                ui: 'action',
                margin: 5,
                flex: 1,
                handler: function () {
                    if (!SetMode) {
                        var SetMode = Ext.create('Ext.ActionSheet', {
                            items: [{
                                xtype: 'selectfield',
                                label: 'Mode',
                                margin: '15 5',
                                options: [{
                                    text: 'Off',
                                    value: 'Off'
                                }, {
                                    text: 'Auto',
                                    value: 'Auto'
                                }, {
                                    text: 'Heat',
                                    value: 'Heat'
                                }, {
                                    text: 'Cool',
                                    value: 'Cool'
                                }]
                            }, {
                                xtype: 'toolbar',
                                docked: 'top',
                                items: [{
                                    xtype: 'button',
                                    text: 'Cancel',
                                    scope: this,
                                    handler: function () {
                                        SetMode.hide();
                                    }
                                }, {
                                    xtype: 'spacer'
                                }, {
                                    xtype: 'button',
                                    text: 'Set Mode',
                                    scope: this,
                                    handler: function () {
                                        var mode = SetMode.items.items[0].getValue()
                                        console.log('AJAX DYNAMIC_CMD_MODE ' + mode);

                                        Ext.Ajax.request({
                                            url: zvsMobile.app.BaseURL() + '/device/' + self.deviceID + '/command/',
                                            method: 'POST',
                                            params: {
                                                u: Math.random(),
                                                name: 'DYNAMIC_CMD_MODE',
                                                arg: mode,
                                                type: 'device'
                                            },
                                            success: function (response, opts) {
                                                var result = JSON.parse(response.responseText);
                                                if (result.success) {
                                                    self.delayedReload();
                                                   // Ext.Msg.alert('Thermostat Command', 'Mode set to ' + mode);
                                                }
                                                else {
                                                    Ext.Msg.alert('Thermostat Command', 'Communication Error!');
                                                }
                                            }
                                        });
                                        SetMode.hide();
                                    }
                                }]
                            }]
                        });
                    }

                    Ext.Viewport.add(SetMode);
                    SetMode.show();
                    var ThermoTPL = self.items.items[1];
                    var data = ThermoTPL.getData();
                    SetMode.items.items[0].setValue(data.mode)

                }
            }, {
                xtype: 'button',
                text: 'Change Fan Mode',
                ui: 'action',
                margin: 5,
                flex: 1,
                handler: function () {
                    if (!SetFanMode) {
                        var SetFanMode = Ext.create('Ext.ActionSheet', {
                            items: [{
                                xtype: 'selectfield',
                                label: 'Fan Mode',
                                margin: '15 5',
                                options: [{
                                    text: 'On Low',
                                    value: 'On Low'
                                }, {
                                    text: 'Auto Low',
                                    value: 'Auto Low'
                                }]
                            }, {
                                xtype: 'toolbar',
                                docked: 'top',
                                items: [{
                                    xtype: 'button',
                                    text: 'Cancel',
                                    scope: this,
                                    handler: function () {
                                        SetFanMode.hide();
                                    }
                                }, {
                                    xtype: 'spacer'
                                }, {
                                    xtype: 'button',
                                    text: 'Set Fan Mode',
                                    scope: this,
                                    handler: function () {
                                        var mode = SetFanMode.items.items[0].getValue()
                                        console.log('DYNAMIC_CMD_FAN MODE' + mode);


                                        Ext.Ajax.request({
                                            url: zvsMobile.app.BaseURL() + '/device/' + self.deviceID + '/command/',
                                            method: 'POST',
                                            params: {
                                                u: Math.random(),
                                                name: 'DYNAMIC_CMD_FAN MODE',
                                                arg: mode,
                                                type: 'device'
                                            },
                                            success: function (response, opts) {
                                                var result = JSON.parse(response.responseText);
                                                if (result.success) {
                                                    self.delayedReload();
                                                    //Ext.Msg.alert('Thermostat Command', 'Fan mode set to ' + mode);
                                                }
                                                else {
                                                    Ext.Msg.alert('Thermostat Command', 'Communication Error!');
                                                }
                                            }
                                        });
                                        SetFanMode.hide();
                                    }
                                }]
                            }]
                        });
                    }
                    Ext.Viewport.add(SetFanMode);
                    SetFanMode.show();
                    var ThermoTPL = Ext.getCmp('ThermoTPL');
                    var data = ThermoTPL.getData();
                    SetFanMode.items.items[0].setValue(data.fan_mode)

                }
            },
                     {
                         xtype: 'button',
                         text: 'Change Heat Point',
                         ui: 'action',
                         margin: 5,
                         flex: 1,
                         handler: function () {
                             var picker = Ext.create('Ext.Picker', {
                                 slots: [{
                                     name: 'temperature',
                                     title: 'Temperature',
                                     data: tempSetPoints
                                 }],
                                 doneButton:
                                        {
                                            xtype: 'button',
                                            text: 'Set Heat Point',
                                            handler: function () {
                                                var selected_temp = picker._slots[0].picker._values.temperature;
                                                console.log('AJAX DYNAMIC_CMD_HEATING 1' + selected_temp);
                                                Ext.Ajax.request({
                                                    url: zvsMobile.app.BaseURL() + '/device/' + self.deviceID + '/command/',
                                                    method: 'POST',
                                                    params: {
                                                        u: Math.random(),
                                                        name: 'DYNAMIC_CMD_HEATING 1',
                                                        arg: selected_temp,
                                                        type: 'device'
                                                    },
                                                    success: function (response, opts) {
                                                        var result = JSON.parse(response.responseText);
                                                        if (result.success) {
                                                            self.delayedReload();
                                                            //Ext.Msg.alert('Thermostat Command', 'Heat Point set to ' + selected_temp + '&deg; F');
                                                        }
                                                        else {
                                                            Ext.Msg.alert('Thermostat Command', 'Communication Error!');
                                                        }
                                                    }
                                                });
                                            }
                                        }
                             });

                             Ext.Viewport.add(picker);
                             picker.show();
                             var ThermoTPL = Ext.getCmp('ThermoTPL');
                             var data = ThermoTPL.getData();
                             picker.setValue({ temperature: data.heat_p }, true)
                         }
                     },
                     {
                         xtype: 'button',
                         text: 'Change Cool Point',
                         ui: 'action',
                         margin: 5,
                         flex: 1,
                         handler: function () {
                             var picker = Ext.create('Ext.Picker', {
                                 slots: [{
                                     name: 'temperature',
                                     title: 'Temperature',
                                     data: tempSetPoints
                                 }],
                                 doneButton:
                                        {
                                            xtype: 'button',
                                            text: 'Set Cool Point',
                                            handler: function () {
                                                var selected_temp = picker._slots[0].picker._values.temperature;
                                                console.log('AJAX DYNAMIC_CMD_COOLING 1 :' + selected_temp);
                                                Ext.Ajax.request({
                                                    url: zvsMobile.app.BaseURL() + '/device/' + self.deviceID + '/command/',
                                                    method: 'POST',
                                                    params: {
                                                        u: Math.random(),
                                                        name: 'DYNAMIC_CMD_COOLING 1',
                                                        arg: selected_temp,
                                                        type: 'device'
                                                    },
                                                    success: function (response, opts) {
                                                        var result = JSON.parse(response.responseText);
                                                        if (result.success) {
                                                            self.delayedReload();
                                                            //Ext.Msg.alert('Thermostat Command', 'Cool Point set to ' + selected_temp + '&deg; F');
                                                        }
                                                        else {
                                                            Ext.Msg.alert('Thermostat Command', 'Communication Error!');
                                                        }
                                                    }
                                                });
                                            }
                                        }
                             });
                             Ext.Viewport.add(picker);
                             picker.show();
                             var ThermoTPL = Ext.getCmp('ThermoTPL');
                             var data = ThermoTPL.getData();
                             picker.setValue({ temperature: data.cool_p }, true)
                         }
                     },
                     {
                         xtype: 'button',
                         text: 'Repoll',
                         ui: 'confirm',
                         margin: '30 5 5 5',
                         flex: 1,
                         handler: function () {
                             console.log('AJAX: SendCmd REPOLL_ME');

                             Ext.Ajax.request({
                                 url: zvsMobile.app.BaseURL() + '/commands/',
                                 method: 'POST',
                                 params: {
                                     u: Math.random(),
                                     name: 'REPOLL_ME',
                                     arg: self.deviceID
                                 },
                                 success: function (response, opts) {
                                     var result = JSON.parse(response.responseText);
                                     if (result.success) {
                                         self.delayedReload();
                                     }
                                     else {
                                         console.log('ERROR');
                                     }
                                 }
                             });
                         }
                     }
                ],
            listeners: {
                scope: this,
                deactivate: function () {
                    if (self.RepollTimer) { clearInterval(self.RepollTimer); }
                }
            }
        });
        this.callOverridden([config]);
    },
    delayedReload: function () {
        var self = this;
        var ThermoTPL = Ext.getCmp('ThermoTPL');
        if (self.RepollTimer) { clearInterval(self.RepollTimer); }

        self.RepollTimer = setTimeout(function () {         
            self.loadDevice(self.deviceID);
        }, 1500);
    },
    loadDevice: function (deviceId) {
        var self = this;
        var ThermoTPL = Ext.getCmp('ThermoTPL');
        self.deviceID = deviceId;
        //Get Device Details			
        console.log('AJAX: GetDeviceDetails');
        Ext.data.JsonP.request({
            url: zvsMobile.app.BaseURL() + '/device/' + deviceId,
            callbackKey: 'callback',
            params: {
                u: Math.random()
            },
            success: function (result) {
                //Send data to panel TPL                            
                ThermoTPL.setData(result.details);

                //Update meter levels 
                self.UpdateLevel(result.details.level);
            }
        });
    },
    UpdateLevel: function (value) {
        var self = this;
        var ThermoTPL = Ext.getCmp('ThermoTPL');
        //Update panel TPL        
        var data = Ext.clone(ThermoTPL._data);
        data.level = value;
        data.level_txt = value + 'F';
        ThermoTPL.setData(data);

        //Update the store 
        data = DeviceStore.data.items;
        for (i = 0, len = data.length; i < len; i++) {
            if (data[i].data.id === ThermoTPL._data.id) {
                data[i].data.level = value;
                data[i].data.level_txt = value + 'F';
            }
        }
        DeviceStore.add(data);
        //Refresh the DEvice list     
        Ext.getCmp('DeviceList').refresh();

    }
});

var tempSetPoints = [{ text: '40&deg;', value: 40 },
                    { text: '41&deg;', value: 41 },
                    { text: '42&deg;', value: 42 },
                    { text: '43&deg;', value: 43 },
                    { text: '44&deg;', value: 44 },
                    { text: '45&deg;', value: 45 },
                    { text: '46&deg;', value: 46 },
                    { text: '47&deg;', value: 47 },
                    { text: '48&deg;', value: 48 },
                    { text: '49&deg;', value: 49 },
                    { text: '50&deg;', value: 50 },
                    { text: '51&deg;', value: 51 },
                    { text: '52&deg;', value: 52 },
                    { text: '53&deg;', value: 53 },
                    { text: '54&deg;', value: 54 },
                    { text: '55&deg;', value: 55 },
                    { text: '56&deg;', value: 56 },
                    { text: '57&deg;', value: 57 },
                    { text: '58&deg;', value: 58 },
                    { text: '59&deg;', value: 59 },
                    { text: '60&deg;', value: 60 },
                    { text: '61&deg;', value: 61 },
                    { text: '62&deg;', value: 62 },
                    { text: '63&deg;', value: 63 },
                    { text: '64&deg;', value: 64 },
                    { text: '65&deg;', value: 65 },
                    { text: '66&deg;', value: 66 },
                    { text: '67&deg;', value: 67 },
                    { text: '68&deg;', value: 68 },
                    { text: '69&deg;', value: 69 },
                    { text: '70&deg;', value: 70 },
                    { text: '71&deg;', value: 71 },
                    { text: '72&deg;', value: 72 },
                    { text: '73&deg;', value: 73 },
                    { text: '74&deg;', value: 74 },
                    { text: '75&deg;', value: 75 },
                    { text: '76&deg;', value: 76 },
                    { text: '77&deg;', value: 77 },
                    { text: '78&deg;', value: 78 },
                    { text: '79&deg;', value: 79 },
                    { text: '80&deg;', value: 80 },
                    { text: '81&deg;', value: 81 },
                    { text: '82&deg;', value: 82 },
                    { text: '83&deg;', value: 83 },
                    { text: '84&deg;', value: 84 },
                    { text: '85&deg;', value: 85 },
                    { text: '86&deg;', value: 86 },
                    { text: '87&deg;', value: 87 },
                    { text: '88&deg;', value: 88 },
                    { text: '89&deg;', value: 89 },
                    { text: '90&deg;', value: 90 },
                    { text: '91&deg;', value: 91 },
                    { text: '92&deg;', value: 92 },
                    { text: '93&deg;', value: 93 },
                    { text: '94&deg;', value: 94 },
                    { text: '95&deg;', value: 95 },
                    { text: '96&deg;', value: 96 },
                    { text: '97&deg;', value: 97 },
                    { text: '98&deg;', value: 98 },
                    { text: '99&deg;', value: 99}];