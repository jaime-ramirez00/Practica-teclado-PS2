--Laboratorio de Sistemas Digitales
--Jaime Andres Ramirez Stanford
--A00825248
--Testbench de practica teclado PS2
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_textio.ALL;
library STD;
use std.textio.all;
entity teclado_tb is
constant temp : time := 50 ns;
constant temp_tec : time := 50 us ;
end entity;
architecture behavior of teclado_tb is
component teclado is 
port(
clk_t, clk, rst, en, data : in std_logic; s_cod : out std_logic_vector(7 downto 0); s_par, s_err, s_lis : out std_logic
);
end component;
signal clk,rst,en,s_lis,s_err, s_par: std_logic := '0';
signal clk_t : std_logic := '1';
signal data : std_logic := 'H';
signal s_cod : std_logic_vector(7 downto 0);
type data_rec is record
cod : std_logic_vector(7 downto 0);
par : std_logic;
end record;
type arr is array (natural range <>) of data_rec;
constant dat : arr := (
(cod => x"3B", par => '0'),
(cod => x"44", par => '1'),
(cod => x"21", par => '0'), 
(cod => x"24", par => '1')
);
begin 
uut : teclado port map (clk_t, data, clk, rst, en, s_cod, s_par, s_lis, s_err);
clk <= not clk after (temp / 2);
rst <= '1', '0' after temp;
process
procedure envia(sc : data_rec) is
begin
clk_t <= 'H';
data <= 'H';            
wait for (temp_tec/2);
data <= '0';        
wait for (temp_tec/2);
clk_t <= '0';
wait for (temp_tec/2);
clk_t <= '1';
for i in 0 to 7 loop
data <= sc.cod(i);               
wait for (temp_tec/2);
clk_t <= '0';
wait for (temp_tec/2);
clk_t <= '1';
end loop;
data <= sc.par;
wait for (temp_tec/2);
clk_t <= '0';
wait for (temp_tec/2);
clk_t <= '1';
data <= '1';
wait for (temp_tec/2);
clk_t <= '0';
wait for (temp_tec/2);
clk_t <= '1';
data <= 'H';
wait for (temp_tec * 3);
end procedure envia;    
begin
wait for temp_tec;
for i in dat'range loop
envia(dat(i));
end loop;
wait;
end process;
process
variable lin : line;
begin
wait until s_lis'event and s_lis = '1';
if s_err = '1' then write (lin, string'("Scan again: "));
else
write(lin, string'("Successful Scan:"));
end if;
write(lin, string'("Codigo->")); 
write(lin, s_cod);
write(lin, string'(", Par->"));
write(lin, s_par);
writeline(output, lin);
end process;
end behavior;