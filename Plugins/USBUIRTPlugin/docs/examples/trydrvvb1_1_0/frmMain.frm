VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmMain 
   Caption         =   "trydrv"
   ClientHeight    =   6315
   ClientLeft      =   165
   ClientTop       =   765
   ClientWidth     =   8160
   LinkTopic       =   "Form1"
   ScaleHeight     =   6315
   ScaleWidth      =   8160
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Interval        =   100
      Left            =   7320
      Top             =   2280
   End
   Begin VB.Frame Frame1 
      Caption         =   "Received UIR Code:"
      Height          =   975
      Left            =   5280
      TabIndex        =   10
      Top             =   600
      Width           =   2775
      Begin VB.Label lblUIRCode 
         Alignment       =   2  'Center
         Caption         =   "------------"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   18
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Left            =   120
         TabIndex        =   11
         Top             =   360
         Width           =   2535
      End
   End
   Begin VB.TextBox tbCurCode 
      Height          =   2415
      Left            =   120
      MultiLine       =   -1  'True
      TabIndex        =   9
      Text            =   "frmMain.frx":0000
      Top             =   3480
      Width           =   7935
   End
   Begin MSComctlLib.Toolbar tbToolBar 
      Align           =   1  'Align Top
      Height          =   420
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Visible         =   0   'False
      Width           =   8160
      _ExtentX        =   14393
      _ExtentY        =   741
      ButtonWidth     =   609
      ButtonHeight    =   582
      Appearance      =   1
      ImageList       =   "imlToolbarIcons"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   5
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "New"
            Object.ToolTipText     =   "New"
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            BeginProperty ButtonMenus {66833FEC-8583-11D1-B16A-00C0F0283628} 
               NumButtonMenus  =   1
               BeginProperty ButtonMenu1 {66833FEE-8583-11D1-B16A-00C0F0283628} 
                  Text            =   "BMenu"
               EndProperty
            EndProperty
         EndProperty
         BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Open"
            Object.ToolTipText     =   "Open"
         EndProperty
         BeginProperty Button4 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button5 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Print"
            Object.ToolTipText     =   "Print"
         EndProperty
      EndProperty
      Enabled         =   0   'False
   End
   Begin MSComctlLib.StatusBar sbStatusBar 
      Align           =   2  'Align Bottom
      Height          =   270
      Left            =   0
      TabIndex        =   0
      Top             =   6045
      Width           =   8160
      _ExtentX        =   14393
      _ExtentY        =   476
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   3
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Object.Width           =   8731
            Text            =   "Status"
            TextSave        =   "Status"
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   6
            AutoSize        =   2
            TextSave        =   "10/7/2003"
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   5
            AutoSize        =   2
            TextSave        =   "10:23 AM"
         EndProperty
      EndProperty
   End
   Begin MSComDlg.CommonDialog dlgCommonDialog 
      Left            =   6120
      Top             =   2280
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   5280
      Top             =   2160
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   3
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":0006
            Key             =   "New"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":0118
            Key             =   "Open"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":022A
            Key             =   "Print"
         EndProperty
      EndProperty
   End
   Begin VB.Label Label4 
      Caption         =   "Current Code:"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   3240
      Width           =   1215
   End
   Begin VB.Label lblStatus 
      Height          =   495
      Left            =   120
      TabIndex        =   7
      Top             =   2640
      Width           =   6855
   End
   Begin VB.Label Label3 
      Caption         =   "Current Status:"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   2400
      Width           =   2655
   End
   Begin VB.Label lblConfig 
      Height          =   375
      Left            =   240
      TabIndex        =   5
      Top             =   1800
      Width           =   6735
   End
   Begin VB.Label Label2 
      Caption         =   "USB-UIRT Configuration:"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   1440
      Width           =   2175
   End
   Begin VB.Label lblInfo 
      Height          =   375
      Left            =   240
      TabIndex        =   3
      Top             =   960
      Width           =   6855
   End
   Begin VB.Label Label1 
      Caption         =   "USB-UIRT Info:"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   600
      Width           =   1215
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFileExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuTransmit 
      Caption         =   "&Transmit"
      Begin VB.Menu mnuTransmitTXBlock 
         Caption         =   "IR Code (&Blocking)"
      End
      Begin VB.Menu mnuTransmitTXNoBlock 
         Caption         =   "IR Code (&Non-Blocking)"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "&About "
      End
   End
   Begin VB.Menu mnuLearn 
      Caption         =   "Learn"
      Begin VB.Menu mnuLearnIRLearnPronto 
         Caption         =   "in &Pronto Format"
      End
      Begin VB.Menu mnuLearnIRLearnUIRTRaw 
         Caption         =   "in UIRT-&Raw Format"
      End
      Begin VB.Menu mnuLearnIRLearnUIRTStruct 
         Caption         =   "in UIRT-&Struct Format"
      End
      Begin VB.Menu mnuToolsIRLearnCarrierFreq 
         Caption         =   "Position Remote (get &Freq.)..."
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Subroutine to refresh USB-UIRT info on the main form.
Private Sub UpdateInfoOnScreen()
    Dim res As Boolean
    Dim UsbUirtInfo As tUuInfo
    Dim UsbUirtConfig As Long
    
    lblInfo.Caption = "---"
    lblConfig = "---"
    
    If hDrvHandle <> 0 Then
        ' Retrieve information about the USB-UIRT device...
        res = UUIRTGetUUIRTInfo(hDrvHandle, UsbUirtInfo)
        If Not res Then
            lblInfo.Caption = "*** ERROR Retrieving USB-UIRT Information! ***"
        Else
            lblInfo.Caption = "FirmwareVer=" + CStr(UsbUirtInfo.fwVersion \ 256) + "." + CStr(UsbUirtInfo.fwVersion Mod 256) + _
                              " ProtVer=" + CStr(UsbUirtInfo.protVersion \ 256) + "." + CStr(UsbUirtInfo.protVersion Mod 256) + _
                              " FirmwareDate=" + CStr(UsbUirtInfo.fwDateMonth) + "/" + CStr(UsbUirtInfo.fwDateDay) + "/" + CStr(UsbUirtInfo.fwDateYear + 2000)
        End If
        
        ' Retrieve USB-UIRT feature config...
        res = UUIRTGetUUIRTConfig(hDrvHandle, UsbUirtConfig)
        If Not res Then
            lblConfig.Caption = "*** ERROR Retrieving USB-UIRT Configuration Info! ***"
        Else
            lblConfig.Caption = "Config = " + CStr(UsbUirtConfig) + " (" + _
                                "LED_RX=" + CStr((UsbUirtConfig And UUIRTDRV_CFG_LEDRX) <> 0) + ", " + _
                                "LED_TX=" + CStr((UsbUirtConfig And UUIRTDRV_CFG_LEDTX) <> 0) + ", " + _
                                "LEGACY_RX=" + CStr((UsbUirtConfig And UUIRTDRV_CFG_LEGACYRX) <> 0) + _
                                ")"
        End If
    End If
    
    tbCurCode.Text = gIRCode
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' On initial load of the main form, OPEN the USB-UIRT API/driver and retrieve
' general information about the USB-UIRT, etc.
Private Sub Form_Load()
    Dim drvAPIVersion As Long
    Dim drvDLLVersion As Long
    Dim res As Boolean
    
    ' Get USB-UIRT *driver* information.  Note that this call does not actually
    ' communicate with the USB-UIRT hardware. Instead, its purpose is solely to
    ' retrieve version information about the API *driver*.  This and GetDrvVersion are
    ' the only API calls (besides UUIRTOpen) which can be performed without a driver
    ' handle (prior to opening the driver via UUIRTOpen).
    res = UUIRTGetDrvInfo(drvAPIVersion)
    If Not res Then
        Call MsgBox("Unable to retrieve uuirtdrv version!", vbOKOnly, "ERROR")
        End
    End If

    ' Check the API version.  This Application is written to be compatible with
    ' driver API version 1.0 (0x100)
    If drvAPIVersion <> &H100 Then
        Call MsgBox("Invalid uuirtdrv version!", vbOKOnly, "ERROR")
        End
    End If

    ' Get the Driver DLL Revision #.  This is necessary for this VB app since it this
    ' app relies on a newer feature of the LearnIR() function which does not block. This
    ' new non-blocking ability is only available in DLL versions 2.6.1 or later.
    ' NOTE: This API call does not exist in versions prior to 2.6.1, so we use the On Error
    ' to trap this condition
    On Error Resume Next
    res = False
    res = UUIRTGetDrvVersion(drvDLLVersion)
    If (Not res) Or (drvDLLVersion < 2610) Then
        Call MsgBox("This application requires USB-UIRT API driver DLL (UUIRTDRV.DLL) version 2.6.1 or later. Please verify you are running the latest API DLL and that you're using the latest version of USB-UIRT firmware!  If problem persists, contact Technical Support!", vbOKOnly, "ERROR")
        End
    End If

    ' Open a communications link with the USB-UIRT...
    If hDrvHandle = 0 Then
        ' Obtain a handle to the USB-UIRT via the UUIRTOpen call. If successful, a handle
        ' is returned which we *must* use in all subsequent APi calls.
        hDrvHandle = UUIRTOpen()
        
        ' If Open call failed, we will be returned an INVALID_HANDLE_VALUE and need to look
        ' at the error to determine what went wrong...
        If hDrvHandle = INVALID_HANDLE_VALUE Then
            If Err.LastDllError = UUIRTDRV_ERR_NO_DLL Then
                Call MsgBox("Unable to find USB-UIRT Driver. Please make sure driver is Installed!", vbOKOnly, "ERROR")
            ElseIf Err.LastDllError = UUIRTDRV_ERR_NO_DEVICE Then
                Call MsgBox("Unable to connect to USB-UIRT device!  Please ensure device is connected to the computer!", vbOKOnly, "ERROR")
            ElseIf Err.LastDllError = UUIRTDRV_ERR_NO_RESP Then
                Call MsgBox("Unable to communicate with USB-UIRT device!  Please check connections and try again.  If you still have problems, try unplugging and reconnecting your USB-UIRT.  If problem persists, contact Technical Support!", vbOKOnly, "ERROR")
            ElseIf Err.LastDllError = UUIRTDRV_ERR_VERSION Then
                Call MsgBox("Your USB-UIRT's firmware is not compatible with this API DLL. Please verify you are running the latest API DLL and that you're using the latest version of USB-UIRT firmware!  If problem persists, contact Technical Support!", vbOKOnly, "ERROR")
            Else
                Call MsgBox("Unable to initialize USB-UIRT (unknown error)!", vbOKOnly, "ERROR")
            End If
            
            End
        Else
            ' If Open was successful, we'll want to register a receive callback function
            ' for the USB-UIRT API to call each time an IR code is received.
            res = UUIRTSetReceiveCallback(hDrvHandle, AddressOf IRReceiveCallback, Me)
        End If
    End If
    
    ' Define an 'initial' IR code for our application.  This is just a sample IR code in
    ' Pronto format which was downloaded from www.remotecentral.com
    gIRCode = "0000 0071 0000 0032 0080 0040 0010 0010 0010 0030 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0030 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0030 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0030 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0030 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0010 0030 0010 0aad"
    gIRCodeFormat = UUIRTDRV_IRFMT_PRONTO
    
    lblStatus.Caption = "Idle"

    Call UpdateInfoOnScreen


    ' Create a hidden window...
    Dim hWnd   As Long
    Dim lStyle As Long
    
    lStyle = (WS_OVERLAPPED Or WS_MINIMIZE)
    
    hWnd = CreateWindowEx(0, "STATIC", "CallbackHiddenWindow", lStyle, 0, 0, 100, 100, 0, 0, 0, 0)
    
    If hWnd <> 0 Then
        gHiddenWindow = hWnd
        Call pStartMessageCapture(hWnd)
    Else
        MsgBox "Unable to create window, LastError = " & Err.LastDllError
    End If

