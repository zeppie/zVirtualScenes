using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using UsbUirt;

namespace USBUIRTPlugin.Forms
{
    public partial class AddDeviceDlg : Form
    {
        private Controller controller;

        public AddDeviceDlg(Controller controller)
        {
            this.controller = controller;
            InitializeComponent();
        }

        private void ButtonAddDevice_Click(object sender, EventArgs e)
        {

        }

        public string DeviceName
        {
            get { return this.txtDeviceName.Text; }
        }
    }
}
