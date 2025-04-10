----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/12/2025 02:46:44 PM
-- Design Name: 
-- Module Name: clock_enable - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_enable is
    generic(
        N_PERIODS : integer := 10_000_000
        );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC);
end clock_enable;

architecture Behavioral of clock_enable is
    signal sig_cnt: integer range 0 to N_PERIODS-1;
begin
    p_clk_enable : process (clk) is
    begin
        if(rising_edge(clk)) then
            if rst = '1' then
                sig_cnt <=0;
            elsif sig_cnt < N_PERIODS-1 then
                sig_cnt <= sig_cnt + 1;
            else 
                sig_cnt <=0;
            end if;
        end if;
    end process p_clk_enable;
    
    pulse <= '1' when sig_cnt = N_PERIODS-1 else 
             '0';
end Behavioral;
