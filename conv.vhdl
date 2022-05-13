library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;

entity conv is
    generic(
 CONV_COUNT :  natural
    );
    port (
 res       : in    std_logic;
 clk       : in    std_logic;
 comm     : in    std_logic_vector(COMM_SIZE - 1 downto 0);
 --result : out  std_logic_vector(DATA_SIZE - 1 downto 0);
 --is_write    : out   STD_LOGIC;
 data_perem: in datarr(0 to 2**(ADDR_SIZE + 1) - 1);
 data : in datarr(0 to 2**(ADDR_SIZE + 1) - 1)
 --next_comm   : out   STD_LOGIC
    );
end conv;

architecture a_conv of conv is
    component codeblock is
        port(
          clk       : in    std_logic;
        commdat     : in std_logic_vector(COMM_SIZE - 1 downto 0);
        valid    : in std_logic;
        comm_1 : out std_logic_vector(CODE_SIZE - 1 downto 0);
        adderss_11 : out  std_logic_vector(ADDR_SIZE - 1 downto 0);
        adderss_22 : out  std_logic_vector(ADDR_SIZE - 1 downto 0);
        redy: out std_logic
        );
        end component;
        component register32 is
          port(
            data_in   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ld  : IN STD_LOGIC; -- load/enable.
            clr : IN STD_LOGIC; -- async. clear.
            clk : IN STD_LOGIC; -- clock.
            data_out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- output
          );
          end component;
          component addressblock is
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
            end component;
    signal comm_1 : std_logic_vector(CODE_SIZE - 1 downto 0);
    signal valid    :  std_logic;
    signal redy_1    :  std_logic;
    signal adderss_11 :  std_logic_vector(ADDR_SIZE - 1 downto 0);
    signal  adderss_22 :   std_logic_vector(ADDR_SIZE - 1 downto 0);
    signal comm_1_out :   std_logic_vector(CODE_SIZE - 1 downto 0);
    signal clr :  STD_LOGIC; -- async. clear.
    signal   reg_post: std_logic;
    signal result_in_reg :   std_logic_vector(DATA_SIZE - 1 downto 0);
    signal data_out   :  STD_LOGIC_VECTOR(31 DOWNTO 0); -- output
    signal  data_reg   :  STD_LOGIC_VECTOR(31 DOWNTO 0); --регистр
    signal op_1 : std_logic_vector(DATA_SIZE - 1 downto 0);
    signal op_2 : std_logic_vector(DATA_SIZE - 1 downto 0);
    
begin
  valid<='1';
    codeblock_1:codeblock 
    port map(
      clk => clk,
      valid => valid,
      redy=>redy_1,
      commdat   => comm,
      adderss_11=>adderss_11,
      adderss_22=>adderss_22,
      comm_1  => comm_1 
    );
    addressblock_1:addressblock
    port map(
      clk => clk,
      valid => redy_1,
      adderss_11=>adderss_11,
      adderss_22=>adderss_22,
      data_perem=>data_perem,
      reg_post=>reg_post,
      data_reg=>data_reg,
      op_1=>op_1,
      op_2=>op_2,
      result_in_reg=>result_in_reg,
      comm_1  => comm_1 
    );
    register_1:register32
    port map(
      data_in=>result_in_reg,
      ld=>reg_post,
      clr=>clr,
      clk=>clk
    );
   
end architecture a_conv;