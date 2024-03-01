----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2023 01:00:20 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    Port ( MemWrite : in STD_LOGIC;
           enable : in STD_LOGIC;
           clk : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
type ram_type is array (0 to 64) of std_logic_vector (15 downto 0);
signal RAM: ram_type := (
  
    --LUNGIME VECTOR
    x"0009",            --$0
    --PRIMUL MAXIM
    x"0000",            --$1
    --AL DOILEA MAXIM
    x"0000",            --$2
    --CMMDC 
    x"0000",            --$3
    
    -- DECLARARE ELEMENTE ARRAY
    x"0010",  -- 16        
    x"000B",  -- 11
    x"0001",  -- 1
    x"0007",  -- 7
    x"0023",  -- 35
    x"0004",  -- 4
    x"0008",  -- 8
    x"FFFA",  -- -9
    x"FFF6",  -- -10
    others => x"0000"
    --others => x"FFFF"
);

begin
process(clk)
begin

MemData <= RAM(conv_integer(ALURes));
if(clk='1' and clk'event) then
     if(MemWrite = '1' and enable = '1') then
         RAM(conv_integer(ALURes)) <= RD2;
end if;   
end if;
end process;
end Behavioral;
