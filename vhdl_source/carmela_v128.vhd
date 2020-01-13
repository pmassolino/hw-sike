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

entity carmela_v128 is
    Generic(
        base_wide_adder_size : integer := 2;
        base_word_size : integer := 16;
        multiplication_factor : integer := 8;
        accumulator_extra_bits : integer := 32;
        memory_address_size : integer := 10
    );
    Port(
        rstn : in std_logic;
        clk : in std_logic;
        address_a : in std_logic_vector((memory_address_size - 1) downto 0);
        address_b : in std_logic_vector((memory_address_size - 1) downto 0);
        address_o : in std_logic_vector((memory_address_size - 1) downto 0);
        next_address_o : in std_logic_vector((memory_address_size - 1) downto 0);
        memory_double_mode : in std_logic;
        memory_only_write_mode : in std_logic;
        enable_signed_a : in std_logic;
        enable_signed_b : in std_logic;
        clear_reg_b : in std_logic;
        clear_reg_acc : in std_logic;
        sel_load_reg_a : in std_logic_vector(1 downto 0);
        sel_shift_reg_o : in std_logic;
        enable_update_reg_s : in std_logic;
        sel_reg_s_reg_o_sign : in std_logic;
        reg_s_reg_o_positive : in std_logic;
        operation_mode : in std_logic_vector(1 downto 0);
        enable_reg_s_mask : in std_logic;
        subtraction_reg_a_b : in std_logic;
        sel_multiply_two_a_b : in std_logic;
        sel_reg_y_output : in std_logic;
        write_enable_output : in std_logic;
        data_in_mem_one_a : in std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
        data_in_mem_one_b : in std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
        data_in_mem_two_a : in std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
        data_in_mem_two_b : in std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
        write_enable_mem_one_a : out std_logic;
        write_enable_mem_one_b : out std_logic;
        write_enable_mem_two_a : out std_logic;
        write_enable_mem_two_b : out std_logic;
        mem_one_address_a : out std_logic_vector((memory_address_size - 1) downto 0);
        mem_one_address_b : out std_logic_vector((memory_address_size - 1) downto 0);
        mem_two_address_a : out std_logic_vector((memory_address_size - 1) downto 0);
        mem_two_address_b : out std_logic_vector((memory_address_size - 1) downto 0);
        data_out_mem_one_a : out std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
        data_out_mem_one_b : out std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
        data_out_mem_two_a : out std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
        data_out_mem_two_b : out std_logic_vector((multiplication_factor*base_word_size - 1) downto 0)
    );
end carmela_v128;

architecture simple_multipliers of carmela_v128 is

component pipeline_signed_base_multiplier_129
    port(
        a : in std_logic_vector(128 downto 0);
        b : in std_logic_vector(128 downto 0);
        clk : in std_logic;
        o : out std_logic_vector(256 downto 0)
    );
end component;

component wide_adder_carry_select
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
end component;

component adder_compressor_3_2
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
end component;

signal int_sel_load_reg_a_1 : std_logic_vector(1 downto 0);
signal int_enable_signed_a : std_logic_vector(1 downto 1);
signal int_enable_signed_b : std_logic_vector(1 downto 1);
signal int_clear_reg_b : std_logic_vector(1 downto 1);
signal int_clear_reg_acc : std_logic_vector(1 downto 1);
signal int_sel_shift_reg_o : std_logic_vector(1 downto 1);
signal int_enable_update_reg_s : std_logic_vector(1 downto 1);
signal int_sel_reg_s_reg_o_sign : std_logic_vector(1 downto 1);
signal int_reg_s_reg_o_positive : std_logic_vector(1 downto 1);
signal int_operation_mode_1 : std_logic_vector(1 downto 0);
signal int_operation_mode_2 : std_logic_vector(1 downto 0);
signal int_operation_mode_3 : std_logic_vector(1 downto 0);
signal int_operation_mode_4 : std_logic_vector(1 downto 0);
signal int_operation_mode_5 : std_logic;
signal int_operation_mode_6 : std_logic;
signal int_operation_mode_7 : std_logic;
signal int_operation_mode_8 : std_logic;
signal int_operation_mode_9 : std_logic;
signal int_enable_reg_s_mask : std_logic_vector(2 downto 1);
signal int_subtraction_reg_a_b : std_logic_vector(2 downto 1);
signal int_sel_multiply_two_a_b : std_logic_vector(8 downto 1);
signal int_sel_reg_y_output : std_logic_vector(9 downto 1);
signal int_write_enable_output : std_logic_vector(9 downto 1);
signal int_memory_only_write_mode : std_logic_vector(9 downto 1);

