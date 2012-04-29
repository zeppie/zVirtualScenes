Attribute VB_Name = "Module1"
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'               VISUAL BASIC SAMPLE TEST APPLICATION FOR THE USB-UIRT                '
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Option Explicit

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Structure definitions:

' Define a structure for received IR codes.
' Received IR codes are 12-ASCII bytes long, and are passed via a callback
' as a null-terminted string.  Since VB handles strings differently, we
' define a byte array and convert it to a VB string inside the callback function.
Type tIRCode
    codeData(16) As Byte
End Type
    
' Define a structure to hold UUINFO data for the UUIRTGetUUIRTInfo function call...
Type tUuInfo
    fwVersion As Long
    protVersion As Long
    fwDateDay As Byte
    fwDateMonth As Byte
    fwDateYear As Byte
End Type

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' USB-UIRT DLL API Function Declarations....
Public Declare Function UUIRTGetDrvInfo Lib "uuirtdrv.dll" _
 (ByRef uVersion As Long) As Long

Public Declare Function UUIRTGetDrvVersion Lib "uuirtdrv.dll" _
 (ByRef uVersion As Long) As Long

Public Declare Function UUIRTOpen Lib "uuirtdrv.dll" _
 () As Long

Public Declare Function UUIRTClose Lib "uuirtdrv.dll" _
 (ByVal hHandle As Long) As Long

Public Declare Function UUIRTGetUUIRTInfo Lib "uuirtdrv.dll" _
 (ByVal hHandle As Long, ByRef rUuInfo As tUuInfo) As Long

Public Declare Function UUIRTGetUUIRTConfig Lib "uuirtdrv.dll" _
 (ByVal hHandle As Long, ByRef uConfig As Long) As Long

Public Declare Function UUIRTSetUUIRTConfig Lib "uuirtdrv.dll" _
 (ByVal hHandle As Long, ByVal uConfig As Long) As Long

Public Declare Function UUIRTTransmitIR Lib "uuirtdrv.dll" _
 (ByVal hHandle As Long, ByVal sIRCode As String, ByVal uCodeFormat As Long, ByVal uRepeatCount As Long, ByVal uInactivityWaitTime As Long, ByVal hEvent As Long, ByVal reserved0 As Long, ByVal reserved1 As Long) As Long

Public Declare Function UUIRTLearnIR Lib "uuirtdrv.dll" _
 (ByVal hHandle As Long, ByVal uCodeFormat As Long, ByVal szIRCode As Long, ByVal pProgressProc As Long, ByVal userData As Long, ByRef pAbort As Boolean, ByVal uParam1 As Long, ByVal hEvent As Long, ByVal reserved0 As Long) As Long

Public Declare Function UUIRTSetReceiveCallback Lib "uuirtdrv.dll" _
 (ByVal hHandle As Long, ByVal pReceiveProc As Long, ByVal userData As Form) As Long

' USB-UIRT DLL API Constants...
Public Const INVALID_HANDLE_VALUE = -1
Public Const ERROR_IO_PENDING = 997
Public Const UUIRTDRV_ERR_NO_DEVICE = &H20000001
Public Const UUIRTDRV_ERR_NO_RESP = &H20000002
Public Const UUIRTDRV_ERR_NO_DLL = &H20000003
Public Const UUIRTDRV_ERR_VERSION = &H20000004

Public Const UUIRTDRV_CFG_LEDRX = &H1
Public Const UUIRTDRV_CFG_LEDTX = &H2
Public Const UUIRTDRV_CFG_LEGACYRX = &H4

Public Const UUIRTDRV_IRFMT_UUIRT = &H0
Public Const UUIRTDRV_IRFMT_PRONTO = &H10

Public Const UUIRTDRV_IRFMT_LEARN_FORCERAW = &H100
Public Const UUIRTDRV_IRFMT_LEARN_FORCESTRUC = &H200
Public Const UUIRTDRV_IRFMT_LEARN_FORCEFREQ = &H400
Public Const UUIRTDRV_IRFMT_LEARN_FREQDETECT = &H800

