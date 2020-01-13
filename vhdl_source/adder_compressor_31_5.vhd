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

entity adder_compressor_31_5 is
    Generic(
        total_size : integer
    );
    Port (
        a1 : in std_logic_vector((total_size - 1) downto 0);
        a2 : in std_logic_vector((total_size - 1) downto 0);
        a3 : in std_logic_vector((total_size - 1) downto 0);
        a4 : in std_logic_vector((total_size - 1) downto 0);
        a5 : in std_logic_vector((total_size - 1) downto 0);
        a6 : in std_logic_vector((total_size - 1) downto 0);
        a7 : in std_logic_vector((total_size - 1) downto 0);
        a8 : in std_logic_vector((total_size - 1) downto 0);
        a9 : in std_logic_vector((total_size - 1) downto 0);
        a10 : in std_logic_vector((total_size - 1) downto 0);
        a11 : in std_logic_vector((total_size - 1) downto 0);
        a12 : in std_logic_vector((total_size - 1) downto 0);
        a13 : in std_logic_vector((total_size - 1) downto 0);
        a14 : in std_logic_vector((total_size - 1) downto 0);
        a15 : in std_logic_vector((total_size - 1) downto 0);
        a16 : in std_logic_vector((total_size - 1) downto 0);
        a17 : in std_logic_vector((total_size - 1) downto 0);
        a18 : in std_logic_vector((total_size - 1) downto 0);
        a19 : in std_logic_vector((total_size - 1) downto 0);
        a20 : in std_logic_vector((total_size - 1) downto 0);
        a21 : in std_logic_vector((total_size - 1) downto 0);
        a22 : in std_logic_vector((total_size - 1) downto 0);
        a23 : in std_logic_vector((total_size - 1) downto 0);
        a24 : in std_logic_vector((total_size - 1) downto 0);
        a25 : in std_logic_vector((total_size - 1) downto 0);
        a26 : in std_logic_vector((total_size - 1) downto 0);
        a27 : in std_logic_vector((total_size - 1) downto 0);
        a28 : in std_logic_vector((total_size - 1) downto 0);
        a29 : in std_logic_vector((total_size - 1) downto 0);
        a30 : in std_logic_vector((total_size - 1) downto 0);
        a31 : in std_logic_vector((total_size - 1) downto 0);
        c1 : out std_logic_vector((total_size) downto 0);
        c2 : out std_logic_vector((total_size+1) downto 0);
        c3 : out std_logic_vector((total_size+2) downto 0);
        c4 : out std_logic_vector((total_size+3) downto 0);
        s : out std_logic_vector((total_size - 1) downto 0)
    );
end adder_compressor_31_5;

architecture behavioral of adder_compressor_31_5 is

type compressor_31_5_blocks is array ((total_size - 1) downto 0) of unsigned(4 downto 0);

signal a_sum_compressor_full_adder : compressor_31_5_blocks;

begin

c1(0) <= '0';
c2(0) <= '0';
c2(1) <= '0';
c3(0) <= '0';
c3(1) <= '0';
c3(2) <= '0';
c4(0) <= '0';
c4(1) <= '0';
c4(2) <= '0';
c4(3) <= '0';

COMPRESSOR_31_5 : for I in compressor_31_5_blocks'range generate

a_sum_compressor_full_adder(I) <= resize(unsigned(a1(I downto I)), 5) + unsigned(a2(I downto I)) + unsigned(a3(I downto I)) + unsigned(a4(I downto I)) + unsigned(a5(I downto I)) + unsigned(a6(I downto I)) + unsigned(a7(I downto I)) + unsigned(a8(I downto I)) + unsigned(a9(I downto I)) + unsigned(a10(I downto I)) + unsigned(a11(I downto I)) + unsigned(a12(I downto I)) + unsigned(a13(I downto I)) + unsigned(a14(I downto I)) + unsigned(a15(I downto I)) + unsigned(a16(I downto I)) + unsigned(a17(I downto I)) + unsigned(a18(I downto I)) + unsigned(a19(I downto I)) + unsigned(a20(I downto I)) + unsigned(a21(I downto I)) + unsigned(a22(I downto I)) + unsigned(a23(I downto I)) + unsigned(a24(I downto I)) + unsigned(a25(I downto I)) + unsigned(a26(I downto I)) + unsigned(a27(I downto I)) + unsigned(a28(I downto I)) + unsigned(a29(I downto I)) + unsigned(a30(I downto I)) + unsigned(a31(I downto I));
s(I) <= a_sum_compressor_full_adder(I)(0);
c1(I+1) <= a_sum_compressor_full_adder(I)(1);
c2(I+2) <= a_sum_compressor_full_adder(I)(2);
c3(I+3) <= a_sum_compressor_full_adder(I)(3);
c4(I+4) <= a_sum_compressor_full_adder(I)(4);

end generate COMPRESSOR_31_5;

end behavioral;