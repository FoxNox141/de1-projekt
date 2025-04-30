-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 27 Apr 2025 08:02:11 GMT
-- Request id : cfwk-fed377c2-680de483cb407

library ieee;
use ieee.std_logic_1164.all;

entity tb_Display is
end tb_Display;

architecture tb of tb_Display is

    component Display
        port (Seg0       : in std_logic_vector (3 downto 0);
              Seg1       : in std_logic_vector (3 downto 0);
              Seg2       : in std_logic_vector (3 downto 0);
              Seg3       : in std_logic_vector (3 downto 0);
              Seg4       : in std_logic_vector (3 downto 0);
              Seg5       : in std_logic_vector (3 downto 0);
              Seg6       : in std_logic_vector (3 downto 0);
              Seg7       : in std_logic_vector (3 downto 0);
              CLK100MHZ  : in std_logic;
              reset      : in std_logic;
              TimeEdit   : in std_logic;
              EditEnable : in std_logic;
              ANOut      : out std_logic_vector (7 downto 0);
              seg_output : out std_logic_vector (6 downto 0));
    end component;

    signal Seg0       : std_logic_vector (3 downto 0);
    signal Seg1       : std_logic_vector (3 downto 0);
    signal Seg2       : std_logic_vector (3 downto 0);
    signal Seg3       : std_logic_vector (3 downto 0);
    signal Seg4       : std_logic_vector (3 downto 0);
    signal Seg5       : std_logic_vector (3 downto 0);
    signal Seg6       : std_logic_vector (3 downto 0);
    signal Seg7       : std_logic_vector (3 downto 0);
    signal CLK100MHZ  : std_logic;
    signal reset      : std_logic;
    signal TimeEdit   : std_logic;
    signal EditEnable : std_logic;
    signal ANOut      : std_logic_vector (7 downto 0);
    signal seg_output : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 1000 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Display
    port map (Seg0       => Seg0,
              Seg1       => Seg1,
              Seg2       => Seg2,
              Seg3       => Seg3,
              Seg4       => Seg4,
              Seg5       => Seg5,
              Seg6       => Seg6,
              Seg7       => Seg7,
              CLK100MHZ  => CLK100MHZ,
              reset      => reset,
              TimeEdit   => TimeEdit,
              EditEnable => EditEnable,
              ANOut      => ANOut,
              seg_output => seg_output);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that CLK100MHZ is really your main clock signal
    CLK100MHZ <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        Seg0 <= (others => '0');
        Seg1 <= (others => '0');
        Seg2 <= (others => '0');
        Seg3 <= (others => '0');
        Seg4 <= (others => '0');
        Seg5 <= (others => '0');
        Seg6 <= (others => '0');
        Seg7 <= (others => '0');
        TimeEdit <= '0';
        EditEnable <= '0';

        -- Reset generation
        -- ***EDIT*** Check that reset is really your reset signal
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        seg0<= "0000";
        seg1<= "0001";
        seg2<= "0010";
        seg3<= "0011";
        seg4<= "0100";
        seg5<= "0101";
        seg6<= "0110";
        seg7<= "0110";
        
        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Display of tb_Display is
    for tb
    end for;
end cfg_tb_Display;