--Laboratorio de sistemas digitales
--Jaime Andres Ramirez Stanford
--A00825248
--Teclado PS2
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
entity teclado is 
port(clk_t, clk, rst, en, data : in std_logic; s_cod : out std_logic_vector(7 downto 0); s_par, s_err, s_lis : out std_logic
);
end entity;
architecture behavior of teclado is
signal estado: integer range 0 to 11:=0;
signal par: std_logic:='1';
signal listo, fil_clk: std_logic;
signal shift: std_logic_vector(8 downto 0);
signal fil: std_logic_vector(7 downto 0);
signal cnt : unsigned(3 downto 0);
begin
clk_fil : process
begin
wait until clk'event and clk = '1';
fil(6 downto 0) <= fil(7 downto 1);
fil(7) <= clk_t;
if fil = x"FF" then 
fil_clk <= '1';
elsif fil = x"00" then
fil_clk <= '0';
end if;
end process;
process(estado)
begin
case estado is
when 0 =>
par <= '1';
when 1 =>
s_err <= '0';
listo <= '0';
when 10 =>
shift(7 downto 0) <= shift(8 downto 1);
shift(8) <= data;
when 11 =>
if shift(8) = par then
s_err <= '0';
else
s_err <= '1';
end if;                
s_par <= par;
s_cod <= shift(7 downto 0);
par <= '1';
listo <= '1';
when others =>
if data = '1' then
par <= (not par);
end if;
shift(7 downto 0) <= shift(8 downto 1);
shift(8) <= data;     
end case;
end process;
process(fil_clk)
begin
if fil_clk'event and fil_clk = '0' then
if rst = '1' then
estado <= 0;
else
if estado = 11 then
estado <= 1;
else 
estado <= estado + 1;
end if;
end if;
end if;
end process;
process (listo, en)
begin
if en = '1' then
s_lis <= '0';
elsif listo'event then
s_lis <= listo;
end if;
end process;
end behavior;