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

entity sike_core_v128 is
    Generic(
        mac_base_wide_adder_size : integer := 2;
        mac_base_word_size : integer := 16;
        mac_accumulator_extra_bits : integer := 32;
        mac_memory_address_size : integer := 11;
        mac_multiplication_factor : integer := 8;
        mac_multiplication_factor_log2 : integer := 3;
        mac_max_operands_size : integer := 3;
        prom_memory_size : integer := 11;
        prom_instruction_size : integer := 64;
        base_alu_ram_memory_size : integer := 10;
        base_alu_rotation_level : integer := 4;
        rd_ram_memory_size : integer := 5
    );
    Port(
        rstn : in std_logic;
        clk : in std_logic;
        enable : in std_logic;
        data_in : in std_logic_vector((mac_base_word_size - 1) downto 0);
        data_in_valid : in std_logic;
        address_data_in_out : in std_logic_vector((mac_base_word_size - 1) downto 0);
        prom_address_region : in std_logic;
        write_enable : in std_logic;
        data_out : out std_logic_vector((mac_base_word_size - 1) downto 0);
        data_out_valid : out std_logic;
        core_free : out std_logic;
        flag : out std_logic
    );
end sike_core_v128;

architecture behavioral of sike_core_v128 is

component carmela_with_control_unit_v128
    Generic(
        base_wide_adder_size : integer := 2;
        base_word_size : integer := 16;
        multiplication_factor : integer := 8;
        accumulator_extra_bits : integer := 32;
        memory_address_size : integer := 10;
        max_operands_size : integer := 3
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
end component;

component program_instructions_v3
    Generic(
        memory_size : integer;
        small_bus_value_size : integer
    );
    Port(
        clk : in std_logic;
        small_bus_mode : in std_logic;
        small_bus_enable : in std_logic;
        full_bus_enable : in std_logic;
        load_instruction_small_bus_mode : in std_logic_vector((small_bus_value_size - 1) downto 0);
        address_instruction_full_bus_mode : in std_logic_vector((memory_size - 1) downto 0);
        address_data_in_instruction_small_bus_mode : in std_logic_vector((memory_size + 1) downto 0);
        address_data_out_instruction_small_bus_mode : in std_logic_vector((memory_size + 1) downto 0);
        load_mode_enable : in std_logic;
        current_instruction_full_bus_mode : out std_logic_vector((4*small_bus_value_size - 1) downto 0);
        current_instruction_small_bus_mode : out std_logic_vector((small_bus_value_size - 1) downto 0)
    );
end component;

component synth_mac_ram_v4
    Generic (
        small_bus_ram_address_size : integer;
        full_bus_address_factor_size : integer;
        small_bus_ram_word_size : integer;
        multiplication_factor : integer
    );
    Port (
        clk : in std_logic;
        small_bus_mode : in std_logic;
        small_bus_enable : in std_logic;
        full_bus_enable : in std_logic;
        data_in_one_a_full_bus_mode : in std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_in_one_b_full_bus_mode : in std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_in_two_a_full_bus_mode : in std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_in_two_b_full_bus_mode : in std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        enable_write_one_a_full_bus_mode : in std_logic;
        enable_write_one_b_full_bus_mode : in std_logic;
        enable_write_two_a_full_bus_mode : in std_logic;
        enable_write_two_b_full_bus_mode : in std_logic;
        address_data_one_a_full_bus_mode : in std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);
        address_data_one_b_full_bus_mode : in std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);
        address_data_two_a_full_bus_mode : in std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);
        address_data_two_b_full_bus_mode : in std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);
        data_out_one_a_full_bus_mode : out std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_out_one_b_full_bus_mode : out std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_out_two_a_full_bus_mode : out std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_out_two_b_full_bus_mode : out std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_in_small_bus_mode : in std_logic_vector((small_bus_ram_word_size - 1) downto 0);
        enable_write_small_bus_mode : std_logic;
        address_data_in_small_bus_mode : in std_logic_vector((small_bus_ram_address_size - 1) downto 0);
        address_data_out_small_bus_mode : in std_logic_vector((small_bus_ram_address_size - 1) downto 0);
        data_out_small_bus_mode : out std_logic_vector((small_bus_ram_word_size - 1) downto 0)
    );
end component;

component synth_base_alu_ram_v3
    Generic (
        small_bus_ram_address_size : integer;
        small_bus_ram_word_size : integer
    );
    Port (
        clk : in std_logic;
        enable : in std_logic;
        operation_mode : in std_logic;
        data_in        : in std_logic_vector((small_bus_ram_word_size - 1) downto 0);
        address_in     : in std_logic_vector((small_bus_ram_address_size - 1) downto 0);
        address_out_0  : in std_logic_vector((small_bus_ram_address_size - 1) downto 0);
        address_out_1  : in std_logic_vector((small_bus_ram_address_size - 1) downto 0);
        write_enable   : in std_logic;
        data_out_0     : out std_logic_vector((small_bus_ram_word_size - 1) downto 0);
        data_out_1     : out std_logic_vector((small_bus_ram_word_size - 1) downto 0)
    );
end component;

component synth_rd_ram
    Generic (
        ram_address_size : integer;
        ram_word_size : integer
    );
    Port (
        data_in : in std_logic_vector((ram_word_size - 1) downto 0);
        write_enable : in std_logic;
        clk : in std_logic;
        address_in : in std_logic_vector((ram_address_size - 1) downto 0);
        address_out_0 : in std_logic_vector((ram_address_size - 1) downto 0);
        address_out_1 : in std_logic_vector((ram_address_size - 1) downto 0);
        address_out_2 : in std_logic_vector((ram_address_size - 1) downto 0);
        address_out_3 : in std_logic_vector((ram_address_size - 1) downto 0);
        data_out_0 : out std_logic_vector((ram_word_size - 1) downto 0);
        data_out_1 : out std_logic_vector((ram_word_size - 1) downto 0);
        data_out_2 : out std_logic_vector((ram_word_size - 1) downto 0);
        data_out_3 : out std_logic_vector((ram_word_size - 1) downto 0)
    );
end component;

component base_alu
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
end component;

component sike_core_state_machine_v128
    Port (
        clk : in std_logic;
        rstn : in std_logic;
        reg_next_instruction_processor_target : in std_logic_vector(1 downto 0);
        reg_next_instruction_base_alu_operation_type : in std_logic_vector(5 downto 0);
        reg_current_instruction_processor_target : in std_logic_vector(1 downto 0);
        reg_current_instruction_base_alu_operation_type : in std_logic_vector(5 downto 0);
        mac_free_flag : in std_logic;
        prom_program_counter_start_execution : in std_logic;
        small_bus_address_burst_last_block : in std_logic;
        keccak_ready : in std_logic;
        reg_next_instruction_enable : out std_logic;
        reg_current_instruction_enable : out std_logic;
        enable_new_mac_instruction : out std_logic;
        full_bus_enable : out std_logic;
        full_bus_mac_ram_control : out std_logic_vector(1 downto 0);
        full_bus_mac_ram_address_mode_a : out std_logic_vector(1 downto 0);
        full_bus_mac_ram_address_mode_b : out std_logic_vector(1 downto 0);
        mac_ram_stack_mode : out std_logic;
        mac_ram_address_incremented_enable : out std_logic;
        mac_ram_address_incremented_decreasing_mode : out std_logic;
        mac_ram_address_incremented_load : out std_logic;
        sidh_control_enable_write_one_a_full_bus_mode : out std_logic;
        sidh_control_reg_bank_direct_write_enable : out std_logic;
        sidh_control_small_bus_enable : out std_logic;
        sidh_control_small_bus_write_enable : out std_logic;
        sidh_control_small_bus_buffer_enable : out std_logic;
        sidh_control_small_bus_stack_mode_enable : out std_logic;
        sidh_control_small_bus_burst_mode : out std_logic;
        sidh_control_small_bus_address_data_in_burst_ctr_enable : out std_logic;
        sidh_control_small_bus_address_data_out_burst_ctr_enable : out std_logic;
        sidh_control_small_bus_address_burst_ctr_load : out std_logic;
        stack_rstn : out std_logic;
        stack_operation_valid : out std_logic;
        stack_push_mode : out std_logic;
        sidh_control_base_alu_ram_operation_mode : out std_logic;
        sidh_control_base_alu_ram_alu_mode : out std_logic;
        sidh_control_base_alu_ram_write_enable : out std_logic;
        prom_program_counter_enable_increase : out std_logic;
        prom_program_counter_enable_jump : out std_logic;
        prom_program_counter_return_function : out std_logic;
        check_base_alu_o_equal_zero : out std_logic;
        check_base_alu_o_change_sign_b : out std_logic;
        enable_base_alu_input_registers : out std_logic;
        reg_constant_full_bus_base : out std_logic;
        keccak_init : out std_logic;
        keccak_go : out std_logic;
        reg_status : out std_logic
    );
end component;

component keccak_small_bus
generic(
    small_bus_word_size : integer := 16;
    small_bus_address_size : integer := 3
);
  port (
    clk     : in  std_logic;
    rstn    : in  std_logic;
    init    : in  std_logic;
    go      : in  std_logic;
    ready   : out  std_logic;
    small_bus_enable : in std_logic;
    small_bus_data_in : in std_logic_vector((small_bus_word_size - 1) downto 0);
    small_bus_write_enable : in std_logic;
    small_bus_address_data_in : in std_logic_vector((small_bus_address_size - 1) downto 0);
    small_bus_address_data_out : in std_logic_vector((small_bus_address_size - 1) downto 0);
    small_bus_data_out : out std_logic_vector((small_bus_word_size - 1) downto 0)
);
end component;

