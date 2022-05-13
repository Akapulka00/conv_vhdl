library IEEE;
use IEEE.std_logic_unsigned.all;
use IEEE.Numeric_std.all;
use IEEE.std_logic_1164.all; 


 
ENTITY TestBench  IS
END TestBench ;
 
ARCHITECTURE behavior OF TestBench  IS 
 

component alu is 
port(
-- inputs:
 OP_1, OP_2 : in unsigned(31 downto 0);
COMM: in std_logic_vector(5 downto 3);
cin, clk, ce : in std_logic;
-- outputs:
cout, sign, zero: out std_logic;-- carry, sign, zero flag
RESULT : out unsigned(31 downto 0)-- result
);
end component;

-- Входные сигналы
signal OP_1 : unsigned(31 downto 0) := "00000000000000000000000000000001";
signal OP_2 : unsigned(31 downto 0) := "00000000000000000000000000000101";
signal cin, clk : std_logic := '1';
signal ce : std_logic := '0';
signal COMM : std_logic_vector(5 downto 3) := "000";
signal eff : std_logic := '1';

-- Выходные сигналы
signal cout, sign, zero : std_logic;
signal RESULT : unsigned(31 downto 0);
begin

--параллельные операторы
clk <= not clk after  10 ns; 
-- Clс частота: 50 MHz

cin <= not cin after 240 ns; 

eff <= not eff after  40 ns; 
-- каждые 4 такта clk такт увеличения OP_1 OP_2


process(eff) is 
begin
if rising_edge(eff) then

OP_1 <= OP_1 + 1;
OP_2 <= OP_2 + 3;

CE <= '0', '1' after 40 ns, '0' after 60 ns; 


case COMM is 
when "000"  => COMM <= "001";
when "001"  => COMM <= "010";
when "010"  => COMM <= "011";
when "011"  => COMM <= "100";
when "100"  => COMM <= "101";
when others => COMM <= "000";
end case;
end if;
end process;

-- instances 

test_alu1 : alu
port map (
-- inputs:
OP_1   => OP_1, 
OP_2   => OP_2,
COMM   => COMM,
ce  => ce, 
cin => cin, 
clk => clk,

-- outputs:
cout => cout, 
sign => sign, 
zero => zero,
RESULT => RESULT
);
