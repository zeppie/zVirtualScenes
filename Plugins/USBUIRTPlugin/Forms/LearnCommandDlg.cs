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
    public partial class LearnCommandDlg : Form
    {
        private Controller controller;

        private string learnedCode;

        public LearnCommandDlg(Controller controller)
        {
            this.controller = controller;
            this.controller.LearnCompleted += new Controller.LearnCompletedEventHandler(controller_LearnCompleted);
            this.controller.Learning += new Controller.LearningEventHandler(controller_Learning);
            InitializeComponent();
        }

        private void AddDeviceDlg_Load(object sender, EventArgs e)
        {
        }

        void controller_Learning(object sender, LearningEventArgs e)
        {
            this.label1.Text = "The USB-UIRT is now learning.";
        }

        void controller_LearnCompleted(object sender, LearnCompletedEventArgs e)
        {
            this.learnedCode = e.Code;
            this.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.Close();
        }

        public string LearnedCode
        {
            get { return this.learnedCode; }
        }

        private void ButtonStartLearning_Click(object sender, EventArgs e)
        {
            this.ButtonStartLearning.Enabled = false;
            this.controller.Learn();
        }

    }
}
