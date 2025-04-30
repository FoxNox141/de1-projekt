-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 27 Apr 2025 12:06:12 GMT
-- Request id : cfwk-fed377c2-680e1db4bc0f0

library ieee;
use ieee.std_logic_1164.all;

entity tb_TopLevel is
end tb_TopLevel;

architecture tb of tb_TopLevel is

    component TopLevel
        port (BTNC      : in std_logic;
              BTNU      : in std_logic;
              BTNL      : in std_logic;
              BTNR      : in std_logic;
              BTND      : in std_logic;
              CLK100MHZ : in std_logic;
              SW_A      : in std_logic;
              CA        : out std_logic;
              CB        : out std_logic;
              CC        : out std_logic;
              CD        : out std_logic;
              CE        : out std_logic;
              CF        : out std_logic;
              CG        : out std_logic;
              AN        : out std_logic_vector (7 downto 0);
              LED16_B   : out std_logic);
    end component;

    signal BTNC      : std_logic;
    signal BTNU      : std_logic;
    signal BTNL      : std_logic;
    signal BTNR      : std_logic;
    signal BTND      : std_logic;
    signal CLK100MHZ : std_logic;
    signal SW_A      : std_logic;
    signal CA        : std_logic;
    signal CB        : std_logic;
    signal CC        : std_logic;
    signal CD        : std_logic;
    signal CE        : std_logic;
    signal CF        : std_logic;
    signal CG        : std_logic;
    signal AN        : std_logic_vector (7 downto 0);
    signal LED16_B   : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : TopLevel
    port map (BTNC      => BTNC,
              BTNU      => BTNU,
              BTNL      => BTNL,
              BTNR      => BTNR,
              BTND      => BTND,
              CLK100MHZ => CLK100MHZ,
              SW_A      => SW_A,
              CA        => CA,
              CB        => CB,
              CC        => CC,
              CD        => CD,
              CE        => CE,
              CF        => CF,
              CG        => CG,
              AN        => AN,
              LED16_B   => LED16_B);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that CLK100MHZ is really your main clock signal
    CLK100MHZ <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        BTNC <= '0';
        BTNU <= '0';
        BTNL <= '0';
        BTNR <= '0';
        BTND <= '0';
        SW_A <= '0';

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

          
        
        BTNU <= '1';
        wait for 100* TbPeriod;
        BTNU <= '0';
        wait for 100* TbPeriod;
        
        BTNU <= '1';
        wait for 100* TbPeriod;
        BTNU <= '0';
        wait for 100* TbPeriod;
        
        BTND <= '1';
        wait for 100* TbPeriod;
        BTND <= '0';
        wait for 100* TbPeriod;
         
        BTNL <= '1';
        wait for 100* TbPeriod;
        BTNL <= '0';
        wait for 100* TbPeriod;
        
        BTNU <= '1';
        wait for 100* TbPeriod;
        BTNU <= '0';
        wait for 100* TbPeriod;      
          
        BTNU <= '1';
        wait for 100* TbPeriod;
        BTNU <= '0';
        wait for 100* TbPeriod;
        
        BTNU <= '1';
        wait for 100* TbPeriod;
        BTNU <= '0';
        wait for 100* TbPeriod;    
                
        BTNC <= '1';
        wait for 100* TbPeriod;
        BTNC <= '0';
        wait for 100* TbPeriod;
                     
        BTNU <= '1';
        wait for 100* TbPeriod;
        BTNU <= '0';
        wait for 100* TbPeriod;
       
        BTNL <= '1';
        wait for 100* TbPeriod;
        BTNL <= '0';
        wait for 1000* TbPeriod;
                
        BTNR <= '1';
        wait for 100* TbPeriod;
        BTNR <= '0';
        wait for 100* TbPeriod;       
          
        BTNU <= '1';
        wait for 100* TbPeriod;
        BTNU <= '0';
        wait for 100ms;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_TopLevel of tb_TopLevel is
    for tb
    end for;
end cfg_tb_TopLevel;