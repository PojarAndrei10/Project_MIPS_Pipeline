----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2023 11:34:01 AM
-- Design Name: 
-- Module Name: test_env2 - Behavioral
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

entity test_env2 is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env2;

architecture Behavioral of test_env2 is

component SSD is
    Port ( counter : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component MPG is
    Port ( clk : in STD_LOGIC;
           b : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component IF_FETCH is
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
end component;

component ID is
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
end component;

component UC is
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
end component;

component MEM is
    Port ( MemWrite : in STD_LOGIC;
           enable : in STD_LOGIC;
           clk : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component EX is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           AluSrc : in STD_LOGIC;
           Sa : in STD_LOGIC;
           AluControl : in STD_LOGIC_VECTOR (2 downto 0);
           Iesire_Zero : out STD_LOGIC;
           Rez : out STD_LOGIC_VECTOR (15 downto 0));
end component;


signal digits:std_logic_vector(15 downto 0);
signal jmp:std_logic;
signal pc:std_logic;
signal jr_add:std_logic;
signal bltzz:std_logic;
signal rst:std_logic;
signal enable:std_logic;
--signal ba:std_logic_vector(15 downto 0);
signal jr:std_logic_vector(15 downto 0);
signal jr_ad:std_logic_vector(15 downto 0);
signal instr:std_logic_vector(15 downto 0);
signal pcc:std_logic_vector(15 downto 0);
signal rgwr:std_logic;
signal rgdst:std_logic;
signal extop:std_logic;
--signal ins:std_logic_vector(15 downto 0);
signal write_data:std_logic_vector(15 downto 0);
signal num1,num2:std_logic_vector(15 downto 0);
signal extindere_zero:std_logic_vector(15 downto 0);
signal funcc:std_logic_vector(2 downto 0);
signal saa:std_logic;
signal AluControl2:std_logic_vector(2 downto 0);
signal AluSrcs:std_logic;
signal memwritee,memtoregg:std_logic;
signal branchh:std_logic;
signal jmpp:std_logic;
signal bltzz2:std_logic;
signal zeros:std_logic;
signal AluRes_rez:std_logic_vector(15 downto 0);
signal Mem_data:std_logic_vector(15 downto 0);


-- SEMNALELE PT REGISTRI INTERMEDIARI PT MIPS PIPELINE: IF/ID,ID/EX,EX/MEM,MEM/WB


signal instr_if_id,pc_if_id:std_logic_vector(15 downto 0);

signal wa_id_ex:std_logic_vector(2 downto 0);
signal pc_id_ex,rd1_id_ex,rd2_id_ex,extimm_id_ex:std_logic_vector(15 downto 0);
signal alucontrol_id_ex:std_logic_vector(2 downto 0);
signal memtoreg_id_ex,regwr_id_ex,memwr_id_ex,brch_id_ex,bltz_id_ex,alusrc_id_ex:std_logic;

signal branchaddress_ex_mem,alurez_ex_mem,rd1_ex_mem,rd2_ex_mem:std_logic_vector(15 downto 0);
signal zero_ex_mem,memtoreg_ex_mem,regwr_ex_mem,memwr_ex_mem,brch_ex_mem,bltz_ex_mem:std_logic;
signal wa_ex_mem:std_logic_vector(2 downto 0);

signal wa_mem_wb:std_logic_vector(2 downto 0);
signal alurez_mem_wb,read_data_mem_wb:std_logic_vector(15 downto 0);
signal memtoreg_mem_wb,regwr_mem_wb:std_logic;

--SEMNAL SUPLIMENTAR MIPS PIPELINE
signal wa_regFile:std_logic_vector(2 downto 0);

begin

 --PORT MAPURI PENTRU TOATE COMPONENTELE
 
display:SSD port map(counter=>digits,clk=>clk,an=>an,cat=>cat);

InstructionFetch:IF_FETCH port map(CLK=>clk,Jump=>jmp,PCsrc=>pc,mux3=>jr_add,mux4=>bltzz,reset=>rst,en=>enable,
Branch_Adress=>branchaddress_ex_mem,Jump_Adress=>jr,Jr_Adress=>jr_ad,Instruction=>instr,PC=>pcc);

InstructionDecode: ID port map (clk=>clk,RegWr=>regwr_mem_wb,RegDst=>rgdst,ExtOp=>extop,enable=>enable,Instr=>instr_if_id,
Wd=>write_data,RD1=>num1,RD2=>num2,Ext_Imm=>extindere_zero,WA=>wa_mem_wb,Func=>funcc,Sa=>saa);

Unitate_control: UC port map(opcode=>instr_if_id(15 downto 13),func=>funcc,AluControl=>AluControl2,RegDst=>rgdst,RegWrite=>
rgwr,AluSrc=>AluSrcs,ExtOp=>extop,MemWrite=>memwritee,MemToReg=>memtoregg,Branch=>branchh,Jump=>jmpp,Jr=>jr_add,Bltz
=>bltzz2);

ALU: EX port map(RD1=>rd1_id_ex,RD2=>rd2_id_ex,Ext_Imm=>extimm_id_ex,AluSrc=>alusrc_id_ex,Sa=>saa,AluControl=>alucontrol_id_ex,
Iesire_Zero=>zeros,Rez=>AluRes_rez);

Memorie_Ram: MEM port map(MemWrite=>memwr_ex_mem,enable=>enable,clk=>clk,ALURes=>alurez_ex_mem,RD2=>rd2_ex_mem,
MemData=>Mem_data);

Generator_Monoimpuls_Sincron1:MPG port map(clk=>clk,b=>btn(0),en=>enable);
Generator_Monoimpuls_Sincron2:MPG port map(clk=>clk,b=>btn(1),en=>rst);

pc<=brch_ex_mem and zero_ex_mem;
bltzz<=rd1_ex_mem(15) and bltz_ex_mem;
--ba<=pcc+extindere_zero;
jr<="000" & instr_if_id(12 downto 0);

process(memtoreg_mem_wb,alurez_mem_wb,read_data_mem_wb)
begin 
if(memtoreg_mem_wb = '0') then 
      write_data <= alurez_mem_wb;
            else write_data <= read_data_mem_wb;
end if; 
end process;

--IESIRILE CARE TREBUIE AFISATE PE SEVEN SEGMENT IN FUNCTIE DE CODUL DAT DE SWITCH-URI

process(sw,instr_if_id,pc_if_id,rd1_id_ex,rd2_id_ex,wa_ex_mem)
begin
case sw(7 downto 5) is
 when "000" => digits <= instr_if_id;
           when "001" => digits <= pc_if_id;
           when "010" => digits <= rd1_id_ex;
           when "011" => digits <= rd2_id_ex;
           when "100" => digits <= extimm_id_ex;
           when "101" => digits <= alurez_ex_mem;
           when "110" => digits <= read_data_mem_wb;
           when "111" => digits <= x"000" & '0' & wa_ex_mem;
end case;
end process;
   --led <= "001" & rgdst & rgwr & AluSrcs & 
   --extop & memwritee & memtoregg & branchh & jmpp & jr_add & bltzz & AluControl2;
   
   led <= "000" & rgdst & regwr_id_ex & alusrc_id_ex & 
   extop & memwritee & memtoregg & brch_ex_mem & jmpp & jr_add & bltz_ex_mem & AluControl2;
   
   
   
 --PROCESELE PENTRU REGISTRELE INTERMEDIARE DIN PIPELINE
 --REGISTRELE INTERMEDIARE SUNT: 
 --IF/ID,ID/EX,EX/MEM,MEM/WB
 
 process(clk)
 begin
 if (clk='1' and clk'event) then
    if (enable='1') then 
    instr_if_id<=instr;
    pc_if_id<=pcc;
    
    pc_id_ex<=pc_if_id;
    rd1_id_ex<=num1;
    rd2_id_ex<=num2;
    extimm_id_ex<=extindere_zero;
    alucontrol_id_ex<=AluControl2;
    wa_id_ex<=wa_regFile;
    memtoreg_id_ex<=memtoregg;
    regwr_id_ex<=rgwr;
    memwr_id_ex<=memwritee;
    brch_id_ex<=branchh;
    bltz_id_ex<=bltzz;
    alusrc_id_ex<=AluSrcs;
    
    alurez_ex_mem<=AluRes_rez;
    branchaddress_ex_mem<=extimm_id_ex+pc_id_ex;
    zero_ex_mem <=zeros;
    wa_ex_mem<=wa_id_ex;
    rd2_ex_mem<=rd2_id_ex;
    rd1_ex_mem<=rd1_id_ex;
    memtoreg_ex_mem<=memtoreg_id_ex;
    regwr_ex_mem<=regwr_id_ex;
    memwr_ex_mem<=memwr_id_ex;
    brch_ex_mem<=brch_id_ex;
    bltz_ex_mem<=bltz_id_ex;
    
    memtoreg_mem_wb<=memtoreg_ex_mem;
    regwr_mem_wb<=regwr_ex_mem;
    alurez_mem_wb<=alurez_ex_mem;
    wa_mem_wb<=wa_ex_mem;
    read_data_mem_wb<=Mem_data;
end if;
end if;
end process;

process(rgdst,wa_regFile,instr_if_id)
begin
if(rgdst='0') then
           wa_regFile<=instr_if_id(9 downto 7);
           else wa_regFile<=instr_if_id(6 downto 4);
end if;
end process;
end Behavioral;
