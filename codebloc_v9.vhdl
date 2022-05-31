library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;
ENTITY codeblock IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        --// input channel
        valid_rd : IN STD_LOGIC;
        ready_rd : OUT STD_LOGIC;--
        --output channel
        valid_wr : OUT STD_LOGIC;
        ready_wr : IN STD_LOGIC;
        commdat     : in std_logic_vector(COMM_SIZE - 1 downto 0);--data in data_rd
        comm_1 : out std_logic_vector(CODE_SIZE - 1 downto 0); --data out data_wr
        adderss_11 : out  std_logic_vector(ADDR_SIZE - 1 downto 0);
        adderss_22 : out  std_logic_vector(ADDR_SIZE - 1 downto 0)
    );
END ENTITY codeblock;

ARCHITECTURE a_codeblock OF codeblock IS

BEGIN

    main : PROCESS (clk, rst)
        VARIABLE ready_rd_map : STD_LOGIC;
        VARIABLE valid_wr_map : STD_LOGIC;
        VARIABLE data_map : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        IF rst = '1' THEN
            valid_wr <= '0';
            ready_rd <= '1';
            ready_rd_map := '1';
        ELSIF rising_edge(clk) THEN
                IF (valid_rd = '1' AND ready_rd_map = '1') THEN
                    ready_rd_map := '0';
                    valid_wr_map :='1';
                    adderss_11 <= commdat(3 * ADDR_SIZE - 1 downto 2 * ADDR_SIZE);
                    adderss_22<=commdat(2 * ADDR_SIZE - 1 downto ADDR_SIZE);
                    comm_1 <= commdat(COMM_SIZE - 1 downto COMM_SIZE - CODE_SIZE);
                else
                valid_wr_map :='0';
                ready_rd_map := '1';
            END IF;
        END IF;
        valid_wr <= valid_wr_map;--скорее всего должно лежать в процессе
        ready_rd <= ready_rd_map;
    END PROCESS main;
  

END ARCHITECTURE a_codeblock;