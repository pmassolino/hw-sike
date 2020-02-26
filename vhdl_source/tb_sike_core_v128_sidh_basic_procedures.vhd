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

entity tb_sike_core_v128_sidh_basic_procedures is
Generic(
    PERIOD : time := 1000 ns;
    mac_base_wide_adder_size : integer := 2;
    mac_base_word_size : integer := 16;
    mac_multiplication_factor : integer := 8;
    mac_multiplication_factor_log2 : integer := 3;
    mac_accumulator_extra_bits : integer := 32;
    mac_memory_address_size : integer := 11;
    mac_max_operands_size : integer := 3;
    prom_memory_size : integer := 11;
    prom_instruction_size : integer := 64;
    base_alu_ram_memory_size : integer := 10;
    base_alu_rotation_level : integer := 4;
    rd_ram_memory_size : integer := 5;
    maximum_number_of_tests : integer := 1;
    
    skip_fp_inv_test : boolean := true;
    skip_fp2_inv_test : boolean := true;
    skip_j_inv_test : boolean := true;
    skip_get_A_test : boolean := true;
    skip_inv_2_way_test : boolean := true;
    skip_ladder_3_pt_test : boolean := false;
    skip_xDBLe_test : boolean := false;
    skip_get_4_isog_test : boolean := false;
    skip_eval_4_isog_test : boolean := false;
    skip_xTPLe_test : boolean := false;
    skip_get_3_isog_test : boolean := false;
    skip_eval_3_isog_test : boolean := false;
    skip_get_2_isog_test : boolean := false;
    skip_eval_2_isog_test : boolean := false;
    
    test_prom_file : string := "../assembler/test_sidh_basic_procedures_v128.dat";
    
    test_program_start_fp_inv_test : integer := 1;
    test_program_number_inputs_fp_inv_test : integer := 2;
    test_program_number_outputs_fp_inv_test : integer := 2;
    test_memory_file_fp_inv_test_8_5 : string := "../hw_sidh_tests_v128/fp_inv_test_8_5.dat";
    test_memory_file_fp_inv_test_216_137 : string := "../hw_sidh_tests_v128/fp_inv_test_216_137.dat";
    test_memory_file_fp_inv_test_250_159 : string := "../hw_sidh_tests_v128/fp_inv_test_250_159.dat";
    test_memory_file_fp_inv_test_305_192 : string := "../hw_sidh_tests_v128/fp_inv_test_305_192.dat";
    test_memory_file_fp_inv_test_372_239 : string := "../hw_sidh_tests_v128/fp_inv_test_372_239.dat";
    test_memory_file_fp_inv_test_486_301 : string := "../hw_sidh_tests_v128/fp_inv_test_486_301.dat";
    
    test_program_start_fp2_inv_test : integer := 25;
    test_program_number_inputs_fp2_inv_test : integer := 4;
    test_program_number_outputs_fp2_inv_test : integer := 4;
    test_memory_file_fp2_inv_test_8_5 : string := "../hw_sidh_tests_v128/fp2_inv_test_8_5.dat";
    test_memory_file_fp2_inv_test_216_137 : string := "../hw_sidh_tests_v128/fp2_inv_test_216_137.dat";
    test_memory_file_fp2_inv_test_250_159 : string := "../hw_sidh_tests_v128/fp2_inv_test_250_159.dat";
    test_memory_file_fp2_inv_test_305_192 : string := "../hw_sidh_tests_v128/fp2_inv_test_305_192.dat";
    test_memory_file_fp2_inv_test_372_239 : string := "../hw_sidh_tests_v128/fp2_inv_test_372_239.dat";
    test_memory_file_fp2_inv_test_486_301 : string := "../hw_sidh_tests_v128/fp2_inv_test_486_301.dat";
    
    test_program_start_j_inv_test : integer := 53;
    test_program_number_inputs_j_inv_test : integer := 4;
    test_program_number_outputs_j_inv_test : integer := 2;
    test_memory_file_j_inv_test_8_5 : string := "../hw_sidh_tests_v128/j_inv_test_8_5.dat";
    test_memory_file_j_inv_test_216_137 : string := "../hw_sidh_tests_v128/j_inv_test_216_137.dat";
    test_memory_file_j_inv_test_250_159 : string := "../hw_sidh_tests_v128/j_inv_test_250_159.dat";
    test_memory_file_j_inv_test_305_192 : string := "../hw_sidh_tests_v128/j_inv_test_305_192.dat";
    test_memory_file_j_inv_test_372_239 : string := "../hw_sidh_tests_v128/j_inv_test_372_239.dat";
    test_memory_file_j_inv_test_486_301 : string := "../hw_sidh_tests_v128/j_inv_test_486_301.dat";
    
    test_program_start_get_A_test : integer := 79;
    test_program_number_inputs_get_A_test : integer := 6;
    test_program_number_outputs_get_A_test : integer := 2;
    test_memory_file_get_A_test_8_5 : string := "../hw_sidh_tests_v128/get_A_test_8_5.dat";
    test_memory_file_get_A_test_216_137 : string := "../hw_sidh_tests_v128/get_A_test_216_137.dat";
    test_memory_file_get_A_test_250_159 : string := "../hw_sidh_tests_v128/get_A_test_250_159.dat";
    test_memory_file_get_A_test_305_192 : string := "../hw_sidh_tests_v128/get_A_test_305_192.dat";
    test_memory_file_get_A_test_372_239 : string := "../hw_sidh_tests_v128/get_A_test_372_239.dat";
    test_memory_file_get_A_test_486_301 : string := "../hw_sidh_tests_v128/get_A_test_486_301.dat";
    
    test_program_start_inv_2_way_test : integer := 107;
    test_program_number_inputs_inv_2_way_test : integer := 8;
    test_program_number_outputs_inv_2_way_test : integer := 8;
    test_memory_file_inv_2_way_test_8_5 : string := "../hw_sidh_tests_v128/inv_2_way_test_8_5.dat";
    test_memory_file_inv_2_way_test_216_137 : string := "../hw_sidh_tests_v128/inv_2_way_test_216_137.dat";
    test_memory_file_inv_2_way_test_250_159 : string := "../hw_sidh_tests_v128/inv_2_way_test_250_159.dat";
    test_memory_file_inv_2_way_test_305_192 : string := "../hw_sidh_tests_v128/inv_2_way_test_305_192.dat";
    test_memory_file_inv_2_way_test_372_239 : string := "../hw_sidh_tests_v128/inv_2_way_test_372_239.dat";
    test_memory_file_inv_2_way_test_486_301 : string := "../hw_sidh_tests_v128/inv_2_way_test_486_301.dat";
    
    test_program_start_ladder_3_pt_test : integer := 143;
    test_program_number_inputs_ladder_3_pt_test : integer := 10;
    test_program_number_outputs_ladder_3_pt_test : integer := 4;
    test_memory_file_ladder_3_pt_test_8_5_oa_bits : string := "../hw_sidh_tests_v128/ladder_3_pt_test_8_5_oa_bits.dat";
    test_memory_file_ladder_3_pt_test_216_137_oa_bits : string := "../hw_sidh_tests_v128/ladder_3_pt_test_216_137_oa_bits.dat";
    test_memory_file_ladder_3_pt_test_250_159_oa_bits : string := "../hw_sidh_tests_v128/ladder_3_pt_test_250_159_oa_bits.dat";
    test_memory_file_ladder_3_pt_test_305_192_oa_bits : string := "../hw_sidh_tests_v128/ladder_3_pt_test_305_192_oa_bits.dat";
    test_memory_file_ladder_3_pt_test_372_239_oa_bits : string := "../hw_sidh_tests_v128/ladder_3_pt_test_372_239_oa_bits.dat";
    test_memory_file_ladder_3_pt_test_486_301_oa_bits : string := "../hw_sidh_tests_v128/ladder_3_pt_test_486_301_oa_bits.dat";
    test_memory_file_ladder_3_pt_test_8_5_ob_bits : string := "../hw_sidh_tests_v128/ladder_3_pt_test_8_5_ob_bits.dat";
    test_memory_file_ladder_3_pt_test_216_137_ob_bits : string := "../hw_sidh_tests_v128/ladder_3_pt_test_216_137_ob_bits.dat";
    test_memory_file_ladder_3_pt_test_250_159_ob_bits : string := "../hw_sidh_tests_v128/ladder_3_pt_test_250_159_ob_bits.dat";
    test_memory_file_ladder_3_pt_test_305_192_ob_bits : string := "../hw_sidh_tests_v128/ladder_3_pt_test_305_192_ob_bits.dat";
    test_memory_file_ladder_3_pt_test_372_239_ob_bits : string := "../hw_sidh_tests_v128/ladder_3_pt_test_372_239_ob_bits.dat";
    test_memory_file_ladder_3_pt_test_486_301_ob_bits : string := "../hw_sidh_tests_v128/ladder_3_pt_test_486_301_ob_bits.dat";
    
    test_program_start_xDBLe_test : integer := 175;
    test_program_number_inputs_xDBLe_test : integer := 9;
    test_program_number_outputs_xDBLe_test : integer := 4;
    test_memory_file_xDBLe_test_8_5 : string := "../hw_sidh_tests_v128/xDBLe_test_8_5.dat";
    test_memory_file_xDBLe_test_216_137 : string := "../hw_sidh_tests_v128/xDBLe_test_216_137.dat";
    test_memory_file_xDBLe_test_250_159 : string := "../hw_sidh_tests_v128/xDBLe_test_250_159.dat";
    test_memory_file_xDBLe_test_305_192 : string := "../hw_sidh_tests_v128/xDBLe_test_305_192.dat";
    test_memory_file_xDBLe_test_372_239 : string := "../hw_sidh_tests_v128/xDBLe_test_372_239.dat";
    test_memory_file_xDBLe_test_486_301 : string := "../hw_sidh_tests_v128/xDBLe_test_486_301.dat";
    
    test_program_start_get_4_isog_test : integer := 207;
    test_program_number_inputs_get_4_isog_test : integer := 4;
    test_program_number_outputs_get_4_isog_test : integer := 10;
    test_memory_file_get_4_isog_test_8_5 : string := "../hw_sidh_tests_v128/get_4_isog_test_8_5.dat";
    test_memory_file_get_4_isog_test_216_137 : string := "../hw_sidh_tests_v128/get_4_isog_test_216_137.dat";
    test_memory_file_get_4_isog_test_250_159 : string := "../hw_sidh_tests_v128/get_4_isog_test_250_159.dat";
    test_memory_file_get_4_isog_test_305_192 : string := "../hw_sidh_tests_v128/get_4_isog_test_305_192.dat";
    test_memory_file_get_4_isog_test_372_239 : string := "../hw_sidh_tests_v128/get_4_isog_test_372_239.dat";
    test_memory_file_get_4_isog_test_486_301 : string := "../hw_sidh_tests_v128/get_4_isog_test_486_301.dat";
    
    test_program_start_eval_4_isog_test : integer := 249;
    test_program_number_inputs_eval_4_isog_test : integer := 10;
    test_program_number_outputs_eval_4_isog_test : integer := 4;
    test_memory_file_eval_4_isog_test_8_5 : string := "../hw_sidh_tests_v128/eval_4_isog_test_8_5.dat";
    test_memory_file_eval_4_isog_test_216_137 : string := "../hw_sidh_tests_v128/eval_4_isog_test_216_137.dat";
    test_memory_file_eval_4_isog_test_250_159 : string := "../hw_sidh_tests_v128/eval_4_isog_test_250_159.dat";
    test_memory_file_eval_4_isog_test_305_192 : string := "../hw_sidh_tests_v128/eval_4_isog_test_305_192.dat";
    test_memory_file_eval_4_isog_test_372_239 : string := "../hw_sidh_tests_v128/eval_4_isog_test_372_239.dat";
    test_memory_file_eval_4_isog_test_486_301 : string := "../hw_sidh_tests_v128/eval_4_isog_test_486_301.dat";
    
    test_program_start_xTPLe_test : integer := 291;
    test_program_number_inputs_xTPLe_test : integer := 9;
    test_program_number_outputs_xTPLe_test : integer := 4;
    test_memory_file_xTPLe_test_8_5 : string := "../hw_sidh_tests_v128/xTPLe_test_8_5.dat";
    test_memory_file_xTPLe_test_250_159 : string := "../hw_sidh_tests_v128/xTPLe_test_250_159.dat";
    test_memory_file_xTPLe_test_216_137 : string := "../hw_sidh_tests_v128/xTPLe_test_216_137.dat";
    test_memory_file_xTPLe_test_305_192 : string := "../hw_sidh_tests_v128/xTPLe_test_305_192.dat";
    test_memory_file_xTPLe_test_372_239 : string := "../hw_sidh_tests_v128/xTPLe_test_372_239.dat";
    test_memory_file_xTPLe_test_486_301 : string := "../hw_sidh_tests_v128/xTPLe_test_486_301.dat";
    
    test_program_start_get_3_isog_test : integer := 323;
    test_program_number_inputs_get_3_isog_test : integer := 4;
    test_program_number_outputs_get_3_isog_test : integer := 8;
    test_memory_file_get_3_isog_test_8_5 : string := "../hw_sidh_tests_v128/get_3_isog_test_8_5.dat";
    test_memory_file_get_3_isog_test_250_159 : string := "../hw_sidh_tests_v128/get_3_isog_test_250_159.dat";
    test_memory_file_get_3_isog_test_216_137 : string := "../hw_sidh_tests_v128/get_3_isog_test_216_137.dat";
    test_memory_file_get_3_isog_test_305_192 : string := "../hw_sidh_tests_v128/get_3_isog_test_305_192.dat";
    test_memory_file_get_3_isog_test_372_239 : string := "../hw_sidh_tests_v128/get_3_isog_test_372_239.dat";
    test_memory_file_get_3_isog_test_486_301 : string := "../hw_sidh_tests_v128/get_3_isog_test_486_301.dat";
    
    test_program_start_eval_3_isog_test : integer := 355;
    test_program_number_inputs_eval_3_isog_test : integer := 8;
    test_program_number_outputs_eval_3_isog_test : integer := 4;
    test_memory_file_eval_3_isog_test_8_5 : string := "../hw_sidh_tests_v128/eval_3_isog_test_8_5.dat";
    test_memory_file_eval_3_isog_test_250_159 : string := "../hw_sidh_tests_v128/eval_3_isog_test_250_159.dat";
    test_memory_file_eval_3_isog_test_216_137 : string := "../hw_sidh_tests_v128/eval_3_isog_test_216_137.dat";
    test_memory_file_eval_3_isog_test_305_192 : string := "../hw_sidh_tests_v128/eval_3_isog_test_305_192.dat";
    test_memory_file_eval_3_isog_test_372_239 : string := "../hw_sidh_tests_v128/eval_3_isog_test_372_239.dat";
    test_memory_file_eval_3_isog_test_486_301 : string := "../hw_sidh_tests_v128/eval_3_isog_test_486_301.dat";
    
    test_program_start_get_2_isog_test : integer := 387;
    test_program_number_inputs_get_2_isog_test : integer := 4;
    test_program_number_outputs_get_2_isog_test : integer := 4;
    test_memory_file_get_2_isog_test_8_5 : string := "../hw_sidh_tests_v128/get_2_isog_test_8_5.dat";
    test_memory_file_get_2_isog_test_250_159 : string := "../hw_sidh_tests_v128/get_2_isog_test_250_159.dat";
    test_memory_file_get_2_isog_test_216_137 : string := "../hw_sidh_tests_v128/get_2_isog_test_216_137.dat";
    test_memory_file_get_2_isog_test_305_192 : string := "../hw_sidh_tests_v128/get_2_isog_test_305_192.dat";
    test_memory_file_get_2_isog_test_372_239 : string := "../hw_sidh_tests_v128/get_2_isog_test_372_239.dat";
    test_memory_file_get_2_isog_test_486_301 : string := "../hw_sidh_tests_v128/get_2_isog_test_486_301.dat";
    
    test_program_start_eval_2_isog_test : integer := 415;
    test_program_number_inputs_eval_2_isog_test : integer := 8;
    test_program_number_outputs_eval_2_isog_test : integer := 4;
    test_memory_file_eval_2_isog_test_8_5 : string := "../hw_sidh_tests_v128/eval_2_isog_test_8_5.dat";
    test_memory_file_eval_2_isog_test_250_159 : string := "../hw_sidh_tests_v128/eval_2_isog_test_250_159.dat";
    test_memory_file_eval_2_isog_test_216_137 : string := "../hw_sidh_tests_v128/eval_2_isog_test_216_137.dat";
    test_memory_file_eval_2_isog_test_305_192 : string := "../hw_sidh_tests_v128/eval_2_isog_test_305_192.dat";
    test_memory_file_eval_2_isog_test_372_239 : string := "../hw_sidh_tests_v128/eval_2_isog_test_372_239.dat";
    test_memory_file_eval_2_isog_test_486_301 : string := "../hw_sidh_tests_v128/eval_2_isog_test_486_301.dat"
    
);
end tb_sike_core_v128_sidh_basic_procedures;