Public Const UUIRTDRV_IRFMT_TRANSMIT_DC = &H80


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' WIN32 API Function Declarations...
Declare Function CreateEvent Lib "kernel32" Alias "CreateEventA" (ByVal lpSecurityAttributes As Long, ByVal bManualReset As Boolean, ByVal bInitialState As Boolean, ByVal lpName As String) As Long
Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Boolean
Declare Function WaitForSingleObject Lib "kernel32" (ByVal hEvent As Long, ByVal dwMilliseconds As Long) As Long
Declare Function CreateThread Lib "kernel32" (ByVal _
lpSecurityAttributes As Long, ByVal dwStackSize As Long, _
ByVal lpStartAddress As Long, ByVal lpParameter As Long, _
ByVal dwCreationFlags As Long, _
lpThreadId As Long) _
As Long
'Declare Function CreateThread Lib "kernel32" (ByVal lpThreadAttributes As Long, ByVal dwStackSize As Long, ByVal lpStartAddress As Long, ByVal lpParameter As Long, ByVal dwCreationFlags As Long, ByRef lpThreadId As Long) As Long
Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Declare Function CreateWindowEx Lib "user32" _
        Alias "CreateWindowExA" (ByVal dwExStyle As Long, _
        ByVal lpClassName As String, ByVal lpWindowName As String, _
        ByVal dwStyle As Long, ByVal x As Long, ByVal y As Long, _
        ByVal nWidth As Long, ByVal nHeight As Long, _
        ByVal hWndParent As Long, ByVal hMenu As Long, _
        ByVal hInstance As Long, lpParam As Any) As Long

Declare Function DestroyWindow Lib "user32" _
        (ByVal hWnd As Long) As Long

Private Declare Function DefWindowProc Lib "user32" _
        Alias "DefWindowProcA" (ByVal hWnd As Long, _
        ByVal wMsg As Long, ByVal wParam As Long, _
        ByVal lParam As Long) As Long

Private Declare Function CallWindowProc Lib "user32" _
        Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, _
        ByVal hWnd As Long, ByVal Msg As Long, ByVal wParam As Long, _
        ByVal lParam As Long) As Long

Private Declare Function SetWindowLong Lib "user32" _
        Alias "SetWindowLongA" (ByVal hWnd As Long, _
        ByVal nIndex As Long, ByVal dwNewLong As Long) As Long

Private Declare Function GetWindowLong Lib "user32" _
        Alias "GetWindowLongA" (ByVal hWnd As Long, _
        ByVal nIndex As Long) As Long

Public Declare Sub CopyMemory Lib "kernel32" Alias _
    "RtlMoveMemory" (Destination As Any, ByVal Source As Long, _
    ByVal Length As Long)
'

' WIN32 API Constants...
Public Const WAIT_OBJECT_0 = 0
Public Const WAIT_TIMEOUT = &H102
Public Const WM_CLOSE = &H10
Public Const WM_SETTEXT = &HC
Public Const WS_OVERLAPPED = &H0&
Public Const WS_MINIMIZE = &H20000000
Private Const WM_USER As Long = &H400
Public Const WM_GOT_RECEIVE As Long = (WM_USER + &H1001)
Public Const WM_GOT_LEARNCB As Long = (WM_USER + &H1002)
Private Const GWL_WNDPROC = -4

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Global Variables:
Public fMainForm As frmMain
Public hDrvHandle As Long           ' Global to hold USB-UIRT driver handle
Public gIRCode As String            ' Global to hold 'current' learned IR code
Public gIRCodeFormat As Long        ' Global to hold 'current' learned IR format
Public gbLrnAbort As Boolean        ' Global to pass to USB-UIRT learn function for abort request
Public hLearnThreadHandle As Long   ' Global for WIN32 learn thread handle
Public gHiddenWindow As Long
Private mlOriginalWinProc As Long
Public szLearnBuffer(2048) As Byte

