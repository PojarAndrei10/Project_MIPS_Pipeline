----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2023 12:39:45 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
    Port ( opcode : in STD_LOGIC_VECTOR (2 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           AluControl : out STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           AluSrc : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           MemToReg : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           Jr : out STD_LOGIC; --Jr
           Bltz : out STD_LOGIC);
end UC;

architecture Behavioral of UC is

signal op_alu:std_logic_vector( 1 downto 0);

begin

process(opcode)
begin
RegDst <= '0'; 
ExtOp <= '0'; 
ALUSrc <= '0'; 
Branch <= '0'; 
Jump <= '0';
MemWrite <= '0';
MemToReg <= '0'; 
Jr <= '0'; 
Bltz <= '0';
RegWrite <= '0'; 

-- Aici facem ce trebuie pentru a crea tabelul de iesire pentru fiecare instructiune 
-- cu Instr(15 downto 13) care se refera la opcode,RegDst,ExtOp,AluSrc,Branch,Jump,MemWr,MemToReg,RegWr

case (opcode) is
         --ADDI
         when "001" => RegWrite <= '1';ALUsrc <= '1'; ExtOp <= '1'; 
                       op_alu <= "00";
         --LW
         when "010" => RegWrite <= '1'; ALUsrc <= '1'; ExtOp <= '1'; MemToReg <= '1'; 
                       op_alu <= "00"; 
         --SW
         when "011" => ALUsrc <= '1';  ExtOp <= '1'; MemWrite <= '1'; 
                       op_alu <= "00"; 
         --BEQ
         when "100" => ExtOp <= '1'; Branch <= '1'; 
                       op_alu <= "01"; 
         --BLTZ              
         when "101" => ExtOp <= '1'; Bltz <= '1'; 
         --JR
         when "110" => Jr <= '1';
         --J
         when "111" => Jump <= '1'; 
         --ADD,SUB,SLL,SRL,AND,OR,XOR,SRA
         when "000" => RegDst <= '1'; RegWrite <= '1'; 
                       op_alu <= "10"; 
end case;
end process;
         
process(op_alu,func)
begin
  if(op_alu = "10") then
    case (func) is
        when "000" => ALUControl <= "000"; -- +
        when "001" => ALUControl <= "100"; -- -
        when "100" => ALUControl <= "001"; -- and
        when "101" => ALUControl <= "010"; -- or
        when "010" => ALUControl <= "110"; -- sll
        when "011" => ALUControl <= "111"; -- srl
        when "110" => ALUControl<= "101"; -- sra 
        when "111" => ALUControl<= "011"; -- xor
end case;   
elsif 
   op_alu = "00" then 
        ALUControl <= "000";
elsif 
   op_alu = "01" then 
        ALUControl <= "100"; 
      
end if;
end process;
end Behavioral;
