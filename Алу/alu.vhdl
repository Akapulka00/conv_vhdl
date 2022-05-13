library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED;


entity alu is 
port(
-- inputs:
 OP_1, OP_2 : in unsigned(31 downto 0);-- operands
COMM : in std_logic_vector(5 downto 3);-- operation
cin, clk, ce : in std_logic;-- carry in, clock, 

-- outputs:
cout, sign, zero: out std_logic;-- carry, sign, zero flag
RESULT : out unsigned(31 downto 0)-- result
);
end entity;


architecture calculation of alu is 

signal RESULT_l : unsigned(31 downto 0) := "00000000000000000000000000000000";

begin

sign <= RESULT_l(31); 
zero <= '1' when RESULT_l(31 downto 0) = "0000000000000000" else 
RESULT    <= RESULT_l(31 downto 0); 
cout <= RESULT_l(31); 


--processes

process(clk) is

Variable output_a, output_b : integer range 0 to 10000000;
Variable output_c : unsigned(31 downto 0);

begin
if rising_edge(clk) and ce = '1' then -- срабатывает при передний фронт и сe 1
-- clk - это ТГ, ce вход запуска ALU
case COMM is 
-- выбор операции

when "000" => -- SUBR+
RESULT_l <= NOT( OP_1)+(((NOT OP_2 )+1));


when "001" => -- SUBR+
if cin = '1' then
     RESULT_l <= ( OP_2) - ( OP_1);
end if;

when "010" => -- MUX+

output_a := to_integer(unsigned(OP_1));
output_b := to_integer(unsigned(OP_2));
output_c :=to_unsigned( output_a * output_b,  output_c 'length); 
RESULT_l <= output_c;


when "011" => RESULT_l <=  (NOT OP_1 );-- NOT+
when "100" => RESULT_l <=  (OP_1 XOR OP_2);--  XOR+
when "101" =>
output_b := to_integer(unsigned(OP_2))mod 10;
RESULT_l <=  rotate_right(unsigned(OP_1),output_b);-- Сдвиг+
when others =>
end case;
end if;
end process;
end architecture;
 
