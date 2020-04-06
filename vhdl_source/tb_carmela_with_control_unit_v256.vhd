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
use IEEE.STD_LOGIC_TEXTIO.ALL;

library STD;
use STD.TEXTIO.ALL;

entity tb_carmela_with_control_unit_v256 is
Generic(
    PERIOD : time := 100 ns;
    base_wide_adder_size : integer := 2;
    base_word_size : integer := 16;
    multiplication_factor : integer := 16;
    multiplication_factor_log2 : integer := 4;
    accumulator_extra_bits : integer := 32;
    memory_address_size : integer := 10;
    max_operands_size : integer := 2;
    maximum_number_of_tests : integer := 0;
    
    
    test_memory_file_multiplication_no_reduction_test_4_3 : string := "../hw_sidh_tests_v256/multiplication_no_reduction_test_4_3.dat";
    test_memory_file_multiplication_no_reduction_test_216_137 : string := "../hw_sidh_tests_v256/multiplication_no_reduction_test_216_137.dat";
    test_memory_file_multiplication_no_reduction_test_250_159 : string := "../hw_sidh_tests_v256/multiplication_no_reduction_test_250_159.dat";
    test_memory_file_multiplication_no_reduction_test_305_192 : string := "../hw_sidh_tests_v256/multiplication_no_reduction_test_305_192.dat";
    test_memory_file_multiplication_no_reduction_test_372_239 : string := "../hw_sidh_tests_v256/multiplication_no_reduction_test_372_239.dat";
    test_memory_file_multiplication_no_reduction_test_486_301 : string := "../hw_sidh_tests_v256/multiplication_no_reduction_test_486_301.dat";
    
    test_memory_file_multiplication_no_reduction_test_240_max  : string := "../hw_sidh_tests_v256/multiplication_no_reduction_test_240_max.dat";
    test_memory_file_multiplication_no_reduction_test_496_max  : string := "../hw_sidh_tests_v256/multiplication_no_reduction_test_496_max.dat";
    test_memory_file_multiplication_no_reduction_test_752_max  : string := "../hw_sidh_tests_v256/multiplication_no_reduction_test_752_max.dat";
    test_memory_file_multiplication_no_reduction_test_1008_max : string := "../hw_sidh_tests_v256/multiplication_no_reduction_test_1008_max.dat";
    
    test_memory_file_square_no_reduction_test_4_3 : string := "../hw_sidh_tests_v256/square_no_reduction_test_4_3.dat";
    test_memory_file_square_no_reduction_test_216_137 : string := "../hw_sidh_tests_v256/square_no_reduction_test_216_137.dat";
    test_memory_file_square_no_reduction_test_250_159 : string := "../hw_sidh_tests_v256/square_no_reduction_test_250_159.dat";
    test_memory_file_square_no_reduction_test_305_192 : string := "../hw_sidh_tests_v256/square_no_reduction_test_305_192.dat";
    test_memory_file_square_no_reduction_test_372_239 : string := "../hw_sidh_tests_v256/square_no_reduction_test_372_239.dat";
    test_memory_file_square_no_reduction_test_486_301 : string := "../hw_sidh_tests_v256/square_no_reduction_test_486_301.dat";
    
    test_memory_file_square_no_reduction_test_240_max  : string := "../hw_sidh_tests_v256/square_no_reduction_test_240_max.dat";
    test_memory_file_square_no_reduction_test_496_max  : string := "../hw_sidh_tests_v256/square_no_reduction_test_496_max.dat";
    test_memory_file_square_no_reduction_test_752_max  : string := "../hw_sidh_tests_v256/square_no_reduction_test_752_max.dat";
    test_memory_file_square_no_reduction_test_1008_max : string := "../hw_sidh_tests_v256/square_no_reduction_test_1008_max.dat";
    
    test_memory_file_montgomery_multiplication_test_4_3 : string := "../hw_sidh_tests_v256/montgomery_multiplication_test_4_3.dat";
    test_memory_file_montgomery_multiplication_test_216_137 : string := "../hw_sidh_tests_v256/montgomery_multiplication_test_216_137.dat";
    test_memory_file_montgomery_multiplication_test_250_159 : string := "../hw_sidh_tests_v256/montgomery_multiplication_test_250_159.dat";
    test_memory_file_montgomery_multiplication_test_305_192 : string := "../hw_sidh_tests_v256/montgomery_multiplication_test_305_192.dat";
    test_memory_file_montgomery_multiplication_test_372_239 : string := "../hw_sidh_tests_v256/montgomery_multiplication_test_372_239.dat";
    test_memory_file_montgomery_multiplication_test_486_301 : string := "../hw_sidh_tests_v256/montgomery_multiplication_test_486_301.dat";
    
    test_memory_file_montgomery_multiplication_test_240_max  : string := "../hw_sidh_tests_v256/montgomery_multiplication_test_240_max.dat";
    test_memory_file_montgomery_multiplication_test_496_max  : string := "../hw_sidh_tests_v256/montgomery_multiplication_test_496_max.dat";
    test_memory_file_montgomery_multiplication_test_752_max  : string := "../hw_sidh_tests_v256/montgomery_multiplication_test_752_max.dat";
    test_memory_file_montgomery_multiplication_test_1008_max : string := "../hw_sidh_tests_v256/montgomery_multiplication_test_1008_max.dat";
    
    test_memory_file_montgomery_squaring_test_4_3 : string := "../hw_sidh_tests_v256/montgomery_squaring_test_4_3.dat";
    test_memory_file_montgomery_squaring_test_216_137 : string := "../hw_sidh_tests_v256/montgomery_squaring_test_216_137.dat";
    test_memory_file_montgomery_squaring_test_250_159 : string := "../hw_sidh_tests_v256/montgomery_squaring_test_250_159.dat";
    test_memory_file_montgomery_squaring_test_305_192 : string := "../hw_sidh_tests_v256/montgomery_squaring_test_305_192.dat";
    test_memory_file_montgomery_squaring_test_372_239 : string := "../hw_sidh_tests_v256/montgomery_squaring_test_372_239.dat";
    test_memory_file_montgomery_squaring_test_486_301 : string := "../hw_sidh_tests_v256/montgomery_squaring_test_486_301.dat";
    
    test_memory_file_montgomery_squaring_test_240_max  : string := "../hw_sidh_tests_v256/montgomery_squaring_test_240_max.dat";
    test_memory_file_montgomery_squaring_test_496_max  : string := "../hw_sidh_tests_v256/montgomery_squaring_test_496_max.dat";
    test_memory_file_montgomery_squaring_test_752_max  : string := "../hw_sidh_tests_v256/montgomery_squaring_test_752_max.dat";
    test_memory_file_montgomery_squaring_test_1008_max : string := "../hw_sidh_tests_v256/montgomery_squaring_test_1008_max.dat";
    
    test_memory_file_addition_subtraction_no_reduction_test_4_3 : string := "../hw_sidh_tests_v256/addition_subtraction_no_reduction_test_4_3.dat";
    test_memory_file_addition_subtraction_no_reduction_test_216_137 : string := "../hw_sidh_tests_v256/addition_subtraction_no_reduction_test_216_137.dat";
    test_memory_file_addition_subtraction_no_reduction_test_250_159 : string := "../hw_sidh_tests_v256/addition_subtraction_no_reduction_test_250_159.dat";
    test_memory_file_addition_subtraction_no_reduction_test_305_192 : string := "../hw_sidh_tests_v256/addition_subtraction_no_reduction_test_305_192.dat";
    test_memory_file_addition_subtraction_no_reduction_test_372_239 : string := "../hw_sidh_tests_v256/addition_subtraction_no_reduction_test_372_239.dat";
    test_memory_file_addition_subtraction_no_reduction_test_486_301 : string := "../hw_sidh_tests_v256/addition_subtraction_no_reduction_test_486_301.dat";
    
    test_memory_file_addition_subtraction_no_reduction_test_240_max  : string := "../hw_sidh_tests_v256/addition_subtraction_no_reduction_test_240_max.dat";
    test_memory_file_addition_subtraction_no_reduction_test_496_max  : string := "../hw_sidh_tests_v256/addition_subtraction_no_reduction_test_496_max.dat";
    test_memory_file_addition_subtraction_no_reduction_test_752_max  : string := "../hw_sidh_tests_v256/addition_subtraction_no_reduction_test_752_max.dat";
    test_memory_file_addition_subtraction_no_reduction_test_1008_max : string := "../hw_sidh_tests_v256/addition_subtraction_no_reduction_test_1008_max.dat";
    
    test_memory_file_iterative_modular_reduction_test_4_3 : string := "../hw_sidh_tests_v256/iterative_modular_reduction_test_4_3.dat";
    test_memory_file_iterative_modular_reduction_test_216_137 : string := "../hw_sidh_tests_v256/iterative_modular_reduction_test_216_137.dat";
    test_memory_file_iterative_modular_reduction_test_250_159 : string := "../hw_sidh_tests_v256/iterative_modular_reduction_test_250_159.dat";
    test_memory_file_iterative_modular_reduction_test_305_192 : string := "../hw_sidh_tests_v256/iterative_modular_reduction_test_305_192.dat";
    test_memory_file_iterative_modular_reduction_test_372_239 : string := "../hw_sidh_tests_v256/iterative_modular_reduction_test_372_239.dat";
    test_memory_file_iterative_modular_reduction_test_486_301 : string := "../hw_sidh_tests_v256/iterative_modular_reduction_test_486_301.dat";
    
    test_memory_file_iterative_modular_reduction_test_240_max  : string := "../hw_sidh_tests_v256/iterative_modular_reduction_test_240_max.dat";
    test_memory_file_iterative_modular_reduction_test_496_max  : string := "../hw_sidh_tests_v256/iterative_modular_reduction_test_496_max.dat";
    test_memory_file_iterative_modular_reduction_test_752_max  : string := "../hw_sidh_tests_v256/iterative_modular_reduction_test_752_max.dat";
    test_memory_file_iterative_modular_reduction_test_1008_max : string := "../hw_sidh_tests_v256/iterative_modular_reduction_test_1008_max.dat"

);
end tb_carmela_with_control_unit_v256;

architecture behavioral of tb_carmela_with_control_unit_v256 is

component carmela_with_control_unit_v256
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

type operands_values_array is array (natural range <>) of std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);