End Sub

' When the main form is unloaded (i.e., the application is terminated), we *must* close
' our connection (if we have one established) with the USB-UIRT API.  If we don't, we will
' likely see a GPF crash!
Private Sub Form_Unload(Cancel As Integer)
    Dim i As Integer
    Dim res As Boolean

    If gHiddenWindow <> 0 Then
        Call pEndMessageCapture(gHiddenWindow)
        Call pDestroyWin(gHiddenWindow)
    End If
    
    ' close USB-UIRT if needed
    If hDrvHandle <> 0 Then
        res = UUIRTClose(hDrvHandle)
    End If

    'close all sub forms
    For i = Forms.Count - 1 To 1 Step -1
        Unload Forms(i)
    Next
End Sub

Private Sub mnuLearnIRLearnUIRTStruct_Click()
    doLearn (UUIRTDRV_IRFMT_UUIRT Or UUIRTDRV_IRFMT_LEARN_FORCESTRUC)
End Sub

Private Sub mnuLearnIRLearnUIRTRaw_Click()
    doLearn (UUIRTDRV_IRFMT_UUIRT)
End Sub

Private Sub mnuLearnIRLearnPronto_Click()
    doLearn (UUIRTDRV_IRFMT_PRONTO)
End Sub

Private Sub mnuHelpAbout_Click()
    frmAbout.Show vbModal, Me
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Example of transmitting an IR code *without* blocking.  In reality, this
' function still blocks within the function, but its intent is to demonstrate how
' a non-blocking call can be made and how the host application can detect when the
' transmission is complete.
Private Sub mnuTransmitTXNoBlock_Click()
    Dim hIrDoneEvent As Long
    Dim res As Boolean
    Dim resLong As Long
    
    gIRCode = tbCurCode.Text
    
    If hDrvHandle <> 0 Then

        ' A non-blocking call requires a WIN32 event handle to be passed as a paramter to
        ' the UUIRTTransmitIR call.
        hIrDoneEvent = CreateEvent(0, False, False, "hUSBUIRTXAckEvent")
        If hIrDoneEvent = 0 Then
            Call MsgBox("*** ERROR: unable to create Windows Event! ***", vbOKOnly, "ERROR")
        Else
            ' Once we've created a WIN32 Event, we can now call the transmit function.
            ' The transmit function should return immediately, and then we can wait for the 'Event'
            ' to be signalled by the USB-UIRT driver.
            lblStatus.Caption = "Transmitting IR Code (non-blocking)..."
            lblStatus.Refresh
            res = UUIRTTransmitIR(hDrvHandle, _
                                  gIRCode, _
                                  gIRCodeFormat, _
                                  10, _
                                  0, _
                                  hIrDoneEvent, _
                                  0, _
                                  0)
                              
            If Not res Then
                Call MsgBox("*** ERROR calling UUIRTTransmitIR! ***", vbOKOnly, "ERROR")
            Else
                ' Wait for the USB-UIRT driver to signal the event, indicating then
                ' the IR transmission has been completed.  Until this event has been
                ' signalled, the host app should *not* attempt to make calls to the USB-UIRT API!
                lblStatus.Caption = lblStatus.Caption + "...Returned from call..."
                lblStatus.Refresh
                ' Wait for event to be signalled -- we'll timeout in 10 seconds just in case --
                ' no IR transmission should take longer than 10 secs!
                resLong = WaitForSingleObject(hIrDoneEvent, 10000)
                If resLong = WAIT_OBJECT_0 Then
                    Call MsgBox("IR Transmission Complete!", vbOKOnly, "SUCCESS")
                Else
                    Call MsgBox("Timeout error waiting for IR to finish!", vbOKOnly, "ERROR")
                End If
            End If
                             
            ' We're done with the Win32 'Event', so get rid of it.
            CloseHandle (hIrDoneEvent)
        End If
    End If
    lblStatus.Caption = "Idle"
       
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Example of transmitting an IR code with blocking.  This is the 'normal' way of
' transmitting IR.
Private Sub mnuTransmitTXBlock_Click()
    Dim res As Boolean
    
    gIRCode = tbCurCode.Text
    
    If hDrvHandle <> 0 Then
        Screen.MousePointer = vbHourglass
        lblStatus.Caption = "Transmitting IR Code (blocking)..."
        lblStatus.Refresh
        
        res = UUIRTTransmitIR(hDrvHandle, _
                              gIRCode, _
                              gIRCodeFormat, _
                              10, _
                              0, _
                              0, _
                              0, _
                              0)
                              
        Screen.MousePointer = vbDefault
        lblStatus.Caption = lblStatus.Caption + "...Returned from call..."
        lblStatus.Refresh
                              
        If Not res Then
            Call MsgBox("*** ERROR calling UUIRTTransmitIR! ***", vbOKOnly, "ERROR")
        Else
            Call MsgBox("Returned from UUIRTTransmitIR call (Done)", vbOKOnly, "SUCCESS")
        End If
        
        lblStatus.Caption = "Idle"
        
    End If
