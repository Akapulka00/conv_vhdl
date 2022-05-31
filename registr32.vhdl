library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;

ENTITY register32 IS PORT(
    data_in   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ld  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    data_out : out regarr(0 to 31); -- data
    addr  : IN  std_logic_vector(DATA_SIZE - 1 downto 0) -- address
);
END register32;

ARCHITECTURE description OF register32 IS

BEGIN
    process(clk, clr)
    begin
        if clr = '1' then
            for i in 0 to 31 loop
                data_out(i) <= x"00000000";
                end loop ; 
        elsif rising_edge(clk) then
            if ld = '1' then
                data_out(to_integer(unsigned(addr))) <= data_in;
            end if;
        end if;
    end process;
END description;