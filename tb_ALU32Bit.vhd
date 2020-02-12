library IEEE;
use IEEE.std_logic_1164.all;

entity tb_ALU32bit is
end tb_ALU32bit;

architecture behavior of tb_ALU32Bit is

component ALU32Bit
port(opCode : in std_logic_vector(2 downto 0);
     iA : in std_logic_vector(31 downto 0);
     iB : in std_logic_vector(31 downto 0);
     zero : out std_logic;
     overFlow : out std_logic;
     o_F : out std_logic_vector(31 downto 0));
end component;

signal s_A, s_B, s_F : std_logic_vector(31 downto 0);
signal s_op : std_logic_vector(2 downto 0);
signal s_zero, s_overflow : std_logic;

begin
ALU : ALU32Bit
port map(opCode => s_op,
	 iA => s_A,
	 iB => s_B,
	 zero => s_zero,
	 overFlow => s_overflow,
	 o_F => s_F);
process
begin

--Test the obvious edge cases of Op 000 (and) and then some random cases

s_op <= "000";
s_A <= x"00000000";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "000";
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "000";
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "000";
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "000";
s_A <= x"00F00F00";
s_B <= x"00000F00";
wait for 100 ns;

s_op <= "000";
s_A <= x"00F00F0F";
s_B <= x"F0000F00";
wait for 100 ns;

--Test the obvious test cases for op 001 (or) and then some extra

s_op <= "001";
s_A <= x"00000000";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "001";
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "001";
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "001";
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "001";
s_A <= x"00F00F00";
s_B <= x"00000F00";
wait for 100 ns;

s_op <= "001";
s_A <= x"00F00F0F";
s_B <= x"F0000F00";
wait for 100 ns;

--Test the obvious edges cases of op 010 (add) and some random ones

s_op <= "010";
s_A <= x"00000000";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "010";
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "010";
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "010";
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "010";
s_A <= x"12345678";
s_B <= x"68493710";
wait for 100 ns;

s_op <= "010";
s_A <= x"58493610";
s_B <= x"89430123";
wait for 100 ns;

--Test the obvious edges cases of op 011 (sub) and some random ones

s_op <= "011";
s_A <= x"00000000";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "011";
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "011";
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "011";
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "011";
s_A <= x"12345678";
s_B <= x"68493710";
wait for 100 ns;

s_op <= "011";
s_A <= x"58493610";
s_B <= x"89430123";
wait for 100 ns;

--Test obvious test cases for op 100 (xor) and random ones

s_op <= "100";
s_A <= x"00000000";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "100";
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "100";
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "100";
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "100";
s_A <= x"00F00F00";
s_B <= x"00000F00";
wait for 100 ns;

s_op <= "100";
s_A <= x"00F00F0F";
s_B <= x"F0000F00";
wait for 100 ns;

--Test obvious edge cases for op 101 (nand) and some random ones

s_op <= "101";
s_A <= x"00000000";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "101";
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "101";
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "101";
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "101";
s_A <= x"00F00F00";
s_B <= x"00000F00";
wait for 100 ns;

s_op <= "101";
s_A <= x"00F00F0F";
s_B <= x"F0000F00";
wait for 100 ns;

--Test obvious test cases for op 110 (nor) and some random ones

s_op <= "110";
s_A <= x"00000000";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "110";
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "110";
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "110";
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "110";
s_A <= x"00F00F00";
s_B <= x"00000F00";
wait for 100 ns;

s_op <= "110";
s_A <= x"00F00F0F";
s_B <= x"F0000F00";
wait for 100 ns;

--Test obvious edge cases and some random
s_op <= "111";
s_A <= x"00000000";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "111";
s_A <= x"FFFFFFFF";
s_B <= x"00000000";
wait for 100 ns;

s_op <= "111";
s_A <= x"00000000";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "111";
s_A <= x"FFFFFFFF";
s_B <= x"FFFFFFFF";
wait for 100 ns;

s_op <= "111";
s_A <= x"F0F00F00";
s_B <= x"00000F00";
wait for 100 ns;

s_op <= "111";
s_A <= x"00F00F0F";
s_B <= x"F0000F00";
wait for 100 ns;

end process;
end behavior;