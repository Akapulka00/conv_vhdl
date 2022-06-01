library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;

-------------------------------------------

entity TestBench  is
end TestBench ;
architecture BEHAVIOR  of TestBench is
component conv_bloc is
  port (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      --// input channel
      valid_rd : IN STD_LOGIC;
      ready_rd : OUT STD_LOGIC;
      --output channel
      valid_wr : OUT STD_LOGIC;
      ready_wr : IN STD_LOGIC;
      data_rd : IN STD_LOGIC_VECTOR(COMM_SIZE - 1 downto 0);--data in
      data_wr: out STD_LOGIC_VECTOR(COMM_SIZE - 1 downto 0) --data out
  );
  end component;
  component conv IS
  PORT (
    rst : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    --// input channel
    valid_rd : IN STD_LOGIC;
    ready_rd : OUT STD_LOGIC;--
    data_perem: in  datarr(0 to 2**(ADDR_SIZE + 1) - 1);--память данных
    commdat     : in std_logic_vector(COMM_SIZE - 1 downto 0)--data in data_rd
  );
  end component;
  component conflict_bloc IS
  PORT (
    rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        --// input channel
        ready_rd : out STD_LOGIC:='1';
        valid_rd : IN STD_LOGIC;
        din : in  std_logic_vector(COMM_SIZE - 1 downto 0);
        dout : out  std_logic_vector(COMM_SIZE - 1 downto 0)
  );
  end component;
  constant CONV_COUNT : natural := 5;
  signal clk_count: natural :=0;
  signal res : std_logic := '1';
  signal clk : std_logic := '0';
  signal comm   : commarr(4 downto 0);
  signal commdat   : std_logic_vector(COMM_SIZE - 1 downto 0);
  signal commdat_buff   : std_logic_vector(COMM_SIZE - 1 downto 0);
  signal commdat_1   : std_logic_vector(COMM_SIZE - 1 downto 0);
  signal commdat_2   : std_logic_vector(COMM_SIZE - 1 downto 0);
  signal commdat_3   : std_logic_vector(COMM_SIZE - 1 downto 0);
  signal commdat_4   : std_logic_vector(COMM_SIZE - 1 downto 0);
  signal op_1 : datarr(CONV_COUNT - 1 downto 0);
  signal op_2 : datarr(CONV_COUNT - 1 downto 0);
  signal adderss_1 : addrarr(CONV_COUNT-1 downto 0);
  signal adderss_2 : addrarr(CONV_COUNT-1 downto 0);
  signal result_adder : addrarr(CONV_COUNT-1 downto 0);
  signal result  : std_logic_vector(DATA_SIZE - 1 downto 0);
  signal result_1  : std_logic_vector(DATA_SIZE - 1 downto 0);
  signal result_2  : std_logic_vector(DATA_SIZE - 1 downto 0);
  signal result_3  : std_logic_vector(DATA_SIZE - 1 downto 0);
  signal result_4  : std_logic_vector(DATA_SIZE - 1 downto 0);
  signal is_write  :STD_LOGIC;
  signal is_write_1  :STD_LOGIC;
  signal is_write_2  :STD_LOGIC;
  signal is_write_3  :STD_LOGIC;
  signal is_write_4  :STD_LOGIC;
  signal next_comm  :STD_LOGIC;
  signal next_comm_1  :STD_LOGIC;
  signal next_comm_2  :STD_LOGIC;
  signal next_comm_3  :STD_LOGIC;
  signal next_comm_4  :STD_LOGIC;
  signal data : datarr(0 to 2**(ADDR_SIZE + 1) - 1);
  signal data_perem : datarr(0 to 2**(ADDR_SIZE + 1) - 1);
  signal  comm_1 : std_logic_vector(CODE_SIZE - 1 downto 0);
  signal adderss_11 :   std_logic_vector(ADDR_SIZE - 1 downto 0);
  signal adderss_22 :   std_logic_vector(ADDR_SIZE - 1 downto 0);
  signal    comm_1_out :  std_logic_vector(CODE_SIZE - 1 downto 0);
  type naturalarr is array (natural range <>) of natural;
  signal next_comm_num : naturalarr(0 to CONV_COUNT - 1) := (others => 0);
  -----------------------------------------
  signal valid_rd :STD_LOGIC;
  signal ready_wr:STD_LOGIC;
  signal ready_rd :STD_LOGIC;
  signal valid_wr :  STD_LOGIC;
