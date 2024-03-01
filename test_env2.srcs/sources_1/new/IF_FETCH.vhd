----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2023 11:52:32 AM
-- Design Name: 
-- Module Name: IF_FETCH - Behavioral
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

entity IF_FETCH is
    Port ( CLK : in STD_LOGIC;
           Jump : in STD_LOGIC;
           PCsrc : in STD_LOGIC;
           mux3 : in STD_LOGIC;
           mux4 : in STD_LOGIC;
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
           Branch_Adress : in STD_LOGIC_VECTOR (15 downto 0);
           Jump_Adress : in STD_LOGIC_VECTOR (15 downto 0);
           Jr_Adress : in STD_LOGIC_VECTOR (15 downto 0); --este jr_adress 
           Instruction : out STD_LOGIC_VECTOR (15 downto 0);
           PC : out STD_LOGIC_VECTOR (15 downto 0));
end IF_FETCH;

architecture Behavioral of IF_FETCH is

signal Inn:std_logic_vector(15 downto 0); --in PC
signal Outt:std_logic_vector(15 downto 0);  --out PC
signal rez:std_logic_vector(15 downto 0);
signal outmux1:std_logic_vector(15 downto 0);
signal outmux2:std_logic_vector(15 downto 0);
signal outmux3:std_logic_vector(15 downto 0);


type memorie_rom is array(0 to 255) of std_logic_vector(15 downto 0);
signal myRom:memorie_rom:=(

    --INSTRUCTIUNILE IN ASAMBLARE
    
    -- ADD $1,$0,$0 
    
    B"000_000_000_001_0_000",    --hexa: 0010
    
    -- LW $2,$0,0
    B"010_000_010_0000000",      --hexa: 4100
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- BEQ $1,$2,42
    B"100_010_001_0101010",      --hexa: 88AA
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- LW $3,$1,4  
    B"010_001_011_0000100",      --hexa: 4584
    
    -- ADDI $5,$0,1 
    B"001_000_101_0000001",      --hexa: 2281
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- AND $4,$3,$5 
    B"000_011_101_100_0_100",    --hexa: 0EC4
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- BEQ $4,$5,28 
    B"100_101_100_0011100",      --hexa: 961C
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- LW $4,$0,1
    B"010_000_100_0000001",      --hexa: 4201
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- SUB $5,$3,$4
    B"000_011_100_101_0_001",    --hexa: 0E51
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- BLTZ $5,7
    B"101_101_000_0000111",      --hexa: B407
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- SW $4,$0,2
    B"011_000_100_0000010",      --hexa: 6202
    
    -- SW $3,$0,1
    B"011_000_011_0000001",      --hexa: 6181
    
    -- JUMP 44
    B"111_0000000101100",        --hexa: E02C
    B"000_000_000_000_0_000",    --NoOp
    
    -- LW $4,$0,2
    B"010_000_100_0000010",      --hexa: 4202
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- SUB $5,$3,$4
    B"000_011_100_101_0_001",    --hexa: 0E51
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- BLTZ $5,4
    B"101_101_000_0000100",      --hexa: B404
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- SW $3,$0,2
    B"011_000_011_0000010",      --hexa: 6182
    
    -- ADDI $1,$1,1
    B"001_001_001_0000001",      --hexa: 2481
    
    -- JUMP 4
    B"111_0000000000100",        --hexa: E004
    B"000_000_000_000_0_000",    --NoOp
    
    -- LW $1,$0,1
    B"010_000_001_0000001",      --hexa: 4081
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- LW $2,$0,2
    B"010_000_010_0000010",      --hexa: 4102
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- BEQ $1,$2,19
    B"100_010_001_0010011",      --hexa: 8893
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- SUB $3,$1,$2
    B"000_001_010_011_0_001",    --hexa: 0531
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- BLTZ $3,6
    B"101_011_000_0000110",      --hexa: AC06
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- SW $3,$0,1
    B"011_000_011_0000001",      --hexa: 6181
    
    -- JUMP 47
    B"111_0000000101111",        --hexa: E02F
    B"000_000_000_000_0_000",    --NoOp
    
    -- SUB $2,$2,$1
    B"000_010_001_010_0_001",    --hexa: 08A1
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    -- SW $2,$0,2
    B"011_000_010_0000010",      --hexa: 6102
    
    -- JUMP 47
    B"111_0000000101111",        --hexa: E02F
    B"000_000_000_000_0_000",    --NoOp
    
    -- SW $1,$0,3
    B"011_000_001_0000011",      --hexa: 6083
    B"000_000_000_000_0_000",    --NoOp
    B"000_000_000_000_0_000",    --NoOp
    
    
    others => x"EEEE"          --OTHERS
    --others => x"0000"
    
    --Am calculat ulterior dupa eliminarea hazardurilor offsetul respectiv 
    --targetul la fiecare instructiune de branch si jump
);

begin
process(clk)
begin
     if(reset='1') then 
       Outt<=x"0000";
end if;
     if(clk='1' and clk'event ) then 
        if(en='1') then 
           Outt<=Inn;
end if;
end if;
end process;

Instruction<=myRom(conv_integer(Outt));
PC<=rez;
rez<=Outt+1;

process(PCsrc,Branch_Adress,rez)  --muxul 1 
begin
    if(Pcsrc='0') then
      outmux1<=rez;
else outmux1<=Branch_Adress;
end if;
end process;

process(Jump,Jump_Adress,outmux1,outmux2) --muxul 2
begin
   if(Jump='0') then 
     outmux2<=outmux1;
else outmux2<=Jump_Adress;
end if;
end process;

process(Jr_Adress,mux3,outmux2)  --muxul 3
begin
   if(mux3='0') then
    outmux3<=outmux2;
else outmux3<=Jr_Adress;
end if;
end process;

process(Branch_Adress,mux4,outmux3) --muxul 4 
begin
    if(mux4='0') then 
      Inn<=outmux3;
else Inn<=Branch_Adress;
end if;
end process;
end Behavioral;
