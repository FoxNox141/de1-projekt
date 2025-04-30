library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TimeBlock is
    Port (
        -- Inputs
        CLK                      : in  STD_LOGIC;  -- 100 MHz
        ModeSelect               : in  STD_LOGIC_VECTOR (2 downto 0);
        UP                       : in  STD_LOGIC;
        DOWN                     : in  STD_LOGIC;
        LEFT                     : in  STD_LOGIC;
        RIGHT                    : in  STD_LOGIC;
        CENTER                   : in  STD_LOGIC;
        rst                      : in  STD_LOGIC;

        -- Outputs
        TimeEditTimer                 : out STD_LOGIC :='0';
        ModeSelectDisableTimer   : out STD_LOGIC :='0';
        Sec1                     : out STD_LOGIC_VECTOR (3 downto 0) :="0000";
        Sec10                    : out STD_LOGIC_VECTOR (3 downto 0) :="0000";
        Min1                     : out STD_LOGIC_VECTOR (3 downto 0) :="0000";
        Min10                    : out STD_LOGIC_VECTOR (3 downto 0) :="0000";
        Hour1                    : out STD_LOGIC_VECTOR (3 downto 0) :="0000";
        Hour10                   : out STD_LOGIC_VECTOR (3 downto 0) :="0000"
    );
end TimeBlock;

architecture Behavioral of TimeBlock is

    component clock_enable is
        generic(
            N_PERIODS : integer
        );
        Port (
            clk   : in STD_LOGIC;
            rst   : in STD_LOGIC;
            pulse : out STD_LOGIC
        );
    end component;

    -- Time storage
    signal seconds : integer range 0 to 59 := 0;
    signal minutes : integer range 0 to 59 := 0;
    signal hours   : integer range 0 to 23 := 0;
    signal CLK_1s      : STD_LOGIC;
    signal CLK_1s_prev : STD_LOGIC := '0';

    -- Edit control
    signal edit_mode       : STD_LOGIC := '0';
    signal editEN          : STD_LOGIC := '0';
    signal Sig_TimeEdit    : STD_LOGIC := '0';             -- 0 = Hours Edit, 1 = Minutes Edit

    -- Edge detection
    signal prev_UP         : STD_LOGIC := '0';
    signal prev_DOWN       : STD_LOGIC := '0';
    signal prev_LEFT       : STD_LOGIC := '0';
    signal prev_RIGHT      : STD_LOGIC := '0';
    signal prev_CENTER     : STD_LOGIC := '0';

begin

    -- Instantiate 1s clock pulse generator
    CLK_Pulse: component clock_enable
        generic map(
            N_PERIODS => 100_00  -- 100 MHz / 100_000_000 = 1s
        )
        port map(
            clk   => CLK,
            rst   => rst,
            pulse => CLK_1s
        );

    -- 1s Time Counter from 100 MHz Clock


    process (CLK)
    begin   
        if rst = '1' then
            seconds <= 0;
            minutes <= 0;
            hours   <= 0;
            Sec1    <= (others => '0');
            Sec10   <= (others => '0');
            Min1    <= (others => '0');
            Min10   <= (others => '0');
            Hour1   <= (others => '0');
            Hour10  <= (others => '0');
            
            -- Taky radši i ostatní vnitřní signály:
            CLK_1s_prev <= '0';
            editEN <= '0';
            Sig_TimeEdit <= '0';
            prev_UP <= '0';
            prev_DOWN <= '0';
            prev_LEFT <= '0';
            prev_RIGHT <= '0';
            prev_CENTER <= '0';

        elsif rising_edge(CLK) then
    

            -- Posunujeme si předchozí hodnotu CLK_1s pro detekci hrany
            CLK_1s_prev <= CLK_1s;
    
            -- Inkrementace sekund při detekci hrany 1s pulzu a pokud neupravujeme čas
            if (CLK_1s = '1' and CLK_1s_prev = '0') and (editEN = '0') then
                seconds <= seconds + 1;
            end if;
    
            -- Time Correction
            if seconds > 59 then
                seconds <= 0;
                minutes <= minutes + 1;
                if minutes > 59 then
                    minutes <= 0;
                    hours <= hours + 1;
                    if hours > 23 then
                        hours <= 0;
                    end if;
                end if;
            end if;
    
            -- Edit Enable Trigger
            if editEN = '0' then
                if DOWN = '1' and prev_DOWN = '0' then
                    editEN <= '1';
                    ModeSelectDisableTimer <= '1';
                else
                    ModeSelectDisableTimer <= '0';
                end if;
            else
                editEN <= '1';
            end if;
    
            -- Editování času
            if editEN = '1' then
                if CENTER = '1' and prev_CENTER = '0' then
                    editEN <= '0';
                    ModeSelectDisableTimer <= '0';
                end if;
                prev_CENTER <= CENTER;
    
                if LEFT = '1' and prev_LEFT = '0' then
                    TimeEditTimer <= not Sig_TimeEdit;
                    Sig_TimeEdit <= not Sig_TimeEdit;
                end if;
                prev_LEFT <= LEFT;
    
                if RIGHT = '1' and prev_RIGHT = '0' then
                    TimeEditTimer <= not Sig_TimeEdit;
                    Sig_TimeEdit <= not Sig_TimeEdit;
                end if;
                prev_RIGHT <= RIGHT;
    
                if UP = '1' and prev_UP = '0' then
                    if Sig_TimeEdit = '0' then -- Editujeme minuty
                        if minutes < 59 then
                            minutes <= minutes + 1;
                        else
                            minutes <= 0;
                        end if;
                    else -- Editujeme hodiny
                        if hours < 23 then
                            hours <= hours + 1;
                        else
                            hours <= 0;
                        end if;
                    end if;
                end if;
                prev_UP <= UP;
    
                if DOWN = '1' and prev_DOWN = '0' then
                    if Sig_TimeEdit = '0' then -- Editujeme minuty
                        if minutes > 0 then
                            minutes <= minutes - 1;
                        else
                            minutes <= 59;
                        end if;
                    else -- Editujeme hodiny
                        if hours > 0 then
                            hours <= hours - 1;
                        else
                            hours <= 23;
                        end if;
                    end if;
                end if;
                prev_DOWN <= DOWN;
            end if;
    
            -- Výstup na displeje (BCD)
            Sec1  <= std_logic_vector(to_unsigned(seconds mod 10, 4));
            Sec10 <= std_logic_vector(to_unsigned(seconds / 10, 4));            
            Min1  <= std_logic_vector(to_unsigned(minutes mod 10, 4));
            Min10 <= std_logic_vector(to_unsigned(minutes / 10, 4));            
            Hour1  <= std_logic_vector(to_unsigned(hours mod 10, 4));
            Hour10 <= std_logic_vector(to_unsigned(hours / 10, 4));
    
        end if;
    end process;


end Behavioral;
