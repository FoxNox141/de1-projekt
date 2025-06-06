# Digital clock, with Stopwatch and Alarm (hh/mm/ss)

### Team members

* Lukáš Vizina
* Samuel Sedmák
* Erik Maděránek

### Table of contents

* [Project objectives](#objectives)
* [Hardware description](#hardware)
* [VHDL modules description and simulations](#modules)
* [TOP module description](#top)
* [Video](#video)
* [References](#references)

<a name="objectives"></a>

## Project objectives

Project goal is to implement digital clock on Nexys A7-50T board, including time setting and alarm function all in hh:mm:ss format.

The clock is controlled by 5 buttons. The output peripherals are an integrated eight digit 7-segment display and an RGB LED implementing the alarm function.



<a name="hardware"></a>

## Hardware description

   #### Nexys A7-50T
   ![nexys board](Graphs/nexys_board.png)

| **Callout** | **Component Description** | **Callout** | **Component Description** |
   | :-: | :-: | :-: | :-: |
   | 1 | Power jack | 16 | JTAG port for (optional) external cable |
   | 2 | Power switch | 17 | Tri-color (RGB) LEDs |
   | 3 | USB host connector | 18 | Slide switches (16) |
   | 4 | PIC24 programming port (factory use) | 19 | LEDs (16) |
   | 5 | Ethernet connector | 20 | Power supply test point(s) |
   | 6 | FPGA programming done LED | 21 | Eight digit 7-seg display |
   | 7 | VGA connector | 22 | Microphone |
   | 8 | Audio connector | 23 | External configuration jumper (SD / USB) |
   | 9 | Programming mode jumper | 24 | MicroSD card slot |
   | 10 | Analog signal Pmod port (XADC) | 25 | Shared UART/ JTAG USB port |
   | 11 | FPGA configuration reset button | 26 | Power select jumper and battery header |
   | 12 | CPU reset button (for soft cores) | 27 | Power-good LED |
   | 13 | Five pushbuttons | 28 | Xilinx Artix-7 FPGA |
   | 14 | Pmod port(s) | 29 | DDR2 memory |
   | 15 | Temperature sensor |  |  |
   
   #### BASIC I/O schematic
   ![nexys basic scheme](Graphs/nexys_basic_scheme.png)
   
## TOP module description

All the main blocks are interconnected in the `top.vhd` module and connected to hardware components.
Code of the TOP module can be found here:
[TOP](Digi_Clock/TOP/TopLevel.vhd)

![top module scheme](Graphs/top.png)

## Schematics for Timer and Stopwatch
Mindmaps for structure of these modules
![Timer module scheme](Graphs/Timer.png)
![Stopwatch module scheme](Graphs/SW.png)
## References


## VHDL modules description

### `Timer.vhd`
This module is responsible for the core operation of the digital clock. It receives a clock signal that is slowed down to a one-second interval using the clock_enable.vhd module, where the parameter N_PERIODS is set to 10,000,000 (100MHz). The seconds count increments every second, looping from 0 to 59 and then restarting at 0. Similarly, the minutes count increases by one when the seconds reach 59, also cycling up to 59. The hours count advances when the minutes reach 59, counting up to 23 before resetting back to 0.

Initially, the clock starts at 00:00:00

[Timer code](Digi_Clock/TimeBlock/Timer.vhd)
[Timer testbench](Digi_Clock/TestBenches/TB_TimeBlock.vhd)
![dig_clock simulation](Graphs/tb_digital_clock.png)

### `Alarm.vhd`
This module works both to remember the set alarm time and to trigger the alarm at the correct time. By pressing buttons RIGHT and LEFT we switch between hh/mm/ss and by pressing buttons DOWN and UP. The alarm function is active only when `alarm_active` is in the 1 position. If the values of the set alarm time and the current time are equal, the alarm is triggered.

[alarm testbench](Digi_Clock/TimeBlock/Alarm.vhd)
![alarm simulation](Graphs/tb_alarm.png)

### `Stopwatch.vhd`
This module, while active, starts at 0 hh/mm/ss and starts counting up upon a button press. Which then stops only when reaching maximum time to start again or if stopped manualy.
[Stopwatch testbench](Digi_Clock/TimeBlock/Stopwatch.vhd)

### `button_debouncer.vhd`
Mechanical buttons often generate fake transitions when pressed due to its mechanical nature. If we want to set the time using pushbuttons, fake transitions would be problematic and create imprecisions, so it is necessary to get rid of them. Module called `debounce` is used to do the job. It consists of three D-latches connected in series. The first one takes the push button signal as its input. When the enable signal is on high level, the input gest shifted to the next latch. The outputs of all three latches are connected to an AND gate which output is output of the whole debouncer. `clock_enable.vhd` module is used as synchronous signal generator where its `N_PERIODS` value is set to 1 000 000 for 100 ms debounce delay.

[button_debouncer testbench](Digi_Clock/Buttons)
![button_debouncer simulation](Graphs/tb_button_debouncer.png)

## Other used modules, taken from exercises and unmodified
### `cnt_up_down.vhd`

### `bin2seg.vhd`

### `clock_enable.vhd`