-----------------------------------------------
signal valid_rd_1 :STD_LOGIC;
signal ready_wr_1 :STD_LOGIC;
signal ready_rd_1 :STD_LOGIC;
signal valid_wr_1 :  STD_LOGIC;
signal commdat_buff_1   : std_logic_vector(COMM_SIZE - 1 downto 0);

------------------------------------------------
signal valid_rd_2 :STD_LOGIC;
signal ready_wr_2 :STD_LOGIC;
signal ready_rd_2 :STD_LOGIC;
signal valid_wr_2 :  STD_LOGIC;
signal commdat_buff_2   : std_logic_vector(COMM_SIZE - 1 downto 0);

------------------------------------------------
signal valid_rd_3 :STD_LOGIC;
signal ready_wr_3 :STD_LOGIC;
signal ready_rd_3 :STD_LOGIC;
signal valid_wr_3 :  STD_LOGIC;
signal commdat_buff_3   : std_logic_vector(COMM_SIZE - 1 downto 0);

------------------------------------------------
signal valid_rd_4 :STD_LOGIC;
signal ready_wr_4 :STD_LOGIC;
signal ready_rd_4 :STD_LOGIC;
signal valid_wr_4 :  STD_LOGIC;
signal commdat_buff_4   : std_logic_vector(COMM_SIZE - 1 downto 0);

------------------------------------------------
  
  signal data_rd: std_logic_vector(COMM_SIZE - 1 downto 0);
  signal data_wr: std_logic_vector(COMM_SIZE - 1 downto 0);
  signal data_wr2: std_logic_vector(COMM_SIZE - 1 downto 0);
  signal data_wr3: std_logic_vector(COMM_SIZE - 1 downto 0);
  signal ready_wr2:STD_LOGIC;
  signal ready_wr3:STD_LOGIC;
  signal valid_wr2 :  STD_LOGIC;
