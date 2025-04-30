----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2025 02:06:34 PM
-- Design Name: 
-- Module Name: TopLevel - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopLevel is
    Port ( 
        BTNC        : in STD_LOGIC;
        BTNU        : in STD_LOGIC;
        BTNL        : in STD_LOGIC;
        BTNR        : in STD_LOGIC;
        BTND        : in STD_LOGIC;
        CLK100MHZ   : in STD_LOGIC;
        SW_A        : in STD_LOGIC;    
        CA          : out std_logic;
        CB          : out std_logic;
        CC          : out std_logic;
        CD          : out std_logic;
        CE          : out std_logic;
        CF          : out std_logic;
        CG          : out std_logic;
        AN          : out std_logic_vector(7 downto 0);  
        LED16_B     : out std_logic 
    );
end TopLevel;

architecture Behavioral of TopLevel is

    component Display is
        Port ( 
            Seg0        : in STD_LOGIC_VECTOR(3 downto 0);
            Seg1        : in STD_LOGIC_VECTOR(3 downto 0);
            Seg2        : in STD_LOGIC_VECTOR(3 downto 0);
            Seg3        : in STD_LOGIC_VECTOR(3 downto 0);
            Seg4        : in STD_LOGIC_VECTOR(3 downto 0);
            Seg5        : in STD_LOGIC_VECTOR(3 downto 0);
            Seg6        : in STD_LOGIC_VECTOR(3 downto 0);
            Seg7        : in STD_LOGIC_VECTOR(3 downto 0);
            CLK100MHZ   : in STD_LOGIC;
            reset          : in STD_LOGIC;
            TimeEdit    : in STD_LOGIC;
            EditEnable  : in STD_LOGIC;
            ANOut       : out STD_LOGIC_VECTOR(7 downto 0);
            seg_output  : out STD_LOGIC_VECTOR(6 downto 0)
 
        );
    end component;
    
    
    
    component Debounce_Top is
        port(
            clk         : in  std_logic;                
            rst         : in  std_logic;              
            buttons     : in  std_logic_vector(4 downto 0); 
            debounced   : out std_logic_vector(4 downto 0)  
        );
    end component;    
    
    
    
    component TimeBlock is
        port(
            -- Inputs
            CLK                      : in  STD_LOGIC;  -- 100 MHz
            ModeSelect               : in  STD_LOGIC_VECTOR (2 downto 0);
            UP                       : in  STD_LOGIC;
            DOWN                     : in  STD_LOGIC;
            LEFT                     : in  STD_LOGIC;
            RIGHT                    : in  STD_LOGIC;
            CENTER                   : in  STD_LOGIC;
            rst                      : in STD_LOGIC;
    
            -- Outputs
            TimeEditTimer                 : out STD_LOGIC;
            ModeSelectDisableTimer   : out STD_LOGIC;
            Sec1                     : out STD_LOGIC_VECTOR (3 downto 0);
            Sec10                    : out STD_LOGIC_VECTOR (3 downto 0);
            Min1                     : out STD_LOGIC_VECTOR (3 downto 0);
            Min10                    : out STD_LOGIC_VECTOR (3 downto 0);
            Hour1                    : out STD_LOGIC_VECTOR (3 downto 0);
            Hour10                   : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;
    
    component Stopwatch is
        port(
            clk_100mhz              : in  STD_LOGIC;  -- 1 kHz hodiny
            reset                   : in  STD_LOGIC;  -- Reset tla?idlo
            start                   : in  STD_LOGIC;  -- �tart (UpBTN)
            stop                    : in  STD_LOGIC;  -- Stop (DownBTN)
            mode_select             : in  STD_LOGIC_VECTOR(2 downto 0); -- V�ber m�du
            minutes10               : out STD_LOGIC_VECTOR(3 downto 0); -- Desiatky min�t
            minutes1                : out STD_LOGIC_VECTOR(3 downto 0); -- Jednotky min�t
            seconds10               : out STD_LOGIC_VECTOR(3 downto 0); -- Desiatky sek�nd
            seconds1                : out STD_LOGIC_VECTOR(3 downto 0); -- Jednotky sek�nd
            ms100                   : out STD_LOGIC_VECTOR(3 downto 0); -- Stovky milisek�nd
            ms10                    : out STD_LOGIC_VECTOR(3 downto 0) -- Desiatky milisek�nd
        );
    end component;
 
     component Alarm is
        port(
            clk_100mhz              : in  STD_LOGIC;  -- 100 MHz hodiny
            reset                   : in  STD_LOGIC;  -- Reset (SW)
            mode_select             : in  STD_LOGIC_VECTOR(2 downto 0);  -- Výber módu
            up                      : in  STD_LOGIC;  -- Tla�?idlo hore
            down                    : in  STD_LOGIC;  -- Tla�?idlo dole
            left                    : in  STD_LOGIC;  -- Tla�?idlo vľavo
            right                   : in  STD_LOGIC;  -- Tla�?idlo vpravo
            center                  : in  STD_LOGIC;  -- Tla�?idlo center
            hour10                  : in  STD_LOGIC_VECTOR(3 downto 0);  -- Desiatky hodín
            hour1                   : in  STD_LOGIC_VECTOR(3 downto 0);  -- Jednotky hodín
            min10                   : in  STD_LOGIC_VECTOR(3 downto 0);  -- Desiatky minút
            min1                    : in  STD_LOGIC_VECTOR(3 downto 0);  -- Jednotky minút
            -- Výstupy
            time_editAlarm               : out STD_LOGIC;  -- 0 = úprava hodín, 1 = úprava minút
            modeselectdisableAlarm   : out STD_LOGIC;  -- Zakáže zmenu módu po�?as úpravy
            alarm_out               : out STD_LOGIC  -- Výstup pre LED signalizáciu budíka
         );
     end component;
 
 
    
    --Signals 
        --BTNS before Debounce
    signal buttons_raw     : std_logic_vector(4 downto 0);
    signal buttons_clean   : std_logic_vector(4 downto 0);
    signal prev_btn_up     : std_logic := '0';

    signal TimeEdit : std_logic:='0';
    signal EditEnable : std_logic:='0';
    
    
        --BTNS before Debounce
    signal buttons_vec              : STD_LOGIC_VECTOR(4 downto 0);
    signal Sig_EditAdd              : STD_LOGIC:='0';
    signal Sig_EditSubb             : STD_LOGIC:='0';
    signal Sig_EditNext             : STD_LOGIC:='0';
    signal Sig_EditBack             : STD_LOGIC:='0';
    signal Sig_EditDone             : STD_LOGIC:='0';
    
        --Additional signals for counters/stopwatches
    signal Sig_ModeSelect           : STD_LOGIC_VECTOR (2 downto 0) :="000";
    signal Sig_ModeSelectDisableTimer    : STD_LOGIC :='0';
    signal Sig_ModeSelectDisableAlarm    : STD_LOGIC :='0';
    signal Sig_TimeEdit             : STD_LOGIC :='0';
    signal Sig_TimeEditAlarm             : STD_LOGIC :='0';
    signal Sig_TimeEditTimer             : STD_LOGIC :='0';
    
    

        --Signals for display
            --Stopwatch
    signal Sig_S_10M                :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_S_1M                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_S_10s                :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_S_1s                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_S_100ms              :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_S_10ms               :STD_LOGIC_VECTOR (3 downto 0):="0000";    
    
            --Timer
    signal Sig_T_10H                :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_T_1H                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_T_10m                :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_T_1m                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_T_10s               :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_T_1s                :STD_LOGIC_VECTOR (3 downto 0):="0000";
        
            --Alarm
    signal Sig_A_10H                :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_A_1H                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_A_10m                :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_A_1m                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_A_10s               :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_A_1s                :STD_LOGIC_VECTOR (3 downto 0):="0000";
    
        -- Sign�ly pro segmenty displeje
    signal Sig_Disp0                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_Disp1                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_Disp2                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_Disp3                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_Disp4                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_Disp5                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_Disp6                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    signal Sig_Disp7                 :STD_LOGIC_VECTOR (3 downto 0):="0000";
    
    signal Sig_SegOut               :STD_LOGIC_VECTOR (6 downto 0);
    signal Sig_AN                   :std_logic_vector (7 downto 0);
    
    signal Up_prev : std_logic := '0';
    signal Up_debounced : std_logic;
   

    
begin
    buttons_raw <= BTNR & BTNL & BTND & BTNU & BTNC;
    -- Debounce v�ech 5 tla?�tek: {BTNR, BTNL, BTND, BTNU, BTNC}
    U_Debounce : Debounce_Top
        port map(
            clk       => CLK100MHZ,
            rst       => '0',
            buttons => buttons_raw,
            debounced => buttons_clean
        );
        
        Up_debounced <= buttons_clean(1);    
        
        Sig_EditAdd  <= buttons_clean(1);
        Sig_EditSubb <= buttons_clean(2);
        Sig_EditNext <= buttons_clean(4);
        Sig_EditBack <= buttons_clean(3);
        Sig_EditDone <= buttons_clean(0);

     U_TimeBlock : TimeBlock
            port map(
                CLK                     => CLK100MHZ,
                ModeSelect              => Sig_ModeSelect,
                UP                      => Sig_EditAdd,
                DOWN                    => Sig_EditSubb,
                LEFT                    => Sig_EditNext,
                RIGHT                   => Sig_EditBack,
                CENTER                  => Sig_EditDone,
                TimeEditTimer                => Sig_TimeEditTimer,
                ModeSelectDisableTimer  => Sig_ModeSelectDisableTimer,
                Sec1                    => Sig_T_1s,
                Sec10                   => Sig_T_10s,
                Min1                    => Sig_T_1M,
                Min10                   => Sig_T_10M,
                Hour1                   => Sig_T_1H,
                Hour10                  => Sig_T_10H,
                rst                     => SW_A
            );
            
                -- Stopwatch
    U_Stopwatch : Stopwatch
        port map(
            clk_100mhz  => CLK100MHZ,
            reset       => Sig_EditDone,
            start       => Sig_EditAdd,
            stop        => Sig_EditSubb,
            mode_select => Sig_ModeSelect,  -- m?�e� pozd?ji ud?lat ?�zen� podle SW
            minutes10   => Sig_S_10M,
            minutes1    => Sig_S_1M,
            seconds10   => Sig_S_10s,
            seconds1    => Sig_S_1s,
            ms100       => Sig_S_100ms,
            ms10        => Sig_S_10ms
        );
        
        
    Display_Module: Display
        port map(
            Seg0 => Sig_Disp0,
            Seg1 => Sig_Disp1,
            Seg2 => Sig_Disp2,
            Seg3 => Sig_Disp3,
            Seg4 => Sig_Disp4,
            Seg5 => Sig_Disp5,
            Seg6 => Sig_Disp6,
            Seg7 => Sig_Disp7,
            CLK100MHZ => CLK100MHZ,
            reset => SW_A,
            TimeEdit => TimeEdit,
            EditEnable => EditEnable,
            ANOut => Sig_AN,
            seg_output => Sig_segout
        );
        
     Alarm_Module: Alarm
        port map(
                CLK_100mhz         => CLK100MHZ,
                reset              => SW_A,
                Mode_Select         => Sig_ModeSelect,
                UP                 => Sig_EditAdd,
                DOWN               => Sig_EditSubb,
                LEFT               => Sig_EditNext,
                RIGHT              => Sig_EditBack,
                CENTER             => Sig_EditDone,
                Min1               => Sig_S_1M,
                Min10              => Sig_S_10M,
                Hour1              => Sig_T_1H,
                Hour10             => Sig_T_10H,
                              
                Time_EditAlarm           => Sig_TimeEditAlarm,
                modeselectdisableAlarm  => Sig_ModeSelectDisableAlarm,
                alarm_out =>LED16_B
                                
        );        
    process(clk100MHZ)
    begin
        if rising_edge(clk100MHZ) then
            -- detekce náběžné hrany: 0 → 1
            if(Sig_ModeSelectDisableAlarm)='0' and (Sig_ModeSelectDisableTimer)='0' then      
                if (Up_prev = '0') and (Up_debounced = '1') then
                    -- zvýšíme režim a obto�?íme přes 3 zpět na 0
                     Sig_ModeSelect <= std_logic_vector((unsigned(Sig_ModeSelect) + 1) mod 3);
                end if;
        
                -- aktualizujeme minulý stav
                Up_prev <= Up_debounced;
            end if;
        end if;
    end process; 
    
    process(Sig_TimeEditAlarm, Sig_TimeEditTimer)
    begin
        if (Sig_TimeEditAlarm = '1') or (Sig_TimeEditTimer = '1') then
            Sig_TimeEdit <= '1';
        else
            Sig_TimeEdit <= '0';
        end if;
        
               case to_integer(unsigned(Sig_ModeSelect)) is
            when 0 =>
                -- StopWatch (např. použij hodnoty z chronometru)
                Sig_Disp0 <= "0000"; --Symbol S
                Sig_Disp1 <= "0000"; --Blind Segment
                Sig_Disp2 <= Sig_S_10m;
                Sig_Disp3 <= Sig_S_1m;
                Sig_Disp4 <= Sig_S_10s;
                Sig_Disp5 <= Sig_S_1s;
                Sig_Disp6 <= Sig_S_100ms;
                Sig_Disp7 <= Sig_S_10ms;
    
            when 1 =>
                -- Timer
                Sig_Disp0 <= "0001"; --Symbol t
                Sig_Disp1 <= "0000";  --Blind Segment
                Sig_Disp2 <= Sig_T_10h;
                Sig_Disp3 <= Sig_T_1h;
                Sig_Disp4 <= Sig_T_10m;
                Sig_Disp5 <= Sig_T_1m;
                Sig_Disp6 <= Sig_T_10s;
                Sig_Disp7 <= Sig_T_1s;
    
            when 2 =>
                -- Alarm
                Sig_Disp0 <= "0010";--Symbol A
                Sig_Disp1 <= "0000";--Blind Segment
                Sig_Disp2 <= Sig_A_10h;
                Sig_Disp3 <= Sig_A_1h;
                Sig_Disp4 <= Sig_A_10m;
                Sig_Disp5 <= Sig_A_1m;
                Sig_Disp6 <= Sig_A_10s;
                Sig_Disp7 <= Sig_A_1s;
    
            when others =>
                Sig_Disp0 <= "0000";
                Sig_Disp1 <= "0000";
                Sig_Disp2 <= "0000";
                Sig_Disp3 <= "0000";
                Sig_Disp4 <= "0000";
                Sig_Disp5 <= "0000";
                Sig_Disp6 <= "0000";
                Sig_Disp7 <= "0000";
        end case;
    end process;
    
    CA <= Sig_segout(0);
    CB <= Sig_segout(1);
    CC <= Sig_segout(2);
    CD <= Sig_segout(3);
    CE <= Sig_segout(4);
    CF <= Sig_segout(5);
    CG <= Sig_segout(6);
    
    AN(0) <= Sig_AN(0);
    AN(1) <= '1';
    AN(2) <= Sig_AN(2);
    AN(3) <= Sig_AN(3);
    AN(4) <= Sig_AN(4);
    AN(5) <= Sig_AN(5);
    AN(6) <= Sig_AN(6);
    AN(7) <= Sig_AN(7);
    
end Behavioral;
