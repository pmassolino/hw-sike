----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_compressor_4_3 is
    Generic(
        total_size : integer
    );
    Port (
        a1 : in std_logic_vector((total_size - 1) downto 0);
        a2 : in std_logic_vector((total_size - 1) downto 0);
        a3 : in std_logic_vector((total_size - 1) downto 0);
        a4 : in std_logic_vector((total_size - 1) downto 0);
        c1 : out std_logic_vector((total_size) downto 0);
        c2 : out std_logic_vector((total_size+1) downto 0);
        s : out std_logic_vector((total_size - 1) downto 0)
    );
end adder_compressor_4_3;

architecture behavioral of adder_compressor_4_3 is

type compressor_4_3_blocks is array ((total_size - 1) downto 0) of unsigned(2 downto 0);

signal a_sum_compressor_full_adder : compressor_4_3_blocks;

begin

c1(0) <= '0';
c2(0) <= '0';
c2(1) <= '0';

COMPRESSOR_4_3 : for I in compressor_4_3_blocks'range generate

a_sum_compressor_full_adder(I) <= resize(unsigned(a1(I downto I)), 3) + unsigned(a2(I downto I)) + unsigned(a3(I downto I)) + unsigned(a4(I downto I));
s(I) <= a_sum_compressor_full_adder(I)(0);
c1(I+1) <= a_sum_compressor_full_adder(I)(1);
c2(I+2) <= a_sum_compressor_full_adder(I)(2);

end generate COMPRESSOR_4_3;

end behavioral;