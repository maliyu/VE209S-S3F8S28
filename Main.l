Wed Sep 04 09:34:13 2013
                              
     SAM8 Assembler Ver. 2.15T(Win32) Copyright (c) 2003 Samsung Electronics Co.
                             
    --------------------------------------------------------------------
                       Source File Name : Main.src
                       Output File Name : Main.o
                       List File Name   : Main.l
    1                    ;************************************************************************
    2                    ;************************************************************************
    3                    ;***********************  8S24 IDD Main.src    ****************************
    4                    ;************************************************************************
    5                    ;************************************************************************ 
    6                    ;-----------------------File description--------------------------------- 
    7                    ;         Test Program Entrance 
    8                    ;         Main function
    9                    ;         IDD
   10                    ;------------------------------------------------------------------------
   11                    ;------------------------Function list-----------------------------------
   12                    ;    --Function name--   |     --Type--        |       --Description--
   13                    ;     SMART OPTION                  sector              Smart option setting
   14                    ;     Interrupt vector              sector              Interrupt vector
   15                    ;     RESET                         reset function      initialization code
   16                    ;     MAIN                          main function       main test function
   17                    ;     Interrupt sevice routine      sub function        interrupt sources
   18                    ;------------------------------------------------------------------------
   19                    ;------------------------File   information------------------------------
   20                    ;    @author@:   Li Baoke
   21                    ;    @date@:     10-04-28            
   22                    ;    @version@:  00             
   23                    ;    @change record@:     
   24                    ;          --date--       |         --content--         |     --who--
   25                    ;         10-04-14               Basic Frame                    Li       
   26                    ;------------------------------------------------------------------------
   27                    ;************************************************************************
   28                    ;************************************************************************
   29                    ;************************************************************************
   30                    .INCLUDE "S3F8S28.reg"
   31                    ; S3F8S28.reg of OPENice
   32                    ;	Created on Sep.10. 2010
   33                    ;	Copyright (c) 2010 YIC System CO., Ltd.
   34                    
   35                    	.list   on
   36                    
   37  0000                      .ORG    0000H
   38                    ;;=======================================================================
   39                    ;;==                                                                   ==
   40                    ;;==                SMART OPTION Setting  ROUTINE                      ==
   41                    ;;==                                                                   == 
   42                    ;;=======================================================================
   43  003C                     .ORG  003CH
   44  003C   FF                .DB   0FFH
   45  003D   FF                .DB   0FFH
   46  003E   84                .DB   10000100B          ;@3EH : ISP options
   47                                                                 ; bit7: Reset vector address change enable/disable
   48                                                                 ;    0-change address   
   49                                                                 ;    1-normal: 100H
   50                                                                 ; bit6~5: reset vector address
   51                                                                 ;      @00B---200H         
   52                                                                 ;      @01B---300H
   53                                                                 ;      @10B---500H
   54                                                                 ;      @11B---900H
   55                                                                 ; bit4-3: not used
   56                                                                 ; bit2: ISP protection enable/disable
   57                                                                 ;    1-disable  
   58                                                                 ;    0-enable
   59                                                                 ; bit1-0: ISP protection size
   60                                                                 ;      @00B---256B         
   61                                                                 ;      @01B---512B
   62                                                                 ;      @10B---1024B
   63                                                                 ;      @11B---2048B        
   64  003F   1F                .DB   00011111B          ;@3FH :LVR, level, P1.2; OSC;
   65                                                                 ; bit 7: LVR Enable/disable
   66                                                                 ;    0-disable  
   67                                                                 ;    1-enable
   68                                                                 ; bit 6-5: LVR level
   69                                                                 ;      @00B---1.9V         
   70                                                                 ;      @01B---2.3V
   71                                                                 ;      @10B---3.0V
   72                                                                 ;      @11B---3.9V
   73                                                                 ; bit 4: P1.2/RESET pin selection
   74                                                                 ;    0-P1.2 pin enable  
   75                                                                 ;    1-RESET Pin enable
   76                                                                 ; bit 3-0: Oscillator selection bit
   77                                                                 ;      @0100B---External LG OSC         
   78                                                                 ;      @1100B---External HG OSC
   79                                                                 ;      @1010B---internal RC(1 M)
   80                                                                 ;      @1111B---internal RC(8 M)
   81                                                                 ;      @1000B---internal RC(0.5 M)
   82                                                                 ;      @1001B---internal RC(2 M)
   83                                                                 ;      @1011B---internal RC(4 M)
   84                    ;;=======================================================================
   85                    ;;==                                                                   ==
   86                    ;;==            INTERRUPT VECTOR                                       ==
   87                    ;;==                                                                   == 
   88                    ;;=======================================================================
   89  00D8   02 2E             .VECTOR  0D8H, EX_INT7
   90  00DA   02 25             .VECTOR  0DAH, EX_INT6
   91  00DC   02 1C             .VECTOR  0DCH, EX_INT5
   92  00DE   02 13             .VECTOR  0DEH, EX_INT4
   93  00E0   02 8F             .VECTOR  0E0H, IIC_INT
   94  00E2   02 87             .VECTOR  0E2H, UART_RV_INT
   95  00E4   02 7F             .VECTOR  0E4H, UART_TRS_INT
   96  00E6   02 92             .VECTOR  0E6H, WDT_INT
   97  00E8   02 73             .VECTOR  0E8H, LVD_INT
   98  00EA   02 68             .VECTOR  0EAH, TIMER1_OVF_INT
   99  00EC   02 5D             .VECTOR  0ECH, TIMER1_MC_INT
  100  00F0   02 49             .VECTOR  0F0H, PWM1_OVF_INT
  101  00F2   02 54             .VECTOR  0F2H, PWM0_OVF_INT
  102  00F4   02 40             .VECTOR  0F4H, TB_MC_INT
  103  00F6   02 37             .VECTOR  0F6H, T0_A_MC_INT
  104  00F8   02 0A             .VECTOR  0F8H, EX_INT3
  105  00FA   02 01             .VECTOR  0FAH, EX_INT2
  106  00FC   01 FB             .VECTOR  0FCH, EX_INT1
  107  00FE   01 F5             .VECTOR  0FEH, EX_INT0                                            
  108                    ;;=======================================================================
  109                    ;;==                                                                   ==
  110                    ;;==            RESET and Initialization code                          ==
  111                    ;;==                                                                   == 
  112                    ;;=======================================================================
  113                    
  114  0100                     .ORG    0100H
  115  0100              RESET:
  116  0100   8F                 DI
  117  0101   E6 D4 18           LD     CLKCON,#00011000B            ;Bit7: osc IRQ wakeup function Enable:
  118                                                                ;      1--disable     
  119                                                                ;      0--enable 
  120                                                                ;Bit4~3:  CPU clock selection:
  121                                                                ;      00-Fosc/16
  122                                                                ;      01-Fosc/8
  123                                                                ;      10-Fosc/2
  124                                                                ;      11-Fosc      
  125  0104   E6 F5 00           LD     ROSCCON,#00000000B            ;bit 7: Ring OSC enable bit
  126                                                                ;  1- enable;   0- disable
  127                                                                ;bit 6: free running timer1 clock selection
  128                                                                ;  1-Ring OSC;  0- system clock.
  129  0107   E6 D3 A3           LD     BTCON,#10100011B             ;Bit7~4: watch Timer function Disable:
  130                                                                ;      1010--disable  
  131                                                                ;      others -- enable 
  132                                                                ;Bit3~2: basic timer clock select:
  133                                                                ;   00-Fosc/4096       01-Fosc/1024
  134                                                                ;   10-Fosc/128        11-invalid
  135                                                                ;Bit1:   counter clear 
  136                                                                ;   1--clear        0--no effect
  137                                                                ;Bit0:   divider clear
  138                                                                ;   1--clear        0--no effect             
  139  010A   E6 D9 FF           LD     SPL,#0FFH                     ;Stack Pointer to the top of RAM
  140  010D   E6 DD FF           LD     IMR,#11111111B               ;Bit7~0: Interrupt mask bit (enable all interrupt)
  141                                                                ;    1-enable interrupt   
  142                                                                ;    0-disable interrupt
  143  0110   E6 FF 10           LD     IPR,#00010000B               ;IRQ0>IRQ1>IRQ2
  144  0113   E6 E6 AA           LD     P0CONH,#10101010B            ;P0.7-P0.4 configuration
  145                                                                ;  Bit(7-2x)~(7-2x-1): P0.(7-x)(x=0-3)configuration bit
  146                                                                ;   00-schmitt trigger input
  147                                                                ;   01-Alternative function
  148                                                                ;   10-push-pull output   
  149                                                                ;   11-AD input,schmitt trigeger input off
  150  0116   E6 E7 AA           LD     P0CONL,#10101010B            ;P0.3-P0.0 configuration
  151                                                                ;  Bit(2x+1)~(2x): P0.x(x=0-3) configuration bit
  152                                                                ;   00-schmitt trigger input,interrupt input(P0.1-0)
  153                                                                ;   01-alternative function
  154                                                                ;   10-push-pull output   
  155                                                                ;   11-AD input,schmitt trigeger input off 
  156  0119   E6 E8 00           LD     P0PND,#00000000B             ;bit3,1 interrupt control bit
  157                                                                ;   1-enable interrupt 
  158                                                                ;   0-disable interrup
  159                                                                ;bit 2,0: pending bit clear
  160                                                                ;   1-interrupt is pending(when read)
  161                                                                ;   0-clear pending bit(when write) 
  162  011C   E6 E5 F0           LD     P0PUR, #11110000B            ;bit 7-4: P0.7-4 pull-up enable/disable
  163                                                                ;   0-enable pull-up
  164                                                                ;   1-disable pull-up
  165                                                                ;bit 3-0: P0.3-0 pull-up enable/disable
  166                                                                ;   1-enable pull-up
  167                                                                ;   0-disable pull-up
  168  011F   E6 E0 00           LD     P0,#000H                     ;P0 LED trun off                                                                                                                                                                                   
  169  0122   E6 E9 00           LD     P1CON,#00000000B             ;P1.0 P1.1 configuration:
  170                                                                ;  Bit x~x+1:  P1.x(x=0-1) configuration bit
  171                                                                ;   00-schmitt trigger input
  172                                                                ;   01-schmitt trigger input,pull-up enable
  173                                                                ;   10-output   
  174                                                                ;   11-schmitt trigger input,pull-down enable 
  175                                                                ;  Bit 6+x:  P1.x(x=0-1) output config
  176                                                                ;   0-push-pull output
  177                                                                ;   1-n-channel open-drain output
  178                                                                ;  When using external oscillator,P1.1&P1.0must be set to 
  179                                                                ;   output port to prevent current consumption.
  180  0125   E6 EA 4A           LD      P2CONH,#01001010B            ;P2.6-P2.4 configuration:
  181                                                                ;  Bit 6~4 : P2.6 config
  182                                                                ;   00x-schmit input
  183                                                                ;   01x-ADC input                 100-push-pull output 
  184                                                                ;   101-open-drain output,pull-up 110-open-drain output
  185                                                                ;   111-Alternative function,CLO output
  186                                                                ;  Bit 3~2:P2.5 config,  Bit 1~0:P2.4 config
  187                                                                ;   00-schmitt trigger input
  188                                                                ;   01-alternative function
  189                                                                ;   10-push-pull output   
  190                                                                ;   11-open-drain output
  191  0128   E6 EB 4A           LD      P2CONL,#01001010B            ;P2.3-P2.0 configuration:
  192                                                                ;  Bit(2x+1)~(2x): P0.x(x=0-3) configuration bit
  193                                                                ;   00-schmitt trigger input
  194                                                                ;   01-alternative function
  195                                                                ;   10-push-pull output   
  196                                                                ;   11-open-drain output
  197  012B   E6 E4 00           LD      P2PUR, #00000000B           ;;bit 6-0: P2.6-0 pull-up enable/disable
  198                                                                ;   0-enable pull-up
  199                                                                ;   1-disable pull-up
  200  012E   E6 E2 FF           LD      P2, #0FFH                   ;LED Turn off.
  201                            
  202  0131   E6 F0 00           LD      P3CON,#00000000B            ;P3 configuration:
  203                                                                ;  Bit x~x+1:  P1.x(x=0-1) configuration bit
  204                                                                ;   00-schmitt trigger input
  205                                                                ;   01-schmitt trigger input,pull-up enable
  206                                                                ;   1x-push-pull output 
  207  0134   E6 EF 00           LD      P3PND, #000000000B          ;P3 Int configuration:
  208                                                                ;   ;bit7,5,3,1 interrupt control bit
  209                                                                ;   1-enable interrupt 
  210                                                                ;   0-disable interrup
  211                                                                ;   bit 6,4,2,0: pending bit clear
  212                                                                ;   1-interrupt is pending(when read)
  213                                                                ;   0-clear pending bit(when write)        
  214  0137   E6 E3 FF           LD      P3, #0FFH                   ;LED Turn off.
  215  013A   E6 D2 00           LD      TACON,#00000000B            ;bit7: Operating mode selection:
  216                                                                ;   0-Two 8-bit timer
  217                                                                ;   1-One 16-bit timer    
  218                                                                ;bit 6: not used, keep as '0'
  219                                                                ;bit 5-4: clock selection bits:
  220                                                                ;    00-fosc/256
  221                                                                ;    01-fosc/64
  222                                                                ;    10-fosc/8
  223                                                                ;    11-fosc
  224                                                                ;bit 3: timer conter clear bit
  225                                                                ;    1-clear counter(when write)
  226                                                                ;bit 2: timer Run enable bit
  227                                                                ;    1-Enbale Run; 0-disable run
  228                                                                ;bit 1: interrupt enable bit
  229                                                                ;    1-enable interrupt
  230                                                                ;    0-interrupt disable 
  231                                                                ;bit0: pending bit
  232                                                                ;    1-penging (when read)
  233                                                                ;    0-clear pending (when write)
  234  013D   E6 EE 00           LD      TBCON, #00000000B           ;bit 7-6: not used
  235                                                                ;bit 5-4: clock selection bits:
  236                                                                ;    00-fosc/256
  237                                                                ;    01-fosc/64
  238                                                                ;    10-fosc/8
  239                                                                ;    11-fosc
  240                                                                ;bit 3: timer conter clear bit
  241                                                                ;    1-clear counter(when write)
  242                                                                ;bit 2: timer Run enable bit
  243                                                                ;    1-Enbale Run; 0-disable run
  244                                                                ;bit 1: interrupt enable bit
  245                                                                ;    1-enable  interrupt
  246                                                                ;    0-interrupt disable 
  247                                                                ;bit0: pending bit
  248                                                                ;    1-penging (when read)
  249                                                                ;    0-clear pending (when write)                                             
  250  0140   E6 F1 00           LD      PWM0EX, #00000000B           ;PWM extension slection 
  251                                                                ;bit7-2: 8+6, 6+6 extension bits
  252                                                                ;bit1-0:
  253                                                                ;    00/10: 6bit + 6 extension
  254                                                                ;    01:    6bit + 2 extension
  255                                                                ;    11;    8bit + 6 extension 
  256  0143   E6 F3 08           LD      PWM0CON,#00001000B           ;bit 7-6:PWM clock selection
  257                                                                ;    00-fosc/64
  258                                                                ;    01-fosc/8
  259                                                                ;    10-fosc/2
  260                                                                ;    11-fosc/1
  261                                                                ;bi4: data interval selection bit
  262                                                                ;    0-reload from extension upcounter overflow
  263                                                                ;    1-reload from base upcounter overflow
  264                                                                ;bit3: PWM counter clear bit
  265                                                                ;    0-no effect
  266                                                                ;    1-clear PWM counter (when write)
  267                                                                ;bit2: PWM counter enable bit
  268                                                                ;    0-stop counter
  269                                                                ;    1-Start(resume countering)
  270                                                                ;bit1: PWM Overflow interrupt enable bit
  271                                                                ;    0-disable PWM interrupt
  272                                                                ;    1-enable PWM interrupt
  273                                                                ;bit0: PWM interrupt pending bit
  274                                                                ;    0-clear pending bit(when write)
  275                                                                ;    1-interrupt pending (when read)
  276  0146   E6 F7 F8           LD      ADCON,#11111000B            ;bit7-4: channel select:
  277                                                                ;    0000-1000: channel 0-8
  278                                                                ;    others:    not connceted.
  279                                                                ;bit3: End of conversion status:
  280                                                                ;    1-conversion complete  0-conversion in progress
  281                                                                ;bit2-1: ADC clock selection: the maximum ADC clock=2.5M
  282                                                                ;    00-fosc/16(fosc<=10M)  01-fosc/8
  283                                                                ;    10-fosc/4              11-fosc/1
  284                                                                ;bit0: Conversion start bit
  285                                                                ;    1-conversion start
  286  0149   5F                 SB1
  287  014A   E6 E6 00           LD      PWM1EX, #00000000B           ;PWM extension slection 
  288                                                                ;bit7-2: 8+6, 6+6 extension bits
  289                                                                ;bit1-0:
  290                                                                ;    00/10: 6bit + 6 extension
  291                                                                ;    01:    6bit + 2 extension
  292                                                                ;    11;    8bit + 6 extension 
  293  014D   E6 E8 08           LD      PWM1CON,#00001000B           ;bit 7-6:PWM clock selection
  294                                                                ;    00-fosc/64
  295                                                                ;    01-fosc/8
  296                                                                ;    10-fosc/2
  297                                                                ;    11-fosc/1
  298                                                                ;bi4: data interval selection bit
  299                                                                ;    0-reload from extension upcounter overflow
  300                                                                ;    1-reload from base upcounter overflow
  301                                                                ;bit3: PWM counter clear bit
  302                                                                ;    0-no effect
  303                                                                ;    1-clear PWM counter (when write)
  304                                                                ;bit2: PWM counter enable bit
  305                                                                ;    0-stop counter
  306                                                                ;    1-Start(resume countering)
  307                                                                ;bit1: PWM Overflow interrupt enable bit
  308                                                                ;    0-disable PWM interrupt
  309                                                                ;    1-enable PWM interrupt
  310                                                                ;bit0: PWM interrupt pending bit
  311                                                                ;    0-clear pending bit(when write)
  312                                                                ;    1-interrupt pending (when read)
  313  0150   E6 E4 00           LD      T1CON,#00000000B            ;bit7-6: operation mode selection
  314                                                                ;    00-interval timer mode
  315                                                                ;    01-Capture mode ,rising edge
  316                                                                ;    10-Capture mode ,falling edge
  317                                                                ;    11-Capture mode ,both edge
  318                                                                ;bit 5: timer Run enable bit
  319                                                                ;    1-Enbale Run; 0-disable run
  320                                                                ;bit 4: timer conter clear bit
  321                                                                ;    1-clear counter(when write)
  322                                                                ;bit 3: overflow interrupt enable bit
  323                                                                ;    1-enable  interrupt
  324                                                                ;    0-interrupt disable 
  325                                                                ;bit 2: overflow interrupt pending bit
  326                                                                ;    1-penging (when read)
  327                                                                ;    0-clear pending (when write)
  328                                                                ;bit 1: match interrupt enable bit
  329                                                                ;    1-enable  interrupt
  330                                                                ;    0-interrupt disable 
  331                                                                ;bit 0: match interrupt pending bit
  332                                                                ;    1-penging (when read)
  333                                                                ;    0-clear pending (when write)
  334  0153   E6 E5 00           LD      T1PS, #00000000B            ;bit 3-0: Timer 1 clock divider:
  335                                                                ;    T1 clock = Flclk/2^(T1PS)
  336  0156   E6 F4 00           LD      LVDCON, #00000000B          ;bit 7: LVD enable/disable
  337                                                                ;   1-enable,  0-disable
  338                                                                ;bit 5: LVD output bit (read only)
  339                                                                ;   0-VDD > Vlvd,  1-VDD < Vlvd 
  340                                                                ;bit 4: interrupt enable/disable
  341                                                                ;   1-enable, 0-disable
  342                                                                ;bit 1-0: LVD level selection:
  343                                                                ;    00-4.1V
  344                                                                ;    01-3.2V
  345                                                                ;    10-2.5V
  346                                                                ;    11-2.1V.   
  347  0159   E6 F5 43           LD      UARTCON, #01000011B         ;bit 7-6:oprating mode selection
  348                                                                ;    00-mode 0:SIO mode
  349                                                                ;    01-8-bit UART mode
  350                                                                ;    10-9-bit , fixed baudrate
  351                                                                ;    11-9-bit
  352                                                                ;bit 5: multi processor enable bit
  353                                                                ;    1-enable   0-disable
  354                                                                ;bit 4: recieve enable
  355                                                                ;    1-enable   0-disable
  356                                                                ;bit 3: 9th bit to be transimitted
  357                                                                ;bit 2: 9th bit recieved
  358                                                                ;bit 1: recieve interrupt enable/disable
  359                                                                ;    1-enable   0-disable
  360                                                                ;bit 0: transimit interrupt enable/disable
  361                                                                ;    1-enable   0-disable 
  362  015C   E6 F6 00           LD      UARTPND, #00000000B         ;UART interrupt pending bit
  363                                                                ;bit 1: recieve interrupt pending bit
  364                                                                ;   0-no interrupt; 1 -interrup pending
  365                                                                ;bit 0: transimit interrupt pending bit
  366                                                                ;   0-no interrupt; 1 -interrup pending 
  367  015F   E6 F0 00           LD      ICCR,    #00000000B
  368  0162   E6 F1 00           LD      ICSR,    #00000000B                                    
  369  0165   4F                 SB0
  370                            
  371  0166   9F                 EI   
  372                    
  373                    ;;=======================================================================
  374                    ;;==      Main function                                                ==
  375                    ;;==                Test the C4's functions                            ==
  376                    ;;==                                                                   == 
  377                    ;;=======================================================================
  378  0167              MAIN::
  379  0167   E6 E0 00           LD      P0,#000H
  380  016A   8D 01 67           JP      MAIN
  381                    ;;==========================================
  382                    ;;      Delay  function  
  383                    ;;==========================================
  384                            ;;--------------------------------
  385                            ;;  delay 120 cycles 
  386                            ;;--------------------------------
  387  016D              DELAY_CYCLES_120::
  388  016D   70 C1              PUSH    R1
  389  016F   1C 0A              LD      R1,#10
  390  0171                  DELAY_CYCLES_12_SUB5:    
  391  0171   FF                 NOP
  392  0172   1A FD              DJNZ    R1,DELAY_CYCLES_12_SUB5
  393  0174   50 C1              POP     R1
  394  0176   AF                 RET
  395                            ;;--------------------------------
  396                            ;;  delay 250 cycles 
  397                            ;;--------------------------------
  398  0177              DELAY_CYCLES_250::
  399  0177   70 C1              PUSH    R1
  400  0179   1C 14              LD      R1,#20
  401  017B                  DELAY_CYCLES_12_SUB4:    
  402  017B   FF                 NOP
  403  017C   1A FD              DJNZ    R1,DELAY_CYCLES_12_SUB4
  404  017E   50 C1              POP     R1
  405  0180   AF                 RET
  406                            ;;--------------------------------
  407                            ;;  delay 500 cycles (0.1ms@10M)
  408                            ;;--------------------------------
  409  0181              DELAY_CYCLES_500::
  410  0181   70 C1              PUSH    R1
  411  0183   1C 29              LD      R1,#41
  412  0185                  DELAY_CYCLES_12:    
  413  0185   FF                 NOP
  414  0186   1A FD              DJNZ    R1,DELAY_CYCLES_12
  415  0188   50 C1              POP     R1
  416  018A   AF                 RET
  417                    
  418                            ;;--------------------------------
  419                            ;;  delay 1000 cycles (0.1ms@10M)
  420                            ;;--------------------------------            
  421  018B              DELAY_CYCLES_1000::
  422  018B   70 C1              PUSH    R1
  423  018D   1C 52              LD      R1,#82
  424  018F                 DELAY_CYCLES_12_SUB:    
  425  018F   FF                 NOP
  426  0190   1A FD              DJNZ    R1,DELAY_CYCLES_12_SUB
  427  0192   50 C1              POP     R1
  428  0194   AF                 RET
  429                            ;;--------------------------------
  430                            ;;  delay 6000 cycles (0.6ms@10M)
  431                            ;;--------------------------------
  432  0195              DELAY_CYCLES_6000::
  433  0195   70 C1              PUSH    R1
  434  0197   70 C2              PUSH    R2
  435  0199   1C 06              LD      R1,#6
  436  019B                 DELAY_CYCLES_1000_SUB:
  437  019B   2C 53              LD      R2,#83
  438  019D                 DELAY_CYCLES_12_SUB_0:    
  439  019D   FF                 NOP
  440  019E   2A FD              DJNZ    R2,DELAY_CYCLES_12_SUB_0
  441  01A0   1A F9              DJNZ    R1,DELAY_CYCLES_1000_SUB
  442  01A2   50 C2              POP     R2
  443  01A4   50 C1              POP     R1
  444  01A6   AF                 RET
  445                            ;;--------------------------------
  446                            ;;  delay 200000 cycles(20ms@10M)
  447                            ;;--------------------------------  
  448  01A7              DELAY_CYCLES_200000::
  449  01A7   70 C1              PUSH    R1
  450  01A9   70 C2              PUSH    R2
  451  01AB   1C C8              LD      R1,#200
  452  01AD                 DELAY_CYCLES_1000_SUB1:     
  453  01AD   2C 52              LD      R2,#82
  454  01AF                 DELAY_CYCLES_12_SUB1:    
  455  01AF   FF                 NOP
  456  01B0   2A FD              DJNZ    R2,DELAY_CYCLES_12_SUB1
  457  01B2   1A F9              DJNZ    R1,DELAY_CYCLES_1000_SUB1
  458  01B4   50 C2              POP     R2
  459  01B6   50 C1              POP     R1
  460  01B8   AF                 RET
  461                     
  462                            ;;--------------------------------
  463                            ;;  delay 1000000 cycles (100ms@10M)
  464                            ;;--------------------------------   
  465  01B9              DELAY_CYCLES_1000000::
  466  01B9   70 C1              PUSH    R1
  467  01BB   70 C2              PUSH    R2
  468  01BD   70 C3              PUSH    R3
  469  01BF   1C 05         LD      R1,#05H
  470  01C1                 DELAY_CYCLES_200000_SUB2:             
  471  01C1   2C C8           LD      R2,#200
  472  01C3                   DELAY_CYCLES_1000_SUB2:     
  473  01C3   3C 52              LD      R3,#82
  474  01C5                      DELAY_CYCLES_12_SUB2:    
  475  01C5   FF                         NOP
  476  01C6   3A FD              DJNZ    R3,DELAY_CYCLES_12_SUB2
  477  01C8   2A F9           DJNZ    R2,DELAY_CYCLES_1000_SUB2
  478  01CA   1A F5         DJNZ    R1,DELAY_CYCLES_200000_SUB2
  479  01CC   50 C3              POP     R3
  480  01CE   50 C2              POP     R2
  481  01D0   50 C1              POP     R1
  482  01D2   AF                 RET        
  483                           
  484                            ;;--------------------------------
  485                            ;;  delay 10000000 cylces(1S@10M)
  486                            ;;--------------------------------   
  487  01D3              DELAY_CYCLES_10000000::
  488  01D3   70 C1              PUSH    R1
  489  01D5   70 C2              PUSH    R2
  490  01D7   70 C3              PUSH    R3
  491  01D9   70 C4              PUSH    R4
  492                            
  493  01DB   1C 0A              LD      R1,#10
  494  01DD               DELAY_CYCLES_1000000_SUB3:
  495  01DD   2C 05         LD      R2,#05
  496  01DF                 DELAY_CYCLES_200000_SUB3:             
  497  01DF   3C C8           LD      R3,#200
  498  01E1                   DELAY_CYCLES_1000_SUB3:     
  499  01E1   4C 52              LD      R4,#82
  500  01E3                      DELAY_CYCLES_12_SUB3:    
  501  01E3   FF                         NOP
  502  01E4   4A FD              DJNZ    R4,DELAY_CYCLES_12_SUB3
  503  01E6   3A F9           DJNZ    R3,DELAY_CYCLES_1000_SUB3
  504  01E8   2A F5         DJNZ    R2,DELAY_CYCLES_200000_SUB3
  505  01EA   1A F1        DJNZ    R1,DELAY_CYCLES_1000000_SUB3
  506                            
  507  01EC   50 C4              POP     R4
  508  01EE   50 C3              POP     R3
  509  01F0   50 C2              POP     R2
  510  01F2   50 C1              POP     R1
  511  01F4   AF                 RET   
  512                    ;;=======================================================================
  513                    ;;==      INTERRUPT SERVICE ROUTINE                                    ==
  514                    ;;==                  interrupt source 4                               ==
  515                    ;;==                                                                   == 
  516                    ;;=======================================================================                                                                                
  517                           ;;----------------------------------------
  518                           ;;     external interrupt 0
  519                           ;;----------------------------------------
  520  01F5              EX_INT0:
  521  01F5   56 E8 FF          AND     P0PND, #11111111B                       ;clear pending bit
  522  01F8   8D 02 9B          JP      INT_ISR_END        
  523                           ;;----------------------------------------
  524                           ;;     external interrupt 1
  525                           ;;----------------------------------------
  526  01FB              EX_INT1:
  527  01FB   56 E8 FF           AND     P0PND, #11111111B                       ;clear pending bit
  528  01FE   8D 02 9B           JP      INT_ISR_END
  529                           ;;----------------------------------------
  530                           ;;     external interrupt 2
  531                           ;;----------------------------------------
  532  0201              EX_INT2:
  533  0201   B6 E0 20           XOR     P0,#00100000B                           ;toggle P0.5 
  534  0204   56 E8 EF           AND     P0PND, #11101111B                       ;clear pending bit
  535  0207   8D 02 9B           JP      INT_ISR_END
  536                            ;;----------------------------------------
  537                           ;;     external interrupt 3
  538                           ;;----------------------------------------
  539  020A              EX_INT3:
  540  020A   B6 E0 10           XOR     P0,#00010000B                           ;toggle P0.4 
  541  020D   56 E8 BF           AND     P0PND, #10111111B                       ;clear pending bit
  542  0210   8D 02 9B           JP      INT_ISR_END
  543                            ;;----------------------------------------
  544                           ;;     external interrupt 4
  545                           ;;----------------------------------------
  546  0213              EX_INT4:
  547  0213   B6 E0 80           XOR     P0,#10000000B                           ;toggle P0.7 
  548  0216   56 EF FE           AND     P3PND, #11111110B                       ;clear pending bit
  549  0219   8D 02 9B           JP      INT_ISR_END
  550                            ;;----------------------------------------
  551                           ;;     external interrupt 5
  552                           ;;----------------------------------------
  553  021C              EX_INT5:
  554  021C   B6 E0 40           XOR     P0,#01000000B                           ;toggle P0.6 
  555  021F   56 EF FB           AND     P3PND, #11111011B                       ;clear pending bit
  556  0222   8D 02 9B           JP      INT_ISR_END
  557                            ;;----------------------------------------
  558                           ;;     external interrupt 6
  559                           ;;----------------------------------------
  560  0225              EX_INT6:
  561  0225   B6 E0 20           XOR     P0,#00100000B                           ;toggle P0.5 
  562  0228   56 EF EF           AND     P3PND, #11101111B                       ;clear pending bit
  563  022B   8D 02 9B           JP      INT_ISR_END
  564                            ;;----------------------------------------
  565                           ;;     external interrupt 7
  566                           ;;----------------------------------------
  567  022E              EX_INT7:
  568  022E   B6 E0 10           XOR     P0,#00010000B                           ;toggle P0.4 
  569  0231   56 EF BF           AND     P3PND, #10111111B                       ;clear pending bit
  570  0234   8D 02 9B           JP      INT_ISR_END
  571                            
  572                           ;;----------------------------------------
  573                           ;;     Timer0/A match interrupt
  574                           ;;----------------------------------------  
  575  0237              T0_A_MC_INT:
  576  0237   B6 E0 80           XOR     P0,#10000000B                           ;toggle P0.7
  577  023A   56 D2 FE           AND     TACON,#11111110B                        ;clear pending bit
  578  023D   8D 02 9B           JP      INT_ISR_END 
  579                           ;;----------------------------------------
  580                           ;;     TimerB match interrupt
  581                           ;;---------------------------------------- 
  582  0240              TB_MC_INT:
  583  0240   B6 E0 40           XOR     P0,#01000000B                           ;toggle P0.6
  584  0243   56 EE FE           AND     TBCON,#11111110B                        ;clear pending bit
  585  0246   8D 02 9B           JP      INT_ISR_END
  586                           ;;----------------------------------------
  587                           ;;     PWM1 Overflow interrupt 
  588                           ;;----------------------------------------
  589  0249              PWM1_OVF_INT:
  590  0249   B6 E0 40           XOR     P0,#01000000B                           ;toggle P0.6
  591  024C   5F                 SB1
  592  024D   56 E8 F6           AND     PWM1CON,#11110110B                       ;clear pending bit
  593  0250   4F                 SB0
  594  0251   8D 02 9B           JP      INT_ISR_END
  595                           ;;----------------------------------------
  596                           ;;     PWM0 Overflow interrupt 
  597                           ;;----------------------------------------
  598  0254              PWM0_OVF_INT:
  599  0254   B6 E0 20           XOR     P0,#00100000B                           ;toggle P0.5
  600  0257   56 F3 F6           AND     PWM0CON,#11110110B                       ;clear pending bit
  601  025A   8D 02 9B           JP      INT_ISR_END
  602                           ;;----------------------------------------
  603                           ;;     Timer1 match interrupt
  604                           ;;----------------------------------------  
  605  025D              TIMER1_MC_INT:
  606  025D   B6 E0 20           XOR     P0,#00100000B                            ;toggle P0.5
  607  0260   5F                 SB1
  608  0261   56 E4 FE           AND     T1CON,#11111110B                         ;clear pending bit
  609  0264   4F                 SB0
  610  0265   8D 02 9B           JP      INT_ISR_END 
  611                           ;;----------------------------------------
  612                           ;;     Timer1 Overflow interrupt
  613                           ;;----------------------------------------  
  614  0268              TIMER1_OVF_INT:
  615  0268   B6 E0 10           XOR     P0,#00010000B                            ;toggle P0.4
  616  026B   5F                 SB1
  617  026C   56 E4 FB           AND     T1CON,#11111011B                         ;clear pending bit
  618  026F   4F                 SB0
  619  0270   8D 02 9B           JP      INT_ISR_END
  620                           ;;----------------------------------------
  621                           ;;     Low voltage detector interrupt
  622                           ;;---------------------------------------- 
  623  0273              LVD_INT:
  624  0273   4F                 SB0
  625  0274   56 E0 F7           AND      P0,#11110111B                            ;light P0.3
  626  0277   5F                 SB1
  627  0278   56 F4 EF           AND     LVDCON, #11101111B                       ;disable interrupt
  628  027B   4F                 SB0
  629  027C   8D 02 9B           JP      INT_ISR_END              
  630                           ;;----------------------------------------
  631                           ;;     UART interrupt
  632                           ;;---------------------------------------- 
  633  027F              UART_TRS_INT:
  634  027F   5F                 SB1
  635  0280   56 F6 FE           AND     UARTPND, #11111110B                      ;clear pending bit
  636  0283   4F                 SB0
  637  0284   8D 02 9B           JP      INT_ISR_END
  638  0287              UART_RV_INT:
  639  0287   5F                 SB1
  640  0288   56 F6 FD           AND     UARTPND, #11111101B                      ;clear pending bit
  641  028B   4F                 SB0
  642  028C   8D 02 9B           JP      INT_ISR_END
  643                           ;;----------------------------------------
  644                           ;;     IIC interrupt
  645                           ;;---------------------------------------- 
  646  028F              IIC_INT:
  647  028F   8D 02 9B           JP      INT_ISR_END
  648                           ;;----------------------------------------
  649                           ;;     Watchdog  interrupt
  650                           ;;---------------------------------------- 
  651  0292              WDT_INT:
  652  0292   B6 E3 01           XOR     P3,#00000001B                           ;toggle P3.0
  653                            ;AND      WDTCON, #10111111B                    ;disable reset, clear counter
  654  0295   46 F6 10           OR      WDTCON, #00010000B                      ;clear counter.      
  655  0298   8D 02 9B           JP      INT_ISR_END       
  656                    
  657                    
  658                    
  659                           ;;----------------------------------------
  660                           ;;     interrupt service end
  661                           ;;----------------------------------------        
  662  029B              INT_ISR_END:                
  663  029B   BF                IRET
  664                     
  665  029C              .END


Total 659 Lines Assembled - 0 Errors, 0 Warnings
Total code size 0x1C6


