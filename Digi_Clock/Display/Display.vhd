library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display is
    Port (
        Seg0       : in STD_LOGIC_VECTOR(6 downto 0);
        Seg1       : in STD_LOGIC_VECTOR(6 downto 0);
        Seg2       : in STD_LOGIC_VECTOR(6 downto 0);
        Seg3       : in STD_LOGIC_VECTOR(6 downto 0);
        Seg4       : in STD_LOGIC_VECTOR(6 downto 0);
        Seg5       : in STD_LOGIC_VECTOR(6 downto 0);
        Seg6       : in STD_LOGIC_VECTOR(6 downto 0);
        Seg7       : in STD_LOGIC_VECTOR(6 downto 0);
        TimeEdit   : in STD_LOGIC_VECTOR(3 downto 0);
        EditEnable : in STD_LOGIC;
        CLK100MHZ  : in STD_LOGIC;
        RSTSw      : in std_logic;
        ANOut      : out STD_LOGIC_VECTOR(7 downto 0);
        SegOut     : out STD_LOGIC_VECTOR(6 downto 0)
    );
end Display;

architecture Behavioral of Display is

    component Bin2Seg is
        Port (
            clear : in STD_LOGIC;
            bin   : in STD_LOGIC_VECTOR(3 downto 0);
            seg   : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

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

    signal CLK_1ms : STD_LOGIC;
    signal CLK_20ms : STD_LOGIC;
    signal counter : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal TimeCounter : integer range 0 to 19 := 0;
    type data_array is array(0 to 7) of STD_LOGIC_VECTOR(3 downto 0);
    signal data_bank : data_array;
    signal bin_input : STD_LOGIC_VECTOR(3 downto 0);
    signal seg_output : STD_LOGIC_VECTOR(6 downto 0);
    signal blink_mask : STD_LOGIC := '0';

begin


    CLK_Pulse: component clock_enable
        generic map(
            N_PERIODS => 100_000
        )
        port map(
            clk => CLK100MHZ,
            rst => RSTSw,
            pulse=>CLK_1ms
        );
        
     DISP: bin2seg
        port map(
            clear =>RSTSw,
            bin =>bin_input,
            seg =>seg_output
        );
        
       -- Pocitani aktivni pozice segmentu
    process(CLK_1ms)
    begin
        if rising_edge(CLK_1ms) then
            counter <= std_logic_vector(unsigned(counter) + 1);
            if TimeCounter = 19 then
                TimeCounter <= 0;
                CLK_20ms <= '1';
            else
                TimeCounter <= TimeCounter + 1;
                CLK_20ms <= '0';
            end if;
        end if;
    end process;
    
         
    -- Blikaci maska
    process(CLK_20ms)
    begin
        if rising_edge(CLK_20ms) then
            blink_mask <= not blink_mask;
        end if;
    end process;

    -- Naplneni dat ze vstupu
    process(Seg0, Seg1, Seg2, Seg3, Seg4, Seg5, Seg6, Seg7)
    begin
        data_bank(0) <= Seg0(3 downto 0);
        data_bank(1) <= Seg1(3 downto 0);
        data_bank(2) <= Seg2(3 downto 0);
        data_bank(3) <= Seg3(3 downto 0);
        data_bank(4) <= Seg4(3 downto 0);
        data_bank(5) <= Seg5(3 downto 0);
        data_bank(6) <= Seg6(3 downto 0);
        data_bank(7) <= Seg7(3 downto 0);
    end process;

    -- Vyber binarni hodnoty pro prevod
    bin_input <= data_bank(to_integer(unsigned(counter)));


    -- Zhasnuti segmentu pri editaci
    process(EditEnable, TimeEdit, counter, blink_mask, seg_output)
    begin
        if (EditEnable = '1' and TimeEdit = counter and blink_mask = '1') then
            SegOut <= (others => '0');  -- bliknuti editovane pozice
        else
            SegOut <= seg_output;
        end if;
    end process;

    -- Aktivace prislusneho segmentu ANOut (aktivni LOW)
    process(counter)
    begin
        ANOut <= (others => '1');
        case counter is
            when "000" => ANOut(0) <= '0';
            when "001" => ANOut(1) <= '0';
            when "010" => ANOut(2) <= '0';
            when "011" => ANOut(3) <= '0';
            when "100" => ANOut(4) <= '0';
            when "101" => ANOut(5) <= '0';
            when "110" => ANOut(6) <= '0';
            when "111" => ANOut(7) <= '0';
            when others => ANOut <= (others => '1');
        end case;
    end process;

end Behavioral;
