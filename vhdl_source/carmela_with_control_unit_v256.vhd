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

entity carmela_with_control_unit_v256 is
    Generic(
        base_wide_adder_size : integer := 2;
        base_word_size : integer := 16;
        multiplication_factor : integer := 16;
        accumulator_extra_bits : integer := 32;
        memory_address_size : integer := 10;
        max_operands_size : integer := 2
    );
    Port(
        rstn : in std_logic;
        clk : in std_logic;
        instruction_values_valid : in std_logic;
        instruction_type : in std_logic_vector(3 downto 0);
        operands_size : in std_logic_vector((max_operands_size - 1) downto 0);
        prime_line_equal_one : in std_logic;
        load_new_address_prime : in std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
        load_new_address_prime_line : in std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
        load_new_address_prime_plus_one : in std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
        load_new_address_input_ma : in std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
        load_new_sign_ma : in std_logic;
        load_new_address_input_mb : in std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
        load_new_address_output_mo : in std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
        enable_new_address_output_mo : in std_logic;
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
        data_out_mem_two_b : out std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
        free_flag : out std_logic
    );
end carmela_with_control_unit_v256;

architecture behavioral of carmela_with_control_unit_v256 is

signal mac_address_a : std_logic_vector((memory_address_size - 1) downto 0);
signal mac_address_b : std_logic_vector((memory_address_size - 1) downto 0);
signal mac_address_o : std_logic_vector((memory_address_size - 1) downto 0);
signal mac_next_address_o : std_logic_vector((memory_address_size - 1) downto 0);
signal mac_memory_double_mode : std_logic;
signal mac_memory_only_write_mode : std_logic;
signal mac_enable_signed_a : std_logic;
signal mac_enable_signed_b : std_logic;
signal mac_sel_load_reg_a : std_logic_vector(1 downto 0);
signal mac_clear_reg_b : std_logic;
signal mac_clear_reg_acc : std_logic;
signal mac_sel_shift_reg_o : std_logic;
signal mac_enable_update_reg_s : std_logic;
signal mac_sel_reg_s_reg_o_sign : std_logic;
signal mac_reg_s_reg_o_positive : std_logic;
signal mac_operation_mode : std_logic_vector(1 downto 0);
signal mac_enable_reg_s_mask : std_logic;
signal mac_subtraction_reg_a_b : std_logic;
signal mac_sel_multiply_two_a_b : std_logic;
signal mac_sel_reg_y_output : std_logic;
signal mac_write_enable_output : std_logic;

signal base_address_generator_a_circular_shift_enable : std_logic;
signal base_address_generator_a_load_new_values_enable : std_logic;
signal base_address_generator_a_rotation_size : std_logic_vector(1 downto 0);
signal base_address_generator_a_current_address : std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
signal base_address_generator_b_circular_shift_enable : std_logic;
signal base_address_generator_b_load_new_values_enable : std_logic;
signal base_address_generator_b_rotation_size : std_logic_vector(1 downto 0);
signal base_address_generator_b_current_address : std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
signal base_address_generator_o_circular_shift_enable : std_logic;
signal base_address_generator_o_load_new_values_enable : std_logic;
signal base_address_generator_o_increment_previous_address : std_logic;
signal base_address_generator_o_rotation_size : std_logic_vector(1 downto 0);
signal base_address_generator_o_current_address_enable : std_logic;
signal base_address_generator_o_current_address : std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
signal base_address_prime : std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
signal base_address_prime_line : std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
signal base_address_prime_plus_one : std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);

signal loading_values_mode : std_logic;

signal sign_a_values : std_logic_vector(7 downto 0);
signal control_operation_number : std_logic_vector(7 downto 0);
signal penultimate_operation : std_logic;
signal sm_rotation_size : std_logic_vector(1 downto 0);
signal sm_circular_shift_enable : std_logic;
signal sel_address_a : std_logic;
signal sel_address_b_prime : std_logic_vector(1 downto 0);
signal sm_specific_mac_address_a : std_logic_vector(1 downto 0);
signal sm_specific_mac_address_b : std_logic_vector(1 downto 0);
signal sm_specific_mac_address_o : std_logic_vector(1 downto 0);
signal sm_specific_mac_next_address_o : std_logic_vector(1 downto 0);
signal sm_sign_a_mode : std_logic;
signal sm_mac_operation_mode : std_logic_vector(1 downto 0);
signal sm_mac_write_enable_output : std_logic;
signal sm_free_flag : std_logic;

