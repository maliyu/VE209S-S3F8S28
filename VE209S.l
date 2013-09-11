Wed Sep 11 18:04:47 2013
                              
     SAM8 Assembler Ver. 2.15T(Win32) Copyright (c) 2003 Samsung Electronics Co.
                             
    --------------------------------------------------------------------
                       Source File Name : VE209S.src
                       Output File Name : VE209S.o
                       List File Name   : VE209S.l
    1                    ;************************************************************************
    2                    ;************************************************************************
    3                    ;***********************  8S28 for VE209S    ****************************
    4                    ;************************************************************************
    5                    ;************************************************************************ 
    6                    ;-----------------------File description--------------------------------- 
    7                    ;         LED control program for VE209S 
    8                    ;         Main function
    9                    ;------------------------------------------------------------------------
   10                    ;------------------------Function list-----------------------------------
   11                    ;    --Function name--   |     --Type--        |       --Description--
   12                    ;     SMART OPTION                  sector              Smart option setting
   13                    ;     Interrupt vector              sector              Interrupt vector
   14                    ;     RESET                         reset function      initialization code
   15                    ;     MAIN                          main function       main test function
   16                    ;     Interrupt sevice routine      sub function        interrupt sources
   17                    ;------------------------------------------------------------------------
   18                    ;------------------------File   information------------------------------
   19                    ;    @author@:   MA LIYU
   20                    ;    @date@:     13-09-04            
   21                    ;    @version@:  00             
   22                    ;    @change record@:     
   23                    ;          --date--       |         --content--         |     --who--
   24                    ;         13-09-04                  Creation                    MA LIYU       
   25                    ;------------------------------------------------------------------------
   26                    ;************************************************************************
   27                    ;************************************************************************
   28                    ;************************************************************************
   29                    .INCLUDE "S3F8S28.reg"
   30                    ; S3F8S28.reg of OPENice
   31                    ;	Created on Sep.10. 2010
   32                    ;	Copyright (c) 2010 YIC System CO., Ltd.
   33                    
   34                    	.list   on
   35                    
   36                    
   37                    ;;=======================================================================
   38                    ;;==                                                                   ==
   39                    ;;==                RAM ASSIGNMENT                                     ==
   40                    ;;==                                                                   == 
   41                    ;;=======================================================================
   42         00 00      uart_status     EQU     00H
   43         00 01      uart_rx_data    EQU     01H     ; reserve 50 bytes for uart rx data
   44         00 33      pwm0_value      EQU     33H     ; store current PWM0 value
   45                    
   46                    
   47  0000                      .ORG    0000H
   48                    ;;=======================================================================
   49                    ;;==                                                                   ==
   50                    ;;==                SMART OPTION Setting  ROUTINE                      ==
   51                    ;;==                                                                   == 
   52                    ;;=======================================================================
   53  003C                     .ORG  003CH
   54  003C   FF                .DB   0FFH
   55  003D   FF                .DB   0FFH
   56  003E   FF                .DB   11111111B          ;@3EH : ISP options
   57                                                                 ; bit7: Reset vector address change enable/disable
   58                                                                 ;    0-change address   
   59                                                                 ;    1-normal: 100H
   60                                                                 ; bit6~5: reset vector address
   61                                                                 ;      @00B---200H         
   62                                                                 ;      @01B---300H
   63                                                                 ;      @10B---500H
   64                                                                 ;      @11B---900H
   65                                                                 ; bit4-3: not used
   66                                                                 ; bit2: ISP protection enable/disable
   67                                                                 ;    1-disable  
   68                                                                 ;    0-enable
   69                                                                 ; bit1-0: ISP protection size
   70                                                                 ;      @00B---256B         
   71                                                                 ;      @01B---512B
   72                                                                 ;      @10B---1024B
   73                                                                 ;      @11B---2048B        
   74  003F   8F                .DB   10001111B          ;@3FH :LVR, level, P1.2; OSC;
   75                                                                 ; bit 7: LVR Enable/disable
   76                                                                 ;    0-disable  
   77                                                                 ;    1-enable
   78                                                                 ; bit 6-5: LVR level
   79                                                                 ;      @00B---1.9V         
   80                                                                 ;      @01B---2.3V
   81                                                                 ;      @10B---3.0V
   82                                                                 ;      @11B---3.9V
   83                                                                 ; bit 4: P1.2/RESET pin selection
   84                                                                 ;    0-P1.2 pin enable  
   85                                                                 ;    1-RESET Pin enable
   86                                                                 ; bit 3-0: Oscillator selection bit
   87                                                                 ;      @0100B---External LG OSC         
   88                                                                 ;      @1100B---External HG OSC
   89                                                                 ;      @1010B---internal RC(1 M)
   90                                                                 ;      @1111B---internal RC(8 M)
   91                                                                 ;      @1000B---internal RC(0.5 M)
   92                                                                 ;      @1001B---internal RC(2 M)
   93                                                                 ;      @1011B---internal RC(4 M)
   94                    ;;=======================================================================
   95                    ;;==                                                                   ==
   96                    ;;==            INTERRUPT VECTOR                                       ==
   97                    ;;==                                                                   == 
   98                    ;;=======================================================================
   99  00D8   04 61             .VECTOR  0D8H, EX_INT7
  100  00DA   04 5B             .VECTOR  0DAH, EX_INT6
  101  00DC   04 55             .VECTOR  0DCH, EX_INT5
  102  00DE   04 4F             .VECTOR  0DEH, EX_INT4
  103  00E0   04 B0             .VECTOR  0E0H, IIC_INT
  104  00E2   04 A4             .VECTOR  0E2H, UART_RV_INT
  105  00E4   04 99             .VECTOR  0E4H, UART_TRS_INT
  106  00E6   04 B3             .VECTOR  0E6H, WDT_INT
  107  00E8   04 91             .VECTOR  0E8H, LVD_INT
  108  00EA   04 89             .VECTOR  0EAH, TIMER1_OVF_INT
  109  00EC   04 81             .VECTOR  0ECH, TIMER1_MC_INT
  110  00F0   04 73             .VECTOR  0F0H, PWM1_OVF_INT
  111  00F2   04 7B             .VECTOR  0F2H, PWM0_OVF_INT
  112  00F4   04 6D             .VECTOR  0F4H, TB_MC_INT
  113  00F6   04 67             .VECTOR  0F6H, T0_A_MC_INT
  114  00F8   04 49             .VECTOR  0F8H, EX_INT3
  115  00FA   04 43             .VECTOR  0FAH, EX_INT2
  116  00FC   04 3D             .VECTOR  0FCH, EX_INT1
  117  00FE   04 37             .VECTOR  0FEH, EX_INT0
  118                    ;;=======================================================================
  119                    ;;==                                                                   ==
  120                    ;;==            RESET and Initialization code                          ==
  121                    ;;==                                                                   == 
  122                    ;;=======================================================================
  123                    
  124  0100                     .ORG    0100H
  125  0100              RESET:
  126  0100   8F                 DI
  127  0101   E6 D3 A3           LD      BTCON,#10100011B        ; bit 7-4: Watchdog timer enable bits
  128                                                            ; 1010B = Disable watchdog function
  129                                                            ; Other value = Enable watchdog function
  130                                                            ; bit 3-2: Basic timer input clock selection bits
  131                                                            ; 00 = fosc/4096
  132                                                            ; 01 = fosc/1024
  133                                                            ; 10 = fosc/128
  134                                                            ; 11 = Invalid selection 
  135                                                            ; bit 1: Basic timer counter clear bits
  136                                                            ; 0 = No effect
  137                                                            ; 1 = Clear basic timer counter
  138                                                            ; bit 0: Divider clear bit for basic timer and timer 0
  139                                                            ; 0 = No effect
  140                                                            ; 1 = Clear both dividers
  141  0104   E6 D4 18           LD      CLKCON,#00011000B       ; bit 7: Oscillator IRQ wake-up enable bit
  142                                                            ; 0 = Enable IRQ for main system oscillator wake-up function in power mode.
  143                                                            ; 1 = Disable IRQ for main system oscillator wake-up function in power down mode.
  144                                                            ; bit 6-5: not used
  145                                                            ; bit 4-3: Divide-by selection bits for CPU clock frequency
  146                                                            ; 00 = fosc/16
  147                                                            ; 01 = fosc/8
  148                                                            ; 10 = fosc/2
  149                                                            ; 11 = fosc (non-divided)
  150                                                                            ; bit 2-0: not used
  151  0107   E6 F5 00           LD      ROSCCON,#00000000B      ; 
  152  010A   E6 D9 FF           LD      SPL,#0FFH               ; SP: FFH (Normally, the SP is set to FFH by the initialization routine) 
  153  010D   E6 DA 00           LD      IPH,#00H
  154  0110   E6 DB 00           LD      IPL,#00H
  155  0113   E6 DD FF           LD      IMR,#11111111B          ; Interrupt level enable bit
  156                                                            ; bit 7-0 <-> IRQ7-0
  157                                                            ; 0 = Disable (mask) interrupt level
  158                                                            ; 1 = Enable (un-mask) interrupt level
  159                                                            
  160                                                            ; IRQ0: External interrupt 0/1/2/3
  161                                                            ; IRQ1: Timer 0/A match interrupt/Timer B match interrupt
  162                                                            ; IRQ2: PWM0 overflow interrupt/PWM1 overflow interrupt
  163                                                            ; IRQ3: Timer 1 match/capture interrupt/Timer 1 overflow interrupt
  164                                                            ; IRQ4: Watchdog interrupt
  165                                                            ; IRQ5: UART transmit interrupt/UART Receive interrupt
  166                                                            ; IRQ6: IIC transmit / receive interrupt
  167                                                            ; IRQ7: External interrupt 4/5/6/7
  168  0116   E6 FF CD           LD      IPR,#11001101B          ; Interrupt Priority Register
  169                                                            ; bit7/4/1 -> Group priority
  170                                                            ; 0 0 0 = Undefined
  171                                                            ; 0 0 1 = B > C > A
  172                                                            ; 0 1 0 = A > B > C
  173                                                            ; 0 1 1 = B > A > C
  174                                                            ; 1 0 0 = C > A > B
  175                                                            ; 1 0 1 = C > B > A
  176                                                            ; 1 1 0 = A > C > B
  177                                                            ; 1 1 1 = Undefined
  178                                                            ; bit 6 -> Subgroup C
  179                                                            ; 0 = IRQ6 > IRQ7
  180                                                            ; 1 = IRQ7 > IRQ6
  181                                                            ; bit 5 -> Group C 
  182                                                            ; 0 = IRQ5 > (IRQ6, IRQ7)
  183                                                            ; 1 = (IRQ6, IRQ7) > IRQ5
  184                                                            ; bit 3 -> Subgroup B
  185                                                            ; 0 = IRQ3 > IRQ4
  186                                                            ; 1 = IRQ4 > IRQ3
  187                                                            ; bit 2 -> Group B
  188                                                            ; 0 = IRQ2 > (IRQ3, IRQ4)
  189                                                            ; 1 = (IRQ3, IRQ4) > IRQ2
  190                                                            ; bit 0 -> Group A
  191                                                            ; 0 = IRQ0 > IRQ1
  192                                                            ; 1 = IRQ1 > IRQ0
  193                    
  194  0119   E6 E6 9A           LD      P0CONH,#10011010B       ; Port 0 Control Register (High Byte)
  195                                                            ; [.7-.6] Port, P0.7/ADC7 Configuration Bits
  196                                                            ; 0 x = Schmitt trigger input
  197                                                            ; 1 0 = Push-pull output
  198                                                            ; 1 1 = A/D converter input (ADC7); schmitt trigger input off
  199                                                            ; [.5-.4] Port 0, P0.6/ADC6/PWM0 Configuration Bits
  200                                                            ; 0 0 = Schmitt trigger input
  201                                                            ; 0 1 = Alternative function: PWM0 output
  202                                                            ; 1 0 = Push-pull output
  203                                                            ; 1 1 = A/D converter input (ADC6); schmitt trigger input off
  204                                                            ; [.3-.2] Port 0, P0.5/ADC5/PWM1 Configuration Bits
  205                                                            ; 0 0 = Schmitt trigger input
  206                                                            ; 0 1 = Alternative function: PWM1 output
  207                                                            ; 1 0 = Push-pull output
  208                                                            ; 1 1 = A/D converter input (ADC5); schmitt trigger input off
  209                                                            ; [.1-.0] Port 0, P0.4/ADC4 Configuration Bits
  210                                                            ; 0 x = Schmitt trigger input
  211                                                            ; 1 0 = Push-pull output
  212                                                            ; 1 1 = A/D converter input (ADC4); schmitt trigger input off
  213  011C   E6 E7 AA           LD     P0CONL,#10101010B        ; Port 0 Control Register (Low Byte)
  214                                                            ; [.7-.6] Port 0, P0.3/ADC3/INT3 Configuration Bits
  215                                                            ; 0 0 = Schmitt trigger input/falling edge interrupt input
  216                                                            ; 0 1 = Alternative function: SDA
  217                                                            ; 1 0 = Push-pull output
  218                                                            ; 1 1 = A/D converter input (ADC3); Schmitt trigger input off
  219                                                            ; [.5-.4] Port 0, P0.2/ADC2/INT2 Configuration Bits
  220                                                            ; 0 0 = Schmitt trigger input/falling edge interrupt input
  221                                                            ; 0 1 = Alternative function: SCK
  222                                                            ; 1 0 = Push-pull output
  223                                                            ; 1 1 = A/D converter input (ADC2); Schmitt trigger input off
  224                                                            ; [.3-.2] Port 0, P0.1/ADC1/INT1 Configuration Bits
  225                                                            ; 0 x = Schmitt trigger input/falling edge interrupt input
  226                                                            ; 1 0 = Push-pull output
  227                                                            ; 1 1 = A/D converter input (ADC1); Schmitt trigger input off
  228                                                            ; [.1-.0] Port 0, P0.0/ADC0/INT0 Configuration Bits
  229                                                            ; 0 x = Schmitt trigger input/falling edge interrupt input
  230                                                            ; 1 0 = Push-pull output
  231                                                            ; 1 1 = A/D converter input (ADC0); Schmitt trigger input off                                    
  232  011F   E6 E8 00            LD     P0PND,#00000000B        ; Port 0 Interrupt Pending Register
  233                             ;LD     P0PUR,#11110000B        ; Port 0 Pull-up Resistor Enable Register
  234  0122   E6 E9 1A            LD     P1CON,#00011010B        ; Port 1 Control Register
  235                                                            ; [.7] Port 1.1 N-Channel Open-Drain Enable Bit
  236                                                            ; 0 = Configure P1.1 as a push-pull output
  237                                                            ; 1 = Configure P1.1 as a n-channel open-drain output
  238                                                            ; [.6] Port 1.0 N-Channel Open-Drain Enable Bit
  239                                                            ; 0 = Configure P1.0 as a push-pull output
  240                                                            ; 1 = Configure P1.0 as a N-channel open-drain output
  241                                                            ; [.5] Not used for S3F8S28/F8S24
  242                                                            ; [.4] Port 1.2 Configuration Bit
  243                                                            ; 0 = Schmitt trigger input;
  244                                                            ; 1 = Open-drain output
  245                                                            ; [.3-.2] Port 1, P1.1 Configuration Bits
  246                                                            ; 0 0 = Schmitt trigger input;
  247                                                            ; 0 1 = Schmitt trigger input; pull-up enable
  248                                                            ; 1 0 = Push-pull output
  249                                                            ; 1 1 = Schmitt trigger input; pull-down enable
  250                                                            ; [.1-.0] Port 1, P1.0 Configuration Bits
  251                                                            ; 0 0 = Schmitt trigger input;
  252                                                            ; 0 1 = Schmitt trigger input; pull-up enable
  253                                                            ; 1 0 = Push-pull output
  254                                                            ; 1 1 = Schmitt trigger input; pull-down enable
  255  0125   E6 EA 4A            LD     P2CONH,#01001010B       ; Port 2 Control Register (High Byte)
  256                                                            ; [.7] Not used in S3F8S28/F8S24
  257                                                            ; [.6-.4] Port 2, P2.6/ADC8/CLO Configuration Bits
  258                                                            ; 0 0 x = Schmitt trigger input
  259                                                            ; 0 1 x = ADC input
  260                                                            ; 1 0 0 = Push-pull output
  261                                                            ; 1 0 1 = Open-drain output; pull-up enable
  262                                                            ; 1 1 0 = Open-drain output
  263                                                            ; 1 1 1 = Alternative function; CLO output
  264                                                            ; [.3-.2] Port 2, P2.5/ADC9 Configuration Bits
  265                                                            ; 0 0 = Schmitt trigger input
  266                                                            ; 0 1 = Alternative function: ADC Input
  267                                                            ; 1 0 = Push-pull output
  268                                                            ; 1 1 = Invalid
  269                                                            ; [ 1-.0] Port 2, P2.4/ADC10 Configuration Bits
  270                                                            ; 0 0 = Schmitt trigger input
  271                                                            ; 0 1 = Alternative function: ADC Input
  272                                                            ; 1 0 = Push-pull output
  273                                                            ; 1 1 = Invalid
  274  0128   E6 EB 4A            LD     P2CONL,#01001010B       ; Port 2 Control Register (Low Byte)
  275                                                            ; [.7-.6] Port 2, P2.3/TxD Configuration Bits
  276                                                            ; 0 0 = Schmitt trigger input
  277                                                            ; 0 1 = Alternative function: TxD output
  278                                                            ; 1 0 = Push-pull output
  279                                                            ; 1 1 = Open-drain output
  280                                                            ; [.5-.4] Port 2, P2.2/T1CAP/RxD Configuration Bits
  281                                                            ; 0 0 = Schmitt trigger input; T1 Capture input; RxD input;
  282                                                            ; 0 1 = Alternative function: RxD output
  283                                                            ; 1 0 = Push-pull output
  284                                                            ; 1 1 = Open-drain output
  285                                                            ; [.3-.2] Port 2, P2.1/T1OUT Configuration Bits
  286                                                            ; 0 0 = Schmitt trigger input
  287                                                            ; 0 1 = Alternative function: T1 match output
  288                                                            ; 1 0 = Push-pull output
  289                                                            ; 1 1 = Open-drain output
  290                                                            ; [.1-.0] Port 2, P2.0/T0OUT Configuration Bits
  291                                                            ; 0 0 = Schmitt trigger input
  292                                                            ; 0 1 = Alternative function: T0 match output
  293                                                            ; 1 0 = Push-pull output
  294                                                            ; 1 1 = Open-drain output
  295  012B   E6 E4 00            LD     P2PUR,#00000000B        ; Port 2 Pull-up Resistor Enable Register
  296                             ;LD     P3CON,#00000000B        ; Port 3 Control Register
  297                                                            ; [.7-.6] Port 3, P3.3/INT7 Configuration Bits
  298                                                            ; 0 0 = Schmitt trigger input / external falling edge interrupt input
  299                                                            ; 0 1 = Schmitt trigger input with pull-up / external falling edge interrupt input
  300                                                            ; 1 x = Push-pull output
  301                                                            ; [.5-.4] Port 3, P3.2/INT6 Configuration Bits
  302                                                            ; 0 0 = Schmitt trigger input / external falling edge interrupt input
  303                                                            ; 0 1 = Schmitt trigger input with pull-up / external falling edge interrupt input
  304                                                            ; 1 x = Push-pull output
  305                                                            ; [.3-.2] Port 3, P3.1/ADC12/INT5 Configuration Bits
  306                                                            ; 0 0 = Schmitt trigger input / external falling edge interrupt input
  307                                                            ; 0 1 = Schmitt trigger input with pull-up / external falling edge interrupt input
  308                                                            ; 1 0 = Push-pull output
  309                                                            ; 1 1 = Alternative function: ADC Input
  310                                                            ; [.1-.0] Port 3, P3.0/ADC11/INT4 Configuration Bits
  311                                                            ; 0 0 = Schmitt trigger input / external falling edge interrupt input
  312                                                            ; 0 1 = Schmitt trigger input with pull-up / external falling edge interrupt input
  313                                                            ; 1 0 = Push-pull output
  314                                                            ; 1 1 = Alternative function: ADC Input
  315                            ;LD      P3PND, #000000000B      ; Port 3 Interrupt Pending Register
  316                                                            ; [.7] Port 3.3/ADC12/INT7, Interrupt Enable Bit
  317                                                            ; 0 = INT7 falling edge interrupt disable
  318                                                            ; 1 = INT7 falling edge interrupt enable
  319                                                            ; [.6] Port 3.3/ADC12/INT7 Interrupt Pending Bit
  320                                                            ; 0 = No interrupt pending (when read)
  321                                                            ; 0 = Pending bit clear (when write)
  322                                                            ; 1 = Interrupt is pending (when read)
  323                                                            ; 1 = No effect (when write)
  324                                                            ; [.5] Port 3.2/ADC11/INT6, Interrupt Enable Bit
  325                                                            ; 0 = INT6 falling edge interrupt disable
  326                                                            ; 1 = INT6 falling edge interrupt enable
  327                                                            ; [.4] Port 3.2/ADC11/INT6, Interrupt Pending Bit
  328                                                            ; 0 = No interrupt pending (when read)
  329                                                            ; 0 = Pending bit clear (when write)
  330                                                            ; 1 = Interrupt is pending (when read)
  331                                                            ; 1 = No effect (when write)
  332                                                            ; [.3] Port 3.1/ADC10/INT5, Interrupt Enable Bit
  333                                                            ; 0 = INT5 falling edge interrupt disable
  334                                                            ; 1 = INT5 falling edge interrupt enable
  335                                                            ; [.2] Port 3.1/ADC10/INT5, Interrupt Pending Bit
  336                                                            ; 0 = No interrupt pending (when read)
  337                                                            ; 0 = Pending bit clear (when write)
  338                                                            ; 1 = Interrupt is pending (when read)
  339                                                            ; 1 = No effect (when write)
  340                                                            ; [.1] Port 3.0/ADC9/INT4, Interrupt Enable Bit
  341                                                            ; 0 = INT4 falling edge interrupt disable
  342                                                            ; 1 = INT4 falling edge interrupt enable
  343                                                            ; [.0] Port 3.0/ADC9/INT4, Interrupt Pending Bit
  344                                                            ; 0 = No interrupt pending (when read)
  345                                                            ; 0 = Pending bit clear (when write)
  346                                                            ; 1 = Interrupt is pending (when read)
  347                                                            ; 1 = No effect (when write)
  348                                                                   
  349  012E   5F                 SB1
  350  012F   E6 F5 53           LD      UARTCON,#01010011B      ; UART Control Register
  351                                                            ; bit 7-6: Operating mode and baud rate selection bits
  352                                                            ; 0 0 -> mode 0 Shift register fxx/(16 x (BRDATA +1))
  353                                                            ; 0 1 -> mode 1 8-bit UART fxx/(16 x (BRDATA +1))
  354                                                            ; 1 0 -> mode 2 9-bit UART fxx/16
  355                                                            ; 1 1 -> 9-bit UART fxx/(16 x (BRDATA +1))
  356                                                            ; bit 5: Multiprocessor communication enable bit (for modes 2 and 3 only)
  357                                                            ; 0 = Disable
  358                                                            ; 1 = Enable
  359                                                            ; bit 4: Serial data receive enable bit
  360                                                            ; 0 = Disable
  361                                                            ; 1 = Enable
  362                                                            ; bit 3: Location of the 9th data bit to be transmitted in UART mode 2 or 3 ("0" or "1")
  363                                                            ; bit 2: Location of the 9th data bit that was received in UART mode 2 or 3 ("0" or "1")
  364                                                            ; bit 1: Received interrupt enable bit
  365                                                            ; 0 = Disable
  366                                                            ; 1 = Enable
  367                                                            ; bit 0: Transmit interrupt enable bit
  368                                                            ; 0 = Disable
  369                                                            ; 1 = Enable
  370  0132   E6 F6 00           LD      UARTPND,#00000000B      ; UART Pending Register
  371                                                            ; bit 7-2: Not used
  372                                                            ; bit 1: UART receive interrupt pending flag
  373                                                            ; 0 = Not pending
  374                                                            ; 0 = Clear pending bit (when write)
  375                                                            ; 1 = Interrupt pending
  376                                                            ; bit 0: UART transmit interrupt pending flag
  377                                                            ; 0 = Not pending
  378                                                            ; 0 = Clear pending bit (when write)
  379                                                            ; 1 = Interrupt pending
  380  0135   E6 F7 33           LD      BRDATA,#33H             ; UART Baud Rate Data Register
  381                                                            ; Mode 0 baud rate = fxx/(16 x (8-bit BRDATA + 1))
  382                                                            ; Mode 1 baud rate = fxx/(16 x (8-bit BRDATA + 1))
  383                                                            ; Mode 2 baud rate = fxx/16
  384                                                            ; Mode 3 baud rate = fxx/(16 x (8-bit BRDATA + 1))
  385  0138   4F                 SB0
  386                            
  387  0139   E6 F3 10           LD      PWM0CON,#00010000B      ; PWM Control Registers
  388                                                            ; bit 7-6: PWM input clock selection bits
  389                                                            ; 00 = fosc/64
  390                                                            ; 01 = fosc/8
  391                                                            ; 10 = fosc/2
  392                                                            ; 11 = fosc/1
  393                                                            ; bit 5: Not Used
  394                                                            ; bit 4: PWMDATA reload interval selection bit
  395                                                            ; 0 = Reload from extension up counter overflow
  396                                                            ; 1 = Reload from base up counter overflow
  397                                                            ; bit 3: PWM counter clear bit
  398                                                            ; 0 = No effect
  399                                                            ; 1 = Clear the PWM counter (When write)
  400                                                            ; bit 2: PWM counter enable bit
  401                                                            ; 0 = Stop counter
  402                                                            ; 1 = Start (resume countering)
  403                                                            ; bit 1: PWM counter interrupt enable bit
  404                                                            ; 0 = Disable PWM OVF interrupt
  405                                                            ; 1 = Enable PWM OVF interrupt
  406                                                            ; bit 0: PWM extension counter OVF Interrupt pending bit
  407                                                            ; 0 = No interrupt pending
  408                                                            ; 0 = Clear pending condition (when write)
  409                                                            ; 1 = Interrupt is pending
  410  013C   E6 F1 00           LD      PWM0EX,#00000000B       ; PWM Extension Registers
  411                                                            ; bit 7-2: PWM Extension bits
  412                                                            ; bit 7-6: For 6 + 2 resolution
  413                                                            ; bit 7-2: For 6 + 6 and 8 + 6 resolutions
  414                                                            ; bit 1-0: PWM resolution selection bits
  415                                                            ; x0 = 12-bit PWM: 6 + 6 resolution
  416                                                            ; 01 = 8-bit PWM: 6 + 2 resolution
  417                                                            ; 11 = 14-bit PWM: 8 + 6 resolution
  418  013F   E6 F2 00           LD      PWM0DATA,#00H
  419                            
  420  0142   B0 00              CLR     uart_status
  421                            
  422  0144   B0 33              CLR     pwm0_value
  423                    
  424  0146   F6 01 F1           CALL    UART_RX_DATA_INIT
  425                            
  426  0149   B0 C0              CLR     R0
  427  014B   B0 C1              CLR     R1
  428  014D   B0 C2              CLR     R2
  429  014F   B0 C3              CLR     R3
  430  0151   B0 C4              CLR     R4
  431  0153   B0 C5              CLR     R5
  432  0155   B0 C6              CLR     R6
  433  0157   B0 C7              CLR     R7
  434  0159   B0 C8              CLR     R8
  435  015B   B0 C9              CLR     R9
  436  015D   B0 CA              CLR     R10
  437  015F   B0 CB              CLR     R11
  438  0161   B0 CC              CLR     R12
  439  0163   B0 CD              CLR     R13
  440  0165   B0 CE              CLR     R14
  441  0167   B0 CF              CLR     R15
  442                            
  443  0169   F8 01              LD      R15,uart_rx_data
  444                            
  445  016B   9F                 EI
  446                    
  447                    ;;=======================================================================
  448                    ;;==      Main function                                                ==
  449                    ;;==                                                                   ==
  450                    ;;==                                                                   == 
  451                    ;;=======================================================================
  452  016C              MAIN::
  453  016C   46 D3 02           OR      BTCON,#02H              ; Enable watchdog function
  454                                                            ; Basic counter (BTCNT) clear
  455                    
  456  016F   F6 02 87           CALL    TASK_RX 
  457                            
  458                            ;CALL    DELAY_10s
  459                                                                                        
  460  0172   8D 01 6C           JP      MAIN                                
  461                    
  462                    ;;=======================================================================
  463                    ;;==      SUBROUTINEs                                                  ==
  464                    ;;==                                                                   ==
  465                    ;;==                                                                   == 
  466                    ;;=======================================================================
  467  0175              DELAY_1ms:
  468  0175   70 C1              PUSH    R1
  469  0177   1C A6              LD      R1,#0A6H
  470  0179              DELAY_LOOP_1ms:
  471  0179   FF                 NOP
  472  017A   FF                 NOP
  473  017B   FF                 NOP
  474  017C   FF                 NOP
  475  017D   FF                 NOP
  476  017E   FF                 NOP
  477  017F   FF                 NOP
  478  0180   FF                 NOP
  479  0181   FF                 NOP
  480  0182   FF                 NOP     
  481  0183   1A F4              DJNZ    R1,DELAY_LOOP_1ms
  482  0185   50 C1              POP     R1
  483                            
  484  0187   AF                 RET      
  485                    
  486  0188              DELAY_10ms:
  487  0188   70 C1              PUSH    R1
  488  018A   70 C2              PUSH    R2
  489  018C   1C 14              LD      R1,#014H
  490  018E              DELAY_LOOP_10ms_R1:
  491  018E   2C 53              LD      R2,#053H
  492  0190              DELAY_LOOP_10ms_R2:
  493  0190   FF                 NOP
  494  0191   FF                 NOP
  495  0192   FF                 NOP
  496  0193   FF                 NOP
  497  0194   FF                 NOP
  498  0195   FF                 NOP
  499  0196   FF                 NOP
  500  0197   FF                 NOP
  501  0198   FF                 NOP
  502  0199   FF                 NOP
  503  019A   2A F4              DJNZ    R2,DELAY_LOOP_10ms_R2     
  504  019C   1A F0              DJNZ    R1,DELAY_LOOP_10ms_R1
  505  019E   50 C2              POP     R2
  506  01A0   50 C1              POP     R1
  507                            
  508  01A2   AF                 RET
  509                    
  510  01A3              DELAY_1s:
  511  01A3   70 C1              PUSH    R1
  512  01A5   70 C2              PUSH    R2
  513  01A7   70 C3              PUSH    R3
  514  01A9   1C 43              LD      R1,#043H
  515  01AB              DELAY_LOOP_1s_R1:
  516  01AB   2C 0C              LD      R2,#00CH
  517  01AD              DELAY_LOOP_1s_R2:
  518  01AD   3C CF              LD      R3,#0CFH
  519  01AF              DELAY_LOOP_1s_R3:
  520  01AF   FF                 NOP
  521  01B0   FF                 NOP
  522  01B1   FF                 NOP
  523  01B2   FF                 NOP
  524  01B3   FF                 NOP
  525  01B4   FF                 NOP
  526  01B5   FF                 NOP
  527  01B6   FF                 NOP
  528  01B7   FF                 NOP
  529  01B8   FF                 NOP
  530  01B9   3A F4              DJNZ    R3,DELAY_LOOP_1s_R3
  531  01BB   2A F0              DJNZ    R2,DELAY_LOOP_1s_R2     
  532  01BD   1A EC              DJNZ    R1,DELAY_LOOP_1s_R1
  533  01BF   50 C3              POP     R3
  534  01C1   50 C2              POP     R2
  535  01C3   50 C1              POP     R1
  536                            
  537  01C5   AF                 RET
  538                    
  539  01C6              DELAY_10s:
  540  01C6   70 C1              PUSH    R1
  541  01C8   70 C2              PUSH    R2
  542  01CA   70 C3              PUSH    R3
  543  01CC   70 C4              PUSH    R4
  544  01CE   1C DF              LD      R1,#0DFH
  545  01D0              DELAY_LOOP_10s_R1:
  546  01D0   2C 04              LD      R2,#004H
  547  01D2              DELAY_LOOP_10s_R2:
  548  01D2   3C 42              LD      R3,#042H
  549  01D4              DELAY_LOOP_10s_R3:
  550  01D4   4C 15              LD      R4,#015H
  551  01D6              DELAY_LOOP_10s_R4:
  552  01D6   FF                 NOP
  553  01D7   FF                 NOP
  554  01D8   FF                 NOP
  555  01D9   FF                 NOP
  556  01DA   FF                 NOP
  557  01DB   FF                 NOP
  558  01DC   FF                 NOP
  559  01DD   FF                 NOP
  560  01DE   FF                 NOP
  561  01DF   FF                 NOP
  562  01E0   4A F4              DJNZ    R4,DELAY_LOOP_10s_R4
  563  01E2   3A F0              DJNZ    R3,DELAY_LOOP_10s_R3
  564  01E4   2A EC              DJNZ    R2,DELAY_LOOP_10s_R2     
  565  01E6   1A E8              DJNZ    R1,DELAY_LOOP_10s_R1
  566  01E8   50 C4              POP     R4
  567  01EA   50 C3              POP     R3
  568  01EC   50 C2              POP     R2
  569  01EE   50 C1              POP     R1
  570                            
  571  01F0   AF                 RET
  572                            
  573  01F1              UART_RX_DATA_INIT:
  574  01F1   70 C0              PUSH    R0
  575  01F3   70 C1              PUSH    R1
  576  01F5   08 01              LD      R0,uart_rx_data
  577  01F7   1C 00              LD      R1,#00H
  578  01F9              UART_RX_DATA_INIT_LOOP:
  579  01F9   B1 C0              CLR     @R0
  580  01FB   0E                 INC     R0
  581  01FC   1E                 INC     R1
  582  01FD   A6 C1 32           CP      R1,#032H
  583  0200   3B F7              JR      ULE,UART_RX_DATA_INIT_LOOP
  584  0202   50 C1              POP     R1
  585  0204   50 C0              POP     R0
  586                            
  587  0206   AF                 RET
  588                                                                                            
  589  0207              UART_TX:
  590  0207   70 C1              PUSH    R1
  591  0209              UART_TX_CHECK:
  592  0209   18 00              LD      R1,uart_status
  593  020B   37 11 FB           BTJRT   UART_TX_CHECK,R1.0      ; wait until tx finish
  594  020E   5F                 SB1
  595  020F   09 F8              LD      UDATA,R0    
  596  0211   4F                 SB0
  597  0212   46 00 01           OR      uart_status,#00000001B    
  598  0215   50 C1              POP     R1
  599                            
  600  0217   AF                 RET
  601                            
  602  0218              TIMER_A:
  603  0218   E6 D1 50           LD      TADATA,#50H             ; CPU = 8mMHz, interrupt interval = 3.2msec
  604  021B   E6 D2 0E           LD      TACON,#00001110B        ; fsoc/256, timer A interrupt enable
  605                            
  606  021E   AF                 RET       
  607                    
  608  021F              PWM0:
  609  021F   09 F2              LD      PWM0DATA,R0
  610  0221   19 F1              LD      PWM0EX,R1
  611  0223   09 33              LD      pwm0_value,R0
  612  0225   56 F3 F7           AND     PWM0CON,#11110111B      ; clear bit3 (clear counter bit, no effect) set to '0' to avoid clear counter
  613  0228   46 F3 04           OR      PWM0CON,#00000100B      ; PWM start run (if have started, then no effect, keep running)
  614                            
  615  022B   AF                 RET
  616                    
  617  022C              VE209S_TRS:
  618                    ; Binary interface for VE209S
  619                    ; 02 is the <STX>
  620                    ; 00 04 is the size_of_the_packet (4 bytes)
  621                    ; 31 32 33 34 are the 4 bytes of the payload
  622                    ; 03 is the <ETX>
  623  022C   0C 02              LD      R0,#02H
  624  022E   F6 02 07           CALL    UART_TX
  625  0231   0C 00              LD      R0,#00H
  626  0233   F6 02 07           CALL    UART_TX
  627  0236   0C 04              LD      R0,#04H
  628  0238   F6 02 07           CALL    UART_TX
  629  023B   0C 31              LD      R0,#31H
  630  023D   F6 02 07           CALL    UART_TX
  631  0240   0C 32              LD      R0,#32H
  632  0242   F6 02 07           CALL    UART_TX
  633  0245   0C 33              LD      R0,#33H
  634  0247   F6 02 07           CALL    UART_TX    
  635  024A   0C 34              LD      R0,#34H
  636  024C   F6 02 07           CALL    UART_TX 
  637  024F   0C 03              LD      R0,#03H
  638  0251   F6 02 07           CALL    UART_TX
  639                            
  640  0254   AF                 RET     
  641                    
  642                    ;;----------------------------------------
  643                    ;;   store data
  644                    ;;   R4 - high address of flash
  645                    ;;   R5 - low address of flash
  646                    ;;   R6 - start address of data
  647                    ;;   R7 - data length
  648                    ;;----------------------------------------
  649  0255              STORE_DATA:
  650  0255   8F                 DI        
  651                    ;;----------------------------------------
  652                    ;;   erase one sector
  653                    ;;----------------------------------------
  654  0256              FULL_FLASH_ERASE:
  655  0256   5F                 SB1
  656  0257   E6 ED A5           LD      FMUSR,#0A5H                             ; Flash Memory User Programming Enable Register
  657                                                                            ; 10100101 = Enable user programming mode
  658                                                                            ; Other values: Disable user programming mode
  659  025A   49 EE              LD      FMSECH,R4                               ; high address
  660  025C   59 EF              LD      FMSECL,R5                               ; low address.
  661  025E   E6 EC A1           LD      FMCON,#10100001B                        ; Flash Memory Control Register
  662                                                                            ; bit 7-4: Flash Memory Mode Selection Bits
  663                                                                            ; 0101 = Programming mode
  664                                                                            ; 1010 = Erase mode
  665                                                                            ; 0110 = Hard lock mode
  666                                                                            ; Others = Not used for S3F8S24
  667                                                                            ; bit 3-1: Not used for S3F8S28/F8S24
  668                                                                            ; bit 0: Flash (Erase or Hard Lock Protection) Operation Start Bit
  669                                                                            ; 0 = Operation stop
  670                                                                            ; 1 = Operation start (This bit will be cleared automatically just after erase operation.)
  671  0261   F6 01 75           CALL    DELAY_1ms
  672  0264   F6 01 75           CALL    DELAY_1ms
  673  0267   F6 01 75           CALL    DELAY_1ms
  674  026A   F6 01 75           CALL    DELAY_1ms
  675  026D   F6 01 75           CALL    DELAY_1ms
  676                            
  677                            ;LD      FMUSR,#00H                              ;return to normal mode
  678                            ;SB0
  679                    ;;----------------------------------------
  680                    ;;   write data to sector
  681                    ;;----------------------------------------
  682  0270              FULL_FLASH_WRITE:  
  683                            ;SB1
  684                            ;LD      FMSECH,#0EH                             ;set sector address
  685                            ;LD      FMSECL,#00H
  686                            ;LD      R4,#0EH
  687                            ;LD      R5,#00H
  688  0270   8C 00              LD      R8,#00H
  689                            ;LD      FMUSR,#0A5H                             ;enter user mode 
  690  0272   E6 EC 50           LD      FMCON,#01010000B                        ;program mode
  691  0275              Flash_Write_Loop:
  692  0275   C7 06              LD      R0,@R6
  693  0277   D3 04              LDC     @RR4,R0
  694  0279   5E                 INC     R5
  695  027A   6E                 INC     R6
  696  027B   8E                 INC     R8
  697  027C   A2 87              CP      R8,R7
  698  027E   ED 02 75           JP      NE,Flash_Write_Loop
  699  0281   E6 ED 00           LD      FMUSR, #00H                             ;return to normal mode
  700  0284   4F                 SB0
  701  0285   9F                 EI
  702                            
  703  0286   AF                 RET
  704                    
  705  0287              TASK_RX:
  706  0287   E5 01 C0           LD      R0,@uart_rx_data
  707  028A   A6 C0 02           CP      R0,#02H                                 ; STX
  708  028D   ED 04 36           JP      NE,DISCARD_DATA
  709                            
  710                            ;LD      R0,#01H
  711                            ;LD      R1,#00H
  712                            ;CALL    PWM0
  713                            
  714  0290   08 01              LD      R0,uart_rx_data
  715  0292   06 C0 02           ADD     R0,#02H
  716  0295   C7 10              LD      R1,@R0
  717                            ;LD      R10,@R0
  718  0297   06 C1 03           ADD     R1,#03H
  719  029A   04 01 C1           ADD     R1,uart_rx_data
  720  029D   C7 01              LD      R0,@R1
  721  029F   A6 C0 03           CP      R0,#03H                                 ; ETX
  722  02A2   ED 04 36           JP      NE,DISCARD_DATA
  723                            
  724                            ;ADD     R10,#04H
  725                            ;LD      R0,#3FH
  726                            ;LD      R1,#00H
  727                            ;CALL    PWM0
  728                    
  729  02A5   28 01              LD      R2,uart_rx_data
  730  02A7              UART_RX_ECHO:        
  731  02A7   C7 02              LD      R0,@R2
  732  02A9   F6 02 07           CALL    UART_TX
  733  02AC   2E                 INC     R2
  734                            ;DJNZ    R10,UART_RX_ECHO
  735  02AD   A2 2F              CP      R2,R15
  736  02AF   3D 02 A7           JP      ULE,UART_RX_ECHO
  737                    
  738                            ; check "ON x" command to turn on LED
  739  02B2   08 01              LD      R0,uart_rx_data
  740  02B4   06 C0 02           ADD     R0,#02H
  741  02B7   C7 10              LD      R1,@R0
  742  02B9   A6 C1 04           CP      R1,#04H
  743  02BC   ED 02 F6           JP      NE,INVALID_ON_CMD
  744  02BF   0E                 INC     R0
  745  02C0   C7 10              LD      R1,@R0
  746  02C2   A6 C1 4F           CP      R1,#4FH         ; 'O'
  747  02C5   ED 02 F6           JP      NE,INVALID_ON_CMD
  748  02C8   0E                 INC     R0
  749  02C9   C7 10              LD      R1,@R0
  750  02CB   A6 C1 4E           CP      R1,#4EH         ; 'N'
  751  02CE   ED 02 F6           JP      NE,INVALID_ON_CMD
  752  02D1   0E                 INC     R0
  753  02D2   C7 10              LD      R1,@R0
  754  02D4   A6 C1 20           CP      R1,#20H         ; ' '
  755  02D7   ED 02 F6           JP      NE,INVALID_ON_CMD
  756  02DA   0E                 INC     R0
  757  02DB   C7 10              LD      R1,@R0
  758  02DD   A6 C1 30           CP      R1,#30H         
  759  02E0   7D 02 F6           JP      ULT,INVALID_ON_CMD
  760  02E3   A6 C1 34           CP      R1,#34H
  761  02E6   BD 02 F6           JP      UGT,INVALID_ON_CMD
  762  02E9   A6 33 00           CP      pwm0_value,#00H
  763  02EC   BD 02 F6           JP      UGT,INVALID_ON_CMD
  764  02EF   0C 01              LD      R0,#01H
  765  02F1   1C 00              LD      R1,#00H
  766  02F3   F6 02 1F           CALL    PWM0
  767  02F6              INVALID_ON_CMD:
  768                    
  769                            ; check "OFF x" command to turn on LED
  770  02F6   08 01              LD      R0,uart_rx_data
  771  02F8   06 C0 02           ADD     R0,#02H
  772  02FB   C7 10              LD      R1,@R0
  773  02FD   A6 C1 05           CP      R1,#05H
  774  0300   ED 03 3D           JP      NE,INVALID_OFF_CMD
  775  0303   0E                 INC     R0
  776  0304   C7 10              LD      R1,@R0
  777  0306   A6 C1 4F           CP      R1,#4FH         ; 'O'
  778  0309   ED 03 3D           JP      NE,INVALID_OFF_CMD
  779  030C   0E                 INC     R0
  780  030D   C7 10              LD      R1,@R0
  781  030F   A6 C1 46           CP      R1,#46H         ; 'F'
  782  0312   ED 03 3D           JP      NE,INVALID_OFF_CMD
  783  0315   0E                 INC     R0
  784  0316   C7 10              LD      R1,@R0
  785  0318   A6 C1 46           CP      R1,#46H         ; 'F'
  786  031B   ED 03 3D           JP      NE,INVALID_OFF_CMD
  787  031E   0E                 INC     R0
  788  031F   C7 10              LD      R1,@R0
  789  0321   A6 C1 20           CP      R1,#20H         ; ' '
  790  0324   ED 03 3D           JP      NE,INVALID_OFF_CMD
  791  0327   0E                 INC     R0
  792  0328   C7 10              LD      R1,@R0
  793  032A   A6 C1 30           CP      R1,#30H
  794  032D   7D 03 3D           JP      ULT,INVALID_OFF_CMD
  795  0330   A6 C1 34           CP      R1,#34H
  796  0333   BD 03 3D           JP      UGT,INVALID_OFF_CMD
  797  0336   0C 00              LD      R0,#00H
  798  0338   1C 00              LD      R1,#00H
  799  033A   F6 02 1F           CALL    PWM0
  800  033D              INVALID_OFF_CMD:
  801                    
  802                            ; check "DIM+ x" command to dim up LED
  803  033D   08 01              LD      R0,uart_rx_data
  804  033F   06 C0 02           ADD     R0,#02H
  805  0342   C7 10              LD      R1,@R0
  806  0344   A6 C1 06           CP      R1,#06H
  807  0347   ED 03 BA           JP      NE,LED_DIMPLUS_CMD
  808  034A   0E                 INC     R0
  809  034B   C7 10              LD      R1,@R0
  810  034D   A6 C1 44           CP      R1,#44H         ; 'D'
  811  0350   ED 03 BA           JP      NE,LED_DIMPLUS_CMD
  812  0353   0E                 INC     R0
  813  0354   C7 10              LD      R1,@R0
  814  0356   A6 C1 49           CP      R1,#49H         ; 'I'
  815  0359   ED 03 BA           JP      NE,LED_DIMPLUS_CMD
  816  035C   0E                 INC     R0
  817  035D   C7 10              LD      R1,@R0
  818  035F   A6 C1 4D           CP      R1,#4DH         ; 'M'
  819  0362   ED 03 BA           JP      NE,LED_DIMPLUS_CMD
  820  0365   0E                 INC     R0
  821  0366   C7 10              LD      R1,@R0
  822  0368   A6 C1 2B           CP      R1,#2BH         ; '+'
  823  036B   ED 03 BA           JP      NE,LED_DIMPLUS_CMD
  824  036E   0E                 INC     R0
  825  036F   C7 10              LD      R1,@R0
  826  0371   A6 C1 20           CP      R1,#20H
  827  0374   ED 03 BA           JP      NE,LED_DIMPLUS_CMD
  828  0377   0E                 INC     R0
  829  0378   C7 10              LD      R1,@R0
  830  037A   A6 C1 30           CP      R1,#30H
  831  037D   7D 03 BA           JP      ULT,LED_DIMPLUS_CMD
  832  0380   A6 C1 34           CP      R1,#34H
  833  0383   BD 03 BA           JP      UGT,LED_DIMPLUS_CMD
  834  0386   A6 33 3F           CP      pwm0_value,#03FH
  835  0389   6D 03 BA           JP      EQ,LED_DIMPLUS_CMD
  836  038C              LED_DIMPLUS_4:
  837  038C   A6 33 30           CP      pwm0_value,#030H
  838  038F   ED 03 97           JP      NE,LED_DIMPLUS_3
  839  0392   0C 3F              LD      R0,#03FH
  840  0394   8D 03 B5           JP      LED_DIMPLUS_0
  841  0397              LED_DIMPLUS_3:
  842  0397   A6 33 20           CP      pwm0_value,#020H
  843  039A   ED 03 A2           JP      NE,LED_DIMPLUS_2
  844  039D   0C 30              LD      R0,#030H
  845  039F   8D 03 B5           JP      LED_DIMPLUS_0
  846  03A2              LED_DIMPLUS_2:
  847  03A2   A6 33 10           CP      pwm0_value,#010H
  848  03A5   ED 03 AD           JP      NE,LED_DIMPLUS_1
  849  03A8   0C 20              LD      R0,#020H
  850  03AA   8D 03 B5           JP      LED_DIMPLUS_0
  851  03AD              LED_DIMPLUS_1:
  852  03AD   A6 33 01           CP      pwm0_value,#01H
  853  03B0   ED 03 BA           JP      NE,LED_DIMPLUS_CMD
  854  03B3   0C 10              LD      R0,#010H
  855  03B5              LED_DIMPLUS_0:
  856  03B5   1C 00              LD      R1,#00H
  857  03B7   F6 02 1F           CALL    PWM0
  858  03BA              LED_DIMPLUS_CMD:
  859                    
  860                            ; check "DIM- x" command to dim up LED
  861  03BA   08 01              LD      R0,uart_rx_data
  862  03BC   06 C0 02           ADD     R0,#02H
  863  03BF   C7 10              LD      R1,@R0
  864  03C1   A6 C1 06           CP      R1,#06H
  865  03C4   ED 04 31           JP      NE,LED_DIMMINUS_CMD
  866  03C7   0E                 INC     R0
  867  03C8   C7 10              LD      R1,@R0
  868  03CA   A6 C1 44           CP      R1,#44H         ; 'D'
  869  03CD   ED 04 31           JP      NE,LED_DIMMINUS_CMD
  870  03D0   0E                 INC     R0
  871  03D1   C7 10              LD      R1,@R0
  872  03D3   A6 C1 49           CP      R1,#49H         ; 'I'
  873  03D6   ED 04 31           JP      NE,LED_DIMMINUS_CMD
  874  03D9   0E                 INC     R0
  875  03DA   C7 10              LD      R1,@R0
  876  03DC   A6 C1 4D           CP      R1,#4DH         ; 'M'
  877  03DF   ED 04 31           JP      NE,LED_DIMMINUS_CMD
  878  03E2   0E                 INC     R0
  879  03E3   C7 10              LD      R1,@R0
  880  03E5   A6 C1 2D           CP      R1,#2DH         ; '-'
  881  03E8   ED 04 31           JP      NE,LED_DIMMINUS_CMD
  882  03EB   0E                 INC     R0
  883  03EC   C7 10              LD      R1,@R0
  884  03EE   A6 C1 20           CP      R1,#20H
  885  03F1   ED 04 31           JP      NE,LED_DIMMINUS_CMD
  886  03F4   0E                 INC     R0
  887  03F5   C7 10              LD      R1,@R0
  888  03F7   A6 C1 30           CP      R1,#30H
  889  03FA   7D 04 31           JP      ULT,LED_DIMMINUS_CMD
  890  03FD   A6 C1 34           CP      R1,#34H
  891  0400   BD 04 31           JP      UGT,LED_DIMMINUS_CMD
  892  0403   A6 33 01           CP      pwm0_value,#01H
  893  0406   3D 04 31           JP      ULE,LED_DIMMINUS_CMD
  894  0409              LED_DIMMINUS_5:
  895  0409   A6 33 10           CP      pwm0_value,#010H
  896  040C   ED 04 14           JP      NE,LED_DIMMINUS_4
  897  040F   0C 01              LD      R0,#01H
  898  0411   8D 04 2C           JP      LED_DIMMINUS_0
  899  0414              LED_DIMMINUS_4:
  900  0414   A6 F2 20           CP      PWM0DATA,#020H
  901  0417   ED 04 1F           JP      NE,LED_DIMMINUS_3
  902  041A   0C 10              LD      R0,#010H
  903  041C   8D 04 2C           JP      LED_DIMMINUS_0
  904  041F              LED_DIMMINUS_3:
  905  041F   A6 F2 30           CP      PWM0DATA,#030H
  906  0422   ED 04 2A           JP      NE,LED_DIMMINUS_2
  907  0425   0C 20              LD      R0,#020H
  908  0427   8D 04 2C           JP      LED_DIMMINUS_0
  909  042A              LED_DIMMINUS_2:
  910  042A   0C 30              LD      R0,#030H
  911  042C              LED_DIMMINUS_0:
  912  042C   1C 00              LD      R1,#00H
  913  042E   F6 02 1F           CALL    PWM0
  914  0431              LED_DIMMINUS_CMD:
  915                                            
  916  0431   F6 01 F1           CALL    UART_RX_DATA_INIT
  917                            
  918  0434   F8 01              LD      R15,uart_rx_data
  919  0436              DISCARD_DATA:
  920                            ;CALL    UART_RX_DATA_INIT
  921                            
  922  0436   AF                 RET                                                                                                                                                                                                                                     
  923                    ;;=======================================================================
  924                    ;;==      INTERRUPT SERVICE ROUTINE                                    ==
  925                    ;;==                                                                   ==
  926                    ;;==                                                                   == 
  927                    ;;=======================================================================                                                                                
  928                           ;;----------------------------------------
  929                           ;;     external interrupt 0
  930                           ;;----------------------------------------
  931  0437              EX_INT0:
  932  0437   56 E8 FF          AND     P0PND, #11111111B                       ;clear pending bit
  933  043A   8D 04 B9          JP      INT_ISR_END        
  934                           ;;----------------------------------------
  935                           ;;     external interrupt 1
  936                           ;;----------------------------------------
  937  043D              EX_INT1:
  938  043D   56 E8 FF           AND     P0PND, #11111111B                       ;clear pending bit
  939  0440   8D 04 B9           JP      INT_ISR_END
  940                           ;;----------------------------------------
  941                           ;;     external interrupt 2
  942                           ;;----------------------------------------
  943  0443              EX_INT2:
  944                            ;XOR     P0,#00100000B                           ;toggle P0.5 
  945  0443   56 E8 EF           AND     P0PND, #11101111B                       ;clear pending bit
  946  0446   8D 04 B9           JP      INT_ISR_END
  947                            ;;----------------------------------------
  948                           ;;     external interrupt 3
  949                           ;;----------------------------------------
  950  0449              EX_INT3:
  951                            ;XOR     P0,#00010000B                           ;toggle P0.4 
  952  0449   56 E8 BF           AND     P0PND, #10111111B                       ;clear pending bit
  953  044C   8D 04 B9           JP      INT_ISR_END
  954                            ;;----------------------------------------
  955                           ;;     external interrupt 4
  956                           ;;----------------------------------------
  957  044F              EX_INT4:
  958                            ;XOR     P0,#10000000B                           ;toggle P0.7 
  959  044F   56 EF FE           AND     P3PND, #11111110B                       ;clear pending bit
  960  0452   8D 04 B9           JP      INT_ISR_END
  961                            ;;----------------------------------------
  962                           ;;     external interrupt 5
  963                           ;;----------------------------------------
  964  0455              EX_INT5:
  965                            ;XOR     P0,#01000000B                           ;toggle P0.6 
  966  0455   56 EF FB           AND     P3PND, #11111011B                       ;clear pending bit
  967  0458   8D 04 B9           JP      INT_ISR_END
  968                            ;;----------------------------------------
  969                           ;;     external interrupt 6
  970                           ;;----------------------------------------
  971  045B              EX_INT6:
  972                            ;XOR     P0,#00100000B                           ;toggle P0.5 
  973  045B   56 EF EF           AND     P3PND, #11101111B                       ;clear pending bit
  974  045E   8D 04 B9           JP      INT_ISR_END
  975                            ;;----------------------------------------
  976                           ;;     external interrupt 7
  977                           ;;----------------------------------------
  978  0461              EX_INT7:
  979                            ;XOR     P0,#00010000B                           ;toggle P0.4 
  980  0461   56 EF BF           AND     P3PND, #10111111B                       ;clear pending bit
  981  0464   8D 04 B9           JP      INT_ISR_END
  982                            
  983                           ;;----------------------------------------
  984                           ;;     Timer0/A match interrupt
  985                           ;;----------------------------------------  
  986  0467              T0_A_MC_INT:
  987                            ;XOR     P0,#10000000B                           ;toggle P0.7
  988  0467   56 D2 FE           AND     TACON,#11111110B                        ;clear pending bit
  989  046A   8D 04 B9           JP      INT_ISR_END 
  990                           ;;----------------------------------------
  991                           ;;     TimerB match interrupt
  992                           ;;---------------------------------------- 
  993  046D              TB_MC_INT:
  994                            ;XOR     P0,#01000000B                           ;toggle P0.6
  995  046D   56 EE FE           AND     TBCON,#11111110B                        ;clear pending bit
  996  0470   8D 04 B9           JP      INT_ISR_END
  997                           ;;----------------------------------------
  998                           ;;     PWM1 Overflow interrupt 
  999                           ;;----------------------------------------
 1000  0473              PWM1_OVF_INT:
 1001                            ;XOR     P0,#01000000B                           ;toggle P0.6
 1002  0473   5F                 SB1
 1003  0474   56 E8 F6           AND     PWM1CON,#11110110B                       ;clear pending bit
 1004  0477   4F                 SB0
 1005  0478   8D 04 B9           JP      INT_ISR_END
 1006                           ;;----------------------------------------
 1007                           ;;     PWM0 Overflow interrupt 
 1008                           ;;----------------------------------------
 1009  047B              PWM0_OVF_INT:
 1010                            ;XOR     P0,#00100000B                           ;toggle P0.5
 1011  047B   56 F3 F6           AND     PWM0CON,#11110110B                       ;clear pending bit
 1012  047E   8D 04 B9           JP      INT_ISR_END
 1013                           ;;----------------------------------------
 1014                           ;;     Timer1 match interrupt
 1015                           ;;----------------------------------------  
 1016  0481              TIMER1_MC_INT:
 1017                            ;XOR     P0,#00100000B                            ;toggle P0.5
 1018  0481   5F                 SB1
 1019  0482   56 E4 FE           AND     T1CON,#11111110B                         ;clear pending bit
 1020  0485   4F                 SB0
 1021  0486   8D 04 B9           JP      INT_ISR_END 
 1022                           ;;----------------------------------------
 1023                           ;;     Timer1 Overflow interrupt
 1024                           ;;----------------------------------------  
 1025  0489              TIMER1_OVF_INT:
 1026                            ;XOR     P0,#00010000B                            ;toggle P0.4
 1027  0489   5F                 SB1
 1028  048A   56 E4 FB           AND     T1CON,#11111011B                         ;clear pending bit
 1029  048D   4F                 SB0
 1030  048E   8D 04 B9           JP      INT_ISR_END
 1031                           ;;----------------------------------------
 1032                           ;;     Low voltage detector interrupt
 1033                           ;;---------------------------------------- 
 1034  0491              LVD_INT:
 1035                            ;SB0
 1036                            ;AND      P0,#11110111B                            ;light P0.3
 1037  0491   5F                 SB1
 1038  0492   56 F4 EF           AND     LVDCON, #11101111B                       ;disable interrupt
 1039  0495   4F                 SB0
 1040  0496   8D 04 B9           JP      INT_ISR_END              
 1041                           ;;----------------------------------------
 1042                           ;;     UART interrupt
 1043                           ;;---------------------------------------- 
 1044  0499              UART_TRS_INT:
 1045  0499   5F                 SB1
 1046  049A   56 00 FE           AND     uart_status,#11111110B
 1047  049D   56 F6 FE           AND     UARTPND, #11111110B                      ;clear pending bit
 1048  04A0   4F                 SB0
 1049  04A1   8D 04 B9           JP      INT_ISR_END
 1050  04A4              UART_RV_INT:
 1051  04A4   5F                 SB1
 1052  04A5   F5 F8 CF           LD      @R15,UDATA
 1053  04A8   FE                 INC     R15
 1054  04A9   56 F6 FD           AND     UARTPND, #11111101B                      ;clear pending bit
 1055  04AC   4F                 SB0
 1056  04AD   8D 04 B9           JP      INT_ISR_END
 1057                           ;;----------------------------------------
 1058                           ;;     IIC interrupt
 1059                           ;;---------------------------------------- 
 1060  04B0              IIC_INT:
 1061  04B0   8D 04 B9           JP      INT_ISR_END
 1062                           ;;----------------------------------------
 1063                           ;;     Watchdog  interrupt
 1064                           ;;---------------------------------------- 
 1065  04B3              WDT_INT:
 1066                            ;XOR     P3,#00000001B                           ;toggle P3.0
 1067                            ;AND      WDTCON, #10111111B                    ;disable reset, clear counter
 1068  04B3   46 F6 10           OR      WDTCON, #00010000B                      ;clear counter.      
 1069  04B6   8D 04 B9           JP      INT_ISR_END       
 1070                    
 1071                    
 1072                    
 1073                           ;;----------------------------------------
 1074                           ;;     interrupt service end
 1075                           ;;----------------------------------------        
 1076  04B9              INT_ISR_END:                
 1077  04B9   BF                IRET
 1078                           
 1079  04BA              .END                                                          


Total 1073 Lines Assembled - 0 Errors, 0 Warnings
Total code size 0x3E4


