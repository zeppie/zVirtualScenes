using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using zVirtualScenesCommon.Entity;
using System.Net.Sockets;
using System.Net;

namespace HttpAPI
{
    class EventBroadcaster
    {
        private Socket socket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
        private IPEndPoint ipEndPoint;

        public EventBroadcaster(int port)
        {
            this.ipEndPoint = new IPEndPoint(IPAddress.Broadcast, port);
            this.socket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.Broadcast, 1);

            this.BindEvents();
        }

        protected void BindEvents()
        {
            builtin_command_que.BuiltinCommandRunCompleteEvent += new builtin_command_que.BuiltinCommandRunCompleteEventHandler(builtin_command_que_BuiltinCommandRunCompleteEvent);
            device_type_command_que.DeviceTypeCommandRunCompleteEvent += new device_type_command_que.DeviceTypeCommandRunCompleteEventHandler(device_type_command_que_DeviceTypeCommandRunCompleteEvent);
            device_command_que.DeviceCommandRunCompleteEvent += new device_command_que.DeviceCommandRunCompleteEventHandler(device_command_que_DeviceCommandRunCompleteEvent);
            zvsEntityControl.SceneRunStartedEvent += new zvsEntityControl.SceneRunStartedEventHandler(zvsEntityControl_SceneRunStartedEvent);
            zvsEntityControl.SceneRunCompleteEvent += new zvsEntityControl.SceneRunCompleteEventHandler(zvsEntityControl_SceneRunCompleteEvent);
            device_values.DeviceValueDataChangedEvent += new device_values.ValueDataChangedEventHandler(device_values_DeviceValueDataChangedEvent);
            device_values.DeviceValueAddedEvent += new device_values.DeviceValueAddedEventHandler(device_values_DeviceValueAddedEvent);
            zvsEntityControl.DeviceModified += new zvsEntityControl.DeviceModifiedEventHandler(zvsEntityControl_DeviceModified);
            device.Added += new device.DeviceAddedEventHandler(device_Added);
            zvsEntityControl.ScheduledTaskModified += new zvsEntityControl.ScheduledTaskModifiedEventHandler(zvsEntityControl_ScheduledTaskModified);
            zvsEntityControl.TriggerModified += new zvsEntityControl.TriggerModifiedEventHandler(zvsEntityControl_TriggerModified);
            zvsEntityControl.SceneModified += new zvsEntityControl.SceneModifiedEventHandler(zvsEntityControl_SceneModified);
        }

        private void BroadcastEvent(string eventName)
        {
            byte[] data = Encoding.ASCII.GetBytes("&&" + eventName);
            this.socket.SendTo(data, this.ipEndPoint);
        }

        void zvsEntityControl_SceneModified(object sender, long? SceneID)
        {
            this.BroadcastEvent("SceneModified");
        }

        void zvsEntityControl_TriggerModified(object sender, string PropertyModified)
        {
            this.BroadcastEvent("TriggerModified." + PropertyModified);
        }

        void zvsEntityControl_ScheduledTaskModified(object sender, string PropertyModified)
        {
            this.BroadcastEvent("ScheduledTaskModified." + PropertyModified);
        }

        void device_Added(object sender, EventArgs e)
        {
            this.BroadcastEvent("DeviceAdded");
        }

        void zvsEntityControl_DeviceModified(object sender, string PropertyModified)
        {
            this.BroadcastEvent("DeviceModified." + PropertyModified);
        }

        void device_values_DeviceValueAddedEvent(object sender, EventArgs e)
        {
            
        }

        void device_values_DeviceValueDataChangedEvent(object sender, device_values.ValueDataChangedEventArgs args)
        {
            
        }

        void zvsEntityControl_SceneRunCompleteEvent(long scene_id, int ErrorCount)
        {
            
        }

        void zvsEntityControl_SceneRunStartedEvent(scene s, string result)
        {
            
        }

        void device_command_que_DeviceCommandRunCompleteEvent(device_command_que cmd, bool withErrors, string txtError)
        {
            
        }

        void device_type_command_que_DeviceTypeCommandRunCompleteEvent(device_type_command_que cmd, bool withErrors, string txtError)
        {
            
        }

        void builtin_command_que_BuiltinCommandRunCompleteEvent(builtin_command_que cmd, bool withErrors, string txtError)
        {
            
        }


    }
}
