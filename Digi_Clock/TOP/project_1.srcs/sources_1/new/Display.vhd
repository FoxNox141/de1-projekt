library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display is
    Port (
        Seg0       : in STD_LOGIC_VECTOR(3 downto 0);
        Seg1       : in STD_LOGIC_VECTOR(3 downto 0);
        Seg2       : in STD_LOGIC_VECTOR(3 downto 0);
        Seg3       : in STD_LOGIC_VECTOR(3 downto 0);
        Seg4       : in STD_LOGIC_VECTOR(3 downto 0);
        Seg5       : in STD_LOGIC_VECTOR(3 downto 0);
        Seg6       : in STD_LOGIC_VECTOR(3 downto 0);
        Seg7       : in STD_LOGIC_VECTOR(3 downto 0);
        CLK100MHZ  : in STD_LOGIC;
        reset         : in STD_LOGIC;
        TimeEdit   : in STD_LOGIC;
        EditEnable : in STD_LOGIC;
        ANOut         : out STD_LOGIC_VECTOR(7 downto 0);
        seg_output : out STD_LOGIC_VECTOR(6 downto 0)      
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
    
    
    signal SegOut              : std_logic_vector (6 downto 0);
    signal CLK_1ms             : STD_LOGIC;
    signal counter             : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal TimeCounter         : integer range 0 to 199 := 0;
    signal CLK_200ms_tick       : STD_LOGIC := '0';
    signal CLK_200ms_prev       : STD_LOGIC := '0';
    signal blink_mask          : STD_LOGIC := '0';

    type data_array is array(0 to 7) of STD_LOGIC_VECTOR(3 downto 0);
    signal data_bank  : data_array;
    signal bin_input  : STD_LOGIC_VECTOR(3 downto 0);
    signal seg_temp   : STD_LOGIC_VECTOR(6 downto 0);

begin          

    -- 1ms clock pulse generator
    CLK_Pulse: component clock_enable
        generic map(
            N_PERIODS => 10   -- 100 MHz / 100000 = 1ms
        )
        port map(
            clk   => CLK100MHZ,
            rst   => reset,
            pulse => CLK_1ms
        );

    -- Binary to 7-segment converter
    DISP: Bin2Seg
        port map(
            clear => reset,
            bin   => bin_input,
            seg   => seg_temp
        );

    data_bank <= (Seg0, Seg1, Seg2, Seg3, Seg4, Seg5, Seg6, Seg7);
    -- 1ms process for segment counter and 200ms tick
    process(CLK_1ms)
    begin
        if rising_edge(CLK_1ms) then
            counter <= std_logic_vector(unsigned(counter) + 1);

            if TimeCounter = 199 then
                TimeCounter <= 0;
                CLK_200ms_tick <= '1';
            else
                TimeCounter <= TimeCounter + 1;
                CLK_200ms_tick <= '0';
            end if;
        end if;
    end process;

    -- Edge detection for 20ms tick
    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            CLK_200ms_prev <= CLK_200ms_tick;
            if CLK_200ms_tick = '1' and CLK_200ms_prev = '0' then
                blink_mask <= not blink_mask;
            end if;
        end if;
    end process;

    -- Select binary value for segment conversion
    bin_input <= data_bank(to_integer(unsigned(counter)));

    -- Output segments, with blinking if editing
    process(EditEnable, TimeEdit, counter, blink_mask, seg_temp)
    begin
        seg_output <= seg_temp;
    
        if (EditEnable = '1') and (blink_mask = '1') then
            if (TimeEdit) = '0' then
                if (counter = "010" or counter = "011") then
                    seg_output <= (others => '1');  -- Blikání pro segmenty 2 a 3
                end if;
            elsif (TimeEdit) = '1' then
                if (counter = "100" or counter = "101") then
                    seg_output <= (others => '1');  -- Blikání pro segmenty 4 a 5
                end if;
            end if;
        end if;
    end process;

    -- Activate corresponding digit (AN is active-low)
    process(counter)
    begin
        ANOut <= (others => '1');
        case counter is
            when "000" => ANOut(7) <= '0';
            when "001" => ANOut(6) <= '0';
            when "010" => ANOut(5) <= '0';
            when "011" => ANOut(4) <= '0';
            when "100" => ANOut(3) <= '0';
            when "101" => ANOut(2) <= '0';
            when "110" => ANOut(1) <= '0';
            when "111" => ANOut(0) <= '0';
            when others => ANOut <= (others => '1');
        end case;
    end process;

end Behavioral;