signal test_rstn : std_logic;
signal test_instruction_values_valid : std_logic;
signal test_instruction_type : std_logic_vector(3 downto 0);
signal test_operands_size : std_logic_vector((max_operands_size - 1) downto 0);
signal test_prime_line_equal_one : std_logic;
signal test_load_new_address_prime : std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
signal test_load_new_address_prime_line : std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
signal test_load_new_address_prime_plus_one : std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
signal test_load_new_address_input_ma : std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
signal test_load_new_sign_ma : std_logic;
signal test_load_new_address_input_mb : std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
signal test_load_new_address_output_mo : std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
signal test_enable_new_address_output_mo : std_logic;
signal test_data_in_mem_one_a : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
signal test_data_in_mem_one_b : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
signal test_data_in_mem_two_a : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
signal test_data_in_mem_two_b : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
signal test_mem_one_address_a : std_logic_vector((memory_address_size - 1) downto 0);
signal test_mem_one_address_b : std_logic_vector((memory_address_size - 1) downto 0);
signal test_mem_two_address_a : std_logic_vector((memory_address_size - 1) downto 0);
signal test_mem_two_address_b : std_logic_vector((memory_address_size - 1) downto 0);
signal test_write_enable_mem_one_a : std_logic;
signal test_write_enable_mem_one_b : std_logic;
signal test_write_enable_mem_two_a : std_logic;
signal test_write_enable_mem_two_b : std_logic;
signal test_data_out_mem_one_a : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
signal test_data_out_mem_one_b : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
signal test_data_out_mem_two_a : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
signal test_data_out_mem_two_b : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
signal test_free_flag : std_logic;

signal test_mem_small_bus_enable : std_logic;
signal test_mem_full_bus_enable : std_logic;
signal test_mem_small_bus_mode : std_logic;
signal test_mem_data_in_small_bus_mode : std_logic_vector((base_word_size - 1) downto 0);
signal test_mem_enable_write_small_bus_mode : std_logic;
signal test_mem_address_data_in_small_bus_mode : std_logic_vector((memory_address_size + multiplication_factor_log2 - 1) downto 0);
signal test_mem_address_data_out_small_bus_mode : std_logic_vector((memory_address_size + multiplication_factor_log2 - 1) downto 0);
signal test_mem_data_out_small_bus_mode : std_logic_vector((base_word_size - 1) downto 0);

signal test_value_a : operands_values_array((2**max_operands_size - 1) downto 0);
signal test_value_b : operands_values_array((2**max_operands_size - 1) downto 0);
signal test_value_prime : operands_values_array((2**max_operands_size - 1) downto 0);
signal test_value_prime_line : operands_values_array((2**max_operands_size - 1) downto 0);
signal test_value_prime_plus_one : operands_values_array((2**max_operands_size - 1) downto 0);
signal test_value_o : operands_values_array((2*(2**max_operands_size) - 1) downto 0);
signal test_value_o_2 : operands_values_array((2*(2**max_operands_size) - 1) downto 0);
signal test_value_o_3 : operands_values_array((2*(2**max_operands_size) - 1) downto 0);
signal true_value_o : operands_values_array((2*(2**max_operands_size) - 1) downto 0);
signal true_value_o_2 : operands_values_array((2*(2**max_operands_size) - 1) downto 0);
signal true_value_o_3 : operands_values_array((2*(2**max_operands_size) - 1) downto 0);
signal test_error : std_logic := '0';
signal test_verification : std_logic := '0';
signal clk : std_logic := '1';
signal test_bench_finish : boolean := false;

constant tb_delay : time := (PERIOD/2);

begin

test : carmela_with_control_unit_v256
    Generic Map(
        base_wide_adder_size => base_wide_adder_size,
        base_word_size => base_word_size,
        accumulator_extra_bits => accumulator_extra_bits,
        memory_address_size => memory_address_size
    )
    Port Map(
        rstn => test_rstn,
        clk => clk,
        instruction_values_valid => test_instruction_values_valid,
        instruction_type => test_instruction_type,
        operands_size => test_operands_size,
        prime_line_equal_one => test_prime_line_equal_one,
        load_new_address_prime => test_load_new_address_prime,
        load_new_address_prime_line => test_load_new_address_prime_line,
        load_new_address_prime_plus_one => test_load_new_address_prime_plus_one,
        load_new_address_input_ma => test_load_new_address_input_ma,
        load_new_sign_ma => test_load_new_sign_ma,
        load_new_address_input_mb => test_load_new_address_input_mb,
        load_new_address_output_mo => test_load_new_address_output_mo,
        enable_new_address_output_mo => test_enable_new_address_output_mo,
        data_in_mem_one_a => test_data_in_mem_one_a,
        data_in_mem_one_b => test_data_in_mem_one_b,
        data_in_mem_two_a => test_data_in_mem_two_a,
        data_in_mem_two_b => test_data_in_mem_two_b,
        mem_one_address_a => test_mem_one_address_a,
        mem_one_address_b => test_mem_one_address_b,
        mem_two_address_a => test_mem_two_address_a,
        mem_two_address_b => test_mem_two_address_b,
        write_enable_mem_one_a => test_write_enable_mem_one_a,
        write_enable_mem_one_b => test_write_enable_mem_one_b,
        write_enable_mem_two_a => test_write_enable_mem_two_a,
        write_enable_mem_two_b => test_write_enable_mem_two_b,
        data_out_mem_one_a => test_data_out_mem_one_a,
        data_out_mem_one_b => test_data_out_mem_one_b,
        data_out_mem_two_a => test_data_out_mem_two_a,
        data_out_mem_two_b => test_data_out_mem_two_b,
        free_flag => test_free_flag
    );

test_mem : entity work.synth_mac_ram_v4(behavioral_one_memory)
    Generic Map(
        small_bus_ram_address_size => memory_address_size+multiplication_factor_log2,
        full_bus_address_factor_size => multiplication_factor_log2,
        small_bus_ram_word_size => base_word_size,
        multiplication_factor => multiplication_factor
    )
    Port Map(
        clk => clk,
        small_bus_enable => test_mem_small_bus_enable,
        full_bus_enable => test_mem_full_bus_enable,
        small_bus_mode => test_mem_small_bus_mode,
        data_in_one_a_full_bus_mode => test_data_out_mem_one_a,
        data_in_one_b_full_bus_mode => test_data_out_mem_one_b,
        data_in_two_a_full_bus_mode => test_data_out_mem_two_a,
        data_in_two_b_full_bus_mode => test_data_out_mem_two_b,
        enable_write_one_a_full_bus_mode => test_write_enable_mem_one_a,
        enable_write_one_b_full_bus_mode => test_write_enable_mem_one_b,
        enable_write_two_a_full_bus_mode => test_write_enable_mem_two_a,
        enable_write_two_b_full_bus_mode => test_write_enable_mem_two_b,
        address_data_one_a_full_bus_mode => test_mem_one_address_a,
        address_data_one_b_full_bus_mode => test_mem_one_address_b,
        address_data_two_a_full_bus_mode => test_mem_two_address_a,
        address_data_two_b_full_bus_mode => test_mem_two_address_b,
        data_out_one_a_full_bus_mode => test_data_in_mem_one_a,
        data_out_one_b_full_bus_mode => test_data_in_mem_one_b,
        data_out_two_a_full_bus_mode => test_data_in_mem_two_a,
        data_out_two_b_full_bus_mode => test_data_in_mem_two_b,
        data_in_small_bus_mode => test_mem_data_in_small_bus_mode,
        enable_write_small_bus_mode => test_mem_enable_write_small_bus_mode,
        address_data_in_small_bus_mode => test_mem_address_data_in_small_bus_mode,
        address_data_out_small_bus_mode => test_mem_address_data_out_small_bus_mode,
        data_out_small_bus_mode => test_mem_data_out_small_bus_mode
    );

clock : process
begin
while (not test_bench_finish ) loop
    wait for PERIOD/2;
    clk <= not clk;
end loop;
wait;
end process;

process

procedure load_operand_memory(
signal value_to_load : in operands_values_array;
base_address : in std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
operands_size : in integer
) is
variable current_address : std_logic_vector((memory_address_size + multiplication_factor_log2 - 1) downto 0);
begin
    for i in 0 to (operands_size - 1) loop
        current_address((multiplication_factor_log2 - 1) downto 0) := (others => '0');
        current_address((max_operands_size + multiplication_factor_log2 - 1) downto multiplication_factor_log2) := (others => '0');
        current_address((memory_address_size + multiplication_factor_log2 - 1) downto (max_operands_size + multiplication_factor_log2)) := base_address;
        for j in 0 to (multiplication_factor - 1) loop
            test_mem_address_data_in_small_bus_mode <= std_logic_vector(unsigned(current_address) + to_unsigned(i*multiplication_factor, memory_address_size+multiplication_factor_log2) +  to_unsigned(j, memory_address_size+multiplication_factor_log2));
            test_mem_enable_write_small_bus_mode <= '0';
            wait for PERIOD;
            test_mem_enable_write_small_bus_mode <= '1';
            test_mem_data_in_small_bus_mode <= value_to_load(i)((((j+1)*(base_word_size)) - 1) downto j*(base_word_size));
            wait for PERIOD;
        end loop;
    end loop;
    test_mem_data_in_small_bus_mode <= (others => '0');
    test_mem_enable_write_small_bus_mode <= '0';
    test_mem_address_data_in_small_bus_mode <= (others => '0');
    wait for PERIOD;
end load_operand_memory;

procedure retrive_operand_memory(
signal value_to_retrive : out operands_values_array;
base_address : in std_logic_vector((memory_address_size - max_operands_size - 1) downto 0);
operands_size : in integer
) is
variable current_address : std_logic_vector((memory_address_size + multiplication_factor_log2 - 1) downto 0);
begin
    current_address((multiplication_factor_log2 - 1) downto 0) := (others => '0');
    current_address((max_operands_size + multiplication_factor_log2 - 1) downto multiplication_factor_log2) := (others => '0');
    current_address((memory_address_size + multiplication_factor_log2 - 1) downto (max_operands_size + multiplication_factor_log2)) := base_address;
    test_mem_enable_write_small_bus_mode <= '0';
    for i in 0 to (operands_size - 1) loop
        test_mem_address_data_out_small_bus_mode <= std_logic_vector(unsigned(current_address) + to_unsigned(i*multiplication_factor, memory_address_size+multiplication_factor_log2) +  to_unsigned(0, memory_address_size+multiplication_factor_log2));
        wait for PERIOD;
        for j in 1 to (multiplication_factor - 1) loop
            value_to_retrive(i)((((j)*(base_word_size)) - 1) downto (j-1)*(base_word_size)) <= test_mem_data_out_small_bus_mode;
            test_mem_address_data_out_small_bus_mode <= std_logic_vector(unsigned(current_address) + to_unsigned(i*multiplication_factor, memory_address_size+multiplication_factor_log2) +  to_unsigned(j, memory_address_size+multiplication_factor_log2));
            wait for PERIOD;
        end loop;
        value_to_retrive(i)((((multiplication_factor)*(base_word_size)) - 1) downto (multiplication_factor-1)*(base_word_size)) <= test_mem_data_out_small_bus_mode;
    end loop;
    test_mem_address_data_out_small_bus_mode <= (others => '0');
    wait for PERIOD;
