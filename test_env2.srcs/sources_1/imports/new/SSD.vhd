----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2023 09:45:23 AM
-- Design Name: 
-- Module Name: SSD - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( counter : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end SSD;

architecture Behavioral of SSD is

signal count_int : std_logic_vector(15 downto 0) :="0000000000000000";
signal input1:std_logic_vector(1 downto 0):="00";
signal mux_1:std_logic_vector(3 downto 0):="0000";

begin

process (clk) 
begin
if clk'event and clk='1'then
count_int <= count_int + 1;
end if;
end process;
input1<=count_int(15 downto 14);
process (clk,input1)
begin
   case input1 is
      when "00" => an <= "0111";
      when "01" => an <= "1011";
      when "10" => an <= "1101";
      when others => an <= "1110";
   end case;
end process;

process (clk,input1)
begin
   case input1 is
      when "00" => mux_1 <= counter(15 downto 12);
      when "01" => mux_1 <=counter(11 downto 8);
      when "10" => mux_1 <= counter(7 downto 4);
      when "11" => mux_1 <= counter(3 downto 0);
      when others => mux_1 <= "0000";
   end case;
end process;
 with mux_1 SELect
  cat<= "1111001" when "0001",   --1
        "0100100" when "0010",   --2
        "0110000" when "0011",   --3
        "0011001" when "0100",   --4
        "0010010" when "0101",   --5
        "0000010" when "0110",   --6
        "1111000" when "0111",   --7
        "0000000" when "1000",   --8
        "0010000" when "1001",   --9
        "0001000" when "1010",   --A
        "0000011" when "1011",   --b
        "1000110" when "1100",   --C
        "0100001" when "1101",   --d
        "0000110" when "1110",   --E
        "0001110" when "1111",   --F
        "1000000" when others;   --0

end Behavioral;
