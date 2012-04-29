VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmLearn 
   Caption         =   "Learn..."
   ClientHeight    =   3915
   ClientLeft      =   60
   ClientTop       =   360
   ClientWidth     =   5055
   LinkTopic       =   "Form1"
   ScaleHeight     =   3915
   ScaleWidth      =   5055
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ProgressBar pbSignalQuality 
      Height          =   1695
      Left            =   4080
      TabIndex        =   3
      Top             =   720
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   2990
      _Version        =   393216
      Appearance      =   1
      Orientation     =   1
   End
   Begin MSComctlLib.ProgressBar pbLearnProgress 
      Height          =   300
      Left            =   240
      TabIndex        =   1
      Top             =   2760
      Width           =   4575
      _ExtentX        =   8070
      _ExtentY        =   529
      _Version        =   393216
      Appearance      =   1
   End
   Begin VB.CommandButton cbCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3480
      TabIndex        =   0
      Top             =   3360
      Width           =   1335
   End
   Begin VB.Label Label5 
      Caption         =   "2. PRESS and HOLD the desired button on your Remote until Learning is Complete..."
      Height          =   495
      Left            =   240
      TabIndex        =   8
      Top             =   1320
      Width           =   3255
   End
   Begin VB.Label Label4 
      Caption         =   "1. Aim Remote directly at USB-UIRT approximately 6 inches from USB-UIRT face."
      Height          =   735
      Left            =   240
      TabIndex        =   7
      Top             =   600
      Width           =   3255
   End
   Begin VB.Label lblCarrierFreq 
      Caption         =   "---"
      Height          =   255
      Left            =   3240
      TabIndex        =   6
      Top             =   2400
      Width           =   615
   End
   Begin VB.Label Label3 
      Caption         =   "Carrier Frequency:"
      Height          =   255
      Left            =   1800
      TabIndex        =   5
      Top             =   2400
      Width           =   1335
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      Caption         =   "Signal Quality:"
      Height          =   495
      Left            =   3840
      TabIndex        =   4
      Top             =   240
      Width           =   735
   End
   Begin VB.Label Label1 
      Caption         =   "Learn Progress:"
      Height          =   255
      Left            =   240
      TabIndex        =   2
      Top             =   2400
      Width           =   1575
   End
End
Attribute VB_Name = "frmLearn"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public Sub cbCancel_Click()
    ' If the user presses the 'Cancel' button, then set the gbLrnAbort global
    ' Boolean to TRUE.  Since the address of this Boolean was passed to the call
    ' to UUIRTLearnIR, the USB-UIRT API will see this as an abort request and will
    ' return.
    gbLrnAbort = True
    Unload Me
End Sub

Private Sub Form_Unload(Cancel As Integer)
'    gbLrnAbort = True
End Sub

Private Sub pbLearnProgress_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)

End Sub
