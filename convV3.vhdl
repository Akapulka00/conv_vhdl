library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;

entity convV3 is
    port (
 res       : in    std_logic;
 clk       : in    std_logic;
 comm      : in std_logic_vector(COMM_SIZE - 1 downto 0);
 result      : out   datarr(5 - 1 downto 0);
 is_write    : out   std_logic;
 data : in datarr(0 to 2**(ADDR_SIZE + 1) - 1);
 next_comm   : out   std_logic
    );
end convV3;

architecture a_convV3 of convV3 is
    component codeblock is
        port(
          clk       : in    std_logic;
          commdat     : in  std_logic_vector(COMM_SIZE - 1 downto 0);
          comm_1 : out std_logic_vector(CODE_SIZE - 1 downto 0)
        );
        end component;
        component addressblock is
          port(
            clk       : in    std_logic;
            commdat     : in std_logic_vector(COMM_SIZE - 1 downto 0);
            comm_1 : in std_logic_vector(CODE_SIZE - 1 downto 0);
            adderss_11 : out  std_logic_vector(ADDR_SIZE - 1 downto 0);
            adderss_22 : out  std_logic_vector(ADDR_SIZE - 1 downto 0);
            comm_1_out : out std_logic_vector(CODE_SIZE - 1 downto 0)
          );
          end component;
          component alublock is
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
            end component;
  signal  comm_1 : std_logic_vector(CODE_SIZE - 1 downto 0);
  signal adderss_11 :  std_logic_vector(ADDR_SIZE - 1 downto 0);
  signal    adderss_22 :  std_logic_vector(ADDR_SIZE - 1 downto 0);
  signal    comm_1_out :  std_logic_vector(CODE_SIZE - 1 downto 0);
begin
    codeblock_1:codeblock 
    port map(
      clk => clk,
      commdat   => comm,
      comm_1  => comm_1 
    );
    adressblock_1:addressblock 
    port map(
      clk => clk,
      commdat   => comm,
      comm_1  => comm_1,
      adderss_11 => adderss_11,
      adderss_22 => adderss_22,
      comm_1_out => comm_1_out
    );
    alublock_1:alublock 
    port map(
      clk => clk,
      comm_1  => comm_1,
      data=>data,
      adderss_11 => adderss_11,
      adderss_22 => adderss_22
    );
end architecture a_convV3;