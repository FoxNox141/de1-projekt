-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 27 Apr 2025 07:19:34 GMT
-- Request id : cfwk-fed377c2-680dda86cc3cd

library ieee;
use ieee.std_logic_1164.all;

entity tb_alarm is
end tb_alarm;

architecture tb of tb_alarm is

    component alarm
        port (clk_100mhz             : in std_logic;
              reset                  : in std_logic;
              mode_select            : in std_logic_vector (2 downto 0);
              up                     : in std_logic;
              down                   : in std_logic;
              left                   : in std_logic;
              right                  : in std_logic;
              center                 : in std_logic;
              hour10                 : in std_logic_vector (3 downto 0);
              hour1                  : in std_logic_vector (3 downto 0);
              min10                  : in std_logic_vector (3 downto 0);
              min1                   : in std_logic_vector (3 downto 0);
              time_edit              : out std_logic;
              modeselectdisableAlarm : out std_logic;
              alarm_out              : out std_logic);
    end component;

    signal clk_100mhz             : std_logic;
    signal reset                  : std_logic;
    signal mode_select            : std_logic_vector (2 downto 0);
    signal up                     : std_logic;
    signal down                   : std_logic;
    signal left                   : std_logic;
    signal right                  : std_logic;
    signal center                 : std_logic;
    signal hour10                 : std_logic_vector (3 downto 0);
    signal hour1                  : std_logic_vector (3 downto 0);
    signal min10                  : std_logic_vector (3 downto 0);
    signal min1                   : std_logic_vector (3 downto 0);
    signal time_edit              : std_logic;
    signal modeselectdisableAlarm : std_logic;
    signal alarm_out              : std_logic;

    constant TbPeriod : time := 1000 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : alarm
    port map (clk_100mhz             => clk_100mhz,
              reset                  => reset,
              mode_select            => mode_select,
              up                     => up,
              down                   => down,
              left                   => left,
              right                  => right,
              center                 => center,
              hour10                 => hour10,
              hour1                  => hour1,
              min10                  => min10,
              min1                   => min1,
              time_edit              => time_edit,
              modeselectdisableAlarm => modeselectdisableAlarm,
              alarm_out              => alarm_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk_100mhz is really your main clock signal
    clk_100mhz <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        mode_select <= (others => '0');
        up <= '0';
        down <= '0';
        left <= '0';
        right <= '0';
        center <= '0';
        hour10 <= (others => '0');
        hour1 <= (others => '0');
        min10 <= (others => '0');
        min1 <= (others => '0');

        -- Reset generation
        -- ***EDIT*** Check that reset is really your reset signal
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Nastavení času v systému na 00:00
        hour10 <= "0000";
        hour1 <= "0000";
        min10 <= "0000";
        min1 <= "0000";
        
        -- Následně musíš simulovat spuštění budíku - například DOWN + mód na "010" a CENTER
        mode_select <= "010"; -- Mód Alarm
        down <= '1'; 
        wait for 10 * TbPeriod;
        down <= '0'; 
        wait for 10 * TbPeriod;
        
        -- Teď se dostaneš do editačního režimu.
        
        -- Simuluj potvrzení budíku (CENTER)
  
        left <= '1'; 
        wait for 10 * TbPeriod;
        left <= '0'; 
        wait for 10 * TbPeriod;
        
        up <= '1'; 
        wait for 10 * TbPeriod;
        up <= '0'; 
        wait for 10 * TbPeriod;
        
        center <= '1';
        wait for 10 * TbPeriod;
        center <= '0';
        wait for 10 * TbPeriod;
        
        -- Teď je alarm aktivní.
        
        -- Teď by měl alarm_out začít blikat, pokud časy souhlasí
        wait for 5000 * TbPeriod;
        
        min1<= "0001";
        wait for 5000 * TbPeriod;        
        
        min1<= "0010";
        wait for 5000 * TbPeriod;
        
        
        
        
        
        TbSimEnded <= '1'; -- Ukončení simulace
        wait;
        
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_alarm of tb_alarm is
    for tb
    end for;
end cfg_tb_alarm;