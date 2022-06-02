library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;


entity alublock is
    port(
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        --// input channel
        valid_rd : IN STD_LOGIC;
        ready_rd : OUT STD_LOGIC;
        --output channel
        valid_wr : OUT STD_LOGIC;
        ready_wr : IN STD_LOGIC;
        op_1 :IN std_logic_vector(DATA_SIZE - 1 downto 0);
        op_2 :IN std_logic_vector(DATA_SIZE - 1 downto 0);
        comm_1 : in std_logic_vector(CODE_SIZE - 1 downto 0);
      --  reg : in regarr(0 to 31); -- data
        op_1_addr_reg :out std_logic_vector(DATA_SIZE - 1 downto 0);
        op_2_data_reg :out std_logic_vector(DATA_SIZE - 1 downto 0);
        comm_1_to_reg : out std_logic_vector(CODE_SIZE - 1 downto 0);
        result : out  std_logic_vector(DATA_SIZE - 1 downto 0)
    );
    end alublock;
    architecture a_alublock of alublock is
        signal result_l :   std_logic_vector(DATA_SIZE - 1 downto 0);
        signal comm_1_to_reg_map:   std_logic_vector(CODE_SIZE - 1 downto 0);
        signal op_1_addr_reg_map: std_logic_vector(DATA_SIZE - 1 downto 0);
        signal op_2_data_reg_map: std_logic_vector(DATA_SIZE - 1 downto 0);
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
               result <=result_l;
               comm_1_to_reg<= comm_1_to_reg_map;
              op_2_data_reg<=op_2_data_reg_map;
              op_1_addr_reg<=op_1_addr_reg_map;
                IF (valid_rd = '1' AND ready_rd_map = '1') THEN
                    ready_rd_map := '0';
                    valid_wr_map :='1';
                    -------------------------------
                    if(comm_1 = NOP_COM) then
                        comm_1_to_reg_map<=comm_1;
                            elsif(comm_1 = SUM_COM) then
                            result_l <= std_logic_vector(signed(op_1) + signed(op_2));
                            result <=result_l;
                            comm_1_to_reg_map<=comm_1;
                            elsif(comm_1 = SUB_COM) then
                            result_l <= std_logic_vector(signed(op_1) - signed(op_2));
                            result <=result_l;
                            comm_1_to_reg_map<=comm_1;
                           elsif(comm_1 = LOAD_COM) then
                            result<=result_l;
                            op_1_addr_reg_map<=op_1;
                            comm_1_to_reg_map<=comm_1;
                            elsif(comm_1 = STORE_COM) then
                            --result <= reg((to_integer(unsigned(op_1))));
                            
                            op_1_addr_reg_map<=op_1;
                            op_2_data_reg_map<=op_2;
                            comm_1_to_reg_map<=comm_1;
                            end if;
                else
                valid_wr_map :='0';
                ready_rd_map := '1';
            END IF;
        END IF;
        valid_wr <= valid_wr_map;--скорее всего должно лежать в процессе
        ready_rd <= ready_rd_map;
        end process ; -- main
    end  a_alublock ; -- a_alublock