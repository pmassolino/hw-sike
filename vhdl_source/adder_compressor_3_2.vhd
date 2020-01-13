--
-- Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
--
-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_compressor_3_2 is
    Generic(
        total_size : integer
    );
    Port (
        a : in std_logic_vector((total_size - 1) downto 0);
        b : in std_logic_vector((total_size - 1) downto 0);
        p : in std_logic_vector((total_size - 1) downto 0);
        c : out std_logic_vector((total_size) downto 0);
        s : out std_logic_vector((total_size - 1) downto 0)
    );
end adder_compressor_3_2;

architecture behavioral of adder_compressor_3_2 is

type compressor_3_2_blocks is array ((total_size - 1) downto 0) of unsigned(1 downto 0);

signal a_sum_b_sum_p_compressor_full_adder : compressor_3_2_blocks;

begin

c(0) <= '0';
COMPRESSOR_3_2 : for I in compressor_3_2_blocks'range generate

a_sum_b_sum_p_compressor_full_adder(I) <= resize(unsigned(a(I downto I)), 2) + unsigned(b(I downto I)) + unsigned(p(I downto I));
s(I) <= a_sum_b_sum_p_compressor_full_adder(I)(0);
c(I+1) <= a_sum_b_sum_p_compressor_full_adder(I)(1);

end generate COMPRESSOR_3_2;

end behavioral;