begin
  res <= '0' after 1 fs;
  conf_1 :conflict_bloc
  port map (
    rst => res,
    clk => clk,
    ready_rd => valid_rd,
    --// input channel
    valid_rd => ready_rd,
    dout=>commdat_buff,
    --output channel
    din =>  commdat --data in data_rd
    );
  conv_1 : conv 
  port map (
  rst => res,
  clk => clk,
  --// input channel
  valid_rd =>valid_rd,
  ready_rd =>ready_rd,
  data_perem=>data_perem,
  --output channel
  commdat =>  commdat_buff --data in data_rd
  );
  conf_2 :conflict_bloc
  port map (
    rst => res,
    clk => clk,
    ready_rd=>valid_rd_1,
    --// input channel
    valid_rd =>ready_rd_1,
    dout=>commdat_buff_1,
    --output channel
    din =>  commdat_1 --data in data_rd
    );
    conv_2 : conv 
  port map (
  rst => res,
  clk => clk,
  --// input channel
  valid_rd =>valid_rd_1,
  ready_rd =>ready_rd_1,
  data_perem=>data_perem,
  --output channel
  commdat =>  commdat_buff_1 --data in data_rd
  );
  conf_3 :conflict_bloc
  port map (
    rst => res,
    clk => clk,
    ready_rd=>valid_rd_2,
    --// input channel
    valid_rd =>ready_rd_2,
    dout=>commdat_buff_2,
    --output channel
    din =>  commdat_2 --data in data_rd
    );
    conv_3 : conv 
  port map (
  rst => res,
  clk => clk,
  --// input channel
  valid_rd =>valid_rd_2,
  ready_rd =>ready_rd_2,
  data_perem=>data_perem,
  --output channel
  commdat =>  commdat_buff_2 --data in data_rd
  );
  conf_4 :conflict_bloc
  port map (
    rst => res,
    clk => clk,
    ready_rd=>valid_rd_3,
    --// input channel
    valid_rd =>ready_rd_3,
    dout=>commdat_buff_3,
    --output channel
    din =>  commdat_3 --data in data_rd
    );
    conv_4 : conv 
  port map (
  rst => res,
  clk => clk,
  --// input channel
  valid_rd =>valid_rd_3,
  ready_rd =>ready_rd_3,
  data_perem=>data_perem,
  --output channel
  commdat =>  commdat_buff_3 --data in data_rd
  );
  conf_5 :conflict_bloc
  port map (
    rst => res,
    clk => clk,
    ready_rd=>valid_rd_4,
    --// input channel
    valid_rd =>ready_rd_4,
    dout=>commdat_buff_4,
    --output channel
    din =>  commdat_4 --data in data_rd
    );
    conv_5 : conv 
  port map (
  rst => res,
  clk => clk,
  --// input channel
  valid_rd =>valid_rd_4,
  ready_rd =>ready_rd_4,
  data_perem=>data_perem,
  --output channel
  commdat =>  commdat_buff_4 --data in data_rd
  );
    
  ----------------
  
  p_clk : process begin
  loop
  wait for 20 fs;
   clk <= not clk;
  end loop;
  end process p_clk;

  main_tb : process(clk, res) begin
 --Настройка памяти
  if(res = '1') then
 --выставляем начпало куоманд
 next_comm_num(0) <= 5;
 next_comm_num(1) <= 15;
 next_comm_num(2) <= 60;
 next_comm_num(3) <= 70;
 next_comm_num(4) <= 110;
 --------------------------------------------------------------------------------------------------------------------------------
 data(05) <= (SUM_COM & std_logic_vector(to_signed(24, ADDR_SIZE)) & std_logic_vector(to_signed(25, ADDR_SIZE)) & std_logic_vector(to_signed(40, ADDR_SIZE)));
 data(06) <= (SUM_COM & std_logic_vector(to_signed(25, ADDR_SIZE)) & std_logic_vector(to_signed(26, ADDR_SIZE)) & std_logic_vector(to_signed(41, ADDR_SIZE)));
 data(07) <= (SUM_COM & std_logic_vector(to_signed(24, ADDR_SIZE)) & std_logic_vector(to_signed(41, ADDR_SIZE)) & std_logic_vector(to_signed(42, ADDR_SIZE)));
 data(08) <= (LOAD_COM & std_logic_vector(to_signed(8, ADDR_SIZE)) & std_logic_vector(to_signed(26, ADDR_SIZE)) & std_logic_vector(to_signed(1, ADDR_SIZE)));
 data(09) <= (STORE_COM & std_logic_vector(to_signed( 8, ADDR_SIZE)) & NULL_ADDR & std_logic_vector(to_signed(43, ADDR_SIZE)));
 data(10) <= (STOP_COM & NULL_ADDR & NULL_ADDR & NULL_ADDR);
 --Переменные первой программы
  data_perem(24) <= std_logic_vector(to_signed(7, DATA_SIZE));
  data_perem(25) <= std_logic_vector(to_signed(8, DATA_SIZE));
  data_perem(26) <= std_logic_vector(to_signed(9, DATA_SIZE));
  data_perem(40) <= std_logic_vector(to_signed(0, DATA_SIZE));
  data_perem(41) <= std_logic_vector(to_signed(0, DATA_SIZE));
  data_perem(42) <= std_logic_vector(to_signed(0, DATA_SIZE));
  --------------------------------------------------------------------------------------------------------------------------------
 --Вторая программа
 data(15) <= (SUM_COM & std_logic_vector(to_signed(28, ADDR_SIZE)) & std_logic_vector(to_signed(29, ADDR_SIZE)) & std_logic_vector(to_signed(50, ADDR_SIZE)));
 data(16) <= (SUM_COM & std_logic_vector(to_signed(29, ADDR_SIZE)) & std_logic_vector(to_signed(30, ADDR_SIZE)) & std_logic_vector(to_signed(51, ADDR_SIZE)));
 data(17) <= (NOP_COM & NULL_ADDR & NULL_ADDR & NULL_ADDR);
 data(18) <= (SUM_COM & std_logic_vector(to_signed(50, ADDR_SIZE)) & std_logic_vector(to_signed(51, ADDR_SIZE)) & std_logic_vector(to_signed(52, ADDR_SIZE)));
 data(19) <= (NOP_COM & NULL_ADDR & NULL_ADDR & NULL_ADDR);
 data(20) <= (LOAD_COM  & std_logic_vector(to_signed(5, ADDR_SIZE)) & NULL_ADDR & std_logic_vector(to_signed(2, ADDR_SIZE)));
 data(21) <= (STORE_COM & std_logic_vector(to_signed(5, ADDR_SIZE)) & NULL_ADDR & std_logic_vector(to_signed(53, ADDR_SIZE)));
 data(22) <= (STOP_COM  & NULL_ADDR & NULL_ADDR & NULL_ADDR);
 --Переменные второй программы
 data_perem(28) <= std_logic_vector(to_signed(7, DATA_SIZE));
 data_perem(29) <= std_logic_vector(to_signed(8, DATA_SIZE));
 data_perem(30) <= std_logic_vector(to_signed(9, DATA_SIZE));
 data_perem(50) <= std_logic_vector(to_signed(0, DATA_SIZE));
 data_perem(51) <= std_logic_vector(to_signed(0, DATA_SIZE));
 data_perem(52) <= std_logic_vector(to_signed(0, DATA_SIZE));
 --------------------------------------------------------------------------------------------------------------------------------
 --Третья программа
 data(60) <= (SUM_COM & std_logic_vector(to_signed(79, ADDR_SIZE)) & std_logic_vector(to_signed(80, ADDR_SIZE)) & std_logic_vector(to_signed(94, ADDR_SIZE)));
 data(61) <= (SUB_COM & std_logic_vector(to_signed(80, ADDR_SIZE)) & std_logic_vector(to_signed(81, ADDR_SIZE)) & std_logic_vector(to_signed(95, ADDR_SIZE)));
 data(62) <= (SUM_COM & std_logic_vector(to_signed(94, ADDR_SIZE)) & std_logic_vector(to_signed(95, ADDR_SIZE)) & std_logic_vector(to_signed(96, ADDR_SIZE)));
 data(63) <= (LOAD_COM  & std_logic_vector(to_signed( 3, ADDR_SIZE)) & NULL_ADDR & std_logic_vector(to_signed(3, ADDR_SIZE)));
 data(64) <= (STORE_COM & std_logic_vector(to_signed( 3, ADDR_SIZE)) & NULL_ADDR & std_logic_vector(to_signed(97, ADDR_SIZE)));
 data(65) <= (STOP_COM  & NULL_ADDR & NULL_ADDR & NULL_ADDR);
 --Переменные третьей программы
 data_perem(79) <= std_logic_vector(to_signed(7, DATA_SIZE));
 data_perem(80) <= std_logic_vector(to_signed(8, DATA_SIZE));
 data_perem(81) <= std_logic_vector(to_signed(9, DATA_SIZE));
 data_perem(94) <= std_logic_vector(to_signed(0, DATA_SIZE));
 data_perem(95) <= std_logic_vector(to_signed(0, DATA_SIZE));
 data_perem(96) <= std_logic_vector(to_signed(0, DATA_SIZE));
 --------------------------------------------------------------------------------------------------------------------------------
 --Четвертая программа
 data(70) <= (SUM_COM & std_logic_vector(to_signed( 82, ADDR_SIZE)) & std_logic_vector(to_signed( 83, ADDR_SIZE)) & std_logic_vector(to_signed(106, ADDR_SIZE)));
 data(71) <= (SUB_COM & std_logic_vector(to_signed( 83, ADDR_SIZE)) & std_logic_vector(to_signed( 84, ADDR_SIZE)) & std_logic_vector(to_signed(107, ADDR_SIZE)));
 data(72) <= (NOP_COM & NULL_ADDR  & NULL_ADDR  & NULL_ADDR);
 data(73) <= (SUM_COM & std_logic_vector(to_signed(106, ADDR_SIZE)) & std_logic_vector(to_signed(107, ADDR_SIZE)) & std_logic_vector(to_signed(108, ADDR_SIZE)));
 data(74) <= (NOP_COM & NULL_ADDR  & NULL_ADDR  & NULL_ADDR);
 data(75) <= (LOAD_COM  & std_logic_vector(to_signed( 4, ADDR_SIZE)) & NULL_ADDR  & std_logic_vector(to_signed(4, ADDR_SIZE)));
 data(76) <= (STORE_COM & std_logic_vector(to_signed(  4, ADDR_SIZE)) & NULL_ADDR  & std_logic_vector(to_signed(109, ADDR_SIZE)));
 data(77) <= (STOP_COM  & NULL_ADDR  & NULL_ADDR  & NULL_ADDR);
 --Переменные четвертой программы
 data_perem(82) <= std_logic_vector(to_signed(7, DATA_SIZE));
 data_perem(83) <= std_logic_vector(to_signed(8, DATA_SIZE));
 data_perem(84) <= std_logic_vector(to_signed(9, DATA_SIZE));
 data_perem(106) <= std_logic_vector(to_signed(0, DATA_SIZE));
 data_perem(107) <= std_logic_vector(to_signed(0, DATA_SIZE));
 data_perem(108) <= std_logic_vector(to_signed(0, DATA_SIZE));
 --------------------------------------------------------------------------------------------------------------------------------
 data(110) <= (SUM_COM & std_logic_vector(to_signed( 118, ADDR_SIZE)) & std_logic_vector(to_signed( 119, ADDR_SIZE)) & std_logic_vector(to_signed(121, ADDR_SIZE)));
 data(111) <= (SUB_COM & std_logic_vector(to_signed( 121, ADDR_SIZE)) & std_logic_vector(to_signed( 120, ADDR_SIZE)) & std_logic_vector(to_signed(122, ADDR_SIZE)));
 data(112) <= (SUB_COM & std_logic_vector(to_signed( 122, ADDR_SIZE)) & std_logic_vector(to_signed( 120, ADDR_SIZE)) & std_logic_vector(to_signed(123, ADDR_SIZE)));
 data(113) <= (SUB_COM & std_logic_vector(to_signed(122, ADDR_SIZE)) & std_logic_vector(to_signed(123, ADDR_SIZE)) & std_logic_vector(to_signed(118, ADDR_SIZE)));
 data(114) <= (NOP_COM & NULL_ADDR & NULL_ADDR & NULL_ADDR);
 data(115) <= (LOAD_COM  & std_logic_vector(to_signed( 5, ADDR_SIZE)) & NULL_ADDR  & std_logic_vector(to_signed(5, ADDR_SIZE)));
 data(116) <= (STORE_COM & std_logic_vector(to_signed(  5, ADDR_SIZE)) & NULL_ADDR  & std_logic_vector(to_signed(118, ADDR_SIZE)));
 data(117) <= (STOP_COM  & NULL_ADDR & NULL_ADDR & NULL_ADDR);
 --Переменные четвертой программы
 data_perem(118) <= std_logic_vector(to_signed(7, DATA_SIZE));
 data_perem(119) <= std_logic_vector(to_signed(8, DATA_SIZE));
 data_perem(120) <= std_logic_vector(to_signed(9, DATA_SIZE));
 data_perem(121) <= std_logic_vector(to_signed(0, DATA_SIZE));
 data_perem(122) <= std_logic_vector(to_signed(0, DATA_SIZE));
 data_perem(123) <= std_logic_vector(to_signed(0, DATA_SIZE));

 comm(0) <= NULL_COMM;
 comm(1) <= NULL_COMM;
 comm(2) <= NULL_COMM;
 comm(3) <= NULL_COMM;
 comm(4) <= NULL_COMM;

  elsif(rising_edge(clk)) then
    clk_count<=clk_count+1;
 for i in 0 to CONV_COUNT - 1 loop

   if(data(next_comm_num(i))(COMM_SIZE - 1 downto COMM_SIZE - CODE_SIZE) /= STOP_COM and ready_rd='1') then
   next_comm_num(i) <= next_comm_num(i) + 1;
 
 if (i=0) then
  commdat<= data(next_comm_num(i));
 end if ;
 if (i=1) then
  commdat_1<= data(next_comm_num(i));
 end if ;
 if (i=2) then
  commdat_2<= data(next_comm_num(i));
 end if ;
 if (i=3) then
  commdat_2<= data(next_comm_num(i));
 end if ;
 if (i=4) then
  commdat_3<= data(next_comm_num(i));
 end if ;

   end if;

 end loop;

  end if;

  end process main_tb;

end BEHAVIOR  ;