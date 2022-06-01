library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;

entity conf_bloc is
Port ( 
rst : IN STD_LOGIC;
clk : IN STD_LOGIC;
comm: in std_logic_vector(COMM_SIZE - 1 downto 0);
reg_comm: in  commarr(7 downto 0);
ready : in  STD_LOGIC;
redy_wr:out STD_LOGIC;
comm_c : out  std_logic_vector(COMM_SIZE - 1 downto 0)
);
end conf_bloc;

 

architecture Behavioral of conf_bloc is

signal reg_comm_map : commarr(7 downto 0);
signal ii : integer:=0;
signal ii_map : integer:=0;
signal comm_1 : std_logic_vector(CODE_SIZE - 1 downto 0);
signal comm_2 : std_logic_vector(CODE_SIZE - 1 downto 0);
signal comm_3 : std_logic_vector(CODE_SIZE - 1 downto 0);
signal redy_wr_map : STD_LOGIC;

begin
process(clk)
begin
if rising_edge(clk) then
    comm_1<=comm(COMM_SIZE - 1 downto COMM_SIZE - CODE_SIZE);
    comm_2<=reg_comm(0)(COMM_SIZE - 1 downto COMM_SIZE - CODE_SIZE);
    comm_3<=reg_comm(1)(COMM_SIZE - 1 downto COMM_SIZE - CODE_SIZE);
    if ready='1' then
        if ii=1 then
            ii_map<=0;
            comm_c<=(NOP_COM & NULL_ADDR & NULL_ADDR & NULL_ADDR);
            else
            redy_wr<='1';
            if(comm(COMM_SIZE - 1 downto COMM_SIZE - CODE_SIZE)=STORE_COM and (reg_comm(0)(COMM_SIZE - 1 downto COMM_SIZE - CODE_SIZE)=LOAD_COM or reg_comm(1)(COMM_SIZE - 1 downto COMM_SIZE - CODE_SIZE)=LOAD_COM) )then
                if comm(3 * ADDR_SIZE - 1 downto 2 * ADDR_SIZE)=reg_comm(0)(3 * ADDR_SIZE - 1 downto 2 * ADDR_SIZE) or comm(3 * ADDR_SIZE - 1 downto 2 * ADDR_SIZE)=reg_comm(1)(3 * ADDR_SIZE - 1 downto 2 * ADDR_SIZE) then
                   ii<=0;
                    redy_wr<='0';
                        if(ready='1') then
                            ii_map<=1;
                            comm_c<=(NOP_COM & NULL_ADDR & NULL_ADDR & NULL_ADDR);
                        end if ;
                    ----------------------
                    else 
                    comm_c<=comm;
                    end if ;
                    else 
                    comm_c<=comm;
                end if ;
                end if ;
        end if;  
        ii<=ii_map;
end if;
end process;
end Behavioral;