end retrive_operand_memory;

procedure compare_operand_memory(
operands_size : in integer;
signal value_computed : in operands_values_array;
signal value_true : in operands_values_array
) is
begin
    for i in 0 to (operands_size - 1) loop
        test_error <= '0';
        test_verification <= '1';
        wait for PERIOD;
        if(value_computed(i) /= value_true(i)) then
            test_error <= '1';
            report "Error found during test";
        else
            test_error <= '0';
        end if;
        wait for PERIOD;
    end loop;
    test_error <= '0';
    test_verification <= '0';
    wait for PERIOD;
end compare_operand_memory;

procedure test_multiplication_no_reduction(
test_filename : in string;
operands_size : in integer
) is 
FILE ram_file : text;
variable line_n : line;
variable number_of_tests : integer;
variable read_operand_values : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
variable i : integer;
variable number_of_tests_per_iteration : integer;
variable current_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable before_time, after_time : time;

begin
    for j in 0 to (2**max_operands_size-1) loop
        test_value_a(j) <= (others => '0');
        test_value_b(j) <= (others => '0');
        test_value_o(j) <= (others => '0');
        true_value_o(j) <= (others => '0');
        test_value_o(j+2**max_operands_size) <= (others => '0');
        true_value_o(j+2**max_operands_size) <= (others => '0');
    end loop;
    test_instruction_values_valid  <= '0';
    test_instruction_type <= (others => '0');
    test_operands_size <= (others => '0');
    test_prime_line_equal_one  <= '0';
    test_load_new_address_prime <= (others => '0');
    test_load_new_address_prime_line <= (others => '0');
    test_load_new_address_prime_plus_one <= (others => '0');
    test_load_new_address_input_ma <= (others => '0');
    test_load_new_sign_ma <= '0';
    test_load_new_address_input_mb <= (others => '0');
    test_load_new_address_output_mo <= (others => '0');
    test_enable_new_address_output_mo <= '0';
    test_mem_small_bus_enable <= '1';
    test_mem_full_bus_enable <= '1';
    test_mem_small_bus_mode <= '1';
    test_mem_data_in_small_bus_mode <= (others => '0');
    test_mem_enable_write_small_bus_mode <= '0';
    test_mem_address_data_in_small_bus_mode <= (others => '0');
    test_mem_address_data_out_small_bus_mode <= (others => '0');
    wait for PERIOD;
    file_open(ram_file, test_filename, READ_MODE);
    readline (ram_file, line_n);
    read (line_n, number_of_tests);
    i := 0;
    if((maximum_number_of_tests /= 0) and (maximum_number_of_tests < number_of_tests)) then
        number_of_tests := maximum_number_of_tests;
    end if;
    while (i < (number_of_tests)) loop
        number_of_tests_per_iteration := -1;
        while ((i < (number_of_tests)) and (number_of_tests_per_iteration < 7)) loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_a(j) <= (others => '0');
                test_value_b(j) <= (others => '0');
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
                test_value_o(j+2**max_operands_size) <= (others => '0');
                true_value_o(j+2**max_operands_size) <= (others => '0');
            end loop;
            wait for PERIOD;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                test_value_a(j) <= read_operand_values;
            end loop;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                test_value_b(j) <= read_operand_values;
            end loop;
            for j in 0 to (2*operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                true_value_o(j) <= read_operand_values;
            end loop;
            wait for PERIOD;
            number_of_tests_per_iteration := number_of_tests_per_iteration + 1;
            current_operation_addres := std_logic_vector(to_unsigned(number_of_tests_per_iteration, current_operation_addres'length));
            load_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            load_operand_memory(test_value_b, current_operation_addres & "001", operands_size);
            load_operand_memory(true_value_o, current_operation_addres & "100", 2*operands_size);
            i := i + 1;
        end loop;
        wait for PERIOD;
        test_mem_small_bus_mode <= '0';
        wait for PERIOD;
        before_time := now;
        test_instruction_values_valid  <= '1';
        test_instruction_type <= "0000";
        test_operands_size <= std_logic_vector(to_unsigned(operands_size-1, max_operands_size));
        test_prime_line_equal_one  <= '0';
        test_load_new_address_prime <= X"00";
        test_load_new_address_prime_line <= X"00";
        test_load_new_address_prime_plus_one <= X"00";
        test_load_new_address_input_ma <= "00000" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00000" & "001";
        test_load_new_address_output_mo <= "00000" & "010";
        test_enable_new_address_output_mo <= '1';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00001" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00001" & "001";
        test_load_new_address_output_mo <= "00001" & "010";
        if(number_of_tests_per_iteration >= 1) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        test_instruction_values_valid  <= '0';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00010" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00010" & "001";
        test_load_new_address_output_mo <= "00010" & "010";
        if(number_of_tests_per_iteration >= 2) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00011" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00011" & "001";
        test_load_new_address_output_mo <= "00011" & "010";
        if(number_of_tests_per_iteration >= 3) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00100" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00100" & "001";
        test_load_new_address_output_mo <= "00100" & "010";
        if(number_of_tests_per_iteration >= 4) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00101" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00101" & "001";
        test_load_new_address_output_mo <= "00101" & "010";
        if(number_of_tests_per_iteration >= 5) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00110" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00110" & "001";
        test_load_new_address_output_mo <= "00110" & "010";
        if(number_of_tests_per_iteration >= 6) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00111" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00111" & "001";
        test_load_new_address_output_mo <= "00111" & "010";
        if(number_of_tests_per_iteration >= 7) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        wait until (test_free_flag = '1' and rising_edge(clk));
        wait for tb_delay;
        after_time := now;
        if(i <= 8) then
                report "Operands size = " & integer'image(operands_size) & " Operation time = " & integer'image((after_time - before_time)/(PERIOD)) & " cycles" severity note;
            end if;
        wait for PERIOD;
        test_mem_small_bus_mode <= '1';
        wait for PERIOD;
        for z in 0 to number_of_tests_per_iteration loop
            for j in 0 to (2*(2**max_operands_size)-1) loop
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
            end loop;
            current_operation_addres := std_logic_vector(to_unsigned(z, current_operation_addres'length));
            retrive_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            retrive_operand_memory(test_value_b, current_operation_addres & "001", operands_size);
            retrive_operand_memory(test_value_o, current_operation_addres & "010", 2*operands_size);
            retrive_operand_memory(true_value_o, current_operation_addres & "100", 2*operands_size);
            compare_operand_memory(operands_size, test_value_o, true_value_o);
            wait for PERIOD;
        end loop;
    end loop;
end test_multiplication_no_reduction;

procedure test_square_no_reduction(
test_filename : in string;
operands_size : in integer
) is 
FILE ram_file : text;
variable line_n : line;
variable number_of_tests : integer;
variable read_operand_values : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
variable i : integer;
variable number_of_tests_per_iteration : integer;
variable current_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable before_time, after_time : time;

begin
    for j in 0 to (2**max_operands_size-1) loop
        test_value_a(j) <= (others => '0');
        test_value_o(j) <= (others => '0');
        true_value_o(j) <= (others => '0');
        test_value_o(j+2**max_operands_size) <= (others => '0');
        true_value_o(j+2**max_operands_size) <= (others => '0');
    end loop;
    test_instruction_values_valid  <= '0';
    test_instruction_type <= (others => '0');
    test_operands_size <= (others => '0');
    test_prime_line_equal_one  <= '0';
    test_load_new_address_prime <= (others => '0');
    test_load_new_address_prime_line <= (others => '0');
    test_load_new_address_prime_plus_one <= (others => '0');
    test_load_new_address_input_ma <= (others => '0');
    test_load_new_sign_ma <= '0';
    test_load_new_address_input_mb <= (others => '0');
    test_load_new_address_output_mo <= (others => '0');
    test_enable_new_address_output_mo <= '0';
    test_mem_small_bus_enable <= '1';
    test_mem_full_bus_enable <= '1';
    test_mem_small_bus_mode <= '1';
    test_mem_data_in_small_bus_mode <= (others => '0');
    test_mem_enable_write_small_bus_mode <= '0';
    test_mem_address_data_in_small_bus_mode <= (others => '0');
    test_mem_address_data_out_small_bus_mode <= (others => '0');
    wait for PERIOD;
    file_open(ram_file, test_filename, READ_MODE);
    readline (ram_file, line_n);
    read (line_n, number_of_tests);
    i := 0;
    if((maximum_number_of_tests /= 0) and (maximum_number_of_tests < number_of_tests)) then
        number_of_tests := maximum_number_of_tests;
    end if;
    while (i < (number_of_tests)) loop
        number_of_tests_per_iteration := -1;
        while ((i < (number_of_tests)) and (number_of_tests_per_iteration < 7)) loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_a(j) <= (others => '0');
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
                test_value_o(j+2**max_operands_size) <= (others => '0');
                true_value_o(j+2**max_operands_size) <= (others => '0');
            end loop;
            wait for PERIOD;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                test_value_a(j) <= read_operand_values;
            end loop;
            for j in 0 to (2*operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                true_value_o(j) <= read_operand_values;
            end loop;
            wait for PERIOD;
            number_of_tests_per_iteration := number_of_tests_per_iteration + 1;
            current_operation_addres := std_logic_vector(to_unsigned(number_of_tests_per_iteration, current_operation_addres'length));
            load_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            load_operand_memory(true_value_o, current_operation_addres & "100", 2*operands_size);
            i := i + 1;
        end loop;
        wait for PERIOD;
        test_mem_small_bus_mode <= '0';
        wait for PERIOD;
        before_time := now;
        test_instruction_values_valid  <= '1';
        test_instruction_type <= "0001";
        test_operands_size <= std_logic_vector(to_unsigned(operands_size-1, max_operands_size));
        test_prime_line_equal_one  <= '0';
        test_load_new_address_prime <= X"00";
        test_load_new_address_prime_line <= X"00";
        test_load_new_address_prime_plus_one <= X"00";
        test_load_new_address_input_ma <= "00000" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00000" & "000";
        test_load_new_address_output_mo <= "00000" & "010";
        test_enable_new_address_output_mo <= '1';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00001" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00001" & "000";
        test_load_new_address_output_mo <= "00001" & "010";
        if(number_of_tests_per_iteration >= 1) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        test_instruction_values_valid  <= '0';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00010" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00010" & "000";
        test_load_new_address_output_mo <= "00010" & "010";
        if(number_of_tests_per_iteration >= 2) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00011" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00011" & "000";
        test_load_new_address_output_mo <= "00011" & "010";
        if(number_of_tests_per_iteration >= 3) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00100" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00100" & "000";
        test_load_new_address_output_mo <= "00100" & "010";
        if(number_of_tests_per_iteration >= 4) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00101" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00101" & "000";
        test_load_new_address_output_mo <= "00101" & "010";
        if(number_of_tests_per_iteration >= 5) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00110" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00110" & "000";
        test_load_new_address_output_mo <= "00110" & "010";
        if(number_of_tests_per_iteration >= 6) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00111" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00111" & "000";
        test_load_new_address_output_mo <= "00111" & "010";
        if(number_of_tests_per_iteration >= 7) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        wait until (test_free_flag = '1' and rising_edge(clk));
        wait for tb_delay;
        after_time := now;
        if(i <= 8) then
                report "Operands size = " & integer'image(operands_size) & " Operation time = " & integer'image((after_time - before_time)/(PERIOD)) & " cycles" severity note;
            end if;
        wait for PERIOD;
        test_mem_small_bus_mode <= '1';
        wait for PERIOD;
        for z in 0 to number_of_tests_per_iteration loop
            for j in 0 to (2*(2**max_operands_size)-1) loop
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
            end loop;
            current_operation_addres := std_logic_vector(to_unsigned(z, current_operation_addres'length));
            retrive_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            retrive_operand_memory(test_value_o, current_operation_addres & "010", 2*operands_size);
            retrive_operand_memory(true_value_o, current_operation_addres & "100", 2*operands_size);
            compare_operand_memory(operands_size, test_value_o, true_value_o);
            wait for PERIOD;
        end loop;
    end loop;
end test_square_no_reduction;

procedure test_montgomery_multiplication(
test_filename : in string;
operands_size : in integer
) is 
FILE ram_file : text;
variable line_n : line;
variable number_of_tests : integer;
variable read_operand_values : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
variable i : integer;
variable number_of_tests_per_iteration : integer;
variable current_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable constants_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable before_time, after_time : time;

begin
    for j in 0 to (2**max_operands_size-1) loop
        test_value_a(j) <= (others => '0');
        test_value_b(j) <= (others => '0');
        test_value_prime(j) <= (others => '0');
        test_value_prime_plus_one(j) <= (others => '0');
        test_value_prime_line(j) <= (others => '0');
        test_value_o(j) <= (others => '0');
        true_value_o(j) <= (others => '0');
    end loop;
    test_instruction_values_valid  <= '0';
    test_instruction_type <= (others => '0');
    test_operands_size <= (others => '0');
    test_prime_line_equal_one  <= '0';
    test_load_new_address_prime <= (others => '0');
    test_load_new_address_prime_line <= (others => '0');
    test_load_new_address_prime_plus_one <= (others => '0');
    test_load_new_address_input_ma <= (others => '0');
    test_load_new_sign_ma <= '0';
    test_load_new_address_input_mb <= (others => '0');
    test_load_new_address_output_mo <= (others => '0');
    test_enable_new_address_output_mo <= '0';
    test_mem_small_bus_enable <= '1';
    test_mem_full_bus_enable <= '1';
    test_mem_small_bus_mode <= '1';
    test_mem_data_in_small_bus_mode <= (others => '0');
    test_mem_enable_write_small_bus_mode <= '0';
    test_mem_address_data_in_small_bus_mode <= (others => '0');
    test_mem_address_data_out_small_bus_mode <= (others => '0');
    wait for PERIOD;
    file_open(ram_file, test_filename, READ_MODE);
    readline (ram_file, line_n);
    read (line_n, number_of_tests);
    if((maximum_number_of_tests /= 0) and (maximum_number_of_tests < number_of_tests)) then
        number_of_tests := maximum_number_of_tests;
    end if;
    for j in 0 to (2**max_operands_size-1) loop
        test_value_prime(j) <= (others => '0');
        test_value_prime_plus_one(j) <= (others => '0');
        test_value_prime_line(j) <= (others => '0');
    end loop;
    wait for PERIOD;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime(j) <= read_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime_plus_one(j) <= read_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime_line(j) <= read_operand_values;
    end loop;
    wait for PERIOD;
    constants_operation_addres := std_logic_vector(to_unsigned(8, constants_operation_addres'length));
    load_operand_memory(test_value_prime, constants_operation_addres & "000", operands_size);
    load_operand_memory(test_value_prime_plus_one, constants_operation_addres & "001", operands_size);
    load_operand_memory(test_value_prime_line, constants_operation_addres & "010", operands_size);
    i := 0;
    while (i < (number_of_tests)) loop
        number_of_tests_per_iteration := -1;
        while ((i < (number_of_tests)) and (number_of_tests_per_iteration < 7)) loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_a(j) <= (others => '0');
                test_value_b(j) <= (others => '0');
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
            end loop;
            wait for PERIOD;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                test_value_a(j) <= read_operand_values;
            end loop;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                test_value_b(j) <= read_operand_values;
            end loop;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                true_value_o(j) <= read_operand_values;
            end loop;
            wait for PERIOD;
            number_of_tests_per_iteration := number_of_tests_per_iteration + 1;
            current_operation_addres := std_logic_vector(to_unsigned(number_of_tests_per_iteration, current_operation_addres'length));
            load_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            load_operand_memory(test_value_b, current_operation_addres & "001", operands_size);
            load_operand_memory(true_value_o, current_operation_addres & "100", operands_size);
            i := i + 1;
        end loop;
        wait for PERIOD;
        test_mem_small_bus_mode <= '0';
        wait for PERIOD;
        before_time := now;
        test_instruction_values_valid  <= '1';
        test_instruction_type <= "0010";
        test_operands_size <= std_logic_vector(to_unsigned(operands_size-1, max_operands_size));
        test_prime_line_equal_one  <= '0';
        test_load_new_address_prime <= "01000" & "000";
        test_load_new_address_prime_line <= "01000" & "010";
        test_load_new_address_prime_plus_one <= "01000" & "001";
        test_load_new_address_input_ma <= "00000" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00000" & "001";
        test_load_new_address_output_mo <= "00000" & "010";
        test_enable_new_address_output_mo <= '1';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00001" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00001" & "001";
        test_load_new_address_output_mo <= "00001" & "010";
        if(number_of_tests_per_iteration >= 1) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        test_instruction_values_valid  <= '0';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00010" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00010" & "001";
        test_load_new_address_output_mo <= "00010" & "010";
        if(number_of_tests_per_iteration >= 2) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00011" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00011" & "001";
        test_load_new_address_output_mo <= "00011" & "010";
        if(number_of_tests_per_iteration >= 3) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00100" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00100" & "001";
        test_load_new_address_output_mo <= "00100" & "010";
        if(number_of_tests_per_iteration >= 4) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00101" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00101" & "001";
        test_load_new_address_output_mo <= "00101" & "010";
        if(number_of_tests_per_iteration >= 5) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00110" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00110" & "001";
        test_load_new_address_output_mo <= "00110" & "010";
        if(number_of_tests_per_iteration >= 6) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00111" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00111" & "001";
        test_load_new_address_output_mo <= "00111" & "010";
        if(number_of_tests_per_iteration >= 7) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        wait until (test_free_flag = '1' and rising_edge(clk));
        wait for tb_delay;
        after_time := now;
        if(i <= 8) then
                report "Operands size = " & integer'image(operands_size) & " Operation time = " & integer'image((after_time - before_time)/(PERIOD)) & " cycles" severity note;
            end if;
        wait for PERIOD;
        test_mem_small_bus_mode <= '1';
        wait for PERIOD;
        for z in 0 to number_of_tests_per_iteration loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
            end loop;
            current_operation_addres := std_logic_vector(to_unsigned(z, current_operation_addres'length));
            retrive_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            retrive_operand_memory(test_value_b, current_operation_addres & "001", operands_size);
            retrive_operand_memory(test_value_o, current_operation_addres & "010", operands_size);
            retrive_operand_memory(true_value_o, current_operation_addres & "100", operands_size);
            compare_operand_memory(operands_size, test_value_o, true_value_o);
            wait for PERIOD;
        end loop;
    end loop;
end test_montgomery_multiplication;

procedure test_special_montgomery_multiplication(
test_filename : in string;
operands_size : in integer
) is 
FILE ram_file : text;
variable line_n : line;
variable number_of_tests : integer;
variable read_operand_values : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
variable i : integer;
variable number_of_tests_per_iteration : integer;
variable current_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable constants_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable before_time, after_time : time;

begin
    for j in 0 to (2**max_operands_size-1) loop
        test_value_a(j) <= (others => '0');
        test_value_b(j) <= (others => '0');
        test_value_prime(j) <= (others => '0');
        test_value_prime_plus_one(j) <= (others => '0');
        test_value_prime_line(j) <= (others => '0');
        test_value_o(j) <= (others => '0');
        true_value_o(j) <= (others => '0');
    end loop;
    test_instruction_values_valid  <= '0';
    test_instruction_type <= (others => '0');
    test_operands_size <= (others => '0');
    test_prime_line_equal_one  <= '0';
    test_load_new_address_prime <= (others => '0');
    test_load_new_address_prime_line <= (others => '0');
    test_load_new_address_prime_plus_one <= (others => '0');
    test_load_new_address_input_ma <= (others => '0');
    test_load_new_sign_ma <= '0';
    test_load_new_address_input_mb <= (others => '0');
    test_load_new_address_output_mo <= (others => '0');
    test_enable_new_address_output_mo <= '0';
    test_mem_small_bus_enable <= '1';
    test_mem_full_bus_enable <= '1';
    test_mem_small_bus_mode <= '1';
    test_mem_data_in_small_bus_mode <= (others => '0');
    test_mem_enable_write_small_bus_mode <= '0';
    test_mem_address_data_in_small_bus_mode <= (others => '0');
    test_mem_address_data_out_small_bus_mode <= (others => '0');
    wait for PERIOD;
    file_open(ram_file, test_filename, READ_MODE);
    readline (ram_file, line_n);
    read (line_n, number_of_tests);
    if((maximum_number_of_tests /= 0) and (maximum_number_of_tests < number_of_tests)) then
        number_of_tests := maximum_number_of_tests;
    end if;
    for j in 0 to (2**max_operands_size-1) loop
        test_value_prime(j) <= (others => '0');
        test_value_prime_plus_one(j) <= (others => '0');
        test_value_prime_line(j) <= (others => '0');
    end loop;
    wait for PERIOD;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime(j) <= read_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime_plus_one(j) <= read_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime_line(j) <= read_operand_values;
    end loop;
    wait for PERIOD;
    constants_operation_addres := std_logic_vector(to_unsigned(8, constants_operation_addres'length));
    load_operand_memory(test_value_prime, constants_operation_addres & "000", operands_size);
    load_operand_memory(test_value_prime_plus_one, constants_operation_addres & "001", operands_size);
    load_operand_memory(test_value_prime_line, constants_operation_addres & "010", operands_size);
    i := 0;
    while (i < (number_of_tests)) loop
        number_of_tests_per_iteration := -1;
        while ((i < (number_of_tests)) and (number_of_tests_per_iteration < 7)) loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_a(j) <= (others => '0');
                test_value_b(j) <= (others => '0');
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
            end loop;
            wait for PERIOD;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                test_value_a(j) <= read_operand_values;
            end loop;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                test_value_b(j) <= read_operand_values;
            end loop;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                true_value_o(j) <= read_operand_values;
            end loop;
            wait for PERIOD;
            number_of_tests_per_iteration := number_of_tests_per_iteration + 1;
            current_operation_addres := std_logic_vector(to_unsigned(number_of_tests_per_iteration, current_operation_addres'length));
            load_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            load_operand_memory(test_value_b, current_operation_addres & "001", operands_size);
            load_operand_memory(true_value_o, current_operation_addres & "100", operands_size);
            i := i + 1;
        end loop;
        wait for PERIOD;
        test_mem_small_bus_mode <= '0';
        wait for PERIOD;
        before_time := now;
        test_instruction_values_valid  <= '1';
        test_prime_line_equal_one  <= '1';
        test_instruction_type <= "0010";
        test_operands_size <= std_logic_vector(to_unsigned(operands_size-1, max_operands_size));
        test_load_new_address_prime <= "01000" & "000";
        test_load_new_address_prime_line <= "01000" & "010";
        test_load_new_address_prime_plus_one <= "01000" & "001";
        test_load_new_address_input_ma <= "00000" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00000" & "001";
        test_load_new_address_output_mo <= "00000" & "010";
        test_enable_new_address_output_mo <= '1';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00001" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00001" & "001";
        test_load_new_address_output_mo <= "00001" & "010";
        if(number_of_tests_per_iteration >= 1) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        test_instruction_values_valid <= '0';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00010" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00010" & "001";
        test_load_new_address_output_mo <= "00010" & "010";
        if(number_of_tests_per_iteration >= 2) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00011" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00011" & "001";
        test_load_new_address_output_mo <= "00011" & "010";
        if(number_of_tests_per_iteration >= 3) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00100" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00100" & "001";
        test_load_new_address_output_mo <= "00100" & "010";
        if(number_of_tests_per_iteration >= 4) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00101" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00101" & "001";
        test_load_new_address_output_mo <= "00101" & "010";
        if(number_of_tests_per_iteration >= 5) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00110" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00110" & "001";
        test_load_new_address_output_mo <= "00110" & "010";
        if(number_of_tests_per_iteration >= 6) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00111" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00111" & "001";
        test_load_new_address_output_mo <= "00111" & "010";
        if(number_of_tests_per_iteration >= 7) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_instruction_values_valid  <= '0';
        wait until (test_free_flag = '1' and rising_edge(clk));
        wait for tb_delay;
        after_time := now;
        if(i <= 8) then
                report "Operands size = " & integer'image(operands_size) & " Operation time = " & integer'image((after_time - before_time)/(PERIOD)) & " cycles" severity note;
            end if;
        wait for PERIOD;
        test_mem_small_bus_mode <= '1';
        wait for PERIOD;
        for z in 0 to number_of_tests_per_iteration loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
            end loop;
            current_operation_addres := std_logic_vector(to_unsigned(z, current_operation_addres'length));
            retrive_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            retrive_operand_memory(test_value_b, current_operation_addres & "001", operands_size);
            retrive_operand_memory(test_value_o, current_operation_addres & "010", operands_size);
            retrive_operand_memory(true_value_o, current_operation_addres & "100", operands_size);
            compare_operand_memory(operands_size, test_value_o, true_value_o);
            wait for PERIOD;
        end loop;
    end loop;
end test_special_montgomery_multiplication;

procedure test_montgomery_squaring(
test_filename : in string;
operands_size : in integer
) is 
FILE ram_file : text;
variable line_n : line;
variable number_of_tests : integer;
variable read_operand_values : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
variable i : integer;
variable number_of_tests_per_iteration : integer;
variable current_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable constants_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable before_time, after_time : time;

begin
    for j in 0 to (2**max_operands_size-1) loop
        test_value_a(j) <= (others => '0');
        test_value_prime(j) <= (others => '0');
        test_value_prime_plus_one(j) <= (others => '0');
        test_value_prime_line(j) <= (others => '0');
        test_value_o(j) <= (others => '0');
        true_value_o(j) <= (others => '0');
    end loop;
    test_instruction_values_valid  <= '0';
    test_instruction_type <= (others => '0');
    test_operands_size <= (others => '0');
    test_prime_line_equal_one  <= '0';
    test_load_new_address_prime <= (others => '0');
    test_load_new_address_prime_line <= (others => '0');
    test_load_new_address_prime_plus_one <= (others => '0');
    test_load_new_address_input_ma <= (others => '0');
    test_load_new_sign_ma <= '0';
    test_load_new_address_input_mb <= (others => '0');
    test_load_new_address_output_mo <= (others => '0');
    test_enable_new_address_output_mo <= '0';
    test_mem_small_bus_enable <= '1';
    test_mem_full_bus_enable <= '1';
    test_mem_small_bus_mode <= '1';
    test_mem_data_in_small_bus_mode <= (others => '0');
    test_mem_enable_write_small_bus_mode <= '0';
    test_mem_address_data_in_small_bus_mode <= (others => '0');
    test_mem_address_data_out_small_bus_mode <= (others => '0');
    wait for PERIOD;
    file_open(ram_file, test_filename, READ_MODE);
    readline (ram_file, line_n);
    read (line_n, number_of_tests);
    if((maximum_number_of_tests /= 0) and (maximum_number_of_tests < number_of_tests)) then
        number_of_tests := maximum_number_of_tests;
    end if;
    for j in 0 to (2**max_operands_size-1) loop
        test_value_prime(j) <= (others => '0');
        test_value_prime_plus_one(j) <= (others => '0');
        test_value_prime_line(j) <= (others => '0');
    end loop;
    wait for PERIOD;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime(j) <= read_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime_plus_one(j) <= read_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime_line(j) <= read_operand_values;
    end loop;
    wait for PERIOD;
    constants_operation_addres := std_logic_vector(to_unsigned(8, constants_operation_addres'length));
    load_operand_memory(test_value_prime, constants_operation_addres & "000", operands_size);
    load_operand_memory(test_value_prime_plus_one, constants_operation_addres & "001", operands_size);
    load_operand_memory(test_value_prime_line, constants_operation_addres & "010", operands_size);
    i := 0;
    while (i < (number_of_tests)) loop
        number_of_tests_per_iteration := -1;
        while ((i < (number_of_tests)) and (number_of_tests_per_iteration < 7)) loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_a(j) <= (others => '0');
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
            end loop;
            wait for PERIOD;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                test_value_a(j) <= read_operand_values;
            end loop;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                true_value_o(j) <= read_operand_values;
            end loop;
            wait for PERIOD;
            number_of_tests_per_iteration := number_of_tests_per_iteration + 1;
            current_operation_addres := std_logic_vector(to_unsigned(number_of_tests_per_iteration, current_operation_addres'length));
            load_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            load_operand_memory(true_value_o, current_operation_addres & "100", operands_size);
            i := i + 1;
        end loop;
        wait for PERIOD;
        test_mem_small_bus_mode <= '0';
        wait for PERIOD;
        before_time := now;
        test_instruction_values_valid  <= '1';
        test_instruction_type <= "0011";
        test_operands_size <= std_logic_vector(to_unsigned(operands_size-1, max_operands_size));
        test_prime_line_equal_one  <= '0';
        test_load_new_address_prime <= "01000" & "000";
        test_load_new_address_prime_line <= "01000" & "010";
        test_load_new_address_prime_plus_one <= "01000" & "001";
        test_load_new_address_input_ma <= "00000" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00000" & "000";
        test_load_new_address_output_mo <= "00000" & "010";
        test_enable_new_address_output_mo <= '1';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00001" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00001" & "000";
        test_load_new_address_output_mo <= "00001" & "010";
        if(number_of_tests_per_iteration >= 1) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        test_instruction_values_valid  <= '0';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00010" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00010" & "000";
        test_load_new_address_output_mo <= "00010" & "010";
        if(number_of_tests_per_iteration >= 2) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00011" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00011" & "000";
        test_load_new_address_output_mo <= "00011" & "010";
        if(number_of_tests_per_iteration >= 3) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00100" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00100" & "000";
        test_load_new_address_output_mo <= "00100" & "010";
        if(number_of_tests_per_iteration >= 4) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00101" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00101" & "000";
        test_load_new_address_output_mo <= "00101" & "010";
        if(number_of_tests_per_iteration >= 5) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00110" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00110" & "000";
        test_load_new_address_output_mo <= "00110" & "010";
        if(number_of_tests_per_iteration >= 6) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00111" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00111" & "000";
        test_load_new_address_output_mo <= "00111" & "010";
        if(number_of_tests_per_iteration >= 7) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        wait until (test_free_flag = '1' and rising_edge(clk));
        wait for tb_delay;
        after_time := now;
        if(i <= 8) then
                report "Operands size = " & integer'image(operands_size) & " Operation time = " & integer'image((after_time - before_time)/(PERIOD)) & " cycles" severity note;
            end if;
        wait for PERIOD;
        test_mem_small_bus_mode <= '1';
        wait for PERIOD;
        for z in 0 to number_of_tests_per_iteration loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
            end loop;
            current_operation_addres := std_logic_vector(to_unsigned(z, current_operation_addres'length));
            retrive_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            retrive_operand_memory(test_value_o, current_operation_addres & "010", operands_size);
            retrive_operand_memory(true_value_o, current_operation_addres & "100", operands_size);
            compare_operand_memory(operands_size, test_value_o, true_value_o);
            wait for PERIOD;
        end loop;
    end loop;
end test_montgomery_squaring;

procedure test_special_montgomery_squaring(
test_filename : in string;
operands_size : in integer
) is 
FILE ram_file : text;
variable line_n : line;
variable number_of_tests : integer;
variable read_operand_values : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
variable i : integer;
variable number_of_tests_per_iteration : integer;
variable current_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable constants_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable before_time, after_time : time;

begin
    for j in 0 to (2**max_operands_size-1) loop
        test_value_a(j) <= (others => '0');
        test_value_prime(j) <= (others => '0');
        test_value_prime_plus_one(j) <= (others => '0');
        test_value_prime_line(j) <= (others => '0');
        test_value_o(j) <= (others => '0');
        true_value_o(j) <= (others => '0');
    end loop;
    test_instruction_values_valid  <= '0';
    test_instruction_type <= (others => '0');
    test_operands_size <= (others => '0');
    test_prime_line_equal_one  <= '0';
    test_load_new_address_prime <= (others => '0');
    test_load_new_address_prime_line <= (others => '0');
    test_load_new_address_prime_plus_one <= (others => '0');
    test_load_new_address_input_ma <= (others => '0');
    test_load_new_sign_ma <= '0';
    test_load_new_address_input_mb <= (others => '0');
    test_load_new_address_output_mo <= (others => '0');
    test_enable_new_address_output_mo <= '0';
    test_mem_small_bus_enable <= '1';
    test_mem_full_bus_enable <= '1';
    test_mem_small_bus_mode <= '1';
    test_mem_data_in_small_bus_mode <= (others => '0');
    test_mem_enable_write_small_bus_mode <= '0';
    test_mem_address_data_in_small_bus_mode <= (others => '0');
    test_mem_address_data_out_small_bus_mode <= (others => '0');
    wait for PERIOD;
    file_open(ram_file, test_filename, READ_MODE);
    readline (ram_file, line_n);
    read (line_n, number_of_tests);
    if((maximum_number_of_tests /= 0) and (maximum_number_of_tests < number_of_tests)) then
        number_of_tests := maximum_number_of_tests;
    end if;
    for j in 0 to (2**max_operands_size-1) loop
        test_value_prime(j) <= (others => '0');
        test_value_prime_plus_one(j) <= (others => '0');
        test_value_prime_line(j) <= (others => '0');
    end loop;
    wait for PERIOD;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime(j) <= read_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime_plus_one(j) <= read_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime_line(j) <= read_operand_values;
    end loop;
    wait for PERIOD;
    constants_operation_addres := std_logic_vector(to_unsigned(8, constants_operation_addres'length));
    load_operand_memory(test_value_prime, constants_operation_addres & "000", operands_size);
    load_operand_memory(test_value_prime_plus_one, constants_operation_addres & "001", operands_size);
    load_operand_memory(test_value_prime_line, constants_operation_addres & "010", operands_size);
    i := 0;
    while (i < (number_of_tests)) loop
        number_of_tests_per_iteration := -1;
        while ((i < (number_of_tests)) and (number_of_tests_per_iteration < 7)) loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_a(j) <= (others => '0');
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
            end loop;
            wait for PERIOD;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                test_value_a(j) <= read_operand_values;
            end loop;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                true_value_o(j) <= read_operand_values;
            end loop;
            wait for PERIOD;
            number_of_tests_per_iteration := number_of_tests_per_iteration + 1;
            current_operation_addres := std_logic_vector(to_unsigned(number_of_tests_per_iteration, current_operation_addres'length));
            load_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            load_operand_memory(true_value_o, current_operation_addres & "100", operands_size);
            i := i + 1;
        end loop;
        wait for PERIOD;
        test_mem_small_bus_mode <= '0';
        wait for PERIOD;
        before_time := now;
        test_instruction_values_valid  <= '1';
        test_instruction_type <= "0011";
        test_operands_size <= std_logic_vector(to_unsigned(operands_size-1, max_operands_size));
        test_prime_line_equal_one  <= '1';
        test_load_new_address_prime <= "01000" & "000";
        test_load_new_address_prime_line <= "01000" & "010";
        test_load_new_address_prime_plus_one <= "01000" & "001";
        test_load_new_address_input_ma <= "00000" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00000" & "000";
        test_load_new_address_output_mo <= "00000" & "010";
        test_enable_new_address_output_mo <= '1';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00001" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00001" & "000";
        test_load_new_address_output_mo <= "00001" & "010";
        if(number_of_tests_per_iteration >= 1) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        test_instruction_values_valid  <= '0';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00010" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00010" & "000";
        test_load_new_address_output_mo <= "00010" & "010";
        if(number_of_tests_per_iteration >= 2) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00011" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00011" & "000";
        test_load_new_address_output_mo <= "00011" & "010";
        if(number_of_tests_per_iteration >= 3) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00100" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00100" & "000";
        test_load_new_address_output_mo <= "00100" & "010";
        if(number_of_tests_per_iteration >= 4) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00101" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00101" & "000";
        test_load_new_address_output_mo <= "00101" & "010";
        if(number_of_tests_per_iteration >= 5) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00110" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00110" & "000";
        test_load_new_address_output_mo <= "00110" & "010";
        if(number_of_tests_per_iteration >= 6) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00111" & "000";
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= "00111" & "000";
        test_load_new_address_output_mo <= "00111" & "010";
        if(number_of_tests_per_iteration >= 7) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        wait until (test_free_flag = '1' and rising_edge(clk));
        wait for tb_delay;
        after_time := now;
        if(i <= 8) then
                report "Operands size = " & integer'image(operands_size) & " Operation time = " & integer'image((after_time - before_time)/(PERIOD)) & " cycles" severity note;
            end if;
        wait for PERIOD;
        test_mem_small_bus_mode <= '1';
        wait for PERIOD;
        for z in 0 to number_of_tests_per_iteration loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
            end loop;
            current_operation_addres := std_logic_vector(to_unsigned(z, current_operation_addres'length));
            retrive_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            retrive_operand_memory(test_value_o, current_operation_addres & "010", operands_size);
            retrive_operand_memory(true_value_o, current_operation_addres & "100", operands_size);
            compare_operand_memory(operands_size, test_value_o, true_value_o);
            wait for PERIOD;
        end loop;
    end loop;
end test_special_montgomery_squaring;

procedure test_addition_subtraction_no_reduction_single_test(
base_address_a : in std_logic_vector(2 downto 0);
base_address_b : in std_logic_vector(2 downto 0);
base_address_o : in std_logic_vector(2 downto 0);
sign_a : in std_logic;
operands_size : in integer;
number_of_tests_per_iteration : integer
) is
variable current_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
begin
    test_instruction_type <= "0100";
    test_operands_size <= std_logic_vector(to_unsigned(operands_size-1, max_operands_size));
    test_prime_line_equal_one  <= '0';
    test_load_new_address_prime <= "00000" & "000";
    test_load_new_address_prime_line <= "00000" & "000";
    test_load_new_address_prime_plus_one <= "00000" & "000";
    test_load_new_address_input_ma <= "00000" & base_address_a;
    test_load_new_sign_ma <= sign_a;
    test_load_new_address_input_mb <= "00000" & base_address_b;
    test_load_new_address_output_mo <= "00000" & base_address_o;
    test_enable_new_address_output_mo <= '1';
    wait for PERIOD;
    test_load_new_address_input_ma <= "00001" & base_address_a;
    test_load_new_sign_ma <= sign_a;
    test_load_new_address_input_mb <= "00001" & base_address_b;
    test_load_new_address_output_mo <= "00001" & base_address_o;
    if(number_of_tests_per_iteration >= 1) then
        test_enable_new_address_output_mo <= '1';
    else
        test_enable_new_address_output_mo <= '0';
    end if;
    test_instruction_values_valid  <= '0';
    wait for PERIOD;
    test_load_new_address_input_ma <= "00010" & base_address_a;
    test_load_new_sign_ma <= sign_a;
    test_load_new_address_input_mb <= "00010" & base_address_b;
    test_load_new_address_output_mo <= "00010" & base_address_o;
    if(number_of_tests_per_iteration >= 2) then
        test_enable_new_address_output_mo <= '1';
    else
        test_enable_new_address_output_mo <= '0';
    end if;
    wait for PERIOD;
    test_load_new_address_input_ma <= "00011" & base_address_a;
    test_load_new_sign_ma <= sign_a;
    test_load_new_address_input_mb <= "00011" & base_address_b;
    test_load_new_address_output_mo <= "00011" & base_address_o;
    if(number_of_tests_per_iteration >= 3) then
        test_enable_new_address_output_mo <= '1';
    else
        test_enable_new_address_output_mo <= '0';
    end if;
    wait for PERIOD;
end test_addition_subtraction_no_reduction_single_test;

procedure test_addition_subtraction_no_reduction(
test_filename : in string;
operands_size : in integer
) is 
FILE ram_file : text;
variable line_n : line;
variable number_of_tests : integer;
variable read_operand_values : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
variable i : integer;
variable number_of_tests_per_iteration : integer;
variable current_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable before_time, after_time : time;

begin
    for j in 0 to (2**max_operands_size-1) loop
        test_value_a(j) <= (others => '0');
        test_value_b(j) <= (others => '0');
        test_value_o(j) <= (others => '0');
        test_value_o_2(j) <= (others => '0');
        test_value_o_3(j) <= (others => '0');
        true_value_o(j) <= (others => '0');
        true_value_o_2(j) <= (others => '0');
        true_value_o_3(j) <= (others => '0');
    end loop;
    test_instruction_values_valid  <= '0';
    test_instruction_type <= (others => '0');
    test_operands_size <= (others => '0');
    test_prime_line_equal_one  <= '0';
    test_load_new_address_prime <= (others => '0');
    test_load_new_address_prime_line <= (others => '0');
    test_load_new_address_input_ma <= (others => '0');
    test_load_new_sign_ma <= '0';
    test_load_new_address_input_mb <= (others => '0');
    test_load_new_address_output_mo <= (others => '0');
    test_enable_new_address_output_mo <= '0';
    test_mem_small_bus_enable <= '1';
    test_mem_full_bus_enable <= '1';
    test_mem_small_bus_mode <= '1';
    test_mem_data_in_small_bus_mode <= (others => '0');
    test_mem_enable_write_small_bus_mode <= '0';
    test_mem_address_data_in_small_bus_mode <= (others => '0');
    test_mem_address_data_out_small_bus_mode <= (others => '0');
    wait for PERIOD;
    file_open(ram_file, test_filename, READ_MODE);
    readline (ram_file, line_n);
    read (line_n, number_of_tests);
    i := 0;
    if((maximum_number_of_tests /= 0) and (maximum_number_of_tests < number_of_tests)) then
        number_of_tests := maximum_number_of_tests;
    end if;
    while (i < (number_of_tests)) loop
        number_of_tests_per_iteration := -1;
        while ((i < (number_of_tests)) and (number_of_tests_per_iteration < 3)) loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_a(j) <= (others => '0');
                test_value_b(j) <= (others => '0');
                test_value_o(j) <= (others => '0');
                test_value_o_2(j) <= (others => '0');
                test_value_o_3(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
                true_value_o_2(j) <= (others => '0');
                true_value_o_3(j) <= (others => '0');
            end loop;
            wait for PERIOD;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                test_value_a(j) <= read_operand_values;
            end loop;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                test_value_b(j) <= read_operand_values;
            end loop;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                true_value_o(j) <= read_operand_values;
            end loop;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                true_value_o_2(j) <= read_operand_values;
            end loop;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                true_value_o_3(j) <= read_operand_values;
            end loop;
            wait for PERIOD;
            number_of_tests_per_iteration := number_of_tests_per_iteration + 1;
            current_operation_addres := std_logic_vector(to_unsigned(number_of_tests_per_iteration, current_operation_addres'length));
            load_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            load_operand_memory(test_value_b, current_operation_addres & "001", operands_size);
            load_operand_memory(true_value_o, current_operation_addres & "101", operands_size);
            load_operand_memory(true_value_o_2, current_operation_addres & "110", operands_size);
            load_operand_memory(true_value_o_3, current_operation_addres & "111", operands_size);
            i := i + 1;
        end loop;
        wait for PERIOD;
        
        test_mem_small_bus_mode <= '0';
        wait for PERIOD;
        before_time := now;
        test_instruction_values_valid  <= '1';
        test_addition_subtraction_no_reduction_single_test("000", "001", "010", '1', operands_size, number_of_tests_per_iteration);
        wait until (test_free_flag = '1' and rising_edge(clk));
        wait for tb_delay;
        after_time := now;
        if(i <= 4) then
                report "Operands size = " & integer'image(operands_size) & " Operation time = " & integer'image((after_time - before_time)/(PERIOD)) & " cycles" severity note;
            end if;
        wait for PERIOD;
        
        test_instruction_values_valid  <= '1';
        test_addition_subtraction_no_reduction_single_test("000", "001", "011", '0', operands_size, number_of_tests_per_iteration);
        wait until (test_free_flag = '1' and rising_edge(clk));
        wait for tb_delay;
        wait for PERIOD;
        
        test_instruction_values_valid  <= '1';
        test_addition_subtraction_no_reduction_single_test("001", "000", "100", '0', operands_size, number_of_tests_per_iteration);
        wait until (test_free_flag = '1' and rising_edge(clk));
        wait for tb_delay;
        wait for PERIOD;
        
        test_mem_small_bus_mode <= '1';
        wait for PERIOD;
        for z in 0 to number_of_tests_per_iteration loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_o(j) <= (others => '0');
                test_value_o_2(j) <= (others => '0');
                test_value_o_3(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
                true_value_o_2(j) <= (others => '0');
                true_value_o_3(j) <= (others => '0');
            end loop;
            current_operation_addres := std_logic_vector(to_unsigned(z, current_operation_addres'length));
            retrive_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            retrive_operand_memory(test_value_b, current_operation_addres & "001", operands_size);
            retrive_operand_memory(test_value_o, current_operation_addres & "010", operands_size);
            retrive_operand_memory(test_value_o_2, current_operation_addres & "011", operands_size);
            retrive_operand_memory(test_value_o_3, current_operation_addres & "100", operands_size);
            retrive_operand_memory(true_value_o, current_operation_addres & "101", operands_size);
            retrive_operand_memory(true_value_o_2, current_operation_addres & "110", operands_size);
            retrive_operand_memory(true_value_o_3, current_operation_addres & "111", operands_size);
            compare_operand_memory(operands_size, test_value_o, true_value_o);
            wait for PERIOD;
            compare_operand_memory(operands_size, test_value_o_2, true_value_o_2);
            wait for PERIOD;
            compare_operand_memory(operands_size, test_value_o_3, true_value_o_3);
            wait for PERIOD;
        end loop;
    end loop;
end test_addition_subtraction_no_reduction;

procedure test_iterative_modular_reduction(
test_filename : in string;
operands_size : in integer
) is 
FILE ram_file : text;
variable line_n : line;
variable number_of_tests : integer;
variable read_operand_values : std_logic_vector((multiplication_factor*base_word_size - 1) downto 0);
variable i : integer;
variable number_of_tests_per_iteration : integer;
variable current_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable constants_operation_addres : std_logic_vector((memory_address_size - 6) downto 0);
variable before_time, after_time : time;
begin
    for j in 0 to (2**max_operands_size-1) loop
        test_value_a(j) <= (others => '0');
        test_value_b(j) <= (others => '0');
        test_value_prime(j) <= (others => '0');
        test_value_prime_plus_one(j) <= (others => '0');
        test_value_prime_line(j) <= (others => '0');
        test_value_o(j) <= (others => '0');
        test_value_o_2(j) <= (others => '0');
        test_value_o_3(j) <= (others => '0');
        true_value_o(j) <= (others => '0');
        true_value_o_2(j) <= (others => '0');
        true_value_o_3(j) <= (others => '0');
    end loop;
    test_instruction_values_valid  <= '0';
    test_instruction_type <= (others => '0');
    test_operands_size <= (others => '0');
    test_prime_line_equal_one  <= '0';
    test_load_new_address_prime <= (others => '0');
    test_load_new_address_prime_line <= (others => '0');
    test_load_new_address_input_ma <= (others => '0');
    test_load_new_sign_ma <= '0';
    test_load_new_address_input_mb <= (others => '0');
    test_load_new_address_output_mo <= (others => '0');
    test_enable_new_address_output_mo <= '0';
    test_mem_small_bus_enable <= '1';
    test_mem_full_bus_enable <= '1';
    test_mem_small_bus_mode <= '1';
    test_mem_data_in_small_bus_mode <= (others => '0');
    test_mem_enable_write_small_bus_mode <= '0';
    test_mem_address_data_in_small_bus_mode <= (others => '0');
    test_mem_address_data_out_small_bus_mode <= (others => '0');
    wait for PERIOD;
    file_open(ram_file, test_filename, READ_MODE);
    readline (ram_file, line_n);
    read (line_n, number_of_tests);
    if((maximum_number_of_tests /= 0) and (maximum_number_of_tests < number_of_tests)) then
        number_of_tests := maximum_number_of_tests;
    end if;
    for j in 0 to (2**max_operands_size-1) loop
        test_value_prime(j) <= (others => '0');
        test_value_prime_plus_one(j) <= (others => '0');
        test_value_prime_line(j) <= (others => '0');
    end loop;
    wait for PERIOD;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime(j) <= read_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime_plus_one(j) <= read_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_operand_values);
        test_value_prime_line(j) <= read_operand_values;
    end loop;
    wait for PERIOD;
    constants_operation_addres := std_logic_vector(to_unsigned(4, constants_operation_addres'length));
    load_operand_memory(test_value_prime, constants_operation_addres & "000", operands_size);
    load_operand_memory(test_value_prime_plus_one, constants_operation_addres & "001", operands_size);
    load_operand_memory(test_value_prime_line, constants_operation_addres & "010", operands_size);
    i := 0;
    while (i < (number_of_tests)) loop
        number_of_tests_per_iteration := -1;
        while ((i < (number_of_tests)) and (number_of_tests_per_iteration < 3)) loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_a(j) <= (others => '0');
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
            end loop;
            wait for PERIOD;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                test_value_a(j) <= read_operand_values;
            end loop;
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_operand_values);
                true_value_o(j) <= read_operand_values;
            end loop;
            wait for PERIOD;
            number_of_tests_per_iteration := number_of_tests_per_iteration + 1;
            current_operation_addres := std_logic_vector(to_unsigned(number_of_tests_per_iteration, current_operation_addres'length));
            load_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            load_operand_memory(true_value_o, current_operation_addres & "101", operands_size);
            i := i + 1;
        end loop;
        wait for PERIOD;
        test_mem_small_bus_mode <= '0';
        wait for PERIOD;
        before_time := now;
        test_instruction_values_valid  <= '1';
        test_instruction_type <= "0101";
        test_operands_size <= std_logic_vector(to_unsigned(operands_size-1, max_operands_size));
        test_prime_line_equal_one  <= '0';
        test_load_new_address_prime <= "00100" & "000";
        test_load_new_address_prime_line <= "00100" & "010";
        test_load_new_address_prime_plus_one <= "00100" & "001";
        test_load_new_address_input_ma <= "00000" & "000";
        test_load_new_sign_ma <= '1';
        test_load_new_address_input_mb <= "00000" & "000";
        test_load_new_address_output_mo <= "00000" & "010";
        test_enable_new_address_output_mo <= '1';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00001" & "000";
        test_load_new_sign_ma <= '1';
        test_load_new_address_input_mb <= "00001" & "000";
        test_load_new_address_output_mo <= "00001" & "010";
        if(number_of_tests_per_iteration >= 1) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        test_instruction_values_valid  <= '0';
        wait for PERIOD;
        test_load_new_address_input_ma <= "00010" & "000";
        test_load_new_sign_ma <= '1';
        test_load_new_address_input_mb <= "00010" & "000";
        test_load_new_address_output_mo <= "00010" & "010";
        if(number_of_tests_per_iteration >= 2) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        test_load_new_address_input_ma <= "00011" & "000";
        test_load_new_sign_ma <= '1';
        test_load_new_address_input_mb <= "00011" & "000";
        test_load_new_address_output_mo <= "00011" & "010";
        if(number_of_tests_per_iteration >= 3) then
            test_enable_new_address_output_mo <= '1';
        else
            test_enable_new_address_output_mo <= '0';
        end if;
        wait for PERIOD;
        wait until (test_free_flag = '1' and rising_edge(clk));
        wait for tb_delay;
        after_time := now;
        if(i <= 4) then
                report "Operands size = " & integer'image(operands_size) & " Operation time = " & integer'image((after_time - before_time)/(PERIOD)) & " cycles" severity note;
            end if;
        wait for PERIOD;
        
        test_mem_small_bus_mode <= '1';
        wait for PERIOD;
        for z in 0 to number_of_tests_per_iteration loop
            for j in 0 to (2**max_operands_size-1) loop
                test_value_o(j) <= (others => '0');
                true_value_o(j) <= (others => '0');
            end loop;
            current_operation_addres := std_logic_vector(to_unsigned(z, current_operation_addres'length));
            retrive_operand_memory(test_value_a, current_operation_addres & "000", operands_size);
            retrive_operand_memory(test_value_o, current_operation_addres & "010", operands_size);
            retrive_operand_memory(true_value_o, current_operation_addres & "101", operands_size);
            compare_operand_memory(operands_size, test_value_o, true_value_o);
            wait for PERIOD;
        end loop;
    end loop;
end test_iterative_modular_reduction;

    begin  
        test_error <= '0';
        test_verification <= '0';
        for j in 0 to (2**max_operands_size-1) loop
            test_value_a(j) <= (others => '0');
            test_value_b(j) <= (others => '0');
            test_value_prime(j) <= (others => '0');
            test_value_prime_line(j) <= (others => '0');
            test_value_prime_plus_one(j) <= (others => '0');
            test_value_o(j) <= (others => '0');
            true_value_o(j) <= (others => '0');
            test_value_o(j+2**max_operands_size) <= (others => '0');
            true_value_o(j+2**max_operands_size) <= (others => '0');
        end loop;
        test_rstn <= '0';
        test_instruction_values_valid  <= '0';
        test_instruction_type <= (others => '0');
        test_operands_size <= (others => '0');
        test_prime_line_equal_one  <= '0';
        test_load_new_address_prime <= (others => '0');
        test_load_new_address_prime_line <= (others => '0');
        test_load_new_address_input_ma <= (others => '0');
        test_load_new_sign_ma <= '0';
        test_load_new_address_input_mb <= (others => '0');
        test_load_new_address_output_mo <= (others => '0');
        test_enable_new_address_output_mo <= '0';
        test_mem_small_bus_enable <= '1';
        test_mem_full_bus_enable <= '1';
        test_mem_small_bus_mode <= '1';
        test_mem_data_in_small_bus_mode <= (others => '0');
        test_mem_enable_write_small_bus_mode <= '0';
        test_mem_address_data_in_small_bus_mode <= (others => '0');
        test_mem_address_data_out_small_bus_mode <= (others => '0');
        wait for PERIOD*4;
        wait for tb_delay;
        test_rstn <= '1';
        wait for PERIOD;
        report "Start multiplication with no reduction test." severity note;
        test_multiplication_no_reduction(test_memory_file_multiplication_no_reduction_test_4_3, 1);
        wait for PERIOD;
        test_multiplication_no_reduction(test_memory_file_multiplication_no_reduction_test_216_137, 2);
        wait for PERIOD;
        test_multiplication_no_reduction(test_memory_file_multiplication_no_reduction_test_250_159, 3);
        wait for PERIOD;
        test_multiplication_no_reduction(test_memory_file_multiplication_no_reduction_test_305_192, 3);
        wait for PERIOD;
        test_multiplication_no_reduction(test_memory_file_multiplication_no_reduction_test_372_239, 3);
        wait for PERIOD;
        test_multiplication_no_reduction(test_memory_file_multiplication_no_reduction_test_486_301, 4);
        wait for PERIOD;
        test_multiplication_no_reduction(test_memory_file_multiplication_no_reduction_test_240_max, 1);
        wait for PERIOD;
        test_multiplication_no_reduction(test_memory_file_multiplication_no_reduction_test_496_max, 2);
        wait for PERIOD;
        test_multiplication_no_reduction(test_memory_file_multiplication_no_reduction_test_752_max, 3);
        wait for PERIOD;
        test_multiplication_no_reduction(test_memory_file_multiplication_no_reduction_test_1008_max, 4);
        wait for PERIOD;
        report "End of the multiplication with no reduction test." severity note;
        wait for PERIOD;
        report "Start square with no reduction test." severity note;
        test_square_no_reduction(test_memory_file_square_no_reduction_test_4_3, 1);
        wait for PERIOD;
        test_square_no_reduction(test_memory_file_square_no_reduction_test_216_137, 2);
        wait for PERIOD;
        test_square_no_reduction(test_memory_file_square_no_reduction_test_250_159, 3);
        wait for PERIOD;
        test_square_no_reduction(test_memory_file_square_no_reduction_test_305_192, 3);
        wait for PERIOD;
        test_square_no_reduction(test_memory_file_square_no_reduction_test_372_239, 3);
        wait for PERIOD;
        test_square_no_reduction(test_memory_file_square_no_reduction_test_486_301, 4);
        wait for PERIOD;
        test_square_no_reduction(test_memory_file_square_no_reduction_test_240_max, 1);
        wait for PERIOD;
        test_square_no_reduction(test_memory_file_square_no_reduction_test_496_max, 2);
        wait for PERIOD;
        test_square_no_reduction(test_memory_file_square_no_reduction_test_752_max, 3);
        wait for PERIOD;
        test_square_no_reduction(test_memory_file_square_no_reduction_test_1008_max, 4);
        wait for PERIOD;
        report "End of the square no reduction test." severity note;
        wait for PERIOD;
        report "Start Montgomery multiplication test." severity note;
        test_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_4_3, 1);
        wait for PERIOD;
        test_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_216_137, 2);
        wait for PERIOD;
        test_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_250_159, 3);
        wait for PERIOD;
        test_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_305_192, 3);
        wait for PERIOD;
        test_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_372_239, 3);
        wait for PERIOD;
        test_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_486_301, 4);
        wait for PERIOD;
        test_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_240_max, 1);
        wait for PERIOD;
        test_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_496_max, 2);
        wait for PERIOD;
        test_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_752_max, 3);
        wait for PERIOD;
        test_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_1008_max, 4);
        wait for PERIOD;
        report "End of the Montgomery multiplication test." severity note;
        wait for PERIOD;
        report "Start special Montgomery multiplication test." severity note;
        test_special_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_305_192, 3);
        wait for PERIOD;
        test_special_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_372_239, 3);
        wait for PERIOD;
        test_special_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_486_301, 4);
        wait for PERIOD;
        test_special_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_496_max, 2);
        wait for PERIOD;
        test_special_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_752_max, 3);
        wait for PERIOD;
        test_special_montgomery_multiplication(test_memory_file_montgomery_multiplication_test_1008_max, 4);
        wait for PERIOD;
        report "End of the special Montgomery multiplication test." severity note;
        wait for PERIOD;
        report "Start Montgomery square test." severity note;
        test_montgomery_squaring(test_memory_file_montgomery_squaring_test_4_3, 1);
        wait for PERIOD;
        test_montgomery_squaring(test_memory_file_montgomery_squaring_test_216_137, 2);
        wait for PERIOD;
        test_montgomery_squaring(test_memory_file_montgomery_squaring_test_250_159, 3);
        wait for PERIOD;
        test_montgomery_squaring(test_memory_file_montgomery_squaring_test_305_192, 3);
        wait for PERIOD;
        test_montgomery_squaring(test_memory_file_montgomery_squaring_test_372_239, 3);
        wait for PERIOD;
        test_montgomery_squaring(test_memory_file_montgomery_squaring_test_486_301, 4);
        wait for PERIOD;
        test_montgomery_squaring(test_memory_file_montgomery_squaring_test_240_max, 1);
        wait for PERIOD;
        test_montgomery_squaring(test_memory_file_montgomery_squaring_test_496_max, 2);
        wait for PERIOD;
        test_montgomery_squaring(test_memory_file_montgomery_squaring_test_752_max, 3);
        wait for PERIOD;
        test_montgomery_squaring(test_memory_file_montgomery_squaring_test_1008_max, 4);
        wait for PERIOD;
        report "End of the Montgomery square test." severity note;
        report "Start special Montgomery square test." severity note;
        test_special_montgomery_squaring(test_memory_file_montgomery_squaring_test_305_192, 3);
        wait for PERIOD;
        test_special_montgomery_squaring(test_memory_file_montgomery_squaring_test_372_239, 3);
        wait for PERIOD;
        test_special_montgomery_squaring(test_memory_file_montgomery_squaring_test_486_301, 4);
        wait for PERIOD;
        test_special_montgomery_squaring(test_memory_file_montgomery_squaring_test_496_max, 2);
        wait for PERIOD;
        test_special_montgomery_squaring(test_memory_file_montgomery_squaring_test_752_max, 3);
        wait for PERIOD;
        test_special_montgomery_squaring(test_memory_file_montgomery_squaring_test_1008_max, 4);
        wait for PERIOD;
        report "End of the special Montgomery square test." severity note;
        wait for PERIOD;
        report "Start addition/subtraction no reduction test." severity note;
        test_addition_subtraction_no_reduction(test_memory_file_addition_subtraction_no_reduction_test_4_3, 1);
        wait for PERIOD;
        test_addition_subtraction_no_reduction(test_memory_file_addition_subtraction_no_reduction_test_216_137, 2);
        wait for PERIOD;
        test_addition_subtraction_no_reduction(test_memory_file_addition_subtraction_no_reduction_test_250_159, 3);
        wait for PERIOD;
        test_addition_subtraction_no_reduction(test_memory_file_addition_subtraction_no_reduction_test_305_192, 3);
        wait for PERIOD;
        test_addition_subtraction_no_reduction(test_memory_file_addition_subtraction_no_reduction_test_372_239, 3);
        wait for PERIOD;
        test_addition_subtraction_no_reduction(test_memory_file_addition_subtraction_no_reduction_test_486_301, 4);
        wait for PERIOD;
        test_addition_subtraction_no_reduction(test_memory_file_addition_subtraction_no_reduction_test_240_max, 1);
        wait for PERIOD;
        test_addition_subtraction_no_reduction(test_memory_file_addition_subtraction_no_reduction_test_496_max, 2);
        wait for PERIOD;
        test_addition_subtraction_no_reduction(test_memory_file_addition_subtraction_no_reduction_test_752_max, 3);
        wait for PERIOD;
        test_addition_subtraction_no_reduction(test_memory_file_addition_subtraction_no_reduction_test_1008_max, 4);
        wait for PERIOD;
        report "End of the addition/subtraction no reduction test." severity note;
        wait for PERIOD;
        report "Start iterative modular reduction test." severity note;
        test_iterative_modular_reduction(test_memory_file_iterative_modular_reduction_test_4_3, 1);
        wait for PERIOD;
        test_iterative_modular_reduction(test_memory_file_iterative_modular_reduction_test_216_137, 2);
        wait for PERIOD;
        test_iterative_modular_reduction(test_memory_file_iterative_modular_reduction_test_250_159, 3);
        wait for PERIOD;
        test_iterative_modular_reduction(test_memory_file_iterative_modular_reduction_test_305_192, 3);
        wait for PERIOD;
        test_iterative_modular_reduction(test_memory_file_iterative_modular_reduction_test_372_239, 3);
        wait for PERIOD;
        test_iterative_modular_reduction(test_memory_file_iterative_modular_reduction_test_486_301, 4);
        wait for PERIOD;
        test_iterative_modular_reduction(test_memory_file_iterative_modular_reduction_test_240_max, 1);
        wait for PERIOD;
        test_iterative_modular_reduction(test_memory_file_iterative_modular_reduction_test_496_max, 2);
        wait for PERIOD;
        test_iterative_modular_reduction(test_memory_file_iterative_modular_reduction_test_752_max, 3);
        wait for PERIOD;
        test_iterative_modular_reduction(test_memory_file_iterative_modular_reduction_test_1008_max, 4);
        wait for PERIOD;
        report "End of the iterative modular reduction test." severity note;
        wait for PERIOD;
        report "End of all tests." severity note;
        test_bench_finish <= true;
        wait;
end process;

end behavioral;