architecture behavioral of tb_sike_core_v128_sidh_basic_procedures is

component sike_core_v128
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
end component;

signal test_rstn : std_logic;
signal test_enable : std_logic;
signal test_data_in : std_logic_vector((mac_base_word_size - 1) downto 0);
signal test_data_in_valid : std_logic;
signal test_address_data_in_out : std_logic_vector((mac_base_word_size - 1) downto 0);
signal test_prom_address_region : std_logic;
signal test_write_enable : std_logic;
signal test_data_out : std_logic_vector((mac_base_word_size - 1) downto 0);
signal test_data_out_valid : std_logic;
signal test_core_free : std_logic;
signal test_flag : std_logic;

signal test_error : std_logic := '0';
signal test_verification : std_logic := '0';
signal clk : std_logic := '1';
signal test_bench_finish : boolean := false;

constant tb_delay : time := (PERIOD/2);

constant mac_ram_start_address : integer                   := 16#00000#;
constant mac_ram_last_address : integer                    := 16#07FFF#;
constant base_alu_ram_start_address : integer              := 16#0C000#;
constant base_alu_ram_last_address : integer               := 16#0C3FF#;
constant keccak_start_address : integer                    := 16#0D000#;
constant keccak_last_address : integer                     := 16#0D1FF#;
constant reg_program_counter_address : integer             := 16#0E000#;
constant reg_status_address : integer                      := 16#0E001#;
constant reg_operands_size_address : integer               := 16#0E002#;
constant reg_prime_line_equal_one_address : integer        := 16#0E003#;
constant reg_prime_address_address : integer               := 16#0E004#;
constant reg_prime_plus_one_address_address : integer      := 16#0E005#;
constant reg_prime_line_address_address : integer          := 16#0E006#;
constant reg_initial_stack_address_address : integer       := 16#0E007#;
constant reg_flag_address : integer                        := 16#0E008#;
constant reg_scalar_address_address : integer              := 16#0E009#;

