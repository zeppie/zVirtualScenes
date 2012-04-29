﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using zVirtualScenesApplication.Structs;
using zVirtualScenesAPI;
using zVirtualScenesApplication.Globals;
using zVirtualScenesCommon.Entity;
using zVirtualScenesCommon;

namespace zVirtualScenesApplication
{
    public partial class formPropertiesScene : Form
    {
        private long Scene_ID = 0;       

        public formPropertiesScene(long Scene_ID)
        {
            this.Scene_ID = Scene_ID;
            InitializeComponent();            
        }

        private void btn_Save_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtb_sceneName.Text))
            {
                MessageBox.Show("Invalid scene name.", zvsEntityControl.zvsNameAndVersion);
            }
            else
            {
                using (zvsEntities2 db = new zvsEntities2(zvsEntityControl.GetzvsConnectionString))
                {
                    scene scene = db.scenes.FirstOrDefault(s => s.id == Scene_ID);
                    if (scene != null)
                    {
                        scene.friendly_name = txtb_sceneName.Text;
                        db.SaveChanges();
                    }
                }
                zvsEntityControl.CallSceneModified(this, Scene_ID);
            }   
        }

        private void formSceneProperties_Load(object sender, EventArgs e)
        {
            using (zvsEntities2 db = new zvsEntities2(zvsEntityControl.GetzvsConnectionString))
            {
                scene scene = db.scenes.FirstOrDefault(s => s.id == Scene_ID);
                if (scene != null)
                {
                    txtb_sceneName.Text = scene.friendly_name;
                    ActiveControl = txtb_sceneName;
                    CreateDynamicProperties(scene,db);
                }
                else
                    this.Close();
            }
        }

        private void CreateDynamicProperties(scene scene, zvsEntities2 db)
        {            
            pnlSceneProperties.Controls.Clear();
            int top = 0;

            #region Properties                                
            top += 10;
            foreach (scene_property property in db.scene_property)
            {
                int left = 0;
                    
                //Get Value
                string value = string.Empty;
                if (scene.scene_property_value.Any(sp => sp.scene_property_id == property.id))
                {
                    value = scene.scene_property_value.FirstOrDefault(sp => sp.scene_property_id == property.id).value;
                }
                else
                {
                    value = property.defualt_value;                            
                }                    
                    
                #region Input Boxes                                      
                left = GlobalMethods.DrawDynamicUserInputBoxes(pnlSceneProperties, 
                                                                (Data_Types)property.value_data_type, 
                                                                top, 
                                                                left,
                                                                property.id + "-proparg",
                                                                property.friendly_name,
                                                                property.scene_property_option.Select(o=> o.option).ToList(),
                                                                value,
                                                                "");

                #endregion

                #region Add Button
                Button btn = new Button();
                btn.Name = property.friendly_name;
                btn.Text = ((Data_Types)property.value_data_type == Data_Types.NONE ? "" : "Save ") + property.friendly_name;
                btn.Click += new EventHandler(btn_Click_Property_Set);
                btn.Tag = property;
                btn.Top = top;
                btn.Left = left;
                pnlSceneProperties.Controls.Add(btn);

                using (Graphics cg = this.CreateGraphics())
                {
                    SizeF size = cg.MeasureString(btn.Text, btn.Font);
                    size.Width += 10; //add some padding
                    btn.Width = (int)size.Width;
                    left = (int)size.Width + left + 5;
                }
                #endregion

                #region Add Description
                Label lbl = new Label();
                lbl.Text = property.description;
                lbl.Top = top +4;
                lbl.Left = left;
                lbl.AutoSize = false;
                pnlSceneProperties.Controls.Add(lbl);

                using (Graphics cg = this.CreateGraphics())
                {
                    SizeF size = cg.MeasureString(lbl.Text, lbl.Font);
                    size.Width += 10; //add some padding
                    lbl.Width = (int)size.Width;
                    left = (int)size.Width + left + 5;
                }
                #endregion

                top += 35;
            }
            #endregion
            
        }

        void btn_Click_Property_Set(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            scene_property property = (scene_property)btn.Tag;

            string arg = String.Empty;

            switch ((Data_Types)property.value_data_type)
            {
                case Data_Types.NONE:
                    break;
                case Data_Types.DECIMAL:
                case Data_Types.INTEGER:
                case Data_Types.SHORT:
                case Data_Types.BYTE:
                    //NumericUpDown have built in self validation
                    if (pnlSceneProperties.Controls.ContainsKey(property.id + "-proparg"))
                        arg = ((NumericUpDown)pnlSceneProperties.Controls[property.id + "-proparg"]).Value.ToString();
                    break;
                case Data_Types.BOOL:
                    if (pnlSceneProperties.Controls.ContainsKey(property.id + "-proparg"))
                        arg = ((CheckBox)pnlSceneProperties.Controls[property.id + "-proparg"]).Checked.ToString();
                    break;
                case Data_Types.STRING:
                    if (pnlSceneProperties.Controls.ContainsKey(property.id + "-proparg"))
                        arg = ((TextBox)pnlSceneProperties.Controls[property.id + "-proparg"]).Text;
                    break;
                case Data_Types.LIST:
                    if (pnlSceneProperties.Controls.ContainsKey(property.id + "-proparg"))
                        arg = ((ComboBox)pnlSceneProperties.Controls[property.id + "-proparg"]).Text;
                    break;
            }

            using (zvsEntities2 db = new zvsEntities2(zvsEntityControl.GetzvsConnectionString))
            {
                scene scene = db.scenes.FirstOrDefault(s => s.id == Scene_ID);
                if (scene != null)
                {
                    if (scene.scene_property_value.Any(sp => sp.scene_property_id == property.id))                    
                        scene.scene_property_value.FirstOrDefault(sp => sp.scene_property_id == property.id).value = arg;                    
                    else                    
                        scene.scene_property_value.Add(new scene_property_value { value = arg, scene_property_id = property.id });
                    
                    db.SaveChanges();
                }
            }
            zvsEntityControl.CallSceneModified(this, Scene_ID);
        }

        private void txtb_sceneName_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                btn_Save_Click((object)sender, (EventArgs)e);
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void lblResetSceneRunning_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Are you sure you want to reset the isRunning property for this scene?", "Are you sure?",
                                        MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                using (zvsEntities2 db = new zvsEntities2(zvsEntityControl.GetzvsConnectionString))
                {
                    scene scene = db.scenes.FirstOrDefault(s => s.id == Scene_ID);
                    if (scene != null)
                    {
                        scene.is_running = false; 
                        db.SaveChanges();
                    }
                }
                zvsEntityControl.CallSceneModified(this, Scene_ID);
            }
        }                
    }       
}