signal mac_instruction_values_valid : std_logic;
signal mac_instruction_type : std_logic_vector(3 downto 0);
signal mac_operands_size : std_logic_vector((mac_max_operands_size - 1) downto 0);
signal mac_prime_line_equal_one : std_logic;
signal mac_load_new_address_prime : std_logic_vector((mac_memory_address_size - mac_max_operands_size - 1) downto 0);
signal mac_load_new_address_prime_line : std_logic_vector((mac_memory_address_size - mac_max_operands_size - 1) downto 0);
signal mac_load_new_address_prime_plus_one : std_logic_vector((mac_memory_address_size - mac_max_operands_size - 1) downto 0);
signal mac_load_new_address_input_ma : std_logic_vector((mac_memory_address_size - mac_max_operands_size - 1) downto 0);
signal mac_load_new_sign_ma : std_logic;
signal mac_load_new_address_input_mb : std_logic_vector((mac_memory_address_size - mac_max_operands_size - 1) downto 0);
signal mac_load_new_address_output_mo : std_logic_vector((mac_memory_address_size - mac_max_operands_size - 1) downto 0);
signal mac_enable_new_address_output_mo : std_logic;
signal mac_data_in_mem_one_a : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_data_in_mem_one_b : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_data_in_mem_two_a : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_data_in_mem_two_b : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_write_enable_mem_one_a : std_logic;
signal mac_write_enable_mem_one_b : std_logic;
signal mac_write_enable_mem_two_a : std_logic;
signal mac_write_enable_mem_two_b : std_logic;
signal mac_mem_one_address_a : std_logic_vector((mac_memory_address_size - 1) downto 0);
signal mac_mem_one_address_b : std_logic_vector((mac_memory_address_size - 1) downto 0);
signal mac_mem_two_address_a : std_logic_vector((mac_memory_address_size - 1) downto 0);
signal mac_mem_two_address_b : std_logic_vector((mac_memory_address_size - 1) downto 0);
signal mac_data_out_mem_one_a : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_data_out_mem_one_b : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_data_out_mem_two_a : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_data_out_mem_two_b : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_free_flag : std_logic;

signal prom_small_bus_enable : std_logic;
signal prom_full_bus_enable : std_logic;
signal prom_small_bus_mode : std_logic;
signal prom_load_instruction_small_bus_mode : std_logic_vector((mac_base_word_size - 1) downto 0);
signal prom_address_instruction_full_bus_mode : std_logic_vector((prom_memory_size - 1) downto 0);
signal prom_address_data_in_instruction_small_bus_mode : std_logic_vector((prom_memory_size + 1) downto 0);
signal prom_address_data_out_instruction_small_bus_mode : std_logic_vector((prom_memory_size + 1) downto 0);
signal prom_load_mode_enable : std_logic;
signal prom_current_instruction_full_bus_mode : std_logic_vector((4*mac_base_word_size - 1) downto 0);
signal prom_current_instruction_small_bus_mode : std_logic_vector((mac_base_word_size - 1) downto 0);

signal small_bus_enable : std_logic;
signal small_bus_address_data_in : std_logic_vector((mac_base_word_size - 1) downto 0);
signal small_bus_address_data_out : std_logic_vector((mac_base_word_size - 1) downto 0);
signal small_bus_data_in : std_logic_vector((mac_base_word_size - 1) downto 0);
signal small_bus_data_out : std_logic_vector((mac_base_word_size - 1) downto 0);
signal small_bus_write_enable : std_logic;

signal small_bus_address_data_in_decoded : std_logic_vector(3 downto 0);
signal small_bus_address_data_out_decoded : std_logic_vector(3 downto 0);

signal sidh_control_small_bus_enable : std_logic;
signal sidh_control_small_bus_write_enable : std_logic;
signal sidh_control_small_bus_address_data_in : std_logic_vector((mac_base_word_size - 1) downto 0);
signal sidh_control_small_bus_address_data_out : std_logic_vector((mac_base_word_size - 1) downto 0);
signal sidh_control_small_bus_buffer_enable : std_logic;
signal sidh_control_small_bus_buffer : std_logic_vector((mac_base_word_size - 1) downto 0);
signal sidh_control_small_bus_stack_mode_enable : std_logic;
signal sidh_control_small_bus_burst_mode : std_logic;
signal sidh_control_small_bus_address_data_in_burst_ctr_enable : std_logic;
signal sidh_control_small_bus_address_data_out_burst_ctr_enable : std_logic;
signal sidh_control_small_bus_address_burst_ctr_load : std_logic;

signal small_bus_address_data_in_burst_ctr : unsigned((mac_base_word_size - 1) downto 0);
signal small_bus_address_data_out_burst_ctr : unsigned((mac_base_word_size - 1) downto 0);
signal small_bus_address_burst_size_ctr : unsigned((mac_base_word_size - 1) downto 0);
signal small_bus_address_burst_last_block : std_logic;

signal mac_ram_small_bus_enable : std_logic;
signal mac_ram_full_bus_enable : std_logic;
signal mac_ram_small_bus_mode : std_logic;
signal mac_ram_data_in_one_a_full_bus_mode : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_ram_data_in_one_b_full_bus_mode : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_ram_data_in_two_a_full_bus_mode : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_ram_data_in_two_b_full_bus_mode : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_ram_enable_write_one_a_full_bus_mode : std_logic;
signal mac_ram_enable_write_one_b_full_bus_mode : std_logic;
signal mac_ram_enable_write_two_a_full_bus_mode : std_logic;
signal mac_ram_enable_write_two_b_full_bus_mode : std_logic;
signal mac_ram_address_data_one_a_full_bus_mode : std_logic_vector((mac_memory_address_size - 1) downto 0);
signal mac_ram_address_data_one_b_full_bus_mode : std_logic_vector((mac_memory_address_size - 1) downto 0);
signal mac_ram_address_data_two_a_full_bus_mode : std_logic_vector((mac_memory_address_size - 1) downto 0);
signal mac_ram_address_data_two_b_full_bus_mode : std_logic_vector((mac_memory_address_size - 1) downto 0);
signal mac_ram_data_out_one_a_full_bus_mode : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_ram_data_out_one_b_full_bus_mode : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_ram_data_out_two_a_full_bus_mode : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_ram_data_out_two_b_full_bus_mode : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal mac_ram_data_in_small_bus_mode : std_logic_vector((mac_base_word_size - 1) downto 0);
signal mac_ram_enable_write_small_bus_mode : std_logic;
signal mac_ram_address_data_in_small_bus_mode : std_logic_vector((mac_memory_address_size + mac_multiplication_factor_log2 - 1) downto 0);
signal mac_ram_address_data_out_small_bus_mode : std_logic_vector((mac_memory_address_size + mac_multiplication_factor_log2 - 1) downto 0);
signal mac_ram_data_out_small_bus_mode : std_logic_vector((mac_base_word_size - 1) downto 0);

signal mac_ram_stack_mode : std_logic;
signal mac_ram_address_incremented_enable : std_logic;
signal mac_ram_address_incremented_decreasing_mode : std_logic;
signal mac_ram_address_incremented_load : std_logic;

signal mac_ram_address_a_incremented : std_logic_vector((mac_memory_address_size - 1) downto 0);
signal mac_ram_address_o_incremented : std_logic_vector((mac_memory_address_size - 1) downto 0);

signal stack_rstn : std_logic;
signal stack_operation_valid : std_logic;
signal stack_push_mode : std_logic;

signal stack_counter_write : std_logic_vector((mac_memory_address_size - 1) downto 0);
signal stack_counter_read : std_logic_vector((mac_memory_address_size - 1) downto 0);

signal base_alu_ram_enable : std_logic;
signal base_alu_ram_operation_mode : std_logic;
signal base_alu_ram_data_in : std_logic_vector((mac_base_word_size - 1) downto 0);
signal base_alu_ram_address_in : std_logic_vector((base_alu_ram_memory_size - 1) downto 0);
signal base_alu_ram_address_out_0  : std_logic_vector((base_alu_ram_memory_size - 1) downto 0);
signal base_alu_ram_address_out_1  : std_logic_vector((base_alu_ram_memory_size - 1) downto 0);
signal base_alu_ram_write_enable  : std_logic;
signal base_alu_ram_data_out_0  : std_logic_vector((mac_base_word_size - 1) downto 0);
signal base_alu_ram_data_out_1  : std_logic_vector((mac_base_word_size - 1) downto 0);

signal sidh_control_base_alu_ram_operation_mode : std_logic;
signal sidh_control_base_alu_ram_alu_mode : std_logic;
signal sidh_control_base_alu_ram_write_enable : std_logic;

signal rd_ram_data_in : std_logic_vector((mac_base_word_size - 1) downto 0);
signal rd_ram_write_enable : std_logic;
signal rd_ram_address_in : std_logic_vector((rd_ram_memory_size - 1) downto 0);
signal rd_ram_address_out_0 : std_logic_vector((rd_ram_memory_size - 1) downto 0);
signal rd_ram_address_out_1 : std_logic_vector((rd_ram_memory_size - 1) downto 0);
signal rd_ram_address_out_2 : std_logic_vector((rd_ram_memory_size - 1) downto 0);
signal rd_ram_address_out_3 : std_logic_vector((rd_ram_memory_size - 1) downto 0);
signal rd_ram_data_out_0 : std_logic_vector((mac_base_word_size - 1) downto 0);
signal rd_ram_data_out_1 : std_logic_vector((mac_base_word_size - 1) downto 0);
signal rd_ram_data_out_2 : std_logic_vector((mac_base_word_size - 1) downto 0);
signal rd_ram_data_out_3 : std_logic_vector((mac_base_word_size - 1) downto 0);

signal enable_base_alu_input_registers : std_logic;

signal base_alu_a : std_logic_vector((mac_base_word_size - 1) downto 0);
signal base_alu_b : std_logic_vector((mac_base_word_size - 1) downto 0);
signal base_alu_operation_type : std_logic_vector(1 downto 0);
signal base_alu_rotation_size : std_logic_vector((base_alu_rotation_level - 1) downto 0);
signal base_alu_left_rotation : std_logic;
signal base_alu_shift_mode : std_logic;
signal base_alu_math_operation : std_logic_vector(1 downto 0);
signal base_alu_a_signed : std_logic;
signal base_alu_b_signed : std_logic;
signal base_alu_logic_operation : std_logic_vector(1 downto 0);
signal base_alu_o : std_logic_vector((2*mac_base_word_size - 1) downto 0);
signal base_alu_o_equal_zero : std_logic;
signal base_alu_o_change_sign_b : std_logic;

signal reg_base_alu_o : std_logic_vector((2*mac_base_word_size - 1) downto 0);
signal reg_base_alu_o_equal_zero : std_logic;
signal reg_base_alu_o_change_sign_b : std_logic;

signal keccak_init : std_logic;
signal keccak_go : std_logic;
signal keccak_ready : std_logic;
signal keccak_small_bus_enable : std_logic;
signal keccak_small_bus_data_in : std_logic_vector((mac_base_word_size - 1) downto 0);
signal keccak_small_bus_write_enable : std_logic;
signal keccak_small_bus_address_data_in : std_logic_vector(10 downto 0);
signal keccak_small_bus_address_data_out : std_logic_vector(10 downto 0);
signal keccak_small_bus_data_out : std_logic_vector((mac_base_word_size - 1) downto 0);

signal prom_program_counter_enable_increase : std_logic;
signal prom_program_counter_enable_jump : std_logic;
signal prom_program_counter_return_function : std_logic;
signal prom_program_counter : std_logic_vector((prom_memory_size - 1) downto 0);