constant mac_ram_prime_address : integer                   := 16#00000#;
constant mac_ram_prime_plus_one_address : integer          := 16#00001#;
constant mac_ram_prime_line_address : integer              := 16#00002#;
constant mac_ram_const_r_address : integer                 := 16#00003#;
constant mac_ram_const_r2_address : integer                := 16#00004#;
constant mac_ram_const_1_address : integer                 := 16#00005#;
constant mac_ram_inv_4_mont_address : integer              := 16#00006#;
constant mac_ram_sidh_xpa_mont_address : integer           := 16#00007#;
constant mac_ram_sidh_xpai_mont_address : integer          := 16#00008#;
constant mac_ram_sidh_xqa_mont_address : integer           := 16#00009#;
constant mac_ram_sidh_xqai_mont_address : integer          := 16#0000A#;
constant mac_ram_sidh_xra_mont_address : integer           := 16#0000B#;
constant mac_ram_sidh_xrai_mont_address : integer          := 16#0000C#;
constant mac_ram_sidh_xpb_mont_address : integer           := 16#0000D#;
constant mac_ram_sidh_xpbi_mont_address : integer          := 16#0000E#;
constant mac_ram_sidh_xqb_mont_address : integer           := 16#0000F#;
constant mac_ram_sidh_xqbi_mont_address : integer          := 16#00010#;
constant mac_ram_sidh_xrb_mont_address : integer           := 16#00011#;
constant mac_ram_sidh_xrbi_mont_address : integer          := 16#00012#;

constant mac_ram_input_function_start_address : integer    := 16#00014#;
constant mac_ram_output_function_start_address : integer   := 16#00024#;

constant base_ram_oa_bits_address : integer                := 16#0019F#;
constant base_ram_ob_bits_address : integer                := 16#001A0#;
constant base_ram_prime_size_bits_address : integer        := 16#001A1#;
constant base_ram_splits_alice_start_address : integer     := 16#001A2#;
constant base_ram_max_row_alice_address : integer          := 16#002D0#;
constant base_ram_splits_bob_start_address : integer       := 16#002D1#;
constant base_ram_max_row_bob_address : integer            := 16#003FF#;

type tests_prom is array(natural range <>) of std_logic_vector((prom_instruction_size - 1) downto 0);
type tests_base_ula_ram is array(natural range <>) of std_logic_vector((mac_base_word_size - 1) downto 0);

signal buffer_test_value_communication_mac_ram : std_logic_vector((mac_multiplication_factor*(mac_base_word_size) - 1) downto 0);
signal buffer_test_value_communication_prom : std_logic_vector((prom_instruction_size - 1) downto 0);
signal buffer_test_value_communication_base_alu_ram : std_logic_vector((mac_base_word_size - 1) downto 0);

type mac_ram_values_array is array (natural range <>) of std_logic_vector((mac_multiplication_factor*(mac_base_word_size) - 1) downto 0);
type base_ram_values_array is array (natural range <>) of std_logic_vector((mac_base_word_size - 1) downto 0);
type procedure_input_operands_values_array is array (0 to 15) of mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);
type procedure_output_operands_values_array is array (0 to 7) of mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);

signal external_prom : tests_prom((2**prom_memory_size - 1) downto 0);

signal test_values_input : procedure_input_operands_values_array;
signal test_values_output : procedure_input_operands_values_array;
signal true_values_output : procedure_input_operands_values_array;

signal temp_value_to_load1 : mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);
signal temp_value_to_load2 : mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);

signal test_value_prime : mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);
signal test_value_prime_line : mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);
signal test_value_prime_plus_one : mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);
signal test_value_constant_r : mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);
signal test_value_constant_r2 : mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);
signal test_value_constant_1 : mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);
signal test_value_constant_inv_4_mont : mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);
signal test_value_prime_size_bits : std_logic_vector((mac_base_word_size - 1) downto 0);
signal test_value_o1 : mac_ram_values_array((2*(2**mac_max_operands_size) - 1) downto 0);
signal test_value_o1i : mac_ram_values_array((2*(2**mac_max_operands_size) - 1) downto 0);
signal test_value_o2 : mac_ram_values_array((2*(2**mac_max_operands_size) - 1) downto 0);
signal test_value_o2i : mac_ram_values_array((2*(2**mac_max_operands_size) - 1) downto 0);
signal true_value_o1 : mac_ram_values_array((2*(2**mac_max_operands_size) - 1) downto 0);
signal true_value_o1i : mac_ram_values_array((2*(2**mac_max_operands_size) - 1) downto 0);
signal true_value_o2 : mac_ram_values_array((2*(2**mac_max_operands_size) - 1) downto 0);
signal true_value_o2i : mac_ram_values_array((2*(2**mac_max_operands_size) - 1) downto 0);

begin

