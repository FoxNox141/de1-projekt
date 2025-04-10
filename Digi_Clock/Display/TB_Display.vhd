library ieee;
use ieee.std_logic_1164.all;

entity tb_Display is
end tb_Display;

architecture tb of tb_Display is

    component Display
        port (Seg0       : in std_logic_vector (6 downto 0);
              Seg1       : in std_logic_vector (6 downto 0);
              Seg2       : in std_logic_vector (6 downto 0);
              Seg3       : in std_logic_vector (6 downto 0);
              Seg4       : in std_logic_vector (6 downto 0);
              Seg5       : in std_logic_vector (6 downto 0);
              Seg6       : in std_logic_vector (6 downto 0);
              Seg7       : in std_logic_vector (6 downto 0);
              TimeEdit   : in std_logic_vector (3 downto 0);
              EditEnable : in std_logic;
              CLK100MHZ  : in std_logic;
              RSTSw      : in std_logic;
              ANOut      : out std_logic_vector (7 downto 0);
              SegOut     : out std_logic_vector (6 downto 0));
    end component;

    signal Seg0       : std_logic_vector (6 downto 0);
    signal Seg1       : std_logic_vector (6 downto 0);
    signal Seg2       : std_logic_vector (6 downto 0);
    signal Seg3       : std_logic_vector (6 downto 0);
    signal Seg4       : std_logic_vector (6 downto 0);
    signal Seg5       : std_logic_vector (6 downto 0);
    signal Seg6       : std_logic_vector (6 downto 0);
    signal Seg7       : std_logic_vector (6 downto 0);
    signal TimeEdit   : std_logic_vector (3 downto 0);
    signal EditEnable : std_logic;
    signal CLK100MHZ  : std_logic;
    signal RSTSw      : std_logic;
    signal ANOut      : std_logic_vector (7 downto 0);
    signal SegOut     : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
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
              TimeEdit   => TimeEdit,
              EditEnable => EditEnable,
              CLK100MHZ  => CLK100MHZ,
              RSTSw      => RSTSw,
              ANOut      => ANOut,
              SegOut     => SegOut);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that CLK100MHZ is really your main clock signal
    CLK100MHZ <= TbClock;

    stimuli : process
    begin
        -- Initialize segment values
        Seg0 <= "0000000"; -- Display 0
        Seg1 <= "0000001"; -- Display 1
        Seg2 <= "0000010"; -- Display 2
        Seg3 <= "0000011"; -- Display 3
        Seg4 <= "0000100"; -- Display 4
        Seg5 <= "0000101"; -- Display 5
        Seg6 <= "0000110"; -- Display 6
        Seg7 <= "0000111"; -- Display 7
        TimeEdit <= "0011"; -- Initial TimeEdit value (for example)
        EditEnable <= '0';

        -- Reset generation
        RSTSw <= '1';
        wait for 10 ns;
        RSTSw <= '0';
        wait for 10 ns;

        -- Change EditEnable to '1' and TimeEdit to '3' after some time
        wait for 100 * TbPeriod;
        EditEnable <= '1';
        TimeEdit <= "0011"; -- Set TimeEdit to value 3

        -- Wait for some more time
        wait for 500 * TbPeriod;

        -- Stop the clock and terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Display of tb_Display is
    for tb
    end for;
end cfg_tb_Display;
