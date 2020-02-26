----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:36:07 11/07/2016 
-- Design Name: 
-- Module Name:    multiplier_nbits_schoolbook - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline_signed_base_multiplier_257 is
    port(
        a : in std_logic_vector(256 downto 0);
        b : in std_logic_vector(256 downto 0);
        clk : in std_logic;
        o : out std_logic_vector(513 downto 0)
    );
end pipeline_signed_base_multiplier_257;

architecture behavioral of pipeline_signed_base_multiplier_257 is

signal temp_o1 : signed(513 downto 0);
signal temp_o2 : signed(513 downto 0);
signal temp_o3 : signed(513 downto 0);
signal temp_o4 : signed(513 downto 0);
signal temp_o5 : signed(513 downto 0);

begin

process(clk)
begin
    if(rising_edge(clk)) then
        temp_o1 <= (signed(a)*signed(b));
        temp_o2 <= temp_o1;
        temp_o3 <= temp_o2;
        temp_o4 <= temp_o3;
        o <= std_logic_vector(temp_o4);
    end if;
end process;

end behavioral;