test : sike_core_v128
    Port Map(
        rstn => test_rstn,
        clk => clk,
        enable => test_enable,
        data_in => test_data_in,
        data_in_valid => test_data_in_valid,
        address_data_in_out => test_address_data_in_out,
        prom_address_region => test_prom_address_region,
        write_enable => test_write_enable,
        data_out => test_data_out,
        data_out_valid => test_data_out_valid,
        core_free => test_core_free,
        flag => test_flag
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

procedure load_value_device_base_alu_internal_registers(
signal value_loaded : in std_logic_vector((mac_base_word_size - 1) downto 0);
address_to_load : in std_logic_vector((mac_base_word_size - 1) downto 0)
) is
begin
    test_enable <= '1';
    test_data_in <= (others => '0');
    test_data_in_valid <= '0';
    test_address_data_in_out <= address_to_load;
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
    test_data_in <= value_loaded;
    test_data_in_valid <= '1';
    test_write_enable <= '1';
    wait for PERIOD;
    test_enable <= '0';
    test_data_in <= (others => '0');
    test_data_in_valid <= '0';
    test_address_data_in_out <= (others => '0');
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
end load_value_device_base_alu_internal_registers;

procedure retrieve_value_device_base_ula_internal_registers(
signal value_retrieved : out std_logic_vector((mac_base_word_size - 1) downto 0);
address_to_retrieve : in std_logic_vector((mac_base_word_size - 1) downto 0)
) is
begin
    test_enable <= '1';
    test_address_data_in_out <= address_to_retrieve;
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
    while(test_data_out_valid /= '1') loop
        wait for PERIOD;
    end loop;
    value_retrieved <= test_data_out;
    test_enable <= '0';
    test_address_data_in_out <= (others => '0');
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
end retrieve_value_device_base_ula_internal_registers;

procedure load_array_device_base_alu_internal_registers(
signal array_loaded : in base_ram_values_array;
address_to_load : in std_logic_vector((mac_base_word_size - 1) downto 0);
array_loaded_length : in integer
) is
begin
    test_enable <= '1';
    test_data_in <= (others => '0');
    test_data_in_valid <= '0';
    test_address_data_in_out <= (others => '0');
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
    for j in 0 to (array_loaded_length - 1) loop
        test_data_in <= array_loaded(j);
        test_data_in_valid <= '1';
        test_write_enable <= '1';
        test_address_data_in_out <= std_logic_vector(unsigned(address_to_load) + to_unsigned(j, address_to_load'length));
        wait for PERIOD;
    end loop;
    test_enable <= '0';
    test_data_in <= (others => '0');
    test_data_in_valid <= '0';
    test_address_data_in_out <= (others => '0');
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
end load_array_device_base_alu_internal_registers;

procedure retrieve_array_device_base_ula_internal_registers(
signal value_retrieved : out base_ram_values_array;
address_to_retrieve : in std_logic_vector((mac_base_word_size - 1) downto 0);
array_retrieved_length : in integer
) is
begin
    test_enable <= '1';
    test_address_data_in_out <= address_to_retrieve;
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
    for j in 0 to (array_retrieved_length - 1) loop
        while(test_data_out_valid /= '1') loop
            wait for PERIOD;
        end loop;
        value_retrieved(j) <= test_data_out;
        test_address_data_in_out <= std_logic_vector(unsigned(address_to_retrieve) + to_unsigned(j + 1, address_to_retrieve'length));
        wait for PERIOD;
    end loop;
    test_enable <= '0';
    test_address_data_in_out <= (others => '0');
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
end retrieve_array_device_base_ula_internal_registers;

procedure load_value_device_mac_ram(
signal value_loaded : in std_logic_vector((mac_multiplication_factor*(mac_base_word_size) - 1) downto 0);
address_to_load : in std_logic_vector((mac_base_word_size - 1) downto 0)
) is
begin
    test_enable <= '1';
    test_data_in <= (others => '0');
    test_data_in_valid <= '0';
    test_address_data_in_out <= (others => '0');
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
    for i in 0 to (mac_multiplication_factor-1) loop
        test_address_data_in_out <= std_logic_vector(unsigned(address_to_load) + to_unsigned(i, address_to_load'length));
        test_data_in <= value_loaded((((i+1)*(mac_base_word_size)) - 1) downto (i*(mac_base_word_size)));
        test_write_enable <= '0';
        test_data_in_valid <= '0';
        wait for PERIOD;
        test_write_enable <= '1';
        test_data_in_valid <= '1';
        wait for PERIOD;
    end loop;
    test_enable <= '0';
    test_data_in <= (others => '0');
    test_data_in_valid <= '0';
    test_address_data_in_out <= (others => '0');
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
end load_value_device_mac_ram;

procedure retrieve_value_device_mac_ram(
signal value_retrieved : out std_logic_vector((mac_multiplication_factor*(mac_base_word_size) - 1) downto 0);
address_to_retrieve : in std_logic_vector((mac_base_word_size - 1) downto 0)
) is
variable i : integer;
begin
    i:= 0;
    test_enable <= '1';
    test_address_data_in_out <= std_logic_vector(unsigned(address_to_retrieve) + to_unsigned(i, address_to_retrieve'length));
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
    while(i < mac_multiplication_factor) loop
        if(test_data_out_valid = '1') then
            value_retrieved((((i+1)*(mac_base_word_size)) - 1) downto (i*(mac_base_word_size))) <= test_data_out;
            i := i + 1;
            test_address_data_in_out <= std_logic_vector(unsigned(address_to_retrieve) + to_unsigned(i, address_to_retrieve'length));
        end if;
        wait for PERIOD;
    end loop;
    test_enable <= '0';
    test_address_data_in_out <= (others => '0');
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
end retrieve_value_device_mac_ram;

procedure load_value_device_prom(
signal value_loaded : in std_logic_vector((prom_instruction_size - 1) downto 0);
address_to_load : in std_logic_vector((mac_base_word_size - 1) downto 0)
) is
begin
    test_enable <= '1';
    test_data_in <= (others => '0');
    test_data_in_valid <= '0';
    test_address_data_in_out <= (others => '0');
    test_prom_address_region <= '1';
    test_write_enable <= '0';
    wait for PERIOD;
    for i in 0 to 3 loop
        test_address_data_in_out <= std_logic_vector(unsigned(address_to_load) + to_unsigned(i, address_to_load'length));
        test_data_in <= value_loaded((((i+1)*(mac_base_word_size)) - 1) downto (i*(mac_base_word_size)));
        test_write_enable <= '0';
        test_data_in_valid <= '0';
        wait for PERIOD;
        test_write_enable <= '1';
        test_data_in_valid <= '1';
        wait for PERIOD;
    end loop;
    test_enable <= '0';
    test_data_in <= (others => '0');
    test_data_in_valid <= '0';
    test_address_data_in_out <= (others => '0');
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
end load_value_device_prom;

procedure retrieve_value_device_prom(
signal value_retrieved : out std_logic_vector((prom_instruction_size - 1) downto 0);
address_to_retrieve : in std_logic_vector((mac_base_word_size - 1) downto 0)
) is
variable i : integer;
begin
    i:= 0;
    test_enable <= '1';
    test_address_data_in_out <= std_logic_vector(unsigned(address_to_retrieve) + to_unsigned(i, address_to_retrieve'length));
    test_prom_address_region <= '1';
    test_write_enable <= '0';
    wait for PERIOD;
    while(i < 4) loop
        if(test_data_out_valid = '1') then
            value_retrieved((((i+1)*(mac_base_word_size)) - 1) downto (i*(mac_base_word_size))) <= test_data_out;
            i := i + 1;
            test_address_data_in_out <= std_logic_vector(unsigned(address_to_retrieve) + to_unsigned(i, address_to_retrieve'length));
        end if;
        wait for PERIOD;
    end loop;
    test_enable <= '0';
    test_address_data_in_out <= (others => '0');
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
end retrieve_value_device_prom;

procedure load_program_device_prom(
signal load_program : in tests_prom;
program_base_address : integer
) is
variable i : integer;
variable j : integer;
variable current_address : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    i := 0;
    j := 0;
    while(j < load_program'length) loop
        buffer_test_value_communication_prom <= load_program(j);
        current_address := std_logic_vector(to_unsigned(program_base_address + i, current_address'length));
        wait for PERIOD;
        load_value_device_prom(buffer_test_value_communication_prom, current_address);
        i := i + 4;
        j := j + 1;
    end loop;
end load_program_device_prom;

procedure load_operand_mac_ram(
signal value_to_load : in mac_ram_values_array;
base_address : in std_logic_vector((mac_base_word_size - 1) downto 0);
operands_size : in integer
) is
variable current_address : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    for i in 0 to (operands_size - 1) loop
        buffer_test_value_communication_mac_ram <= value_to_load(i);
        current_address := std_logic_vector(unsigned(base_address) + to_unsigned(i*mac_multiplication_factor, current_address'length));
        wait for PERIOD;
        load_value_device_mac_ram(buffer_test_value_communication_mac_ram, current_address);
    end loop;
    wait for PERIOD;
end load_operand_mac_ram;

procedure retrieve_operand_mac_ram(
signal value_to_retrive : out mac_ram_values_array;
base_address : in std_logic_vector((mac_base_word_size - 1) downto 0);
operands_size : in integer
) is
variable current_address : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    for i in 0 to (operands_size - 1) loop
        current_address := std_logic_vector(unsigned(base_address) + to_unsigned(i*mac_multiplication_factor, current_address'length));
        retrieve_value_device_mac_ram(buffer_test_value_communication_mac_ram, current_address);
        wait for PERIOD;
        value_to_retrive(i) <= buffer_test_value_communication_mac_ram;
    end loop;
    wait for PERIOD;
end retrieve_operand_mac_ram;

procedure compare_operand_mac_ram(
operands_size : in integer;
signal value_computed : in mac_ram_values_array;
signal value_true : in mac_ram_values_array
) is
variable is_equal : boolean;
begin
    is_equal := true;
    test_error <= '0';
    test_verification <= '1';
    wait for PERIOD;
    for i in 0 to (operands_size - 1) loop
        if(value_computed(i) /= value_true(i)) then
            is_equal := false;
        end if;
    end loop;
    if(not is_equal) then
        test_error <= '1';
        report "Error found during test";
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_error <= '0';
    test_verification <= '0';
    wait for PERIOD;
end compare_operand_mac_ram;

procedure test_function(
test_filename : in string;
operands_size : in integer;
procedure_start_address : in integer;
prime_line_equal_one : in integer;
number_of_inputs : in integer;
number_of_outputs : in integer
) is 
FILE ram_file : text;
variable line_n : line;
variable number_of_tests : integer;
variable read_MAC_RAM_operand_values : std_logic_vector((mac_multiplication_factor*(mac_base_word_size) - 1) downto 0);
variable read_BASE_RAM_operand_values : std_logic_vector((mac_base_word_size - 1) downto 0);
variable i : integer;
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
variable before_time, after_time : time;
begin
    test_error <= '0';
    test_verification <= '0';
    test_rstn <= '1';
    test_enable <= '0';
    test_data_in <= (others => '0');
    test_data_in_valid <= '0';
    test_address_data_in_out <= (others => '0');
    test_prom_address_region <= '0';
    test_write_enable <= '0';
    wait for PERIOD;
    file_open(ram_file, test_filename, READ_MODE);
    readline (ram_file, line_n);
    read (line_n, number_of_tests);
    
    if((maximum_number_of_tests /= 0) and (maximum_number_of_tests < number_of_tests)) then
        number_of_tests := maximum_number_of_tests;
    end if;
    for j in 0 to (2**mac_max_operands_size - 1) loop
        test_value_prime(j) <= (others => '0');
        test_value_prime_plus_one(j) <= (others => '0');
        test_value_prime_line(j) <= (others => '0');
        test_value_constant_r(j) <= (others => '0');
        test_value_constant_r2(j) <= (others => '0');
        test_value_constant_1(j) <= (others => '0');
        test_value_constant_inv_4_mont(j) <= (others => '0');
    end loop;
    test_value_prime_size_bits <= (others => '0');
    wait for PERIOD;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_MAC_RAM_operand_values);
        test_value_prime(j) <= read_MAC_RAM_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_MAC_RAM_operand_values);
        test_value_prime_plus_one(j) <= read_MAC_RAM_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_MAC_RAM_operand_values);
        test_value_prime_line(j) <= read_MAC_RAM_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_MAC_RAM_operand_values);
        test_value_constant_r(j) <= read_MAC_RAM_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_MAC_RAM_operand_values);
        test_value_constant_r2(j) <= read_MAC_RAM_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_MAC_RAM_operand_values);
        test_value_constant_1(j) <= read_MAC_RAM_operand_values;
    end loop;
    for j in 0 to (operands_size-1) loop
        readline (ram_file, line_n);
        read (line_n, read_MAC_RAM_operand_values);
        test_value_constant_inv_4_mont(j) <= read_MAC_RAM_operand_values;
    end loop;
    readline (ram_file, line_n);
    read (line_n, read_BASE_RAM_operand_values);
    test_value_prime_size_bits <= read_BASE_RAM_operand_values;
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned((mac_ram_prime_address)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    load_operand_mac_ram(test_value_prime, current_operation_addres, operands_size);
    current_operation_addres := std_logic_vector(to_unsigned((mac_ram_prime_plus_one_address)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    load_operand_mac_ram(test_value_prime_plus_one, current_operation_addres, operands_size);
    current_operation_addres := std_logic_vector(to_unsigned((mac_ram_prime_line_address)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    load_operand_mac_ram(test_value_prime_line, current_operation_addres, operands_size);
    current_operation_addres := std_logic_vector(to_unsigned((mac_ram_const_r_address)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    load_operand_mac_ram(test_value_constant_r, current_operation_addres, operands_size);
    current_operation_addres := std_logic_vector(to_unsigned((mac_ram_const_r2_address)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    load_operand_mac_ram(test_value_constant_r2, current_operation_addres, operands_size);
    current_operation_addres := std_logic_vector(to_unsigned((mac_ram_const_1_address)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    load_operand_mac_ram(test_value_constant_1, current_operation_addres, operands_size);
    current_operation_addres := std_logic_vector(to_unsigned((mac_ram_inv_4_mont_address)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    load_operand_mac_ram(test_value_constant_inv_4_mont, current_operation_addres, operands_size);
    current_operation_addres := std_logic_vector(to_unsigned(base_ram_prime_size_bits_address + base_alu_ram_start_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(test_value_prime_size_bits, current_operation_addres);
    i := 0;
    while (i < (number_of_tests)) loop
        for z in 0 to (number_of_inputs - 1) loop
            for j in 0 to (2**mac_max_operands_size - 1) loop
                test_values_input(z)(j) <= (others => '0');
            end loop;
        end loop;
        for z in 0 to (number_of_outputs - 1) loop
            for j in 0 to (2**mac_max_operands_size - 1) loop
                test_values_output(z)(j) <= (others => '0');
                true_values_output(z)(j) <= (others => '0');
            end loop;
        end loop;
        wait for PERIOD;
        for z in 0 to (number_of_inputs - 1) loop
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_MAC_RAM_operand_values);
                test_values_input(z)(j) <= read_MAC_RAM_operand_values;
            end loop;
        end loop;
        for z in 0 to (number_of_outputs - 1) loop
            for j in 0 to (operands_size-1) loop
                readline (ram_file, line_n);
                read (line_n, read_MAC_RAM_operand_values);
                true_values_output(z)(j) <= read_MAC_RAM_operand_values;
            end loop;
        end loop;
        wait for PERIOD;
        for z in 0 to (number_of_inputs - 1) loop
            current_operation_addres := std_logic_vector(to_unsigned((mac_ram_input_function_start_address+z)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
            temp_value_to_load1 <= test_values_input(z);
            wait for PERIOD;
            load_operand_mac_ram(temp_value_to_load1, current_operation_addres, operands_size);
        end loop;
        wait for PERIOD;
        i := i + 1;
        wait for PERIOD;
        buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(operands_size-1, buffer_test_value_communication_base_alu_ram'length));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
        wait for PERIOD;
        buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(prime_line_equal_one, buffer_test_value_communication_base_alu_ram'length));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(reg_prime_line_equal_one_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
        wait for PERIOD;
        buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(reg_prime_address_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
        wait for PERIOD;
        buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(1, buffer_test_value_communication_base_alu_ram'length));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(reg_prime_plus_one_address_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
        wait for PERIOD;
        buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(2, buffer_test_value_communication_base_alu_ram'length));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(reg_prime_line_address_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
        wait for PERIOD;
        buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned((2**mac_max_operands_size)*224, buffer_test_value_communication_base_alu_ram'length));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(reg_initial_stack_address_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
        wait for PERIOD;
        buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(procedure_start_address, buffer_test_value_communication_base_alu_ram'length));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(reg_program_counter_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
        wait for PERIOD;
        test_enable <= '1';
        test_data_in <= (others => '0');
        test_data_in_valid <= '0';
        test_address_data_in_out <= std_logic_vector(to_unsigned(reg_status_address, test_address_data_in_out'length));
        test_write_enable <= '0';
        wait for PERIOD;
        wait until (test_flag = '1' and rising_edge(clk));
        before_time := now;
        wait until (test_flag = '0' and rising_edge(clk));
        after_time := now;
        wait until (test_core_free = '1' and rising_edge(clk));
        wait for tb_delay;
        if(i <= 1) then
                report "Operands size = " & integer'image(operands_size) & " Operation time = " & integer'image((after_time - before_time)/(PERIOD)) & " cycles" severity note;
            end if;
        wait for PERIOD;
        for j in 0 to 7 loop
            test_value_o1(j) <= (others => '0');
            test_value_o1i(j) <= (others => '0');
        end loop;
        wait for PERIOD;
        for z in 0 to (number_of_outputs - 1) loop
            current_operation_addres := std_logic_vector(to_unsigned((mac_ram_output_function_start_address+z)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
            retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, operands_size);
            wait for PERIOD;
            test_values_output(z) <= temp_value_to_load1;
        end loop;
        wait for PERIOD;
        for z in 0 to (number_of_outputs - 1) loop
            temp_value_to_load1 <= test_values_output(z);
            temp_value_to_load2 <= true_values_output(z);
            wait for PERIOD;
            compare_operand_mac_ram(operands_size, temp_value_to_load1, temp_value_to_load2);
        end loop;
        wait for PERIOD;
    end loop;
end test_function;

FILE prom_ram_file : text;
variable line_n : line;
variable buffer_prom_file : std_logic_vector((prom_instruction_size - 1) downto 0);
variable i : integer;
begin
    test_error <= '0';
    test_verification <= '0';
    test_rstn <= '0';
    test_enable <= '0';
    test_data_in <= (others => '0');
    test_data_in_valid <= '0';
    test_address_data_in_out <= (others => '0');
    test_write_enable <= '0';
    wait for PERIOD;
    wait for tb_delay;
    test_rstn <= '1';
    wait for PERIOD;
    file_open(prom_ram_file, test_prom_file, READ_MODE);
    wait for PERIOD;
    external_prom <= (others => X"0000000000000000");
    wait for PERIOD;
    i := 0;
    while not endfile(prom_ram_file) loop
        readline(prom_ram_file, line_n);
        read (line_n, buffer_prom_file);
        external_prom(i)((buffer_prom_file'length - 1) downto 0) <= buffer_prom_file;
        external_prom(i)((external_prom(0)'length - 1) downto buffer_prom_file'length) <= (others => '0');
        wait for PERIOD;
        i := i + 1;
    end loop;
    wait for PERIOD;
    load_program_device_prom(external_prom, 0);
    wait for PERIOD;
    if( not skip_fp_inv_test ) then
        report "Start inversion program test." severity note;
        test_function(test_memory_file_fp_inv_test_8_5, 1, test_program_start_fp_inv_test, 0, test_program_number_inputs_fp_inv_test, test_program_number_outputs_fp_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_fp_inv_test_216_137, 4, test_program_start_fp_inv_test, 1, test_program_number_inputs_fp_inv_test, test_program_number_outputs_fp_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_fp_inv_test_250_159, 4, test_program_start_fp_inv_test, 1, test_program_number_inputs_fp_inv_test, test_program_number_outputs_fp_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_fp_inv_test_305_192, 5, test_program_start_fp_inv_test, 1, test_program_number_inputs_fp_inv_test, test_program_number_outputs_fp_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_fp_inv_test_372_239, 6, test_program_start_fp_inv_test, 1, test_program_number_inputs_fp_inv_test, test_program_number_outputs_fp_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_fp_inv_test_486_301, 8, test_program_start_fp_inv_test, 1, test_program_number_inputs_fp_inv_test, test_program_number_outputs_fp_inv_test);
        wait for PERIOD;
    end if;
    if( not skip_fp2_inv_test ) then
        report "Start inversion^2 program test." severity note;
        test_function(test_memory_file_fp2_inv_test_8_5, 1, test_program_start_fp2_inv_test, 0, test_program_number_inputs_fp2_inv_test, test_program_number_outputs_fp2_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_fp2_inv_test_216_137, 4, test_program_start_fp2_inv_test, 1, test_program_number_inputs_fp2_inv_test, test_program_number_outputs_fp2_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_fp2_inv_test_250_159, 4, test_program_start_fp2_inv_test, 1, test_program_number_inputs_fp2_inv_test, test_program_number_outputs_fp2_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_fp2_inv_test_305_192, 5, test_program_start_fp2_inv_test, 1, test_program_number_inputs_fp2_inv_test, test_program_number_outputs_fp2_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_fp2_inv_test_372_239, 6, test_program_start_fp2_inv_test, 1, test_program_number_inputs_fp2_inv_test, test_program_number_outputs_fp2_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_fp2_inv_test_486_301, 8, test_program_start_fp2_inv_test, 1, test_program_number_inputs_fp2_inv_test, test_program_number_outputs_fp2_inv_test);
        wait for PERIOD;
    end if;
    if( not skip_j_inv_test ) then
        report "Start j_invariant program test." severity note;
        test_function(test_memory_file_j_inv_test_8_5, 1, test_program_start_j_inv_test, 0, test_program_number_inputs_j_inv_test, test_program_number_outputs_j_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_j_inv_test_216_137, 4, test_program_start_j_inv_test, 1, test_program_number_inputs_j_inv_test, test_program_number_outputs_j_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_j_inv_test_250_159, 4, test_program_start_j_inv_test, 1, test_program_number_inputs_j_inv_test, test_program_number_outputs_j_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_j_inv_test_305_192, 5, test_program_start_j_inv_test, 1, test_program_number_inputs_j_inv_test, test_program_number_outputs_j_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_j_inv_test_372_239, 6, test_program_start_j_inv_test, 1, test_program_number_inputs_j_inv_test, test_program_number_outputs_j_inv_test);
        wait for PERIOD;
        test_function(test_memory_file_j_inv_test_486_301, 8, test_program_start_j_inv_test, 1, test_program_number_inputs_j_inv_test, test_program_number_outputs_j_inv_test);
        wait for PERIOD;
    end if;
    if( not skip_get_A_test ) then
        report "Start get_A program test." severity note;
        test_function(test_memory_file_get_A_test_8_5, 1, test_program_start_get_A_test, 0, test_program_number_inputs_get_A_test, test_program_number_outputs_get_A_test);
        wait for PERIOD;
        test_function(test_memory_file_get_A_test_216_137, 4, test_program_start_get_A_test, 1, test_program_number_inputs_get_A_test, test_program_number_outputs_get_A_test);
        wait for PERIOD;
        test_function(test_memory_file_get_A_test_250_159, 4, test_program_start_get_A_test, 1, test_program_number_inputs_get_A_test, test_program_number_outputs_get_A_test);
        wait for PERIOD;
        test_function(test_memory_file_get_A_test_305_192, 5, test_program_start_get_A_test, 1, test_program_number_inputs_get_A_test, test_program_number_outputs_get_A_test);
        wait for PERIOD;
        test_function(test_memory_file_get_A_test_372_239, 6, test_program_start_get_A_test, 1, test_program_number_inputs_get_A_test, test_program_number_outputs_get_A_test);
        wait for PERIOD;
        test_function(test_memory_file_get_A_test_486_301, 8, test_program_start_get_A_test, 1, test_program_number_inputs_get_A_test, test_program_number_outputs_get_A_test);
        wait for PERIOD;
    end if;
    if( not skip_inv_2_way_test ) then
        report "Start inversion 2 way program test." severity note;
        test_function(test_memory_file_inv_2_way_test_8_5, 1, test_program_start_inv_2_way_test, 0, test_program_number_inputs_inv_2_way_test, test_program_number_outputs_inv_2_way_test);
        wait for PERIOD;
        test_function(test_memory_file_inv_2_way_test_216_137, 4, test_program_start_inv_2_way_test, 1, test_program_number_inputs_inv_2_way_test, test_program_number_outputs_inv_2_way_test);
        wait for PERIOD;
        test_function(test_memory_file_inv_2_way_test_250_159, 4, test_program_start_inv_2_way_test, 1, test_program_number_inputs_inv_2_way_test, test_program_number_outputs_inv_2_way_test);
        wait for PERIOD;
        test_function(test_memory_file_inv_2_way_test_305_192, 5, test_program_start_inv_2_way_test, 1, test_program_number_inputs_inv_2_way_test, test_program_number_outputs_inv_2_way_test);
        wait for PERIOD;
        test_function(test_memory_file_inv_2_way_test_372_239, 6, test_program_start_inv_2_way_test, 1, test_program_number_inputs_inv_2_way_test, test_program_number_outputs_inv_2_way_test);
        wait for PERIOD;
        test_function(test_memory_file_inv_2_way_test_486_301, 8, test_program_start_inv_2_way_test, 1, test_program_number_inputs_inv_2_way_test, test_program_number_outputs_inv_2_way_test);
        wait for PERIOD;
    end if;
    if( not skip_ladder_3_pt_test ) then
        report "Start ladder 3 point program test oa bits." severity note;
        test_function(test_memory_file_ladder_3_pt_test_8_5_oa_bits, 1, test_program_start_ladder_3_pt_test, 0, test_program_number_inputs_ladder_3_pt_test, test_program_number_outputs_ladder_3_pt_test);
        wait for PERIOD;
        test_function(test_memory_file_ladder_3_pt_test_216_137_oa_bits, 4, test_program_start_ladder_3_pt_test, 1, test_program_number_inputs_ladder_3_pt_test, test_program_number_outputs_ladder_3_pt_test);
        wait for PERIOD;
        test_function(test_memory_file_ladder_3_pt_test_250_159_oa_bits, 4, test_program_start_ladder_3_pt_test, 1, test_program_number_inputs_ladder_3_pt_test, test_program_number_outputs_ladder_3_pt_test);
        wait for PERIOD;
        test_function(test_memory_file_ladder_3_pt_test_305_192_oa_bits, 5, test_program_start_ladder_3_pt_test, 1, test_program_number_inputs_ladder_3_pt_test, test_program_number_outputs_ladder_3_pt_test);
        wait for PERIOD;
        test_function(test_memory_file_ladder_3_pt_test_372_239_oa_bits, 6, test_program_start_ladder_3_pt_test, 1, test_program_number_inputs_ladder_3_pt_test, test_program_number_outputs_ladder_3_pt_test);
        wait for PERIOD;
        test_function(test_memory_file_ladder_3_pt_test_486_301_oa_bits, 8, test_program_start_ladder_3_pt_test, 1, test_program_number_inputs_ladder_3_pt_test, test_program_number_outputs_ladder_3_pt_test);
        wait for PERIOD;
        report "Start ladder 3 point program test ob bits." severity note;
        test_function(test_memory_file_ladder_3_pt_test_8_5_ob_bits, 1, test_program_start_ladder_3_pt_test, 0, test_program_number_inputs_ladder_3_pt_test, test_program_number_outputs_ladder_3_pt_test);
        wait for PERIOD;
        test_function(test_memory_file_ladder_3_pt_test_216_137_ob_bits, 4, test_program_start_ladder_3_pt_test, 1, test_program_number_inputs_ladder_3_pt_test, test_program_number_outputs_ladder_3_pt_test);
        wait for PERIOD;
        test_function(test_memory_file_ladder_3_pt_test_250_159_ob_bits, 4, test_program_start_ladder_3_pt_test, 1, test_program_number_inputs_ladder_3_pt_test, test_program_number_outputs_ladder_3_pt_test);
        wait for PERIOD;
        test_function(test_memory_file_ladder_3_pt_test_305_192_ob_bits, 5, test_program_start_ladder_3_pt_test, 1, test_program_number_inputs_ladder_3_pt_test, test_program_number_outputs_ladder_3_pt_test);
        wait for PERIOD;
        test_function(test_memory_file_ladder_3_pt_test_372_239_ob_bits, 6, test_program_start_ladder_3_pt_test, 1, test_program_number_inputs_ladder_3_pt_test, test_program_number_outputs_ladder_3_pt_test);
        wait for PERIOD;
        test_function(test_memory_file_ladder_3_pt_test_486_301_ob_bits, 8, test_program_start_ladder_3_pt_test, 1, test_program_number_inputs_ladder_3_pt_test, test_program_number_outputs_ladder_3_pt_test);
        wait for PERIOD;
    end if;
    if( not skip_xDBLe_test ) then
        report "Start xDBLe program test." severity note;
        test_function(test_memory_file_xDBLe_test_8_5, 1, test_program_start_xDBLe_test, 0, test_program_number_inputs_xDBLe_test, test_program_number_outputs_xDBLe_test);
        wait for PERIOD;
        test_function(test_memory_file_xDBLe_test_216_137, 4, test_program_start_xDBLe_test, 1, test_program_number_inputs_xDBLe_test, test_program_number_outputs_xDBLe_test);
        wait for PERIOD;
        test_function(test_memory_file_xDBLe_test_250_159, 4, test_program_start_xDBLe_test, 1, test_program_number_inputs_xDBLe_test, test_program_number_outputs_xDBLe_test);
        wait for PERIOD;
        test_function(test_memory_file_xDBLe_test_305_192, 5, test_program_start_xDBLe_test, 1, test_program_number_inputs_xDBLe_test, test_program_number_outputs_xDBLe_test);
        wait for PERIOD;
        test_function(test_memory_file_xDBLe_test_372_239, 6, test_program_start_xDBLe_test, 1, test_program_number_inputs_xDBLe_test, test_program_number_outputs_xDBLe_test);
        wait for PERIOD;
        test_function(test_memory_file_xDBLe_test_486_301, 8, test_program_start_xDBLe_test, 1, test_program_number_inputs_xDBLe_test, test_program_number_outputs_xDBLe_test);
        wait for PERIOD;
    end if;
    if( not skip_get_4_isog_test ) then
        report "Start get 4 isogenies program test." severity note;
        test_function(test_memory_file_get_4_isog_test_8_5, 1, test_program_start_get_4_isog_test, 0, test_program_number_inputs_get_4_isog_test, test_program_number_outputs_get_4_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_4_isog_test_216_137, 4, test_program_start_get_4_isog_test, 1, test_program_number_inputs_get_4_isog_test, test_program_number_outputs_get_4_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_4_isog_test_250_159, 4, test_program_start_get_4_isog_test, 1, test_program_number_inputs_get_4_isog_test, test_program_number_outputs_get_4_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_4_isog_test_305_192, 5, test_program_start_get_4_isog_test, 1, test_program_number_inputs_get_4_isog_test, test_program_number_outputs_get_4_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_4_isog_test_372_239, 6, test_program_start_get_4_isog_test, 1, test_program_number_inputs_get_4_isog_test, test_program_number_outputs_get_4_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_4_isog_test_486_301, 8, test_program_start_get_4_isog_test, 1, test_program_number_inputs_get_4_isog_test, test_program_number_outputs_get_4_isog_test);
        wait for PERIOD;
    end if;
    if( not skip_eval_4_isog_test ) then
        report "Start eval 4 isogenies program test." severity note;
        test_function(test_memory_file_eval_4_isog_test_8_5, 1, test_program_start_eval_4_isog_test, 0, test_program_number_inputs_eval_4_isog_test, test_program_number_outputs_eval_4_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_4_isog_test_216_137, 4, test_program_start_eval_4_isog_test, 1, test_program_number_inputs_eval_4_isog_test, test_program_number_outputs_eval_4_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_4_isog_test_250_159, 4, test_program_start_eval_4_isog_test, 1, test_program_number_inputs_eval_4_isog_test, test_program_number_outputs_eval_4_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_4_isog_test_305_192, 5, test_program_start_eval_4_isog_test, 1, test_program_number_inputs_eval_4_isog_test, test_program_number_outputs_eval_4_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_4_isog_test_372_239, 6, test_program_start_eval_4_isog_test, 1, test_program_number_inputs_eval_4_isog_test, test_program_number_outputs_eval_4_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_4_isog_test_486_301, 8, test_program_start_eval_4_isog_test, 1, test_program_number_inputs_eval_4_isog_test, test_program_number_outputs_eval_4_isog_test);
        wait for PERIOD;
    end if;
    if( not skip_xTPLe_test ) then
        report "Start xTPLe program test." severity note;
        test_function(test_memory_file_xTPLe_test_8_5, 1, test_program_start_xTPLe_test, 0, test_program_number_inputs_xTPLe_test, test_program_number_outputs_xTPLe_test);
        wait for PERIOD;
        test_function(test_memory_file_xTPLe_test_216_137, 4, test_program_start_xTPLe_test, 1, test_program_number_inputs_xTPLe_test, test_program_number_outputs_xTPLe_test);
        wait for PERIOD;
        test_function(test_memory_file_xTPLe_test_250_159, 4, test_program_start_xTPLe_test, 1, test_program_number_inputs_xTPLe_test, test_program_number_outputs_xTPLe_test);
        wait for PERIOD;
        test_function(test_memory_file_xTPLe_test_305_192, 5, test_program_start_xTPLe_test, 1, test_program_number_inputs_xTPLe_test, test_program_number_outputs_xTPLe_test);
        wait for PERIOD;
        test_function(test_memory_file_xTPLe_test_372_239, 6, test_program_start_xTPLe_test, 1, test_program_number_inputs_xTPLe_test, test_program_number_outputs_xTPLe_test);
        wait for PERIOD;
        test_function(test_memory_file_xTPLe_test_486_301, 8, test_program_start_xTPLe_test, 1, test_program_number_inputs_xTPLe_test, test_program_number_outputs_xTPLe_test);
        wait for PERIOD;
    end if;
    if( not skip_get_3_isog_test ) then
        report "Start Get 3 isogenies program test." severity note;
        test_function(test_memory_file_get_3_isog_test_8_5, 1, test_program_start_get_3_isog_test, 0, test_program_number_inputs_get_3_isog_test, test_program_number_outputs_get_3_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_3_isog_test_216_137, 4, test_program_start_get_3_isog_test, 1, test_program_number_inputs_get_3_isog_test, test_program_number_outputs_get_3_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_3_isog_test_250_159, 4, test_program_start_get_3_isog_test, 1, test_program_number_inputs_get_3_isog_test, test_program_number_outputs_get_3_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_3_isog_test_305_192, 5, test_program_start_get_3_isog_test, 1, test_program_number_inputs_get_3_isog_test, test_program_number_outputs_get_3_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_3_isog_test_372_239, 6, test_program_start_get_3_isog_test, 1, test_program_number_inputs_get_3_isog_test, test_program_number_outputs_get_3_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_3_isog_test_486_301, 8, test_program_start_get_3_isog_test, 1, test_program_number_inputs_get_3_isog_test, test_program_number_outputs_get_3_isog_test);
        wait for PERIOD;
    end if;
    if( not skip_eval_3_isog_test ) then
        report "Start Eval 3 isogenies program test." severity note;
        test_function(test_memory_file_eval_3_isog_test_8_5, 1, test_program_start_eval_3_isog_test, 0, test_program_number_inputs_eval_3_isog_test, test_program_number_outputs_eval_3_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_3_isog_test_216_137, 4, test_program_start_eval_3_isog_test, 1, test_program_number_inputs_eval_3_isog_test, test_program_number_outputs_eval_3_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_3_isog_test_250_159, 4, test_program_start_eval_3_isog_test, 1, test_program_number_inputs_eval_3_isog_test, test_program_number_outputs_eval_3_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_3_isog_test_305_192, 5, test_program_start_eval_3_isog_test, 1, test_program_number_inputs_eval_3_isog_test, test_program_number_outputs_eval_3_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_3_isog_test_372_239, 6, test_program_start_eval_3_isog_test, 1, test_program_number_inputs_eval_3_isog_test, test_program_number_outputs_eval_3_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_3_isog_test_486_301, 8, test_program_start_eval_3_isog_test, 1, test_program_number_inputs_eval_3_isog_test, test_program_number_outputs_eval_3_isog_test);
        wait for PERIOD;
    end if;
    if( not skip_get_2_isog_test ) then
        report "Start Get 2 isogenies program test." severity note;
        test_function(test_memory_file_get_2_isog_test_8_5, 1, test_program_start_get_2_isog_test, 0, test_program_number_inputs_get_2_isog_test, test_program_number_outputs_get_2_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_2_isog_test_216_137, 4, test_program_start_get_2_isog_test, 1, test_program_number_inputs_get_2_isog_test, test_program_number_outputs_get_2_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_2_isog_test_250_159, 4, test_program_start_get_2_isog_test, 1, test_program_number_inputs_get_2_isog_test, test_program_number_outputs_get_2_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_2_isog_test_305_192, 5, test_program_start_get_2_isog_test, 1, test_program_number_inputs_get_2_isog_test, test_program_number_outputs_get_2_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_2_isog_test_372_239, 6, test_program_start_get_2_isog_test, 1, test_program_number_inputs_get_2_isog_test, test_program_number_outputs_get_2_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_get_2_isog_test_486_301, 8, test_program_start_get_2_isog_test, 1, test_program_number_inputs_get_2_isog_test, test_program_number_outputs_get_2_isog_test);
        wait for PERIOD;
    end if;
    if( not skip_eval_2_isog_test ) then
        report "Start Eval 2 isogenies program test." severity note;
        test_function(test_memory_file_eval_2_isog_test_8_5, 1, test_program_start_eval_2_isog_test, 0, test_program_number_inputs_eval_2_isog_test, test_program_number_outputs_eval_2_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_2_isog_test_216_137, 4, test_program_start_eval_2_isog_test, 1, test_program_number_inputs_eval_2_isog_test, test_program_number_outputs_eval_2_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_2_isog_test_250_159, 4, test_program_start_eval_2_isog_test, 1, test_program_number_inputs_eval_2_isog_test, test_program_number_outputs_eval_2_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_2_isog_test_305_192, 5, test_program_start_eval_2_isog_test, 1, test_program_number_inputs_eval_2_isog_test, test_program_number_outputs_eval_2_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_2_isog_test_372_239, 6, test_program_start_eval_2_isog_test, 1, test_program_number_inputs_eval_2_isog_test, test_program_number_outputs_eval_2_isog_test);
        wait for PERIOD;
        test_function(test_memory_file_eval_2_isog_test_486_301, 8, test_program_start_eval_2_isog_test, 1, test_program_number_inputs_eval_2_isog_test, test_program_number_outputs_eval_2_isog_test);
        wait for PERIOD;
    end if;
    test_bench_finish <= true;
    wait;
end process;

end behavioral;