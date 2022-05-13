library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;


entity codeblock is
    port(
        clk       : in    std_logic;
        commdat     : in std_logic_vector(COMM_SIZE - 1 downto 0);
        valid    : in std_logic;
        comm_1 : out std_logic_vector(CODE_SIZE - 1 downto 0);
        adderss_11 : out  std_logic_vector(ADDR_SIZE - 1 downto 0);
        adderss_22 : out  std_logic_vector(ADDR_SIZE - 1 downto 0);
        redy: out std_logic
    );
    end codeblock;
    architecture a_codeblock of codeblock is
    begin
        main : process( clk, commdat )
        variable r_l : std_logic;
        begin
            if valid ='1'    then
                r_l:='0';
                redy<=r_l;
            adderss_11 <= commdat(3 * ADDR_SIZE - 1 downto 2 * ADDR_SIZE);
            adderss_22<=commdat(2 * ADDR_SIZE - 1 downto ADDR_SIZE);
            comm_1 <= commdat(COMM_SIZE - 1 downto COMM_SIZE - CODE_SIZE);
            end if;
            if r_l='0' then
            r_l:='1';
            redy<=r_l;
            end if;
        end process ; -- main
    end  a_codeblock ; -- a_codeblock