component carmela_v256
    Generic(
        base_wide_adder_size : integer := 2;
        base_word_size : integer := 16;
        multiplication_factor: integer := 16;
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
        sel_load_reg_a : in std_logic_vector(1 downto 0);
        clear_reg_b : in std_logic;
        clear_reg_acc : in std_logic;
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
end component;

component carmela_state_machine_v256
    Port (
        clk : in std_logic;
        rstn : in std_logic;
        instruction_values_valid : in std_logic;
        instruction_type : in std_logic_vector(3 downto 0);
        operands_size : in std_logic_vector(1 downto 0);
        prime_line_equal_one : in std_logic;
        penultimate_operation : in std_logic;
        sm_rotation_size : out std_logic_vector(1 downto 0);
        sm_circular_shift_enable : out std_logic;
        sel_address_a : out std_logic;
        sel_address_b_prime : out std_logic_vector(1 downto 0);
        sm_specific_mac_address_a : out std_logic_vector(1 downto 0);
        sm_specific_mac_address_b : out std_logic_vector(1 downto 0);
        sm_specific_mac_address_o : out std_logic_vector(1 downto 0);
        sm_specific_mac_next_address_o : out std_logic_vector(1 downto 0);
        mac_enable_signed_a : out std_logic;
        mac_enable_signed_b : out std_logic;
        mac_sel_load_reg_a : out std_logic_vector(1 downto 0);
        mac_clear_reg_b : out std_logic;
        mac_clear_reg_acc : out std_logic;
        mac_sel_shift_reg_o : out std_logic;
        mac_enable_update_reg_s : out std_logic;
        mac_sel_reg_s_reg_o_sign : out std_logic;
        mac_reg_s_reg_o_positive : out std_logic;
        sm_sign_a_mode : out std_logic;
        sm_mac_operation_mode : out std_logic_vector(1 downto 0);
        mac_enable_reg_s_mask : out std_logic;
        mac_subtraction_reg_a_b : out std_logic;
        mac_sel_multiply_two_a_b : out std_logic;
        mac_sel_reg_y_output : out std_logic;
        sm_mac_write_enable_output : out std_logic;
        mac_memory_double_mode : out std_logic;
        mac_memory_only_write_mode : out std_logic;
        base_address_generator_o_increment_previous_address : out std_logic;
        sm_free_flag : out std_logic
    );
end component;

component base_address_circular_shift_input_v2
    Generic(
        memory_base_address_size : integer
    );
    Port (
        clk : in std_logic;
        circular_shift_enable : in std_logic;
        load_new_values_enable : in std_logic;
        rotation_size : in std_logic_vector(1 downto 0);
        load_new_address : in std_logic_vector((memory_base_address_size - 1) downto 0);
        current_address : out std_logic_vector((memory_base_address_size - 1) downto 0)
    );
end component;

component base_address_circular_shift_output_v2
    Generic(
        memory_base_address_size : integer
    );
    Port (
        clk : in std_logic;
        circular_shift_enable : in std_logic;
        load_new_values_enable : in std_logic;
        increment_previous_address : in std_logic;
        rotation_size : in std_logic_vector(1 downto 0);
        enable_new_address : in std_logic;
        load_new_address : in std_logic_vector((memory_base_address_size - 1) downto 0);
        current_address_enable : out std_logic;
        current_address : out std_logic_vector((memory_base_address_size - 1) downto 0)
    );
end component;

begin

mac_address_a((memory_address_size - 1) downto 2) <= base_address_generator_o_current_address when (sel_address_a = '1') else 
                                                         base_address_generator_a_current_address;
mac_address_a(1 downto 0) <= sm_specific_mac_address_a;
mac_address_b((memory_address_size - 1) downto 2) <= base_address_prime when (sel_address_b_prime = "10") else 
                                                         base_address_prime_line when (sel_address_b_prime = "11") else 
                                                         base_address_generator_b_current_address;
mac_address_b(1 downto 0) <= sm_specific_mac_address_b;
mac_address_o((memory_address_size - 1) downto 2) <= base_address_generator_o_current_address;
mac_address_o(1 downto 0) <= sm_specific_mac_address_o;
mac_next_address_o((memory_address_size - 1) downto 2) <= base_address_generator_o_current_address;
mac_next_address_o(1 downto 0) <= sm_specific_mac_next_address_o;

mac_operation_mode(1) <= sm_mac_operation_mode(1);
mac_operation_mode(0) <= sign_a_values(0) when (sm_sign_a_mode = '1') else sm_mac_operation_mode(0);
mac_write_enable_output <= base_address_generator_o_current_address_enable and sm_mac_write_enable_output;

big_mac : entity work.carmela_v256(simple_rectangular_multipliers)
    Generic Map(
        base_wide_adder_size => base_wide_adder_size,
        base_word_size => base_word_size,
        multiplication_factor => multiplication_factor,
        accumulator_extra_bits => accumulator_extra_bits,
        memory_address_size => memory_address_size
    )
    Port Map(
        rstn => rstn,
        clk => clk,
        address_a => mac_address_a,
        address_b => mac_address_b,
        address_o => mac_address_o,
        next_address_o => mac_next_address_o,
        memory_double_mode => mac_memory_double_mode,
        memory_only_write_mode => mac_memory_only_write_mode,
        enable_signed_a => mac_enable_signed_a,
        enable_signed_b => mac_enable_signed_b,
        sel_load_reg_a => mac_sel_load_reg_a,
        clear_reg_b => mac_clear_reg_b,
        clear_reg_acc => mac_clear_reg_acc,
        sel_shift_reg_o => mac_sel_shift_reg_o,
        enable_update_reg_s => mac_enable_update_reg_s,
        sel_reg_s_reg_o_sign => mac_sel_reg_s_reg_o_sign,
        reg_s_reg_o_positive => mac_reg_s_reg_o_positive,
        operation_mode => mac_operation_mode,
        enable_reg_s_mask => mac_enable_reg_s_mask,
        subtraction_reg_a_b => mac_subtraction_reg_a_b,
        sel_multiply_two_a_b => mac_sel_multiply_two_a_b,
        sel_reg_y_output => mac_sel_reg_y_output,
        write_enable_output => mac_write_enable_output,
        data_in_mem_one_a => data_in_mem_one_a,
        data_in_mem_one_b => data_in_mem_one_b,
        data_in_mem_two_a => data_in_mem_two_a,
        data_in_mem_two_b => data_in_mem_two_b,
        write_enable_mem_one_a => write_enable_mem_one_a,
        write_enable_mem_one_b => write_enable_mem_one_b,
        write_enable_mem_two_a => write_enable_mem_two_a,
        write_enable_mem_two_b => write_enable_mem_two_b,
        mem_one_address_a => mem_one_address_a,
        mem_one_address_b => mem_one_address_b,
        mem_two_address_a => mem_two_address_a,
        mem_two_address_b => mem_two_address_b,
        data_out_mem_one_a => data_out_mem_one_a,
        data_out_mem_one_b => data_out_mem_one_b,
        data_out_mem_two_a => data_out_mem_two_a,
        data_out_mem_two_b => data_out_mem_two_b
    );

controller : entity work.carmela_state_machine_v256(compact_memory_based_v2)
    Port Map(
        clk => clk,
        rstn => rstn,
        instruction_values_valid => instruction_values_valid,
        instruction_type => instruction_type,
        operands_size => operands_size,
        prime_line_equal_one => prime_line_equal_one,
        penultimate_operation => penultimate_operation,
        sm_rotation_size => sm_rotation_size,
        sm_circular_shift_enable => sm_circular_shift_enable,
        sel_address_a => sel_address_a,
        sel_address_b_prime => sel_address_b_prime,
        sm_specific_mac_address_a => sm_specific_mac_address_a,
        sm_specific_mac_address_b => sm_specific_mac_address_b,
        sm_specific_mac_address_o => sm_specific_mac_address_o,
        sm_specific_mac_next_address_o => sm_specific_mac_next_address_o,
        mac_enable_signed_a => mac_enable_signed_a,
        mac_enable_signed_b => mac_enable_signed_b,
        mac_sel_load_reg_a => mac_sel_load_reg_a,
        mac_clear_reg_b => mac_clear_reg_b,
        mac_clear_reg_acc => mac_clear_reg_acc,
        mac_sel_shift_reg_o => mac_sel_shift_reg_o,
        mac_enable_update_reg_s => mac_enable_update_reg_s,
        mac_sel_reg_s_reg_o_sign => mac_sel_reg_s_reg_o_sign,
        mac_reg_s_reg_o_positive => mac_reg_s_reg_o_positive,
        sm_sign_a_mode => sm_sign_a_mode,
        sm_mac_operation_mode => sm_mac_operation_mode,
        mac_enable_reg_s_mask => mac_enable_reg_s_mask,
        mac_subtraction_reg_a_b => mac_subtraction_reg_a_b,
        mac_sel_multiply_two_a_b => mac_sel_multiply_two_a_b,
        mac_sel_reg_y_output => mac_sel_reg_y_output,
        sm_mac_write_enable_output => sm_mac_write_enable_output,
        mac_memory_double_mode => mac_memory_double_mode,
        mac_memory_only_write_mode => mac_memory_only_write_mode,
        base_address_generator_o_increment_previous_address => base_address_generator_o_increment_previous_address,
        sm_free_flag => sm_free_flag
    );
    
base_address_generator_a_load_new_values_enable <= loading_values_mode or instruction_values_valid;
base_address_generator_a_rotation_size <= sm_rotation_size;
base_address_generator_a_circular_shift_enable <= sm_circular_shift_enable;

base_address_generator_a : base_address_circular_shift_input_v2
    Generic Map(
        memory_base_address_size => memory_address_size - max_operands_size
    )
    Port Map(
        clk => clk,
        circular_shift_enable => base_address_generator_a_circular_shift_enable,
        load_new_values_enable => base_address_generator_a_load_new_values_enable,
        rotation_size => base_address_generator_a_rotation_size,
        load_new_address => load_new_address_input_ma,
        current_address => base_address_generator_a_current_address
    );

base_address_generator_b_load_new_values_enable <= loading_values_mode or instruction_values_valid;
base_address_generator_b_rotation_size <= sm_rotation_size;
base_address_generator_b_circular_shift_enable <= sm_circular_shift_enable;

base_address_generator_b : base_address_circular_shift_input_v2
    Generic Map(
        memory_base_address_size => memory_address_size - max_operands_size
    )
    Port Map(
        clk => clk,
        circular_shift_enable => base_address_generator_b_circular_shift_enable,
        load_new_values_enable => base_address_generator_b_load_new_values_enable,
        rotation_size => base_address_generator_b_rotation_size,
        load_new_address => load_new_address_input_mb,
        current_address => base_address_generator_b_current_address
    );

base_address_generator_o_load_new_values_enable <= loading_values_mode or instruction_values_valid;
base_address_generator_o_rotation_size <= sm_rotation_size;
base_address_generator_o_circular_shift_enable <= sm_circular_shift_enable;

base_address_generator_o : base_address_circular_shift_output_v2
    Generic Map(
        memory_base_address_size => memory_address_size - max_operands_size
    )
    Port Map(
        clk => clk,
        circular_shift_enable => base_address_generator_o_circular_shift_enable,
        load_new_values_enable => base_address_generator_o_load_new_values_enable,
        increment_previous_address => base_address_generator_o_increment_previous_address,
        rotation_size => base_address_generator_o_rotation_size,
        enable_new_address => enable_new_address_output_mo,
        load_new_address => load_new_address_output_mo,
        current_address_enable => base_address_generator_o_current_address_enable,
        current_address => base_address_generator_o_current_address
    );

base_address_registers : process(clk)
begin
    if(rising_edge(clk)) then
        if(instruction_values_valid = '1') then
            base_address_prime_line <= load_new_address_prime_line;
            if(prime_line_equal_one = '1') then
                base_address_prime <= load_new_address_prime_plus_one;
            else
                base_address_prime <= load_new_address_prime;
            end if;
        end if;
    end if;
end process;
    
process(clk)
begin
    if(rising_edge(clk)) then
        if(instruction_values_valid = '1') then
            control_operation_number(0) <= '1';
            control_operation_number(7 downto 1) <= (others => '0');
            sign_a_values(0) <= load_new_sign_ma;
        elsif(sm_circular_shift_enable = '1') then
            if(loading_values_mode = '1') then
                sign_a_values(0) <= load_new_sign_ma;
            else
                sign_a_values(0) <= sign_a_values(1);
            end if;
            control_operation_number(0) <= control_operation_number(1);
            control_operation_number(1) <= control_operation_number(2);
            sign_a_values(1) <= sign_a_values(2);
            control_operation_number(2) <= control_operation_number(3);
            sign_a_values(2) <= sign_a_values(3);
            if(sm_rotation_size(0) = '0') then
                control_operation_number(3) <= control_operation_number(0);
                sign_a_values(3) <= sign_a_values(0);
            else
                control_operation_number(3) <= control_operation_number(4);
                sign_a_values(3) <= sign_a_values(4);
            end if;
            control_operation_number(4) <= control_operation_number(5);
            sign_a_values(4) <= sign_a_values(5);
            control_operation_number(5) <= control_operation_number(6);
            sign_a_values(5) <= sign_a_values(6);
            control_operation_number(6) <= control_operation_number(7);
            sign_a_values(6) <= sign_a_values(7);
            control_operation_number(7) <= control_operation_number(0);
            sign_a_values(7) <= sign_a_values(0);
        end if;
    end if;
end process;


process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            loading_values_mode <= '0';
        elsif(instruction_values_valid = '1') then
            loading_values_mode <= '1';
        elsif(control_operation_number(2) = '1') then
            loading_values_mode <= '0';
        end if;
    end if;
end process;

penultimate_operation <= control_operation_number(2);

free_flag <= sm_free_flag;

end behavioral;