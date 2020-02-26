----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    
-- Design Name:    
-- Module Name:    
-- Project Name:   
-- Target Devices: Any
-- Tool versions:  
--
-- Description: 
--
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
-- 
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity base_alu is
    Generic (
        values_size : integer;
        rotation_level : integer
    );
    Port (
        a : in std_logic_vector((values_size - 1) downto 0);
        b : in std_logic_vector((values_size - 1) downto 0);
        operation_type : in std_logic_vector(1 downto 0);
        rotation_size : in std_logic_vector((rotation_level - 1) downto 0);
        left_rotation : in std_logic;
        shift_mode : in std_logic;
        math_operation : in std_logic_vector(1 downto 0);
        a_signed : in std_logic;
        b_signed : in std_logic;
        logic_operation : in std_logic_vector(1 downto 0);
        o : out std_logic_vector((2*values_size - 1) downto 0);
        o_equal_zero : out std_logic;
        o_change_sign_b : out std_logic
    );
end base_alu;

architecture behavioral of base_alu is

signal internal_a : std_logic_vector((values_size) downto 0);
signal internal_b : std_logic_vector((values_size) downto 0);

signal dsp_sign : std_logic;
signal dsp_a : signed((values_size) downto 0);
signal dsp_b : signed((values_size) downto 0);
signal dsp_c : signed((values_size) downto 0);
signal dsp_o : signed((2*values_size + 1) downto 0);

type rotations_intermediate is array(integer range 0 to (rotation_level)) of std_logic_vector((values_size - 1) downto 0);

signal inverted_b : std_logic_vector((values_size - 1) downto 0);
signal rotation_b_intermediates : rotations_intermediate;
signal final_intermediate_rotation : std_logic_vector((values_size - 1) downto 0);
signal inverted_final_intermediate_rotation : std_logic_vector((values_size - 1) downto 0);
signal rotation_output : std_logic_vector((values_size - 1) downto 0);

signal logic_output : std_logic_vector((values_size - 1) downto 0);

signal internal_o_equal_zero : std_logic;
signal internal_o_change_sign_b : std_logic;

begin

internal_a(values_size) <= a(values_size - 1) when (a_signed = '1') else '0';
internal_a((values_size - 1) downto 0) <= a((values_size - 1) downto 0);

internal_b(values_size) <= b(values_size - 1) when (b_signed = '1') else '0';
internal_b((values_size - 1) downto 0) <= b((values_size - 1) downto 0);

dsp_a <= signed(internal_a) when (math_operation(1 downto 0) = "00") else
         signed(internal_a) when (math_operation(1 downto 0) = "01") else
         signed(internal_a) when (math_operation(1 downto 0) = "10") else
         (others => '0');

dsp_b <= to_signed(1, dsp_b'length) when (math_operation(1 downto 0) = "00") else
         to_signed(1, dsp_b'length) when (math_operation(1 downto 0) = "01") else
         signed(internal_b) when (math_operation(1 downto 0) = "10") else
         (others => '0');

dsp_c <= signed(internal_b) when (math_operation(1 downto 0) = "00") else
         signed(internal_b) when (math_operation(1 downto 0) = "01") else
         to_signed(0, dsp_b'length) when (math_operation(1 downto 0) = "10") else
         (others => '0');

dsp_sign <= '0' when (math_operation(1 downto 0) = "01") else
            '1';
         
process(dsp_a, dsp_b, dsp_c, dsp_sign)
begin
    if(dsp_sign = '1') then
        dsp_o <= dsp_c + dsp_a*dsp_b;
    else
        dsp_o <= dsp_c - dsp_a*dsp_b;
    end if;
end process;

process(b)
begin
    for i in b'range loop
        inverted_b(i) <= b(values_size - i - 1);
    end loop;
end process;

rotation_b_intermediates(0) <= inverted_b when left_rotation = '1' else
                               b;

main_rotation : for I in 0 to (rotation_level - 1) generate

rotation_b_intermediates((I+1))((values_size - 1) downto (values_size - (2**I))) <= rotation_b_intermediates(I)((values_size - 1) downto (values_size - (2**I))) when rotation_size(I) = '0' else 
                                                                           rotation_b_intermediates(I)((2**I - 1) downto 0) when shift_mode = '0' else
                                                                           (others => '0');
rotation_b_intermediates((I+1))((values_size - 1 - (2**I)) downto 0) <= rotation_b_intermediates(I)((values_size -  1 - (2**I)) downto 0) when rotation_size(I) = '0' else 
                                                                        rotation_b_intermediates(I)((values_size - 1) downto (2**I));

end generate;

final_intermediate_rotation <= rotation_b_intermediates(rotation_level);

process(final_intermediate_rotation)
begin
    for i in final_intermediate_rotation'range loop
        inverted_final_intermediate_rotation(i) <= final_intermediate_rotation(values_size - i - 1);
    end loop;
end process;

rotation_output <= inverted_final_intermediate_rotation when left_rotation = '1' else
                   final_intermediate_rotation;
                   
logic_output <= a and b when logic_operation = "00" else
                a or b when logic_operation = "01" else
                a xor b when logic_operation = "10" else
                (others => '0');

o((2*values_size - 1) downto values_size) <= std_logic_vector(dsp_o((2*values_size - 1) downto values_size)) when operation_type = "00" else
                                             (others => '0') when operation_type = "01" else
                                             (others => '0') when operation_type = "10" else
                                             (others => '0');
o((values_size - 1) downto 0) <= std_logic_vector(dsp_o((values_size - 1) downto 0)) when operation_type = "00" else
                                 rotation_output when operation_type = "01" else
                                 logic_output when operation_type = "10" else
                                 (others => '0');

internal_o_equal_zero <= '1' when to_01(dsp_o((values_size - 1) downto 0)) = to_signed(0, values_size) else '0';

process(dsp_a, dsp_c, dsp_o, internal_o_equal_zero)
begin
    if(internal_o_equal_zero = '1') then
        internal_o_change_sign_b <= '0';
    else
        if(dsp_a(values_size) = dsp_c(values_size)) then
            if(dsp_c(values_size) = '1') then
                internal_o_change_sign_b <= dsp_o(values_size);
            else
                internal_o_change_sign_b <= dsp_o(values_size);
            end if;
        else
            internal_o_change_sign_b <= dsp_c(values_size);
        end if;
    end if;
end process;

o_equal_zero <= internal_o_equal_zero;
o_change_sign_b <= internal_o_change_sign_b;

end behavioral;