signal int_address_o_1 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_address_o_2 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_address_o_3 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_address_o_4 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_address_o_5 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_address_o_6 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_address_o_7 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_address_o_8 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_address_o_9 : std_logic_vector((memory_address_size - 1) downto 0);

signal int_next_address_o_1 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_next_address_o_2 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_next_address_o_3 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_next_address_o_4 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_next_address_o_5 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_next_address_o_6 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_next_address_o_7 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_next_address_o_8 : std_logic_vector((memory_address_size - 1) downto 0);
signal int_next_address_o_9 : std_logic_vector((memory_address_size - 1) downto 0);

signal data_in_a_internal : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
signal data_in_b_internal : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);

signal reg_a : std_logic_vector((multiplication_factor*base_word_size) downto 0);
signal reg_a_inverse : std_logic_vector((multiplication_factor*base_word_size) downto 0);
signal reg_b : std_logic_vector((multiplication_factor*base_word_size) downto 0);
signal reg_acc : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);
signal reg_s : std_logic;
signal reg_s_pipeline : std_logic_vector(5 downto 3);
signal reg_s_mask : std_logic_vector((multiplication_factor*base_word_size) downto 0);
signal reg_b_masked_s : std_logic_vector((multiplication_factor*base_word_size) downto 0);
signal reg_b_masked_s_inverse : std_logic_vector((multiplication_factor*base_word_size) downto 0);

signal multiplier_a : std_logic_vector((multiplication_factor*base_word_size) downto 0);
signal multiplier_b : std_logic_vector((multiplication_factor*base_word_size) downto 0);
signal multiplier_o : std_logic_vector((2*multiplication_factor*base_word_size + 1) downto 0);

signal reg_multiplier_o : std_logic_vector((multiplication_factor*base_word_size) downto 0);

signal compress_a_b_acc_a : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);
signal compress_a_b_acc_b : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);
signal compress_a_b_acc_p : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);
signal compress_a_b_acc_c : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits) downto 0);
signal compress_a_b_acc_s : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);

signal reg_compress_a_b_acc_c : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);
signal reg_compress_a_b_acc_s : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);

signal reg_acc_a_b_4 : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);
signal reg_acc_a_b_5 : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);
signal reg_acc_a_b_6 : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);
signal reg_acc_a_b_7 : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);

signal acc_final_value_a : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);
signal acc_final_value_b : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);
signal acc_final_value_o : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);

signal reg_acc_final_value_o : std_logic_vector((2*multiplication_factor*base_word_size + accumulator_extra_bits - 1) downto 0);
signal reg_y : std_logic_vector((multiplication_factor*base_word_size) downto 0);

signal mac_output_1 : std_logic_vector((multiplication_factor*base_word_size) downto 0);
signal mac_output_2 : std_logic_vector((multiplication_factor*base_word_size) downto 0);

begin

mem_one_address_a <= int_address_o_9 ;
mem_one_address_b <= int_next_address_o_9 when (int_memory_only_write_mode(9) = '1') else
                     address_a;
mem_two_address_a <= int_address_o_9;
mem_two_address_b <= int_next_address_o_9 when (int_memory_only_write_mode(9) = '1') else
                     address_b;

write_enable_mem_one_a <= int_write_enable_output(9);
write_enable_mem_one_b <= int_write_enable_output(9) when (int_memory_only_write_mode(9) = '1') else
                          '0';
