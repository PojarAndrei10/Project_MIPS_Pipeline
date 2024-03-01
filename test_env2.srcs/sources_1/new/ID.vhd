----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2023 12:13:22 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
    Port ( clk : in STD_LOGIC;
           RegWr : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           enable : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           Wd : in STD_LOGIC_VECTOR (15 downto 0);
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm:out STD_LOGIC_VECTOR(15 downto 0);
           WA:in std_logic_vector(2 downto 0);
           Func : out STD_LOGIC_VECTOR (2 downto 0);
           Sa : out STD_LOGIC);
end ID;

architecture Behavioral of ID is

component Reg_file is
    Port ( clk : in STD_LOGIC;
           enable:in STD_LOGIC;
           RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           RegWr : in STD_LOGIC);
end component;


begin

-- port map pentru reg file
RF: Reg_file port map(clk=>clk,enable=>enable,RA1=>Instr(12 downto 10),RA2=>Instr( 9 downto 7),
          WA=>WA,WD=>Wd,RD1=>RD1,RD2=>RD2,RegWr=>RegWr);
          
--process(RegDst,Instr)
--begin
--if(RegDst='0') then 
  --   wa<=Instr(9 downto 7);
--else wa<=Instr(6 downto 4);
--end if;
--end process;

process(ExtOp,Instr)
begin
case (ExtOp) is
      when '0' => Ext_Imm <= "000000000" & Instr(6 downto 0);
      when '1' => if(Instr(6)='1' ) then
               Ext_Imm<="111111111" & Instr(6 downto 0);
            else Ext_Imm<="000000000" & Instr(6 downto 0);
end if;
end case;
end process;
            
Func<=Instr(2 downto 0);
Sa<=Instr(3);

end Behavioral;
