library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stopwatch is
    Port (
        clk_100mhz  : in  STD_LOGIC;  -- 100 MHz vstup
        reset       : in  STD_LOGIC;  -- Reset tlačidlo
        start       : in  STD_LOGIC;  -- Štart (UpBTN)
        stop        : in  STD_LOGIC;  -- Stop (DownBTN)
        mode_select : in  STD_LOGIC_VECTOR(2 downto 0); -- Výber módu
        minutes10   : out STD_LOGIC_VECTOR(3 downto 0) :="0000"; -- Desiatky minút
        minutes1    : out STD_LOGIC_VECTOR(3 downto 0) :="0000"; -- Jednotky minút
        seconds10   : out STD_LOGIC_VECTOR(3 downto 0) :="0000"; -- Desiatky sekúnd
        seconds1    : out STD_LOGIC_VECTOR(3 downto 0) :="0000"; -- Jednotky sekúnd
        ms100       : out STD_LOGIC_VECTOR(3 downto 0) :="0000"; -- Stovky milisekúnd
        ms10        : out STD_LOGIC_VECTOR(3 downto 0) :="0000"  -- Desiatky milisekúnd
        -- ms1 odstránené
    );
end stopwatch;

architecture Behavioral of stopwatch is


    -- Definícia komponenty clock_enable
    component clock_enable is
        generic (
            N_PERIODS : integer
        );
        Port (
            clk   : in  STD_LOGIC;
            rst   : in  STD_LOGIC;
            pulse : out STD_LOGIC
        );
    end component;
    
    signal clk_1ms : STD_LOGIC;  -- Interný 1 kHz signál generovaný clock_enable
    signal running : STD_LOGIC := '0';
    signal start_prev, stop_prev : STD_LOGIC := '0'; -- Detekcia stlačenia
    signal ms_counter : unsigned(3 downto 0) := (others => '0'); -- Počítadlo na 10 ms
    signal ms10_reg, ms100_reg : unsigned(3 downto 0) := (others => '0');
    signal seconds1_reg, seconds10_reg : unsigned(3 downto 0) := (others => '0');
    signal minutes1_reg, minutes10_reg : unsigned(3 downto 0) := (others => '0');

begin
    -- Inštancia clock_enable na generovanie 1 kHz (1 ms) z 100 MHz
    CLK_PULSE : component clock_enable
        generic map (
            N_PERIODS => 10       --100_000
        )
        port map (
            clk => clk_100mhz,
            rst => reset,
            pulse => clk_1ms
        );

    process(clk_1ms)
begin
    if rising_edge(clk_1ms) then

        -- Reset
        if reset = '1' then
            ms_counter <= (others => '0');
            ms10_reg <= (others => '0');
            ms100_reg <= (others => '0');
            seconds1_reg <= (others => '0');
            seconds10_reg <= (others => '0');
            minutes1_reg <= (others => '0');
            minutes10_reg <= (others => '0');
            running <= '0';
            start_prev <= '0';
            stop_prev <= '0';

        else
            -- Tlačidlá
            if mode_select = "000" then
                if start = '1' and start_prev = '0' then
                    running <= '1';
                end if;
                start_prev <= start;

                if stop = '1' and stop_prev = '0' then
                    running <= '0';
                end if;
                stop_prev <= stop;
            end if;

            -- Počítanie času
            if running = '1' then
                if ms_counter = 9 then
                    ms_counter <= (others => '0');
                    if ms10_reg = 9 then
                        ms10_reg <= (others => '0');
                        if ms100_reg = 9 then
                            ms100_reg <= (others => '0');
                            if seconds1_reg = 9 then
                                seconds1_reg <= (others => '0');
                                if seconds10_reg = 5 then
                                    seconds10_reg <= (others => '0');
                                    if minutes1_reg = 9 then
                                        minutes1_reg <= (others => '0');
                                        if minutes10_reg = 9 then
                                            minutes10_reg <= (others => '0');
                                        else
                                            minutes10_reg <= minutes10_reg + 1;
                                        end if;
                                    else
                                        minutes1_reg <= minutes1_reg + 1;
                                    end if;
                                else
                                    seconds10_reg <= seconds10_reg + 1;
                                end if;
                            else
                                seconds1_reg <= seconds1_reg + 1;
                            end if;
                        else
                            ms100_reg <= ms100_reg + 1;
                        end if;
                    else
                        ms10_reg <= ms10_reg + 1;
                    end if;
                else
                    ms_counter <= ms_counter + 1;
                end if;
            end if;
        end if;
    end if;
end process;


    -- Výstupy
    minutes10 <= std_logic_vector(minutes10_reg);
    minutes1 <= std_logic_vector(minutes1_reg);
    seconds10 <= std_logic_vector(seconds10_reg);
    seconds1 <= std_logic_vector(seconds1_reg);
    ms100 <= std_logic_vector(ms100_reg);
    ms10 <= std_logic_vector(ms10_reg);
    -- ms1 odstránené
end Behavioral;

