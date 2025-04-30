-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 27 Apr 2025 06:56:03 GMT
-- Request id : cfwk-fed377c2-680dd5031deca

library ieee;
use ieee.std_logic_1164.all;

entity tb_stopwatch is
end tb_stopwatch;

architecture tb of tb_stopwatch is

    component stopwatch
        port (clk_100mhz  : in std_logic;
              reset       : in std_logic;
              start       : in std_logic;
              stop        : in std_logic;
              mode_select : in std_logic_vector (2 downto 0);
              minutes10   : out std_logic_vector (3 downto 0);
              minutes1    : out std_logic_vector (3 downto 0);
              seconds10   : out std_logic_vector (3 downto 0);
              seconds1    : out std_logic_vector (3 downto 0);
              ms100       : out std_logic_vector (3 downto 0);
              ms10        : out std_logic_vector (3 downto 0));
    end component;

    signal clk_100mhz  : std_logic;
    signal reset       : std_logic;
    signal start       : std_logic;
    signal stop        : std_logic;
    signal mode_select : std_logic_vector (2 downto 0);
    signal minutes10   : std_logic_vector (3 downto 0);
    signal minutes1    : std_logic_vector (3 downto 0);
    signal seconds10   : std_logic_vector (3 downto 0);
    signal seconds1    : std_logic_vector (3 downto 0);
    signal ms100       : std_logic_vector (3 downto 0);
    signal ms10        : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 1000 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : stopwatch
    port map (clk_100mhz  => clk_100mhz,
              reset       => reset,
              start       => start,
              stop        => stop,
              mode_select => mode_select,
              minutes10   => minutes10,
              minutes1    => minutes1,
              seconds10   => seconds10,
              seconds1    => seconds1,
              ms100       => ms100,
              ms10        => ms10);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk_100mhz is really your main clock signal
    clk_100mhz <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        start <= '0';
        stop <= '0';
        mode_select <= (others => '0');

        -- Reset generation
        -- ***EDIT*** Check that reset is really your reset signal
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;
        
        mode_select <= "000";
        start <= '1';
        wait for 100 * TbPeriod;
        start <= '0';
        
        wait for 1000000 * TbPeriod;wait for 1000000 * TbPeriod;wait for 1000000 * TbPeriod;
        stop <= '1';
        wait for 100 * TbPeriod;
        stop <= '0';
        

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_stopwatch of tb_stopwatch is
    for tb
    end for;
end cfg_tb_stopwatch;