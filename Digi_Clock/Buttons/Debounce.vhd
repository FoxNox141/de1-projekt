library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Debounce_Top is
    Port (
        clk      : in  std_logic;                -- 100 MHz clock
        rst      : in  std_logic;                -- reset
        buttons  : in  std_logic_vector(4 downto 0); -- vstup z tlačítek
        debounced: out std_logic_vector(4 downto 0)  -- výstup debounce
    );
end Debounce_Top;

architecture Behavioral of Debounce_Top is

    component clock_enable
        generic (
            N_PERIODS : integer
        );
        Port (
            clk   : in std_logic;
            rst   : in std_logic;
            pulse : out std_logic
        );
    end component;

    component DFF_Debouncing_Button
        Port (
            clk           : in  std_logic;
            clock_enable  : in  std_logic;
            D             : in  std_logic;
            Q             : out std_logic := '0'
        );
    end component;

    signal slow_pulse : std_logic;
    signal Q0, Q1, Q2 : std_logic_vector(4 downto 0);
    signal Q2_bar     : std_logic_vector(4 downto 0);

begin

    clk_gen: clock_enable
        generic map (
            N_PERIODS => 10  -- 1ms for 100 MHz clock --100_000
        )
        port map (
            clk   => clk,
            rst   => rst,
            pulse => slow_pulse
        );

    -- Pro každé tlačítko vytvoříme 3x DFF (posuvný registr)
    gen_button: for i in 0 to 4 generate
        FF0: DFF_Debouncing_Button
            port map (
                clk          => clk,
                clock_enable => slow_pulse,
                D            => buttons(i),
                Q            => Q0(i)
            );

        FF1: DFF_Debouncing_Button
            port map (
                clk          => clk,
                clock_enable => slow_pulse,
                D            => Q0(i),
                Q            => Q1(i)
            );

        FF2: DFF_Debouncing_Button
            port map (
                clk          => clk,
                clock_enable => slow_pulse,
                D            => Q1(i),
                Q            => Q2(i)
            );

        Q2_bar(i)      <= not Q2(i);
        debounced(i)   <= Q1(i) and Q2_bar(i);
    end generate;

end Behavioral;
