library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;

entity shift_reg is
Port ( 
clk : in  STD_LOGIC;
din : in  std_logic_vector(COMM_SIZE - 1 downto 0);
ready : in  STD_LOGIC;
sr :out commarr(7 downto 0);
dout : out  std_logic_vector(COMM_SIZE - 1 downto 0)
);
end shift_reg;

 

architecture Behavioral of shift_reg is

signal sr_map : commarr(7 downto 0);
 
begin
process(clk)
begin
    if ready='1' then
        sr_map<= sr_map(6 downto 0) & din;
        sr<=sr_map;
    end if ;
end process;
end Behavioral;