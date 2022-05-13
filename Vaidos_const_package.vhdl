library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package my_package is

    constant DATA_SIZE : integer := 32;
    constant ADDR_SIZE : integer := 8;
    constant CODE_SIZE : integer := 8;
    constant COMM_SIZE : integer := 32;
    -------------------------------------------------
    constant NOP_COM   : std_logic_vector(CODE_SIZE - 1 downto 0) := std_logic_vector(to_signed(0, CODE_SIZE));
    constant SUM_COM   : std_logic_vector(CODE_SIZE - 1 downto 0) := std_logic_vector(to_signed(1, CODE_SIZE));
    constant SUB_COM   : std_logic_vector(CODE_SIZE - 1 downto 0) := std_logic_vector(to_signed(2, CODE_SIZE));
    constant LOAD_COM  : std_logic_vector(CODE_SIZE - 1 downto 0) := std_logic_vector(to_signed(4, CODE_SIZE));
    constant STORE_COM : std_logic_vector(CODE_SIZE - 1 downto 0) := std_logic_vector(to_signed(5, CODE_SIZE));
    constant STOP_COM  : std_logic_vector(CODE_SIZE - 1 downto 0) := std_logic_vector(to_signed(-1, CODE_SIZE));
  -------------------------------------------------
    constant NULL_ADDR : std_logic_vector(ADDR_SIZE - 1 downto 0) := std_logic_vector(to_signed(0, ADDR_SIZE));
    constant NULL_DATA : std_logic_vector(DATA_SIZE - 1 downto 0) := std_logic_vector(to_signed(0, DATA_SIZE));
    constant NULL_COMM : std_logic_vector(COMM_SIZE - 1 downto 0) := std_logic_vector(to_signed(0, COMM_SIZE));
    type datarr is array (natural range <>) of std_logic_vector(DATA_SIZE - 1 downto 0);
    type addrarr is array (natural range <>) of std_logic_vector(ADDR_SIZE - 1 downto 0);
    type codearr is array (natural range <>) of std_logic_vector(CODE_SIZE - 1 downto 0);
    type commarr is array (natural range <>) of std_logic_vector(COMM_SIZE - 1 downto 0);
   
  --  type commarr  std_logic_vector(COMM_SIZE - 1 downto 0);
  --  type datarr  std_logic_vector(DATA_SIZE - 1 downto 0);
  --  type addrarr  std_logic_vector(ADDR_SIZE - 1 downto 0);
  --  type codearr  std_logic_vector(CODE_SIZE - 1 downto 0);
--type commarr  std_logic_vector(COMM_SIZE - 1 downto 0);
end my_package;