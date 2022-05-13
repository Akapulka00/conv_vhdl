library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;


entity addressblock is
    port(
        clk       : in    std_logic;
        comm_1 : in std_logic_vector(CODE_SIZE - 1 downto 0);
        adderss_11 : in  std_logic_vector(ADDR_SIZE - 1 downto 0);
        adderss_22 : in  std_logic_vector(ADDR_SIZE - 1 downto 0);
        valid    : in std_logic;
        data_perem: in  datarr(0 to 2**(ADDR_SIZE + 1) - 1);--память данных
        data_reg   : in STD_LOGIC_VECTOR(31 DOWNTO 0); --регистр
        redy: out std_logic;
        reg_post: out std_logic;
        result_in_reg : out  std_logic_vector(DATA_SIZE - 1 downto 0);--линия записи в память данных
        op_1 :out std_logic_vector(DATA_SIZE - 1 downto 0);
        op_2 :out std_logic_vector(DATA_SIZE - 1 downto 0);
        comm_1_out : out std_logic_vector(CODE_SIZE - 1 downto 0)
    );
    end addressblock;
    architecture a_addressblock of addressblock is
    begin
        main : process( clk, comm_1,adderss_11,adderss_22 )
        variable r_l : std_logic;
        begin
            if valid ='1'    then
                r_l:='0';
                redy<=r_l;
                -----------------------
                if comm_1 = LOAD_COM    then
                    reg_post<='1';
                    result_in_reg<=data_reg;
                    else
                    op_1 <= data_perem(to_integer(unsigned(adderss_11)));
                    op_2 <= data_perem(to_integer(unsigned(adderss_22)));
                    comm_1_out<=comm_1;
                    end if;
            end if;
            if r_l='0' then
            r_l:='1';
            redy<=r_l;
            end if;

        end process ; -- main
    end  a_addressblock ; -- a_addressblock