signal reg_next_instruction_program_counter : std_logic_vector((prom_memory_size - 1) downto 0);
signal reg_current_instruction_program_counter : std_logic_vector((prom_memory_size - 1) downto 0);

signal check_base_alu_o_equal_zero : std_logic;
signal check_base_alu_o_change_sign_b : std_logic;

signal prom_program_counter_start_execution : std_logic;

signal reg_next_instruction : std_logic_vector((prom_instruction_size - 1) downto 0);
signal reg_next_instruction_enable : std_logic;
signal reg_next_instruction_processor_target : std_logic_vector(1 downto 0);
signal reg_next_instruction_base_alu_operation_type : std_logic_vector(5 downto 0);
signal reg_next_instruction_address_a : std_logic_vector(15 downto 0);
signal reg_next_instruction_address_b : std_logic_vector(15 downto 0);
signal reg_next_instruction_address_o : std_logic_vector(15 downto 0);
signal reg_next_instruction_address_solved : std_logic_vector((prom_instruction_size - 1) downto 0);

signal reg_current_instruction_enable : std_logic;
signal reg_current_instruction : std_logic_vector((prom_instruction_size - 1) downto 0);
signal reg_current_instruction_processor_target : std_logic_vector(1 downto 0);
signal reg_current_instruction_base_alu_operation_type : std_logic_vector(5 downto 0);

signal reg_current_instruction_address_a : std_logic_vector(15 downto 0);
signal reg_current_instruction_constant_a : std_logic;
signal reg_current_instruction_direction_a : std_logic;
signal reg_current_instruction_sign_a : std_logic;
signal reg_current_instruction_address_a_solved : std_logic_vector(15 downto 0);
signal reg_current_instruction_value_a_solved : std_logic_vector(15 downto 0);
signal reg_current_instruction_address_b : std_logic_vector(15 downto 0);
signal reg_current_instruction_constant_b : std_logic;
signal reg_current_instruction_direction_b : std_logic;
signal reg_current_instruction_sign_b : std_logic;
signal reg_current_instruction_address_b_solved : std_logic_vector(15 downto 0);
signal reg_current_instruction_value_b_solved : std_logic_vector(15 downto 0);
signal reg_current_instruction_address_o : std_logic_vector(15 downto 0);
signal reg_current_instruction_direction_o : std_logic;
signal reg_current_instruction_address_o_solved : std_logic_vector(15 downto 0);
signal reg_current_instruction_value_o_solved : std_logic_vector(15 downto 0);

signal reg_constant_full_bus : std_logic_vector((mac_multiplication_factor*mac_base_word_size - 1) downto 0);
signal reg_constant_full_bus_base : std_logic;

signal enable_new_mac_instruction : std_logic;
signal full_bus_enable : std_logic;
signal full_bus_mac_ram_control : std_logic_vector(1 downto 0);
signal full_bus_mac_ram_address_mode_a : std_logic_vector(1 downto 0);
signal full_bus_mac_ram_address_mode_b : std_logic_vector(1 downto 0);
signal sidh_control_enable_write_one_a_full_bus_mode : std_logic;

signal reg_status : std_logic;
signal reg_operands_size : std_logic_vector((mac_max_operands_size - 1) downto 0);
signal reg_prime_line_equal_one : std_logic;
signal reg_prime_address : std_logic_vector((mac_memory_address_size - mac_max_operands_size - 1) downto 0);
signal reg_prime_plus_one_address : std_logic_vector((mac_memory_address_size - mac_max_operands_size - 1) downto 0);
signal reg_prime_line_address : std_logic_vector((mac_memory_address_size - mac_max_operands_size - 1) downto 0);
signal reg_initial_stack_address : std_logic_vector((mac_memory_address_size - 1) downto 0);
signal reg_flag : std_logic;
signal reg_scalar_address : std_logic_vector((rd_ram_memory_size - 1) downto 0);

