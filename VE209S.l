Thu Oct 03 10:57:40 2013
                              
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
   99  00D8   05 09             .VECTOR  0D8H, EX_INT7
  100  00DA   05 03             .VECTOR  0DAH, EX_INT6
  101  00DC   04 FD             .VECTOR  0DCH, EX_INT5
  102  00DE   04 F7             .VECTOR  0DEH, EX_INT4
  103  00E0   05 58             .VECTOR  0E0H, IIC_INT
  104  00E2   05 4C             .VECTOR  0E2H, UART_RV_INT
  105  00E4   05 41             .VECTOR  0E4H, UART_TRS_INT
  106  00E6   05 5B             .VECTOR  0E6H, WDT_INT
  107  00E8   05 39             .VECTOR  0E8H, LVD_INT
  108  00EA   05 31             .VECTOR  0EAH, TIMER1_OVF_INT
  109  00EC   05 29             .VECTOR  0ECH, TIMER1_MC_INT
  110  00F0   05 1B             .VECTOR  0F0H, PWM1_OVF_INT
  111  00F2   05 23             .VECTOR  0F2H, PWM0_OVF_INT
  112  00F4   05 15             .VECTOR  0F4H, TB_MC_INT
  113  00F6   05 0F             .VECTOR  0F6H, T0_A_MC_INT
  114  00F8   04 F1             .VECTOR  0F8H, EX_INT3
  115  00FA   04 EB             .VECTOR  0FAH, EX_INT2
  116  00FC   04 E5             .VECTOR  0FCH, EX_INT1
  117  00FE   04 DF             .VECTOR  0FEH, EX_INT0
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
  424  0149   F6 01 FA           CALL    UART_RX_DATA_INIT
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
  445  016E   9F                 EI
  446                    
  447                    ;;=======================================================================
  448                    ;;==      Main function                                                ==
  449                    ;;==                                                                   ==
  450                    ;;==                                                                   == 
  451                    ;;=======================================================================
  452  016F              MAIN::
  453  016F   46 D3 02           OR      BTCON,#02H              ; Enable watchdog function
  454                                                            ; Basic counter (BTCNT) clear
  455                    
  456  0172   F6 02 90           CALL    TASK_RX 
  457                            
  458  0175   F6 04 40           CALL    BUTTON_PRESS
  459                            
  460  0178   F6 04 6C           CALL    TASK_P00
  461                            
  462                            ;CALL    DELAY_10s
  463                                                                                        
  464  017B   8D 01 6F           JP      MAIN                                
  465                    
  466                    ;;=======================================================================
  467                    ;;==      SUBROUTINEs                                                  ==
  468                    ;;==                                                                   ==
  469                    ;;==                                                                   == 
  470                    ;;=======================================================================
  471  017E              DELAY_1ms:
  472  017E   70 C1              PUSH    R1
  473  0180   1C A6              LD      R1,#0A6H
  474  0182              DELAY_LOOP_1ms:
  475  0182   FF                 NOP
  476  0183   FF                 NOP
  477  0184   FF                 NOP
  478  0185   FF                 NOP
  479  0186   FF                 NOP
  480  0187   FF                 NOP
  481  0188   FF                 NOP
  482  0189   FF                 NOP
  483  018A   FF                 NOP
  484  018B   FF                 NOP     
  485  018C   1A F4              DJNZ    R1,DELAY_LOOP_1ms
  486  018E   50 C1              POP     R1
  487                            
  488  0190   AF                 RET      
  489                    
  490  0191              DELAY_10ms:
  491  0191   70 C1              PUSH    R1
  492  0193   70 C2              PUSH    R2
  493  0195   1C 14              LD      R1,#014H
  494  0197              DELAY_LOOP_10ms_R1:
  495  0197   2C 53              LD      R2,#053H
  496  0199              DELAY_LOOP_10ms_R2:
  497  0199   FF                 NOP
  498  019A   FF                 NOP
  499  019B   FF                 NOP
  500  019C   FF                 NOP
  501  019D   FF                 NOP
  502  019E   FF                 NOP
  503  019F   FF                 NOP
  504  01A0   FF                 NOP
  505  01A1   FF                 NOP
  506  01A2   FF                 NOP
  507  01A3   2A F4              DJNZ    R2,DELAY_LOOP_10ms_R2     
  508  01A5   1A F0              DJNZ    R1,DELAY_LOOP_10ms_R1
  509  01A7   50 C2              POP     R2
  510  01A9   50 C1              POP     R1
  511                            
  512  01AB   AF                 RET
  513                    
  514  01AC              DELAY_1s:
  515  01AC   70 C1              PUSH    R1
  516  01AE   70 C2              PUSH    R2
  517  01B0   70 C3              PUSH    R3
  518  01B2   1C 43              LD      R1,#043H
  519  01B4              DELAY_LOOP_1s_R1:
  520  01B4   2C 0C              LD      R2,#00CH
  521  01B6              DELAY_LOOP_1s_R2:
  522  01B6   3C CF              LD      R3,#0CFH
  523  01B8              DELAY_LOOP_1s_R3:
  524  01B8   FF                 NOP
  525  01B9   FF                 NOP
  526  01BA   FF                 NOP
  527  01BB   FF                 NOP
  528  01BC   FF                 NOP
  529  01BD   FF                 NOP
  530  01BE   FF                 NOP
  531  01BF   FF                 NOP
  532  01C0   FF                 NOP
  533  01C1   FF                 NOP
  534  01C2   3A F4              DJNZ    R3,DELAY_LOOP_1s_R3
  535  01C4   2A F0              DJNZ    R2,DELAY_LOOP_1s_R2     
  536  01C6   1A EC              DJNZ    R1,DELAY_LOOP_1s_R1
  537  01C8   50 C3              POP     R3
  538  01CA   50 C2              POP     R2
  539  01CC   50 C1              POP     R1
  540                            
  541  01CE   AF                 RET
  542                    
  543  01CF              DELAY_10s:
  544  01CF   70 C1              PUSH    R1
  545  01D1   70 C2              PUSH    R2
  546  01D3   70 C3              PUSH    R3
  547  01D5   70 C4              PUSH    R4
  548  01D7   1C DF              LD      R1,#0DFH
  549  01D9              DELAY_LOOP_10s_R1:
  550  01D9   2C 04              LD      R2,#004H
  551  01DB              DELAY_LOOP_10s_R2:
  552  01DB   3C 42              LD      R3,#042H
  553  01DD              DELAY_LOOP_10s_R3:
  554  01DD   4C 15              LD      R4,#015H
  555  01DF              DELAY_LOOP_10s_R4:
  556  01DF   FF                 NOP
  557  01E0   FF                 NOP
  558  01E1   FF                 NOP
  559  01E2   FF                 NOP
  560  01E3   FF                 NOP
  561  01E4   FF                 NOP
  562  01E5   FF                 NOP
  563  01E6   FF                 NOP
  564  01E7   FF                 NOP
  565  01E8   FF                 NOP
  566  01E9   4A F4              DJNZ    R4,DELAY_LOOP_10s_R4
  567  01EB   3A F0              DJNZ    R3,DELAY_LOOP_10s_R3
  568  01ED   2A EC              DJNZ    R2,DELAY_LOOP_10s_R2     
  569  01EF   1A E8              DJNZ    R1,DELAY_LOOP_10s_R1
  570  01F1   50 C4              POP     R4
  571  01F3   50 C3              POP     R3
  572  01F5   50 C2              POP     R2
  573  01F7   50 C1              POP     R1
  574                            
  575  01F9   AF                 RET
  576                            
  577  01FA              UART_RX_DATA_INIT:
  578  01FA   70 C0              PUSH    R0
  579  01FC   70 C1              PUSH    R1
  580  01FE   08 01              LD      R0,uart_rx_data
  581  0200   1C 00              LD      R1,#00H
  582  0202              UART_RX_DATA_INIT_LOOP:
  583  0202   B1 C0              CLR     @R0
  584  0204   0E                 INC     R0
  585  0205   1E                 INC     R1
  586  0206   A6 C1 32           CP      R1,#032H
  587  0209   3B F7              JR      ULE,UART_RX_DATA_INIT_LOOP
  588  020B   50 C1              POP     R1
  589  020D   50 C0              POP     R0
  590                            
  591  020F   AF                 RET
  592                                                                                            
  593  0210              UART_TX:
  594  0210   70 C1              PUSH    R1
  595  0212              UART_TX_CHECK:
  596  0212   18 00              LD      R1,uart_status
  597  0214   37 11 FB           BTJRT   UART_TX_CHECK,R1.0      ; wait until tx finish
  598  0217   5F                 SB1
  599  0218   09 F8              LD      UDATA,R0    
  600  021A   4F                 SB0
  601  021B   46 00 01           OR      uart_status,#00000001B    
  602  021E   50 C1              POP     R1
  603                            
  604  0220   AF                 RET
  605                            
  606  0221              TIMER_A:
  607  0221   E6 D1 50           LD      TADATA,#50H             ; CPU = 8mMHz, interrupt interval = 3.2msec
  608  0224   E6 D2 0E           LD      TACON,#00001110B        ; fsoc/256, timer A interrupt enable
  609                            
  610  0227   AF                 RET       
  611                    
  612  0228              PWM0:
  613  0228   09 F2              LD      PWM0DATA,R0
  614  022A   19 F1              LD      PWM0EX,R1
  615  022C   09 33              LD      pwm0_value,R0
  616  022E   56 F3 F7           AND     PWM0CON,#11110111B      ; clear bit3 (clear counter bit, no effect) set to '0' to avoid clear counter
  617  0231   46 F3 04           OR      PWM0CON,#00000100B      ; PWM start run (if have started, then no effect, keep running)
  618                            
  619  0234   AF                 RET
  620                    
  621  0235              VE209S_TRS:
  622                    ; Binary interface for VE209S
  623                    ; 02 is the <STX>
  624                    ; 00 04 is the size_of_the_packet (4 bytes)
  625                    ; 31 32 33 34 are the 4 bytes of the payload
  626                    ; 03 is the <ETX>
  627  0235   0C 02              LD      R0,#02H
  628  0237   F6 02 10           CALL    UART_TX
  629  023A   0C 00              LD      R0,#00H
  630  023C   F6 02 10           CALL    UART_TX
  631  023F   0C 04              LD      R0,#04H
  632  0241   F6 02 10           CALL    UART_TX
  633  0244   0C 31              LD      R0,#31H
  634  0246   F6 02 10           CALL    UART_TX
  635  0249   0C 32              LD      R0,#32H
  636  024B   F6 02 10           CALL    UART_TX
  637  024E   0C 33              LD      R0,#33H
  638  0250   F6 02 10           CALL    UART_TX    
  639  0253   0C 34              LD      R0,#34H
  640  0255   F6 02 10           CALL    UART_TX 
  641  0258   0C 03              LD      R0,#03H
  642  025A   F6 02 10           CALL    UART_TX
  643                            
  644  025D   AF                 RET     
  645                    
  646                    ;;----------------------------------------
  647                    ;;   store data
  648                    ;;   R4 - high address of flash
  649                    ;;   R5 - low address of flash
  650                    ;;   R6 - start address of data
  651                    ;;   R7 - data length
  652                    ;;----------------------------------------
  653  025E              STORE_DATA:
  654  025E   8F                 DI        
  655                    ;;----------------------------------------
  656                    ;;   erase one sector
  657                    ;;----------------------------------------
  658  025F              FULL_FLASH_ERASE:
  659  025F   5F                 SB1
  660  0260   E6 ED A5           LD      FMUSR,#0A5H                             ; Flash Memory User Programming Enable Register
  661                                                                            ; 10100101 = Enable user programming mode
  662                                                                            ; Other values: Disable user programming mode
  663  0263   49 EE              LD      FMSECH,R4                               ; high address
  664  0265   59 EF              LD      FMSECL,R5                               ; low address.
  665  0267   E6 EC A1           LD      FMCON,#10100001B                        ; Flash Memory Control Register
  666                                                                            ; bit 7-4: Flash Memory Mode Selection Bits
  667                                                                            ; 0101 = Programming mode
  668                                                                            ; 1010 = Erase mode
  669                                                                            ; 0110 = Hard lock mode
  670                                                                            ; Others = Not used for S3F8S24
  671                                                                            ; bit 3-1: Not used for S3F8S28/F8S24
  672                                                                            ; bit 0: Flash (Erase or Hard Lock Protection) Operation Start Bit
  673                                                                            ; 0 = Operation stop
  674                                                                            ; 1 = Operation start (This bit will be cleared automatically just after erase operation.)
  675  026A   F6 01 7E           CALL    DELAY_1ms
  676  026D   F6 01 7E           CALL    DELAY_1ms
  677  0270   F6 01 7E           CALL    DELAY_1ms
  678  0273   F6 01 7E           CALL    DELAY_1ms
  679  0276   F6 01 7E           CALL    DELAY_1ms
  680                            
  681                            ;LD      FMUSR,#00H                              ;return to normal mode
  682                            ;SB0
  683                    ;;----------------------------------------
  684                    ;;   write data to sector
  685                    ;;----------------------------------------
  686  0279              FULL_FLASH_WRITE:  
  687                            ;SB1
  688                            ;LD      FMSECH,#0EH                             ;set sector address
  689                            ;LD      FMSECL,#00H
  690                            ;LD      R4,#0EH
  691                            ;LD      R5,#00H
  692  0279   8C 00              LD      R8,#00H
  693                            ;LD      FMUSR,#0A5H                             ;enter user mode 
  694  027B   E6 EC 50           LD      FMCON,#01010000B                        ;program mode
  695  027E              Flash_Write_Loop:
  696  027E   C7 06              LD      R0,@R6
  697  0280   D3 04              LDC     @RR4,R0
  698  0282   5E                 INC     R5
  699  0283   6E                 INC     R6
  700  0284   8E                 INC     R8
  701  0285   A2 87              CP      R8,R7
  702  0287   ED 02 7E           JP      NE,Flash_Write_Loop
  703  028A   E6 ED 00           LD      FMUSR, #00H                             ;return to normal mode
  704  028D   4F                 SB0
  705  028E   9F                 EI
  706                            
  707  028F   AF                 RET
  708                    
  709  0290              TASK_RX:
  710  0290   E5 01 C0           LD      R0,@uart_rx_data
  711  0293   A6 C0 02           CP      R0,#02H                                 ; STX
  712  0296   ED 04 3F           JP      NE,DISCARD_DATA
  713                            
  714                            ;LD      R0,#01H
  715                            ;LD      R1,#00H
  716                            ;CALL    PWM0
  717                            
  718  0299   08 01              LD      R0,uart_rx_data
  719  029B   06 C0 02           ADD     R0,#02H
  720  029E   C7 10              LD      R1,@R0
  721                            ;LD      R10,@R0
  722  02A0   06 C1 03           ADD     R1,#03H
  723  02A3   04 01 C1           ADD     R1,uart_rx_data
  724  02A6   C7 01              LD      R0,@R1
  725  02A8   A6 C0 03           CP      R0,#03H                                 ; ETX
  726  02AB   ED 04 3F           JP      NE,DISCARD_DATA
  727                            
  728                            ;ADD     R10,#04H
  729                            ;LD      R0,#3FH
  730                            ;LD      R1,#00H
  731                            ;CALL    PWM0
  732                    
  733  02AE   28 01              LD      R2,uart_rx_data
  734  02B0              UART_RX_ECHO:        
  735  02B0   C7 02              LD      R0,@R2
  736  02B2   F6 02 10           CALL    UART_TX
  737  02B5   2E                 INC     R2
  738                            ;DJNZ    R10,UART_RX_ECHO
  739  02B6   A2 2F              CP      R2,R15
  740  02B8   3D 02 B0           JP      ULE,UART_RX_ECHO
  741                    
  742                            ; check "ON x" command to turn on LED
  743  02BB   08 01              LD      R0,uart_rx_data
  744  02BD   06 C0 02           ADD     R0,#02H
  745  02C0   C7 10              LD      R1,@R0
  746  02C2   A6 C1 04           CP      R1,#04H
  747  02C5   ED 02 FF           JP      NE,INVALID_ON_CMD
  748  02C8   0E                 INC     R0
  749  02C9   C7 10              LD      R1,@R0
  750  02CB   A6 C1 4F           CP      R1,#4FH         ; 'O'
  751  02CE   ED 02 FF           JP      NE,INVALID_ON_CMD
  752  02D1   0E                 INC     R0
  753  02D2   C7 10              LD      R1,@R0
  754  02D4   A6 C1 4E           CP      R1,#4EH         ; 'N'
  755  02D7   ED 02 FF           JP      NE,INVALID_ON_CMD
  756  02DA   0E                 INC     R0
  757  02DB   C7 10              LD      R1,@R0
  758  02DD   A6 C1 20           CP      R1,#20H         ; ' '
  759  02E0   ED 02 FF           JP      NE,INVALID_ON_CMD
  760  02E3   0E                 INC     R0
  761  02E4   C7 10              LD      R1,@R0
  762  02E6   A6 C1 30           CP      R1,#30H         
  763  02E9   7D 02 FF           JP      ULT,INVALID_ON_CMD
  764  02EC   A6 C1 34           CP      R1,#34H
  765  02EF   BD 02 FF           JP      UGT,INVALID_ON_CMD
  766  02F2   A6 33 00           CP      pwm0_value,#00H
  767  02F5   BD 02 FF           JP      UGT,INVALID_ON_CMD
  768  02F8   0C 01              LD      R0,#01H
  769  02FA   1C 00              LD      R1,#00H
  770  02FC   F6 02 28           CALL    PWM0
  771  02FF              INVALID_ON_CMD:
  772                    
  773                            ; check "OFF x" command to turn on LED
  774  02FF   08 01              LD      R0,uart_rx_data
  775  0301   06 C0 02           ADD     R0,#02H
  776  0304   C7 10              LD      R1,@R0
  777  0306   A6 C1 05           CP      R1,#05H
  778  0309   ED 03 46           JP      NE,INVALID_OFF_CMD
  779  030C   0E                 INC     R0
  780  030D   C7 10              LD      R1,@R0
  781  030F   A6 C1 4F           CP      R1,#4FH         ; 'O'
  782  0312   ED 03 46           JP      NE,INVALID_OFF_CMD
  783  0315   0E                 INC     R0
  784  0316   C7 10              LD      R1,@R0
  785  0318   A6 C1 46           CP      R1,#46H         ; 'F'
  786  031B   ED 03 46           JP      NE,INVALID_OFF_CMD
  787  031E   0E                 INC     R0
  788  031F   C7 10              LD      R1,@R0
  789  0321   A6 C1 46           CP      R1,#46H         ; 'F'
  790  0324   ED 03 46           JP      NE,INVALID_OFF_CMD
  791  0327   0E                 INC     R0
  792  0328   C7 10              LD      R1,@R0
  793  032A   A6 C1 20           CP      R1,#20H         ; ' '
  794  032D   ED 03 46           JP      NE,INVALID_OFF_CMD
  795  0330   0E                 INC     R0
  796  0331   C7 10              LD      R1,@R0
  797  0333   A6 C1 30           CP      R1,#30H
  798  0336   7D 03 46           JP      ULT,INVALID_OFF_CMD
  799  0339   A6 C1 34           CP      R1,#34H
  800  033C   BD 03 46           JP      UGT,INVALID_OFF_CMD
  801  033F   0C 00              LD      R0,#00H
  802  0341   1C 00              LD      R1,#00H
  803  0343   F6 02 28           CALL    PWM0
  804  0346              INVALID_OFF_CMD:
  805                    
  806                            ; check "DIM+ x" command to dim up LED
  807  0346   08 01              LD      R0,uart_rx_data
  808  0348   06 C0 02           ADD     R0,#02H
  809  034B   C7 10              LD      R1,@R0
  810  034D   A6 C1 06           CP      R1,#06H
  811  0350   ED 03 C3           JP      NE,LED_DIMPLUS_CMD
  812  0353   0E                 INC     R0
  813  0354   C7 10              LD      R1,@R0
  814  0356   A6 C1 44           CP      R1,#44H         ; 'D'
  815  0359   ED 03 C3           JP      NE,LED_DIMPLUS_CMD
  816  035C   0E                 INC     R0
  817  035D   C7 10              LD      R1,@R0
  818  035F   A6 C1 49           CP      R1,#49H         ; 'I'
  819  0362   ED 03 C3           JP      NE,LED_DIMPLUS_CMD
  820  0365   0E                 INC     R0
  821  0366   C7 10              LD      R1,@R0
  822  0368   A6 C1 4D           CP      R1,#4DH         ; 'M'
  823  036B   ED 03 C3           JP      NE,LED_DIMPLUS_CMD
  824  036E   0E                 INC     R0
  825  036F   C7 10              LD      R1,@R0
  826  0371   A6 C1 2B           CP      R1,#2BH         ; '+'
  827  0374   ED 03 C3           JP      NE,LED_DIMPLUS_CMD
  828  0377   0E                 INC     R0
  829  0378   C7 10              LD      R1,@R0
  830  037A   A6 C1 20           CP      R1,#20H
  831  037D   ED 03 C3           JP      NE,LED_DIMPLUS_CMD
  832  0380   0E                 INC     R0
  833  0381   C7 10              LD      R1,@R0
  834  0383   A6 C1 30           CP      R1,#30H
  835  0386   7D 03 C3           JP      ULT,LED_DIMPLUS_CMD
  836  0389   A6 C1 34           CP      R1,#34H
  837  038C   BD 03 C3           JP      UGT,LED_DIMPLUS_CMD
  838  038F   A6 33 3F           CP      pwm0_value,#03FH
  839  0392   6D 03 C3           JP      EQ,LED_DIMPLUS_CMD
  840  0395              LED_DIMPLUS_4:
  841  0395   A6 33 30           CP      pwm0_value,#030H
  842  0398   ED 03 A0           JP      NE,LED_DIMPLUS_3
  843  039B   0C 3F              LD      R0,#03FH
  844  039D   8D 03 BE           JP      LED_DIMPLUS_0
  845  03A0              LED_DIMPLUS_3:
  846  03A0   A6 33 20           CP      pwm0_value,#020H
  847  03A3   ED 03 AB           JP      NE,LED_DIMPLUS_2
  848  03A6   0C 30              LD      R0,#030H
  849  03A8   8D 03 BE           JP      LED_DIMPLUS_0
  850  03AB              LED_DIMPLUS_2:
  851  03AB   A6 33 10           CP      pwm0_value,#010H
  852  03AE   ED 03 B6           JP      NE,LED_DIMPLUS_1
  853  03B1   0C 20              LD      R0,#020H
  854  03B3   8D 03 BE           JP      LED_DIMPLUS_0
  855  03B6              LED_DIMPLUS_1:
  856  03B6   A6 33 01           CP      pwm0_value,#01H
  857  03B9   ED 03 C3           JP      NE,LED_DIMPLUS_CMD
  858  03BC   0C 10              LD      R0,#010H
  859  03BE              LED_DIMPLUS_0:
  860  03BE   1C 00              LD      R1,#00H
  861  03C0   F6 02 28           CALL    PWM0
  862  03C3              LED_DIMPLUS_CMD:
  863                    
  864                            ; check "DIM- x" command to dim up LED
  865  03C3   08 01              LD      R0,uart_rx_data
  866  03C5   06 C0 02           ADD     R0,#02H
  867  03C8   C7 10              LD      R1,@R0
  868  03CA   A6 C1 06           CP      R1,#06H
  869  03CD   ED 04 3A           JP      NE,LED_DIMMINUS_CMD
  870  03D0   0E                 INC     R0
  871  03D1   C7 10              LD      R1,@R0
  872  03D3   A6 C1 44           CP      R1,#44H         ; 'D'
  873  03D6   ED 04 3A           JP      NE,LED_DIMMINUS_CMD
  874  03D9   0E                 INC     R0
  875  03DA   C7 10              LD      R1,@R0
  876  03DC   A6 C1 49           CP      R1,#49H         ; 'I'
  877  03DF   ED 04 3A           JP      NE,LED_DIMMINUS_CMD
  878  03E2   0E                 INC     R0
  879  03E3   C7 10              LD      R1,@R0
  880  03E5   A6 C1 4D           CP      R1,#4DH         ; 'M'
  881  03E8   ED 04 3A           JP      NE,LED_DIMMINUS_CMD
  882  03EB   0E                 INC     R0
  883  03EC   C7 10              LD      R1,@R0
  884  03EE   A6 C1 2D           CP      R1,#2DH         ; '-'
  885  03F1   ED 04 3A           JP      NE,LED_DIMMINUS_CMD
  886  03F4   0E                 INC     R0
  887  03F5   C7 10              LD      R1,@R0
  888  03F7   A6 C1 20           CP      R1,#20H
  889  03FA   ED 04 3A           JP      NE,LED_DIMMINUS_CMD
  890  03FD   0E                 INC     R0
  891  03FE   C7 10              LD      R1,@R0
  892  0400   A6 C1 30           CP      R1,#30H
  893  0403   7D 04 3A           JP      ULT,LED_DIMMINUS_CMD
  894  0406   A6 C1 34           CP      R1,#34H
  895  0409   BD 04 3A           JP      UGT,LED_DIMMINUS_CMD
  896  040C   A6 33 01           CP      pwm0_value,#01H
  897  040F   3D 04 3A           JP      ULE,LED_DIMMINUS_CMD
  898  0412              LED_DIMMINUS_5:
  899  0412   A6 33 10           CP      pwm0_value,#010H
  900  0415   ED 04 1D           JP      NE,LED_DIMMINUS_4
  901  0418   0C 01              LD      R0,#01H
  902  041A   8D 04 35           JP      LED_DIMMINUS_0
  903  041D              LED_DIMMINUS_4:
  904  041D   A6 F2 20           CP      PWM0DATA,#020H
  905  0420   ED 04 28           JP      NE,LED_DIMMINUS_3
  906  0423   0C 10              LD      R0,#010H
  907  0425   8D 04 35           JP      LED_DIMMINUS_0
  908  0428              LED_DIMMINUS_3:
  909  0428   A6 F2 30           CP      PWM0DATA,#030H
  910  042B   ED 04 33           JP      NE,LED_DIMMINUS_2
  911  042E   0C 20              LD      R0,#020H
  912  0430   8D 04 35           JP      LED_DIMMINUS_0
  913  0433              LED_DIMMINUS_2:
  914  0433   0C 30              LD      R0,#030H
  915  0435              LED_DIMMINUS_0:
  916  0435   1C 00              LD      R1,#00H
  917  0437   F6 02 28           CALL    PWM0
  918  043A              LED_DIMMINUS_CMD:
  919                                            
  920  043A   F6 01 FA           CALL    UART_RX_DATA_INIT
  921                            
  922  043D   F8 01              LD      R15,uart_rx_data
  923  043F              DISCARD_DATA:
  924                            ;CALL    UART_RX_DATA_INIT
  925                            
  926  043F   AF                 RET 
  927                    
  928  0440              BUTTON_PRESS:
  929  0440   08 E0              LD      R0,P0
  930  0442   56 C0 01           AND     R0,#00000001B
  931  0445   37 01 1F           BTJRT   BUTTON_PRESS_RELEASED,R0.0
  932  0448   A6 CD 64           CP      R13,#064H
  933  044B   2D 04 5E           JP      LE,BUTTON_PRESS_DEBOUNCE
  934  044E   A6 CE 00           CP      R14,#00H
  935  0451   ED 04 59           JP      NE,BUTTON_PRESS_CONTINUE
  936  0454   EC 01              LD      R14,#001H       ; key press down detected
  937  0456   8D 04 6B           JP      BUTTON_PRESS_END
  938  0459              BUTTON_PRESS_CONTINUE:
  939  0459   EC 02              LD      R14,#002H       ; key press on hold detected
  940  045B   8D 04 6B           JP      BUTTON_PRESS_END
  941  045E              BUTTON_PRESS_DEBOUNCE:
  942  045E   06 CD 01           ADD     R13,#01H
  943  0461   F6 01 7E           CALL    DELAY_1ms
  944  0464   8D 04 6B           JP      BUTTON_PRESS_END
  945  0467              BUTTON_PRESS_RELEASED:
  946  0467   B0 CD              CLR     R13
  947  0469   B0 CE              CLR     R14
  948  046B              BUTTON_PRESS_END:
  949  046B   AF                 RET
  950                    
  951  046C              TASK_P00:
  952  046C   A6 CE 01           CP      R14,#001H
  953  046F   ED 04 DE           JP      NE,TASK_P00_END
  954  0472   A6 F2 00           CP      PWM0DATA,#00H
  955  0475   ED 04 AA           JP      NE,TASK_P00_LED_OFF
  956  0478              TASK_P00_LED_ON:
  957  0478   0C 01              LD      R0,#001H
  958  047A   1C 00              LD      R1,#00H
  959  047C   F6 02 28           CALL    PWM0
  960  047F   0C 02              LD      R0,#02H
  961  0481   F6 02 10           CALL    UART_TX
  962  0484   0C 00              LD      R0,#00H
  963  0486   F6 02 10           CALL    UART_TX
  964  0489   0C 04              LD      R0,#04H
  965  048B   F6 02 10           CALL    UART_TX
  966  048E   0C 4F              LD      R0,#4FH
  967  0490   F6 02 10           CALL    UART_TX
  968  0493   0C 4E              LD      R0,#4EH
  969  0495   F6 02 10           CALL    UART_TX
  970  0498   0C 20              LD      R0,#20H
  971  049A   F6 02 10           CALL    UART_TX    
  972  049D   0C 31              LD      R0,#31H
  973  049F   F6 02 10           CALL    UART_TX 
  974  04A2   0C 03              LD      R0,#03H
  975  04A4   F6 02 10           CALL    UART_TX
  976  04A7   8D 04 DE           JP      TASK_P00_END
  977  04AA              TASK_P00_LED_OFF:  
  978  04AA   0C 00              LD      R0,#00H
  979  04AC   1C 00              LD      R1,#00H
  980  04AE   F6 02 28           CALL    PWM0
  981  04B1   0C 02              LD      R0,#02H
  982  04B3   F6 02 10           CALL    UART_TX
  983  04B6   0C 00              LD      R0,#00H
  984  04B8   F6 02 10           CALL    UART_TX
  985  04BB   0C 05              LD      R0,#05H
  986  04BD   F6 02 10           CALL    UART_TX
  987  04C0   0C 4F              LD      R0,#4FH
  988  04C2   F6 02 10           CALL    UART_TX
  989  04C5   0C 46              LD      R0,#46H
  990  04C7   F6 02 10           CALL    UART_TX
  991  04CA   0C 46              LD      R0,#46H
  992  04CC   F6 02 10           CALL    UART_TX
  993  04CF   0C 20              LD      R0,#20H
  994  04D1   F6 02 10           CALL    UART_TX    
  995  04D4   0C 31              LD      R0,#31H
  996  04D6   F6 02 10           CALL    UART_TX 
  997  04D9   0C 03              LD      R0,#03H
  998  04DB   F6 02 10           CALL    UART_TX      
  999  04DE              TASK_P00_END:        
 1000  04DE   AF                 RET                                                                                                                                                                                                                                    
 1001                    ;;=======================================================================
 1002                    ;;==      INTERRUPT SERVICE ROUTINE                                    ==
 1003                    ;;==                                                                   ==
 1004                    ;;==                                                                   == 
 1005                    ;;=======================================================================                                                                                
 1006                           ;;----------------------------------------
 1007                           ;;     external interrupt 0
 1008                           ;;----------------------------------------
 1009  04DF              EX_INT0:
 1010  04DF   56 E8 FE          AND     P0PND, #11111110B                       ;clear pending bit
 1011  04E2   8D 05 61          JP      INT_ISR_END        
 1012                           ;;----------------------------------------
 1013                           ;;     external interrupt 1
 1014                           ;;----------------------------------------
 1015  04E5              EX_INT1:
 1016  04E5   56 E8 FB           AND     P0PND, #11111011B                       ;clear pending bit
 1017  04E8   8D 05 61           JP      INT_ISR_END
 1018                           ;;----------------------------------------
 1019                           ;;     external interrupt 2
 1020                           ;;----------------------------------------
 1021  04EB              EX_INT2:
 1022                            ;XOR     P0,#00100000B                           ;toggle P0.5 
 1023  04EB   56 E8 EF           AND     P0PND, #11101111B                       ;clear pending bit
 1024  04EE   8D 05 61           JP      INT_ISR_END
 1025                            ;;----------------------------------------
 1026                           ;;     external interrupt 3
 1027                           ;;----------------------------------------
 1028  04F1              EX_INT3:
 1029                            ;XOR     P0,#00010000B                           ;toggle P0.4 
 1030  04F1   56 E8 BF           AND     P0PND, #10111111B                       ;clear pending bit
 1031  04F4   8D 05 61           JP      INT_ISR_END
 1032                            ;;----------------------------------------
 1033                           ;;     external interrupt 4
 1034                           ;;----------------------------------------
 1035  04F7              EX_INT4:
 1036                            ;XOR     P0,#10000000B                           ;toggle P0.7 
 1037  04F7   56 EF FE           AND     P3PND, #11111110B                       ;clear pending bit
 1038  04FA   8D 05 61           JP      INT_ISR_END
 1039                            ;;----------------------------------------
 1040                           ;;     external interrupt 5
 1041                           ;;----------------------------------------
 1042  04FD              EX_INT5:
 1043                            ;XOR     P0,#01000000B                           ;toggle P0.6 
 1044  04FD   56 EF FB           AND     P3PND, #11111011B                       ;clear pending bit
 1045  0500   8D 05 61           JP      INT_ISR_END
 1046                            ;;----------------------------------------
 1047                           ;;     external interrupt 6
 1048                           ;;----------------------------------------
 1049  0503              EX_INT6:
 1050                            ;XOR     P0,#00100000B                           ;toggle P0.5 
 1051  0503   56 EF EF           AND     P3PND, #11101111B                       ;clear pending bit
 1052  0506   8D 05 61           JP      INT_ISR_END
 1053                            ;;----------------------------------------
 1054                           ;;     external interrupt 7
 1055                           ;;----------------------------------------
 1056  0509              EX_INT7:
 1057                            ;XOR     P0,#00010000B                           ;toggle P0.4 
 1058  0509   56 EF BF           AND     P3PND, #10111111B                       ;clear pending bit
 1059  050C   8D 05 61           JP      INT_ISR_END
 1060                            
 1061                           ;;----------------------------------------
 1062                           ;;     Timer0/A match interrupt
 1063                           ;;----------------------------------------  
 1064  050F              T0_A_MC_INT:
 1065                            ;XOR     P0,#10000000B                           ;toggle P0.7
 1066  050F   56 D2 FE           AND     TACON,#11111110B                        ;clear pending bit
 1067  0512   8D 05 61           JP      INT_ISR_END 
 1068                           ;;----------------------------------------
 1069                           ;;     TimerB match interrupt
 1070                           ;;---------------------------------------- 
 1071  0515              TB_MC_INT:
 1072                            ;XOR     P0,#01000000B                           ;toggle P0.6
 1073  0515   56 EE FE           AND     TBCON,#11111110B                        ;clear pending bit
 1074  0518   8D 05 61           JP      INT_ISR_END
 1075                           ;;----------------------------------------
 1076                           ;;     PWM1 Overflow interrupt 
 1077                           ;;----------------------------------------
 1078  051B              PWM1_OVF_INT:
 1079                            ;XOR     P0,#01000000B                           ;toggle P0.6
 1080  051B   5F                 SB1
 1081  051C   56 E8 F6           AND     PWM1CON,#11110110B                       ;clear pending bit
 1082  051F   4F                 SB0
 1083  0520   8D 05 61           JP      INT_ISR_END
 1084                           ;;----------------------------------------
 1085                           ;;     PWM0 Overflow interrupt 
 1086                           ;;----------------------------------------
 1087  0523              PWM0_OVF_INT:
 1088                            ;XOR     P0,#00100000B                           ;toggle P0.5
 1089  0523   56 F3 F6           AND     PWM0CON,#11110110B                       ;clear pending bit
 1090  0526   8D 05 61           JP      INT_ISR_END
 1091                           ;;----------------------------------------
 1092                           ;;     Timer1 match interrupt
 1093                           ;;----------------------------------------  
 1094  0529              TIMER1_MC_INT:
 1095                            ;XOR     P0,#00100000B                            ;toggle P0.5
 1096  0529   5F                 SB1
 1097  052A   56 E4 FE           AND     T1CON,#11111110B                         ;clear pending bit
 1098  052D   4F                 SB0
 1099  052E   8D 05 61           JP      INT_ISR_END 
 1100                           ;;----------------------------------------
 1101                           ;;     Timer1 Overflow interrupt
 1102                           ;;----------------------------------------  
 1103  0531              TIMER1_OVF_INT:
 1104                            ;XOR     P0,#00010000B                            ;toggle P0.4
 1105  0531   5F                 SB1
 1106  0532   56 E4 FB           AND     T1CON,#11111011B                         ;clear pending bit
 1107  0535   4F                 SB0
 1108  0536   8D 05 61           JP      INT_ISR_END
 1109                           ;;----------------------------------------
 1110                           ;;     Low voltage detector interrupt
 1111                           ;;---------------------------------------- 
 1112  0539              LVD_INT:
 1113                            ;SB0
 1114                            ;AND      P0,#11110111B                            ;light P0.3
 1115  0539   5F                 SB1
 1116  053A   56 F4 EF           AND     LVDCON, #11101111B                       ;disable interrupt
 1117  053D   4F                 SB0
 1118  053E   8D 05 61           JP      INT_ISR_END              
 1119                           ;;----------------------------------------
 1120                           ;;     UART interrupt
 1121                           ;;---------------------------------------- 
 1122  0541              UART_TRS_INT:
 1123  0541   5F                 SB1
 1124  0542   56 00 FE           AND     uart_status,#11111110B
 1125  0545   56 F6 FE           AND     UARTPND, #11111110B                      ;clear pending bit
 1126  0548   4F                 SB0
 1127  0549   8D 05 61           JP      INT_ISR_END
 1128  054C              UART_RV_INT:
 1129  054C   5F                 SB1
 1130  054D   F5 F8 CF           LD      @R15,UDATA
 1131  0550   FE                 INC     R15
 1132  0551   56 F6 FD           AND     UARTPND, #11111101B                      ;clear pending bit
 1133  0554   4F                 SB0
 1134  0555   8D 05 61           JP      INT_ISR_END
 1135                           ;;----------------------------------------
 1136                           ;;     IIC interrupt
 1137                           ;;---------------------------------------- 
 1138  0558              IIC_INT:
 1139  0558   8D 05 61           JP      INT_ISR_END
 1140                           ;;----------------------------------------
 1141                           ;;     Watchdog  interrupt
 1142                           ;;---------------------------------------- 
 1143  055B              WDT_INT:
 1144                            ;XOR     P3,#00000001B                           ;toggle P3.0
 1145                            ;AND      WDTCON, #10111111B                    ;disable reset, clear counter
 1146  055B   46 F6 10           OR      WDTCON, #00010000B                      ;clear counter.      
 1147  055E   8D 05 61           JP      INT_ISR_END       
 1148                    
 1149                    
 1150                    
 1151                           ;;----------------------------------------
 1152                           ;;     interrupt service end
 1153                           ;;----------------------------------------        
 1154  0561              INT_ISR_END:                
 1155  0561   BF                IRET
 1156                           
 1157  0562              .END                                                          


Total 1151 Lines Assembled - 0 Errors, 0 Warnings
Total code size 0x48C


