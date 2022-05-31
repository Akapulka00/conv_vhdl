library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;
ENTITY conv_bloc IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        --// input channel
        valid_rd : IN STD_LOGIC;
        ready_rd : OUT STD_LOGIC;
        --output channel
        valid_wr : OUT STD_LOGIC;
        ready_wr : IN STD_LOGIC;
        data_rd : IN STD_LOGIC_VECTOR(COMM_SIZE - 1 downto 0);--data in
        data_wr : out STD_LOGIC_VECTOR(COMM_SIZE - 1 downto 0) --data out
    );
END ENTITY conv_bloc;

ARCHITECTURE rtl OF conv_bloc IS

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
                    data_wr<=data_rd;
                else
                valid_wr_map :='0';
                ready_rd_map := '1';
            END IF;
        END IF;
        valid_wr <= valid_wr_map;--скорее всего должно лежать в процессе
        ready_rd <= ready_rd_map;
    END PROCESS main;
  

END ARCHITECTURE rtl;