constant mac_ram_start_address : unsigned((mac_base_word_size - 1) downto 0)                := to_unsigned(16#00000#, mac_base_word_size);
constant mac_ram_last_address : unsigned((mac_base_word_size - 1) downto 0)                 := to_unsigned(16#07FFF#, mac_base_word_size);
constant base_alu_ram_start_address : unsigned((mac_base_word_size - 1) downto 0)           := to_unsigned(16#0C000#, mac_base_word_size);
constant base_alu_ram_last_address : unsigned((mac_base_word_size - 1) downto 0)            := to_unsigned(16#0C3FF#, mac_base_word_size);
constant keccak_start_address : unsigned((mac_base_word_size - 1) downto 0)                 := to_unsigned(16#0D000#, mac_base_word_size);
constant keccak_last_address : unsigned((mac_base_word_size - 1) downto 0)                  := to_unsigned(16#0D7FF#, mac_base_word_size);
constant reg_program_counter_address : unsigned((mac_base_word_size - 1) downto 0)          := to_unsigned(16#0E000#, mac_base_word_size);
constant reg_status_address : unsigned((mac_base_word_size - 1) downto 0)                   := to_unsigned(16#0E001#, mac_base_word_size);
constant reg_operands_size_address : unsigned((mac_base_word_size - 1) downto 0)            := to_unsigned(16#0E002#, mac_base_word_size);
constant reg_prime_line_equal_one_address : unsigned((mac_base_word_size - 1) downto 0)     := to_unsigned(16#0E003#, mac_base_word_size);
constant reg_prime_address_address : unsigned((mac_base_word_size - 1) downto 0)            := to_unsigned(16#0E004#, mac_base_word_size);
constant reg_prime_plus_one_address_address : unsigned((mac_base_word_size - 1) downto 0)   := to_unsigned(16#0E005#, mac_base_word_size);
constant reg_prime_line_address_address : unsigned((mac_base_word_size - 1) downto 0)       := to_unsigned(16#0E006#, mac_base_word_size);
constant reg_initial_stack_address_address : unsigned((mac_base_word_size - 1) downto 0)    := to_unsigned(16#0E007#, mac_base_word_size);
constant reg_flag_address : unsigned((mac_base_word_size - 1) downto 0)                     := to_unsigned(16#0E008#, mac_base_word_size);
constant reg_scalar_address_address : unsigned((mac_base_word_size - 1) downto 0)           := to_unsigned(16#0E009#, mac_base_word_size);

constant base_unit_nop_operation : std_logic_vector(5 downto 0)          := "000000";
constant base_unit_jumpeq_operation : std_logic_vector(5 downto 0)       := "000001";
constant base_unit_jumpl_operation : std_logic_vector(5 downto 0)        := "000010";
constant base_unit_jumpeql_operation : std_logic_vector(5 downto 0)      := "000011";
constant base_unit_push_operation : std_logic_vector(5 downto 0)         := "000100";
constant base_unit_pop_operation : std_logic_vector(5 downto 0)          := "000101";
constant base_unit_pushf_operation : std_logic_vector(5 downto 0)        := "000110";
constant base_unit_popf_operation : std_logic_vector(5 downto 0)         := "000111";
constant base_unit_pushm_operation : std_logic_vector(5 downto 0)        := "001000";
constant base_unit_popm_operation : std_logic_vector(5 downto 0)         := "001001";
constant base_unit_copy_operation : std_logic_vector(5 downto 0)         := "001010";
constant base_unit_copyf_operation : std_logic_vector(5 downto 0)        := "001011";
constant base_unit_copym_operation : std_logic_vector(5 downto 0)        := "001100";
constant base_unit_lconstf_operation : std_logic_vector(5 downto 0)      := "001101";
constant base_unit_lconstm_operation : std_logic_vector(5 downto 0)      := "001110";
constant base_unit_call_operation : std_logic_vector(5 downto 0)         := "001111";
constant base_unit_ret_operation : std_logic_vector(5 downto 0)          := "010000";
constant base_unit_keccak_init_operation : std_logic_vector(5 downto 0)  := "010010";
constant base_unit_keccak_go_operation : std_logic_vector(5 downto 0)    := "010011";
constant base_unit_copya_inc_ds_operation : std_logic_vector(5 downto 0) := "011000";
constant base_unit_copya_inc_d_operation : std_logic_vector(5 downto 0)  := "011001";
constant base_unit_copya_inc_s_operation : std_logic_vector(5 downto 0)  := "011010";
constant base_unit_copya_inc_operation : std_logic_vector(5 downto 0)    := "011011";
constant base_unit_copya_dec_ds_operation : std_logic_vector(5 downto 0) := "011100";
constant base_unit_copya_dec_d_operation : std_logic_vector(5 downto 0)  := "011101";
constant base_unit_copya_dec_s_operation : std_logic_vector(5 downto 0)  := "011110";
constant base_unit_copya_dec_operation : std_logic_vector(5 downto 0)    := "011111";
constant base_unit_badd_operation : std_logic_vector(5 downto 0)         := "100000";
constant base_unit_bsub_operation : std_logic_vector(5 downto 0)         := "100001";
constant base_unit_bsmul_operation : std_logic_vector(5 downto 0)        := "100010";
constant base_unit_bshiftr_operation : std_logic_vector(5 downto 0)      := "100100";
constant base_unit_brotr_operation : std_logic_vector(5 downto 0)        := "100101";
constant base_unit_bshiftl_operation : std_logic_vector(5 downto 0)      := "100110";
constant base_unit_brotl_operation : std_logic_vector(5 downto 0)        := "100111";
constant base_unit_bland_operation : std_logic_vector(5 downto 0)        := "101000";
constant base_unit_blor_operation : std_logic_vector(5 downto 0)         := "101001";
constant base_unit_blxor_operation : std_logic_vector(5 downto 0)        := "101010";
constant base_unit_fin_operation : std_logic_vector(5 downto 0)          := "111111";

begin

sike_control : entity work.sike_core_state_machine_v128(direct_mode)
    Port Map(
        clk => clk,
        rstn => rstn,
        reg_next_instruction_processor_target => reg_next_instruction_processor_target,
        reg_next_instruction_base_alu_operation_type => reg_next_instruction_base_alu_operation_type,
        reg_current_instruction_processor_target => reg_current_instruction_processor_target,
        reg_current_instruction_base_alu_operation_type => reg_current_instruction_base_alu_operation_type,
        keccak_ready => keccak_ready,
        mac_free_flag => mac_free_flag,
        prom_program_counter_start_execution => prom_program_counter_start_execution,
        small_bus_address_burst_last_block => small_bus_address_burst_last_block,
        reg_next_instruction_enable => reg_next_instruction_enable,
        reg_current_instruction_enable => reg_current_instruction_enable,
        enable_new_mac_instruction => enable_new_mac_instruction,
        full_bus_enable => full_bus_enable,
        full_bus_mac_ram_control => full_bus_mac_ram_control,
        full_bus_mac_ram_address_mode_a => full_bus_mac_ram_address_mode_a,
        full_bus_mac_ram_address_mode_b => full_bus_mac_ram_address_mode_b,
        mac_ram_stack_mode => mac_ram_stack_mode,
        mac_ram_address_incremented_enable => mac_ram_address_incremented_enable,
        mac_ram_address_incremented_decreasing_mode => mac_ram_address_incremented_decreasing_mode,
        mac_ram_address_incremented_load => mac_ram_address_incremented_load,
        sidh_control_enable_write_one_a_full_bus_mode => sidh_control_enable_write_one_a_full_bus_mode,
        sidh_control_small_bus_enable => sidh_control_small_bus_enable,
        sidh_control_small_bus_write_enable => sidh_control_small_bus_write_enable,
        sidh_control_small_bus_buffer_enable => sidh_control_small_bus_buffer_enable,
        sidh_control_small_bus_stack_mode_enable => sidh_control_small_bus_stack_mode_enable,
        sidh_control_small_bus_burst_mode => sidh_control_small_bus_burst_mode,
        sidh_control_small_bus_address_data_in_burst_ctr_enable => sidh_control_small_bus_address_data_in_burst_ctr_enable,
        sidh_control_small_bus_address_data_out_burst_ctr_enable => sidh_control_small_bus_address_data_out_burst_ctr_enable,
        sidh_control_small_bus_address_burst_ctr_load => sidh_control_small_bus_address_burst_ctr_load,
        stack_rstn => stack_rstn,
        stack_operation_valid => stack_operation_valid,
        stack_push_mode => stack_push_mode,
        sidh_control_base_alu_ram_operation_mode => sidh_control_base_alu_ram_operation_mode,
        sidh_control_base_alu_ram_alu_mode => sidh_control_base_alu_ram_alu_mode,
        sidh_control_base_alu_ram_write_enable => sidh_control_base_alu_ram_write_enable,
        prom_program_counter_enable_increase => prom_program_counter_enable_increase,
        prom_program_counter_enable_jump => prom_program_counter_enable_jump,
        prom_program_counter_return_function => prom_program_counter_return_function,
        enable_base_alu_input_registers => enable_base_alu_input_registers,
        check_base_alu_o_equal_zero => check_base_alu_o_equal_zero,
        check_base_alu_o_change_sign_b => check_base_alu_o_change_sign_b,
        reg_constant_full_bus_base => reg_constant_full_bus_base,
        keccak_init => keccak_init,
        keccak_go => keccak_go,
        reg_status => reg_status
    );

mac_operands_size <= reg_operands_size;
mac_prime_line_equal_one <= reg_prime_line_equal_one;

mac_data_in_mem_one_a <= mac_ram_data_out_one_a_full_bus_mode;
mac_data_in_mem_one_b <= mac_ram_data_out_one_b_full_bus_mode;
mac_data_in_mem_two_a <= mac_ram_data_out_two_a_full_bus_mode;
mac_data_in_mem_two_b <= mac_ram_data_out_two_b_full_bus_mode;

mac : carmela_with_control_unit_v128
    Generic Map(
        base_wide_adder_size => mac_base_wide_adder_size,
        base_word_size => mac_base_word_size,
        accumulator_extra_bits => mac_accumulator_extra_bits,
        multiplication_factor => mac_multiplication_factor,
        memory_address_size => mac_memory_address_size,
        max_operands_size => mac_max_operands_size
    )
    Port Map(
        rstn => rstn,
        clk => clk,
        instruction_values_valid => mac_instruction_values_valid,
        instruction_type => mac_instruction_type,
        operands_size => mac_operands_size,
        prime_line_equal_one => mac_prime_line_equal_one,
        load_new_address_prime => mac_load_new_address_prime,
        load_new_address_prime_line => mac_load_new_address_prime_line,
        load_new_address_prime_plus_one => mac_load_new_address_prime_plus_one,
        load_new_address_input_ma => mac_load_new_address_input_ma,
        load_new_sign_ma => mac_load_new_sign_ma,
        load_new_address_input_mb => mac_load_new_address_input_mb,
        load_new_address_output_mo => mac_load_new_address_output_mo,
        enable_new_address_output_mo => mac_enable_new_address_output_mo,
        data_in_mem_one_a => mac_data_in_mem_one_a,
        data_in_mem_one_b => mac_data_in_mem_one_b,
        data_in_mem_two_a => mac_data_in_mem_two_a,
        data_in_mem_two_b => mac_data_in_mem_two_b,
        write_enable_mem_one_a => mac_write_enable_mem_one_a,
        write_enable_mem_one_b => mac_write_enable_mem_one_b,
        write_enable_mem_two_a => mac_write_enable_mem_two_a,
        write_enable_mem_two_b => mac_write_enable_mem_two_b,
        mem_one_address_a => mac_mem_one_address_a,
        mem_one_address_b => mac_mem_one_address_b,
        mem_two_address_a => mac_mem_two_address_a,
        mem_two_address_b => mac_mem_two_address_b,
        data_out_mem_one_a => mac_data_out_mem_one_a,
        data_out_mem_one_b => mac_data_out_mem_one_b,
        data_out_mem_two_a => mac_data_out_mem_two_a,
        data_out_mem_two_b => mac_data_out_mem_two_b,
        free_flag => mac_free_flag
    );

prom_small_bus_enable <= '1' when (enable = '1') else '0';
prom_full_bus_enable <= '1';
prom_small_bus_mode <= '1' when ((enable = '1') and (reg_status = '1')) else '0';
prom_load_instruction_small_bus_mode <= data_in;
prom_address_instruction_full_bus_mode <= prom_program_counter;
prom_address_data_in_instruction_small_bus_mode <= address_data_in_out((prom_address_data_in_instruction_small_bus_mode'length - 1) downto 0);
prom_address_data_out_instruction_small_bus_mode <= address_data_in_out((prom_address_data_out_instruction_small_bus_mode'length - 1) downto 0);
prom_load_mode_enable <= '1' when ((reg_status = '1') and (write_enable = '1') and (data_in_valid = '1') and (prom_address_region = '1')) else '0';

prom : program_instructions_v3
    Generic Map(
        memory_size => prom_memory_size,
        small_bus_value_size => mac_base_word_size
    )
    Port Map(
        clk => clk,
        small_bus_enable => prom_small_bus_enable,
        full_bus_enable => prom_full_bus_enable,
        small_bus_mode => prom_small_bus_mode,
        load_instruction_small_bus_mode => prom_load_instruction_small_bus_mode,
        address_instruction_full_bus_mode => prom_address_instruction_full_bus_mode,
        address_data_in_instruction_small_bus_mode => prom_address_data_in_instruction_small_bus_mode,
        address_data_out_instruction_small_bus_mode => prom_address_data_out_instruction_small_bus_mode,
        load_mode_enable => prom_load_mode_enable,
        current_instruction_full_bus_mode => prom_current_instruction_full_bus_mode,
        current_instruction_small_bus_mode => prom_current_instruction_small_bus_mode
    );
    
mac_ram_small_bus_enable <= '1' when (small_bus_enable = '1') else '0';
mac_ram_full_bus_enable <= '1' when (full_bus_enable = '1') else '0';
mac_ram_small_bus_mode <= small_bus_enable and (not mac_ram_stack_mode);
mac_ram_data_in_one_a_full_bus_mode((small_bus_data_out'length - 1) downto 0) <= mac_data_out_mem_one_a((small_bus_data_out'length - 1) downto 0) when full_bus_mac_ram_control = "11" else
                                       small_bus_data_out when full_bus_mac_ram_control = "10" else
                                       reg_constant_full_bus((small_bus_data_out'length - 1) downto 0) when full_bus_mac_ram_control = "01" else
                                       mac_ram_data_out_one_b_full_bus_mode((small_bus_data_out'length - 1) downto 0);
mac_ram_data_in_one_a_full_bus_mode((mac_multiplication_factor*mac_base_word_size - 1) downto small_bus_data_out'length) <= mac_data_out_mem_one_a((mac_multiplication_factor*mac_base_word_size - 1) downto small_bus_data_out'length) when full_bus_mac_ram_control = "11" else
                                       (others => '0') when full_bus_mac_ram_control = "10" else
                                       reg_constant_full_bus((mac_multiplication_factor*mac_base_word_size - 1) downto small_bus_data_out'length) when full_bus_mac_ram_control = "01" else
                                       mac_ram_data_out_one_b_full_bus_mode((mac_multiplication_factor*mac_base_word_size - 1) downto small_bus_data_out'length);
mac_ram_data_in_one_b_full_bus_mode <= mac_data_out_mem_one_b;
mac_ram_data_in_two_a_full_bus_mode((small_bus_data_out'length - 1) downto 0) <= mac_data_out_mem_two_a((small_bus_data_out'length - 1) downto 0) when full_bus_mac_ram_control = "11" else
                                       small_bus_data_out when full_bus_mac_ram_control = "10" else
                                       reg_constant_full_bus((small_bus_data_out'length - 1) downto 0) when full_bus_mac_ram_control = "01" else
                                       mac_ram_data_out_one_b_full_bus_mode((small_bus_data_out'length - 1) downto 0);
mac_ram_data_in_two_a_full_bus_mode((mac_multiplication_factor*mac_base_word_size - 1) downto small_bus_data_out'length) <= mac_data_out_mem_two_a((mac_multiplication_factor*mac_base_word_size - 1) downto small_bus_data_out'length) when full_bus_mac_ram_control = "11" else
                                       (others => '0') when full_bus_mac_ram_control = "10" else
                                       reg_constant_full_bus((mac_multiplication_factor*mac_base_word_size - 1) downto small_bus_data_out'length) when full_bus_mac_ram_control = "01" else
                                       mac_ram_data_out_one_b_full_bus_mode((mac_multiplication_factor*mac_base_word_size - 1) downto small_bus_data_out'length);
mac_ram_data_in_two_b_full_bus_mode <= mac_data_out_mem_two_b;
mac_ram_enable_write_one_a_full_bus_mode <= mac_write_enable_mem_one_a when full_bus_mac_ram_control = "11" else
                                            sidh_control_enable_write_one_a_full_bus_mode;
mac_ram_enable_write_one_b_full_bus_mode <= mac_write_enable_mem_one_b when full_bus_mac_ram_control = "11" else
                                            '0';
mac_ram_enable_write_two_a_full_bus_mode <= mac_write_enable_mem_two_a when full_bus_mac_ram_control = "11" else
                                            sidh_control_enable_write_one_a_full_bus_mode;
mac_ram_enable_write_two_b_full_bus_mode <= mac_write_enable_mem_two_b when full_bus_mac_ram_control = "11" else
                                            '0';
mac_ram_address_data_one_a_full_bus_mode <= mac_mem_one_address_a when full_bus_mac_ram_address_mode_a = "11" else
                                            stack_counter_write when full_bus_mac_ram_address_mode_a = "10" else
                                            mac_ram_address_o_incremented when full_bus_mac_ram_address_mode_a = "01" else
                                            reg_current_instruction_address_o((mac_memory_address_size - 1) downto 0);
mac_ram_address_data_one_b_full_bus_mode <= mac_mem_one_address_b when full_bus_mac_ram_address_mode_b = "11" else
                                            stack_counter_read when full_bus_mac_ram_address_mode_b = "10" else
                                            mac_ram_address_a_incremented when full_bus_mac_ram_address_mode_b = "01" else
                                            reg_current_instruction_address_a((mac_memory_address_size - 1) downto 0);
mac_ram_address_data_two_a_full_bus_mode <= mac_mem_two_address_a when full_bus_mac_ram_address_mode_a = "11" else
                                            stack_counter_write when full_bus_mac_ram_address_mode_a = "10" else
                                            mac_ram_address_o_incremented when full_bus_mac_ram_address_mode_a = "01" else
                                            reg_current_instruction_address_o((mac_memory_address_size - 1) downto 0);
mac_ram_address_data_two_b_full_bus_mode <= mac_mem_two_address_b when full_bus_mac_ram_address_mode_b = "11" else
                                            stack_counter_read when full_bus_mac_ram_address_mode_b = "10" else
                                            mac_ram_address_a_incremented when full_bus_mac_ram_address_mode_b = "01" else
                                            reg_current_instruction_address_a((mac_memory_address_size - 1) downto 0);
                                            
mac_ram_data_in_small_bus_mode <= small_bus_data_in;
mac_ram_enable_write_small_bus_mode <= small_bus_write_enable when (small_bus_address_data_in_decoded = "0000") else '0';
mac_ram_address_data_in_small_bus_mode <= small_bus_address_data_in((mac_ram_address_data_in_small_bus_mode'length - 1) downto 0);
mac_ram_address_data_out_small_bus_mode <= small_bus_address_data_out((mac_ram_address_data_out_small_bus_mode'length - 1) downto 0);

mac_ram_address_a_incremented((mac_memory_address_size - 1) downto 3) <= reg_current_instruction_address_a((mac_memory_address_size - 1) downto 3);
mac_ram_address_o_incremented((mac_memory_address_size - 1) downto 3) <= reg_current_instruction_address_o((mac_memory_address_size - 1) downto 3);
process(clk)
begin
    if(rising_edge(clk)) then
        if(mac_ram_address_incremented_enable = '1') then
            if(mac_ram_address_incremented_load = '1') then
                if(mac_ram_address_incremented_decreasing_mode = '1') then
                    mac_ram_address_a_incremented(2 downto 0) <= "111";
                    mac_ram_address_o_incremented(2 downto 0) <= "000";
                else
                    mac_ram_address_a_incremented(2 downto 0) <= "001";
                    mac_ram_address_o_incremented(2 downto 0) <= "000";
                end if;
            else
                if(mac_ram_address_incremented_decreasing_mode = '1') then
                    mac_ram_address_a_incremented(2 downto 0) <= std_logic_vector(unsigned(mac_ram_address_a_incremented(2 downto 0)) - to_unsigned(1, 3));
                    mac_ram_address_o_incremented(2 downto 0) <= std_logic_vector(unsigned(mac_ram_address_o_incremented(2 downto 0)) - to_unsigned(1, 3));
                else
                    mac_ram_address_a_incremented(2 downto 0) <= std_logic_vector(unsigned(mac_ram_address_a_incremented(2 downto 0)) + to_unsigned(1, 3));
                    mac_ram_address_o_incremented(2 downto 0) <= std_logic_vector(unsigned(mac_ram_address_o_incremented(2 downto 0)) + to_unsigned(1, 3));
                end if;
            end if;
        end if;
    end if;
end process;

mac_ram : entity work.synth_mac_ram_v4(behavioral_small_memories)
    Generic Map(
        small_bus_ram_address_size => mac_memory_address_size + mac_multiplication_factor_log2,
        small_bus_ram_word_size => mac_base_word_size,
        full_bus_address_factor_size => mac_multiplication_factor_log2,
        multiplication_factor => mac_multiplication_factor
    )
    Port Map(
        clk => clk,
        small_bus_enable => mac_ram_small_bus_enable,
        full_bus_enable => mac_ram_full_bus_enable,
        small_bus_mode => mac_ram_small_bus_mode,
        data_in_one_a_full_bus_mode => mac_ram_data_in_one_a_full_bus_mode,
        data_in_one_b_full_bus_mode => mac_ram_data_in_one_b_full_bus_mode,
        data_in_two_a_full_bus_mode => mac_ram_data_in_two_a_full_bus_mode,
        data_in_two_b_full_bus_mode => mac_ram_data_in_two_b_full_bus_mode,
        enable_write_one_a_full_bus_mode => mac_ram_enable_write_one_a_full_bus_mode,
        enable_write_one_b_full_bus_mode => mac_ram_enable_write_one_b_full_bus_mode,
        enable_write_two_a_full_bus_mode => mac_ram_enable_write_two_a_full_bus_mode,
        enable_write_two_b_full_bus_mode => mac_ram_enable_write_two_b_full_bus_mode,
        address_data_one_a_full_bus_mode => mac_ram_address_data_one_a_full_bus_mode,
        address_data_one_b_full_bus_mode => mac_ram_address_data_one_b_full_bus_mode,
        address_data_two_a_full_bus_mode => mac_ram_address_data_two_a_full_bus_mode,
        address_data_two_b_full_bus_mode => mac_ram_address_data_two_b_full_bus_mode,
        data_out_one_a_full_bus_mode => mac_ram_data_out_one_a_full_bus_mode,
        data_out_one_b_full_bus_mode => mac_ram_data_out_one_b_full_bus_mode,
        data_out_two_a_full_bus_mode => mac_ram_data_out_two_a_full_bus_mode,
        data_out_two_b_full_bus_mode => mac_ram_data_out_two_b_full_bus_mode,
        data_in_small_bus_mode => mac_ram_data_in_small_bus_mode,
        enable_write_small_bus_mode => mac_ram_enable_write_small_bus_mode,
        address_data_in_small_bus_mode => mac_ram_address_data_in_small_bus_mode,
        address_data_out_small_bus_mode => mac_ram_address_data_out_small_bus_mode,
        data_out_small_bus_mode => mac_ram_data_out_small_bus_mode
    );

process(clk)
begin
    if(rising_edge(clk)) then
        if(stack_rstn = '0') then
            stack_counter_read <= std_logic_vector(unsigned(reg_initial_stack_address) - to_unsigned(1, stack_counter_read'length));
            stack_counter_write <= reg_initial_stack_address;
        else
            if(stack_operation_valid = '1') then
                if(stack_push_mode = '1') then
                    stack_counter_write <= std_logic_vector(unsigned(stack_counter_write) + to_unsigned(1, stack_counter_write'length));
                    stack_counter_read <= stack_counter_write;
                else
                    stack_counter_write <= stack_counter_read;
                    stack_counter_read <= std_logic_vector(unsigned(stack_counter_read) - to_unsigned(1, stack_counter_read'length));
                end if;
            end if;
        end if;
    end if;
end process;

base_alu_ram_enable <= '1';
base_alu_ram_operation_mode <= sidh_control_base_alu_ram_operation_mode;
base_alu_ram_data_in <= reg_base_alu_o((mac_base_word_size - 1) downto 0) when (sidh_control_base_alu_ram_alu_mode = '1') else
                        small_bus_data_in;
base_alu_ram_write_enable <= sidh_control_base_alu_ram_write_enable when (sidh_control_base_alu_ram_alu_mode = '1') else
                             small_bus_write_enable when (((small_bus_enable = '1') and (small_bus_address_data_in_decoded = "0010"))) else 
                             '0';
base_alu_ram_address_in <= reg_current_instruction_address_o((base_alu_ram_memory_size - 1) downto 0) when (sidh_control_base_alu_ram_alu_mode = '1') else
                           small_bus_address_data_in((base_alu_ram_memory_size - 1) downto 0);
base_alu_ram_address_out_0 <= reg_current_instruction_address_a((base_alu_ram_memory_size - 1) downto 0) when sidh_control_base_alu_ram_alu_mode = '1' else
                              small_bus_address_data_out((base_alu_ram_memory_size - 1) downto 0);
base_alu_ram_address_out_1 <= reg_current_instruction_address_b((base_alu_ram_memory_size - 1) downto 0);

base_alu_ram : synth_base_alu_ram_v3
    Generic Map(
        small_bus_ram_address_size => base_alu_ram_memory_size,
        small_bus_ram_word_size => mac_base_word_size
    )
    Port Map(
        clk => clk,
        enable => base_alu_ram_enable,
        operation_mode => base_alu_ram_operation_mode,
        data_in => base_alu_ram_data_in,
        address_in => base_alu_ram_address_in,
        address_out_0 => base_alu_ram_address_out_0,
        address_out_1 => base_alu_ram_address_out_1,
        write_enable => base_alu_ram_write_enable,
        data_out_0 => base_alu_ram_data_out_0,
        data_out_1 => base_alu_ram_data_out_1 
    );

rd_ram_data_in <= reg_base_alu_o((mac_base_word_size - 1) downto 0) when (sidh_control_base_alu_ram_alu_mode = '1') else
                  small_bus_data_in;
rd_ram_write_enable <= sidh_control_base_alu_ram_write_enable when ((sidh_control_base_alu_ram_alu_mode = '1') and (reg_current_instruction_address_o(9 downto 5) = "00000")) else
                       small_bus_write_enable when ((small_bus_enable = '1') and (small_bus_address_data_in_decoded = "0010") and (small_bus_address_data_in(9 downto 5) = "00000")) else 
                       '0';
rd_ram_address_in <= reg_current_instruction_address_o(4 downto 0) when (sidh_control_base_alu_ram_alu_mode = '1') else
                     small_bus_address_data_in(4 downto 0);

rd_ram_address_out_0 <= reg_next_instruction_address_a((rd_ram_memory_size - 1) downto 0)                                                         when (reg_next_instruction_address_a(15) = '0') else
                        reg_next_instruction_address_a((rd_ram_memory_size - 1) downto 1) & (reg_next_instruction_address_a(0) xor rd_ram_data_out_3(15)) when (reg_next_instruction_address_a(15 downto 14) = "10") else
                        reg_next_instruction_address_a((rd_ram_memory_size - 1) downto 1) & (reg_next_instruction_address_a(0) xor rd_ram_data_out_3(0));

rd_ram_address_out_1 <= reg_next_instruction_address_b((rd_ram_memory_size - 1) downto 0)                                                         when (reg_next_instruction_address_b(15) = '0') else
                        reg_next_instruction_address_b((rd_ram_memory_size - 1) downto 1) & (reg_next_instruction_address_b(0) xor rd_ram_data_out_3(15)) when (reg_next_instruction_address_b(15 downto 14) = "10") else
                        reg_next_instruction_address_b((rd_ram_memory_size - 1) downto 1) & (reg_next_instruction_address_b(0) xor rd_ram_data_out_3(0));

rd_ram_address_out_2 <= reg_next_instruction_address_o((rd_ram_memory_size - 1) downto 0)                                                         when (reg_next_instruction_address_o(15) = '0') else
                        reg_next_instruction_address_o((rd_ram_memory_size - 1) downto 1) & (reg_next_instruction_address_o(0) xor rd_ram_data_out_3(15)) when (reg_next_instruction_address_o(15 downto 14) = "10") else
                        reg_next_instruction_address_o((rd_ram_memory_size - 1) downto 1) & (reg_next_instruction_address_o(0) xor rd_ram_data_out_3(0));

rd_ram_address_out_3 <= reg_scalar_address;

rd_ram : synth_rd_ram
    Generic Map(
        ram_address_size => rd_ram_memory_size,
        ram_word_size => mac_base_word_size
    )
    Port Map(
        data_in => rd_ram_data_in,
        write_enable => rd_ram_write_enable,
        clk => clk,
        address_in => rd_ram_address_in,
        address_out_0 => rd_ram_address_out_0,
        address_out_1 => rd_ram_address_out_1,
        address_out_2 => rd_ram_address_out_2,
        address_out_3 => rd_ram_address_out_3,
        data_out_0 => rd_ram_data_out_0,
        data_out_1 => rd_ram_data_out_1,
        data_out_2 => rd_ram_data_out_2,
        data_out_3 => rd_ram_data_out_3
    );


process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            base_alu_a <= (others => '0');
        elsif(enable_base_alu_input_registers = '1') then
            base_alu_a <= reg_current_instruction_value_a_solved;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            base_alu_b <= (others => '0');
        elsif(enable_base_alu_input_registers = '1') then
            base_alu_b <= reg_current_instruction_value_b_solved;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            base_alu_rotation_size <= (others => '0');
        elsif(enable_base_alu_input_registers = '1') then
            base_alu_rotation_size <= reg_current_instruction_value_a_solved((base_alu_rotation_level - 1) downto 0);
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            base_alu_left_rotation <= '0';
        elsif(enable_base_alu_input_registers = '1') then
            if((reg_current_instruction_base_alu_operation_type = base_unit_bshiftl_operation) or (reg_current_instruction_base_alu_operation_type = base_unit_brotl_operation)) then
                base_alu_left_rotation <= '1';
            else
                base_alu_left_rotation <= '0';
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            base_alu_shift_mode <= '0';
        elsif(enable_base_alu_input_registers = '1') then
            if((reg_current_instruction_base_alu_operation_type = base_unit_bshiftr_operation) or (reg_current_instruction_base_alu_operation_type = base_unit_bshiftl_operation)) then
                base_alu_shift_mode <= '1';
            else
                base_alu_shift_mode <= '0';
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            base_alu_a_signed <= '0';
            base_alu_b_signed <= '0';
        elsif(enable_base_alu_input_registers = '1') then
            base_alu_a_signed <= reg_current_instruction_sign_a;
            base_alu_b_signed <= reg_current_instruction_sign_b;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            base_alu_operation_type <= "11";
            base_alu_math_operation <= "11";
            base_alu_logic_operation <= "11";
        elsif(enable_base_alu_input_registers = '1') then
            case reg_current_instruction_base_alu_operation_type is 
                when base_unit_badd_operation =>
                    base_alu_operation_type <= "00";
                    base_alu_math_operation <= "00";
                    base_alu_logic_operation <= "11";
                when base_unit_bsub_operation =>
                    base_alu_operation_type <= "00";
                    base_alu_math_operation <= "01";
                    base_alu_logic_operation <= "11";
                when base_unit_bsmul_operation =>
                    base_alu_operation_type <= "00";
                    base_alu_math_operation <= "10";
                    base_alu_logic_operation <= "11";
                when base_unit_bshiftr_operation =>
                    base_alu_operation_type <= "01";
                    base_alu_math_operation <= "11";
                    base_alu_logic_operation <= "11";
                when base_unit_bshiftl_operation =>
                    base_alu_operation_type <= "01";
                    base_alu_math_operation <= "11";
                    base_alu_logic_operation <= "11";
                when base_unit_brotr_operation =>
                    base_alu_operation_type <= "01";
                    base_alu_math_operation <= "11";
                    base_alu_logic_operation <= "11";
                when base_unit_brotl_operation =>
                    base_alu_operation_type <= "01";
                    base_alu_math_operation <= "11";
                    base_alu_logic_operation <= "11";
                when base_unit_bland_operation =>
                    base_alu_operation_type <= "10";
                    base_alu_math_operation <= "11";
                    base_alu_logic_operation <= "00";
                when base_unit_blor_operation =>
                    base_alu_operation_type <= "10";
                    base_alu_math_operation <= "11";
                    base_alu_logic_operation <= "01";
                when base_unit_blxor_operation =>
                    base_alu_operation_type <= "10";
                    base_alu_math_operation <= "11";
                    base_alu_logic_operation <= "10";
                when base_unit_jumpeq_operation =>
                    base_alu_operation_type <= "11";
                    base_alu_math_operation <= "01";
                    base_alu_logic_operation <= "11";
                when base_unit_jumpl_operation =>
                    base_alu_operation_type <= "11";
                    base_alu_math_operation <= "01";
                    base_alu_logic_operation <= "11";
                when base_unit_jumpeql_operation =>
                    base_alu_operation_type <= "11";
                    base_alu_math_operation <= "01";
                    base_alu_logic_operation <= "11";
                when others =>
                    base_alu_operation_type <= "11";
                    base_alu_math_operation <= "11";
                    base_alu_logic_operation <= "11";
            end case;
        end if;
    end if;
end process;

sike_base_alu : base_alu
    Generic Map(
        values_size => mac_base_word_size,
        rotation_level => base_alu_rotation_level
    )
    Port Map(
        a => base_alu_a,
        b => base_alu_b,
        operation_type => base_alu_operation_type,
        rotation_size => base_alu_rotation_size,
        left_rotation => base_alu_left_rotation,
        shift_mode => base_alu_shift_mode,
        math_operation => base_alu_math_operation,
        a_signed => base_alu_a_signed,
        b_signed => base_alu_b_signed,
        logic_operation => base_alu_logic_operation,
        o => base_alu_o,
        o_equal_zero => base_alu_o_equal_zero,
        o_change_sign_b => base_alu_o_change_sign_b
    );

process(clk)
begin
    if(rising_edge(clk)) then
        reg_base_alu_o <= base_alu_o;
        reg_base_alu_o_equal_zero <= base_alu_o_equal_zero;
        reg_base_alu_o_change_sign_b <= base_alu_o_change_sign_b;
    end if;
end process;

keccak_small_bus_enable <= small_bus_enable when ((small_bus_address_data_in_decoded = "0011") or (small_bus_address_data_out_decoded = "0011")) else '0';
keccak_small_bus_data_in <= small_bus_data_in;
keccak_small_bus_write_enable <= small_bus_write_enable when ((small_bus_address_data_in_decoded = "0011")) else '0';
keccak_small_bus_address_data_in <= small_bus_address_data_in((keccak_small_bus_address_data_in'length - 1) downto 0);
keccak_small_bus_address_data_out <= small_bus_address_data_out((keccak_small_bus_address_data_out'length - 1) downto 0);

keccak : keccak_small_bus
generic map(
    small_bus_word_size => mac_base_word_size,
    small_bus_address_size => 11
)
port map(
    clk => clk,
    rstn => rstn,
    init => keccak_init,
    go => keccak_go,
    ready => keccak_ready,
    small_bus_enable => keccak_small_bus_enable,
    small_bus_data_in => keccak_small_bus_data_in,
    small_bus_write_enable => keccak_small_bus_write_enable,
    small_bus_address_data_in => keccak_small_bus_address_data_in,
    small_bus_address_data_out => keccak_small_bus_address_data_out,
    small_bus_data_out => keccak_small_bus_data_out
);

process(clk)
begin
    if(rising_edge(clk)) then
        if(sidh_control_small_bus_address_data_in_burst_ctr_enable = '1') then
            if(sidh_control_small_bus_address_burst_ctr_load = '1') then
                small_bus_address_data_in_burst_ctr  <= unsigned(reg_current_instruction_address_o);
            elsif(reg_current_instruction(56) = '1') then
                if(reg_current_instruction(57) = '0') then
                    small_bus_address_data_in_burst_ctr  <= small_bus_address_data_in_burst_ctr + to_unsigned(1, mac_base_word_size);
                else
                    small_bus_address_data_in_burst_ctr  <= small_bus_address_data_in_burst_ctr - to_unsigned(1, mac_base_word_size);
                end if;
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(sidh_control_small_bus_address_data_out_burst_ctr_enable = '1') then
            if(sidh_control_small_bus_address_burst_ctr_load = '1') then
                small_bus_address_data_out_burst_ctr <= unsigned(reg_current_instruction_address_a);
            elsif(reg_current_instruction(55) = '1') then
                if(reg_current_instruction(57) = '0') then
                    small_bus_address_data_out_burst_ctr <= small_bus_address_data_out_burst_ctr + to_unsigned(1, mac_base_word_size);
                else
                    small_bus_address_data_out_burst_ctr <= small_bus_address_data_out_burst_ctr - to_unsigned(1, mac_base_word_size);
                end if;
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(sidh_control_small_bus_address_data_out_burst_ctr_enable = '1') then
            if(sidh_control_small_bus_address_burst_ctr_load = '1') then
                small_bus_address_burst_size_ctr <= unsigned(reg_current_instruction_value_b_solved);
            elsif(small_bus_address_burst_last_block /= '1') then
                small_bus_address_burst_size_ctr <= small_bus_address_burst_size_ctr - to_unsigned(1, mac_base_word_size);
            end if;
        end if;
    end if;
end process;

small_bus_address_burst_last_block <= '1' when to_01(small_bus_address_burst_size_ctr) = to_unsigned(0, mac_base_word_size) else '0';

sidh_control_small_bus_address_data_in <= std_logic_vector(small_bus_address_data_in_burst_ctr) when sidh_control_small_bus_burst_mode = '1' else
                                          reg_current_instruction_address_o;

sidh_control_small_bus_address_data_out <= std_logic_vector(small_bus_address_data_out_burst_ctr) when sidh_control_small_bus_burst_mode = '1' else
                                           reg_current_instruction_address_a;

small_bus_enable <= enable when (reg_status = '1') else
                    sidh_control_small_bus_enable;
small_bus_address_data_in <= address_data_in_out when (reg_status = '1') else
                     sidh_control_small_bus_address_data_in;
small_bus_address_data_out <= address_data_in_out when (reg_status = '1') else
                     sidh_control_small_bus_address_data_out;
small_bus_data_in <= data_in when (reg_status = '1') else
                     mac_ram_data_out_one_b_full_bus_mode((mac_base_word_size - 1) downto 0) when (sidh_control_small_bus_stack_mode_enable = '1') else
                     sidh_control_small_bus_buffer;
small_bus_write_enable <= write_enable and data_in_valid when (reg_status = '1') else
                          sidh_control_small_bus_write_enable;

process(small_bus_address_data_in)
begin
    small_bus_address_data_in_decoded <= "1111"; -- Address is unknown
    if(small_bus_address_data_in(15) = '0') then
        small_bus_address_data_in_decoded <= "0000"; -- Address is in the MAC RAM region
    elsif(small_bus_address_data_in(15 downto 12) = "1100") then
        small_bus_address_data_in_decoded <= "0010"; -- Address is in the Base ALU RAM region
    elsif(small_bus_address_data_in(15 downto 12) = "1101") then
        small_bus_address_data_in_decoded <= "0011"; -- Address is in the Keccak range
    elsif(to_01(unsigned(small_bus_address_data_in)) = reg_scalar_address_address) then
        small_bus_address_data_in_decoded <= "0100"; -- Address is in the scalar
    elsif(to_01(unsigned(small_bus_address_data_in)) = reg_program_counter_address) then
        small_bus_address_data_in_decoded <= "0101"; -- Address is in the program_counter
    elsif(to_01(unsigned(small_bus_address_data_in)) = reg_status_address) then
        small_bus_address_data_in_decoded <= "0110"; -- Address is in the status register
    elsif(to_01(unsigned(small_bus_address_data_in)) = reg_operands_size_address) then
        small_bus_address_data_in_decoded <= "0111"; -- Address is in the operand size register
    elsif(to_01(unsigned(small_bus_address_data_in)) = reg_prime_line_equal_one_address) then
        small_bus_address_data_in_decoded <= "1000"; -- Address is in the prime line equal one register
    elsif(to_01(unsigned(small_bus_address_data_in)) = reg_prime_address_address) then
        small_bus_address_data_in_decoded <= "1001"; -- Address is in the prime address register
    elsif(to_01(unsigned(small_bus_address_data_in)) = reg_prime_plus_one_address_address) then
        small_bus_address_data_in_decoded <= "1010"; -- Address is in the prime plus one address register
    elsif(to_01(unsigned(small_bus_address_data_in)) = reg_prime_line_address_address) then
        small_bus_address_data_in_decoded <= "1011"; -- Address is in the prime line address register
    elsif(to_01(unsigned(small_bus_address_data_in)) = reg_initial_stack_address_address) then
        small_bus_address_data_in_decoded <= "1100"; -- Address is in the initial stack address register
    elsif(to_01(unsigned(small_bus_address_data_in)) = reg_flag_address) then
        small_bus_address_data_in_decoded <= "1101"; -- Address is in the flag register
    end if;
end process;

process(small_bus_address_data_out)
begin
    small_bus_address_data_out_decoded <= "1111"; -- Address is unknown
    if(small_bus_address_data_out(15) = '0') then
        small_bus_address_data_out_decoded <= "0000"; -- Address is in the MAC RAM region
    elsif(small_bus_address_data_out(15 downto 12) = "1100") then
        small_bus_address_data_out_decoded <= "0010"; -- Address is in the Base ALU RAM region
    elsif(small_bus_address_data_out(15 downto 12) = "1101") then
        small_bus_address_data_out_decoded <= "0011"; -- Address is in the Keccak range
    elsif(to_01(unsigned(small_bus_address_data_out)) = reg_scalar_address_address) then
        small_bus_address_data_out_decoded <= "0100"; -- Address is in the scalar
    elsif(to_01(unsigned(small_bus_address_data_out)) = reg_program_counter_address) then
        small_bus_address_data_out_decoded <= "0101"; -- Address is in the program_counter
    elsif(to_01(unsigned(small_bus_address_data_out)) = reg_status_address) then
        small_bus_address_data_out_decoded <= "0110"; -- Address is in the status register
    elsif(to_01(unsigned(small_bus_address_data_out)) = reg_operands_size_address) then
        small_bus_address_data_out_decoded <= "0111"; -- Address is in the operand size register
    elsif(to_01(unsigned(small_bus_address_data_out)) = reg_prime_line_equal_one_address) then
        small_bus_address_data_out_decoded <= "1000"; -- Address is in the prime line equal one register
    elsif(to_01(unsigned(small_bus_address_data_out)) = reg_prime_address_address) then
        small_bus_address_data_out_decoded <= "1001"; -- Address is in the prime address register
    elsif(to_01(unsigned(small_bus_address_data_out)) = reg_prime_plus_one_address_address) then
        small_bus_address_data_out_decoded <= "1010"; -- Address is in the prime plus one address register
    elsif(to_01(unsigned(small_bus_address_data_out)) = reg_prime_line_address_address) then
        small_bus_address_data_out_decoded <= "1011"; -- Address is in the prime line address register
    elsif(to_01(unsigned(small_bus_address_data_out)) = reg_initial_stack_address_address) then
        small_bus_address_data_out_decoded <= "1100"; -- Address is in the initial stack address register
    elsif(to_01(unsigned(small_bus_address_data_out)) = reg_flag_address) then
        small_bus_address_data_out_decoded <= "1101"; -- Address is in the flag register
    end if;
end process;
                          
process(small_bus_address_data_out_decoded, mac_ram_data_out_small_bus_mode, base_alu_ram_data_out_0, keccak_small_bus_data_out, reg_scalar_address, prom_current_instruction_small_bus_mode, reg_next_instruction_program_counter, reg_status, reg_operands_size, reg_prime_line_equal_one, reg_current_instruction_address_o, reg_current_instruction_constant_a, reg_current_instruction_address_a, reg_prime_address, reg_prime_plus_one_address, reg_prime_line_address, reg_initial_stack_address)
begin
    if((reg_status = '0') and (reg_current_instruction_constant_a = '0')) then
        small_bus_data_out <= reg_current_instruction_address_a;
    else
        case small_bus_address_data_out_decoded is
            when "0000" =>
                small_bus_data_out <= mac_ram_data_out_small_bus_mode;
            when "0010" =>
                small_bus_data_out <= base_alu_ram_data_out_0;
            when "0011" =>
                small_bus_data_out <= keccak_small_bus_data_out;
            when "0100" =>
                small_bus_data_out((small_bus_data_out'length - 1) downto reg_scalar_address'length) <= (others => '0');
                small_bus_data_out((reg_scalar_address'length - 1) downto 0) <= reg_scalar_address;
            when "0101" =>
                small_bus_data_out((small_bus_data_out'length - 1) downto reg_next_instruction_program_counter'length) <= (others => '0');
                small_bus_data_out((reg_next_instruction_program_counter'length - 1) downto 0) <= reg_next_instruction_program_counter;
            when "0110" =>
                small_bus_data_out((small_bus_data_out'length - 1) downto 1) <= (others => '0');
                small_bus_data_out(0) <= reg_status;
            when "0111" =>
                small_bus_data_out((small_bus_data_out'length - 1) downto 2) <= (others => '0');
                small_bus_data_out((mac_max_operands_size - 1) downto 0) <= reg_operands_size;
            when "1000" =>
                small_bus_data_out((small_bus_data_out'length - 1) downto 1) <= (others => '0');
                small_bus_data_out(0) <= reg_prime_line_equal_one;
            when "1001" =>
                small_bus_data_out((small_bus_data_out'length - 1) downto reg_prime_address'length) <= (others => '0');
                small_bus_data_out((reg_prime_address'length - 1) downto 0) <= reg_prime_address;
            when "1010" =>
                small_bus_data_out((small_bus_data_out'length - 1) downto reg_prime_plus_one_address'length) <= (others => '0');
                small_bus_data_out((reg_prime_plus_one_address'length - 1) downto 0) <= reg_prime_plus_one_address;
            when "1011" =>
                small_bus_data_out((small_bus_data_out'length - 1) downto reg_prime_line_address'length) <= (others => '0');
                small_bus_data_out((reg_prime_line_address'length - 1) downto 0) <= reg_prime_line_address;
            when "1100" =>
                small_bus_data_out((small_bus_data_out'length - 1) downto reg_initial_stack_address'length) <= (others => '0');
                small_bus_data_out((reg_initial_stack_address'length - 1) downto 0) <= reg_initial_stack_address;
            when others =>
                small_bus_data_out <= (others => '0');
            end case;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(sidh_control_small_bus_buffer_enable = '1') then
            sidh_control_small_bus_buffer <= small_bus_data_out;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_operands_size <= (others => '0');
        elsif(reg_status = '1') then
            if((enable = '1') and (write_enable = '1') and (data_in_valid = '1') and (address_data_in_out = std_logic_vector(reg_operands_size_address))) then
                reg_operands_size <= data_in((reg_operands_size'length - 1) downto 0);
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_prime_line_equal_one <= '0';
        elsif(reg_status = '1') then
            if((enable = '1') and (write_enable = '1') and (data_in_valid = '1') and (address_data_in_out = std_logic_vector(reg_prime_line_equal_one_address))) then
                reg_prime_line_equal_one <= data_in(0);
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_initial_stack_address <= std_logic_vector(to_unsigned(4*224, reg_initial_stack_address'length));
        elsif(reg_status = '1') then
            if((enable = '1') and (write_enable = '1') and (data_in_valid = '1') and (address_data_in_out = std_logic_vector(reg_initial_stack_address_address))) then
                reg_initial_stack_address <= data_in((reg_initial_stack_address'length - 1) downto 0);
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_prime_address <= std_logic_vector(to_unsigned(0, mac_memory_address_size - mac_max_operands_size));
        else
            if((small_bus_enable = '1') and (small_bus_write_enable = '1') and (small_bus_address_data_in = std_logic_vector(reg_prime_address_address))) then
                reg_prime_address <= small_bus_data_in((reg_prime_address'length - 1) downto 0);
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_prime_plus_one_address <= std_logic_vector(to_unsigned(1, mac_memory_address_size - mac_max_operands_size));
        else
            if((small_bus_enable = '1') and (small_bus_write_enable = '1') and (small_bus_address_data_in = std_logic_vector(reg_prime_plus_one_address_address))) then
                reg_prime_plus_one_address <= small_bus_data_in((reg_prime_plus_one_address'length - 1) downto 0);
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_prime_line_address <= std_logic_vector(to_unsigned(2, mac_memory_address_size - mac_max_operands_size));
        else
            if((small_bus_enable = '1') and (small_bus_write_enable = '1') and (small_bus_address_data_in = std_logic_vector(reg_prime_line_address_address))) then
                reg_prime_line_address <= small_bus_data_in((reg_prime_line_address'length - 1) downto 0);
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_flag <= '0';
        else
            if((small_bus_enable = '1') and (small_bus_write_enable = '1') and (small_bus_address_data_in = std_logic_vector(reg_flag_address))) then
                reg_flag <= small_bus_data_in(0);
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_scalar_address <= std_logic_vector(to_unsigned(0, rd_ram_memory_size));
        else
            if((small_bus_enable = '1') and (small_bus_write_enable = '1') and (small_bus_address_data_in = std_logic_vector(reg_scalar_address_address))) then
                reg_scalar_address <= small_bus_data_in((reg_scalar_address'length - 1) downto 0);
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            prom_program_counter_start_execution <= '0';
        elsif(reg_status = '1') then
            if((enable = '1') and (write_enable = '1') and (data_in_valid = '1') and (address_data_in_out = std_logic_vector(reg_program_counter_address))) then
                prom_program_counter_start_execution <= '1';
            end if;
        elsif(prom_program_counter_start_execution = '1') then
            prom_program_counter_start_execution <= '0';
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            prom_program_counter <= (others => '0');
        elsif(reg_status = '1') then
            if((enable = '1') and (write_enable = '1') and (data_in_valid = '1') and (address_data_in_out = std_logic_vector(reg_program_counter_address))) then
                prom_program_counter <= data_in((prom_program_counter'length - 1) downto 0);
            end if;
        elsif(prom_program_counter_enable_increase = '1') then
            prom_program_counter <= std_logic_vector(unsigned(prom_program_counter) + to_unsigned(1, prom_program_counter'length));
        elsif(prom_program_counter_enable_jump = '1') then
            if((check_base_alu_o_equal_zero = '0') and (check_base_alu_o_change_sign_b = '0')) then
                if(prom_program_counter_return_function = '1') then
                    prom_program_counter <= mac_ram_data_out_one_b_full_bus_mode((prom_program_counter'length - 1) downto 0);
                else
                    prom_program_counter <= reg_current_instruction_address_o((prom_program_counter'length - 1) downto 0);
                end if;
            elsif(((check_base_alu_o_equal_zero = '1') and (reg_base_alu_o_equal_zero = '1')) or ((check_base_alu_o_change_sign_b = '1') and (reg_base_alu_o_change_sign_b = '1'))) then
                prom_program_counter <= reg_current_instruction_address_o((prom_program_counter'length - 1) downto 0);
            else
                prom_program_counter <= reg_next_instruction_program_counter;
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_next_instruction <= (others => '0');
        elsif(reg_next_instruction_enable = '1') then
            reg_next_instruction <= prom_current_instruction_full_bus_mode;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_next_instruction_program_counter <= (others => '0');
        elsif(prom_program_counter_enable_increase = '1') then
            reg_next_instruction_program_counter <= prom_program_counter;
        end if;
    end if;
end process;

reg_next_instruction_processor_target <= reg_next_instruction(63 downto 62);
reg_next_instruction_base_alu_operation_type <= reg_next_instruction(60 downto 55);

reg_next_instruction_address_a <= reg_next_instruction(15 downto 0);
reg_next_instruction_address_b <= reg_next_instruction(34 downto 19);
reg_next_instruction_address_o <= reg_next_instruction(53 downto 38);

reg_next_instruction_address_solved(reg_next_instruction'left downto 55) <= reg_next_instruction(reg_next_instruction'left downto 55);
reg_next_instruction_address_solved(54) <= '0';
reg_next_instruction_address_solved(53 downto 38) <= reg_next_instruction_address_o when (reg_next_instruction(54) = '0') else
                                                     rd_ram_data_out_2(15 downto 0);
reg_next_instruction_address_solved(37) <= reg_next_instruction(37);
reg_next_instruction_address_solved(36) <= '0';
reg_next_instruction_address_solved(35) <= reg_next_instruction(35);
reg_next_instruction_address_solved(34 downto 19) <= reg_next_instruction_address_b when (reg_next_instruction(36) = '0') else
                                                     rd_ram_data_out_1(15 downto 0);
reg_next_instruction_address_solved(18) <= reg_next_instruction(18);
reg_next_instruction_address_solved(17) <= '0';
reg_next_instruction_address_solved(16) <= reg_next_instruction(16);
reg_next_instruction_address_solved(15 downto  0) <= reg_next_instruction_address_a when (reg_next_instruction(17) = '0') else
                                                     rd_ram_data_out_0(15 downto 0);

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_current_instruction <= (others => '0');
        elsif(reg_current_instruction_enable = '1') then
            reg_current_instruction <= reg_next_instruction_address_solved;
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_current_instruction_program_counter <= (others => '0');
        elsif(prom_program_counter_enable_increase = '1') then
            reg_current_instruction_program_counter <= reg_next_instruction_program_counter;
        end if;
    end if;
end process;

reg_current_instruction_processor_target <= reg_current_instruction(63 downto 62);
reg_current_instruction_base_alu_operation_type <= reg_current_instruction(60 downto 55);

reg_current_instruction_address_a <= reg_current_instruction(15 downto 0);
reg_current_instruction_constant_a <= reg_current_instruction(16);
reg_current_instruction_direction_a <= reg_current_instruction(17);
reg_current_instruction_sign_a <= reg_current_instruction(18);

reg_current_instruction_address_a_solved <= reg_current_instruction_address_a when (reg_current_instruction_direction_a = '0') else
                                            base_alu_ram_data_out_0(15 downto 0);

reg_current_instruction_value_a_solved <= reg_current_instruction_address_a when (reg_current_instruction_constant_a = '0') else
                                          base_alu_ram_data_out_0(15 downto 0);

reg_current_instruction_address_b <= reg_current_instruction(34 downto 19);
reg_current_instruction_constant_b <= reg_current_instruction(35);
reg_current_instruction_direction_b <= reg_current_instruction(36);
reg_current_instruction_sign_b <= reg_current_instruction(37);

reg_current_instruction_address_b_solved <= reg_current_instruction_address_b when (reg_current_instruction_direction_b = '0') else
                                            base_alu_ram_data_out_1(15 downto 0);

reg_current_instruction_value_b_solved <= reg_current_instruction_address_b when (reg_current_instruction_constant_b = '0') else
                                          base_alu_ram_data_out_1(15 downto 0);

reg_current_instruction_address_o <= reg_current_instruction(53 downto 38);
reg_current_instruction_direction_o <= reg_current_instruction(54);

reg_current_instruction_address_o_solved <= reg_current_instruction_address_o;

reg_current_instruction_value_o_solved <= reg_current_instruction_address_o;

reg_constant_full_bus(15 downto 0) <= reg_current_instruction_address_a when reg_constant_full_bus_base = '0' else
                                      (others => reg_current_instruction_address_a(15)) when reg_current_instruction_sign_a = '1' else (others => '0');
reg_constant_full_bus(reg_constant_full_bus'left downto 16) <= (others => reg_current_instruction_address_a(15)) when reg_current_instruction_sign_a = '1' else (others => '0');

mac_instruction_values_valid <= enable_new_mac_instruction;



mac_instruction_type <= reg_current_instruction(58 downto 55);
mac_load_new_address_prime_plus_one <= reg_prime_plus_one_address;
mac_load_new_address_prime_line <= reg_prime_line_address;
mac_load_new_address_prime <= reg_prime_address;
mac_load_new_address_input_ma <= reg_current_instruction_address_a((mac_load_new_address_input_ma'length - 1) downto 0) when (reg_current_instruction(16) = '1') else
                                 (others => '0');
mac_load_new_sign_ma <= reg_current_instruction(18);
mac_load_new_address_input_mb <= reg_current_instruction_address_b((mac_load_new_address_input_mb'length - 1) downto 0) when (reg_current_instruction(35) = '1') else
                                 (others => '0');
mac_load_new_address_output_mo <= reg_current_instruction_address_o((mac_load_new_address_output_mo'length - 1) downto 0) when (reg_current_instruction(16) = '1' or reg_current_instruction(35) = '1') else
                                 (others => '0');
mac_enable_new_address_output_mo <= reg_current_instruction(16) or reg_current_instruction(35);

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            data_out_valid <= '0';
        elsif(reg_status = '1') then
            if((enable = '1') and (write_enable = '0')) then
                case small_bus_address_data_out_decoded is 
                    when "0000" =>
                        data_out_valid <= '1';
                    when "0010" =>
                        data_out_valid <= '1';
                    when "0001" =>
                        data_out_valid <= '1';
                    when "0011" =>
                        data_out_valid <= '0';
                    when "0100" =>
                        data_out_valid <= '0';
                    when "0101" =>
                        data_out_valid <= '1';
                    when "0110" =>
                        data_out_valid <= '1';
                    when "0111" =>
                        data_out_valid <= '1';
                    when "1000" =>
                        data_out_valid <= '1';
                    when "1001" =>
                        data_out_valid <= '1';
                    when "1010" =>
                        data_out_valid <= '1';
                    when "1011" =>
                        data_out_valid <= '1';
                    when others =>
                        data_out_valid <= '0';
                end case;
            else
                data_out_valid <= '0';
            end if;
        else
            if((enable = '1') and (write_enable = '0') and (address_data_in_out = std_logic_vector(reg_status_address))) then
                data_out_valid <= '1';
            else
                data_out_valid <= '0';
            end if;
        end if;
    end if;
end process;

data_out <= prom_current_instruction_small_bus_mode when ((reg_status = '1') and (prom_address_region = '1')) else
            small_bus_data_out when (reg_status = '1') else (others => '0');
core_free <= reg_status;
flag <= reg_flag;

end behavioral;