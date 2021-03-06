﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using zVirtualScenesAPI;
using System.ComponentModel.Composition;
using zVirtualScenesCommon.Entity;
using zVirtualScenesCommon;
using System.Net.Sockets;
using System.Net;

namespace EventBroadcaster
{
    [Export(typeof(Plugin))]
    public class EventBroadcasterPlugin : Plugin
    {
        private Socket socket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
        private IPEndPoint ipEndPoint;

        public EventBroadcasterPlugin()
            : base("EventBroadcasterPlugin", "Event Broadcaster", "Broadcasts events through UDP")
        {

        }

        public override void Initialize()
        {
            DefineOrUpdateSetting(new plugin_settings
            {
                name = "PORT",
                friendly_name = "Port",
                value = (33333).ToString(),
                value_data_type = (int)Data_Types.INTEGER,
                description = "The UDP port to broadcast via."
            });

            DefineOrUpdateSetting(new plugin_settings
            {
                name = "DELIMITER",
                friendly_name = "Delimiter",
                value = ".",
                value_data_type = (int)Data_Types.STRING,
                description = "The delimiter between the event segments."
            });
        }

        protected override bool StartPlugin()
        {
            this.ipEndPoint = new IPEndPoint(IPAddress.Broadcast, int.Parse(GetSettingValue("PORT")));
            this.socket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.Broadcast, 1);

            this.BindEvents();

            return true;
        }

        protected override bool StopPlugin()
        {
            this.BindEvents();

            return true;
        }

        protected void BindEvents()
        {
            zvsEntityControl.SceneRunStartedEvent += zvsEntityControl_SceneRunStartedEvent;
            zvsEntityControl.SceneRunCompleteEvent += zvsEntityControl_SceneRunCompleteEvent;
            builtin_command_que.BuiltinCommandRunCompleteEvent += builtin_command_que_BuiltinCommandRunCompleteEvent;
            device_type_command_que.DeviceTypeCommandRunCompleteEvent += device_type_command_que_DeviceTypeCommandRunCompleteEvent;
            device_values.DeviceValueDataChangedEvent -= device_values_DeviceValueDataChangedEvent;
            device_values.DeviceValueAddedEvent += device_values_DeviceValueAddedEvent;

            //device_command_que.DeviceCommandRunCompleteEvent += device_command_que_DeviceCommandRunCompleteEvent;
            //device_values.DeviceValueDataChangedEvent += device_values_DeviceValueDataChangedEvent;
            //zvsEntityControl.DeviceModified += zvsEntityControl_DeviceModified;
            //device.Added += device_Added;
            //zvsEntityControl.ScheduledTaskModified += zvsEntityControl_ScheduledTaskModified;
            //zvsEntityControl.TriggerModified += zvsEntityControl_TriggerModified;
            //zvsEntityControl.SceneModified += zvsEntityControl_SceneModified;
        }

        protected void UnbindEvents()
        {
            zvsEntityControl.SceneRunStartedEvent -= zvsEntityControl_SceneRunStartedEvent;
            zvsEntityControl.SceneRunCompleteEvent -= zvsEntityControl_SceneRunCompleteEvent;
            builtin_command_que.BuiltinCommandRunCompleteEvent -= builtin_command_que_BuiltinCommandRunCompleteEvent;
            device_type_command_que.DeviceTypeCommandRunCompleteEvent -= device_type_command_que_DeviceTypeCommandRunCompleteEvent;
            device_values.DeviceValueDataChangedEvent -= device_values_DeviceValueDataChangedEvent;
            device_values.DeviceValueAddedEvent -= device_values_DeviceValueAddedEvent;

            //device_command_que.DeviceCommandRunCompleteEvent -= device_command_que_DeviceCommandRunCompleteEvent;
            //device_values.DeviceValueAddedEvent -= device_values_DeviceValueAddedEvent;
            //zvsEntityControl.DeviceModified -= zvsEntityControl_DeviceModified;
            //device.Added -= device_Added;
            //zvsEntityControl.ScheduledTaskModified -= zvsEntityControl_ScheduledTaskModified;
            //zvsEntityControl.TriggerModified -= zvsEntityControl_TriggerModified;
            //zvsEntityControl.SceneModified -= zvsEntityControl_SceneModified;
        }

        private void BroadcastEvent(params string[] eventSegments)
        {
            var delimiter = GetSettingValue("DELIMITER");

            string eventName = String.Join(delimiter, eventSegments);

            byte[] data = Encoding.ASCII.GetBytes(eventName);
            this.socket.SendTo(data, this.ipEndPoint);
        }

        protected override void SettingChanged(string settingName, string settingValue)
        {
            switch (settingName)
            {
                case "Port":
                    this.ipEndPoint = new IPEndPoint(IPAddress.Broadcast, int.Parse(settingValue));
                    break;
            }
        }

        void zvsEntityControl_SceneModified(object sender, long? SceneID)
        {
            if (SceneID != null)
            {
                this.BroadcastEvent("SceneModified", SceneID.ToString());
            }
        }

        void zvsEntityControl_TriggerModified(object sender, string PropertyModified)
        {
            this.BroadcastEvent("TriggerModified", PropertyModified);
        }

        void zvsEntityControl_ScheduledTaskModified(object sender, string PropertyModified)
        {
            this.BroadcastEvent("ScheduledTaskModified", PropertyModified);
        }

        void device_Added(object sender, EventArgs e)
        {
            this.BroadcastEvent("DeviceAdded");
        }

        void zvsEntityControl_DeviceModified(object sender, string PropertyModified)
        {
            this.BroadcastEvent("DeviceModified", PropertyModified);
        }

        void device_values_DeviceValueAddedEvent(object sender, EventArgs e)
        {
            this.BroadcastEvent("DeviceValueAdded");
        }

        void device_values_DeviceValueDataChangedEvent(object sender, device_values.ValueDataChangedEventArgs args)
        {
            this.BroadcastEvent("DeviceValueDataChanged", args.device_value_id.ToString(), args.previousValue.ToString());
        }

        void zvsEntityControl_SceneRunCompleteEvent(long scene_id, int ErrorCount)
        {
            this.BroadcastEvent("SceneRunComplete", scene_id.ToString());
        }

        void zvsEntityControl_SceneRunStartedEvent(scene s, string result)
        {
            this.BroadcastEvent("SceneRunStarted", s.id.ToString());
        }

        void device_command_que_DeviceCommandRunCompleteEvent(device_command_que cmd, bool withErrors, string txtError)
        {
            this.BroadcastEvent("DeviceCommandRunComplete", cmd.id.ToString());
        }

        void device_type_command_que_DeviceTypeCommandRunCompleteEvent(device_type_command_que cmd, bool withErrors, string txtError)
        {
            this.BroadcastEvent("DeviceTypeCommandRunComplete", cmd.id.ToString());
        }

        void builtin_command_que_BuiltinCommandRunCompleteEvent(builtin_command_que cmd, bool withErrors, string txtError)
        {
            this.BroadcastEvent("BuiltinCommandRunComplete", cmd.id.ToString());
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
    }
}
