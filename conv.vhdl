library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;

entity conv is
    port (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      --// input channel
      valid_rd : IN STD_LOGIC;
      ready_rd : OUT STD_LOGIC;
      data_perem: in  datarr(0 to 2**(ADDR_SIZE + 1) - 1);--память данных
      commdat     : in std_logic_vector(COMM_SIZE - 1 downto 0)--data in data_rd
    );
end conv;

architecture a_conv of conv is
  component codeblock IS
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
  end component;
  component addressblock is
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
  end component;
  component register32 is
    port(
      data_in   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ld  : IN STD_LOGIC; -- load/enable.
      clr : IN STD_LOGIC; -- async. clear.
      clk : IN STD_LOGIC; -- clock.
      data_out : out regarr(0 to 31); -- data
      addr  : IN  std_logic_vector(DATA_SIZE - 1 downto 0) -- address
    );
  end component;
  component alublock is
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
      reg : in regarr(0 to 31); -- data
      op_1_addr_reg :out std_logic_vector(DATA_SIZE - 1 downto 0);
      op_2 :IN std_logic_vector(DATA_SIZE - 1 downto 0);
      comm_1 : in std_logic_vector(CODE_SIZE - 1 downto 0);
      result : out  std_logic_vector(DATA_SIZE - 1 downto 0);
      reg_post: out std_logic;
      result_in_reg : out  std_logic_vector(DATA_SIZE - 1 downto 0);--линия записи в память данных
      is_write : out  STD_LOGIC;
      next_comm :out  STD_LOGIC
    );
  end component;
  
  signal ready_wr : STD_LOGIC;
  signal valid_wr :  STD_LOGIC;
    signal comm_1 : std_logic_vector(CODE_SIZE - 1 downto 0);
    signal adderss_11 :  std_logic_vector(ADDR_SIZE - 1 downto 0);
    signal  adderss_22 :   std_logic_vector(ADDR_SIZE - 1 downto 0);
    signal comm_1_out :   std_logic_vector(CODE_SIZE - 1 downto 0);
    signal clr :  STD_LOGIC; -- async. clear.
    signal   reg_post: std_logic;
    signal result_in_reg :   std_logic_vector(DATA_SIZE - 1 downto 0);
    signal  data_reg   :  STD_LOGIC_VECTOR(31 DOWNTO 0); --регистр
    signal op_1 : std_logic_vector(DATA_SIZE - 1 downto 0);
    signal op_2 : std_logic_vector(DATA_SIZE - 1 downto 0);
  signal data_rd: std_logic_vector(COMM_SIZE - 1 downto 0);
  signal data_wr: std_logic_vector(COMM_SIZE - 1 downto 0);
  signal data_wr2: std_logic_vector(COMM_SIZE - 1 downto 0);
  signal data_wr3: std_logic_vector(COMM_SIZE - 1 downto 0);
  signal ready_wr1:STD_LOGIC;
  signal valid_wr1 :  STD_LOGIC;
  signal ready_wr2:STD_LOGIC;
  signal valid_wr2 :  STD_LOGIC;
  signal ready_wr3:STD_LOGIC;
  signal result :  std_logic_vector(DATA_SIZE - 1 downto 0);
  signal     is_write :  STD_LOGIC;
  signal     next_comm :  STD_LOGIC;
  signal data_out :  regarr(0 to 31); -- data
    signal op_1_addr_reg:std_logic_vector(DATA_SIZE - 1 downto 0);
    
begin
    codeblock_1:codeblock 
    port map(
      rst => rst,
  clk => clk,
  --// input channel
  valid_rd =>valid_rd,
  ready_rd =>ready_rd,
  --output channel
  ready_wr =>ready_wr,
  valid_wr =>valid_wr,
  commdat =>  commdat ,--data in data_rd
  comm_1 => comm_1 , --data out data_wr
  adderss_11 => adderss_11 ,
  adderss_22 => adderss_22
    );
    addressblock_1:addressblock
    port map(
      rst =>rst,
      clk =>clk,
      --// input channel
      valid_rd =>valid_wr,
      ready_rd =>ready_wr,
      --output channel
      valid_wr =>valid_wr1,
      ready_wr =>ready_wr1,
      ------------------------------------
      comm_1 =>comm_1,
      adderss_11 =>adderss_11,
      adderss_22 =>adderss_22,
      data_perem=>data_perem,
      op_1 =>op_1,
      op_2 =>op_2,
      comm_1_out => comm_1_out );

      register_1:register32
      port map(
        clr =>rst,
        clk =>clk,
        data_in=>result_in_reg,
        ld=>reg_post,
        data_out=>data_out,
        addr=>op_1
      );
      alublock_1:alublock
      port map(
        rst =>rst,
        clk =>clk,
         --// input channel
      valid_rd =>valid_wr1,
      ready_rd =>ready_wr1,
      --output channel
      valid_wr =>valid_wr2,
      ready_wr =>ready_wr2,
      op_1=>op_1,
      reg=>data_out,
      op_1_addr_reg=>op_1_addr_reg,
      op_2=>op_2,
      reg_post=>reg_post,
      result_in_reg=>result_in_reg,
      comm_1=>comm_1_out,
      result=>result,
      is_write=>is_write,
      next_comm=>next_comm
      );
end architecture a_conv;