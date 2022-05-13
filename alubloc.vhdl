library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;


entity alublock is
    port(
        clk       : in    std_logic;
        adderss_11 : in  std_logic_vector(ADDR_SIZE - 1 downto 0);
        adderss_22 : in  std_logic_vector(ADDR_SIZE - 1 downto 0);
        comm_1 : in std_logic_vector(CODE_SIZE - 1 downto 0);
        data : in datarr(0 to 2**(ADDR_SIZE + 1) - 1);
        result : out  std_logic_vector(DATA_SIZE - 1 downto 0);
        is_write : out  STD_LOGIC;
        next_comm :out  STD_LOGIC
       
    );
    end alublock;
    architecture a_alublock of alublock is
        signal op_1 : std_logic_vector(DATA_SIZE - 1 downto 0);
        signal op_2 : std_logic_vector(DATA_SIZE - 1 downto 0);
        signal result_l :   std_logic_vector(DATA_SIZE - 1 downto 0);
        signal reg :   std_logic_vector(DATA_SIZE - 1 downto 0);
    begin
        main : process( clk, comm_1, adderss_11, adderss_22 )
        begin
            if(comm_1 = NOP_COM) then
                is_write <= '0';
                    elsif(comm_1 = SUM_COM) then
                        op_1 <= data(to_integer(unsigned(adderss_11)));
                    op_2 <= data(to_integer(unsigned(adderss_22)));
                    result_l <= std_logic_vector(signed(op_1) + signed(op_2));
                    result <=result_l;
                is_write <= '1';
                    elsif(comm_1 = SUB_COM) then
                        op_1 <= data(to_integer(unsigned(adderss_11)));
                        op_2 <= data(to_integer(unsigned(adderss_22)));
                        result_l <= std_logic_vector(signed(op_1) - signed(op_2));
                    result <=result_l;
                is_write <= '1';
                   elsif(comm_1 = LOAD_COM) then
                    reg <= result_l;
                is_write  <= '0';
                    elsif(comm_1 = STORE_COM) then
                 result <= reg;
                is_write <= '1';
                    else
                is_write<= '0';
                next_comm <= '1';
                    end if;
        end process ; -- main
    end  a_alublock ; -- a_alublock