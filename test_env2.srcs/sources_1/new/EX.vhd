----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2023 12:47:42 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           AluSrc : in STD_LOGIC;
           Sa : in STD_LOGIC;
           AluControl : in STD_LOGIC_VECTOR (2 downto 0);
           Iesire_Zero : out STD_LOGIC;
           Rez : out STD_LOGIC_VECTOR (15 downto 0));
end EX;

architecture Behavioral of EX is

signal q:std_logic_vector(15 downto 0);
signal w:std_logic_vector(15 downto 0);
signal ALURes:std_logic_vector(15 downto 0);

begin
q<=RD1;
process(RD2, Ext_imm,AluSrc)
begin
       if(ALUSrc = '0') then
            w <= RD2;
       else w <= Ext_Imm;     
end if;
end process;

process(AluControl,q,w)
begin
     case(AluControl) is
     when "000" => ALURes <= q+w ;
     when "100" => ALURes <= q-w;
     when "010" => ALURes <= q or w;
     when "001" => ALURes <= q and w;
     when "110" => ALURes <= q(14 downto 0) & '0';
     when "111" => ALURes <= '0' & q(15 downto 1);
     when "101" => if(q(15) = '0') then
     ALURes <= '0' & q(15 downto 1);
else ALURes <= '0' & q(15 downto 1);
end if;
     when "011" => ALURes <= q xor w;                
end case;
end process;

Iesire_Zero<='1' when ALURes=x"0000" 
                 else '0';
--rezultatul operatiei este stocat in Rez,mai precis in iesirea Alu care tine minte rezultatul
Rez<=ALURes;

end Behavioral;
