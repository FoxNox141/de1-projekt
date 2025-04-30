-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 27 Apr 2025 12:53:45 GMT
-- Request id : cfwk-fed377c2-680e28d91a886

library ieee;
use ieee.std_logic_1164.all;

entity tb_TimeBlock is
end tb_TimeBlock;

architecture tb of tb_TimeBlock is

    component TimeBlock
        port (CLK                    : in std_logic;
              ModeSelect             : in std_logic_vector (2 downto 0);
              UP                     : in std_logic;
              DOWN                   : in std_logic;
              LEFT                   : in std_logic;
              RIGHT                  : in std_logic;
              CENTER                 : in std_logic;
              rst                    : in std_logic;
              TimeEditTimer          : out std_logic;
              ModeSelectDisableTimer : out std_logic;
              Sec1                   : out std_logic_vector (3 downto 0);
              Sec10                  : out std_logic_vector (3 downto 0);
              Min1                   : out std_logic_vector (3 downto 0);
              Min10                  : out std_logic_vector (3 downto 0);
              Hour1                  : out std_logic_vector (3 downto 0);
              Hour10                 : out std_logic_vector (3 downto 0));
    end component;

    signal CLK                    : std_logic;
    signal ModeSelect             : std_logic_vector (2 downto 0);
    signal UP                     : std_logic;
    signal DOWN                   : std_logic;
    signal LEFT                   : std_logic;
    signal RIGHT                  : std_logic;
    signal CENTER                 : std_logic;
    signal rst                    : std_logic;
    signal TimeEditTimer          : std_logic;
    signal ModeSelectDisableTimer : std_logic;
    signal Sec1                   : std_logic_vector (3 downto 0);
    signal Sec10                  : std_logic_vector (3 downto 0);
    signal Min1                   : std_logic_vector (3 downto 0);
    signal Min10                  : std_logic_vector (3 downto 0);
    signal Hour1                  : std_logic_vector (3 downto 0);
    signal Hour10                 : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 1000 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : TimeBlock
    port map (CLK                    => CLK,
              ModeSelect             => ModeSelect,
              UP                     => UP,
              DOWN                   => DOWN,
              LEFT                   => LEFT,
              RIGHT                  => RIGHT,
              CENTER                 => CENTER,
              rst                    => rst,
              TimeEditTimer          => TimeEditTimer,
              ModeSelectDisableTimer => ModeSelectDisableTimer,
              Sec1                   => Sec1,
              Sec10                  => Sec10,
              Min1                   => Min1,
              Min10                  => Min10,
              Hour1                  => Hour1,
              Hour10                 => Hour10);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        ModeSelect <= (others => '0');
        UP <= '0';
        DOWN <= '0';
        LEFT <= '0';
        RIGHT <= '0';
        CENTER <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 1000000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_TimeBlock of tb_TimeBlock is
    for tb
    end for;
end cfg_tb_TimeBlock;