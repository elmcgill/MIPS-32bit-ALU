library IEEE;
use IEEE.std_logic_1164.all;

entity tb_cpuWithFullALU is
    generic(gCLK_HPER   : time := 50 ns);
end tb_cpuWithFullALU;

architecture behavior of tb_cpuWithFullALU is

--Calculate the clock period as twice the half-period
constant cCLK_PER  : time := gCLK_HPER * 2;

component cpuFullALU
    port(clk 				: in std_logic;						-- control for clock signal
     readAddr1 				: in std_logic_vector(4 downto 0);	-- First address read from register file
     readAddr2 				: in std_logic_vector(4 downto 0);	-- Second address read from register file
     writeAddr 				: in std_logic_vector(4 downto 0);	-- Address to be written to in register file
     ALUSrc 				: in std_logic;						-- control for ALU with immediate value
     opCode_ALU				: in std_logic_vector(5 downto 0);	-- control for full ALU functions
     i_shift				: in std_logic_vector(4 downto 0);	-- shift amount for full ALU barrel-shifter op
     sign 					: in std_logic;							-- control for sign extension component
     immediate				: in std_logic_vector(15 downto 0);	-- immediate value 
     memWE, memReadEnable 	: in std_logic);				-- control for memory component
end component;

    -- Signals to test the processor
    signal s_CLK  : std_logic;
    signal s_readAddr1 : std_logic_vector(4 downto 0) := "00000";
    signal s_readAddr2 : std_logic_vector(4 downto 0) := "00000";
    signal s_writeAddr : std_logic_vector(4 downto 0) := "00000";
    signal s_opCode : std_logic_vector(5 downto 0);
    signal s_aluInBSel : std_logic;
    signal s_immediate : std_logic_vector(15 downto 0) := x"0000";
    signal s_memWE : std_logic;
    signal s_memRE : std_logic;
    signal s_sign : std_logic;
    signal s_shift : std_logic_vector(4 downto 0);

begin

DUT: cpuFullALU
    port map(clk => s_CLK,
	     readAddr1 => s_readAddr1,
	     readAddr2 => s_readAddr2,
	     writeAddr => s_writeAddr,
	     ALUSrc => s_aluInBSel,
	     opCode_ALU => s_opCode,
	     i_shift => s_shift,
	     sign => s_sign,
	     immediate => s_immediate,
	     memWE => s_memWE,
	     memReadEnable => s_memRE);

-- This process sets the clock value (low for gCLK_HPER, then high
-- for gCLK_HPER). Absent a "wait" command, processes restart
-- at the beginning once they have reached the final statement.
P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
end process;