write_enable_mem_two_a <= int_write_enable_output(9);
write_enable_mem_two_b <= int_write_enable_output(9) when (int_memory_only_write_mode(9) = '1') else
                          '0';
data_out_mem_one_a <= mac_output_1((multiplication_factor*base_word_size - 1) downto 0);
data_out_mem_one_b <= mac_output_2((multiplication_factor*base_word_size - 1) downto 0);
data_out_mem_two_a <= mac_output_1((multiplication_factor*base_word_size - 1) downto 0);
data_out_mem_two_b <= mac_output_2((multiplication_factor*base_word_size - 1) downto 0);

data_in_a_internal <= data_in_mem_one_b;
data_in_b_internal <= data_in_mem_two_b;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            int_enable_signed_a <= (others => '0');
            int_enable_signed_b <= (others => '0');
            int_sel_load_reg_a_1 <= (others => '0');
            int_clear_reg_b <= (others => '0');
            int_clear_reg_acc <= (others => '0');
            int_sel_shift_reg_o <= (others => '0');
            int_enable_update_reg_s <= (others => '0');
            int_sel_reg_s_reg_o_sign <= (others => '0');
            int_reg_s_reg_o_positive <= (others => '0');
            int_operation_mode_1 <= (others => '0');
            int_operation_mode_2 <= (others => '0');
            int_operation_mode_3 <= (others => '0');
            int_operation_mode_4 <= (others => '0');
            int_operation_mode_5 <= '0';
            int_operation_mode_6 <= '0';
            int_operation_mode_7 <= '0';
            int_operation_mode_8 <= '0';
            int_enable_reg_s_mask <= (others => '0');
            int_subtraction_reg_a_b <= (others => '0');
            int_sel_multiply_two_a_b <= (others => '0');
            int_sel_reg_y_output <= (others => '0');
            int_write_enable_output <= (others => '0');
            int_memory_only_write_mode <= (others => '0');
            reg_s <= '0';
            reg_s_pipeline <= (others => '0');
        else
        -- First Stage
        int_enable_signed_a(1) <= enable_signed_a;
        int_enable_signed_b(1) <= enable_signed_b;
        int_clear_reg_b(1) <= clear_reg_b;
        int_clear_reg_acc(1) <= clear_reg_acc;
        int_sel_load_reg_a_1 <= sel_load_reg_a;
        int_sel_shift_reg_o(1) <= sel_shift_reg_o;
        int_enable_update_reg_s(1) <= enable_update_reg_s;
        int_sel_reg_s_reg_o_sign(1) <= sel_reg_s_reg_o_sign;
        int_reg_s_reg_o_positive(1) <= reg_s_reg_o_positive;
        int_operation_mode_1 <= operation_mode;
        int_enable_reg_s_mask(1) <= enable_reg_s_mask;
        int_subtraction_reg_a_b(1) <= subtraction_reg_a_b;
        int_sel_multiply_two_a_b(1) <= sel_multiply_two_a_b;
        int_sel_reg_y_output(1) <= sel_reg_y_output;
        int_write_enable_output(1) <= write_enable_output;
        int_memory_only_write_mode(1) <= memory_only_write_mode and memory_double_mode;
        int_address_o_1 <= address_o;
        int_next_address_o_1 <= next_address_o;
        -- Second Stage
        int_operation_mode_2 <= int_operation_mode_1;
        int_enable_reg_s_mask(2) <= int_enable_reg_s_mask(1);
        int_subtraction_reg_a_b(2) <= int_subtraction_reg_a_b(1);
        int_sel_multiply_two_a_b(2) <= int_sel_multiply_two_a_b(1);
        int_sel_reg_y_output(2) <= int_sel_reg_y_output(1);
        int_write_enable_output(2) <= int_write_enable_output(1);
        int_memory_only_write_mode(2) <= int_memory_only_write_mode(1);
        if(int_sel_load_reg_a_1 = "11") then
            reg_a <= (others => '0');
        elsif(int_sel_load_reg_a_1 = "01") then
            reg_a <= "0" & reg_y((reg_a'length - 2) downto 0);
        elsif(int_sel_load_reg_a_1 = "10") then
            reg_a <= "0" & reg_acc_final_value_o((reg_a'length - 2) downto 0);
        else
            if(int_enable_signed_a(1) = '1') then
                reg_a(data_in_a_internal'length) <= data_in_a_internal(data_in_a_internal'length - 1);
            else
                reg_a(data_in_a_internal'length) <= '0';
            end if;
            reg_a((data_in_a_internal'length - 1) downto 0) <= data_in_a_internal;
        end if;
        if(int_clear_reg_b(1) = '1') then
            reg_b <= (others => '0');
        else
            if(int_enable_signed_b(1) = '1') then
                reg_b(data_in_b_internal'length) <= data_in_b_internal(data_in_b_internal'length - 1);
            else
                reg_b(data_in_b_internal'length) <= '0';
            end if;
            reg_b((data_in_b_internal'length - 1) downto 0) <= data_in_b_internal;
        end if;
        if(int_clear_reg_acc(1) = '1') then
            reg_acc <= (others => '0');
        elsif(int_sel_shift_reg_o(1) = '1') then
            reg_acc(((reg_acc_final_value_o'length - multiplication_factor*base_word_size - 1)) downto 0) <= reg_acc_final_value_o((reg_acc_final_value_o'length - 1) downto multiplication_factor*base_word_size);
            reg_acc(((reg_acc'length - 1)) downto (reg_acc_final_value_o'length - multiplication_factor*base_word_size)) <= (others => reg_acc_final_value_o(reg_acc_final_value_o'length - 1));
        else
            reg_acc <= reg_acc_final_value_o;
        end if;
        if(int_enable_update_reg_s(1) = '1') then
            if(int_sel_reg_s_reg_o_sign(1) = '1') then
                reg_s <= reg_acc_final_value_o(reg_acc_final_value_o'length-1) xor int_reg_s_reg_o_positive(1);
            else
                reg_s <= int_operation_mode_1(0);
            end if;
        else
            reg_s <= reg_s_pipeline(5);
        end if;
        int_address_o_2 <= int_address_o_1;
        int_next_address_o_2 <= int_next_address_o_1;
        -- Third Stage
        reg_s_pipeline(3) <= reg_s;
        int_operation_mode_3 <= int_operation_mode_2;
        int_sel_multiply_two_a_b(3) <= int_sel_multiply_two_a_b(2);
        int_sel_reg_y_output(3) <= int_sel_reg_y_output(2);
        int_write_enable_output(3) <= int_write_enable_output(2);
        int_memory_only_write_mode(3) <= int_memory_only_write_mode(2);
        reg_compress_a_b_acc_c(compress_a_b_acc_c'length - 2 downto 1) <= compress_a_b_acc_c(compress_a_b_acc_c'length - 2 downto 1);
        if(int_operation_mode_2 = "00") then
            reg_compress_a_b_acc_c(0) <= '1';
        else 
            reg_compress_a_b_acc_c(0) <= '0';
        end if;
        reg_compress_a_b_acc_s <= compress_a_b_acc_s;
        int_address_o_3 <= int_address_o_2;
        int_next_address_o_3 <= int_next_address_o_2;
        -- Fourth Stage
        reg_s_pipeline(4) <= reg_s_pipeline(3);
        int_operation_mode_4 <= int_operation_mode_3;
        int_sel_multiply_two_a_b(4) <= int_sel_multiply_two_a_b(3);
        int_sel_reg_y_output(4) <= int_sel_reg_y_output(3);
        int_write_enable_output(4) <= int_write_enable_output(3);
        int_memory_only_write_mode(4) <= int_memory_only_write_mode(3);
        reg_acc_a_b_4 <= reg_compress_a_b_acc_s;
        int_address_o_4 <= int_address_o_3;
        int_next_address_o_4 <= int_next_address_o_3;
        -- Fifth Stage
        reg_s_pipeline(5) <= reg_s_pipeline(4);
        int_operation_mode_5 <= int_operation_mode_4(0);
        int_sel_multiply_two_a_b(5) <= int_sel_multiply_two_a_b(4);
        if(int_operation_mode_4(1) = '0') then
            int_sel_reg_y_output(5) <= '0';
            int_write_enable_output(5) <= '0';
            int_memory_only_write_mode(5) <= '0';
        else
            int_sel_reg_y_output(5) <= int_sel_reg_y_output(4);
            int_write_enable_output(5) <= int_write_enable_output(4);
            int_memory_only_write_mode(5) <= int_memory_only_write_mode(4);
        end if;
        reg_acc_a_b_5 <= reg_acc_a_b_4;
        int_address_o_5 <= int_address_o_4;
        int_next_address_o_5 <= int_next_address_o_4;
        -- Sixth Stage
        int_operation_mode_6 <= int_operation_mode_5;
        int_sel_multiply_two_a_b(6) <= int_sel_multiply_two_a_b(5);
        int_sel_reg_y_output(6) <= int_sel_reg_y_output(5);
        int_write_enable_output(6) <= int_write_enable_output(5);
        int_memory_only_write_mode(6) <= int_memory_only_write_mode(5);
        reg_acc_a_b_6 <= reg_acc_a_b_5;
        int_address_o_6 <= int_address_o_5;
        int_next_address_o_6 <= int_next_address_o_5;
        -- Seventh Stage
        int_operation_mode_7 <= int_operation_mode_6;
        int_sel_multiply_two_a_b(7) <= int_sel_multiply_two_a_b(6);
        int_sel_reg_y_output(7) <= int_sel_reg_y_output(6);
        int_write_enable_output(7) <= int_write_enable_output(6);
        int_memory_only_write_mode(7) <= int_memory_only_write_mode(6);
        reg_acc_a_b_7 <= reg_acc_a_b_6;
        int_address_o_7 <= int_address_o_6;
        int_next_address_o_7 <= int_next_address_o_6;
        -- Eighth Stage
        int_operation_mode_8 <= int_operation_mode_7;
        int_sel_multiply_two_a_b(8) <= int_sel_multiply_two_a_b(7);
        int_sel_reg_y_output(8) <= int_sel_reg_y_output(7);
        int_write_enable_output(8) <= int_write_enable_output(7);
        int_memory_only_write_mode(8) <= int_memory_only_write_mode(7);
        int_address_o_8 <= int_address_o_7;
        int_next_address_o_8 <= int_next_address_o_7;
        reg_multiplier_o <= multiplier_o((reg_multiplier_o'length - 1) downto 0);
        if(int_operation_mode_3(1) = '1') then
            if(int_operation_mode_7 = '1') then
                acc_final_value_a <= (others => '0');
            elsif(int_sel_multiply_two_a_b(7) = '1') then
                acc_final_value_a((multiplier_o'length) downto 0) <= multiplier_o & "0";
                acc_final_value_a((acc_final_value_a'length - 1) downto (multiplier_o'length+1)) <= (others => multiplier_o(multiplier_o'length-1));
            else
                acc_final_value_a((multiplier_o'length) downto 0) <= (multiplier_o(multiplier_o'length-1) & multiplier_o);
                acc_final_value_a((acc_final_value_a'length - 1) downto (multiplier_o'length+1)) <= (others => multiplier_o(multiplier_o'length-1));
            end if;
            acc_final_value_b <= reg_acc_a_b_7;
        else
            acc_final_value_a <= reg_compress_a_b_acc_c;
            acc_final_value_b <= reg_compress_a_b_acc_s;
        end if;
        -- Ninth Stage
        if(int_operation_mode_3(1) = '1') then
            int_sel_reg_y_output(9) <= int_sel_reg_y_output(8);
            int_write_enable_output(9) <= int_write_enable_output(8);
            int_memory_only_write_mode(9) <= int_memory_only_write_mode(8);
            int_address_o_9 <= int_address_o_8;
            int_next_address_o_9 <= int_next_address_o_8;
        else
            int_sel_reg_y_output(9) <= '0';
            int_write_enable_output(9) <= int_write_enable_output(4);
            int_memory_only_write_mode(9) <= int_memory_only_write_mode(4);
            int_address_o_9 <= int_address_o_4;
            int_next_address_o_9 <= int_next_address_o_4;
        end if;
        reg_y <= reg_multiplier_o;
        reg_acc_final_value_o <= acc_final_value_o;
        end if;
    end if;
end process;

reg_s_mask <= (others => reg_s);
reg_b_masked_s <= reg_b and reg_s_mask when (int_enable_reg_s_mask(2) = '1') else reg_b;

reg_a_inverse <= not reg_a;
reg_b_masked_s_inverse <= not reg_b_masked_s;

compress_a_b_acc_a((reg_a'length - 1) downto 0) <= (others => '0') when (int_operation_mode_2(1) = '1') else 
                                                   reg_a when (int_operation_mode_2(0) = '1') else 
                                                   reg_a when (int_subtraction_reg_a_b(2) = '1') else 
                                                   reg_a_inverse;
compress_a_b_acc_a((compress_a_b_acc_a'length - 1) downto reg_a'length) <= (others => '0') when (int_operation_mode_2(1) = '1') else 
                                                   (others => reg_a(reg_a'length - 1)) when (int_operation_mode_2(0) = '1') else 
                                                   (others => reg_a(reg_a'length - 1)) when (int_subtraction_reg_a_b(2) = '1') else 
                                                   (others => reg_a_inverse(reg_a_inverse'length - 1));
                                                   
compress_a_b_acc_b((reg_b_masked_s'length - 1) downto 0) <= (others => '0') when (int_operation_mode_2(1) = '1') else 
                                                   reg_b_masked_s when (int_operation_mode_2(0) = '1') else 
                                                   reg_b_masked_s_inverse when (int_subtraction_reg_a_b(2) = '1') else 
                                                   reg_b_masked_s;
compress_a_b_acc_b((compress_a_b_acc_b'length - 1) downto reg_b_masked_s'length) <= (others => '0') when (int_operation_mode_2(1) = '1') else 
                                                   (others => reg_b_masked_s(reg_b_masked_s'length - 1)) when (int_operation_mode_2(0) = '1') else 
                                                   (others => reg_b_masked_s_inverse(reg_b_masked_s_inverse'length - 1)) when (int_subtraction_reg_a_b(2) = '1') else 
                                                   (others => reg_b_masked_s(reg_b_masked_s'length - 1));
                                                   
compress_a_b_acc_p <= reg_acc;

compress_a_b_acc : adder_compressor_3_2
    Generic Map(
        total_size => 2*multiplication_factor*base_word_size + accumulator_extra_bits
    )
    Port Map(
        a => compress_a_b_acc_a,
        b => compress_a_b_acc_b,
        p => compress_a_b_acc_p,
        c => compress_a_b_acc_c,
        s => compress_a_b_acc_s
    );

multiplier : entity work.pipeline_signed_base_multiplier_129(behavioral)
    port map(
        a => multiplier_a,
        b => multiplier_b,
        clk => clk,
        o => multiplier_o
    );

multiplier_a <= reg_a;
multiplier_b <= reg_b;

acc_final_value : entity work.wide_adder_carry_select(behavioral_aam)
    Generic Map(
        base_size => base_wide_adder_size,
        total_size => 2*multiplication_factor*base_word_size + accumulator_extra_bits
    )
    Port Map(
        a => acc_final_value_a,
        b => acc_final_value_b,
        cin => "0",
        o => acc_final_value_o
    );

mac_output_1 <= reg_y((multiplication_factor*base_word_size) downto 0) when (int_sel_reg_y_output(9) = '1') else reg_acc_final_value_o((multiplication_factor*base_word_size) downto 0);

mac_output_2 <= reg_acc_final_value_o((2*multiplication_factor*base_word_size) downto (multiplication_factor*base_word_size));

end simple_multipliers;