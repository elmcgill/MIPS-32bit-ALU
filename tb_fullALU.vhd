--------------------------------------------------------------------------------
-- Ehren Fox & Ethan McGill 
-- Department of Electrical and Computer Engineering
-- Iowa State University
--
--------------------------------------------------------------------------------

-- Full ALU Testbench
--------------------------------------------------------------------------------
-- DESCRIPTION: This file contains a Test bench for a 32 bit ALU that can perform 
-- the following functions;   shift left or right (logical) and shift right (arithmetic) 
-- 				and, or, add, sub, xor, nand, nor, and set less than
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_FullALU is
end tb_FullALU;




architecture behavior of tb_FullALU is

	component fullALU
		port(op_ALU				:	in std_logic_vector(2 downto 0);
			 op_Shifter 		:	in std_logic_vector(1 downto 0);
			 op_Select			:	in std_logic;
			 i_A				: 	in std_logic_vector(31 downto 0);
			 i_B				:	in std_logic_vector(31 downto 0);
			 i_Shamt			:	in std_logic_vector(4 downto 0);
			 o_F				:	out std_logic_vector(31 downto 0);
			 o_Zero				:	out std_logic;
			 o_Overflow			:	out std_logic);
	end component;
		
	
	signal s_opCode				:	std_logic_vector(5 downto 0); -- 6 bit opcode, bits 5-3 for ALU. bits 2 and 1 for the shifter. bit 0 to select the output
	signal s_expectedOut		:	std_logic_vector(31 downto 0);	-- signal that will hold the "correct" value of test
	signal s_A, s_B, s_F		:	std_logic_vector(31 downto 0); 
	signal s_zero, s_overflow	:	std_logic;
	signal s_shift				: 	std_logic_vector(4 downto 0);
	
	
	-- Helper Function that will output strings on a modelSim waveform --
	-- Will be beneficial in displaying changes or functions in the wves   --
	signal info : string(1 to 20);

	  function string_fill(msg : string; len : natural) return string is
		variable res_v : string(1 to len);
	  begin
		res_v := (others => ' ');  -- Fill with spaces to blank all for a start
		res_v(1 to msg'length) := msg;
		return res_v;
	  end function;
  
  
begin
	
	ALU	:	fullALU
	port MAP(op_ALU				=> s_opCode(5 downto 3),
			 op_Shifter 		=> s_opCode(2 downto 1),
			 op_Select			=> s_opCode(0),
			 i_A				=> s_A,
			 i_B				=> s_B,
			 i_Shamt			=> s_shift,
			 o_Zero 			=> s_zero,
			 o_Overflow 		=> s_overflow,
			 o_F				=> s_F);
			 
process
begin

--Some test cases for the ALU, have already tested so this is just to ensure its still working


-- AND OPERATION
info <= string_fill("AND OPERATION", info'length);
s_opCode <= "000001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"00000000";

wait for 200 ns;

-- AND OPERATION
info <= string_fill("AND OPERATION", info'length);
s_opCode <= "000001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"00000000";

wait for 200 ns;

-- AND OPERATION
info <= string_fill("AND OPERATION", info'length);
s_opCode <= "000001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"00000000";

wait for 200 ns;

-- AND OPERATION
info <= string_fill("AND OPERATION", info'length);
s_opCode <= "000001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";

wait for 200 ns;


-- AND OPERATION
info <= string_fill("AND OPERATION", info'length);
s_opCode <= "000001";	-- LSB = '1' means select ALU output
s_A <= x"08006004";
s_B <= x"08004003";
s_shift <= "00000";
s_expectedOut <= x"08004000";

wait for 200 ns;

-- OR OPERATION
info <= string_fill("OR OPERATION", info'length);
s_opCode <= "001001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- OR OPERATION
info <= string_fill("OR OPERATION", info'length);
s_opCode <= "001001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;

-- OR OPERATION
info <= string_fill("OR OPERATION", info'length);
s_opCode <= "001001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;

-- OR OPERATION
info <= string_fill("OR OPERATION", info'length);
s_opCode <= "001001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;

-- OR OPERATION
info <= string_fill("OR OPERATION", info'length);
s_opCode <= "001001";	-- LSB = '1' means select ALU output
s_A <= x"08006004";
s_B <= x"08004003";
s_shift <= "00000";
s_expectedOut <= x"08006007";
wait for 200 ns;

-- ADD OPERATION
info <= string_fill("ADD OPERATION", info'length);
s_opCode <= "010001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- ADD OPERATION
info <= string_fill("ADD OPERATION", info'length);
s_opCode <= "010001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;

-- ADD OPERATION
info <= string_fill("ADD OPERATION", info'length);
s_opCode <= "010001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;

-- ADD OPERATION
info <= string_fill("ADD OPERATION", info'length);
s_opCode <= "010001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFE";
wait for 200 ns;

-- ADD OPERATION
info <= string_fill("ADD OPERATION", info'length);
s_opCode <= "010001";	-- LSB = '1' means select ALU output
s_A <= x"08006004";
s_B <= x"08004003";
s_shift <= "00000";
s_expectedOut <= x"1000A007";
wait for 200 ns;

--SUB OPERATION
info <= string_fill("SUB OPERATION", info'length);
s_opCode <= "011001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

--SUB OPERATION
info <= string_fill("SUB OPERATION", info'length);
s_opCode <= "011001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;

--SUB OPERATION
info <= string_fill("SUB OPERATION", info'length);
s_opCode <= "011001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"00000001";
wait for 200 ns;

--SUB OPERATION
info <= string_fill("SUB OPERATION", info'length);
s_opCode <= "011001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

--SUB OPERATION
info <= string_fill("SUB OPERATION", info'length);
s_opCode <= "011001";	-- LSB = '1' means select ALU output
s_A <= x"08006004";
s_B <= x"08004003";
s_shift <= "00000";
s_expectedOut <= x"00002001";
wait for 200 ns;

-- XOR OPERATION
info <= string_fill("XOR OPERATION", info'length);
s_opCode <= "100001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- XOR OPERATION
info <= string_fill("XOR OPERATION", info'length);
s_opCode <= "100001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;

-- XOR OPERATION
info <= string_fill("XOR OPERATION", info'length);
s_opCode <= "100001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;

-- XOR OPERATION
info <= string_fill("XOR OPERATION", info'length);
s_opCode <= "100001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- XOR OPERATION
info <= string_fill("XOR OPERATION", info'length);
s_opCode <= "100001";	-- LSB = '1' means select ALU output
s_A <= x"08006004";
s_B <= x"08004003";
s_shift <= "00000";
s_expectedOut <= x"00002007";
wait for 200 ns;

-- NAND OPERATION
info <= string_fill("NAND OPERATION", info'length);
s_opCode <= "101001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;

-- NAND OPERATION
info <= string_fill("NAND OPERATION", info'length);
s_opCode <= "101001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;

-- NAND OPERATION
info <= string_fill("NAND OPERATION", info'length);
s_opCode <= "101001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;

-- NAND OPERATION
info <= string_fill("NAND OPERATION", info'length);
s_opCode <= "101001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- NAND OPERATION
info <= string_fill("NAND OPERATION", info'length);
s_opCode <= "101001";	-- LSB = '1' means select ALU output
s_A <= x"08006004";
s_B <= x"08004003";
s_shift <= "00000";
s_expectedOut <= x"F7FFBFFF";
wait for 200 ns;

-- NOR OPERATION
info <= string_fill("NOR OPERATION", info'length);
s_opCode <= "110001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;

-- NOR OPERATION
info <= string_fill("NOR OPERATION", info'length);
s_opCode <= "110001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- NOR OPERATION
info <= string_fill("NOR OPERATION", info'length);
s_opCode <= "110001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- NOR OPERATION
info <= string_fill("NOR OPERATION", info'length);
s_opCode <= "110001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- NOR OPERATION
info <= string_fill("NOR OPERATION", info'length);
s_opCode <= "110001";	-- LSB = '1' means select ALU output
s_A <= x"08006004";
s_B <= x"08004003";
s_shift <= "00000";
s_expectedOut <= x"F7FF9FF8";
wait for 200 ns;

-- SLT OPERATION -- result not expected to  be less 
info <= string_fill("SLT OPERATION", info'length);
s_opCode <= "111001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- SLT OPERATION -- result not expected to  be less 
info <= string_fill("SLT OPERATION", info'length);
s_opCode <= "111001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
s_shift <= "00000";
s_expectedOut <= x"00000001";
wait for 200 ns;

-- SLT OPERATION -- result not expected to  be less 
info <= string_fill("SLT OPERATION", info'length);
s_opCode <= "111001";	-- LSB = '1' means select ALU output
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- SLT OPERATION -- result not expected to  be less 
info <= string_fill("SLT OPERATION", info'length);
s_opCode <= "111001";	-- LSB = '1' means select ALU output
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- SLT OPERATION -- result not expected to  be less 
info <= string_fill("SLT OPERATION", info'length);
s_opCode <= "111001";	-- LSB = '1' means select ALU output
s_A <= x"08006004";
s_B <= x"08004003";
s_shift <= "00000";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- SLT OPERATION -- result expected to be less
info <= string_fill("SLT OPERATION", info'length);
s_opCode <= "111001";	-- LSB = '1' means select ALU output
s_A <= x"08006002";
s_B <= x"08504003";
s_shift <= "00000";
s_expectedOut <= x"00000001";
wait for 200 ns;

-- SHIFT OPERATION -- left 1 bit
info <= string_fill("SHIFT LEFT 1 OP", info'length);
s_opCode <= "111000";	-- LSB = '0' means select SHIFTER output
s_A <= x"08006002";
s_shift <= "00001";
s_expectedOut <= x"1000C004";
wait for 200 ns;

-- SHIFT OPERATION -- left 2 bit
info <= string_fill("SHIFT LEFT 2 OP", info'length);
s_opCode <= "111000";	-- LSB = '0' means select SHIFTER output
s_A <= x"08006002";
s_shift <= "00010";
s_expectedOut <= x"20018008";
wait for 200 ns;

-- SHIFT OPERATION -- left 4 bit
info <= string_fill("SHIFT LEFT 4 OP", info'length);
s_opCode <= "111000";	-- LSB = '0' means select SHIFTER output
s_A <= x"08006002";
s_shift <= "00100";
s_expectedOut <= x"80060020";
wait for 200 ns;

-- SHIFT OPERATION -- left 8 bit
info <= string_fill("SHIFT LEFT 8 OP", info'length);
s_opCode <= "111000";	-- LSB = '0' means select SHIFTER output
s_A <= x"08006002";
s_shift <= "01000";
s_expectedOut <= x"00600200";
wait for 200 ns;

-- SHIFT OPERATION -- left 16 bit
info <= string_fill("SHIFT LEFT 16 OP", info'length);
s_opCode <= "111000";	-- LSB = '0' means select SHIFTER output
s_A <= x"08006002";
s_shift <= "10000";
s_expectedOut <= x"60020000";
wait for 200 ns;

-- SHIFT OPERATION -- left 31 bit
info <= string_fill("SHIFT LEFT 31 OP", info'length);
s_opCode <= "111000";	-- LSB = '0' means select SHIFTER output
s_A <= x"08006002";
s_shift <= "11111";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- SHIFT OPERATION -- right 1 bit
info <= string_fill("SHIFT RIGHT 1 OP", info'length);
s_opCode <= "111010";	-- LSB = '0' means select SHIFTER output
s_A <= x"08006002";
s_shift <= "00001";
s_expectedOut <= x"04003001";
wait for 200 ns;

-- SHIFT OPERATION -- right 2 bits
info <= string_fill("SHIFT RIGHT 2 OP", info'length);
s_opCode <= "111010";	-- LSB = '0' means select SHIFTER output
s_A <= x"08006002";
s_shift <= "00010";
s_expectedOut <= x"02001800";
wait for 200 ns;

-- SHIFT OPERATION -- right 2 bits
info <= string_fill("SHIFT RIGHT 4 OP", info'length);
s_opCode <= "111010";	-- LSB = '0' means select SHIFTER output
s_A <= x"08006002";
s_shift <= "00100";
s_expectedOut <= x"00800600";
wait for 200 ns;

-- SHIFT OPERATION -- right 2 bits
info <= string_fill("SHIFT RIGHT 8 OP", info'length);
s_opCode <= "111010";	-- LSB = '0' means select SHIFTER output
s_A <= x"08006002";
s_shift <= "01000";
s_expectedOut <= x"00080060";
wait for 200 ns;

-- SHIFT OPERATION -- right 2 bits
info <= string_fill("SHIFT RIGHT 16 OP", info'length);
s_opCode <= "111010";	-- LSB = '0' means select SHIFTER output
s_A <= x"08006002";
s_shift <= "10000";
s_expectedOut <= x"00000800";
wait for 200 ns;

-- SHIFT OPERATION -- right 2 bits
info <= string_fill("SHIFT RIGHT 31 OP", info'length);
s_opCode <= "111010";	-- LSB = '0' means select SHIFTER output
s_A <= x"08006002";
s_shift <= "11111";
s_expectedOut <= x"00000000";
wait for 200 ns;

-- SHIFT OPERATION -- right 1 bit
info <= string_fill("SHIFT RIGHT Ar 1 OP", info'length);
s_opCode <= "111100";	-- LSB = '0' means select SHIFTER output
s_A <= x"F0000000";
s_shift <= "00001";
s_expectedOut <= x"C0000000";
wait for 200 ns;

-- SHIFT OPERATION -- right 2 bits
info <= string_fill("SHIFT RIGHT Ar 2 OP", info'length);
s_opCode <= "111100";	-- LSB = '0' means select SHIFTER output
s_A <= x"F0000000";
s_shift <= "00010";
s_expectedOut <= x"E0000000";
wait for 200 ns;

-- SHIFT OPERATION -- right 2 bits
info <= string_fill("SHIFT RIGHT Ar 4 OP", info'length);
s_opCode <= "111100";	-- LSB = '0' means select SHIFTER output
s_A <= x"F0000000";
s_shift <= "00100";
s_expectedOut <= x"F8000000";
wait for 200 ns;

-- SHIFT OPERATION -- right 2 bits
info <= string_fill("SHIFT RIGHT Ar 8 OP", info'length);
s_opCode <= "111100";	-- LSB = '0' means select SHIFTER output
s_A <= x"F0000000";
s_shift <= "01000";
s_expectedOut <= x"FF800000";
wait for 200 ns;

-- SHIFT OPERATION -- right 2 bits
info <= string_fill("SHIFT RIGHT Ar 16 OP", info'length);
s_opCode <= "111100";	-- LSB = '0' means select SHIFTER output
s_A <= x"F0000000";
s_shift <= "10000";
s_expectedOut <= x"FFFF8000";
wait for 200 ns;

-- SHIFT OPERATION -- right 2 bits
info <= string_fill("SHIFT RIGHT Ar 31 OP", info'length);
s_opCode <= "111100";	-- LSB = '0' means select SHIFTER output
s_A <= x"F0000000";
s_shift <= "11111";
s_expectedOut <= x"FFFFFFFF";
wait for 200 ns;


wait;

end process;
end behavior;