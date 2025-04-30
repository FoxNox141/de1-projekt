-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 23 Apr 2025 05:20:10 GMT
-- Request id : cfwk-fed377c2-6808788af1dee

library ieee;
use ieee.std_logic_1164.all;

entity tb_Debounce_Top is
end tb_Debounce_Top;

architecture tb of tb_Debounce_Top is

    component Debounce_Top
        port (clk       : in std_logic;
              rst       : in std_logic;
              buttons   : in std_logic_vector (4 downto 0);
              debounced : out std_logic_vector (4 downto 0));
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal buttons   : std_logic_vector (4 downto 0);
    signal debounced : std_logic_vector (4 downto 0);

    constant TbPeriod : time := 10 ns; -- 100 MHz clock
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Debounce_Top
    port map (clk       => clk,
              rst       => rst,
              buttons   => buttons,
              debounced => debounced);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- Connect the clock
    clk <= TbClock;

    stimuli : process
    begin
        -- Initialize signals
        rst <= '0';
        buttons <= (others => '0');

        -- Simulate button presses and releases
        wait for 5 * TbPeriod;  -- Wait for initial setup

        -- Simulate pressing button 0 for 20ms
        buttons(0) <= '1';  
        wait for 20 * TbPeriod;  -- 20ms

        -- Simulate releasing button 0
        buttons(0) <= '0';  
        wait for 10 * TbPeriod;  -- 10ms

        -- Simulate pressing button 1 for 20ms
        buttons(1) <= '1';  
        wait for 20 * TbPeriod;  -- 20ms

        -- Simulate releasing button 1
        buttons(1) <= '0';  
        wait for 10 * TbPeriod;  -- 10ms

        -- Repeat for other buttons
        buttons(2) <= '1';  
        wait for 20 * TbPeriod;  -- 20ms
        buttons(2) <= '0';  
        wait for 10 * TbPeriod;

        buttons(3) <= '1';  
        wait for 20 * TbPeriod;  -- 20ms
        buttons(3) <= '0';  
        wait for 10 * TbPeriod;

        buttons(4) <= '1';  
        wait for 20 * TbPeriod;  -- 20ms
        buttons(4) <= '0';  
        wait for 10 * TbPeriod;

        -- Stop the clock and end the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Debounce_Top of tb_Debounce_Top is
    for tb
    end for;
end cfg_tb_Debounce_Top;
