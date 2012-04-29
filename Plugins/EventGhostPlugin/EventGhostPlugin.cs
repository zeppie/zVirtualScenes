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

namespace EventGhostPlugin
{
    [Export(typeof(Plugin))]
    public class EventGhostPlugin : Plugin
    {
        public volatile bool isActive;

        public EventGhostPlugin()
            : base("EventGhost",
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
        }
               
        protected override bool StartPlugin()
        {
            WriteToLog(Urgency.INFO, this.Friendly_Name + " plugin started.");

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

