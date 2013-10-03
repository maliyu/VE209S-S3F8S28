Thu Oct 03 15:28:14 2013
                              
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
   99  00D8   05 7D             .VECTOR  0D8H, EX_INT7
  100  00DA   05 77             .VECTOR  0DAH, EX_INT6
  101  00DC   05 71             .VECTOR  0DCH, EX_INT5
  102  00DE   05 6B             .VECTOR  0DEH, EX_INT4
  103  00E0   05 CC             .VECTOR  0E0H, IIC_INT
  104  00E2   05 C0             .VECTOR  0E2H, UART_RV_INT
  105  00E4   05 B5             .VECTOR  0E4H, UART_TRS_INT
  106  00E6   05 CF             .VECTOR  0E6H, WDT_INT
  107  00E8   05 AD             .VECTOR  0E8H, LVD_INT
  108  00EA   05 A5             .VECTOR  0EAH, TIMER1_OVF_INT
  109  00EC   05 9D             .VECTOR  0ECH, TIMER1_MC_INT
  110  00F0   05 8F             .VECTOR  0F0H, PWM1_OVF_INT
  111  00F2   05 97             .VECTOR  0F2H, PWM0_OVF_INT
  112  00F4   05 89             .VECTOR  0F4H, TB_MC_INT
  113  00F6   05 83             .VECTOR  0F6H, T0_A_MC_INT
  114  00F8   05 65             .VECTOR  0F8H, EX_INT3
  115  00FA   05 5F             .VECTOR  0FAH, EX_INT2
  116  00FC   05 59             .VECTOR  0FCH, EX_INT1
  117  00FE   05 53             .VECTOR  0FEH, EX_INT0
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
  213  011C   E6 E7 A9           LD     P0CONL,#10101001B        ; Port 0 Control Register (Low Byte)
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
  233  0122   E6 E5 F1            LD     P0PUR,#11110001B        ; Port 0 Pull-up Resistor Enable Register
  234  0125   E6 E9 1A            LD     P1CON,#00011010B        ; Port 1 Control Register
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
  255  0128   E6 EA 4A            LD     P2CONH,#01001010B       ; Port 2 Control Register (High Byte)
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
  274  012B   E6 EB 4A            LD     P2CONL,#01001010B       ; Port 2 Control Register (Low Byte)
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
  295  012E   E6 E4 00            LD     P2PUR,#00000000B        ; Port 2 Pull-up Resistor Enable Register
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
  349  0131   5F                 SB1
  350  0132   E6 F5 53           LD      UARTCON,#01010011B      ; UART Control Register
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
  370  0135   E6 F6 00           LD      UARTPND,#00000000B      ; UART Pending Register
  371                                                            ; bit 7-2: Not used
  372                                                            ; bit 1: UART receive interrupt pending flag
  373                                                            ; 0 = Not pending
  374                                                            ; 0 = Clear pending bit (when write)
  375                                                            ; 1 = Interrupt pending
  376                                                            ; bit 0: UART transmit interrupt pending flag
  377                                                            ; 0 = Not pending
  378                                                            ; 0 = Clear pending bit (when write)
  379                                                            ; 1 = Interrupt pending
  380  0138   E6 F7 33           LD      BRDATA,#33H             ; UART Baud Rate Data Register
  381                                                            ; Mode 0 baud rate = fxx/(16 x (8-bit BRDATA + 1))
  382                                                            ; Mode 1 baud rate = fxx/(16 x (8-bit BRDATA + 1))
  383                                                            ; Mode 2 baud rate = fxx/16
  384                                                            ; Mode 3 baud rate = fxx/(16 x (8-bit BRDATA + 1))
  385  013B   4F                 SB0
  386                            
  387  013C   E6 F3 10           LD      PWM0CON,#00010000B      ; PWM Control Registers
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
  410  013F   E6 F1 00           LD      PWM0EX,#00000000B       ; PWM Extension Registers
  411                                                            ; bit 7-2: PWM Extension bits
  412                                                            ; bit 7-6: For 6 + 2 resolution
  413                                                            ; bit 7-2: For 6 + 6 and 8 + 6 resolutions
  414                                                            ; bit 1-0: PWM resolution selection bits
  415                                                            ; x0 = 12-bit PWM: 6 + 6 resolution
  416                                                            ; 01 = 8-bit PWM: 6 + 2 resolution
  417                                                            ; 11 = 14-bit PWM: 8 + 6 resolution
  418  0142   E6 F2 00           LD      PWM0DATA,#00H
  419                            
  420  0145   B0 00              CLR     uart_status
  421                            
  422  0147   B0 33              CLR     pwm0_value
  423                    
  424  0149   F6 01 F9           CALL    UART_RX_DATA_INIT
  425                            
  426  014C   B0 C0              CLR     R0
  427  014E   B0 C1              CLR     R1
  428  0150   B0 C2              CLR     R2
  429  0152   B0 C3              CLR     R3
  430  0154   B0 C4              CLR     R4
  431  0156   B0 C5              CLR     R5
  432  0158   B0 C6              CLR     R6
  433  015A   B0 C7              CLR     R7
  434  015C   B0 C8              CLR     R8
  435  015E   B0 C9              CLR     R9
  436  0160   B0 CA              CLR     R10
  437  0162   B0 CB              CLR     R11
  438  0164   B0 CC              CLR     R12
  439  0166   B0 CD              CLR     R13
  440  0168   B0 CE              CLR     R14
  441  016A   B0 CF              CLR     R15
  442                            
  443  016C   F8 01              LD      R15,uart_rx_data
  444                            
  445  016E   CC 01              LD      R12,#001H
  446                            
  447  0170   9F                 EI
  448                    
  449                    ;;=======================================================================
  450                    ;;==      Main function                                                ==
  451                    ;;==                                                                   ==
  452                    ;;==                                                                   == 
  453                    ;;=======================================================================
  454  0171              MAIN::
  455  0171   46 D3 02           OR      BTCON,#02H              ; Enable watchdog function
  456                                                            ; Basic counter (BTCNT) clear
  457                    
  458  0174   F6 02 8F           CALL    TASK_RX 
  459                            
  460  0177   F6 04 3F           CALL    BUTTON_PRESS
  461                            
  462                            ;CALL    TASK_P00
  463                            
  464                            ;CALL    DELAY_10s
  465                                                                                        
  466  017A   8D 01 71           JP      MAIN                                
  467                    
  468                    ;;=======================================================================
  469                    ;;==      SUBROUTINEs                                                  ==
  470                    ;;==                                                                   ==
  471                    ;;==                                                                   == 
  472                    ;;=======================================================================
  473  017D              DELAY_1ms:
  474  017D   70 C1              PUSH    R1
  475  017F   1C A6              LD      R1,#0A6H
  476  0181              DELAY_LOOP_1ms:
  477  0181   FF                 NOP
  478  0182   FF                 NOP
  479  0183   FF                 NOP
  480  0184   FF                 NOP
  481  0185   FF                 NOP
  482  0186   FF                 NOP
  483  0187   FF                 NOP
  484  0188   FF                 NOP
  485  0189   FF                 NOP
  486  018A   FF                 NOP     
  487  018B   1A F4              DJNZ    R1,DELAY_LOOP_1ms
  488  018D   50 C1              POP     R1
  489                            
  490  018F   AF                 RET      
  491                    
  492  0190              DELAY_10ms:
  493  0190   70 C1              PUSH    R1
  494  0192   70 C2              PUSH    R2
  495  0194   1C 14              LD      R1,#014H
  496  0196              DELAY_LOOP_10ms_R1:
  497  0196   2C 53              LD      R2,#053H
  498  0198              DELAY_LOOP_10ms_R2:
  499  0198   FF                 NOP
  500  0199   FF                 NOP
  501  019A   FF                 NOP
  502  019B   FF                 NOP
  503  019C   FF                 NOP
  504  019D   FF                 NOP
  505  019E   FF                 NOP
  506  019F   FF                 NOP
  507  01A0   FF                 NOP
  508  01A1   FF                 NOP
  509  01A2   2A F4              DJNZ    R2,DELAY_LOOP_10ms_R2     
  510  01A4   1A F0              DJNZ    R1,DELAY_LOOP_10ms_R1
  511  01A6   50 C2              POP     R2
  512  01A8   50 C1              POP     R1
  513                            
  514  01AA   AF                 RET
  515                    
  516  01AB              DELAY_1s:
  517  01AB   70 C1              PUSH    R1
  518  01AD   70 C2              PUSH    R2
  519  01AF   70 C3              PUSH    R3
  520  01B1   1C 43              LD      R1,#043H
  521  01B3              DELAY_LOOP_1s_R1:
  522  01B3   2C 0C              LD      R2,#00CH
  523  01B5              DELAY_LOOP_1s_R2:
  524  01B5   3C CF              LD      R3,#0CFH
  525  01B7              DELAY_LOOP_1s_R3:
  526  01B7   FF                 NOP
  527  01B8   FF                 NOP
  528  01B9   FF                 NOP
  529  01BA   FF                 NOP
  530  01BB   FF                 NOP
  531  01BC   FF                 NOP
  532  01BD   FF                 NOP
  533  01BE   FF                 NOP
  534  01BF   FF                 NOP
  535  01C0   FF                 NOP
  536  01C1   3A F4              DJNZ    R3,DELAY_LOOP_1s_R3
  537  01C3   2A F0              DJNZ    R2,DELAY_LOOP_1s_R2     
  538  01C5   1A EC              DJNZ    R1,DELAY_LOOP_1s_R1
  539  01C7   50 C3              POP     R3
  540  01C9   50 C2              POP     R2
  541  01CB   50 C1              POP     R1
  542                            
  543  01CD   AF                 RET
  544                    
  545  01CE              DELAY_10s:
  546  01CE   70 C1              PUSH    R1
  547  01D0   70 C2              PUSH    R2
  548  01D2   70 C3              PUSH    R3
  549  01D4   70 C4              PUSH    R4
  550  01D6   1C DF              LD      R1,#0DFH
  551  01D8              DELAY_LOOP_10s_R1:
  552  01D8   2C 04              LD      R2,#004H
  553  01DA              DELAY_LOOP_10s_R2:
  554  01DA   3C 42              LD      R3,#042H
  555  01DC              DELAY_LOOP_10s_R3:
  556  01DC   4C 15              LD      R4,#015H
  557  01DE              DELAY_LOOP_10s_R4:
  558  01DE   FF                 NOP
  559  01DF   FF                 NOP
  560  01E0   FF                 NOP
  561  01E1   FF                 NOP
  562  01E2   FF                 NOP
  563  01E3   FF                 NOP
  564  01E4   FF                 NOP
  565  01E5   FF                 NOP
  566  01E6   FF                 NOP
  567  01E7   FF                 NOP
  568  01E8   4A F4              DJNZ    R4,DELAY_LOOP_10s_R4
  569  01EA   3A F0              DJNZ    R3,DELAY_LOOP_10s_R3
  570  01EC   2A EC              DJNZ    R2,DELAY_LOOP_10s_R2     
  571  01EE   1A E8              DJNZ    R1,DELAY_LOOP_10s_R1
  572  01F0   50 C4              POP     R4
  573  01F2   50 C3              POP     R3
  574  01F4   50 C2              POP     R2
  575  01F6   50 C1              POP     R1
  576                            
  577  01F8   AF                 RET
  578                            
  579  01F9              UART_RX_DATA_INIT:
  580  01F9   70 C0              PUSH    R0
  581  01FB   70 C1              PUSH    R1
  582  01FD   08 01              LD      R0,uart_rx_data
  583  01FF   1C 00              LD      R1,#00H
  584  0201              UART_RX_DATA_INIT_LOOP:
  585  0201   B1 C0              CLR     @R0
  586  0203   0E                 INC     R0
  587  0204   1E                 INC     R1
  588  0205   A6 C1 32           CP      R1,#032H
  589  0208   3B F7              JR      ULE,UART_RX_DATA_INIT_LOOP
  590  020A   50 C1              POP     R1
  591  020C   50 C0              POP     R0
  592                            
  593  020E   AF                 RET
  594                                                                                            
  595  020F              UART_TX:
  596  020F   70 C1              PUSH    R1
  597  0211              UART_TX_CHECK:
  598  0211   18 00              LD      R1,uart_status
  599  0213   37 11 FB           BTJRT   UART_TX_CHECK,R1.0      ; wait until tx finish
  600  0216   5F                 SB1
  601  0217   09 F8              LD      UDATA,R0    
  602  0219   4F                 SB0
  603  021A   46 00 01           OR      uart_status,#00000001B    
  604  021D   50 C1              POP     R1
  605                            
  606  021F   AF                 RET
  607                            
  608  0220              TIMER_A:
  609  0220   E6 D1 50           LD      TADATA,#50H             ; CPU = 8mMHz, interrupt interval = 3.2msec
  610  0223   E6 D2 0E           LD      TACON,#00001110B        ; fsoc/256, timer A interrupt enable
  611                            
  612  0226   AF                 RET       
  613                    
  614  0227              PWM0:
  615  0227   09 F2              LD      PWM0DATA,R0
  616  0229   19 F1              LD      PWM0EX,R1
  617  022B   09 33              LD      pwm0_value,R0
  618  022D   56 F3 F7           AND     PWM0CON,#11110111B      ; clear bit3 (clear counter bit, no effect) set to '0' to avoid clear counter
  619  0230   46 F3 04           OR      PWM0CON,#00000100B      ; PWM start run (if have started, then no effect, keep running)
  620                            
  621  0233   AF                 RET
  622                    
  623  0234              VE209S_TRS:
  624                    ; Binary interface for VE209S
  625                    ; 02 is the <STX>
  626                    ; 00 04 is the size_of_the_packet (4 bytes)
  627                    ; 31 32 33 34 are the 4 bytes of the payload
  628                    ; 03 is the <ETX>
  629  0234   0C 02              LD      R0,#02H
  630  0236   F6 02 0F           CALL    UART_TX
  631  0239   0C 00              LD      R0,#00H
  632  023B   F6 02 0F           CALL    UART_TX
  633  023E   0C 04              LD      R0,#04H
  634  0240   F6 02 0F           CALL    UART_TX
  635  0243   0C 31              LD      R0,#31H
  636  0245   F6 02 0F           CALL    UART_TX
  637  0248   0C 32              LD      R0,#32H
  638  024A   F6 02 0F           CALL    UART_TX
  639  024D   0C 33              LD      R0,#33H
  640  024F   F6 02 0F           CALL    UART_TX    
  641  0252   0C 34              LD      R0,#34H
  642  0254   F6 02 0F           CALL    UART_TX 
  643  0257   0C 03              LD      R0,#03H
  644  0259   F6 02 0F           CALL    UART_TX
  645                            
  646  025C   AF                 RET     
  647                    
  648                    ;;----------------------------------------
  649                    ;;   store data
  650                    ;;   R4 - high address of flash
  651                    ;;   R5 - low address of flash
  652                    ;;   R6 - start address of data
  653                    ;;   R7 - data length
  654                    ;;----------------------------------------
  655  025D              STORE_DATA:
  656  025D   8F                 DI        
  657                    ;;----------------------------------------
  658                    ;;   erase one sector
  659                    ;;----------------------------------------
  660  025E              FULL_FLASH_ERASE:
  661  025E   5F                 SB1
  662  025F   E6 ED A5           LD      FMUSR,#0A5H                             ; Flash Memory User Programming Enable Register
  663                                                                            ; 10100101 = Enable user programming mode
  664                                                                            ; Other values: Disable user programming mode
  665  0262   49 EE              LD      FMSECH,R4                               ; high address
  666  0264   59 EF              LD      FMSECL,R5                               ; low address.
  667  0266   E6 EC A1           LD      FMCON,#10100001B                        ; Flash Memory Control Register
  668                                                                            ; bit 7-4: Flash Memory Mode Selection Bits
  669                                                                            ; 0101 = Programming mode
  670                                                                            ; 1010 = Erase mode
  671                                                                            ; 0110 = Hard lock mode
  672                                                                            ; Others = Not used for S3F8S24
  673                                                                            ; bit 3-1: Not used for S3F8S28/F8S24
  674                                                                            ; bit 0: Flash (Erase or Hard Lock Protection) Operation Start Bit
  675                                                                            ; 0 = Operation stop
  676                                                                            ; 1 = Operation start (This bit will be cleared automatically just after erase operation.)
  677  0269   F6 01 7D           CALL    DELAY_1ms
  678  026C   F6 01 7D           CALL    DELAY_1ms
  679  026F   F6 01 7D           CALL    DELAY_1ms
  680  0272   F6 01 7D           CALL    DELAY_1ms
  681  0275   F6 01 7D           CALL    DELAY_1ms
  682                            
  683                            ;LD      FMUSR,#00H                              ;return to normal mode
  684                            ;SB0
  685                    ;;----------------------------------------
  686                    ;;   write data to sector
  687                    ;;----------------------------------------
  688  0278              FULL_FLASH_WRITE:  
  689                            ;SB1
  690                            ;LD      FMSECH,#0EH                             ;set sector address
  691                            ;LD      FMSECL,#00H
  692                            ;LD      R4,#0EH
  693                            ;LD      R5,#00H
  694  0278   8C 00              LD      R8,#00H
  695                            ;LD      FMUSR,#0A5H                             ;enter user mode 
  696  027A   E6 EC 50           LD      FMCON,#01010000B                        ;program mode
  697  027D              Flash_Write_Loop:
  698  027D   C7 06              LD      R0,@R6
  699  027F   D3 04              LDC     @RR4,R0
  700  0281   5E                 INC     R5
  701  0282   6E                 INC     R6
  702  0283   8E                 INC     R8
  703  0284   A2 87              CP      R8,R7
  704  0286   ED 02 7D           JP      NE,Flash_Write_Loop
  705  0289   E6 ED 00           LD      FMUSR, #00H                             ;return to normal mode
  706  028C   4F                 SB0
  707  028D   9F                 EI
  708                            
  709  028E   AF                 RET
  710                    
  711  028F              TASK_RX:
  712  028F   E5 01 C0           LD      R0,@uart_rx_data
  713  0292   A6 C0 02           CP      R0,#02H                                 ; STX
  714  0295   ED 04 3E           JP      NE,DISCARD_DATA
  715                            
  716                            ;LD      R0,#01H
  717                            ;LD      R1,#00H
  718                            ;CALL    PWM0
  719                            
  720  0298   08 01              LD      R0,uart_rx_data
  721  029A   06 C0 02           ADD     R0,#02H
  722  029D   C7 10              LD      R1,@R0
  723                            ;LD      R10,@R0
  724  029F   06 C1 03           ADD     R1,#03H
  725  02A2   04 01 C1           ADD     R1,uart_rx_data
  726  02A5   C7 01              LD      R0,@R1
  727  02A7   A6 C0 03           CP      R0,#03H                                 ; ETX
  728  02AA   ED 04 3E           JP      NE,DISCARD_DATA
  729                            
  730                            ;ADD     R10,#04H
  731                            ;LD      R0,#3FH
  732                            ;LD      R1,#00H
  733                            ;CALL    PWM0
  734                    
  735  02AD   28 01              LD      R2,uart_rx_data
  736  02AF              UART_RX_ECHO:        
  737  02AF   C7 02              LD      R0,@R2
  738  02B1   F6 02 0F           CALL    UART_TX
  739  02B4   2E                 INC     R2
  740                            ;DJNZ    R10,UART_RX_ECHO
  741  02B5   A2 2F              CP      R2,R15
  742  02B7   3D 02 AF           JP      ULE,UART_RX_ECHO
  743                    
  744                            ; check "ON x" command to turn on LED
  745  02BA   08 01              LD      R0,uart_rx_data
  746  02BC   06 C0 02           ADD     R0,#02H
  747  02BF   C7 10              LD      R1,@R0
  748  02C1   A6 C1 04           CP      R1,#04H
  749  02C4   ED 02 FE           JP      NE,INVALID_ON_CMD
  750  02C7   0E                 INC     R0
  751  02C8   C7 10              LD      R1,@R0
  752  02CA   A6 C1 4F           CP      R1,#4FH         ; 'O'
  753  02CD   ED 02 FE           JP      NE,INVALID_ON_CMD
  754  02D0   0E                 INC     R0
  755  02D1   C7 10              LD      R1,@R0
  756  02D3   A6 C1 4E           CP      R1,#4EH         ; 'N'
  757  02D6   ED 02 FE           JP      NE,INVALID_ON_CMD
  758  02D9   0E                 INC     R0
  759  02DA   C7 10              LD      R1,@R0
  760  02DC   A6 C1 20           CP      R1,#20H         ; ' '
  761  02DF   ED 02 FE           JP      NE,INVALID_ON_CMD
  762  02E2   0E                 INC     R0
  763  02E3   C7 10              LD      R1,@R0
  764  02E5   A6 C1 30           CP      R1,#30H         
  765  02E8   7D 02 FE           JP      ULT,INVALID_ON_CMD
  766  02EB   A6 C1 34           CP      R1,#34H
  767  02EE   BD 02 FE           JP      UGT,INVALID_ON_CMD
  768  02F1   A6 33 00           CP      pwm0_value,#00H
  769  02F4   BD 02 FE           JP      UGT,INVALID_ON_CMD
  770  02F7   0C 01              LD      R0,#01H
  771  02F9   1C 00              LD      R1,#00H
  772  02FB   F6 02 27           CALL    PWM0
  773  02FE              INVALID_ON_CMD:
  774                    
  775                            ; check "OFF x" command to turn on LED
  776  02FE   08 01              LD      R0,uart_rx_data
  777  0300   06 C0 02           ADD     R0,#02H
  778  0303   C7 10              LD      R1,@R0
  779  0305   A6 C1 05           CP      R1,#05H
  780  0308   ED 03 45           JP      NE,INVALID_OFF_CMD
  781  030B   0E                 INC     R0
  782  030C   C7 10              LD      R1,@R0
  783  030E   A6 C1 4F           CP      R1,#4FH         ; 'O'
  784  0311   ED 03 45           JP      NE,INVALID_OFF_CMD
  785  0314   0E                 INC     R0
  786  0315   C7 10              LD      R1,@R0
  787  0317   A6 C1 46           CP      R1,#46H         ; 'F'
  788  031A   ED 03 45           JP      NE,INVALID_OFF_CMD
  789  031D   0E                 INC     R0
  790  031E   C7 10              LD      R1,@R0
  791  0320   A6 C1 46           CP      R1,#46H         ; 'F'
  792  0323   ED 03 45           JP      NE,INVALID_OFF_CMD
  793  0326   0E                 INC     R0
  794  0327   C7 10              LD      R1,@R0
  795  0329   A6 C1 20           CP      R1,#20H         ; ' '
  796  032C   ED 03 45           JP      NE,INVALID_OFF_CMD
  797  032F   0E                 INC     R0
  798  0330   C7 10              LD      R1,@R0
  799  0332   A6 C1 30           CP      R1,#30H
  800  0335   7D 03 45           JP      ULT,INVALID_OFF_CMD
  801  0338   A6 C1 34           CP      R1,#34H
  802  033B   BD 03 45           JP      UGT,INVALID_OFF_CMD
  803  033E   0C 00              LD      R0,#00H
  804  0340   1C 00              LD      R1,#00H
  805  0342   F6 02 27           CALL    PWM0
  806  0345              INVALID_OFF_CMD:
  807                    
  808                            ; check "DIM+ x" command to dim up LED
  809  0345   08 01              LD      R0,uart_rx_data
  810  0347   06 C0 02           ADD     R0,#02H
  811  034A   C7 10              LD      R1,@R0
  812  034C   A6 C1 06           CP      R1,#06H
  813  034F   ED 03 C2           JP      NE,LED_DIMPLUS_CMD
  814  0352   0E                 INC     R0
  815  0353   C7 10              LD      R1,@R0
  816  0355   A6 C1 44           CP      R1,#44H         ; 'D'
  817  0358   ED 03 C2           JP      NE,LED_DIMPLUS_CMD
  818  035B   0E                 INC     R0
  819  035C   C7 10              LD      R1,@R0
  820  035E   A6 C1 49           CP      R1,#49H         ; 'I'
  821  0361   ED 03 C2           JP      NE,LED_DIMPLUS_CMD
  822  0364   0E                 INC     R0
  823  0365   C7 10              LD      R1,@R0
  824  0367   A6 C1 4D           CP      R1,#4DH         ; 'M'
  825  036A   ED 03 C2           JP      NE,LED_DIMPLUS_CMD
  826  036D   0E                 INC     R0
  827  036E   C7 10              LD      R1,@R0
  828  0370   A6 C1 2B           CP      R1,#2BH         ; '+'
  829  0373   ED 03 C2           JP      NE,LED_DIMPLUS_CMD
  830  0376   0E                 INC     R0
  831  0377   C7 10              LD      R1,@R0
  832  0379   A6 C1 20           CP      R1,#20H
  833  037C   ED 03 C2           JP      NE,LED_DIMPLUS_CMD
  834  037F   0E                 INC     R0
  835  0380   C7 10              LD      R1,@R0
  836  0382   A6 C1 30           CP      R1,#30H
  837  0385   7D 03 C2           JP      ULT,LED_DIMPLUS_CMD
  838  0388   A6 C1 34           CP      R1,#34H
  839  038B   BD 03 C2           JP      UGT,LED_DIMPLUS_CMD
  840  038E   A6 33 3F           CP      pwm0_value,#03FH
  841  0391   6D 03 C2           JP      EQ,LED_DIMPLUS_CMD
  842  0394              LED_DIMPLUS_4:
  843  0394   A6 33 30           CP      pwm0_value,#030H
  844  0397   ED 03 9F           JP      NE,LED_DIMPLUS_3
  845  039A   0C 3F              LD      R0,#03FH
  846  039C   8D 03 BD           JP      LED_DIMPLUS_0
  847  039F              LED_DIMPLUS_3:
  848  039F   A6 33 20           CP      pwm0_value,#020H
  849  03A2   ED 03 AA           JP      NE,LED_DIMPLUS_2
  850  03A5   0C 30              LD      R0,#030H
  851  03A7   8D 03 BD           JP      LED_DIMPLUS_0
  852  03AA              LED_DIMPLUS_2:
  853  03AA   A6 33 10           CP      pwm0_value,#010H
  854  03AD   ED 03 B5           JP      NE,LED_DIMPLUS_1
  855  03B0   0C 20              LD      R0,#020H
  856  03B2   8D 03 BD           JP      LED_DIMPLUS_0
  857  03B5              LED_DIMPLUS_1:
  858  03B5   A6 33 01           CP      pwm0_value,#01H
  859  03B8   ED 03 C2           JP      NE,LED_DIMPLUS_CMD
  860  03BB   0C 10              LD      R0,#010H
  861  03BD              LED_DIMPLUS_0:
  862  03BD   1C 00              LD      R1,#00H
  863  03BF   F6 02 27           CALL    PWM0
  864  03C2              LED_DIMPLUS_CMD:
  865                    
  866                            ; check "DIM- x" command to dim up LED
  867  03C2   08 01              LD      R0,uart_rx_data
  868  03C4   06 C0 02           ADD     R0,#02H
  869  03C7   C7 10              LD      R1,@R0
  870  03C9   A6 C1 06           CP      R1,#06H
  871  03CC   ED 04 39           JP      NE,LED_DIMMINUS_CMD
  872  03CF   0E                 INC     R0
  873  03D0   C7 10              LD      R1,@R0
  874  03D2   A6 C1 44           CP      R1,#44H         ; 'D'
  875  03D5   ED 04 39           JP      NE,LED_DIMMINUS_CMD
  876  03D8   0E                 INC     R0
  877  03D9   C7 10              LD      R1,@R0
  878  03DB   A6 C1 49           CP      R1,#49H         ; 'I'
  879  03DE   ED 04 39           JP      NE,LED_DIMMINUS_CMD
  880  03E1   0E                 INC     R0
  881  03E2   C7 10              LD      R1,@R0
  882  03E4   A6 C1 4D           CP      R1,#4DH         ; 'M'
  883  03E7   ED 04 39           JP      NE,LED_DIMMINUS_CMD
  884  03EA   0E                 INC     R0
  885  03EB   C7 10              LD      R1,@R0
  886  03ED   A6 C1 2D           CP      R1,#2DH         ; '-'
  887  03F0   ED 04 39           JP      NE,LED_DIMMINUS_CMD
  888  03F3   0E                 INC     R0
  889  03F4   C7 10              LD      R1,@R0
  890  03F6   A6 C1 20           CP      R1,#20H
  891  03F9   ED 04 39           JP      NE,LED_DIMMINUS_CMD
  892  03FC   0E                 INC     R0
  893  03FD   C7 10              LD      R1,@R0
  894  03FF   A6 C1 30           CP      R1,#30H
  895  0402   7D 04 39           JP      ULT,LED_DIMMINUS_CMD
  896  0405   A6 C1 34           CP      R1,#34H
  897  0408   BD 04 39           JP      UGT,LED_DIMMINUS_CMD
  898  040B   A6 33 01           CP      pwm0_value,#01H
  899  040E   3D 04 39           JP      ULE,LED_DIMMINUS_CMD
  900  0411              LED_DIMMINUS_5:
  901  0411   A6 33 10           CP      pwm0_value,#010H
  902  0414   ED 04 1C           JP      NE,LED_DIMMINUS_4
  903  0417   0C 01              LD      R0,#01H
  904  0419   8D 04 34           JP      LED_DIMMINUS_0
  905  041C              LED_DIMMINUS_4:
  906  041C   A6 F2 20           CP      PWM0DATA,#020H
  907  041F   ED 04 27           JP      NE,LED_DIMMINUS_3
  908  0422   0C 10              LD      R0,#010H
  909  0424   8D 04 34           JP      LED_DIMMINUS_0
  910  0427              LED_DIMMINUS_3:
  911  0427   A6 F2 30           CP      PWM0DATA,#030H
  912  042A   ED 04 32           JP      NE,LED_DIMMINUS_2
  913  042D   0C 20              LD      R0,#020H
  914  042F   8D 04 34           JP      LED_DIMMINUS_0
  915  0432              LED_DIMMINUS_2:
  916  0432   0C 30              LD      R0,#030H
  917  0434              LED_DIMMINUS_0:
  918  0434   1C 00              LD      R1,#00H
  919  0436   F6 02 27           CALL    PWM0
  920  0439              LED_DIMMINUS_CMD:
  921                                            
  922  0439   F6 01 F9           CALL    UART_RX_DATA_INIT
  923                            
  924  043C   F8 01              LD      R15,uart_rx_data
  925  043E              DISCARD_DATA:
  926                            ;CALL    UART_RX_DATA_INIT
  927                            
  928  043E   AF                 RET 
  929                    
  930  043F              BUTTON_PRESS:        
  931  043F   08 E0              LD      R0,P0
  932  0441   56 C0 01           AND     R0,#00000001B
  933  0444   A6 C0 01           CP      R0,#001H
  934  0447   6D 04 DB           JP      EQ,BUTTON_PRESS_RELEASE
  935  044A   A6 CD 64           CP      R13,#064H
  936  044D   2D 04 D2           JP      LE,BUTTON_PRESS_DEBOUNCE
  937  0450   A6 C0 01           CP      R0,#001H
  938  0453   6D 04 DB           JP      EQ,BUTTON_PRESS_RELEASE
  939  0456   A6 CE 00           CP      R14,#00H
  940  0459   ED 04 CD           JP      NE,BUTTON_PRESS_CONTINUE
  941  045C   EC 01              LD      R14,#001H       ; key press down detected
  942  045E   A6 F2 00           CP      PWM0DATA,#00H
  943  0461   ED 04 96           JP      NE,BUTTON_PRESS_LED_OFF
  944  0464              BUTTON_PRESS_LED_ON:
  945  0464   0C 01              LD      R0,#001H
  946  0466   1C 00              LD      R1,#00H
  947  0468   F6 02 27           CALL    PWM0
  948  046B   0C 02              LD      R0,#02H
  949  046D   F6 02 0F           CALL    UART_TX
  950  0470   0C 00              LD      R0,#00H
  951  0472   F6 02 0F           CALL    UART_TX
  952  0475   0C 04              LD      R0,#04H
  953  0477   F6 02 0F           CALL    UART_TX
  954  047A   0C 4F              LD      R0,#4FH
  955  047C   F6 02 0F           CALL    UART_TX
  956  047F   0C 4E              LD      R0,#4EH
  957  0481   F6 02 0F           CALL    UART_TX
  958  0484   0C 20              LD      R0,#20H
  959  0486   F6 02 0F           CALL    UART_TX    
  960  0489   0C 31              LD      R0,#31H
  961  048B   F6 02 0F           CALL    UART_TX 
  962  048E   0C 03              LD      R0,#03H
  963  0490   F6 02 0F           CALL    UART_TX
  964  0493   8D 04 DF           JP      BUTTON_PRESS_END
  965  0496              BUTTON_PRESS_LED_OFF:
  966  0496   0C 00              LD      R0,#00H
  967  0498   1C 00              LD      R1,#00H
  968  049A   F6 02 27           CALL    PWM0
  969  049D   0C 02              LD      R0,#02H
  970  049F   F6 02 0F           CALL    UART_TX
  971  04A2   0C 00              LD      R0,#00H
  972  04A4   F6 02 0F           CALL    UART_TX
  973  04A7   0C 05              LD      R0,#05H
  974  04A9   F6 02 0F           CALL    UART_TX
  975  04AC   0C 4F              LD      R0,#4FH
  976  04AE   F6 02 0F           CALL    UART_TX
  977  04B1   0C 46              LD      R0,#46H
  978  04B3   F6 02 0F           CALL    UART_TX
  979  04B6   0C 46              LD      R0,#46H
  980  04B8   F6 02 0F           CALL    UART_TX
  981  04BB   0C 20              LD      R0,#20H
  982  04BD   F6 02 0F           CALL    UART_TX    
  983  04C0   0C 31              LD      R0,#31H
  984  04C2   F6 02 0F           CALL    UART_TX 
  985  04C5   0C 03              LD      R0,#03H
  986  04C7   F6 02 0F           CALL    UART_TX
  987  04CA   8D 04 DF           JP      BUTTON_PRESS_END
  988  04CD              BUTTON_PRESS_CONTINUE:
  989  04CD   EC 02              LD      R14,#002H       ; key press on hold detected
  990  04CF   8D 04 DF           JP      BUTTON_PRESS_END
  991  04D2              BUTTON_PRESS_DEBOUNCE:
  992  04D2   06 CD 01           ADD     R13,#01H
  993  04D5   F6 01 7D           CALL    DELAY_1ms
  994  04D8   8D 04 DF           JP      BUTTON_PRESS_END
  995  04DB              BUTTON_PRESS_RELEASE:
  996  04DB   B0 CD              CLR     R13
  997  04DD   B0 CE              CLR     R14
  998  04DF              BUTTON_PRESS_END:
  999  04DF   AF                 RET
 1000                    
 1001  04E0              TASK_P00:
 1002  04E0   A6 CE 01           CP      R14,#001H
 1003  04E3   ED 05 52           JP      NE,TASK_P00_END
 1004  04E6   A6 F2 00           CP      PWM0DATA,#00H
 1005  04E9   ED 05 1E           JP      NE,TASK_P00_LED_OFF
 1006  04EC              TASK_P00_LED_ON:
 1007  04EC   0C 01              LD      R0,#001H
 1008  04EE   1C 00              LD      R1,#00H
 1009  04F0   F6 02 27           CALL    PWM0
 1010  04F3   0C 02              LD      R0,#02H
 1011  04F5   F6 02 0F           CALL    UART_TX
 1012  04F8   0C 00              LD      R0,#00H
 1013  04FA   F6 02 0F           CALL    UART_TX
 1014  04FD   0C 04              LD      R0,#04H
 1015  04FF   F6 02 0F           CALL    UART_TX
 1016  0502   0C 4F              LD      R0,#4FH
 1017  0504   F6 02 0F           CALL    UART_TX
 1018  0507   0C 4E              LD      R0,#4EH
 1019  0509   F6 02 0F           CALL    UART_TX
 1020  050C   0C 20              LD      R0,#20H
 1021  050E   F6 02 0F           CALL    UART_TX    
 1022  0511   0C 31              LD      R0,#31H
 1023  0513   F6 02 0F           CALL    UART_TX 
 1024  0516   0C 03              LD      R0,#03H
 1025  0518   F6 02 0F           CALL    UART_TX
 1026  051B   8D 05 52           JP      TASK_P00_END
 1027  051E              TASK_P00_LED_OFF:  
 1028  051E   0C 00              LD      R0,#00H
 1029  0520   1C 00              LD      R1,#00H
 1030  0522   F6 02 27           CALL    PWM0
 1031  0525   0C 02              LD      R0,#02H
 1032  0527   F6 02 0F           CALL    UART_TX
 1033  052A   0C 00              LD      R0,#00H
 1034  052C   F6 02 0F           CALL    UART_TX
 1035  052F   0C 05              LD      R0,#05H
 1036  0531   F6 02 0F           CALL    UART_TX
 1037  0534   0C 4F              LD      R0,#4FH
 1038  0536   F6 02 0F           CALL    UART_TX
 1039  0539   0C 46              LD      R0,#46H
 1040  053B   F6 02 0F           CALL    UART_TX
 1041  053E   0C 46              LD      R0,#46H
 1042  0540   F6 02 0F           CALL    UART_TX
 1043  0543   0C 20              LD      R0,#20H
 1044  0545   F6 02 0F           CALL    UART_TX    
 1045  0548   0C 31              LD      R0,#31H
 1046  054A   F6 02 0F           CALL    UART_TX 
 1047  054D   0C 03              LD      R0,#03H
 1048  054F   F6 02 0F           CALL    UART_TX      
 1049  0552              TASK_P00_END:        
 1050  0552   AF                 RET 
 1051                                                                                                                                                                                                                                                               
 1052                    ;;=======================================================================
 1053                    ;;==      INTERRUPT SERVICE ROUTINE                                    ==
 1054                    ;;==                                                                   ==
 1055                    ;;==                                                                   == 
 1056                    ;;=======================================================================                                                                                
 1057                           ;;----------------------------------------
 1058                           ;;     external interrupt 0
 1059                           ;;----------------------------------------
 1060  0553              EX_INT0:
 1061  0553   56 E8 FE          AND     P0PND, #11111110B                       ;clear pending bit
 1062  0556   8D 05 D5          JP      INT_ISR_END        
 1063                           ;;----------------------------------------
 1064                           ;;     external interrupt 1
 1065                           ;;----------------------------------------
 1066  0559              EX_INT1:
 1067  0559   56 E8 FB           AND     P0PND, #11111011B                       ;clear pending bit
 1068  055C   8D 05 D5           JP      INT_ISR_END
 1069                           ;;----------------------------------------
 1070                           ;;     external interrupt 2
 1071                           ;;----------------------------------------
 1072  055F              EX_INT2:
 1073                            ;XOR     P0,#00100000B                           ;toggle P0.5 
 1074  055F   56 E8 EF           AND     P0PND, #11101111B                       ;clear pending bit
 1075  0562   8D 05 D5           JP      INT_ISR_END
 1076                            ;;----------------------------------------
 1077                           ;;     external interrupt 3
 1078                           ;;----------------------------------------
 1079  0565              EX_INT3:
 1080                            ;XOR     P0,#00010000B                           ;toggle P0.4 
 1081  0565   56 E8 BF           AND     P0PND, #10111111B                       ;clear pending bit
 1082  0568   8D 05 D5           JP      INT_ISR_END
 1083                            ;;----------------------------------------
 1084                           ;;     external interrupt 4
 1085                           ;;----------------------------------------
 1086  056B              EX_INT4:
 1087                            ;XOR     P0,#10000000B                           ;toggle P0.7 
 1088  056B   56 EF FE           AND     P3PND, #11111110B                       ;clear pending bit
 1089  056E   8D 05 D5           JP      INT_ISR_END
 1090                            ;;----------------------------------------
 1091                           ;;     external interrupt 5
 1092                           ;;----------------------------------------
 1093  0571              EX_INT5:
 1094                            ;XOR     P0,#01000000B                           ;toggle P0.6 
 1095  0571   56 EF FB           AND     P3PND, #11111011B                       ;clear pending bit
 1096  0574   8D 05 D5           JP      INT_ISR_END
 1097                            ;;----------------------------------------
 1098                           ;;     external interrupt 6
 1099                           ;;----------------------------------------
 1100  0577              EX_INT6:
 1101                            ;XOR     P0,#00100000B                           ;toggle P0.5 
 1102  0577   56 EF EF           AND     P3PND, #11101111B                       ;clear pending bit
 1103  057A   8D 05 D5           JP      INT_ISR_END
 1104                            ;;----------------------------------------
 1105                           ;;     external interrupt 7
 1106                           ;;----------------------------------------
 1107  057D              EX_INT7:
 1108                            ;XOR     P0,#00010000B                           ;toggle P0.4 
 1109  057D   56 EF BF           AND     P3PND, #10111111B                       ;clear pending bit
 1110  0580   8D 05 D5           JP      INT_ISR_END
 1111                            
 1112                           ;;----------------------------------------
 1113                           ;;     Timer0/A match interrupt
 1114                           ;;----------------------------------------  
 1115  0583              T0_A_MC_INT:
 1116                            ;XOR     P0,#10000000B                           ;toggle P0.7
 1117  0583   56 D2 FE           AND     TACON,#11111110B                        ;clear pending bit
 1118  0586   8D 05 D5           JP      INT_ISR_END 
 1119                           ;;----------------------------------------
 1120                           ;;     TimerB match interrupt
 1121                           ;;---------------------------------------- 
 1122  0589              TB_MC_INT:
 1123                            ;XOR     P0,#01000000B                           ;toggle P0.6
 1124  0589   56 EE FE           AND     TBCON,#11111110B                        ;clear pending bit
 1125  058C   8D 05 D5           JP      INT_ISR_END
 1126                           ;;----------------------------------------
 1127                           ;;     PWM1 Overflow interrupt 
 1128                           ;;----------------------------------------
 1129  058F              PWM1_OVF_INT:
 1130                            ;XOR     P0,#01000000B                           ;toggle P0.6
 1131  058F   5F                 SB1
 1132  0590   56 E8 F6           AND     PWM1CON,#11110110B                       ;clear pending bit
 1133  0593   4F                 SB0
 1134  0594   8D 05 D5           JP      INT_ISR_END
 1135                           ;;----------------------------------------
 1136                           ;;     PWM0 Overflow interrupt 
 1137                           ;;----------------------------------------
 1138  0597              PWM0_OVF_INT:
 1139                            ;XOR     P0,#00100000B                           ;toggle P0.5
 1140  0597   56 F3 F6           AND     PWM0CON,#11110110B                       ;clear pending bit
 1141  059A   8D 05 D5           JP      INT_ISR_END
 1142                           ;;----------------------------------------
 1143                           ;;     Timer1 match interrupt
 1144                           ;;----------------------------------------  
 1145  059D              TIMER1_MC_INT:
 1146                            ;XOR     P0,#00100000B                            ;toggle P0.5
 1147  059D   5F                 SB1
 1148  059E   56 E4 FE           AND     T1CON,#11111110B                         ;clear pending bit
 1149  05A1   4F                 SB0
 1150  05A2   8D 05 D5           JP      INT_ISR_END 
 1151                           ;;----------------------------------------
 1152                           ;;     Timer1 Overflow interrupt
 1153                           ;;----------------------------------------  
 1154  05A5              TIMER1_OVF_INT:
 1155                            ;XOR     P0,#00010000B                            ;toggle P0.4
 1156  05A5   5F                 SB1
 1157  05A6   56 E4 FB           AND     T1CON,#11111011B                         ;clear pending bit
 1158  05A9   4F                 SB0
 1159  05AA   8D 05 D5           JP      INT_ISR_END
 1160                           ;;----------------------------------------
 1161                           ;;     Low voltage detector interrupt
 1162                           ;;---------------------------------------- 
 1163  05AD              LVD_INT:
 1164                            ;SB0
 1165                            ;AND      P0,#11110111B                            ;light P0.3
 1166  05AD   5F                 SB1
 1167  05AE   56 F4 EF           AND     LVDCON, #11101111B                       ;disable interrupt
 1168  05B1   4F                 SB0
 1169  05B2   8D 05 D5           JP      INT_ISR_END              
 1170                           ;;----------------------------------------
 1171                           ;;     UART interrupt
 1172                           ;;---------------------------------------- 
 1173  05B5              UART_TRS_INT:
 1174  05B5   5F                 SB1
 1175  05B6   56 00 FE           AND     uart_status,#11111110B
 1176  05B9   56 F6 FE           AND     UARTPND, #11111110B                      ;clear pending bit
 1177  05BC   4F                 SB0
 1178  05BD   8D 05 D5           JP      INT_ISR_END
 1179  05C0              UART_RV_INT:
 1180  05C0   5F                 SB1
 1181  05C1   F5 F8 CF           LD      @R15,UDATA
 1182  05C4   FE                 INC     R15
 1183  05C5   56 F6 FD           AND     UARTPND, #11111101B                      ;clear pending bit
 1184  05C8   4F                 SB0
 1185  05C9   8D 05 D5           JP      INT_ISR_END
 1186                           ;;----------------------------------------
 1187                           ;;     IIC interrupt
 1188                           ;;---------------------------------------- 
 1189  05CC              IIC_INT:
 1190  05CC   8D 05 D5           JP      INT_ISR_END
 1191                           ;;----------------------------------------
 1192                           ;;     Watchdog  interrupt
 1193                           ;;---------------------------------------- 
 1194  05CF              WDT_INT:
 1195                            ;XOR     P3,#00000001B                           ;toggle P3.0
 1196                            ;AND      WDTCON, #10111111B                    ;disable reset, clear counter
 1197  05CF   46 F6 10           OR      WDTCON, #00010000B                      ;clear counter.      
 1198  05D2   8D 05 D5           JP      INT_ISR_END       
 1199                    
 1200                    
 1201                    
 1202                           ;;----------------------------------------
 1203                           ;;     interrupt service end
 1204                           ;;----------------------------------------        
 1205  05D5              INT_ISR_END:                
 1206  05D5   BF                IRET
 1207                           
 1208  05D6              .END                                                          


Total 1202 Lines Assembled - 0 Errors, 0 Warnings
Total code size 0x500