Sub Main()
    Set fMainForm = New frmMain
    fMainForm.Show
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' LEARN Callback function. The USB-UIRT API will call this function periodically
' during learning to update the user app on learn status, etc.
' Note since the learn callback is called in the context of a separate thread,
' it is *not* running in the context of the main VB forms.  Because of this, we must
' take care of updates we make to the VB 'Learn' dialog. In this example, we post a message
' to the hidden window we created so that the message can be processed in the main VB thread
' This function is passed in the call to UUIRTLearnIR.
Public Sub IRLearnCallback(ByVal progress As Long, ByVal sigQuality As Long, ByVal carrierFreq As Long, ByVal userData As Form)
    If progress < 0 Then progress = 255
    Call PostMessageA(gHiddenWindow, WM_GOT_LEARNCB, progress + (sigQuality * 256), carrierFreq)
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' RECEIVE callback funtion. The USB-UIRT API will call this function whenever an
' IR code is received during normal operation.  This callback was 'registered'
' via a call to UUIRTSetReceiveCallback
' Note since this callback is called in the context of a separate thread, it is *not*
' running in the context of the main VB forms.  Because of this, we must take care of
' updates we make to the main VB dialog. In this example, we post a message to the hidden
' window we created so that the message can be processed in the main VB thread
Public Sub IRReceiveCallback(ByVal IRCode As Long, ByVal userData As Long)
    Call PostMessageA(gHiddenWindow, WM_GOT_RECEIVE, 0, IRCode)
End Sub

Public Function fLocalWinProc(ByVal hWnd As Long, ByVal uMsg As Long, _
    ByVal wParam As Long, ByVal lParam As Long) As Long

    Dim IRCode As tIRCode
    
    Select Case uMsg
        Case WM_GOT_RECEIVE:
            Call CopyMemory(IRCode, lParam, 16)
            fMainForm.lblUIRCode.Caption = StrConv(IRCode.codeData, vbUnicode)
            fMainForm.lblUIRCode.ForeColor = vbRed
            fMainForm.Timer1.Enabled = True
            '
            ' lParam has the window handle from the timer
            ' callback procedure for the timer to fire.
            '
            fLocalWinProc = DefWindowProc(hWnd, uMsg, wParam, lParam)
        Case WM_GOT_LEARNCB:
            Dim progress As Integer
            
            progress = wParam Mod 256
            If progress = 255 Then
                Unload frmLearn 'CCall SendMessage(frmLearn, WM_CLOSE, 0, 0)
            Else
                frmLearn.pbLearnProgress.Value = progress
                frmLearn.pbSignalQuality.Value = wParam \ 256
                frmLearn.lblCarrierFreq.Caption = CStr(lParam \ 1000) + "." + CStr((lParam Mod 1000) \ 100) + "KHz"
            End If
            
            fLocalWinProc = DefWindowProc(hWnd, uMsg, wParam, lParam)
       
        Case Else:
            fLocalWinProc = CallWindowProc(mlOriginalWinProc, hWnd, uMsg, wParam, lParam)
    End Select
End Function

Public Sub pDestroyWin(ByVal hWnd As Long)
    '
    ' Close window.
    '
    Call PostMessageA(hWnd, WM_CLOSE, 0, 0)
End Sub

Public Sub pStartMessageCapture(ByVal hWnd As Long)
    Dim lWinProc As Long
    
    mlOriginalWinProc = 0
    
    lWinProc = GetWindowLong(hWnd, GWL_WNDPROC)
    
    If lWinProc <> 0 Then
        Call SetWindowLong(hWnd, GWL_WNDPROC, AddressOf fLocalWinProc)
    Else
        Err.Raise 51, "", "Unable to get default window proc handle"
    End If
    
    mlOriginalWinProc = lWinProc
End Sub

Public Sub pEndMessageCapture(ByVal hWnd As Long)
    Call SetWindowLong(hWnd, GWL_WNDPROC, mlOriginalWinProc)
End Sub

