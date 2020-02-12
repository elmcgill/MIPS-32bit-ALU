library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.mux32BitArray.all;

entity registerFile is
	port(clk              : in std_logic;
	     readOne, readTwo : in std_logic_vector(4 downto 0);
	     writeAddress     : in std_logic_vector(4 downto 0);
	     writeData        : in std_logic_vector(31 downto 0);
	     reset            : in std_logic;
	     we               : in std_logic;
	     readDataOne      : out std_logic_vector(31 downto 0);
	     readDataTwo      : out std_logic_vector(31 downto 0));
end registerFile;

architecture structural of registerFile is

component reg is

port(i_CLK        : in std_logic;     -- Clock input
     i_RST        : in std_logic;     -- Reset input
     i_WE         : in std_logic;     -- Write enable input
     i_D          : in std_logic_vector(31 downto 0);     -- Data value input
     o_Q          : out std_logic_vector(31 downto 0));   -- Data value output

end component;


component decoder32to5 is

port(input : in std_logic_vector(4 downto 0);
     we    : in std_logic;
     output : out std_logic_vector(31 downto 0));

end component;


component mux32to1 is

port(i_In     : in muxArray;
     i_Select : in std_logic_vector(4 downto 0);
     o_Out    : out std_logic_vector(31 downto 0));

end component;

signal s_enable : std_logic_vector(31 downto 0);
signal s_data   : muxArray;

begin

decoder : decoder32to5
port map(input  => writeAddress,
         we => we,
         output => s_enable);

s_data(0) <= x"00000000";

registers : for i in 1 to 31 generate
begin
register_i : reg
generic map (N => 32)
port map(i_CLK => clk,
	 i_RST => reset,
	 i_WE  => s_enable(i),
	 i_D   => writeData,
	 o_Q   => s_data(i));
end generate;

mux1 : mux32to1
generic map(N => 32)
port map(i_In => s_data,
	 i_Select => readOne,
	 o_Out => readDataOne);

mux2 : mux32to1
generic map(N => 32)
port map(i_In => s_data,
	 i_Select => readTwo,
	 o_Out => readDataTwo);

end structural;