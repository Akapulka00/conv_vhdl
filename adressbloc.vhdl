library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;


entity addressblock is
    port(
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        --// input channel
        valid_rd : IN STD_LOGIC;
        ready_rd : OUT STD_LOGIC;--
        --output channel
        valid_wr : OUT STD_LOGIC;
        ready_wr : IN STD_LOGIC;
        ------------------------------------
        comm_1 : in std_logic_vector(CODE_SIZE - 1 downto 0);
        adderss_11 : in  std_logic_vector(ADDR_SIZE - 1 downto 0);
        adderss_22 : in  std_logic_vector(ADDR_SIZE - 1 downto 0);
        data_perem: in  datarr(0 to 2**(ADDR_SIZE + 1) - 1);--память данных
        op_1 :out std_logic_vector(DATA_SIZE - 1 downto 0);
        op_2 :out std_logic_vector(DATA_SIZE - 1 downto 0);
        comm_1_out : out std_logic_vector(CODE_SIZE - 1 downto 0)
    );
    end addressblock;
    architecture a_addressblock of addressblock is
    begin
        main : process( clk, rst )
        VARIABLE ready_rd_map : STD_LOGIC;
        VARIABLE valid_wr_map : STD_LOGIC;
        VARIABLE data_map : STD_LOGIC_VECTOR(31 DOWNTO 0);
        begin
            IF rst = '1' THEN
            valid_wr <= '0';
            ready_rd <= '1';
            ready_rd_map := '1';
        ELSIF rising_edge(clk) THEN
                IF (valid_rd = '1' AND ready_rd_map = '1') THEN
                    ready_rd_map := '0';
                    valid_wr_map :='1';
                    -----------------------------
                    if comm_1 = LOAD_COM or comm_1 = STORE_COM then
                        op_1 <=std_logic_vector(resize(signed(adderss_11), 32)); 
                        op_2 <=std_logic_vector(resize(signed(adderss_22), 32));
                        comm_1_out<=comm_1; 
                        else

                        op_1 <= data_perem(to_integer(unsigned(adderss_11)));
                        op_2 <= data_perem(to_integer(unsigned(adderss_22)));
                        comm_1_out<=comm_1;
                      end if;
                    ------------------------------
                else
                valid_wr_map :='0';
                ready_rd_map := '1';
            END IF;
        END IF;
        valid_wr <= valid_wr_map;--скорее всего должно лежать в процессе
        ready_rd <= ready_rd_map;

        end process ; -- main
    end  a_addressblock ; -- a_addressblock