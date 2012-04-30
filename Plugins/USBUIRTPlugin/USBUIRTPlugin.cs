using System.Net.Sockets;
using System.ComponentModel.Composition;
using System.Collections.Generic;
using System;
using System.Net;
using System.Threading;
using System.Text;
using System.Data;
using zVirtualScenesAPI;
using zVirtualScenesCommon;
using zVirtualScenesCommon.Entity;
using System.Linq;
using UsbUirt;

namespace USBUIRTPlugin
{
    [Export(typeof(Plugin))]
    public class USBUIRTPlugin : Plugin
    {
        public const int ControllerNodeId = 1;

        public volatile bool isActive;

        private Controller controller;

        private device_types infraredType;

        public USBUIRTPlugin()
            : base("USBUIRT",
               "USB-UIRT Plugin",
                "This plug-in interacts with infrared devices."
                ) { }

        public override void Initialize()
        {
            DefineOrUpdateSetting(new plugin_settings
            {
                name = "COMPORT",
                friendly_name = "Com Port",
                value = (4).ToString(),
                value_data_type = (int)Data_Types.COMPORT,
                description = "The COM port that your USB-UIRT is assigned to."
            });

            // The USB-UIRT device type
            device_types usbuirtType = new device_types { name = "USBUIRT", friendly_name = "USB-UIRT", show_in_list = true };
            usbuirtType.device_type_commands.Add(new device_type_commands { 
                name = "ADD", 
                friendly_name = "Add device", 
                arg_data_type = (int)Data_Types.NONE, 
                description = "Add a new infrared device." 
            });
            DefineOrUpdateDeviceType(usbuirtType);

            // An infrared device type
            this.infraredType = new device_types { name = "INFRARED", friendly_name = "Infrared", show_in_list = true };
            this.infraredType.device_type_commands.Add(new device_type_commands { 
                name = "LEARN", 
                friendly_name = "Learn Command", 
                arg_data_type = (int)Data_Types.NONE, 
                description = "Teaches the device a new command." 
            });
            DefineOrUpdateDeviceType(this.infraredType);
        }

        protected void CreateNewInfraredDevice(string deviceName)
        {
            using (zvsEntities2 db = new zvsEntities2(zvsEntityControl.GetzvsConnectionString))
            {
                device ir_device = GetDevices(db).FirstOrDefault(d => d.friendly_name == deviceName);
                if (ir_device == null)
                {
                    ir_device = new device
                    {
                        device_types = GetDeviceType("INFRARED", db),
                        friendly_name = deviceName
                    };

                    db.devices.AddObject(ir_device);
                    db.SaveChanges();

                    ir_device.CallAdded(new EventArgs());
                }
            }
        }
               
        protected override bool StartPlugin()
        {
            WriteToLog(Urgency.INFO, this.Friendly_Name + " plugin started.");

            // The USB-UIRT device
            using (zvsEntities2 db = new zvsEntities2(zvsEntityControl.GetzvsConnectionString))
            {
                device usbUirt = GetDevices(db).FirstOrDefault(d => d.node_id == ControllerNodeId);
                //If we dont already have the device
                if (usbUirt == null)
                {
                    usbUirt = new device
                    {
                        node_id = ControllerNodeId,
                        device_types = GetDeviceType("USBUIRT", db),
                        friendly_name = "USB-UIRT"
                    };

                    db.devices.AddObject(usbUirt);
                    db.SaveChanges();

                    usbUirt.CallAdded(new EventArgs());
                }
            }

            IsReady = true;
            return true;
        }

        protected override void SettingChanged(string settingName, string settingValue)
        {
            switch (settingName)
            {
                case "Com Port":
                    // Set the port here
                    break;
            }
        } 

        protected override bool StopPlugin()
        {
            WriteToLog(Urgency.INFO, this.Friendly_Name + " plugin ended.");
            Disconnect();

            //Wait to shutdown
            System.Threading.Thread.Sleep(500);
            isActive = false;

            device_values.DeviceValueDataChangedEvent -= new device_values.ValueDataChangedEventHandler(device_values_DeviceValueDataChangedEvent);
            
            IsReady = false;
            return true;
        }

        void device_values_DeviceValueDataChangedEvent(object sender, device_values.ValueDataChangedEventArgs args)
        {
        }

        public override bool ProcessDeviceCommand(device_command_que cmd)
        {
            return true;
        }

        public override bool ProcessDeviceTypeCommand(device_type_command_que cmd)
        {
            if (cmd.device.device_types.name == "USBUIRT")
            {
                switch (cmd.device_type_commands.name)
                {
                    case "ADD":
                        var addDeviceForm = new Forms.AddDeviceDlg(this.controller);
                        if (addDeviceForm.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                        {
                            this.CreateNewInfraredDevice(addDeviceForm.DeviceName);
                        }
                        break;
                }
            }
            else if (cmd.device.device_types.name == "INFRARED")
            {
                switch (cmd.device_type_commands.name)
                {
                    case "LEARN":
                        var learnForm = new Forms.LearnCommandDlg(this.controller);
                        if (learnForm.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                        {

                        }
                        break;
                }
            }

            return true;
        }

        public override bool Repoll(device device)
        {
            return true;
        }

        public override bool ActivateGroup(long groupID)
        {
            return true;
        }

        public override bool DeactivateGroup(long groupID)
        {
            return true;
        }

        public void Disconnect()
        {
        }
    }
    
}

