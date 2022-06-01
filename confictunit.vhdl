library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;
ENTITY conflict_bloc IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        --// input channel
        ready_rd : out STD_LOGIC:='1';
        valid_rd : IN STD_LOGIC;
        din : in  std_logic_vector(COMM_SIZE - 1 downto 0);
        dout : out  std_logic_vector(COMM_SIZE - 1 downto 0)
    );
END ENTITY conflict_bloc;

ARCHITECTURE rtl OF conflict_bloc IS
component shift_reg IS
  PORT (
    clk : in  STD_LOGIC;
    din : in  std_logic_vector(COMM_SIZE - 1 downto 0);
    ready : in  STD_LOGIC;
    sr :out commarr(7 downto 0);
    dout : out  std_logic_vector(COMM_SIZE - 1 downto 0)
    );
    end component;
    component conf_bloc IS
  PORT (
    rst : IN STD_LOGIC;
clk : IN STD_LOGIC;
comm: in std_logic_vector(COMM_SIZE - 1 downto 0);
reg_comm: in  commarr(7 downto 0);
ready : in  STD_LOGIC;
redy_wr:out STD_LOGIC;
comm_c : out  std_logic_vector(COMM_SIZE - 1 downto 0)
    );
    end component;
    signal sr : commarr(7 downto 0);
    signal  comm_c :  std_logic_vector(COMM_SIZE - 1 downto 0);
BEGIN
register_2:shift_reg
port map(
  din =>din,
  clk =>clk,
  ready=>valid_rd,
  sr=>sr
);
conf_bloc_1:conf_bloc
port map(
  rst =>rst,
  clk =>clk,
  ready=>valid_rd,
  comm=>din,
  comm_c=>dout,
  redy_wr=>ready_rd,
  reg_comm=>sr
);

END ARCHITECTURE rtl;