End Sub

Private Sub mnuToolsIRLearnCarrierFreq_Click()
    doLearn (UUIRTDRV_IRFMT_UUIRT Or UUIRTDRV_IRFMT_LEARN_FREQDETECT)
End Sub

Private Sub mnuFileExit_Click()
    'unload the form
    Unload Me
End Sub

Private Function Trim0(sName As String) As String
   ' Right trim string at first null.
   Dim x As Integer
   x = InStr(sName, vbNullChar)
   If x > 0 Then Trim0 = Left$(sName, x - 1) Else Trim0 = sName
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Our Learn helper function. This function puts up a user modal dialog box with
' learn progress, etc.
Private Sub doLearn(uLearnFormat As Long)
    Dim res As Boolean

    If hDrvHandle <> 0 Then
        gbLrnAbort = False

        res = UUIRTLearnIR(hDrvHandle, uLearnFormat, VarPtr(szLearnBuffer(0)), AddressOf IRLearnCallback, 0, gbLrnAbort, 0, INVALID_HANDLE_VALUE, 0)
        If Err.LastDllError <> ERROR_IO_PENDING Then
            Call MsgBox("The USB-UIRT Driver Installed on your System is not compatible with this application. Please update your USB-UIRT API driver (UUIRTDRV.DLL)!", vbOKOnly, "ERROR")
        End If
    
        frmLearn.Show vbModal, Me
    
        If Not gbLrnAbort Then
            gIRCode = Trim0(StrConv(szLearnBuffer, vbUnicode))
            gIRCodeFormat = uLearnFormat
            tbCurCode.Text = gIRCode
        End If
        
    End If

End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' This is a simple timer function which sets the text color of the received IR code
' on the main form to BLACK.  When a new IR code is received, the receive callback
' function sets the text color to red and enables the timer to call this function about
' 100mS later.  This makes the text appear to 'flash' red when an IR code is received.
Private Sub Timer1_Timer()
    lblUIRCode.ForeColor = vbBlack
    Timer1.Enabled = False
End Sub
