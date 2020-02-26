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

entity tb_sike_core_v128_instructions_isolated is
Generic(
    PERIOD : time := 50 ns;
    mac_base_wide_adder_size : integer := 2;
    mac_base_word_size : integer := 16;
    mac_accumulator_extra_bits : integer := 32;
    mac_memory_address_size : integer := 11;
    mac_multiplication_factor : integer := 8;
    mac_max_operands_size : integer := 3;
    mac_full_bus_address_factor_size : integer := 3;
    prom_memory_size : integer := 11;
    prom_instruction_size : integer := 64;
    base_alu_ram_memory_size : integer := 10;
    base_alu_rotation_level : integer := 4;
    rd_ram_memory_size : integer := 5;
    
    
    test_prom_file : string := "../assembler/test_instructions_isolated_v128.dat";
    
    test_program_start_test_nop        : integer := 1;
    test_program_start_test_badd       : integer := 7;
    test_program_start_test_bsub       : integer := 11;
    test_program_start_test_bsmul      : integer := 15;
    test_program_start_test_bsmuls     : integer := 19;
    test_program_start_test_bshiftr    : integer := 23;
    test_program_start_test_brotr      : integer := 25;
    test_program_start_test_bshiftl    : integer := 27;
    test_program_start_test_brotl      : integer := 29;
    test_program_start_test_bland      : integer := 31;
    test_program_start_test_blor       : integer := 34;
    test_program_start_test_blxor      : integer := 37;
    test_program_start_test_blnot      : integer := 40;
    test_program_start_test_push_pop   : integer := 43;
    test_program_start_test_pushf_popf : integer := 50;
    test_program_start_test_pushm_popm : integer := 67;
    test_program_start_test_copy       : integer := 76;
    test_program_start_test_copyf      : integer := 80;
    test_program_start_test_copym      : integer := 85;
    test_program_start_test_copya      : integer := 90;
    test_program_start_test_lconstf    : integer := 93;
    test_program_start_test_lconstm    : integer := 97;
    test_program_start_test_call       : integer := 101;
    test_program_start_test_jump       : integer := 107
);
end tb_sike_core_v128_instructions_isolated;

architecture behavioral of tb_sike_core_v128_instructions_isolated is

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

signal test_program_counter : std_logic_vector((prom_memory_size - 1) downto 0);
signal test_base_alu_inputa : std_logic_vector((mac_base_word_size - 1) downto 0);
signal test_base_alu_inputb : std_logic_vector((mac_base_word_size - 1) downto 0);
signal test_prom_program_counter_enable_increase : std_logic;
signal test_prom_program_counter_enable_jump : std_logic;
signal test_check_base_alu_o_equal_zero : std_logic;
signal test_check_base_alu_o_change_sign_b : std_logic;
signal test_base_alu_o_equal_zero : std_logic;
signal test_base_alu_o_change_sign_b : std_logic;

signal test_error : std_logic := '0';
signal test_verification : std_logic := '0';
signal clk : std_logic := '1';
signal test_bench_finish : boolean := false;

constant tb_delay : time := (PERIOD/2);

constant mac_ram_start_address : integer                   := 16#00000#;
constant mac_ram_last_address : integer                    := 16#03FFF#;
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

constant base_ram_prime_size_bits_address : integer        := 16#001A1#;
constant base_ram_splits_alice_start_address : integer     := 16#001A2#;
constant base_ram_max_row_alice_address : integer          := 16#002D0#;
constant base_ram_splits_bob_start_address : integer       := 16#002D1#;
constant base_ram_max_row_bob_address : integer            := 16#003FF#;

type tests_mac_ram_prom is array(natural range <>) of std_logic_vector((prom_instruction_size - 1) downto 0);
type tests_base_ula_ram is array(natural range <>) of std_logic_vector((mac_base_word_size - 1) downto 0);

signal buffer_test_value_communication_prom : std_logic_vector((prom_instruction_size - 1) downto 0);
signal buffer_test_value_communication_mac_ram : std_logic_vector((mac_multiplication_factor*(mac_base_word_size) - 1) downto 0);
signal buffer_test_value_communication_base_alu_ram : std_logic_vector((mac_base_word_size - 1) downto 0);

type mac_ram_values_array is array (natural range <>) of std_logic_vector((mac_multiplication_factor*(mac_base_word_size) - 1) downto 0);
type base_ram_values_array is array (natural range <>) of std_logic_vector((mac_base_word_size - 1) downto 0);
type procedure_input_mac_ram_values_array is array (0 to 15) of mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);
type procedure_output_mac_ram_values_array is array (0 to 7) of mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);

signal external_prom : tests_mac_ram_prom((2**prom_memory_size - 1) downto 0);

