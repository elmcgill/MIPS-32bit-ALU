library IEEE;
use IEEE.std_logic_1164.all;

entity tb_ALU1Bit is
end tb_ALU1Bit;

architecture behavior of tb_ALU1Bit is

component ALUBit31
port(opCode : std_logic_vector(2 downto 0);
     i_A : std_logic;
     i_B : std_logic;
     i_Cin : std_logic;
     less : in std_logic;
     o_set : out std_logic;
     o_Cout : out std_logic;
     o_F : out std_logic);
end component;

signal s_A, s_B, s_Cin, s_less, s_set, s_Cout, s_F : std_logic;
signal s_op : std_logic_vector(2 downto 0);

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

ALU : ALUBit31
port map(opCode => s_op,
	 i_A => s_A,
	 i_B => s_B,
	 i_Cin => s_Cin,
	 less => s_less,
	 o_set => s_set,
	 o_Cout => s_Cout,
	 o_F => s_F);

process
begin
--Test all inputs of Op 000 (and)

info <= string_fill("AND OPERATION", info'length);
s_op <= "000";
s_A <= '0';
s_B <= '0';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "000";
s_A <= '0';
s_B <= '1';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "000";
s_A <= '1';
s_B <= '0';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "000";
s_A <= '1';
s_B <= '1';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

--Test all inputs for Op 001 (or)

info <= string_fill("OR OPERATION", info'length);
s_op <= "001";
s_A <= '0';
s_B <= '0';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "001";
s_A <= '0';
s_B <= '1';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "001";
s_A <= '1';
s_B <= '0';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "001";
s_A <= '1';
s_B <= '1';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

--Test all inputs for Op 010 (add)
info <= string_fill("ADD OPERATION", info'length);
s_op <= "010";
s_A <= '0';
s_B <= '0';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "010";
s_A <= '0';
s_B <= '1';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "010";
s_A <= '1';
s_B <= '0';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "010";
s_A <= '1';
s_B <= '1';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

--Test all inputs for Op 011 (sub)
info <= string_fill("SUB OPERATION", info'length);
s_op <= "011";
s_A <= '0';
s_B <= '0';
s_Cin <= '1';
s_less <= '0';
wait for 100 ns;

s_op <= "011";
s_A <= '0';
s_B <= '1';
s_Cin <= '1';
s_less <= '0';
wait for 100 ns;

s_op <= "011";
s_A <= '1';
s_B <= '0';
s_Cin <= '1';
s_less <= '0';
wait for 100 ns;

s_op <= "011";
s_A <= '1';
s_B <= '1';
s_Cin <= '1';
s_less <= '0';
wait for 100 ns;

--Test all inputs for Op 100 (xor)
info <= string_fill("XOR OPERATION", info'length);
s_op <= "100";
s_A <= '0';
s_B <= '0';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "100";
s_A <= '0';
s_B <= '1';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "100";
s_A <= '1';
s_B <= '0';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "100";
s_A <= '1';
s_B <= '1';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

--Test all inputs for Op 101 (nand)
info <= string_fill("NAND OPERATION", info'length);
s_op <= "101";
s_A <= '0';
s_B <= '0';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "101";
s_A <= '0';
s_B <= '1';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "101";
s_A <= '1';
s_B <= '0';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "101";
s_A <= '1';
s_B <= '1';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

--Test all inputs for Op 110 (nor)
info <= string_fill("NOR OPERATION", info'length);
s_op <= "110";
s_A <= '0';
s_B <= '0';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "110";
s_A <= '0';
s_B <= '1';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "110";
s_A <= '1';
s_B <= '0';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

s_op <= "110";
s_A <= '1';
s_B <= '1';
s_Cin <= '0';
s_less <= '0';
wait for 100 ns;

--Test all inputs for Op 111 (slt) s_F will be 0, but s_set should hold the value of less than
info <= string_fill("SLT OPERATION", info'length);
s_op <= "111";
s_A <= '0';
s_B <= '0';
s_Cin <= '1';
s_less <= '0';
wait for 100 ns;

s_op <= "111";
s_A <= '0';
s_B <= '1';
s_Cin <= '1';
s_less <= '0';
wait for 100 ns;

s_op <= "111";
s_A <= '1';
s_B <= '0';
s_Cin <= '1';
s_less <= '0';
wait for 100 ns;

s_op <= "111";
s_A <= '1';
s_B <= '1';
s_Cin <= '1';
s_less <= '0';
wait for 100 ns;

end process;
end behavior;