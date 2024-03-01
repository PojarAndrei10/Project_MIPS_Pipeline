----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2023 04:25:58 PM
-- Design Name: 
-- Module Name: Reg_file - Behavioral
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

entity Reg_file is
    Port ( clk : in STD_LOGIC;
           enable:in STD_LOGIC;
           RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           RD1 : out STD_LOGIC_VECTOR (15 downto 0); 
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           RegWr : in STD_LOGIC);
end Reg_file;

architecture Behavioral of Reg_file is
type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (
 x"0001",x"0201",x"2402",x"ABCD",x"1BCA",
 others => x"0000"
);

begin
process(clk) 
      begin
        if falling_edge(clk) then  --se testeaza frontul descrescator clk=0 and clk'event
            if(RegWr = '1' and enable = '1') then
                reg_file(conv_integer(WA)) <= WD;
end if;
end if;
end process;

RD1 <= reg_file(conv_integer(RA1));
RD2 <= reg_file(conv_integer(RA2));

end Behavioral;