P_TB: process
begin

   --addi $25, $0, 0
   s_memWE <= '0';		--disable memory write
   s_memRE <= '0';		--disable memory read
   s_writeAddr <= "11001";	--write to register 25
   s_readAddr1 <= "00000";	--read from register 0
   s_readAddr2 <= "00000";	--read2 doesnt matter with addi immediate
   s_immediate <= x"0000";	--immediate equal to 0
   s_sign <= '1';		--addi is not unsigned
   s_aluInBSel <= '1';		--aluSrc is enabled to pass the immediate to the alu
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --addi $26, $0, 256
   s_memWE <= '0';		
   s_memRE <= '0';
   s_writeAddr <= "11010";
   s_readAddr1 <= "00000";
   s_readAddr2 <= "00000";
   s_immediate <= x"0100";
   s_sign <= '0';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;


   --lw $1, 0($25)
   s_memWE <= '0';
   s_memRE <= '1';
   s_writeAddr <= "00001";
   s_readAddr1 <= "11001";
   s_readAddr2 <= "00000";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --addi $25, $0, 1
   s_memWE <= '0';		--disable memory write
   s_memRE <= '0';		--disable memory read
   s_writeAddr <= "11001";	--write to register 25
   s_readAddr1 <= "11001";	--read from register 0
   s_readAddr2 <= "00000";	--read2 doesnt matter with addi immediate
   s_immediate <= x"0001";	--immediate equal to 0
   s_sign <= '1';		--addi is not unsigned
   s_aluInBSel <= '1';		--aluSrc is enabled to pass the immediate to the alu
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;


   --sll $27, $25, 2 => $27 =4 =A[1]
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "11011";
   s_readAddr1 <= "11001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '1';
   s_opCode <= "000000";	--alu set to sll
   s_shift <= "00010";
   wait for cCLK_PER;

   --lw $2, 0($27) == lw $2, 4($25)
   s_memWE <= '0';
   s_memRE <= '1';
   s_writeAddr <= "00010";
   s_readAddr1 <= "11011";
   s_readAddr2 <= "00000";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --and $1, $1, $2
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "00001";
   s_readAddr1 <= "00001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '0';
   s_opCode <= "000001";	--alu set to and
   s_shift <= "00000";
   wait for cCLK_PER;

   --sw $1, 0($26)
   s_memWE <= '1';
   s_memRE <= '0';
   s_writeAddr <= "00000";
   s_readAddr1 <= "11010";
   s_readAddr2 <= "00001";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --addi $25, $25, 1
   s_memWE <= '0';		--disable memory write
   s_memRE <= '0';		--disable memory read
   s_writeAddr <= "11001";	--write to register 25
   s_readAddr1 <= "11001";	--read from register 0
   s_readAddr2 <= "00000";	--read2 doesnt matter with addi immediate
   s_immediate <= x"0001";	--immediate equal to 0
   s_sign <= '1';		--addi is not unsigned
   s_aluInBSel <= '1';		--aluSrc is enabled to pass the immediate to the alu
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;


   --sll $27, $25, 2 => $27 =8 =A[2]
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "11011";
   s_readAddr1 <= "11001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '1';
   s_opCode <= "000000";	--alu set to sll
   s_shift <= "00010";
   wait for cCLK_PER;

   --lw $1, 0($27)
   s_memWE <= '0';
   s_memRE <= '1';
   s_writeAddr <= "00001";
   s_readAddr1 <= "11011";
   s_readAddr2 <= "00000";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --addi $25, $25, 1
   s_memWE <= '0';		--disable memory write
   s_memRE <= '0';		--disable memory read
   s_writeAddr <= "11001";	--write to register 25
   s_readAddr1 <= "11001";	--read from register 0
   s_readAddr2 <= "00000";	--read2 doesnt matter with addi immediate
   s_immediate <= x"0001";	--immediate equal to 0
   s_sign <= '1';		--addi is not unsigned
   s_aluInBSel <= '1';		--aluSrc is enabled to pass the immediate to the alu
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;


   --sll $27, $25, 2 => $27 =12 =A[3]
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "11011";
   s_readAddr1 <= "11001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '1';
   s_opCode <= "000000";	--alu set to sll
   s_shift <= "00010";
   wait for cCLK_PER;

   --lw $2, 0($27) == lw $2, 12($25)
   s_memWE <= '0';
   s_memRE <= '1';
   s_writeAddr <= "00010";
   s_readAddr1 <= "11011";
   s_readAddr2 <= "00000";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --or $1, $1, $2
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "00001";
   s_readAddr1 <= "00001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '0';
   s_opCode <= "001001";	--alu set to or
   s_shift <= "00000";
   wait for cCLK_PER;

   --sw $1, 4($26)
   s_memWE <= '1';
   s_memRE <= '0';
   s_writeAddr <= "00000";
   s_readAddr1 <= "11010";
   s_readAddr2 <= "00001";
   s_immediate <= x"0004";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --addi $25, $25, 1
   s_memWE <= '0';		--disable memory write
   s_memRE <= '0';		--disable memory read
   s_writeAddr <= "11001";	--write to register 25
   s_readAddr1 <= "11001";	--read from register 0
   s_readAddr2 <= "00000";	--read2 doesnt matter with addi immediate
   s_immediate <= x"0001";	--immediate equal to 0
   s_sign <= '1';		--addi is not unsigned
   s_aluInBSel <= '1';		--aluSrc is enabled to pass the immediate to the alu
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;


   --sll $27, $25, 2 => $27 =16 =A[4]
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "11011";
   s_readAddr1 <= "11001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '1';
   s_opCode <= "000000";	--alu set to sll
   s_shift <= "00010";
   wait for cCLK_PER;

   --lw $2, 0($27) == lw $2, 16($25)
   s_memWE <= '0';
   s_memRE <= '1';
   s_writeAddr <= "00010";
   s_readAddr1 <= "11011";
   s_readAddr2 <= "00000";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --add $1, $1, $2
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "00001";
   s_readAddr1 <= "00001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '0';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --sw $1, 8($26)
   s_memWE <= '1';
   s_memRE <= '0';
   s_writeAddr <= "00000";
   s_readAddr1 <= "11010";
   s_readAddr2 <= "00001";
   s_immediate <= x"0008";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --addi $25, $25, 1
   s_memWE <= '0';		--disable memory write
   s_memRE <= '0';		--disable memory read
   s_writeAddr <= "11001";	--write to register 25
   s_readAddr1 <= "11001";	--read from register 0
   s_readAddr2 <= "00000";	--read2 doesnt matter with addi immediate
   s_immediate <= x"0001";	--immediate equal to 0
   s_sign <= '1';		--addi is not unsigned
   s_aluInBSel <= '1';		--aluSrc is enabled to pass the immediate to the alu
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;


   --sll $27, $25, 2 => $27 =20 =A[5]
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "11011";
   s_readAddr1 <= "11001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '1';
   s_opCode <= "000000";	--alu set to sll
   s_shift <= "00010";
   wait for cCLK_PER;

   --lw $2, 0($27) == lw $2, 20($25)
   s_memWE <= '0';
   s_memRE <= '1';
   s_writeAddr <= "00010";
   s_readAddr1 <= "11011";
   s_readAddr2 <= "00000";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --sub $1, $1, $2
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "00001";
   s_readAddr1 <= "00001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '0';
   s_opCode <= "011001";	--alu set to sub
   s_shift <= "00000";
   wait for cCLK_PER;

   --sw $1, 12($26)
   s_memWE <= '1';
   s_memRE <= '0';
   s_writeAddr <= "00000";
   s_readAddr1 <= "11010";
   s_readAddr2 <= "00001";
   s_immediate <= x"000C";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --addi $25, $25, 1
   s_memWE <= '0';		--disable memory write
   s_memRE <= '0';		--disable memory read
   s_writeAddr <= "11001";	--write to register 25
   s_readAddr1 <= "11001";	--read from register 0
   s_readAddr2 <= "00000";	--read2 doesnt matter with addi immediate
   s_immediate <= x"0001";	--immediate equal to 0
   s_sign <= '1';		--addi is not unsigned
   s_aluInBSel <= '1';		--aluSrc is enabled to pass the immediate to the alu
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;


   --sll $27, $25, 2 => $27 =24 =A[6]
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "11011";
   s_readAddr1 <= "11001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '1';
   s_opCode <= "000000";	--alu set to sll
   s_shift <= "00010";
   wait for cCLK_PER;

   --lw $2, 0($27) == lw $2, 24($25)
   s_memWE <= '0';
   s_memRE <= '1';
   s_writeAddr <= "00010";
   s_readAddr1 <= "11011";
   s_readAddr2 <= "00000";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --xor $1, $1, $2
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "00001";
   s_readAddr1 <= "00001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '0';
   s_opCode <= "100001";	--alu set to xor
   s_shift <= "00000";
   wait for cCLK_PER;

   --sw $1, 16($26)
   s_memWE <= '1';
   s_memRE <= '0';
   s_writeAddr <= "00000";
   s_readAddr1 <= "11010";
   s_readAddr2 <= "00001";
   s_immediate <= x"0010";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --addi $25, $25, 1
   s_memWE <= '0';		--disable memory write
   s_memRE <= '0';		--disable memory read
   s_writeAddr <= "11001";	--write to register 25
   s_readAddr1 <= "11001";	--read from register 0
   s_readAddr2 <= "00000";	--read2 doesnt matter with addi immediate
   s_immediate <= x"0001";	--immediate equal to 0
   s_sign <= '1';		--addi is not unsigned
   s_aluInBSel <= '1';		--aluSrc is enabled to pass the immediate to the alu
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;


   --sll $27, $25, 2 => $27 =28 =A[7]
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "11011";
   s_readAddr1 <= "11001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '1';
   s_opCode <= "000000";	--alu set to sll
   s_shift <= "00010";
   wait for cCLK_PER;

   --lw $2, 0($27) == lw $2, 28($25)
   s_memWE <= '0';
   s_memRE <= '1';
   s_writeAddr <= "00010";
   s_readAddr1 <= "11011";
   s_readAddr2 <= "00000";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --nand $1, $1, $2
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "00001";
   s_readAddr1 <= "00001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '0';
   s_opCode <= "101001";	--alu set to nand
   s_shift <= "00000";
   wait for cCLK_PER;

   --sw $1, 20($26)
   s_memWE <= '1';
   s_memRE <= '0';
   s_writeAddr <= "00000";
   s_readAddr1 <= "11010";
   s_readAddr2 <= "00001";
   s_immediate <= x"0014";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --addi $25, $25, 1
   s_memWE <= '0';		--disable memory write
   s_memRE <= '0';		--disable memory read
   s_writeAddr <= "11001";	--write to register 25
   s_readAddr1 <= "11001";	--read from register 0
   s_readAddr2 <= "00000";	--read2 doesnt matter with addi immediate
   s_immediate <= x"0001";	--immediate equal to 0
   s_sign <= '1';		--addi is not unsigned
   s_aluInBSel <= '1';		--aluSrc is enabled to pass the immediate to the alu
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;


   --sll $27, $25, 2 => $27 =32 =A[8]
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "11011";
   s_readAddr1 <= "11001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '1';
   s_opCode <= "000000";	--alu set to sll
   s_shift <= "00010";
   wait for cCLK_PER;

   --lw $2, 0($27) == lw $2, 32($25)
   s_memWE <= '0';
   s_memRE <= '1';
   s_writeAddr <= "00010";
   s_readAddr1 <= "11011";
   s_readAddr2 <= "00000";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --nor $1, $1, $2
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "00001";
   s_readAddr1 <= "00001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '0';
   s_opCode <= "110001";	--alu set to nor
   s_shift <= "00000";
   wait for cCLK_PER;

   --sw $1, 24($26)
   s_memWE <= '1';
   s_memRE <= '0';
   s_writeAddr <= "00000";
   s_readAddr1 <= "11010";
   s_readAddr2 <= "00001";
   s_immediate <= x"0018";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --addi $25, $25, 1
   s_memWE <= '0';		--disable memory write
   s_memRE <= '0';		--disable memory read
   s_writeAddr <= "11001";	--write to register 25
   s_readAddr1 <= "11001";	--read from register 0
   s_readAddr2 <= "00000";	--read2 doesnt matter with addi immediate
   s_immediate <= x"0001";	--immediate equal to 0
   s_sign <= '1';		--addi is not unsigned
   s_aluInBSel <= '1';		--aluSrc is enabled to pass the immediate to the alu
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;


   --sll $27, $25, 2 => $27 =36 =A[9]
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "11011";
   s_readAddr1 <= "11001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '1';
   s_opCode <= "000000";	--alu set to sll
   s_shift <= "00010";
   wait for cCLK_PER;

   --lw $2, 0($27) == lw $2, 32($25)
   s_memWE <= '0';
   s_memRE <= '1';
   s_writeAddr <= "00010";
   s_readAddr1 <= "11011";
   s_readAddr2 <= "00000";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --slt $1, $1, $2
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "00001";
   s_readAddr1 <= "00001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '0';
   s_opCode <= "111001";	--alu set to slt
   s_shift <= "00000";
   wait for cCLK_PER;

   --sw $1, 28($26)
   s_memWE <= '1';
   s_memRE <= '0';
   s_writeAddr <= "00000";
   s_readAddr1 <= "11010";
   s_readAddr2 <= "00001";
   s_immediate <= x"001C";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --addi $25, $0, 64
   s_memWE <= '0';		--disable memory write
   s_memRE <= '0';		--disable memory read
   s_writeAddr <= "11001";	--write to register 25
   s_readAddr1 <= "00000";	--read from register 0
   s_readAddr2 <= "00000";	--read2 doesnt matter with addi immediate
   s_immediate <= x"0040";	--immediate equal to 0
   s_sign <= '1';		--addi is not unsigned
   s_aluInBSel <= '1';		--aluSrc is enabled to pass the immediate to the alu
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --srl $27, $25, 2 => $27 =16 =A[4]
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "11011";
   s_readAddr1 <= "11001";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '0';
   s_aluInBSel <= '1';
   s_opCode <= "000010";	--alu set to srl
   s_shift <= "00010";
   wait for cCLK_PER;

   --lw $2, 0($27) == lw $2, 16($25)
   s_memWE <= '0';
   s_memRE <= '1';
   s_writeAddr <= "00010";
   s_readAddr1 <= "11011";
   s_readAddr2 <= "00000";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   --sra $1, $2, 2
   s_memWE <= '0';
   s_memRE <= '0';
   s_writeAddr <= "00001";
   s_readAddr1 <= "00010";
   s_readAddr2 <= "00010";
   s_immediate <= x"0000";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "000100";	--alu set to srl
   s_shift <= "00010";
   wait for cCLK_PER;

   --sw $1, 28($26)
   s_memWE <= '1';
   s_memRE <= '0';
   s_writeAddr <= "00000";
   s_readAddr1 <= "11010";
   s_readAddr2 <= "00001";
   s_immediate <= x"001C";
   s_sign <= '1';
   s_aluInBSel <= '1';
   s_opCode <= "010001";	--alu set to add
   s_shift <= "00000";
   wait for cCLK_PER;

   wait;
  end process;
end behavior;
    