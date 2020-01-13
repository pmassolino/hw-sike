-- Based on the design from the paper:
-- Authors: H. D. Nguyen, B. Pasca, and T. B. Preusser.
-- Title:  FPGA-Specific Arithmetic Optimizations of Short-Latency Adders
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

entity wide_adder_carry_select is
    Generic(
        base_size : integer;
        total_size : integer
    );
    Port (
        a : in std_logic_vector((total_size - 1) downto 0);
        b : in std_logic_vector((total_size - 1) downto 0);
        cin : in std_logic_vector(0 downto 0);
        o : out std_logic_vector((total_size - 1) downto 0)
    );
end wide_adder_carry_select;

architecture behavioral_aam of wide_adder_carry_select is

type number_blocks is array (((total_size + base_size - 1)/(base_size) - 1) downto 0) of unsigned((base_size - 1) downto 0);
type sum_blocks is array (((total_size + base_size - 1)/(base_size) - 1) downto 0) of unsigned((base_size) downto 0);
type carry_number_blocks is array ((((total_size + base_size - 1)/(base_size)) - 2) downto 0) of unsigned(0 downto 0);

signal a_divided_blocks : number_blocks;
signal b_divided_blocks : number_blocks;
signal s0_divided_blocks : sum_blocks;
signal s1_divided_blocks : sum_blocks;
signal c0_divided_blocks : unsigned(((total_size + base_size - 1)/(base_size) - 3) downto 0);
signal c1_divided_blocks : unsigned(((total_size + base_size - 1)/(base_size) - 3) downto 0);
signal ccc_temp : unsigned(((total_size + base_size - 1)/(base_size) - 3) downto 0);
signal c_final_divided_blocks : carry_number_blocks;
signal first_block_addition : unsigned(base_size downto 0);
signal o_divided_blocks : number_blocks;

begin

SPLIT_INPUT_A_B_OUTPUT_O : for I in number_blocks'range generate

MOST_BLOCKS : if (((I+1)*base_size)) <= total_size generate

a_divided_blocks(I) <= unsigned(a((((I+1)*base_size)-1) downto (I*base_size)));
b_divided_blocks(I) <= unsigned(b((((I+1)*base_size)-1) downto (I*base_size)));

o((((I+1)*base_size)-1) downto (I*base_size)) <= std_logic_vector(o_divided_blocks(I));

end generate MOST_BLOCKS;

LAST_BLOCK : if (((I+1)*base_size)) > total_size generate

a_divided_blocks(I)(((total_size mod base_size)-1) downto 0) <= unsigned(a((total_size-1) downto (I*base_size)));
a_divided_blocks(I)((base_size-1) downto (total_size mod base_size)) <= (others => '0');
b_divided_blocks(I)(((total_size mod base_size)-1) downto 0) <= unsigned(b((total_size-1) downto (I*base_size)));
b_divided_blocks(I)((base_size-1) downto (total_size mod base_size)) <= (others => '0');

o((total_size-1) downto (I*base_size)) <= std_logic_vector(o_divided_blocks(I)(((total_size mod base_size)-1) downto 0));

end generate LAST_BLOCK;

end generate SPLIT_INPUT_A_B_OUTPUT_O;