signal test_values_input : procedure_input_mac_ram_values_array;
signal test_values_output : procedure_input_mac_ram_values_array;
signal true_values_output : procedure_input_mac_ram_values_array;

signal temp_value_to_load1 : mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);
signal temp_value_to_load2 : mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);

signal temp_value_to_load3 : std_logic_vector((mac_base_word_size - 1) downto 0);

signal temp_mac_ram_constant : mac_ram_values_array((2**mac_max_operands_size - 1) downto 0);
signal temp_base_ram_constant : base_ram_values_array(0 to 302);

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
signal load_program : in tests_mac_ram_prom;
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

procedure test_nop_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start nop test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+20, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_nop, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+20, (mac_base_word_size)));
        test_verification <= '1';
        test_error <= '0';
        wait for PERIOD;
        if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
            test_error <= '1';
            report("Error during the nop test");
        else
            test_error <= '0';
        end if;
        wait for PERIOD;
        test_verification <= '0';
        test_error <= '0';
        wait for PERIOD;
    end loop;
    report("End nop test");
end test_nop_instruction;

procedure test_badd_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start badd test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+20, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_badd, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(20+20, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the badd test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b5
    current_operation_addres := std_logic_vector(to_unsigned(5 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(20+21, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the badd test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b6
    current_operation_addres := std_logic_vector(to_unsigned(6 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(21+32, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the badd test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End badd test");
end test_badd_instruction;

procedure test_bsub_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start bsub test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+20, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_bsub, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(20-20, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bsub test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b5
    current_operation_addres := std_logic_vector(to_unsigned(5 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(2**mac_base_word_size+20-21, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bsub test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b6
    current_operation_addres := std_logic_vector(to_unsigned(6 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(21-20, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bsub test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End bsub test");
end test_bsub_instruction;

procedure test_bsmul_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start bsmul test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+20, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_bsmul, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(20*20, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bsmul test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b5
    current_operation_addres := std_logic_vector(to_unsigned(5 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(20*21, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bsmul test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b6
    current_operation_addres := std_logic_vector(to_unsigned(6 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(21*1000, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bsmul test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End bsmul test");
end test_bsmul_instruction;

procedure test_bsmuls_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start bsmuls test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_signed(j-20, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_bsmuls, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_signed((-20)*(-20), (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bsmuls test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b5
    current_operation_addres := std_logic_vector(to_unsigned(5 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_signed((-20)*(-19), (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bsmuls test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b6
    current_operation_addres := std_logic_vector(to_unsigned(6 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_signed((-19)*1000, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bsmuls test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End bsmuls test");
end test_bsmuls_instruction;

procedure test_bshiftr_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start bshiftr test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_bshiftr, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(6, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bshiftr test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End bshiftr test");
end test_bshiftr_instruction;

procedure test_brotr_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start brotr test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_brotr, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(50496, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the brotr test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End brotr test");
end test_brotr_instruction;

procedure test_bshiftl_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start bshiftl test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_bshiftl, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(50496, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bshiftl test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End bshiftl test");
end test_bshiftl_instruction;

procedure test_brotl_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start brotl test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_brotl, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(43032, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the brotl test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End brotl test");
end test_brotl_instruction;

procedure test_bland_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start bland test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_bland, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(789, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bland test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b5
    current_operation_addres := std_logic_vector(to_unsigned(5 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(788, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the bland test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End bland test");
end test_bland_instruction;

procedure test_blor_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start blor test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_blor, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(789, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the blor test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b5
    current_operation_addres := std_logic_vector(to_unsigned(5 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(791, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the blor test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End blor test");
end test_blor_instruction;

procedure test_blxor_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start blxor test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_blxor, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(0, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the blxor test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b5
    current_operation_addres := std_logic_vector(to_unsigned(5 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(3, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the blxor test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End blxor test");
end test_blxor_instruction;

procedure test_blnot_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start blnot test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_blnot, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    for j in 0 to 255 loop
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 4);
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        compare_operand_mac_ram(4, temp_value_to_load1, temp_mac_ram_constant);
    end loop;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(64746, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the blnot test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b5
    current_operation_addres := std_logic_vector(to_unsigned(5 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(65381, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the blnot test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End blnot test");
end test_blnot_instruction;

procedure test_push_pop_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start push and pop test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 4);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_push_pop, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(789, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the push pop test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b5
    current_operation_addres := std_logic_vector(to_unsigned(5 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(790, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the push pop test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b6
    current_operation_addres := std_logic_vector(to_unsigned(6 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(791, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the push pop test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End push and pop test");
end test_push_pop_instruction;

procedure test_pushf_popf_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start pushf and popf test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 8);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_pushf_popf, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    -- Verify m29.0
    current_operation_addres := std_logic_vector(to_unsigned((29)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*29, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*29, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*29, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*29, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*29, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*29, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*29, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m30.1
    current_operation_addres := std_logic_vector(to_unsigned((30)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(30, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*30, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*30, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*30, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*30, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*30, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*30, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m31.2
    current_operation_addres := std_logic_vector(to_unsigned((31)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(31, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*31, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*31, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*31, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*31, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*31, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*31, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m32.3
    current_operation_addres := std_logic_vector(to_unsigned((32)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(32, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*32, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*32, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*32, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*32, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*32, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*32, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m33.4
    current_operation_addres := std_logic_vector(to_unsigned((33)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(33, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*33, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*33, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*33, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*24, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*33, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*33, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*33, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m34.5
    current_operation_addres := std_logic_vector(to_unsigned((34)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(34, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*34, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*34, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*34, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*34, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*25, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*34, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*34, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m35.6
    current_operation_addres := std_logic_vector(to_unsigned((35)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(35, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*35, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*35, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*35, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*35, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*35, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*26, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*35, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m36.7
    current_operation_addres := std_logic_vector(to_unsigned((36)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(36, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*36, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*36, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*36, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*36, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*36, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*36, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*27, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    report("End pushf and popf test");
end test_pushf_popf_instruction;

procedure test_pushm_popm_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start pushm and popm test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 8);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_pushm_popm, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    -- Verify m25
    current_operation_addres := std_logic_vector(to_unsigned((25)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*20, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m26
    current_operation_addres := std_logic_vector(to_unsigned((26)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*21, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m27
    current_operation_addres := std_logic_vector(to_unsigned((27)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*22, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m28
    current_operation_addres := std_logic_vector(to_unsigned((28)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*23, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    report("End pushm and popm test");
end test_pushm_popm_instruction;

procedure test_copy_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start copy test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 8);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_copy, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(789, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the copy test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b5
    current_operation_addres := std_logic_vector(to_unsigned(5 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(790, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the copy test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b6
    current_operation_addres := std_logic_vector(to_unsigned(6 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(791, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the copy test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End copy test");
end test_copy_instruction;

procedure test_copyf_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start copyf test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 8);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_copyf, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    -- Verify m25
    current_operation_addres := std_logic_vector(to_unsigned((25)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*25, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*25, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*25, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*25, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    report("End copyf test");
end test_copyf_instruction;

procedure test_copym_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start copym test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 8);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_copym, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    -- Verify m25
    current_operation_addres := std_logic_vector(to_unsigned((25)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*20, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*20, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m26
    current_operation_addres := std_logic_vector(to_unsigned((26)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*21, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*21, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m27
    current_operation_addres := std_logic_vector(to_unsigned((27)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*22, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*22, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m28
    current_operation_addres := std_logic_vector(to_unsigned((28)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*23, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*23, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    report("End copym test");
end test_copym_instruction;

procedure test_copya_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start copya test");
    test_error <= '0';
    test_verification <= '0';
    test_rstn <= '1';
    test_enable <= '0';
    test_data_in <= (others => '0');
    test_data_in_valid <= '0';
    test_address_data_in_out <= (others => '0');
    test_write_enable <= '0';
    wait for PERIOD;
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, (mac_multiplication_factor)*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, (mac_multiplication_factor)*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, (mac_multiplication_factor)*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, (mac_multiplication_factor)*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*(mac_multiplication_factor) + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, (2**mac_max_operands_size));
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_copya, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    -- Verify b10
    current_operation_addres := std_logic_vector(to_unsigned(10 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(789, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the copya test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b11
    current_operation_addres := std_logic_vector(to_unsigned(11 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(790, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the copya test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b12
    current_operation_addres := std_logic_vector(to_unsigned(12 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(791, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the copya test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b13
    current_operation_addres := std_logic_vector(to_unsigned(13 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(792, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the copya test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b14
    current_operation_addres := std_logic_vector(to_unsigned(14 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(793, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the copya test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End copya test");
end test_copya_instruction;

procedure test_lconstf_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start lconstf test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 8);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_lconstf, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    -- Verify m25
    current_operation_addres := std_logic_vector(to_unsigned((25)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(5743, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(328, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*25, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*25, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*25, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*25, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*25, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    report("End lconstf test");
end test_lconstf_instruction;

procedure test_lconstm_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start lconstm test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 8);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+789, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_lconstm, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    wait for PERIOD;
    -- Verify m25
    current_operation_addres := std_logic_vector(to_unsigned((25)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(5743, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m26
    current_operation_addres := std_logic_vector(to_unsigned((26)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(328, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    -- Verify m27
    current_operation_addres := std_logic_vector(to_unsigned((27)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
    retrieve_operand_mac_ram(temp_value_to_load1, current_operation_addres, 8);
    temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(9, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(0, mac_multiplication_factor*(mac_base_word_size)));
    wait for PERIOD;
    compare_operand_mac_ram(8, temp_value_to_load1, temp_mac_ram_constant);
    wait for PERIOD;
    report("End lconstm test");
end test_lconstm_instruction;

procedure test_call_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start call test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 8);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+20, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_call, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(20+20, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the call test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b5
    current_operation_addres := std_logic_vector(to_unsigned(5 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(20+21, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the call test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    -- Verify b6
    current_operation_addres := std_logic_vector(to_unsigned(6 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(21+32, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the call test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End call test");
end test_call_instruction;

procedure test_jump_instruction is 
variable current_operation_addres : std_logic_vector((mac_base_word_size - 1) downto 0);
begin
    report("Start jump test");
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
    for j in 0 to 255 loop
        temp_mac_ram_constant(0) <= std_logic_vector(to_unsigned(j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(1) <= std_logic_vector(to_unsigned(5*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(2) <= std_logic_vector(to_unsigned(9*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(3) <= std_logic_vector(to_unsigned(19*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(4) <= std_logic_vector(to_unsigned(23*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(5) <= std_logic_vector(to_unsigned(29*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(6) <= std_logic_vector(to_unsigned(37*j, mac_multiplication_factor*(mac_base_word_size)));
        temp_mac_ram_constant(7) <= std_logic_vector(to_unsigned(45*j, mac_multiplication_factor*(mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned((j)*(2**mac_max_operands_size)*mac_multiplication_factor + mac_ram_start_address, current_operation_addres'length));
        load_operand_mac_ram(temp_mac_ram_constant, current_operation_addres, 8);
    end loop;
    wait for PERIOD;
    for j in 0 to 1023 loop
        temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(j+20, (mac_base_word_size)));
        wait for PERIOD;
        current_operation_addres := std_logic_vector(to_unsigned(j + base_alu_ram_start_address, current_operation_addres'length));
        load_value_device_base_alu_internal_registers(temp_base_ram_constant(0), current_operation_addres);
    end loop;
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(3, buffer_test_value_communication_base_alu_ram'length));
    wait for PERIOD;
    current_operation_addres := std_logic_vector(to_unsigned(reg_operands_size_address, current_operation_addres'length));
    load_value_device_base_alu_internal_registers(buffer_test_value_communication_base_alu_ram, current_operation_addres);
    wait for PERIOD;
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(0, buffer_test_value_communication_base_alu_ram'length));
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
    buffer_test_value_communication_base_alu_ram <= std_logic_vector(to_unsigned(test_program_start_test_jump, buffer_test_value_communication_base_alu_ram'length));
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
    wait until (test_core_free = '1' and rising_edge(clk));
    wait for tb_delay;
    -- Verify b4
    current_operation_addres := std_logic_vector(to_unsigned(4 + base_alu_ram_start_address, current_operation_addres'length));
    retrieve_value_device_base_ula_internal_registers(temp_value_to_load3, current_operation_addres);
    temp_base_ram_constant(0) <= std_logic_vector(to_unsigned(21+21, (mac_base_word_size)));
    test_verification <= '1';
    test_error <= '0';
    wait for PERIOD;
    if(temp_value_to_load3 /= temp_base_ram_constant(0)) then
        test_error <= '1';
        report("Error during the jump test");
    else
        test_error <= '0';
    end if;
    wait for PERIOD;
    test_verification <= '0';
    test_error <= '0';
    wait for PERIOD;
    report("End jump test");
end test_jump_instruction;

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
    test_prom_address_region <= '0';
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
    test_nop_instruction;
    test_badd_instruction;
    test_bsub_instruction;
    test_bsmul_instruction;
    test_bsmuls_instruction;
    test_bshiftr_instruction;
    test_brotr_instruction;
    test_bshiftl_instruction;
    test_brotl_instruction;
    test_bland_instruction;
    test_blor_instruction;
    test_blxor_instruction;
    test_blnot_instruction;
    test_push_pop_instruction;
    test_pushf_popf_instruction;
    test_pushm_popm_instruction;
    test_copy_instruction;
    test_copyf_instruction;
    test_copym_instruction;
    test_copya_instruction;
    test_lconstf_instruction;
    test_lconstm_instruction;
    test_call_instruction;
    test_jump_instruction;
    wait for PERIOD;
    test_bench_finish <= true;
    wait;
end process;

end behavioral;