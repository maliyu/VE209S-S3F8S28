Mon Sep 09 18:57:43 2013
                              
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
   42         00 00      uart_status      EQU     00H
   43                    
   44  0000                      .ORG    0000H
   45                    ;;=======================================================================
   46                    ;;==                                                                   ==
   47                    ;;==                SMART OPTION Setting  ROUTINE                      ==
   48                    ;;==                                                                   == 
   49                    ;;=======================================================================
   50  003C                     .ORG  003CH
   51  003C   FF                .DB   0FFH
   52  003D   FF                .DB   0FFH
   53  003E   FF                .DB   11111111B          ;@3EH : ISP options
   54                                                                 ; bit7: Reset vector address change enable/disable
   55                                                                 ;    0-change address   
   56                                                                 ;    1-normal: 100H
   57                                                                 ; bit6~5: reset vector address
   58                                                                 ;      @00B---200H         
   59                                                                 ;      @01B---300H
   60                                                                 ;      @10B---500H
   61                                                                 ;      @11B---900H
   62                                                                 ; bit4-3: not used
   63                                                                 ; bit2: ISP protection enable/disable
   64                                                                 ;    1-disable  
   65                                                                 ;    0-enable
   66                                                                 ; bit1-0: ISP protection size
   67                                                                 ;      @00B---256B         
   68                                                                 ;      @01B---512B
   69                                                                 ;      @10B---1024B
   70                                                                 ;      @11B---2048B        
   71  003F   8F                .DB   10001111B          ;@3FH :LVR, level, P1.2; OSC;
   72                                                                 ; bit 7: LVR Enable/disable
   73                                                                 ;    0-disable  
   74                                                                 ;    1-enable
   75                                                                 ; bit 6-5: LVR level
   76                                                                 ;      @00B---1.9V         
   77                                                                 ;      @01B---2.3V
   78                                                                 ;      @10B---3.0V
   79                                                                 ;      @11B---3.9V
   80                                                                 ; bit 4: P1.2/RESET pin selection
   81                                                                 ;    0-P1.2 pin enable  
   82                                                                 ;    1-RESET Pin enable
   83                                                                 ; bit 3-0: Oscillator selection bit
   84                                                                 ;      @0100B---External LG OSC         
   85                                                                 ;      @1100B---External HG OSC
   86                                                                 ;      @1010B---internal RC(1 M)
   87                                                                 ;      @1111B---internal RC(8 M)
   88                                                                 ;      @1000B---internal RC(0.5 M)
   89                                                                 ;      @1001B---internal RC(2 M)
   90                                                                 ;      @1011B---internal RC(4 M)
   91                    ;;=======================================================================
   92                    ;;==                                                                   ==
   93                    ;;==            INTERRUPT VECTOR                                       ==
   94                    ;;==                                                                   == 
   95                    ;;=======================================================================
   96  00D8   02 52             .VECTOR  0D8H, EX_INT7
   97  00DA   02 4C             .VECTOR  0DAH, EX_INT6
   98  00DC   02 46             .VECTOR  0DCH, EX_INT5
   99  00DE   02 40             .VECTOR  0DEH, EX_INT4
  100  00E0   02 9D             .VECTOR  0E0H, IIC_INT
  101  00E2   02 95             .VECTOR  0E2H, UART_RV_INT
  102  00E4   02 8A             .VECTOR  0E4H, UART_TRS_INT
  103  00E6   02 A0             .VECTOR  0E6H, WDT_INT
  104  00E8   02 82             .VECTOR  0E8H, LVD_INT
  105  00EA   02 7A             .VECTOR  0EAH, TIMER1_OVF_INT
  106  00EC   02 72             .VECTOR  0ECH, TIMER1_MC_INT
  107  00F0   02 64             .VECTOR  0F0H, PWM1_OVF_INT
  108  00F2   02 6C             .VECTOR  0F2H, PWM0_OVF_INT
  109  00F4   02 5E             .VECTOR  0F4H, TB_MC_INT
  110  00F6   02 58             .VECTOR  0F6H, T0_A_MC_INT
  111  00F8   02 3A             .VECTOR  0F8H, EX_INT3
  112  00FA   02 34             .VECTOR  0FAH, EX_INT2
  113  00FC   02 2E             .VECTOR  0FCH, EX_INT1
  114  00FE   02 28             .VECTOR  0FEH, EX_INT0
  115                    ;;=======================================================================
  116                    ;;==                                                                   ==
  117                    ;;==            RESET and Initialization code                          ==
  118                    ;;==                                                                   == 
  119                    ;;=======================================================================
  120                    
  121  0100                     .ORG    0100H
  122  0100              RESET:
  123  0100   8F                 DI
  124  0101   E6 D3 A3           LD      BTCON,#10100011B        ; bit 7-4: Watchdog timer enable bits
  125                                                            ; 1010B = Disable watchdog function
  126                                                            ; Other value = Enable watchdog function
  127                                                            ; bit 3-2: Basic timer input clock selection bits
  128                                                            ; 00 = fosc/4096
  129                                                            ; 01 = fosc/1024
  130                                                            ; 10 = fosc/128
  131                                                            ; 11 = Invalid selection 
  132                                                            ; bit 1: Basic timer counter clear bits
  133                                                            ; 0 = No effect
  134                                                            ; 1 = Clear basic timer counter
  135                                                            ; bit 0: Divider clear bit for basic timer and timer 0
  136                                                            ; 0 = No effect
  137                                                            ; 1 = Clear both dividers
  138  0104   E6 D4 18           LD      CLKCON,#00011000B       ; bit 7: Oscillator IRQ wake-up enable bit
  139                                                            ; 0 = Enable IRQ for main system oscillator wake-up function in power mode.
  140                                                            ; 1 = Disable IRQ for main system oscillator wake-up function in power down mode.
  141                                                            ; bit 6-5: not used
  142                                                            ; bit 4-3: Divide-by selection bits for CPU clock frequency
  143                                                            ; 00 = fosc/16
  144                                                            ; 01 = fosc/8
  145                                                            ; 10 = fosc/2
  146                                                            ; 11 = fosc (non-divided)
  147                                                                            ; bit 2-0: not used
  148  0107   E6 F5 00           LD      ROSCCON,#00000000B      ; 
  149  010A   E6 D9 FF           LD      SPL,#0FFH               ; SP: FFH (Normally, the SP is set to FFH by the initialization routine) 
  150  010D   E6 DA 00           LD      IPH,#00H
  151  0110   E6 DB 00           LD      IPL,#00H
  152  0113   E6 DD FF           LD      IMR,#11111111B          ; Interrupt level enable bit
  153                                                            ; bit 7-0 <-> IRQ7-0
  154                                                            ; 0 = Disable (mask) interrupt level
  155                                                            ; 1 = Enable (un-mask) interrupt level
  156                                                            
  157                                                            ; IRQ0: External interrupt 0/1/2/3
  158                                                            ; IRQ1: Timer 0/A match interrupt/Timer B match interrupt
  159                                                            ; IRQ2: PWM0 overflow interrupt/PWM1 overflow interrupt
  160                                                            ; IRQ3: Timer 1 match/capture interrupt/Timer 1 overflow interrupt
  161                                                            ; IRQ4: Watchdog interrupt
  162                                                            ; IRQ5: UART transmit interrupt/UART Receive interrupt
  163                                                            ; IRQ6: IIC transmit / receive interrupt
  164                                                            ; IRQ7: External interrupt 4/5/6/7
  165  0116   E6 FF CD           LD      IPR,#11001101B          ; Interrupt Priority Register
  166                                                            ; bit7/4/1 -> Group priority
  167                                                            ; 0 0 0 = Undefined
  168                                                            ; 0 0 1 = B > C > A
  169                                                            ; 0 1 0 = A > B > C
  170                                                            ; 0 1 1 = B > A > C
  171                                                            ; 1 0 0 = C > A > B
  172                                                            ; 1 0 1 = C > B > A
  173                                                            ; 1 1 0 = A > C > B
  174                                                            ; 1 1 1 = Undefined
  175                                                            ; bit 6 -> Subgroup C
  176                                                            ; 0 = IRQ6 > IRQ7
  177                                                            ; 1 = IRQ7 > IRQ6
  178                                                            ; bit 5 -> Group C 
  179                                                            ; 0 = IRQ5 > (IRQ6, IRQ7)
  180                                                            ; 1 = (IRQ6, IRQ7) > IRQ5
  181                                                            ; bit 3 -> Subgroup B
  182                                                            ; 0 = IRQ3 > IRQ4
  183                                                            ; 1 = IRQ4 > IRQ3
  184                                                            ; bit 2 -> Group B
  185                                                            ; 0 = IRQ2 > (IRQ3, IRQ4)
  186                                                            ; 1 = (IRQ3, IRQ4) > IRQ2
  187                                                            ; bit 0 -> Group A
  188                                                            ; 0 = IRQ0 > IRQ1
  189                                                            ; 1 = IRQ1 > IRQ0
  190                    
  191  0119   E6 E6 9A           LD      P0CONH,#10011010B       ; Port 0 Control Register (High Byte)
  192                                                            ; [.7-.6] Port, P0.7/ADC7 Configuration Bits
  193                                                            ; 0 x = Schmitt trigger input
  194                                                            ; 1 0 = Push-pull output
  195                                                            ; 1 1 = A/D converter input (ADC7); schmitt trigger input off
  196                                                            ; [.5-.4] Port 0, P0.6/ADC6/PWM0 Configuration Bits
  197                                                            ; 0 0 = Schmitt trigger input
  198                                                            ; 0 1 = Alternative function: PWM0 output
  199                                                            ; 1 0 = Push-pull output
  200                                                            ; 1 1 = A/D converter input (ADC6); schmitt trigger input off
  201                                                            ; [.3-.2] Port 0, P0.5/ADC5/PWM1 Configuration Bits
  202                                                            ; 0 0 = Schmitt trigger input
  203                                                            ; 0 1 = Alternative function: PWM1 output
  204                                                            ; 1 0 = Push-pull output
  205                                                            ; 1 1 = A/D converter input (ADC5); schmitt trigger input off
  206                                                            ; [.1-.0] Port 0, P0.4/ADC4 Configuration Bits
  207                                                            ; 0 x = Schmitt trigger input
  208                                                            ; 1 0 = Push-pull output
  209                                                            ; 1 1 = A/D converter input (ADC4); schmitt trigger input off
  210  011C   E6 E7 AA           LD     P0CONL,#10101010B        ; Port 0 Control Register (Low Byte)
  211                                                            ; [.7-.6] Port 0, P0.3/ADC3/INT3 Configuration Bits
  212                                                            ; 0 0 = Schmitt trigger input/falling edge interrupt input
  213                                                            ; 0 1 = Alternative function: SDA
  214                                                            ; 1 0 = Push-pull output
  215                                                            ; 1 1 = A/D converter input (ADC3); Schmitt trigger input off
  216                                                            ; [.5-.4] Port 0, P0.2/ADC2/INT2 Configuration Bits
  217                                                            ; 0 0 = Schmitt trigger input/falling edge interrupt input
  218                                                            ; 0 1 = Alternative function: SCK
  219                                                            ; 1 0 = Push-pull output
  220                                                            ; 1 1 = A/D converter input (ADC2); Schmitt trigger input off
  221                                                            ; [.3-.2] Port 0, P0.1/ADC1/INT1 Configuration Bits
  222                                                            ; 0 x = Schmitt trigger input/falling edge interrupt input
  223                                                            ; 1 0 = Push-pull output
  224                                                            ; 1 1 = A/D converter input (ADC1); Schmitt trigger input off
  225                                                            ; [.1-.0] Port 0, P0.0/ADC0/INT0 Configuration Bits
  226                                                            ; 0 x = Schmitt trigger input/falling edge interrupt input
  227                                                            ; 1 0 = Push-pull output
  228                                                            ; 1 1 = A/D converter input (ADC0); Schmitt trigger input off                                    
  229  011F   E6 E8 00            LD     P0PND,#00000000B        ; Port 0 Interrupt Pending Register
  230                             ;LD     P0PUR,#11110000B        ; Port 0 Pull-up Resistor Enable Register
  231  0122   E6 E9 1A            LD     P1CON,#00011010B        ; Port 1 Control Register
  232                                                            ; [.7] Port 1.1 N-Channel Open-Drain Enable Bit
  233                                                            ; 0 = Configure P1.1 as a push-pull output
  234                                                            ; 1 = Configure P1.1 as a n-channel open-drain output
  235                                                            ; [.6] Port 1.0 N-Channel Open-Drain Enable Bit
  236                                                            ; 0 = Configure P1.0 as a push-pull output
  237                                                            ; 1 = Configure P1.0 as a N-channel open-drain output
  238                                                            ; [.5] Not used for S3F8S28/F8S24
  239                                                            ; [.4] Port 1.2 Configuration Bit
  240                                                            ; 0 = Schmitt trigger input;
  241                                                            ; 1 = Open-drain output
  242                                                            ; [.3-.2] Port 1, P1.1 Configuration Bits
  243                                                            ; 0 0 = Schmitt trigger input;
  244                                                            ; 0 1 = Schmitt trigger input; pull-up enable
  245                                                            ; 1 0 = Push-pull output
  246                                                            ; 1 1 = Schmitt trigger input; pull-down enable
  247                                                            ; [.1-.0] Port 1, P1.0 Configuration Bits
  248                                                            ; 0 0 = Schmitt trigger input;
  249                                                            ; 0 1 = Schmitt trigger input; pull-up enable
  250                                                            ; 1 0 = Push-pull output
  251                                                            ; 1 1 = Schmitt trigger input; pull-down enable
  252  0125   E6 EA 4A            LD     P2CONH,#01001010B       ; Port 2 Control Register (High Byte)
  253                                                            ; [.7] Not used in S3F8S28/F8S24
  254                                                            ; [.6-.4] Port 2, P2.6/ADC8/CLO Configuration Bits
  255                                                            ; 0 0 x = Schmitt trigger input
  256                                                            ; 0 1 x = ADC input
  257                                                            ; 1 0 0 = Push-pull output
  258                                                            ; 1 0 1 = Open-drain output; pull-up enable
  259                                                            ; 1 1 0 = Open-drain output
  260                                                            ; 1 1 1 = Alternative function; CLO output
  261                                                            ; [.3-.2] Port 2, P2.5/ADC9 Configuration Bits
  262                                                            ; 0 0 = Schmitt trigger input
  263                                                            ; 0 1 = Alternative function: ADC Input
  264                                                            ; 1 0 = Push-pull output
  265                                                            ; 1 1 = Invalid
  266                                                            ; [ 1-.0] Port 2, P2.4/ADC10 Configuration Bits
  267                                                            ; 0 0 = Schmitt trigger input
  268                                                            ; 0 1 = Alternative function: ADC Input
  269                                                            ; 1 0 = Push-pull output
  270                                                            ; 1 1 = Invalid
  271  0128   E6 EB 5A            LD     P2CONL,#01011010B       ; Port 2 Control Register (Low Byte)
  272                                                            ; [.7-.6] Port 2, P2.3/TxD Configuration Bits
  273                                                            ; 0 0 = Schmitt trigger input
  274                                                            ; 0 1 = Alternative function: TxD output
  275                                                            ; 1 0 = Push-pull output
  276                                                            ; 1 1 = Open-drain output
  277                                                            ; [.5-.4] Port 2, P2.2/T1CAP/RxD Configuration Bits
  278                                                            ; 0 0 = Schmitt trigger input; T1 Capture input; RxD input;
  279                                                            ; 0 1 = Alternative function: RxD output
  280                                                            ; 1 0 = Push-pull output
  281                                                            ; 1 1 = Open-drain output
  282                                                            ; [.3-.2] Port 2, P2.1/T1OUT Configuration Bits
  283                                                            ; 0 0 = Schmitt trigger input
  284                                                            ; 0 1 = Alternative function: T1 match output
  285                                                            ; 1 0 = Push-pull output
  286                                                            ; 1 1 = Open-drain output
  287                                                            ; [.1-.0] Port 2, P2.0/T0OUT Configuration Bits
  288                                                            ; 0 0 = Schmitt trigger input
  289                                                            ; 0 1 = Alternative function: T0 match output
  290                                                            ; 1 0 = Push-pull output
  291                                                            ; 1 1 = Open-drain output
  292  012B   E6 E4 00            LD     P2PUR,#00000000B        ; Port 2 Pull-up Resistor Enable Register
  293                             ;LD     P3CON,#00000000B        ; Port 3 Control Register
  294                                                            ; [.7-.6] Port 3, P3.3/INT7 Configuration Bits
  295                                                            ; 0 0 = Schmitt trigger input / external falling edge interrupt input
  296                                                            ; 0 1 = Schmitt trigger input with pull-up / external falling edge interrupt input
  297                                                            ; 1 x = Push-pull output
  298                                                            ; [.5-.4] Port 3, P3.2/INT6 Configuration Bits
  299                                                            ; 0 0 = Schmitt trigger input / external falling edge interrupt input
  300                                                            ; 0 1 = Schmitt trigger input with pull-up / external falling edge interrupt input
  301                                                            ; 1 x = Push-pull output
  302                                                            ; [.3-.2] Port 3, P3.1/ADC12/INT5 Configuration Bits
  303                                                            ; 0 0 = Schmitt trigger input / external falling edge interrupt input
  304                                                            ; 0 1 = Schmitt trigger input with pull-up / external falling edge interrupt input
  305                                                            ; 1 0 = Push-pull output
  306                                                            ; 1 1 = Alternative function: ADC Input
  307                                                            ; [.1-.0] Port 3, P3.0/ADC11/INT4 Configuration Bits
  308                                                            ; 0 0 = Schmitt trigger input / external falling edge interrupt input
  309                                                            ; 0 1 = Schmitt trigger input with pull-up / external falling edge interrupt input
  310                                                            ; 1 0 = Push-pull output
  311                                                            ; 1 1 = Alternative function: ADC Input
  312                            ;LD      P3PND, #000000000B      ; Port 3 Interrupt Pending Register
  313                                                            ; [.7] Port 3.3/ADC12/INT7, Interrupt Enable Bit
  314                                                            ; 0 = INT7 falling edge interrupt disable
  315                                                            ; 1 = INT7 falling edge interrupt enable
  316                                                            ; [.6] Port 3.3/ADC12/INT7 Interrupt Pending Bit
  317                                                            ; 0 = No interrupt pending (when read)
  318                                                            ; 0 = Pending bit clear (when write)
  319                                                            ; 1 = Interrupt is pending (when read)
  320                                                            ; 1 = No effect (when write)
  321                                                            ; [.5] Port 3.2/ADC11/INT6, Interrupt Enable Bit
  322                                                            ; 0 = INT6 falling edge interrupt disable
  323                                                            ; 1 = INT6 falling edge interrupt enable
  324                                                            ; [.4] Port 3.2/ADC11/INT6, Interrupt Pending Bit
  325                                                            ; 0 = No interrupt pending (when read)
  326                                                            ; 0 = Pending bit clear (when write)
  327                                                            ; 1 = Interrupt is pending (when read)
  328                                                            ; 1 = No effect (when write)
  329                                                            ; [.3] Port 3.1/ADC10/INT5, Interrupt Enable Bit
  330                                                            ; 0 = INT5 falling edge interrupt disable
  331                                                            ; 1 = INT5 falling edge interrupt enable
  332                                                            ; [.2] Port 3.1/ADC10/INT5, Interrupt Pending Bit
  333                                                            ; 0 = No interrupt pending (when read)
  334                                                            ; 0 = Pending bit clear (when write)
  335                                                            ; 1 = Interrupt is pending (when read)
  336                                                            ; 1 = No effect (when write)
  337                                                            ; [.1] Port 3.0/ADC9/INT4, Interrupt Enable Bit
  338                                                            ; 0 = INT4 falling edge interrupt disable
  339                                                            ; 1 = INT4 falling edge interrupt enable
  340                                                            ; [.0] Port 3.0/ADC9/INT4, Interrupt Pending Bit
  341                                                            ; 0 = No interrupt pending (when read)
  342                                                            ; 0 = Pending bit clear (when write)
  343                                                            ; 1 = Interrupt is pending (when read)
  344                                                            ; 1 = No effect (when write)
  345                                                                   
  346  012E   5F                 SB1
  347  012F   E6 F5 53           LD      UARTCON,#01010011B      ; UART Control Register
  348                                                            ; bit 7-6: Operating mode and baud rate selection bits
  349                                                            ; 0 0 -> mode 0 Shift register fxx/(16 x (BRDATA +1))
  350                                                            ; 0 1 -> mode 1 8-bit UART fxx/(16 x (BRDATA +1))
  351                                                            ; 1 0 -> mode 2 9-bit UART fxx/16
  352                                                            ; 1 1 -> 9-bit UART fxx/(16 x (BRDATA +1))
  353                                                            ; bit 5: Multiprocessor communication enable bit (for modes 2 and 3 only)
  354                                                            ; 0 = Disable
  355                                                            ; 1 = Enable
  356                                                            ; bit 4: Serial data receive enable bit
  357                                                            ; 0 = Disable
  358                                                            ; 1 = Enable
  359                                                            ; bit 3: Location of the 9th data bit to be transmitted in UART mode 2 or 3 ("0" or "1")
  360                                                            ; bit 2: Location of the 9th data bit that was received in UART mode 2 or 3 ("0" or "1")
  361                                                            ; bit 1: Received interrupt enable bit
  362                                                            ; 0 = Disable
  363                                                            ; 1 = Enable
  364                                                            ; bit 0: Transmit interrupt enable bit
  365                                                            ; 0 = Disable
  366                                                            ; 1 = Enable
  367  0132   E6 F6 00           LD      UARTPND,#00000000B      ; UART Pending Register
  368                                                            ; bit 7-2: Not used
  369                                                            ; bit 1: UART receive interrupt pending flag
  370                                                            ; 0 = Not pending
  371                                                            ; 0 = Clear pending bit (when write)
  372                                                            ; 1 = Interrupt pending
  373                                                            ; bit 0: UART transmit interrupt pending flag
  374                                                            ; 0 = Not pending
  375                                                            ; 0 = Clear pending bit (when write)
  376                                                            ; 1 = Interrupt pending
  377  0135   E6 F7 33           LD      BRDATA,#33H             ; UART Baud Rate Data Register
  378                                                            ; Mode 0 baud rate = fxx/(16 x (8-bit BRDATA + 1))
  379                                                            ; Mode 1 baud rate = fxx/(16 x (8-bit BRDATA + 1))
  380                                                            ; Mode 2 baud rate = fxx/16
  381                                                            ; Mode 3 baud rate = fxx/(16 x (8-bit BRDATA + 1))
  382  0138   4F                 SB0
  383                            
  384  0139   E6 F3 10           LD      PWM0CON,#00010000B      ; PWM Control Registers
  385                                                            ; bit 7-6: PWM input clock selection bits
  386                                                            ; 00 = fosc/64
  387                                                            ; 01 = fosc/8
  388                                                            ; 10 = fosc/2
  389                                                            ; 11 = fosc/1
  390                                                            ; bit 5: Not Used
  391                                                            ; bit 4: PWMDATA reload interval selection bit
  392                                                            ; 0 = Reload from extension up counter overflow
  393                                                            ; 1 = Reload from base up counter overflow
  394                                                            ; bit 3: PWM counter clear bit
  395                                                            ; 0 = No effect
  396                                                            ; 1 = Clear the PWM counter (When write)
  397                                                            ; bit 2: PWM counter enable bit
  398                                                            ; 0 = Stop counter
  399                                                            ; 1 = Start (resume countering)
  400                                                            ; bit 1: PWM counter interrupt enable bit
  401                                                            ; 0 = Disable PWM OVF interrupt
  402                                                            ; 1 = Enable PWM OVF interrupt
  403                                                            ; bit 0: PWM extension counter OVF Interrupt pending bit
  404                                                            ; 0 = No interrupt pending
  405                                                            ; 0 = Clear pending condition (when write)
  406                                                            ; 1 = Interrupt is pending
  407  013C   E6 F1 00           LD      PWM0EX,#00000000B       ; PWM Extension Registers
  408                                                            ; bit 7-2: PWM Extension bits
  409                                                            ; bit 7-6: For 6 + 2 resolution
  410                                                            ; bit 7-2: For 6 + 6 and 8 + 6 resolutions
  411                                                            ; bit 1-0: PWM resolution selection bits
  412                                                            ; x0 = 12-bit PWM: 6 + 6 resolution
  413                                                            ; 01 = 8-bit PWM: 6 + 2 resolution
  414                                                            ; 11 = 14-bit PWM: 8 + 6 resolution
  415  013F   E6 F2 00           LD      PWM0DATA,#00H
  416                            
  417  0142   E6 00 00           LD      uart_status,#00H
  418                            
  419  0145   9F                 EI
  420                    
  421                    ;;=======================================================================
  422                    ;;==      Main function                                                ==
  423                    ;;==                                                                   ==
  424                    ;;==                                                                   == 
  425                    ;;=======================================================================
  426  0146              MAIN::
  427  0146   46 D3 02           OR      BTCON,#02H              ; Enable watchdog function
  428                                                            ; Basic counter (BTCNT) clear
  429                                                            
  430                                                            
  431                            
  432                            
  433  0149   0C 01              LD      R0,#01H
  434  014B   1C 00              LD      R1,#00H
  435  014D   F6 01 F4           CALL    PWM0                           
  436                            
  437  0150   F6 01 B1           CALL    DELAY_10s
  438                            
  439  0153   0C 3F              LD      R0,#3FH
  440  0155   1C 00              LD      R1,#00H
  441  0157   F6 01 F4           CALL    PWM0
  442                            
  443  015A   F6 01 B1           CALL    DELAY_10s
  444                                                                                        
  445  015D   8D 01 46           JP      MAIN                                
  446                    
  447                    ;;=======================================================================
  448                    ;;==      SUBROUTINEs                                                  ==
  449                    ;;==                                                                   ==
  450                    ;;==                                                                   == 
  451                    ;;=======================================================================
  452  0160              DELAY_1ms:
  453  0160   70 C1              PUSH    R1
  454  0162   1C A6              LD      R1,#0A6H
  455  0164              DELAY_LOOP_1ms:
  456  0164   FF                 NOP
  457  0165   FF                 NOP
  458  0166   FF                 NOP
  459  0167   FF                 NOP
  460  0168   FF                 NOP
  461  0169   FF                 NOP
  462  016A   FF                 NOP
  463  016B   FF                 NOP
  464  016C   FF                 NOP
  465  016D   FF                 NOP     
  466  016E   1A F4              DJNZ    R1,DELAY_LOOP_1ms
  467  0170   50 C1              POP     R1
  468                            
  469  0172   AF                 RET      
  470                    
  471  0173              DELAY_10ms:
  472  0173   70 C1              PUSH    R1
  473  0175   70 C2              PUSH    R2
  474  0177   1C 14              LD      R1,#014H
  475  0179              DELAY_LOOP_10ms_R1:
  476  0179   2C 53              LD      R2,#053H
  477  017B              DELAY_LOOP_10ms_R2:
  478  017B   FF                 NOP
  479  017C   FF                 NOP
  480  017D   FF                 NOP
  481  017E   FF                 NOP
  482  017F   FF                 NOP
  483  0180   FF                 NOP
  484  0181   FF                 NOP
  485  0182   FF                 NOP
  486  0183   FF                 NOP
  487  0184   FF                 NOP
  488  0185   2A F4              DJNZ    R2,DELAY_LOOP_10ms_R2     
  489  0187   1A F0              DJNZ    R1,DELAY_LOOP_10ms_R1
  490  0189   50 C2              POP     R2
  491  018B   50 C1              POP     R1
  492                            
  493  018D   AF                 RET
  494                    
  495  018E              DELAY_1s:
  496  018E   70 C1              PUSH    R1
  497  0190   70 C2              PUSH    R2
  498  0192   70 C3              PUSH    R3
  499  0194   1C 43              LD      R1,#043H
  500  0196              DELAY_LOOP_1s_R1:
  501  0196   2C 0C              LD      R2,#00CH
  502  0198              DELAY_LOOP_1s_R2:
  503  0198   3C CF              LD      R3,#0CFH
  504  019A              DELAY_LOOP_1s_R3:
  505  019A   FF                 NOP
  506  019B   FF                 NOP
  507  019C   FF                 NOP
  508  019D   FF                 NOP
  509  019E   FF                 NOP
  510  019F   FF                 NOP
  511  01A0   FF                 NOP
  512  01A1   FF                 NOP
  513  01A2   FF                 NOP
  514  01A3   FF                 NOP
  515  01A4   3A F4              DJNZ    R3,DELAY_LOOP_1s_R3
  516  01A6   2A F0              DJNZ    R2,DELAY_LOOP_1s_R2     
  517  01A8   1A EC              DJNZ    R1,DELAY_LOOP_1s_R1
  518  01AA   50 C3              POP     R3
  519  01AC   50 C2              POP     R2
  520  01AE   50 C1              POP     R1
  521                            
  522  01B0   AF                 RET
  523                    
  524  01B1              DELAY_10s:
  525  01B1   70 C1              PUSH    R1
  526  01B3   70 C2              PUSH    R2
  527  01B5   70 C3              PUSH    R3
  528  01B7   70 C4              PUSH    R4
  529  01B9   1C DF              LD      R1,#0DFH
  530  01BB              DELAY_LOOP_10s_R1:
  531  01BB   2C 04              LD      R2,#004H
  532  01BD              DELAY_LOOP_10s_R2:
  533  01BD   3C 42              LD      R3,#042H
  534  01BF              DELAY_LOOP_10s_R3:
  535  01BF   4C 15              LD      R4,#015H
  536  01C1              DELAY_LOOP_10s_R4:
  537  01C1   FF                 NOP
  538  01C2   FF                 NOP
  539  01C3   FF                 NOP
  540  01C4   FF                 NOP
  541  01C5   FF                 NOP
  542  01C6   FF                 NOP
  543  01C7   FF                 NOP
  544  01C8   FF                 NOP
  545  01C9   FF                 NOP
  546  01CA   FF                 NOP
  547  01CB   4A F4              DJNZ    R4,DELAY_LOOP_10s_R4
  548  01CD   3A F0              DJNZ    R3,DELAY_LOOP_10s_R3
  549  01CF   2A EC              DJNZ    R2,DELAY_LOOP_10s_R2     
  550  01D1   1A E8              DJNZ    R1,DELAY_LOOP_10s_R1
  551  01D3   50 C4              POP     R4
  552  01D5   50 C3              POP     R3
  553  01D7   50 C2              POP     R2
  554  01D9   50 C1              POP     R1
  555                            
  556  01DB   AF                 RET
  557                                                    
  558  01DC              UART_TX:
  559  01DC   70 C1              PUSH    R1
  560  01DE              UART_TX_CHECK:
  561  01DE   18 00              LD      R1,uart_status
  562  01E0   37 11 FB           BTJRT   UART_TX_CHECK,R1.0      ; wait until tx finish
  563  01E3   5F                 SB1
  564  01E4   09 F8              LD      UDATA,R0    
  565  01E6   4F                 SB0
  566  01E7   46 00 01           OR      uart_status,#00000001B    
  567  01EA   50 C1              POP     R1
  568                            
  569  01EC   AF                 RET
  570                            
  571  01ED              TIMER_A:
  572  01ED   E6 D1 50           LD      TADATA,#50H             ; CPU = 8mMHz, interrupt interval = 3.2msec
  573  01F0   E6 D2 0E           LD      TACON,#00001110B        ; fsoc/256, timer A interrupt enable
  574                            
  575  01F3   AF                 RET       
  576                    
  577  01F4              PWM0:
  578  01F4   09 F2              LD      PWM0DATA,R0
  579  01F6   19 F1              LD      PWM0EX,R1
  580  01F8   56 F3 F7           AND     PWM0CON,#11110111B      ; clear bit3 (clear counter bit, no effect) set to '0' to avoid clear counter
  581  01FB   46 F3 04           OR      PWM0CON,#00000100B      ; PWM start run (if have started, then no effect, keep running)
  582                            
  583  01FE   AF                 RET
  584                    
  585  01FF              VE209S_TRS:
  586                    ; Binary interface for VE209S
  587                    ; 02 is the <STX>
  588                    ; 00 04 is the size_of_the_packet (4 bytes)
  589                    ; 31 32 33 34 are the 4 bytes of the payload
  590                    ; 03 is the <ETX>
  591  01FF   0C 02              LD      R0,#02H
  592  0201   F6 01 DC           CALL    UART_TX
  593  0204   0C 00              LD      R0,#00H
  594  0206   F6 01 DC           CALL    UART_TX
  595  0209   0C 04              LD      R0,#04H
  596  020B   F6 01 DC           CALL    UART_TX
  597  020E   0C 31              LD      R0,#31H
  598  0210   F6 01 DC           CALL    UART_TX
  599  0213   0C 32              LD      R0,#32H
  600  0215   F6 01 DC           CALL    UART_TX
  601  0218   0C 33              LD      R0,#33H
  602  021A   F6 01 DC           CALL    UART_TX    
  603  021D   0C 34              LD      R0,#34H
  604  021F   F6 01 DC           CALL    UART_TX 
  605  0222   0C 03              LD      R0,#03H
  606  0224   F6 01 DC           CALL    UART_TX
  607                            
  608  0227   AF                 RET                                                                                                                                                                                                                                           
  609                    ;;=======================================================================
  610                    ;;==      INTERRUPT SERVICE ROUTINE                                    ==
  611                    ;;==                                                                   ==
  612                    ;;==                                                                   == 
  613                    ;;=======================================================================                                                                                
  614                           ;;----------------------------------------
  615                           ;;     external interrupt 0
  616                           ;;----------------------------------------
  617  0228              EX_INT0:
  618  0228   56 E8 FF          AND     P0PND, #11111111B                       ;clear pending bit
  619  022B   8D 02 A6          JP      INT_ISR_END        
  620                           ;;----------------------------------------
  621                           ;;     external interrupt 1
  622                           ;;----------------------------------------
  623  022E              EX_INT1:
  624  022E   56 E8 FF           AND     P0PND, #11111111B                       ;clear pending bit
  625  0231   8D 02 A6           JP      INT_ISR_END
  626                           ;;----------------------------------------
  627                           ;;     external interrupt 2
  628                           ;;----------------------------------------
  629  0234              EX_INT2:
  630                            ;XOR     P0,#00100000B                           ;toggle P0.5 
  631  0234   56 E8 EF           AND     P0PND, #11101111B                       ;clear pending bit
  632  0237   8D 02 A6           JP      INT_ISR_END
  633                            ;;----------------------------------------
  634                           ;;     external interrupt 3
  635                           ;;----------------------------------------
  636  023A              EX_INT3:
  637                            ;XOR     P0,#00010000B                           ;toggle P0.4 
  638  023A   56 E8 BF           AND     P0PND, #10111111B                       ;clear pending bit
  639  023D   8D 02 A6           JP      INT_ISR_END
  640                            ;;----------------------------------------
  641                           ;;     external interrupt 4
  642                           ;;----------------------------------------
  643  0240              EX_INT4:
  644                            ;XOR     P0,#10000000B                           ;toggle P0.7 
  645  0240   56 EF FE           AND     P3PND, #11111110B                       ;clear pending bit
  646  0243   8D 02 A6           JP      INT_ISR_END
  647                            ;;----------------------------------------
  648                           ;;     external interrupt 5
  649                           ;;----------------------------------------
  650  0246              EX_INT5:
  651                            ;XOR     P0,#01000000B                           ;toggle P0.6 
  652  0246   56 EF FB           AND     P3PND, #11111011B                       ;clear pending bit
  653  0249   8D 02 A6           JP      INT_ISR_END
  654                            ;;----------------------------------------
  655                           ;;     external interrupt 6
  656                           ;;----------------------------------------
  657  024C              EX_INT6:
  658                            ;XOR     P0,#00100000B                           ;toggle P0.5 
  659  024C   56 EF EF           AND     P3PND, #11101111B                       ;clear pending bit
  660  024F   8D 02 A6           JP      INT_ISR_END
  661                            ;;----------------------------------------
  662                           ;;     external interrupt 7
  663                           ;;----------------------------------------
  664  0252              EX_INT7:
  665                            ;XOR     P0,#00010000B                           ;toggle P0.4 
  666  0252   56 EF BF           AND     P3PND, #10111111B                       ;clear pending bit
  667  0255   8D 02 A6           JP      INT_ISR_END
  668                            
  669                           ;;----------------------------------------
  670                           ;;     Timer0/A match interrupt
  671                           ;;----------------------------------------  
  672  0258              T0_A_MC_INT:
  673                            ;XOR     P0,#10000000B                           ;toggle P0.7
  674  0258   56 D2 FE           AND     TACON,#11111110B                        ;clear pending bit
  675  025B   8D 02 A6           JP      INT_ISR_END 
  676                           ;;----------------------------------------
  677                           ;;     TimerB match interrupt
  678                           ;;---------------------------------------- 
  679  025E              TB_MC_INT:
  680                            ;XOR     P0,#01000000B                           ;toggle P0.6
  681  025E   56 EE FE           AND     TBCON,#11111110B                        ;clear pending bit
  682  0261   8D 02 A6           JP      INT_ISR_END
  683                           ;;----------------------------------------
  684                           ;;     PWM1 Overflow interrupt 
  685                           ;;----------------------------------------
  686  0264              PWM1_OVF_INT:
  687                            ;XOR     P0,#01000000B                           ;toggle P0.6
  688  0264   5F                 SB1
  689  0265   56 E8 F6           AND     PWM1CON,#11110110B                       ;clear pending bit
  690  0268   4F                 SB0
  691  0269   8D 02 A6           JP      INT_ISR_END
  692                           ;;----------------------------------------
  693                           ;;     PWM0 Overflow interrupt 
  694                           ;;----------------------------------------
  695  026C              PWM0_OVF_INT:
  696                            ;XOR     P0,#00100000B                           ;toggle P0.5
  697  026C   56 F3 F6           AND     PWM0CON,#11110110B                       ;clear pending bit
  698  026F   8D 02 A6           JP      INT_ISR_END
  699                           ;;----------------------------------------
  700                           ;;     Timer1 match interrupt
  701                           ;;----------------------------------------  
  702  0272              TIMER1_MC_INT:
  703                            ;XOR     P0,#00100000B                            ;toggle P0.5
  704  0272   5F                 SB1
  705  0273   56 E4 FE           AND     T1CON,#11111110B                         ;clear pending bit
  706  0276   4F                 SB0
  707  0277   8D 02 A6           JP      INT_ISR_END 
  708                           ;;----------------------------------------
  709                           ;;     Timer1 Overflow interrupt
  710                           ;;----------------------------------------  
  711  027A              TIMER1_OVF_INT:
  712                            ;XOR     P0,#00010000B                            ;toggle P0.4
  713  027A   5F                 SB1
  714  027B   56 E4 FB           AND     T1CON,#11111011B                         ;clear pending bit
  715  027E   4F                 SB0
  716  027F   8D 02 A6           JP      INT_ISR_END
  717                           ;;----------------------------------------
  718                           ;;     Low voltage detector interrupt
  719                           ;;---------------------------------------- 
  720  0282              LVD_INT:
  721                            ;SB0
  722                            ;AND      P0,#11110111B                            ;light P0.3
  723  0282   5F                 SB1
  724  0283   56 F4 EF           AND     LVDCON, #11101111B                       ;disable interrupt
  725  0286   4F                 SB0
  726  0287   8D 02 A6           JP      INT_ISR_END              
  727                           ;;----------------------------------------
  728                           ;;     UART interrupt
  729                           ;;---------------------------------------- 
  730  028A              UART_TRS_INT:
  731  028A   5F                 SB1
  732  028B   56 00 FE           AND     uart_status,#11111110B
  733  028E   56 F6 FE           AND     UARTPND, #11111110B                      ;clear pending bit
  734  0291   4F                 SB0
  735  0292   8D 02 A6           JP      INT_ISR_END
  736  0295              UART_RV_INT:
  737  0295   5F                 SB1
  738  0296   56 F6 FD           AND     UARTPND, #11111101B                      ;clear pending bit
  739  0299   4F                 SB0
  740  029A   8D 02 A6           JP      INT_ISR_END
  741                           ;;----------------------------------------
  742                           ;;     IIC interrupt
  743                           ;;---------------------------------------- 
  744  029D              IIC_INT:
  745  029D   8D 02 A6           JP      INT_ISR_END
  746                           ;;----------------------------------------
  747                           ;;     Watchdog  interrupt
  748                           ;;---------------------------------------- 
  749  02A0              WDT_INT:
  750                            ;XOR     P3,#00000001B                           ;toggle P3.0
  751                            ;AND      WDTCON, #10111111B                    ;disable reset, clear counter
  752  02A0   46 F6 10           OR      WDTCON, #00010000B                      ;clear counter.      
  753  02A3   8D 02 A6           JP      INT_ISR_END       
  754                    
  755                    
  756                    
  757                           ;;----------------------------------------
  758                           ;;     interrupt service end
  759                           ;;----------------------------------------        
  760  02A6              INT_ISR_END:                
  761  02A6   BF                IRET
  762                           
  763  02A7              .END                                                          


Total 757 Lines Assembled - 0 Errors, 0 Warnings
Total code size 0x1D1


