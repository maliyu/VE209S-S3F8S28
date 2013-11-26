Tue Nov 26 11:53:14 2013
                              
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
   37         00 32      VE209S_NUMBER   EQU     032H
   38                    
   39                    ;;=======================================================================
   40                    ;;==                                                                   ==
   41                    ;;==                RAM ASSIGNMENT                                     ==
   42                    ;;==                                                                   == 
   43                    ;;=======================================================================
   44         00 10      uart_status     EQU     10H
   45         00 11      uart_rx_data    EQU     11H     ; reserve 50 bytes for uart rx data
   46         00 43      pwm0_value      EQU     43H     ; store current PWM0 value
   47                    
   48                    
   49  0000                      .ORG    0000H
   50                    ;;=======================================================================
   51                    ;;==                                                                   ==
   52                    ;;==                SMART OPTION Setting  ROUTINE                      ==
   53                    ;;==                                                                   == 
   54                    ;;=======================================================================
   55  003C                     .ORG  003CH
   56  003C   FF                .DB   0FFH
   57  003D   FF                .DB   0FFH
   58  003E   FF                .DB   11111111B          ;@3EH : ISP options
   59                                                                 ; bit7: Reset vector address change enable/disable
   60                                                                 ;    0-change address   
   61                                                                 ;    1-normal: 100H
   62                                                                 ; bit6~5: reset vector address
   63                                                                 ;      @00B---200H         
   64                                                                 ;      @01B---300H
   65                                                                 ;      @10B---500H
   66                                                                 ;      @11B---900H
   67                                                                 ; bit4-3: not used
   68                                                                 ; bit2: ISP protection enable/disable
   69                                                                 ;    1-disable  
   70                                                                 ;    0-enable
   71                                                                 ; bit1-0: ISP protection size
   72                                                                 ;      @00B---256B         
   73                                                                 ;      @01B---512B
   74                                                                 ;      @10B---1024B
   75                                                                 ;      @11B---2048B        
   76  003F   8F                .DB   10001111B          ;@3FH :LVR, level, P1.2; OSC;
   77                                                                 ; bit 7: LVR Enable/disable
   78                                                                 ;    0-disable  
   79                                                                 ;    1-enable
   80                                                                 ; bit 6-5: LVR level
   81                                                                 ;      @00B---1.9V         
   82                                                                 ;      @01B---2.3V
   83                                                                 ;      @10B---3.0V
   84                                                                 ;      @11B---3.9V
   85                                                                 ; bit 4: P1.2/RESET pin selection
   86                                                                 ;    0-P1.2 pin enable  
   87                                                                 ;    1-RESET Pin enable
   88                                                                 ; bit 3-0: Oscillator selection bit
   89                                                                 ;      @0100B---External LG OSC         
   90                                                                 ;      @1100B---External HG OSC
   91                                                                 ;      @1010B---internal RC(1 M)
   92                                                                 ;      @1111B---internal RC(8 M)
   93                                                                 ;      @1000B---internal RC(0.5 M)
   94                                                                 ;      @1001B---internal RC(2 M)
   95                                                                 ;      @1011B---internal RC(4 M)
   96                    ;;=======================================================================
   97                    ;;==                                                                   ==
   98                    ;;==            INTERRUPT VECTOR                                       ==
   99                    ;;==                                                                   == 
  100                    ;;=======================================================================
  101  00D8   05 6E             .VECTOR  0D8H, EX_INT7
  102  00DA   05 68             .VECTOR  0DAH, EX_INT6
  103  00DC   05 62             .VECTOR  0DCH, EX_INT5
  104  00DE   05 5C             .VECTOR  0DEH, EX_INT4
  105  00E0   05 C5             .VECTOR  0E0H, IIC_INT
  106  00E2   05 B1             .VECTOR  0E2H, UART_RV_INT
  107  00E4   05 A6             .VECTOR  0E4H, UART_TRS_INT
  108  00E6   05 C8             .VECTOR  0E6H, WDT_INT
  109  00E8   05 9E             .VECTOR  0E8H, LVD_INT
  110  00EA   05 96             .VECTOR  0EAH, TIMER1_OVF_INT
  111  00EC   05 8E             .VECTOR  0ECH, TIMER1_MC_INT
  112  00F0   05 80             .VECTOR  0F0H, PWM1_OVF_INT
  113  00F2   05 88             .VECTOR  0F2H, PWM0_OVF_INT
  114  00F4   05 7A             .VECTOR  0F4H, TB_MC_INT
  115  00F6   05 74             .VECTOR  0F6H, T0_A_MC_INT
  116  00F8   05 56             .VECTOR  0F8H, EX_INT3
  117  00FA   05 50             .VECTOR  0FAH, EX_INT2
  118  00FC   05 4A             .VECTOR  0FCH, EX_INT1
  119  00FE   05 44             .VECTOR  0FEH, EX_INT0
  120                    ;;=======================================================================
  121                    ;;==                                                                   ==
  122                    ;;==            RESET and Initialization code                          ==
  123                    ;;==                                                                   == 
  124                    ;;=======================================================================
  125                    
  126  0100                     .ORG    0100H
  127  0100              RESET:
  128  0100   8F                 DI
  129  0101   E6 D3 A3           LD      BTCON,#10100011B        ; bit 7-4: Watchdog timer enable bits
  130                                                            ; 1010B = Disable watchdog function
  131                                                            ; Other value = Enable watchdog function
  132                                                            ; bit 3-2: Basic timer input clock selection bits
  133                                                            ; 00 = fosc/4096
  134                                                            ; 01 = fosc/1024
  135                                                            ; 10 = fosc/128
  136                                                            ; 11 = Invalid selection 
  137                                                            ; bit 1: Basic timer counter clear bits
  138                                                            ; 0 = No effect
  139                                                            ; 1 = Clear basic timer counter
  140                                                            ; bit 0: Divider clear bit for basic timer and timer 0
  141                                                            ; 0 = No effect
  142                                                            ; 1 = Clear both dividers
  143  0104   E6 D4 18           LD      CLKCON,#00011000B       ; bit 7: Oscillator IRQ wake-up enable bit
  144                                                            ; 0 = Enable IRQ for main system oscillator wake-up function in power mode.
  145                                                            ; 1 = Disable IRQ for main system oscillator wake-up function in power down mode.
  146                                                            ; bit 6-5: not used
  147                                                            ; bit 4-3: Divide-by selection bits for CPU clock frequency
  148                                                            ; 00 = fosc/16
  149                                                            ; 01 = fosc/8
  150                                                            ; 10 = fosc/2
  151                                                            ; 11 = fosc (non-divided)
  152                                                                            ; bit 2-0: not used
  153  0107   E6 F5 00           LD      ROSCCON,#00000000B      ; 
  154  010A   E6 D9 FF           LD      SPL,#0FFH               ; SP: FFH (Normally, the SP is set to FFH by the initialization routine) 
  155  010D   E6 DA 00           LD      IPH,#00H
  156  0110   E6 DB 00           LD      IPL,#00H
  157  0113   E6 DD FF           LD      IMR,#11111111B          ; Interrupt level enable bit
  158                                                            ; bit 7-0 <-> IRQ7-0
  159                                                            ; 0 = Disable (mask) interrupt level
  160                                                            ; 1 = Enable (un-mask) interrupt level
  161                                                            
  162                                                            ; IRQ0: External interrupt 0/1/2/3
  163                                                            ; IRQ1: Timer 0/A match interrupt/Timer B match interrupt
  164                                                            ; IRQ2: PWM0 overflow interrupt/PWM1 overflow interrupt
  165                                                            ; IRQ3: Timer 1 match/capture interrupt/Timer 1 overflow interrupt
  166                                                            ; IRQ4: Watchdog interrupt
  167                                                            ; IRQ5: UART transmit interrupt/UART Receive interrupt
  168                                                            ; IRQ6: IIC transmit / receive interrupt
  169                                                            ; IRQ7: External interrupt 4/5/6/7
  170  0116   E6 FF CD           LD      IPR,#11001101B          ; Interrupt Priority Register
  171                                                            ; bit7/4/1 -> Group priority
  172                                                            ; 0 0 0 = Undefined
  173                                                            ; 0 0 1 = B > C > A
  174                                                            ; 0 1 0 = A > B > C
  175                                                            ; 0 1 1 = B > A > C
  176                                                            ; 1 0 0 = C > A > B
  177                                                            ; 1 0 1 = C > B > A
  178                                                            ; 1 1 0 = A > C > B
  179                                                            ; 1 1 1 = Undefined
  180                                                            ; bit 6 -> Subgroup C
  181                                                            ; 0 = IRQ6 > IRQ7
  182                                                            ; 1 = IRQ7 > IRQ6
  183                                                            ; bit 5 -> Group C 
  184                                                            ; 0 = IRQ5 > (IRQ6, IRQ7)
  185                                                            ; 1 = (IRQ6, IRQ7) > IRQ5
  186                                                            ; bit 3 -> Subgroup B
  187                                                            ; 0 = IRQ3 > IRQ4
  188                                                            ; 1 = IRQ4 > IRQ3
  189                                                            ; bit 2 -> Group B
  190                                                            ; 0 = IRQ2 > (IRQ3, IRQ4)
  191                                                            ; 1 = (IRQ3, IRQ4) > IRQ2
  192                                                            ; bit 0 -> Group A
  193                                                            ; 0 = IRQ0 > IRQ1
  194                                                            ; 1 = IRQ1 > IRQ0
  195                    
  196  0119   E6 E6 9A           LD      P0CONH,#10011010B       ; Port 0 Control Register (High Byte)
  197                                                            ; [.7-.6] Port, P0.7/ADC7 Configuration Bits
  198                                                            ; 0 x = Schmitt trigger input
  199                                                            ; 1 0 = Push-pull output
  200                                                            ; 1 1 = A/D converter input (ADC7); schmitt trigger input off
  201                                                            ; [.5-.4] Port 0, P0.6/ADC6/PWM0 Configuration Bits
  202                                                            ; 0 0 = Schmitt trigger input
  203                                                            ; 0 1 = Alternative function: PWM0 output
  204                                                            ; 1 0 = Push-pull output
  205                                                            ; 1 1 = A/D converter input (ADC6); schmitt trigger input off
  206                                                            ; [.3-.2] Port 0, P0.5/ADC5/PWM1 Configuration Bits
  207                                                            ; 0 0 = Schmitt trigger input
  208                                                            ; 0 1 = Alternative function: PWM1 output
  209                                                            ; 1 0 = Push-pull output
  210                                                            ; 1 1 = A/D converter input (ADC5); schmitt trigger input off
  211                                                            ; [.1-.0] Port 0, P0.4/ADC4 Configuration Bits
  212                                                            ; 0 x = Schmitt trigger input
  213                                                            ; 1 0 = Push-pull output
  214                                                            ; 1 1 = A/D converter input (ADC4); schmitt trigger input off
  215  011C   E6 E7 A9           LD     P0CONL,#10101001B        ; Port 0 Control Register (Low Byte)
  216                                                            ; [.7-.6] Port 0, P0.3/ADC3/INT3 Configuration Bits
  217                                                            ; 0 0 = Schmitt trigger input/falling edge interrupt input
  218                                                            ; 0 1 = Alternative function: SDA
  219                                                            ; 1 0 = Push-pull output
  220                                                            ; 1 1 = A/D converter input (ADC3); Schmitt trigger input off
  221                                                            ; [.5-.4] Port 0, P0.2/ADC2/INT2 Configuration Bits
  222                                                            ; 0 0 = Schmitt trigger input/falling edge interrupt input
  223                                                            ; 0 1 = Alternative function: SCK
  224                                                            ; 1 0 = Push-pull output
  225                                                            ; 1 1 = A/D converter input (ADC2); Schmitt trigger input off
  226                                                            ; [.3-.2] Port 0, P0.1/ADC1/INT1 Configuration Bits
  227                                                            ; 0 x = Schmitt trigger input/falling edge interrupt input
  228                                                            ; 1 0 = Push-pull output
  229                                                            ; 1 1 = A/D converter input (ADC1); Schmitt trigger input off
  230                                                            ; [.1-.0] Port 0, P0.0/ADC0/INT0 Configuration Bits
  231                                                            ; 0 x = Schmitt trigger input/falling edge interrupt input
  232                                                            ; 1 0 = Push-pull output
  233                                                            ; 1 1 = A/D converter input (ADC0); Schmitt trigger input off                                    
  234  011F   E6 E8 00            LD     P0PND,#00000000B        ; Port 0 Interrupt Pending Register
  235  0122   E6 E5 F1            LD     P0PUR,#11110001B        ; Port 0 Pull-up Resistor Enable Register
  236  0125   E6 E9 1A            LD     P1CON,#00011010B        ; Port 1 Control Register
  237                                                            ; [.7] Port 1.1 N-Channel Open-Drain Enable Bit
  238                                                            ; 0 = Configure P1.1 as a push-pull output
  239                                                            ; 1 = Configure P1.1 as a n-channel open-drain output
  240                                                            ; [.6] Port 1.0 N-Channel Open-Drain Enable Bit
  241                                                            ; 0 = Configure P1.0 as a push-pull output
  242                                                            ; 1 = Configure P1.0 as a N-channel open-drain output
  243                                                            ; [.5] Not used for S3F8S28/F8S24
  244                                                            ; [.4] Port 1.2 Configuration Bit
  245                                                            ; 0 = Schmitt trigger input;
  246                                                            ; 1 = Open-drain output
  247                                                            ; [.3-.2] Port 1, P1.1 Configuration Bits
  248                                                            ; 0 0 = Schmitt trigger input;
  249                                                            ; 0 1 = Schmitt trigger input; pull-up enable
  250                                                            ; 1 0 = Push-pull output
  251                                                            ; 1 1 = Schmitt trigger input; pull-down enable
  252                                                            ; [.1-.0] Port 1, P1.0 Configuration Bits
  253                                                            ; 0 0 = Schmitt trigger input;
  254                                                            ; 0 1 = Schmitt trigger input; pull-up enable
  255                                                            ; 1 0 = Push-pull output
  256                                                            ; 1 1 = Schmitt trigger input; pull-down enable
  257  0128   E6 EA 4A            LD     P2CONH,#01001010B       ; Port 2 Control Register (High Byte)
  258                                                            ; [.7] Not used in S3F8S28/F8S24
  259                                                            ; [.6-.4] Port 2, P2.6/ADC8/CLO Configuration Bits
  260                                                            ; 0 0 x = Schmitt trigger input
  261                                                            ; 0 1 x = ADC input
  262                                                            ; 1 0 0 = Push-pull output
  263                                                            ; 1 0 1 = Open-drain output; pull-up enable
  264                                                            ; 1 1 0 = Open-drain output
  265                                                            ; 1 1 1 = Alternative function; CLO output
  266                                                            ; [.3-.2] Port 2, P2.5/ADC9 Configuration Bits
  267                                                            ; 0 0 = Schmitt trigger input
  268                                                            ; 0 1 = Alternative function: ADC Input
  269                                                            ; 1 0 = Push-pull output
  270                                                            ; 1 1 = Invalid
  271                                                            ; [ 1-.0] Port 2, P2.4/ADC10 Configuration Bits
  272                                                            ; 0 0 = Schmitt trigger input
  273                                                            ; 0 1 = Alternative function: ADC Input
  274                                                            ; 1 0 = Push-pull output
  275                                                            ; 1 1 = Invalid
  276  012B   E6 EB 4A            LD     P2CONL,#01001010B       ; Port 2 Control Register (Low Byte)
  277                                                            ; [.7-.6] Port 2, P2.3/TxD Configuration Bits
  278                                                            ; 0 0 = Schmitt trigger input
  279                                                            ; 0 1 = Alternative function: TxD output
  280                                                            ; 1 0 = Push-pull output
  281                                                            ; 1 1 = Open-drain output
  282                                                            ; [.5-.4] Port 2, P2.2/T1CAP/RxD Configuration Bits
  283                                                            ; 0 0 = Schmitt trigger input; T1 Capture input; RxD input;
  284                                                            ; 0 1 = Alternative function: RxD output
  285                                                            ; 1 0 = Push-pull output
  286                                                            ; 1 1 = Open-drain output
  287                                                            ; [.3-.2] Port 2, P2.1/T1OUT Configuration Bits
  288                                                            ; 0 0 = Schmitt trigger input
  289                                                            ; 0 1 = Alternative function: T1 match output
  290                                                            ; 1 0 = Push-pull output
  291                                                            ; 1 1 = Open-drain output
  292                                                            ; [.1-.0] Port 2, P2.0/T0OUT Configuration Bits
  293                                                            ; 0 0 = Schmitt trigger input
  294                                                            ; 0 1 = Alternative function: T0 match output
  295                                                            ; 1 0 = Push-pull output
  296                                                            ; 1 1 = Open-drain output
  297  012E   E6 E4 00            LD     P2PUR,#00000000B        ; Port 2 Pull-up Resistor Enable Register
  298                             ;LD     P3CON,#00000000B        ; Port 3 Control Register
  299                                                            ; [.7-.6] Port 3, P3.3/INT7 Configuration Bits
  300                                                            ; 0 0 = Schmitt trigger input / external falling edge interrupt input
  301                                                            ; 0 1 = Schmitt trigger input with pull-up / external falling edge interrupt input
  302                                                            ; 1 x = Push-pull output
  303                                                            ; [.5-.4] Port 3, P3.2/INT6 Configuration Bits
  304                                                            ; 0 0 = Schmitt trigger input / external falling edge interrupt input
  305                                                            ; 0 1 = Schmitt trigger input with pull-up / external falling edge interrupt input
  306                                                            ; 1 x = Push-pull output
  307                                                            ; [.3-.2] Port 3, P3.1/ADC12/INT5 Configuration Bits
  308                                                            ; 0 0 = Schmitt trigger input / external falling edge interrupt input
  309                                                            ; 0 1 = Schmitt trigger input with pull-up / external falling edge interrupt input
  310                                                            ; 1 0 = Push-pull output
  311                                                            ; 1 1 = Alternative function: ADC Input
  312                                                            ; [.1-.0] Port 3, P3.0/ADC11/INT4 Configuration Bits
  313                                                            ; 0 0 = Schmitt trigger input / external falling edge interrupt input
  314                                                            ; 0 1 = Schmitt trigger input with pull-up / external falling edge interrupt input
  315                                                            ; 1 0 = Push-pull output
  316                                                            ; 1 1 = Alternative function: ADC Input
  317                            ;LD      P3PND, #000000000B      ; Port 3 Interrupt Pending Register
  318                                                            ; [.7] Port 3.3/ADC12/INT7, Interrupt Enable Bit
  319                                                            ; 0 = INT7 falling edge interrupt disable
  320                                                            ; 1 = INT7 falling edge interrupt enable
  321                                                            ; [.6] Port 3.3/ADC12/INT7 Interrupt Pending Bit
  322                                                            ; 0 = No interrupt pending (when read)
  323                                                            ; 0 = Pending bit clear (when write)
  324                                                            ; 1 = Interrupt is pending (when read)
  325                                                            ; 1 = No effect (when write)
  326                                                            ; [.5] Port 3.2/ADC11/INT6, Interrupt Enable Bit
  327                                                            ; 0 = INT6 falling edge interrupt disable
  328                                                            ; 1 = INT6 falling edge interrupt enable
  329                                                            ; [.4] Port 3.2/ADC11/INT6, Interrupt Pending Bit
  330                                                            ; 0 = No interrupt pending (when read)
  331                                                            ; 0 = Pending bit clear (when write)
  332                                                            ; 1 = Interrupt is pending (when read)
  333                                                            ; 1 = No effect (when write)
  334                                                            ; [.3] Port 3.1/ADC10/INT5, Interrupt Enable Bit
  335                                                            ; 0 = INT5 falling edge interrupt disable
  336                                                            ; 1 = INT5 falling edge interrupt enable
  337                                                            ; [.2] Port 3.1/ADC10/INT5, Interrupt Pending Bit
  338                                                            ; 0 = No interrupt pending (when read)
  339                                                            ; 0 = Pending bit clear (when write)
  340                                                            ; 1 = Interrupt is pending (when read)
  341                                                            ; 1 = No effect (when write)
  342                                                            ; [.1] Port 3.0/ADC9/INT4, Interrupt Enable Bit
  343                                                            ; 0 = INT4 falling edge interrupt disable
  344                                                            ; 1 = INT4 falling edge interrupt enable
  345                                                            ; [.0] Port 3.0/ADC9/INT4, Interrupt Pending Bit
  346                                                            ; 0 = No interrupt pending (when read)
  347                                                            ; 0 = Pending bit clear (when write)
  348                                                            ; 1 = Interrupt is pending (when read)
  349                                                            ; 1 = No effect (when write)
  350                                                                   
  351  0131   5F                 SB1
  352  0132   E6 F5 53           LD      UARTCON,#01010011B      ; UART Control Register
  353                                                            ; bit 7-6: Operating mode and baud rate selection bits
  354                                                            ; 0 0 -> mode 0 Shift register fxx/(16 x (BRDATA +1))
  355                                                            ; 0 1 -> mode 1 8-bit UART fxx/(16 x (BRDATA +1))
  356                                                            ; 1 0 -> mode 2 9-bit UART fxx/16
  357                                                            ; 1 1 -> 9-bit UART fxx/(16 x (BRDATA +1))
  358                                                            ; bit 5: Multiprocessor communication enable bit (for modes 2 and 3 only)
  359                                                            ; 0 = Disable
  360                                                            ; 1 = Enable
  361                                                            ; bit 4: Serial data receive enable bit
  362                                                            ; 0 = Disable
  363                                                            ; 1 = Enable
  364                                                            ; bit 3: Location of the 9th data bit to be transmitted in UART mode 2 or 3 ("0" or "1")
  365                                                            ; bit 2: Location of the 9th data bit that was received in UART mode 2 or 3 ("0" or "1")
  366                                                            ; bit 1: Received interrupt enable bit
  367                                                            ; 0 = Disable
  368                                                            ; 1 = Enable
  369                                                            ; bit 0: Transmit interrupt enable bit
  370                                                            ; 0 = Disable
  371                                                            ; 1 = Enable
  372  0135   E6 F6 00           LD      UARTPND,#00000000B      ; UART Pending Register
  373                                                            ; bit 7-2: Not used
  374                                                            ; bit 1: UART receive interrupt pending flag
  375                                                            ; 0 = Not pending
  376                                                            ; 0 = Clear pending bit (when write)
  377                                                            ; 1 = Interrupt pending
  378                                                            ; bit 0: UART transmit interrupt pending flag
  379                                                            ; 0 = Not pending
  380                                                            ; 0 = Clear pending bit (when write)
  381                                                            ; 1 = Interrupt pending
  382  0138   E6 F7 33           LD      BRDATA,#33H             ; UART Baud Rate Data Register
  383                                                            ; Mode 0 baud rate = fxx/(16 x (8-bit BRDATA + 1))
  384                                                            ; Mode 1 baud rate = fxx/(16 x (8-bit BRDATA + 1))
  385                                                            ; Mode 2 baud rate = fxx/16
  386                                                            ; Mode 3 baud rate = fxx/(16 x (8-bit BRDATA + 1))
  387  013B   4F                 SB0
  388                            
  389  013C   E6 F3 10           LD      PWM0CON,#00010000B      ; PWM Control Registers
  390                                                            ; bit 7-6: PWM input clock selection bits
  391                                                            ; 00 = fosc/64
  392                                                            ; 01 = fosc/8
  393                                                            ; 10 = fosc/2
  394                                                            ; 11 = fosc/1
  395                                                            ; bit 5: Not Used
  396                                                            ; bit 4: PWMDATA reload interval selection bit
  397                                                            ; 0 = Reload from extension up counter overflow
  398                                                            ; 1 = Reload from base up counter overflow
  399                                                            ; bit 3: PWM counter clear bit
  400                                                            ; 0 = No effect
  401                                                            ; 1 = Clear the PWM counter (When write)
  402                                                            ; bit 2: PWM counter enable bit
  403                                                            ; 0 = Stop counter
  404                                                            ; 1 = Start (resume countering)
  405                                                            ; bit 1: PWM counter interrupt enable bit
  406                                                            ; 0 = Disable PWM OVF interrupt
  407                                                            ; 1 = Enable PWM OVF interrupt
  408                                                            ; bit 0: PWM extension counter OVF Interrupt pending bit
  409                                                            ; 0 = No interrupt pending
  410                                                            ; 0 = Clear pending condition (when write)
  411                                                            ; 1 = Interrupt is pending
  412  013F   E6 F1 00           LD      PWM0EX,#00000000B       ; PWM Extension Registers
  413                                                            ; bit 7-2: PWM Extension bits
  414                                                            ; bit 7-6: For 6 + 2 resolution
  415                                                            ; bit 7-2: For 6 + 6 and 8 + 6 resolutions
  416                                                            ; bit 1-0: PWM resolution selection bits
  417                                                            ; x0 = 12-bit PWM: 6 + 6 resolution
  418                                                            ; 01 = 8-bit PWM: 6 + 2 resolution
  419                                                            ; 11 = 14-bit PWM: 8 + 6 resolution
  420  0142   E6 F2 00           LD      PWM0DATA,#00H
  421                            
  422  0145   B0 10              CLR     uart_status
  423                            
  424  0147   B0 43              CLR     pwm0_value
  425                    
  426  0149   F6 01 F7           CALL    UART_RX_DATA_INIT
  427                            
  428  014C   B0 C0              CLR     R0
  429  014E   B0 C1              CLR     R1
  430  0150   B0 C2              CLR     R2
  431  0152   B0 C3              CLR     R3
  432  0154   B0 C4              CLR     R4
  433  0156   B0 C5              CLR     R5
  434  0158   B0 C6              CLR     R6
  435  015A   B0 C7              CLR     R7
  436  015C   B0 C8              CLR     R8
  437  015E   B0 C9              CLR     R9
  438  0160   B0 CA              CLR     R10
  439  0162   B0 CB              CLR     R11
  440  0164   B0 CC              CLR     R12
  441  0166   B0 CD              CLR     R13
  442  0168   B0 CE              CLR     R14
  443  016A   B0 CF              CLR     R15
  444                            
  445  016C   FC 11              LD      R15,#uart_rx_data
  446                            
  447  016E   9F                 EI
  448                    
  449                    ;;=======================================================================
  450                    ;;==      Main function                                                ==
  451                    ;;==                                                                   ==
  452                    ;;==                                                                   == 
  453                    ;;=======================================================================
  454  016F              MAIN::
  455  016F   46 D3 02           OR      BTCON,#02H              ; Enable watchdog function
  456                                                            ; Basic counter (BTCNT) clear
  457                    
  458  0172   F6 02 8E           CALL    TASK_RX 
  459                            
  460  0175   F6 04 30           CALL    BUTTON_PRESS
  461                            
  462                            ;CALL    TASK_P00
  463                            
  464                            ;CALL    DELAY_10s
  465                                                                                        
  466  0178   8D 01 6F           JP      MAIN                                
  467                    
  468                    ;;=======================================================================
  469                    ;;==      SUBROUTINEs                                                  ==
  470                    ;;==                                                                   ==
  471                    ;;==                                                                   == 
  472                    ;;=======================================================================
  473  017B              DELAY_1ms:
  474  017B   70 C1              PUSH    R1
  475  017D   1C A6              LD      R1,#0A6H
  476  017F              DELAY_LOOP_1ms:
  477  017F   FF                 NOP
  478  0180   FF                 NOP
  479  0181   FF                 NOP
  480  0182   FF                 NOP
  481  0183   FF                 NOP
  482  0184   FF                 NOP
  483  0185   FF                 NOP
  484  0186   FF                 NOP
  485  0187   FF                 NOP
  486  0188   FF                 NOP     
  487  0189   1A F4              DJNZ    R1,DELAY_LOOP_1ms
  488  018B   50 C1              POP     R1
  489                            
  490  018D   AF                 RET      
  491                    
  492  018E              DELAY_10ms:
  493  018E   70 C1              PUSH    R1
  494  0190   70 C2              PUSH    R2
  495  0192   1C 14              LD      R1,#014H
  496  0194              DELAY_LOOP_10ms_R1:
  497  0194   2C 53              LD      R2,#053H
  498  0196              DELAY_LOOP_10ms_R2:
  499  0196   FF                 NOP
  500  0197   FF                 NOP
  501  0198   FF                 NOP
  502  0199   FF                 NOP
  503  019A   FF                 NOP
  504  019B   FF                 NOP
  505  019C   FF                 NOP
  506  019D   FF                 NOP
  507  019E   FF                 NOP
  508  019F   FF                 NOP
  509  01A0   2A F4              DJNZ    R2,DELAY_LOOP_10ms_R2     
  510  01A2   1A F0              DJNZ    R1,DELAY_LOOP_10ms_R1
  511  01A4   50 C2              POP     R2
  512  01A6   50 C1              POP     R1
  513                            
  514  01A8   AF                 RET
  515                    
  516  01A9              DELAY_1s:
  517  01A9   70 C1              PUSH    R1
  518  01AB   70 C2              PUSH    R2
  519  01AD   70 C3              PUSH    R3
  520  01AF   1C 43              LD      R1,#043H
  521  01B1              DELAY_LOOP_1s_R1:
  522  01B1   2C 0C              LD      R2,#00CH
  523  01B3              DELAY_LOOP_1s_R2:
  524  01B3   3C CF              LD      R3,#0CFH
  525  01B5              DELAY_LOOP_1s_R3:
  526  01B5   FF                 NOP
  527  01B6   FF                 NOP
  528  01B7   FF                 NOP
  529  01B8   FF                 NOP
  530  01B9   FF                 NOP
  531  01BA   FF                 NOP
  532  01BB   FF                 NOP
  533  01BC   FF                 NOP
  534  01BD   FF                 NOP
  535  01BE   FF                 NOP
  536  01BF   3A F4              DJNZ    R3,DELAY_LOOP_1s_R3
  537  01C1   2A F0              DJNZ    R2,DELAY_LOOP_1s_R2     
  538  01C3   1A EC              DJNZ    R1,DELAY_LOOP_1s_R1
  539  01C5   50 C3              POP     R3
  540  01C7   50 C2              POP     R2
  541  01C9   50 C1              POP     R1
  542                            
  543  01CB   AF                 RET
  544                    
  545  01CC              DELAY_10s:
  546  01CC   70 C1              PUSH    R1
  547  01CE   70 C2              PUSH    R2
  548  01D0   70 C3              PUSH    R3
  549  01D2   70 C4              PUSH    R4
  550  01D4   1C DF              LD      R1,#0DFH
  551  01D6              DELAY_LOOP_10s_R1:
  552  01D6   2C 04              LD      R2,#004H
  553  01D8              DELAY_LOOP_10s_R2:
  554  01D8   3C 42              LD      R3,#042H
  555  01DA              DELAY_LOOP_10s_R3:
  556  01DA   4C 15              LD      R4,#015H
  557  01DC              DELAY_LOOP_10s_R4:
  558  01DC   FF                 NOP
  559  01DD   FF                 NOP
  560  01DE   FF                 NOP
  561  01DF   FF                 NOP
  562  01E0   FF                 NOP
  563  01E1   FF                 NOP
  564  01E2   FF                 NOP
  565  01E3   FF                 NOP
  566  01E4   FF                 NOP
  567  01E5   FF                 NOP
  568  01E6   4A F4              DJNZ    R4,DELAY_LOOP_10s_R4
  569  01E8   3A F0              DJNZ    R3,DELAY_LOOP_10s_R3
  570  01EA   2A EC              DJNZ    R2,DELAY_LOOP_10s_R2     
  571  01EC   1A E8              DJNZ    R1,DELAY_LOOP_10s_R1
  572  01EE   50 C4              POP     R4
  573  01F0   50 C3              POP     R3
  574  01F2   50 C2              POP     R2
  575  01F4   50 C1              POP     R1
  576                            
  577  01F6   AF                 RET
  578                            
  579  01F7              UART_RX_DATA_INIT:
  580  01F7   70 C0              PUSH    R0
  581  01F9   70 C1              PUSH    R1
  582  01FB   0C 11              LD      R0,#uart_rx_data
  583  01FD   1C 00              LD      R1,#00H
  584  01FF              UART_RX_DATA_INIT_LOOP:
  585  01FF   B1 C0              CLR     @R0
  586  0201   0E                 INC     R0
  587  0202   1E                 INC     R1
  588  0203   A6 C1 32           CP      R1,#032H
  589  0206   3D 01 FF           JP      ULE,UART_RX_DATA_INIT_LOOP
  590  0209   50 C1              POP     R1
  591  020B   50 C0              POP     R0
  592                            
  593  020D   AF                 RET
  594                                                                                            
  595  020E              UART_TX:
  596  020E   70 C1              PUSH    R1
  597  0210              UART_TX_CHECK:
  598  0210   18 10              LD      R1,uart_status
  599  0212   37 11 FB           BTJRT   UART_TX_CHECK,R1.0      ; wait until tx finish
  600  0215   5F                 SB1
  601  0216   09 F8              LD      UDATA,R0    
  602  0218   4F                 SB0
  603  0219   46 10 01           OR      uart_status,#00000001B    
  604  021C   50 C1              POP     R1
  605                            
  606  021E   AF                 RET
  607                            
  608  021F              TIMER_A:
  609  021F   E6 D1 50           LD      TADATA,#50H             ; CPU = 8mMHz, interrupt interval = 3.2msec
  610  0222   E6 D2 0E           LD      TACON,#00001110B        ; fsoc/256, timer A interrupt enable
  611                            
  612  0225   AF                 RET       
  613                    
  614  0226              PWM0:
  615  0226   09 F2              LD      PWM0DATA,R0
  616  0228   19 F1              LD      PWM0EX,R1
  617  022A   09 43              LD      pwm0_value,R0
  618  022C   56 F3 F7           AND     PWM0CON,#11110111B      ; clear bit3 (clear counter bit, no effect) set to '0' to avoid clear counter
  619  022F   46 F3 04           OR      PWM0CON,#00000100B      ; PWM start run (if have started, then no effect, keep running)
  620                            
  621  0232   AF                 RET
  622                    
  623  0233              VE209S_TRS:
  624                    ; Binary interface for VE209S
  625                    ; 02 is the <STX>
  626                    ; 00 04 is the size_of_the_packet (4 bytes)
  627                    ; 31 32 33 34 are the 4 bytes of the payload
  628                    ; 03 is the <ETX>
  629  0233   0C 02              LD      R0,#02H
  630  0235   F6 02 0E           CALL    UART_TX
  631  0238   0C 00              LD      R0,#00H
  632  023A   F6 02 0E           CALL    UART_TX
  633  023D   0C 04              LD      R0,#04H
  634  023F   F6 02 0E           CALL    UART_TX
  635  0242   0C 31              LD      R0,#31H
  636  0244   F6 02 0E           CALL    UART_TX
  637  0247   0C 32              LD      R0,#32H
  638  0249   F6 02 0E           CALL    UART_TX
  639  024C   0C 33              LD      R0,#33H
  640  024E   F6 02 0E           CALL    UART_TX    
  641  0251   0C 34              LD      R0,#34H
  642  0253   F6 02 0E           CALL    UART_TX 
  643  0256   0C 03              LD      R0,#03H
  644  0258   F6 02 0E           CALL    UART_TX
  645                            
  646  025B   AF                 RET     
  647                    
  648                    ;;----------------------------------------
  649                    ;;   store data
  650                    ;;   R4 - high address of flash
  651                    ;;   R5 - low address of flash
  652                    ;;   R6 - start address of data
  653                    ;;   R7 - data length
  654                    ;;----------------------------------------
  655  025C              STORE_DATA:
  656  025C   8F                 DI        
  657                    ;;----------------------------------------
  658                    ;;   erase one sector
  659                    ;;----------------------------------------
  660  025D              FULL_FLASH_ERASE:
  661  025D   5F                 SB1
  662  025E   E6 ED A5           LD      FMUSR,#0A5H                             ; Flash Memory User Programming Enable Register
  663                                                                            ; 10100101 = Enable user programming mode
  664                                                                            ; Other values: Disable user programming mode
  665  0261   49 EE              LD      FMSECH,R4                               ; high address
  666  0263   59 EF              LD      FMSECL,R5                               ; low address.
  667  0265   E6 EC A1           LD      FMCON,#10100001B                        ; Flash Memory Control Register
  668                                                                            ; bit 7-4: Flash Memory Mode Selection Bits
  669                                                                            ; 0101 = Programming mode
  670                                                                            ; 1010 = Erase mode
  671                                                                            ; 0110 = Hard lock mode
  672                                                                            ; Others = Not used for S3F8S24
  673                                                                            ; bit 3-1: Not used for S3F8S28/F8S24
  674                                                                            ; bit 0: Flash (Erase or Hard Lock Protection) Operation Start Bit
  675                                                                            ; 0 = Operation stop
  676                                                                            ; 1 = Operation start (This bit will be cleared automatically just after erase operation.)
  677  0268   F6 01 7B           CALL    DELAY_1ms
  678  026B   F6 01 7B           CALL    DELAY_1ms
  679  026E   F6 01 7B           CALL    DELAY_1ms
  680  0271   F6 01 7B           CALL    DELAY_1ms
  681  0274   F6 01 7B           CALL    DELAY_1ms
  682                            
  683                            ;LD      FMUSR,#00H                              ;return to normal mode
  684                            ;SB0
  685                    ;;----------------------------------------
  686                    ;;   write data to sector
  687                    ;;----------------------------------------
  688  0277              FULL_FLASH_WRITE:  
  689                            ;SB1
  690                            ;LD      FMSECH,#0EH                             ;set sector address
  691                            ;LD      FMSECL,#00H
  692                            ;LD      R4,#0EH
  693                            ;LD      R5,#00H
  694  0277   8C 00              LD      R8,#00H
  695                            ;LD      FMUSR,#0A5H                             ;enter user mode 
  696  0279   E6 EC 50           LD      FMCON,#01010000B                        ;program mode
  697  027C              Flash_Write_Loop:
  698  027C   C7 06              LD      R0,@R6
  699  027E   D3 04              LDC     @RR4,R0
  700  0280   5E                 INC     R5
  701  0281   6E                 INC     R6
  702  0282   8E                 INC     R8
  703  0283   A2 87              CP      R8,R7
  704  0285   ED 02 7C           JP      NE,Flash_Write_Loop
  705  0288   E6 ED 00           LD      FMUSR, #00H                             ;return to normal mode
  706  028B   4F                 SB0
  707  028C   9F                 EI
  708                            
  709  028D   AF                 RET
  710                            
  711  028E              TASK_RX:
  712  028E   A6 CC 80           CP      R12,#80H
  713  0291   ED 04 2F           JP      NE,TASK_RX_END
  714  0294   0C 11              LD      R0,#uart_rx_data
  715  0296   C7 10              LD      R1,@R0
  716  0298   A6 C1 02           CP      R1,#02H                                 ; STX
  717  029B   ED 04 26           JP      NE,TASK_RX_DISCARD
  718  029E   0E                 INC     R0
  719  029F   C7 10              LD      R1,@R0                                  
  720  02A1   A6 C1 00           CP      R1,#00H                                 ; high byte of data length. It should be 00H
  721  02A4   ED 04 26           JP      NE,TASK_RX_DISCARD
  722  02A7   0E                 INC     R0
  723  02A8   C7 10              LD      R1,@R0
  724  02AA   A6 C1 00           CP      R1,#00H                                 ; low byte of data length. It should not be 00H
  725  02AD   6D 04 26           JP      EQ,TASK_RX_DISCARD                      
  726  02B0   A6 C1 04           CP      R1,#04H
  727  02B3   6D 02 C5           JP      EQ,TASK_RX_ON_CMD
  728  02B6   A6 C1 05           CP      R1,#05H
  729  02B9   6D 02 FE           JP      EQ,TASK_RX_OFF_CMD
  730  02BC   A6 C1 06           CP      R1,#06H
  731  02BF   6D 03 40           JP      EQ,TASK_RX_DIM_CMD
  732  02C2   8D 04 26           JP      TASK_RX_DISCARD      
  733  02C5              TASK_RX_ON_CMD: 
  734  02C5   0E                 INC     R0
  735  02C6   C7 10              LD      R1,@R0
  736  02C8   A6 C1 4F           CP      R1,#4FH                                 ; 'O'
  737  02CB   ED 04 26           JP      NE,TASK_RX_DISCARD
  738  02CE   0E                 INC     R0
  739  02CF   C7 10              LD      R1,@R0
  740  02D1   A6 C1 4E           CP      R1,#4EH                                 ; 'N'
  741  02D4   ED 04 26           JP      NE,TASK_RX_DISCARD
  742  02D7   0E                 INC     R0
  743  02D8   C7 10              LD      R1,@R0
  744  02DA   A6 C1 20           CP      R1,#20H                                 ; space
  745  02DD   ED 04 26           JP      NE,TASK_RX_DISCARD
  746  02E0   0E                 INC     R0
  747  02E1   C7 10              LD      R1,@R0
  748  02E3   A6 C1 32           CP      R1,#VE209S_NUMBER                       ; VE209S number, from 31H-35H
  749  02E6   ED 04 26           JP      NE,TASK_RX_DISCARD
  750  02E9   0E                 INC     R0
  751  02EA   C7 10              LD      R1,@R0
  752  02EC   A6 C1 03           CP      R1,#03H                                 ; ETX
  753  02EF   ED 04 26           JP      NE,TASK_RX_DISCARD
  754  02F2   38 C0              LD      R3,R0
  755  02F4   0C 01              LD      R0,#01H
  756  02F6   1C 00              LD      R1,#00H
  757  02F8   F6 02 26           CALL    PWM0      
  758  02FB   8D 04 19           JP      TASK_RX_ECHO
  759  02FE              TASK_RX_OFF_CMD:
  760  02FE   0E                 INC     R0
  761  02FF   C7 10              LD      R1,@R0
  762  0301   A6 C1 4F           CP      R1,#4FH                                 ; 'O'
  763  0304   ED 04 26           JP      NE,TASK_RX_DISCARD
  764  0307   0E                 INC     R0
  765  0308   C7 10              LD      R1,@R0
  766  030A   A6 C1 46           CP      R1,#46H                                 ; 'F'
  767  030D   ED 04 26           JP      NE,TASK_RX_DISCARD
  768  0310   0E                 INC     R0
  769  0311   C7 10              LD      R1,@R0
  770  0313   A6 C1 46           CP      R1,#46H                                 ; 'F'
  771  0316   ED 04 26           JP      NE,TASK_RX_DISCARD 
  772  0319   0E                 INC     R0
  773  031A   C7 10              LD      R1,@R0
  774  031C   A6 C1 20           CP      R1,#20H                                 ; space
  775  031F   ED 04 26           JP      NE,TASK_RX_DISCARD 
  776  0322   0E                 INC     R0
  777  0323   C7 10              LD      R1,@R0
  778  0325   A6 C1 32           CP      R1,#VE209S_NUMBER                       ; VE209S number, from 31H-35H
  779  0328   ED 04 26           JP      NE,TASK_RX_DISCARD
  780  032B   0E                 INC     R0
  781  032C   C7 10              LD      R1,@R0
  782  032E   A6 C1 03           CP      R1,#03H                                 ; ETX
  783  0331   ED 04 26           JP      NE,TASK_RX_DISCARD
  784  0334   38 C0              LD      R3,R0
  785  0336   0C 00              LD      R0,#00H
  786  0338   1C 00              LD      R1,#00H
  787  033A   F6 02 26           CALL    PWM0    
  788  033D   8D 04 19           JP      TASK_RX_ECHO
  789  0340              TASK_RX_DIM_CMD:
  790  0340   0E                 INC     R0
  791  0341   C7 10              LD      R1,@R0
  792  0343   A6 C1 44           CP      R1,#44H                                 ; 'D'
  793  0346   ED 04 26           JP      NE,TASK_RX_DISCARD
  794  0349   0E                 INC     R0
  795  034A   C7 10              LD      R1,@R0
  796  034C   A6 C1 49           CP      R1,#49H                                 ; 'I'
  797  034F   ED 04 26           JP      NE,TASK_RX_DISCARD
  798  0352   0E                 INC     R0
  799  0353   C7 10              LD      R1,@R0
  800  0355   A6 C1 4D           CP      R1,#4DH                                 ; 'M'
  801  0358   ED 04 26           JP      NE,TASK_RX_DISCARD
  802  035B   0E                 INC     R0
  803  035C   C7 10              LD      R1,@R0                                  
  804  035E   A6 C1 2B           CP      R1,#2BH                                 ; '+'
  805  0361   6D 03 C1           JP      EQ,TASK_RX_DIM_CMD_PLUS
  806  0364   A6 C1 2D           CP      R1,#2DH                                 ; '-'
  807  0367   ED 04 26           JP      NE,TASK_RX_DISCARD
  808  036A              TASK_RX_DIM_CMD_MINUS:
  809  036A   0E                 INC     R0
  810  036B   C7 10              LD      R1,@R0
  811  036D   A6 C1 20           CP      R1,#20H                                 ; space
  812  0370   ED 04 26           JP      NE,TASK_RX_DISCARD 
  813  0373   0E                 INC     R0
  814  0374   C7 10              LD      R1,@R0
  815  0376   A6 C1 32           CP      R1,#VE209S_NUMBER                       ; VE209S number, from 31H-35H
  816  0379   ED 04 26           JP      NE,TASK_RX_DISCARD
  817  037C   0E                 INC     R0
  818  037D   C7 10              LD      R1,@R0
  819  037F   A6 C1 03           CP      R1,#03H                                 ; ETX
  820  0382   ED 04 26           JP      NE,TASK_RX_DISCARD
  821  0385   38 C0              LD      R3,R0
  822  0387   A6 43 00           CP      pwm0_value,#00H
  823  038A   6D 04 19           JP      EQ,TASK_RX_ECHO
  824  038D   A6 43 01           CP      pwm0_value,#01H
  825  0390   6D 03 A8           JP      EQ,TASK_RX_DIM_CMD_MINUS1
  826  0393   A6 43 10           CP      pwm0_value,#010H
  827  0396   6D 03 AD           JP      EQ,TASK_RX_DIM_CMD_MINUS2
  828  0399   A6 43 20           CP      pwm0_value,#020H
  829  039C   6D 03 B2           JP      EQ,TASK_RX_DIM_CMD_MINUS3
  830  039F   A6 43 30           CP      pwm0_value,#030H
  831  03A2   6D 03 B7           JP      EQ,TASK_RX_DIM_CMD_MINUS4
  832  03A5   8D 04 19           JP      TASK_RX_ECHO
  833  03A8              TASK_RX_DIM_CMD_MINUS1:
  834  03A8   0C 00              LD      R0,#00H
  835  03AA   8D 03 B9           JP      TASK_RX_DIM_CMD_MINUS_PWM
  836  03AD              TASK_RX_DIM_CMD_MINUS2:
  837  03AD   0C 01              LD      R0,#01H
  838  03AF   8D 03 B9           JP      TASK_RX_DIM_CMD_MINUS_PWM
  839  03B2              TASK_RX_DIM_CMD_MINUS3:
  840  03B2   0C 10              LD      R0,#010H
  841  03B4   8D 03 B9           JP      TASK_RX_DIM_CMD_MINUS_PWM
  842  03B7              TASK_RX_DIM_CMD_MINUS4:
  843  03B7   0C 20              LD      R0,#020H
  844  03B9              TASK_RX_DIM_CMD_MINUS_PWM:
  845  03B9   1C 00              LD      R1,#00H
  846  03BB   F6 02 26           CALL    PWM0
  847  03BE   8D 04 19           JP      TASK_RX_ECHO        
  848  03C1              TASK_RX_DIM_CMD_PLUS:
  849  03C1   0E                 INC     R0
  850  03C2   C7 10              LD      R1,@R0
  851  03C4   A6 C1 20           CP      R1,#20H                                 ; space
  852  03C7   ED 04 26           JP      NE,TASK_RX_DISCARD 
  853  03CA   0E                 INC     R0
  854  03CB   C7 10              LD      R1,@R0
  855  03CD   A6 C1 32           CP      R1,#VE209S_NUMBER                       ; VE209S number, from 31H-35H
  856  03D0   ED 04 26           JP      NE,TASK_RX_DISCARD
  857  03D3   0E                 INC     R0
  858  03D4   C7 10              LD      R1,@R0
  859  03D6   A6 C1 03           CP      R1,#03H                                 ; ETX
  860  03D9   ED 04 26           JP      NE,TASK_RX_DISCARD
  861  03DC   38 C0              LD      R3,R0
  862  03DE   A6 43 00           CP      pwm0_value,#00H
  863  03E1   6D 04 19           JP      EQ,TASK_RX_ECHO
  864  03E4   A6 43 01           CP      pwm0_value,#01H
  865  03E7   6D 03 FF           JP      EQ,TASK_RX_DIM_CMD_PLUS1
  866  03EA   A6 43 10           CP      pwm0_value,#010H
  867  03ED   6D 04 04           JP      EQ,TASK_RX_DIM_CMD_PLUS2
  868  03F0   A6 43 20           CP      pwm0_value,#020H
  869  03F3   6D 04 09           JP      EQ,TASK_RX_DIM_CMD_PLUS3
  870  03F6   A6 43 30           CP      pwm0_value,#030H
  871  03F9   6D 04 0E           JP      EQ,TASK_RX_DIM_CMD_PLUS4
  872  03FC   8D 04 19           JP      TASK_RX_ECHO
  873  03FF              TASK_RX_DIM_CMD_PLUS1:
  874  03FF   0C 10              LD      R0,#010H
  875  0401   8D 04 11           JP      TASK_RX_DIM_CMD_PWM
  876  0404              TASK_RX_DIM_CMD_PLUS2:
  877  0404   0C 20              LD      R0,#020H
  878  0406   8D 04 11           JP      TASK_RX_DIM_CMD_PWM
  879  0409              TASK_RX_DIM_CMD_PLUS3:
  880  0409   0C 30              LD      R0,#030H
  881  040B   8D 04 11           JP      TASK_RX_DIM_CMD_PWM
  882  040E              TASK_RX_DIM_CMD_PLUS4:
  883  040E   8D 04 19           JP      TASK_RX_ECHO
  884  0411              TASK_RX_DIM_CMD_PWM:
  885  0411   1C 00              LD      R1,#00H
  886  0413   F6 02 26           CALL    PWM0
  887  0416   8D 04 19           JP      TASK_RX_ECHO 
  888  0419              TASK_RX_ECHO:
  889  0419   1C 11              LD      R1,#uart_rx_data
  890  041B              TASK_RX_ECHO_REPEAT:
  891  041B   C7 01              LD      R0,@R1
  892  041D   F6 02 0E           CALL    UART_TX
  893  0420   1E                 INC     R1
  894  0421   A2 13              CP      R1,R3
  895  0423   3D 04 1B           JP      ULE,TASK_RX_ECHO_REPEAT       
  896  0426              TASK_RX_DISCARD:
  897  0426   8F                 DI
  898  0427   F6 01 F7           CALL    UART_RX_DATA_INIT
  899  042A   FC 11              LD      R15,#uart_rx_data
  900  042C   CC 00              LD      R12,#00H
  901  042E   9F                 EI
  902  042F              TASK_RX_END:        
  903  042F   AF                 RET 
  904                            
  905  0430              BUTTON_PRESS:        
  906  0430   08 E0              LD      R0,P0
  907  0432   56 C0 01           AND     R0,#00000001B
  908                            ;AND     R0,#00010000B
  909  0435   A6 C0 01           CP      R0,#001H
  910                            ;CP      R0,#010H
  911  0438   6D 04 CC           JP      EQ,BUTTON_PRESS_RELEASE
  912  043B   A6 CD 64           CP      R13,#064H
  913  043E   2D 04 C3           JP      LE,BUTTON_PRESS_DEBOUNCE
  914  0441   A6 C0 01           CP      R0,#001H
  915                            ;CP      R0,#010H
  916  0444   6D 04 CC           JP      EQ,BUTTON_PRESS_RELEASE
  917  0447   A6 CE 00           CP      R14,#00H
  918  044A   ED 04 BE           JP      NE,BUTTON_PRESS_CONTINUE
  919  044D   EC 01              LD      R14,#001H       ; key press down detected
  920  044F   A6 F2 00           CP      PWM0DATA,#00H
  921  0452   ED 04 87           JP      NE,BUTTON_PRESS_LED_OFF
  922  0455              BUTTON_PRESS_LED_ON:
  923  0455   0C 01              LD      R0,#001H
  924                            ;LD      R0,#03FH
  925  0457   1C 00              LD      R1,#00H
  926  0459   F6 02 26           CALL    PWM0
  927  045C   0C 02              LD      R0,#02H
  928  045E   F6 02 0E           CALL    UART_TX
  929  0461   0C 00              LD      R0,#00H
  930  0463   F6 02 0E           CALL    UART_TX
  931  0466   0C 04              LD      R0,#04H
  932  0468   F6 02 0E           CALL    UART_TX
  933  046B   0C 4F              LD      R0,#4FH
  934  046D   F6 02 0E           CALL    UART_TX
  935  0470   0C 4E              LD      R0,#4EH
  936  0472   F6 02 0E           CALL    UART_TX
  937  0475   0C 20              LD      R0,#20H
  938  0477   F6 02 0E           CALL    UART_TX    
  939  047A   0C 32              LD      R0,#VE209S_NUMBER
  940  047C   F6 02 0E           CALL    UART_TX 
  941  047F   0C 03              LD      R0,#03H
  942  0481   F6 02 0E           CALL    UART_TX
  943  0484   8D 04 D0           JP      BUTTON_PRESS_END
  944  0487              BUTTON_PRESS_LED_OFF:
  945  0487   0C 00              LD      R0,#00H
  946  0489   1C 00              LD      R1,#00H
  947  048B   F6 02 26           CALL    PWM0
  948  048E              BUTTON_PRESS_LED_OFF_TX:
  949  048E   0C 02              LD      R0,#02H
  950  0490   F6 02 0E           CALL    UART_TX
  951  0493   0C 00              LD      R0,#00H
  952  0495   F6 02 0E           CALL    UART_TX
  953  0498   0C 05              LD      R0,#05H
  954  049A   F6 02 0E           CALL    UART_TX
  955  049D   0C 4F              LD      R0,#4FH
  956  049F   F6 02 0E           CALL    UART_TX
  957  04A2   0C 46              LD      R0,#46H
  958  04A4   F6 02 0E           CALL    UART_TX
  959  04A7   0C 46              LD      R0,#46H
  960  04A9   F6 02 0E           CALL    UART_TX
  961  04AC   0C 20              LD      R0,#20H
  962  04AE   F6 02 0E           CALL    UART_TX    
  963  04B1   0C 32              LD      R0,#VE209S_NUMBER
  964  04B3   F6 02 0E           CALL    UART_TX 
  965  04B6   0C 03              LD      R0,#03H
  966  04B8   F6 02 0E           CALL    UART_TX
  967  04BB   8D 04 D0           JP      BUTTON_PRESS_END
  968  04BE              BUTTON_PRESS_CONTINUE:
  969  04BE   EC 02              LD      R14,#002H       ; key press on hold detected
  970  04C0   8D 04 D0           JP      BUTTON_PRESS_END
  971  04C3              BUTTON_PRESS_DEBOUNCE:
  972  04C3   06 CD 01           ADD     R13,#01H
  973  04C6   F6 01 7B           CALL    DELAY_1ms
  974  04C9   8D 04 D0           JP      BUTTON_PRESS_END
  975  04CC              BUTTON_PRESS_RELEASE:
  976  04CC   B0 CD              CLR     R13
  977  04CE   B0 CE              CLR     R14
  978  04D0              BUTTON_PRESS_END:
  979  04D0   AF                 RET
  980                    
  981  04D1              TASK_P00:
  982  04D1   A6 CE 01           CP      R14,#001H
  983  04D4   ED 05 43           JP      NE,TASK_P00_END
  984  04D7   A6 F2 00           CP      PWM0DATA,#00H
  985  04DA   ED 05 0F           JP      NE,TASK_P00_LED_OFF
  986  04DD              TASK_P00_LED_ON:
  987  04DD   0C 01              LD      R0,#001H
  988  04DF   1C 00              LD      R1,#00H
  989  04E1   F6 02 26           CALL    PWM0
  990  04E4   0C 02              LD      R0,#02H
  991  04E6   F6 02 0E           CALL    UART_TX
  992  04E9   0C 00              LD      R0,#00H
  993  04EB   F6 02 0E           CALL    UART_TX
  994  04EE   0C 04              LD      R0,#04H
  995  04F0   F6 02 0E           CALL    UART_TX
  996  04F3   0C 4F              LD      R0,#4FH
  997  04F5   F6 02 0E           CALL    UART_TX
  998  04F8   0C 4E              LD      R0,#4EH
  999  04FA   F6 02 0E           CALL    UART_TX
 1000  04FD   0C 20              LD      R0,#20H
 1001  04FF   F6 02 0E           CALL    UART_TX    
 1002  0502   0C 31              LD      R0,#31H
 1003  0504   F6 02 0E           CALL    UART_TX 
 1004  0507   0C 03              LD      R0,#03H
 1005  0509   F6 02 0E           CALL    UART_TX
 1006  050C   8D 05 43           JP      TASK_P00_END
 1007  050F              TASK_P00_LED_OFF:  
 1008  050F   0C 00              LD      R0,#00H
 1009  0511   1C 00              LD      R1,#00H
 1010  0513   F6 02 26           CALL    PWM0
 1011  0516   0C 02              LD      R0,#02H
 1012  0518   F6 02 0E           CALL    UART_TX
 1013  051B   0C 00              LD      R0,#00H
 1014  051D   F6 02 0E           CALL    UART_TX
 1015  0520   0C 05              LD      R0,#05H
 1016  0522   F6 02 0E           CALL    UART_TX
 1017  0525   0C 4F              LD      R0,#4FH
 1018  0527   F6 02 0E           CALL    UART_TX
 1019  052A   0C 46              LD      R0,#46H
 1020  052C   F6 02 0E           CALL    UART_TX
 1021  052F   0C 46              LD      R0,#46H
 1022  0531   F6 02 0E           CALL    UART_TX
 1023  0534   0C 20              LD      R0,#20H
 1024  0536   F6 02 0E           CALL    UART_TX    
 1025  0539   0C 31              LD      R0,#31H
 1026  053B   F6 02 0E           CALL    UART_TX 
 1027  053E   0C 03              LD      R0,#03H
 1028  0540   F6 02 0E           CALL    UART_TX      
 1029  0543              TASK_P00_END:        
 1030  0543   AF                 RET 
 1031                                                                                                                                                                                                                                                               
 1032                    ;;=======================================================================
 1033                    ;;==      INTERRUPT SERVICE ROUTINE                                    ==
 1034                    ;;==                                                                   ==
 1035                    ;;==                                                                   == 
 1036                    ;;=======================================================================                                                                                
 1037                           ;;----------------------------------------
 1038                           ;;     external interrupt 0
 1039                           ;;----------------------------------------
 1040  0544              EX_INT0:
 1041  0544   56 E8 FE          AND     P0PND, #11111110B                       ;clear pending bit
 1042  0547   8D 05 CE          JP      INT_ISR_END        
 1043                           ;;----------------------------------------
 1044                           ;;     external interrupt 1
 1045                           ;;----------------------------------------
 1046  054A              EX_INT1:
 1047  054A   56 E8 FB           AND     P0PND, #11111011B                       ;clear pending bit
 1048  054D   8D 05 CE           JP      INT_ISR_END
 1049                           ;;----------------------------------------
 1050                           ;;     external interrupt 2
 1051                           ;;----------------------------------------
 1052  0550              EX_INT2:
 1053                            ;XOR     P0,#00100000B                           ;toggle P0.5 
 1054  0550   56 E8 EF           AND     P0PND, #11101111B                       ;clear pending bit
 1055  0553   8D 05 CE           JP      INT_ISR_END
 1056                            ;;----------------------------------------
 1057                           ;;     external interrupt 3
 1058                           ;;----------------------------------------
 1059  0556              EX_INT3:
 1060                            ;XOR     P0,#00010000B                           ;toggle P0.4 
 1061  0556   56 E8 BF           AND     P0PND, #10111111B                       ;clear pending bit
 1062  0559   8D 05 CE           JP      INT_ISR_END
 1063                            ;;----------------------------------------
 1064                           ;;     external interrupt 4
 1065                           ;;----------------------------------------
 1066  055C              EX_INT4:
 1067                            ;XOR     P0,#10000000B                           ;toggle P0.7 
 1068  055C   56 EF FE           AND     P3PND, #11111110B                       ;clear pending bit
 1069  055F   8D 05 CE           JP      INT_ISR_END
 1070                            ;;----------------------------------------
 1071                           ;;     external interrupt 5
 1072                           ;;----------------------------------------
 1073  0562              EX_INT5:
 1074                            ;XOR     P0,#01000000B                           ;toggle P0.6 
 1075  0562   56 EF FB           AND     P3PND, #11111011B                       ;clear pending bit
 1076  0565   8D 05 CE           JP      INT_ISR_END
 1077                            ;;----------------------------------------
 1078                           ;;     external interrupt 6
 1079                           ;;----------------------------------------
 1080  0568              EX_INT6:
 1081                            ;XOR     P0,#00100000B                           ;toggle P0.5 
 1082  0568   56 EF EF           AND     P3PND, #11101111B                       ;clear pending bit
 1083  056B   8D 05 CE           JP      INT_ISR_END
 1084                            ;;----------------------------------------
 1085                           ;;     external interrupt 7
 1086                           ;;----------------------------------------
 1087  056E              EX_INT7:
 1088                            ;XOR     P0,#00010000B                           ;toggle P0.4 
 1089  056E   56 EF BF           AND     P3PND, #10111111B                       ;clear pending bit
 1090  0571   8D 05 CE           JP      INT_ISR_END
 1091                            
 1092                           ;;----------------------------------------
 1093                           ;;     Timer0/A match interrupt
 1094                           ;;----------------------------------------  
 1095  0574              T0_A_MC_INT:
 1096                            ;XOR     P0,#10000000B                           ;toggle P0.7
 1097  0574   56 D2 FE           AND     TACON,#11111110B                        ;clear pending bit
 1098  0577   8D 05 CE           JP      INT_ISR_END 
 1099                           ;;----------------------------------------
 1100                           ;;     TimerB match interrupt
 1101                           ;;---------------------------------------- 
 1102  057A              TB_MC_INT:
 1103                            ;XOR     P0,#01000000B                           ;toggle P0.6
 1104  057A   56 EE FE           AND     TBCON,#11111110B                        ;clear pending bit
 1105  057D   8D 05 CE           JP      INT_ISR_END
 1106                           ;;----------------------------------------
 1107                           ;;     PWM1 Overflow interrupt 
 1108                           ;;----------------------------------------
 1109  0580              PWM1_OVF_INT:
 1110                            ;XOR     P0,#01000000B                           ;toggle P0.6
 1111  0580   5F                 SB1
 1112  0581   56 E8 F6           AND     PWM1CON,#11110110B                       ;clear pending bit
 1113  0584   4F                 SB0
 1114  0585   8D 05 CE           JP      INT_ISR_END
 1115                           ;;----------------------------------------
 1116                           ;;     PWM0 Overflow interrupt 
 1117                           ;;----------------------------------------
 1118  0588              PWM0_OVF_INT:
 1119                            ;XOR     P0,#00100000B                           ;toggle P0.5
 1120  0588   56 F3 F6           AND     PWM0CON,#11110110B                       ;clear pending bit
 1121  058B   8D 05 CE           JP      INT_ISR_END
 1122                           ;;----------------------------------------
 1123                           ;;     Timer1 match interrupt
 1124                           ;;----------------------------------------  
 1125  058E              TIMER1_MC_INT:
 1126                            ;XOR     P0,#00100000B                            ;toggle P0.5
 1127  058E   5F                 SB1
 1128  058F   56 E4 FE           AND     T1CON,#11111110B                         ;clear pending bit
 1129  0592   4F                 SB0
 1130  0593   8D 05 CE           JP      INT_ISR_END 
 1131                           ;;----------------------------------------
 1132                           ;;     Timer1 Overflow interrupt
 1133                           ;;----------------------------------------  
 1134  0596              TIMER1_OVF_INT:
 1135                            ;XOR     P0,#00010000B                            ;toggle P0.4
 1136  0596   5F                 SB1
 1137  0597   56 E4 FB           AND     T1CON,#11111011B                         ;clear pending bit
 1138  059A   4F                 SB0
 1139  059B   8D 05 CE           JP      INT_ISR_END
 1140                           ;;----------------------------------------
 1141                           ;;     Low voltage detector interrupt
 1142                           ;;---------------------------------------- 
 1143  059E              LVD_INT:
 1144                            ;SB0
 1145                            ;AND      P0,#11110111B                            ;light P0.3
 1146  059E   5F                 SB1
 1147  059F   56 F4 EF           AND     LVDCON, #11101111B                       ;disable interrupt
 1148  05A2   4F                 SB0
 1149  05A3   8D 05 CE           JP      INT_ISR_END              
 1150                           ;;----------------------------------------
 1151                           ;;     UART interrupt
 1152                           ;;---------------------------------------- 
 1153  05A6              UART_TRS_INT:
 1154  05A6   5F                 SB1
 1155  05A7   56 10 FE           AND     uart_status,#11111110B
 1156  05AA   56 F6 FE           AND     UARTPND, #11111110B                      ;clear pending bit
 1157  05AD   4F                 SB0
 1158  05AE   8D 05 CE           JP      INT_ISR_END
 1159  05B1              UART_RV_INT:
 1160  05B1   5F                 SB1
 1161  05B2   F5 F8 CF           LD      @R15,UDATA
 1162  05B5   A6 F8 03           CP      UDATA,#03H
 1163  05B8   ED 05 BD           JP      NE,UART_RV_INT_ETX
 1164  05BB   CC 80              LD      R12,#80H
 1165  05BD              UART_RV_INT_ETX:
 1166  05BD   FE                 INC     R15
 1167  05BE   56 F6 FD           AND     UARTPND, #11111101B                      ;clear pending bit
 1168  05C1   4F                 SB0
 1169  05C2   8D 05 CE           JP      INT_ISR_END
 1170                           ;;----------------------------------------
 1171                           ;;     IIC interrupt
 1172                           ;;---------------------------------------- 
 1173  05C5              IIC_INT:
 1174  05C5   8D 05 CE           JP      INT_ISR_END
 1175                           ;;----------------------------------------
 1176                           ;;     Watchdog  interrupt
 1177                           ;;---------------------------------------- 
 1178  05C8              WDT_INT:
 1179                            ;XOR     P3,#00000001B                           ;toggle P3.0
 1180                            ;AND      WDTCON, #10111111B                    ;disable reset, clear counter
 1181  05C8   46 F6 10           OR      WDTCON, #00010000B                      ;clear counter.      
 1182  05CB   8D 05 CE           JP      INT_ISR_END       
 1183                    
 1184                    
 1185                    
 1186                           ;;----------------------------------------
 1187                           ;;     interrupt service end
 1188                           ;;----------------------------------------        
 1189  05CE              INT_ISR_END:                
 1190  05CE   BF                IRET
 1191                           
 1192  05CF              .END                                                          


Total 1186 Lines Assembled - 0 Errors, 0 Warnings
Total code size 0x4F9