VALUES_S_0_1 : for I in 1 to (number_blocks'length - 1) generate

s0_divided_blocks(I) <= to_01(resize(a_divided_blocks(I), base_size+1)) + to_01(b_divided_blocks(I)) + to_unsigned(0,1);
s1_divided_blocks(I) <= to_01(resize(a_divided_blocks(I), base_size+1)) + to_01(b_divided_blocks(I)) + to_unsigned(1,1);

end generate VALUES_S_0_1;

VALUES_C_0_1 : for I in 1 to (number_blocks'length - 2) generate

c0_divided_blocks(I-1) <= s0_divided_blocks(I)(base_size);
c1_divided_blocks(I-1) <= s1_divided_blocks(I)(base_size);

end generate VALUES_C_0_1;

first_block_addition <= resize(a_divided_blocks(0), base_size + 1) + b_divided_blocks(0) + unsigned(cin);

o_divided_blocks(0) <= first_block_addition((base_size - 1) downto 0);
c_final_divided_blocks(0)(0) <= first_block_addition(base_size);

ccc_temp <= c0_divided_blocks + c1_divided_blocks + c_final_divided_blocks(0);

CR_CIRCUIT : for I in 1 to (number_blocks'length - 2) generate

c_final_divided_blocks(I)(0) <= (((not ccc_temp(I-1)) and c1_divided_blocks(I-1)) or c0_divided_blocks(I-1));

end generate CR_CIRCUIT;

OUTPUT_VALUES : for I in 1 to (number_blocks'length - 1) generate

o_divided_blocks(I) <= s1_divided_blocks(I)((base_size-1) downto 0) when c_final_divided_blocks(I-1)(0) = '1' else s0_divided_blocks(I)((base_size-1) downto 0);

end generate OUTPUT_VALUES;

end behavioral_aam;

architecture behavioral_cca of wide_adder_carry_select is

type number_blocks is array (((total_size + base_size - 1)/(base_size) - 1) downto 0) of unsigned((base_size - 1) downto 0);
type carry_number_blocks is array ((((total_size + base_size - 1)/(base_size)) - 2) downto 0) of unsigned(0 downto 0);

signal a_divided_blocks : number_blocks;
signal b_divided_blocks : number_blocks;
signal c0_divided_blocks : unsigned(((total_size + base_size - 1)/(base_size) - 3) downto 0);
signal c1_divided_blocks : unsigned(((total_size + base_size - 1)/(base_size) - 3) downto 0);
signal ccc_temp : unsigned(((total_size + base_size - 1)/(base_size) - 3) downto 0);
signal c_final_divided_blocks : carry_number_blocks;
signal first_block_addition : unsigned(base_size downto 0);
signal o_divided_blocks : number_blocks;

begin

SPLIT_INPUT_A_B_OUTPUT_O : for I in number_blocks'range generate

MOST_BLOCKS : if (((I+1)*base_size)) <= total_size generate

a_divided_blocks(I) <= unsigned(a((((I+1)*base_size)-1) downto (I*base_size)));
b_divided_blocks(I) <= unsigned(b((((I+1)*base_size)-1) downto (I*base_size)));

o((((I+1)*base_size)-1) downto (I*base_size)) <= std_logic_vector(o_divided_blocks(I));

end generate MOST_BLOCKS;

LAST_BLOCK : if (((I+1)*base_size)) > total_size generate

a_divided_blocks(I)(((total_size mod base_size)-1) downto 0) <= unsigned(a((total_size-1) downto (I*base_size)));
a_divided_blocks(I)((base_size-1) downto (total_size mod base_size)) <= (others => '0');
b_divided_blocks(I)(((total_size mod base_size)-1) downto 0) <= unsigned(b((total_size-1) downto (I*base_size)));
b_divided_blocks(I)((base_size-1) downto (total_size mod base_size)) <= (others => '0');

o((total_size-1) downto (I*base_size)) <= std_logic_vector(o_divided_blocks(I)(((total_size mod base_size)-1) downto 0));

end generate LAST_BLOCK;

end generate SPLIT_INPUT_A_B_OUTPUT_O;

VALUES_C_0_1 : for I in 1 to (number_blocks'length - 2) generate

c0_divided_blocks(I-1) <= '1' when (to_01(a_divided_blocks(I)) > to_01(not b_divided_blocks(I))) else '0';
c1_divided_blocks(I-1) <= '1' when (to_01(a_divided_blocks(I)) >= to_01(not b_divided_blocks(I))) else '0';

end generate VALUES_C_0_1;

first_block_addition <= resize(a_divided_blocks(0), base_size + 1) + b_divided_blocks(0) + unsigned(cin);

o_divided_blocks(0) <= first_block_addition((base_size - 1) downto 0);
c_final_divided_blocks(0)(0) <= first_block_addition(base_size);

ccc_temp <= c0_divided_blocks + c1_divided_blocks + c_final_divided_blocks(0);

CR_CIRCUIT : for I in 1 to (number_blocks'length - 2) generate

c_final_divided_blocks(I)(0) <= (((not ccc_temp(I-1)) and c1_divided_blocks(I-1)) or c0_divided_blocks(I-1));

end generate CR_CIRCUIT;

OUTPUT_VALUES : for I in 1 to (number_blocks'length - 1) generate

o_divided_blocks(I) <= a_divided_blocks(I) + b_divided_blocks(I) + c_final_divided_blocks(I-1);

end generate OUTPUT_VALUES;

end behavioral_cca;