'--------------------------------------------------------------
'                   Thomas Jensen | uCtrl.net
'--------------------------------------------------------------
'  file: AVR_ALARM
'  date: 07/11/2007
'--------------------------------------------------------------
$regfile = "attiny2313.dat"
$crystal = 8000000
Config Portd = Input
Config Portb = Output
Config Watchdog = 1024

Dim Lifesignal As Byte , Alloff As Byte , Nokkel As Byte , Nokkel_turned As Byte
Dim Horn As Byte , Armed As Byte , Button1 As Byte , Button2 As Byte
Dim Modesel As Byte , A As Byte , Alarmled As Byte , Utlost As Byte , B As Byte

'In:
'PD0 Key switch N.O
'PD1 Key switch N.C
'PD2 Alarm trigger N.C
'PD3 Buzzer trigger
'PD4 Trigger mode 1
'PD5 Trigger mode 2
'PD6 Tamper N.C

'Out:
'PB0 Alarm LED
'PB1 Green LED
'PB2 Red LED
'PB3 Buzzer
'PB4 Siren
'PB5 Lights out signal
'PB6 Away mode signal
'PB7 Lifesignal

If Pind.0 = 0 Then Nokkel = 1
If Pind.1 = 0 Then Nokkel = 2
If Nokkel = 0 Then Portb.3 = 1

Do
Portb.0 = 1
Waitms 100
Gosub Doloop
Portb.0 = 0
If Nokkel_turned = 1 Then
   Nokkel_turned = 0
   Start Watchdog
   Goto Main
   End If
Waitms 100
Gosub Doloop
Loop

Main:
If Nokkel_turned = 1 And Armed = 0 Then                     'key NO and NC
   Nokkel_turned = 0
   Portb.0 = 0
   For A = 1 To 7
   Portb.1 = 1
   Portb.2 = 0
   For B = 1 To 15
   Waitms 100
   Gosub Doloop
   Next B
   If Nokkel_turned = 1 Then Goto Selectmode
   Portb.1 = 0
   Portb.2 = 1
   For B = 1 To 15
   Waitms 100
   Gosub Doloop
   Next B
   If Nokkel_turned = 1 Then Goto Selectmode
   Next A
   Portb.1 = 0
   Portb.2 = 0
End If

If Nokkel_turned = 1 And Armed = 1 Then
   Nokkel_turned = 0
   Modesel = 0
   Armed = 0
   End If

If Modesel = 2 And Armed = 0 Then                           'arm alarm
      If Pind.2 = 1 Or Pind.6 = 1 Then
      Horn = 10
      Modesel = 0
      Goto Main
      End If
   Utlost = 0
   For A = 1 To 60
   Portb.0 = 1
   Portb.1 = 1
   Portb.3 = 1
   Waitms 100
   Portb.3 = 0
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   Waitms 100
   If Pind.6 = 1 Then Portb.3 = 1
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   Portb.0 = 0
   Portb.1 = 0
   Waitms 100
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   Waitms 100
   Portb.3 = 0
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   If Nokkel_turned = 1 Then
      Nokkel_turned = 0
      Modesel = 0
      Goto Main
      End If
   Next A
      If Pind.2 = 1 Then
      Horn = 10
      Modesel = 0
      Goto Main
      End If
   Armed = 1
   Alloff = 5
   End If

If Armed = 1 Then Portb.6 = 1

If Armed = 1 And Modesel = 2 Then
   If Alarmled = 0 Then Alarmled = 10
   If Pind.2 = 1 Then Goto Alarm
End If

If Armed = 0 Then
   Portb.6 = 0
   If Utlost = 1 Then Portb.0 = 1
   If Modesel = 1 Then
      Alarmled = 10
      Armed = 1
      Alloff = 5
      End If
End If

Waitms 100
Gosub Doloop
Goto Main
End

Alarm:                                                      'alarm triggered
   For A = 1 To 30
   Portb.0 = 1
   Portb.2 = 1
   Portb.3 = 1
   Waitms 100
   Portb.0 = 0
   Gosub Doloop
   Waitms 100
   Portb.0 = 1
   Gosub Doloop
   Waitms 100
   Portb.0 = 0
   Gosub Doloop
   Waitms 100
   Portb.0 = 1
   Gosub Doloop
   Waitms 100
   Portb.0 = 0
   Portb.2 = 0
   Portb.3 = 0
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   If Nokkel_turned = 1 Then
      Nokkel_turned = 0
      Modesel = 0
      Armed = 0
      Goto Main
      End If
   If Pind.6 = 1 Then Goto Sirene
   Next A

   Sirene:                                                  'siren
   For A = 1 To 60
   Utlost = 1
   Portb.0 = 1
   Portb.3 = 1
   Portb.4 = 1
   Waitms 100
   Portb.0 = 0
   Gosub Doloop
   Waitms 100
   Portb.0 = 1
   Gosub Doloop
   Waitms 100
   Portb.0 = 0
   Gosub Doloop
   Waitms 100
   Portb.0 = 1
   Gosub Doloop
   Waitms 100
   Portb.0 = 0
   Portb.3 = 0
   Waitms 100
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   Waitms 100
   Gosub Doloop
   If Nokkel_turned = 1 Then
      Nokkel_turned = 0
      Portb.4 = 0
      Modesel = 0
      Armed = 0
      Goto Main
      End If
   Next A
   Portb.4 = 0
   Goto Main

End

Selectmode:                                                 'select mode
Nokkel_turned = 0
If Portb.1 = 1 Then Modesel = 1
If Portb.2 = 1 Then Modesel = 2
Portb.1 = 0
Portb.2 = 0
Goto Main
End

Doloop:
'Key turned
If Pind.0 = 0 And Pind.1 = 1 And Nokkel = 2 Then            '1
   Nokkel = 1
   Nokkel_turned = 1
   End If
If Pind.0 = 1 And Pind.1 = 0 And Nokkel = 1 Then            '2
   Nokkel = 2
   Nokkel_turned = 1
   End If

'Ext button 1
If Pind.4 = 0 And Button1 = 0 Then
   Button1 = 1
   If Modesel = 1 Then
      Nokkel_turned = 1
      Goto Endofbutton1
      End If
   If Modesel = 0 Then Modesel = 1
   Endofbutton1:
   End If
If Pind.4 = 1 Then Button1 = 0

'Ext button 2
If Pind.5 = 0 And Button2 = 0 Then
   Button2 = 1
   If Modesel = 2 Then
      Nokkel_turned = 1
      Goto Endofbutton2
      End If
   If Modesel = 0 Then Modesel = 2
   Endofbutton2:
   End If
If Pind.5 = 1 Then Button2 = 0

'Buzzer
If Pind.3 = 0 And Horn = 0 Then Horn = 10
If Horn = 10 Then Portb.3 = 1
If Horn = 7 Then Portb.3 = 0
If Horn > 0 Then Horn = Horn - 1

'All off
If Alloff = 5 Then Portb.5 = 1
If Alloff = 2 Then Portb.5 = 0
If Alloff > 0 Then Alloff = Alloff - 1

'AlarmLED
If Alarmled = 10 Then Portb.0 = 1
If Alarmled = 9 Then Portb.0 = 0
If Alarmled > 0 Then Alarmled = Alarmled - 1

'Lifesignal
If Lifesignal > 0 Then Lifesignal = Lifesignal - 1
If Lifesignal = 6 Then Portb.7 = 1
If Lifesignal = 1 Then Portb.7 = 0
If Lifesignal = 0 Then Lifesignal = 21

Reset Watchdog
Return
End