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

entity sike_core_state_machine_v128 is
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
end sike_core_state_machine_v128;

architecture direct_mode of sike_core_state_machine_v128 is

type state is (reset, idle, start_processor_1, start_processor_2, fetch_execute_instruction,
-- Nop
-- (00000)
nop_instruction,
-- Jump - Jump to the specified position, memo -> PC if memb = mema
-- (000001)
-- Jump - Jump to the specified position, memo -> PC if memb > mema
-- (000010)
-- Jump - Jump to the specified position, memo -> PC if memb >= mema
-- (000011)
execute_jumpeq_instruction_1, execute_jumpeq_instruction_2, execute_jumpeq_instruction_3, execute_jumpeq_instruction_4, execute_jumpeq_instruction_5, execute_jumpeq_instruction_6,
execute_jumpl_instruction_1, execute_jumpl_instruction_2, execute_jumpl_instruction_3, execute_jumpl_instruction_4, execute_jumpl_instruction_5, execute_jumpl_instruction_6,
execute_jumpeql_instruction_1, execute_jumpeql_instruction_2, execute_jumpeql_instruction_3, execute_jumpeql_instruction_4, execute_jumpeql_instruction_5, execute_jumpeql_instruction_6,
-- Push Memory map position a in mac ram -> Stack
-- (000100)
execute_push_small_bus_instruction_1, execute_push_small_bus_instruction_2,
-- Pop Stack -> Memory map position b in mac ram
-- (000101)
execute_pop_small_bus_instruction_1, execute_pop_small_bus_instruction_2,
-- Push Memory map position a in mac ram -> Stack
-- (000110)
execute_push_full_bus_single_instruction_1, execute_push_full_bus_single_instruction_2,
-- Pop Stack -> Memory map position b in mac ram
-- (000111)
execute_pop_full_bus_single_instruction_1, execute_pop_full_bus_single_instruction_2,
-- Push Memory map position a in mac ram -> Stack
-- (001000)
execute_push_full_bus_full_instruction_1, execute_push_full_bus_full_instruction_2,
-- Pop Stack -> Memory map position b in mac ram
-- (001001)
execute_pop_full_bus_full_instruction_1, execute_pop_full_bus_full_instruction_2, execute_pop_full_bus_full_instruction_3, execute_pop_full_bus_full_instruction_10,
-- Copy value mema -> memb
-- from small bus
-- (001010)
execute_copy_small_bus_instruction_1, execute_copy_small_bus_instruction_2, execute_copy_small_bus_instruction_3,
-- Copy value mema -> memb 
-- from full bus a single mac word
-- (001011)
execute_copy_full_bus_single_instruction_1, execute_copy_full_bus_single_instruction_2,
-- Copy value mema -> memb 
-- from full bus a full mac word
-- (001100)
execute_copy_full_bus_full_instruction_1, execute_copy_full_bus_full_instruction_2,
-- Load value mac memory a single word
-- (001101)
execute_load_value_single_mac_memory_1,
-- Load value mac memory a full word
-- (001110)
execute_load_value_full_mac_memory_1, execute_load_value_full_mac_memory_2, execute_load_value_full_mac_memory_3,
-- Call a function
-- (001111)
execute_function_call_1, execute_function_call_2, execute_function_call_3,
-- Return from a function
-- (010000)
execute_function_return_1, execute_function_return_2, execute_function_return_3, execute_function_return_4,
-- Copy array mema -> memb
-- from small bus
-- (010001)
execute_copy_array_small_bus_instruction_1, execute_copy_array_small_bus_instruction_2, execute_copy_array_small_bus_instruction_3, execute_copy_array_small_bus_instruction_4, execute_copy_array_small_bus_instruction_5,execute_copy_array_small_bus_instruction_6,
-- Init the Keccak core
-- (011000)
execute_keccak_init_instruction_1, execute_keccak_init_instruction_2, execute_keccak_init_instruction_3,
-- Perform the Keccak 24 rounds.
-- (011001)
execute_keccak_go_instruction_1, execute_keccak_go_instruction_2, execute_keccak_go_instruction_3,
--
-- Addition                    memo = memb + mema
-- (010000)
-- Subtraction                 memo = memb - mema
-- (010001)
-- Multiplication single       memo = memb * mema
-- (010010)
-- Multiplication double       memo = memb * mema
-- (010011)
-- Shift right                 memo = memb >> consta
-- (010100)
-- Rotate right                memo = memb >> consta
-- (010101)
-- Shift left                  memo = memb << consta
-- (010110)
-- Rotate left                 memo = memb << consta 
-- (010111)
-- Logical AND                 memo = memb AND mema
-- (011000)
-- Logical OR                  memo = memb OR  mema
-- (011001)
-- Logical XOR                 memo = memb XOR mema
-- (011010)
execute_base_alu_instruction_1, execute_base_alu_instruction_2, execute_base_alu_instruction_3, execute_base_alu_instruction_4,
-- Finish execution 
-- (111111)
-- MAC Instruction
start_execute_8_mac_instruction_1, start_execute_8_mac_instruction_2, start_execute_8_mac_instruction_3, start_execute_8_mac_instruction_8, start_execute_8_mac_instruction_9, execute_8_mac_instruction,
start_execute_4_mac_instruction_1, start_execute_4_mac_instruction_2, start_execute_4_mac_instruction_3, start_execute_4_mac_instruction_4, start_execute_4_mac_instruction_5, execute_4_mac_instruction);

signal actual_state, next_state : state;

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
constant base_unit_bdmul_operation : std_logic_vector(5 downto 0)        := "100011";
constant base_unit_bshiftr_operation : std_logic_vector(5 downto 0)      := "100100";
constant base_unit_brotr_operation : std_logic_vector(5 downto 0)        := "100101";
constant base_unit_bshiftl_operation : std_logic_vector(5 downto 0)      := "100110";
constant base_unit_brotl_operation : std_logic_vector(5 downto 0)        := "100111";
constant base_unit_bland_operation : std_logic_vector(5 downto 0)        := "101000";
constant base_unit_blor_operation : std_logic_vector(5 downto 0)         := "101001";
constant base_unit_blxor_operation : std_logic_vector(5 downto 0)        := "101010";
constant base_unit_fin_operation : std_logic_vector(5 downto 0)          := "111111";

constant mac_unit_mmuld_operation : std_logic_vector(3 downto 0)         := "0000";
constant mac_unit_msqud_operation : std_logic_vector(3 downto 0)         := "0001";
constant mac_unit_mmulm_operation : std_logic_vector(3 downto 0)         := "0010";
constant mac_unit_msqum_operation : std_logic_vector(3 downto 0)         := "0011";
constant mac_unit_madd_subd_operation : std_logic_vector(3 downto 0)     := "0100";
constant mac_unit_mitred_operation : std_logic_vector(3 downto 0)        := "0101";

signal ctr_repeat_states_value : unsigned(2 downto 0);
signal ctr_repeat_states_enable : std_logic;
signal ctr_repeat_states_load : std_logic;
signal ctr_repeat_states_load_value : std_logic_vector(1 downto 0);
signal ctr_repeat_states_limit : std_logic;

begin

ctr_repeat_states : process(clk)
begin
    if(rising_edge(clk)) then
        if(ctr_repeat_states_enable = '1') then
            if(ctr_repeat_states_load = '1') then
                case (ctr_repeat_states_load_value) is
                    when "10" =>
                        ctr_repeat_states_value <= to_unsigned(7, 3);
                    when "11" =>
                        ctr_repeat_states_value <= to_unsigned(6, 3);
                    when others =>
                        ctr_repeat_states_value <= to_unsigned(4, 3);
                end case;
            else
                ctr_repeat_states_value <= ctr_repeat_states_value - to_unsigned(1, 3);
            end if;
        end if;
    end if;
end process;

ctr_repeat_states_limit <= '1' when (to_01(ctr_repeat_states_value) = to_unsigned(0, 3)) else '0';

registers_state : process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            actual_state <= reset;
        else
            actual_state <= next_state;
        end if;
    end if;
end process;

update_output : process(actual_state)
begin
    reg_next_instruction_enable <= '0';
    reg_current_instruction_enable <= '0';
    enable_new_mac_instruction <= '0';
    full_bus_enable <= '0';
    full_bus_mac_ram_control <= "00";
    full_bus_mac_ram_address_mode_a <= "00";
    full_bus_mac_ram_address_mode_b <= "00";
    mac_ram_stack_mode <= '0';
    mac_ram_address_incremented_enable <= '0';
    mac_ram_address_incremented_decreasing_mode <= '0';
    mac_ram_address_incremented_load <= '0';
    sidh_control_enable_write_one_a_full_bus_mode <= '0';
    sidh_control_small_bus_enable <= '0';
    sidh_control_small_bus_write_enable <= '0';
    sidh_control_small_bus_buffer_enable <= '0';
    sidh_control_small_bus_stack_mode_enable <= '0';
    sidh_control_small_bus_burst_mode <= '0';
    sidh_control_small_bus_address_data_in_burst_ctr_enable <= '0';
    sidh_control_small_bus_address_data_out_burst_ctr_enable <= '0';
    sidh_control_small_bus_address_burst_ctr_load <= '0';
    stack_rstn <= '1';
    stack_operation_valid <= '0';
    stack_push_mode <= '0';
    sidh_control_base_alu_ram_operation_mode <= '1';
    sidh_control_base_alu_ram_alu_mode <= '0';
    sidh_control_base_alu_ram_write_enable <= '0';
    prom_program_counter_enable_increase <= '0';
    prom_program_counter_enable_jump <= '0';
    prom_program_counter_return_function <= '0';
    check_base_alu_o_equal_zero <= '0';
    check_base_alu_o_change_sign_b <= '0';
    enable_base_alu_input_registers <= '0';
    reg_constant_full_bus_base <= '0';
    keccak_init <= '0';
    keccak_go <= '0';
    reg_status <= '0';
    ctr_repeat_states_enable <= '0';
    ctr_repeat_states_load <= '0';
    ctr_repeat_states_load_value <= "00";
    case (actual_state) is
        when reset =>
            stack_rstn <= '0';
        when idle =>
            sidh_control_small_bus_enable <= '1';
            reg_status <= '1';
        when start_processor_1 =>
            full_bus_enable <= '1';
            stack_rstn <= '0';
            prom_program_counter_enable_increase <= '1';
        when start_processor_2 =>
            full_bus_enable <= '1';
            reg_next_instruction_enable <= '1';
        when fetch_execute_instruction =>
            reg_next_instruction_enable <= '1';
            reg_current_instruction_enable <= '1';
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
            prom_program_counter_enable_increase <= '1';
        when nop_instruction =>
            full_bus_enable <= '1';
        when execute_jumpeq_instruction_1 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_jumpeq_instruction_2 =>
            enable_base_alu_input_registers <= '1';
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_jumpeq_instruction_3 =>
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_jumpeq_instruction_4 =>
            full_bus_enable <= '1';
            prom_program_counter_enable_jump <= '1';
            check_base_alu_o_equal_zero <= '1';
        when execute_jumpeq_instruction_5 =>
            full_bus_enable <= '1';
            prom_program_counter_enable_increase <= '1';
        when execute_jumpeq_instruction_6 =>
            full_bus_enable <= '1';
            reg_next_instruction_enable <= '1';
        when execute_jumpl_instruction_1 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_jumpl_instruction_2 =>
            enable_base_alu_input_registers <= '1';
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_jumpl_instruction_3 =>
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_jumpl_instruction_4 =>
            full_bus_enable <= '1';
            prom_program_counter_enable_jump <= '1';
            check_base_alu_o_change_sign_b <= '1';
        when execute_jumpl_instruction_5 =>
            full_bus_enable <= '1';
            prom_program_counter_enable_increase <= '1';
        when execute_jumpl_instruction_6 =>
            full_bus_enable <= '1';
            reg_next_instruction_enable <= '1';
        when execute_jumpeql_instruction_1 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_jumpeql_instruction_2 =>
            enable_base_alu_input_registers <= '1';
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_jumpeql_instruction_3 =>
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_jumpeql_instruction_4 =>
            full_bus_enable <= '1';
            prom_program_counter_enable_jump <= '1';
            check_base_alu_o_equal_zero <= '1';
            check_base_alu_o_change_sign_b <= '1';
        when execute_jumpeql_instruction_5 =>
            full_bus_enable <= '1';
            prom_program_counter_enable_increase <= '1';
        when execute_jumpeql_instruction_6 =>
            full_bus_enable <= '1';
            reg_next_instruction_enable <= '1';
        when execute_push_small_bus_instruction_1 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_operation_mode <= '1';
            mac_ram_stack_mode <= '1';
            full_bus_mac_ram_address_mode_a <= "10";
            full_bus_mac_ram_address_mode_b <= "00";
            sidh_control_small_bus_enable <= '1';
            stack_push_mode <= '1';
        when execute_push_small_bus_instruction_2 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "10";
            full_bus_mac_ram_address_mode_a <= "10";
            mac_ram_stack_mode <= '1';
            sidh_control_enable_write_one_a_full_bus_mode <= '1';
            sidh_control_small_bus_enable <= '1';
            stack_operation_valid <= '1';
            stack_push_mode <= '1';
        when execute_pop_small_bus_instruction_1 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_operation_mode <= '1';
            mac_ram_stack_mode <= '1';
            full_bus_mac_ram_address_mode_a <= "00";
            full_bus_mac_ram_address_mode_b <= "10";
            sidh_control_small_bus_enable <= '1';
            stack_operation_valid <= '1';
            sidh_control_small_bus_stack_mode_enable <= '1';
        when execute_pop_small_bus_instruction_2 =>
            full_bus_mac_ram_control <= "10";
            full_bus_mac_ram_address_mode_b <= "10";
            mac_ram_stack_mode <= '1';
            sidh_control_small_bus_enable <= '1';
            sidh_control_small_bus_write_enable <= '1';
            sidh_control_small_bus_stack_mode_enable <= '1';
        when execute_push_full_bus_single_instruction_1 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_operation_mode <= '1';
            mac_ram_stack_mode <= '1';
            full_bus_mac_ram_address_mode_a <= "10";
            full_bus_mac_ram_address_mode_b <= "00";
            stack_push_mode <= '1';
        when execute_push_full_bus_single_instruction_2 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_address_mode_a <= "10";
            mac_ram_stack_mode <= '1';
            sidh_control_enable_write_one_a_full_bus_mode <= '1';
            stack_operation_valid <= '1';
            stack_push_mode <= '1';
        when execute_pop_full_bus_single_instruction_1 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_operation_mode <= '1';
            mac_ram_stack_mode <= '1';
            full_bus_mac_ram_control <= "00";
            full_bus_mac_ram_address_mode_a <= "00";
            full_bus_mac_ram_address_mode_b <= "10";
            stack_operation_valid <= '1';
        when execute_pop_full_bus_single_instruction_2 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_address_mode_b <= "10";
            mac_ram_stack_mode <= '1';
            sidh_control_enable_write_one_a_full_bus_mode <= '1';
        when execute_push_full_bus_full_instruction_1 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_address_mode_a <= "10";
            full_bus_mac_ram_address_mode_b <= "00";
            sidh_control_base_alu_ram_operation_mode <= '1';
            mac_ram_stack_mode <= '1';
            mac_ram_address_incremented_enable <= '1';
            mac_ram_address_incremented_load <= '1';
            stack_push_mode <= '1';
            ctr_repeat_states_enable <= '1';
            ctr_repeat_states_load <= '1';
            ctr_repeat_states_load_value <= "10";
        when execute_push_full_bus_full_instruction_2 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_address_mode_a <= "10";
            full_bus_mac_ram_address_mode_b <= "01";
            mac_ram_stack_mode <= '1';
            mac_ram_address_incremented_enable <= '1';
            sidh_control_enable_write_one_a_full_bus_mode <= '1';
            stack_operation_valid <= '1';
            stack_push_mode <= '1';
            ctr_repeat_states_enable <= '1';
        when execute_pop_full_bus_full_instruction_1 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_operation_mode <= '1';
            mac_ram_stack_mode <= '1';
            full_bus_mac_ram_control <= "00";
            full_bus_mac_ram_address_mode_a <= "01";
            full_bus_mac_ram_address_mode_b <= "10";
            mac_ram_address_incremented_enable <= '1';
            mac_ram_address_incremented_decreasing_mode <= '1';
            mac_ram_address_incremented_load <= '1';
        when execute_pop_full_bus_full_instruction_2 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_address_mode_a <= "01";
            full_bus_mac_ram_address_mode_b <= "10";
            mac_ram_stack_mode <= '1';
            mac_ram_address_incremented_enable <= '1';
            mac_ram_address_incremented_decreasing_mode <= '1';
            stack_operation_valid <= '1';
            ctr_repeat_states_enable <= '1';
            ctr_repeat_states_load <= '1';
            ctr_repeat_states_load_value <= "11";
        when execute_pop_full_bus_full_instruction_3 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_address_mode_a <= "01";
            full_bus_mac_ram_address_mode_b <= "10";
            mac_ram_stack_mode <= '1';
            mac_ram_address_incremented_enable <= '1';
            mac_ram_address_incremented_decreasing_mode <= '1';
            sidh_control_enable_write_one_a_full_bus_mode <= '1';
            stack_operation_valid <= '1';
            ctr_repeat_states_enable <= '1';
        when execute_pop_full_bus_full_instruction_10 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_address_mode_a <= "01";
            full_bus_mac_ram_address_mode_b <= "10";
            mac_ram_stack_mode <= '1';
            sidh_control_enable_write_one_a_full_bus_mode <= '1';
        when execute_copy_small_bus_instruction_1 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_operation_mode <= '1';
            sidh_control_small_bus_enable <= '1';
        when execute_copy_small_bus_instruction_2 =>
            full_bus_enable <= '1';
            sidh_control_small_bus_enable <= '1';
            sidh_control_small_bus_buffer_enable <= '1';
        when execute_copy_small_bus_instruction_3 =>
            full_bus_enable <= '1';
            sidh_control_small_bus_enable <= '1';
            sidh_control_small_bus_write_enable <= '1';
        when execute_copy_full_bus_single_instruction_1 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "00";
        when execute_copy_full_bus_single_instruction_2 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "00";
            sidh_control_enable_write_one_a_full_bus_mode <= '1';
        when execute_copy_full_bus_full_instruction_1 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_operation_mode <= '1';
            mac_ram_address_incremented_enable <= '1';
            mac_ram_address_incremented_load <= '1';
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "00";
            ctr_repeat_states_enable <= '1';
            ctr_repeat_states_load <= '1';
            ctr_repeat_states_load_value <= "10";
        when execute_copy_full_bus_full_instruction_2 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_address_mode_a <= "01";
            full_bus_mac_ram_address_mode_b <= "01";
            mac_ram_address_incremented_enable <= '1';
            sidh_control_enable_write_one_a_full_bus_mode <= '1';
            ctr_repeat_states_enable <= '1';
        when execute_load_value_single_mac_memory_1 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "01";
            sidh_control_enable_write_one_a_full_bus_mode <= '1';
        when execute_load_value_full_mac_memory_1 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "01";
            full_bus_mac_ram_address_mode_a <= "01";
            mac_ram_address_incremented_enable <= '1';
            mac_ram_address_incremented_load <= '1';
        when execute_load_value_full_mac_memory_2 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "01";
            full_bus_mac_ram_address_mode_a <= "01";
            mac_ram_address_incremented_enable <= '1';
            sidh_control_enable_write_one_a_full_bus_mode <= '1';
            ctr_repeat_states_enable <= '1';
            ctr_repeat_states_load <= '1';
            ctr_repeat_states_load_value <= "11";
        when execute_load_value_full_mac_memory_3 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "01";
            full_bus_mac_ram_address_mode_a <= "01";
            mac_ram_address_incremented_enable <= '1';
            sidh_control_enable_write_one_a_full_bus_mode <= '1';
            reg_constant_full_bus_base <= '1';
            ctr_repeat_states_enable <= '1';
        when execute_function_call_1 =>
            full_bus_enable <= '1';
            mac_ram_stack_mode <= '1';
            full_bus_mac_ram_control <= "10";
            full_bus_mac_ram_address_mode_a <= "10";
            full_bus_mac_ram_address_mode_b <= "00";
            sidh_control_small_bus_enable <= '1';
            sidh_control_small_bus_write_enable <= '1';
            sidh_control_enable_write_one_a_full_bus_mode <= '1';
            stack_push_mode <= '1';
            stack_operation_valid <= '1';
            prom_program_counter_enable_jump <= '1';
        when execute_function_call_2 =>
            full_bus_enable <= '1';
            prom_program_counter_enable_increase <= '1';
        when execute_function_call_3 =>
            full_bus_enable <= '1';
            reg_next_instruction_enable <= '1';
        when execute_function_return_1 =>
            full_bus_enable <= '1';
            mac_ram_stack_mode <= '1';
            full_bus_mac_ram_address_mode_a <= "00";
            full_bus_mac_ram_address_mode_b <= "10";
            sidh_control_small_bus_enable <= '1';
            stack_operation_valid <= '1';
        when execute_function_return_2 =>
            full_bus_enable <= '1';
            prom_program_counter_enable_jump <= '1';
            prom_program_counter_return_function <= '1';
        when execute_function_return_3 =>
            full_bus_enable <= '1';
            prom_program_counter_enable_increase <= '1';
        when execute_function_return_4 =>
            full_bus_enable <= '1';
            reg_next_instruction_enable <= '1';
        when execute_copy_array_small_bus_instruction_1 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_copy_array_small_bus_instruction_2 =>
            full_bus_enable <= '1';
            sidh_control_small_bus_burst_mode <= '1';
            sidh_control_small_bus_address_data_in_burst_ctr_enable <= '1';
            sidh_control_small_bus_address_data_out_burst_ctr_enable <= '1';
            sidh_control_small_bus_address_burst_ctr_load <= '1';
            sidh_control_small_bus_enable <= '1';
        when execute_copy_array_small_bus_instruction_3 =>
            full_bus_enable <= '1';
            sidh_control_small_bus_burst_mode <= '1';
            sidh_control_small_bus_address_data_out_burst_ctr_enable <= '1';
            sidh_control_base_alu_ram_operation_mode <= '1';
            sidh_control_small_bus_enable <= '1';
        when execute_copy_array_small_bus_instruction_4 =>
            full_bus_enable <= '1';
            sidh_control_small_bus_burst_mode <= '1';
            sidh_control_small_bus_address_data_out_burst_ctr_enable <= '1';
            sidh_control_base_alu_ram_operation_mode <= '1';
            sidh_control_small_bus_enable <= '1';
            sidh_control_small_bus_buffer_enable <= '1';
        when execute_copy_array_small_bus_instruction_5|execute_copy_array_small_bus_instruction_6 =>
            full_bus_enable <= '1';
            sidh_control_small_bus_burst_mode <= '1';
            sidh_control_small_bus_address_data_in_burst_ctr_enable <= '1';
            sidh_control_small_bus_address_data_out_burst_ctr_enable <= '1';
            sidh_control_base_alu_ram_operation_mode <= '1';
            sidh_control_small_bus_enable <= '1';
            sidh_control_small_bus_buffer_enable <= '1';
            sidh_control_small_bus_write_enable <= '1';
        when execute_keccak_go_instruction_1 =>
            full_bus_enable <= '1';
            keccak_go <= '1';
        when execute_keccak_go_instruction_2|execute_keccak_go_instruction_3 =>
            full_bus_enable <= '1';
        when execute_keccak_init_instruction_1 =>
            full_bus_enable <= '1';
            keccak_init <= '1';
        when execute_keccak_init_instruction_2|execute_keccak_init_instruction_3 =>
            full_bus_enable <= '1';
        when execute_base_alu_instruction_1 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_base_alu_instruction_2 =>
            full_bus_enable <= '1';
            enable_base_alu_input_registers <= '1';
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_base_alu_instruction_3 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_base_alu_instruction_4 =>
            full_bus_enable <= '1';
            sidh_control_base_alu_ram_operation_mode <= '1';
            sidh_control_base_alu_ram_alu_mode <= '1';
            sidh_control_base_alu_ram_write_enable <= '1';
        when start_execute_8_mac_instruction_1 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "11";
            full_bus_mac_ram_address_mode_a <= "11";
            full_bus_mac_ram_address_mode_b <= "11";
            sidh_control_base_alu_ram_operation_mode <= '0';
            prom_program_counter_enable_increase <= '1';
        when start_execute_8_mac_instruction_2 =>
            enable_new_mac_instruction <= '1';
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "11";
            full_bus_mac_ram_address_mode_a <= "11";
            full_bus_mac_ram_address_mode_b <= "11";
            sidh_control_base_alu_ram_operation_mode <= '0';
            prom_program_counter_enable_increase <= '1';
            reg_current_instruction_enable <= '1';
            reg_next_instruction_enable <= '1';
            ctr_repeat_states_enable <= '1';
            ctr_repeat_states_load <= '1';
            ctr_repeat_states_load_value <= "00";
        when start_execute_8_mac_instruction_3 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "11";
            full_bus_mac_ram_address_mode_a <= "11";
            full_bus_mac_ram_address_mode_b <= "11";
            sidh_control_base_alu_ram_operation_mode <= '0';
            prom_program_counter_enable_increase <= '1';
            reg_current_instruction_enable <= '1';
            reg_next_instruction_enable <= '1';
            ctr_repeat_states_enable <= '1';
        when start_execute_8_mac_instruction_8 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "11";
            full_bus_mac_ram_address_mode_a <= "11";
            full_bus_mac_ram_address_mode_b <= "11";
            sidh_control_base_alu_ram_operation_mode <= '0';
            reg_current_instruction_enable <= '1';
            reg_next_instruction_enable <= '1';
        when start_execute_8_mac_instruction_9 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "11";
            full_bus_mac_ram_address_mode_a <= "11";
            full_bus_mac_ram_address_mode_b <= "11";
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_8_mac_instruction =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "11";
            full_bus_mac_ram_address_mode_a <= "11";
            full_bus_mac_ram_address_mode_b <= "11";
            sidh_control_base_alu_ram_operation_mode <= '0';
        when start_execute_4_mac_instruction_1 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "11";
            full_bus_mac_ram_address_mode_a <= "11";
            full_bus_mac_ram_address_mode_b <= "11";
            sidh_control_base_alu_ram_operation_mode <= '0';
            prom_program_counter_enable_increase <= '1';
        when start_execute_4_mac_instruction_2 =>
            enable_new_mac_instruction <= '1';
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "11";
            full_bus_mac_ram_address_mode_a <= "11";
            full_bus_mac_ram_address_mode_b <= "11";
            sidh_control_base_alu_ram_operation_mode <= '0';
            prom_program_counter_enable_increase <= '1';
            reg_current_instruction_enable <= '1';
            reg_next_instruction_enable <= '1';
        when start_execute_4_mac_instruction_3 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "11";
            full_bus_mac_ram_address_mode_a <= "11";
            full_bus_mac_ram_address_mode_b <= "11";
            sidh_control_base_alu_ram_operation_mode <= '0';
            prom_program_counter_enable_increase <= '1';
            reg_current_instruction_enable <= '1';
            reg_next_instruction_enable <= '1';
        when start_execute_4_mac_instruction_4 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "11";
            full_bus_mac_ram_address_mode_a <= "11";
            full_bus_mac_ram_address_mode_b <= "11";
            sidh_control_base_alu_ram_operation_mode <= '0';
            reg_current_instruction_enable <= '1';
            reg_next_instruction_enable <= '1';
        when start_execute_4_mac_instruction_5 =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "11";
            full_bus_mac_ram_address_mode_a <= "11";
            full_bus_mac_ram_address_mode_b <= "11";
            sidh_control_base_alu_ram_operation_mode <= '0';
        when execute_4_mac_instruction =>
            full_bus_enable <= '1';
            full_bus_mac_ram_control <= "11";
            full_bus_mac_ram_address_mode_a <= "11";
            full_bus_mac_ram_address_mode_b <= "11";
            sidh_control_base_alu_ram_operation_mode <= '0';
    end case;
end process;

update_state : process(actual_state, reg_next_instruction_processor_target, reg_next_instruction_base_alu_operation_type, reg_current_instruction_processor_target, reg_current_instruction_base_alu_operation_type, mac_free_flag, prom_program_counter_start_execution, small_bus_address_burst_last_block, keccak_ready, ctr_repeat_states_limit)
begin
    case (actual_state) is
        when reset =>
            next_state <= idle;
        when idle =>
            next_state <= idle;
            if(prom_program_counter_start_execution = '1') then
                next_state <= start_processor_1;
            end if;
        when start_processor_1 =>
            next_state <= start_processor_2;
        when start_processor_2 =>
            next_state <= fetch_execute_instruction;
        when fetch_execute_instruction =>
            next_state <= fetch_execute_instruction;
            if(reg_next_instruction_processor_target = "00") then
                case reg_next_instruction_base_alu_operation_type is
                    when base_unit_nop_operation =>
                        next_state <= nop_instruction;
                    when base_unit_jumpeq_operation =>
                        next_state <= execute_jumpeq_instruction_1;
                    when base_unit_jumpl_operation =>
                        next_state <= execute_jumpl_instruction_1;
                    when base_unit_jumpeql_operation =>
                        next_state <= execute_jumpeql_instruction_1;
                    when base_unit_push_operation =>
                        next_state <= execute_push_small_bus_instruction_1;
                    when base_unit_pop_operation =>
                        next_state <= execute_pop_small_bus_instruction_1;
                    when base_unit_pushf_operation =>
                        next_state <= execute_push_full_bus_single_instruction_1;
                    when base_unit_popf_operation =>
                        next_state <= execute_pop_full_bus_single_instruction_1;
                    when base_unit_pushm_operation =>
                        next_state <= execute_push_full_bus_full_instruction_1;
                    when base_unit_popm_operation =>
                        next_state <= execute_pop_full_bus_full_instruction_1;
                    when base_unit_copy_operation =>
                        next_state <= execute_copy_small_bus_instruction_1;
                    when base_unit_copyf_operation =>
                        next_state <= execute_copy_full_bus_single_instruction_1;
                    when base_unit_copym_operation =>
                        next_state <= execute_copy_full_bus_full_instruction_1;
                    when base_unit_lconstf_operation =>
                        next_state <= execute_load_value_single_mac_memory_1;
                    when base_unit_lconstm_operation =>
                        next_state <= execute_load_value_full_mac_memory_1;
                    when base_unit_call_operation =>
                        next_state <= execute_function_call_1;
                    when base_unit_ret_operation =>
                        next_state <= execute_function_return_1;
                    when base_unit_copya_inc_ds_operation|base_unit_copya_inc_d_operation|base_unit_copya_inc_s_operation|base_unit_copya_inc_operation|base_unit_copya_dec_ds_operation|base_unit_copya_dec_d_operation|base_unit_copya_dec_s_operation =>
                        next_state <= execute_copy_array_small_bus_instruction_1;
                    when base_unit_keccak_init_operation =>
                        next_state <= execute_keccak_init_instruction_1;
                    when base_unit_keccak_go_operation =>
                        next_state <= execute_keccak_go_instruction_1;
                    when base_unit_badd_operation|base_unit_bsub_operation|base_unit_bsmul_operation|base_unit_bdmul_operation|base_unit_bshiftr_operation|base_unit_brotr_operation|base_unit_bshiftl_operation|base_unit_brotl_operation|base_unit_bland_operation|base_unit_blor_operation|base_unit_blxor_operation =>
                        next_state <= execute_base_alu_instruction_1;
                    when base_unit_fin_operation =>
                        next_state <= idle;
                    when others =>
                        next_state <= nop_instruction;
                end case;
            elsif(reg_next_instruction_processor_target = "01") then
                case reg_next_instruction_base_alu_operation_type(3 downto 0) is
                    when mac_unit_mmuld_operation|mac_unit_msqud_operation|mac_unit_mmulm_operation|mac_unit_msqum_operation =>
                        next_state <= start_execute_8_mac_instruction_1;
                    when mac_unit_madd_subd_operation|mac_unit_mitred_operation =>
                        next_state <= start_execute_4_mac_instruction_1;
                    when others =>
                        next_state <= start_execute_8_mac_instruction_1;
                end case;
            end if;
        when nop_instruction =>
            next_state <= fetch_execute_instruction;
        when execute_jumpeq_instruction_1 =>
            next_state <= execute_jumpeq_instruction_2;
        when execute_jumpeq_instruction_2 =>
            next_state <= execute_jumpeq_instruction_3;
        when execute_jumpeq_instruction_3 =>
            next_state <= execute_jumpeq_instruction_4;
        when execute_jumpeq_instruction_4 =>
            next_state <= execute_jumpeq_instruction_5;
        when execute_jumpeq_instruction_5 =>
            next_state <= execute_jumpeq_instruction_6;
        when execute_jumpeq_instruction_6 =>
            next_state <= fetch_execute_instruction;
        when execute_jumpl_instruction_1 =>
            next_state <= execute_jumpl_instruction_2;
        when execute_jumpl_instruction_2 =>
            next_state <= execute_jumpl_instruction_3;
        when execute_jumpl_instruction_3 =>
            next_state <= execute_jumpl_instruction_4;
        when execute_jumpl_instruction_4 =>
            next_state <= execute_jumpl_instruction_5;
        when execute_jumpl_instruction_5 =>
            next_state <= execute_jumpl_instruction_6;
        when execute_jumpl_instruction_6 =>
            next_state <= fetch_execute_instruction;
        when execute_jumpeql_instruction_1 =>
            next_state <= execute_jumpeql_instruction_2;
        when execute_jumpeql_instruction_2 =>
            next_state <= execute_jumpeql_instruction_3;
        when execute_jumpeql_instruction_3 =>
            next_state <= execute_jumpeql_instruction_4;
        when execute_jumpeql_instruction_4 =>
            next_state <= execute_jumpeql_instruction_5;
        when execute_jumpeql_instruction_5 =>
            next_state <= execute_jumpeql_instruction_6;
        when execute_jumpeql_instruction_6 =>
            next_state <= fetch_execute_instruction;
        when execute_push_small_bus_instruction_1 =>
            next_state <= execute_push_small_bus_instruction_2;
        when execute_push_small_bus_instruction_2 =>
            next_state <= fetch_execute_instruction;
        when execute_pop_small_bus_instruction_1 =>
            next_state <= execute_pop_small_bus_instruction_2;
        when execute_pop_small_bus_instruction_2 =>
            next_state <= fetch_execute_instruction;
        when execute_push_full_bus_single_instruction_1 =>
            next_state <= execute_push_full_bus_single_instruction_2;
        when execute_push_full_bus_single_instruction_2 =>
            next_state <= fetch_execute_instruction;
        when execute_pop_full_bus_single_instruction_1 =>
            next_state <= execute_pop_full_bus_single_instruction_2;
        when execute_pop_full_bus_single_instruction_2 =>
            next_state <= fetch_execute_instruction;
        when execute_push_full_bus_full_instruction_1 =>
            next_state <= execute_push_full_bus_full_instruction_2;
        when execute_push_full_bus_full_instruction_2 =>
            if(ctr_repeat_states_limit = '1') then
                next_state <= fetch_execute_instruction;
            else
                next_state <= execute_push_full_bus_full_instruction_2;
            end if;
        when execute_pop_full_bus_full_instruction_1 =>
            next_state <= execute_pop_full_bus_full_instruction_2;
        when execute_pop_full_bus_full_instruction_2 =>
            next_state <= execute_pop_full_bus_full_instruction_3;
        when execute_pop_full_bus_full_instruction_3 =>
            if(ctr_repeat_states_limit = '1') then
                next_state <= execute_pop_full_bus_full_instruction_10;
            else
                next_state <= execute_pop_full_bus_full_instruction_3;
            end if;
        when execute_pop_full_bus_full_instruction_10 =>
            next_state <= fetch_execute_instruction;
        when execute_copy_small_bus_instruction_1 =>
            next_state <= execute_copy_small_bus_instruction_2;
        when execute_copy_small_bus_instruction_2 =>
            next_state <= execute_copy_small_bus_instruction_3;
        when execute_copy_small_bus_instruction_3 =>
            next_state <= fetch_execute_instruction;
        when execute_copy_full_bus_single_instruction_1 =>
            next_state <= execute_copy_full_bus_single_instruction_2;
        when execute_copy_full_bus_single_instruction_2 =>
            next_state <= fetch_execute_instruction;
        when execute_copy_full_bus_full_instruction_1 =>
            next_state <= execute_copy_full_bus_full_instruction_2;
        when execute_copy_full_bus_full_instruction_2 =>
            if(ctr_repeat_states_limit = '1') then
                next_state <= fetch_execute_instruction;
            else
                next_state <= execute_copy_full_bus_full_instruction_2;
            end if;
        when execute_load_value_single_mac_memory_1 =>
            next_state <= fetch_execute_instruction;
        when execute_load_value_full_mac_memory_1 =>
            next_state <= execute_load_value_full_mac_memory_2;
        when execute_load_value_full_mac_memory_2 =>
            next_state <= execute_load_value_full_mac_memory_3;
        when execute_load_value_full_mac_memory_3 =>
            if(ctr_repeat_states_limit = '1') then
                next_state <= fetch_execute_instruction;
            else
                next_state <= execute_load_value_full_mac_memory_3;
            end if;
        when execute_function_call_1 =>
            next_state <= execute_function_call_2;
        when execute_function_call_2 =>
            next_state <= execute_function_call_3;
        when execute_function_call_3 =>
            next_state <= fetch_execute_instruction;
        when execute_function_return_1 =>
            next_state <= execute_function_return_2;
        when execute_function_return_2 =>
            next_state <= execute_function_return_3;
        when execute_function_return_3 =>
            next_state <= execute_function_return_4;
        when execute_function_return_4 =>
            next_state <= fetch_execute_instruction;
        when execute_copy_array_small_bus_instruction_1 =>
            next_state <= execute_copy_array_small_bus_instruction_2;
        when execute_copy_array_small_bus_instruction_2 =>
            next_state <= execute_copy_array_small_bus_instruction_3;
        when execute_copy_array_small_bus_instruction_3 =>
            next_state <= execute_copy_array_small_bus_instruction_4;
        when execute_copy_array_small_bus_instruction_4 =>
            if(small_bus_address_burst_last_block = '1') then
                next_state <= execute_copy_array_small_bus_instruction_6;
            else
                next_state <= execute_copy_array_small_bus_instruction_5;
            end if;
        when execute_copy_array_small_bus_instruction_5 =>
            if(small_bus_address_burst_last_block = '1') then
                next_state <= execute_copy_array_small_bus_instruction_6;
            else
                next_state <= execute_copy_array_small_bus_instruction_5;
            end if;
        when execute_copy_array_small_bus_instruction_6 =>
            next_state <= fetch_execute_instruction;
        when execute_keccak_init_instruction_1 =>
            next_state <= execute_keccak_init_instruction_2;
        when execute_keccak_init_instruction_2 =>
            next_state <= execute_keccak_init_instruction_3;
        when execute_keccak_init_instruction_3 =>
            if(keccak_ready = '1') then
                next_state <= fetch_execute_instruction;
            else
                next_state <= execute_keccak_init_instruction_3;
            end if;
        when execute_keccak_go_instruction_1 =>
            next_state <= execute_keccak_go_instruction_2;
        when execute_keccak_go_instruction_2 =>
            next_state <= execute_keccak_go_instruction_3;
        when execute_keccak_go_instruction_3 =>
            if(keccak_ready = '1') then
                next_state <= fetch_execute_instruction;
            else
                next_state <= execute_keccak_go_instruction_3;
            end if;
        when execute_base_alu_instruction_1 =>
            next_state <= execute_base_alu_instruction_2;
        when execute_base_alu_instruction_2 =>
            next_state <= execute_base_alu_instruction_3;
        when execute_base_alu_instruction_3 =>
            next_state <= execute_base_alu_instruction_4;
        when execute_base_alu_instruction_4 =>
            next_state <= fetch_execute_instruction;
        when start_execute_8_mac_instruction_1 =>
            next_state <= start_execute_8_mac_instruction_2;
        when start_execute_8_mac_instruction_2 =>
            next_state <= start_execute_8_mac_instruction_3;
        when start_execute_8_mac_instruction_3 =>
            if(ctr_repeat_states_limit = '1') then
                next_state <= start_execute_8_mac_instruction_8;
            else
                next_state <= start_execute_8_mac_instruction_3;
            end if;
        when start_execute_8_mac_instruction_8 =>
            next_state <= start_execute_8_mac_instruction_9;
        when start_execute_8_mac_instruction_9 =>
            next_state <= execute_8_mac_instruction;
        when execute_8_mac_instruction =>
            next_state <= execute_8_mac_instruction;
            if(mac_free_flag = '1') then
                next_state <= fetch_execute_instruction;
            end if;
        when start_execute_4_mac_instruction_1 =>
            next_state <= start_execute_4_mac_instruction_2;
        when start_execute_4_mac_instruction_2 =>
            next_state <= start_execute_4_mac_instruction_3;
        when start_execute_4_mac_instruction_3 =>
            next_state <= start_execute_4_mac_instruction_4;
        when start_execute_4_mac_instruction_4 =>
            next_state <= start_execute_4_mac_instruction_5;
        when start_execute_4_mac_instruction_5 =>
            next_state <= execute_4_mac_instruction;
        when execute_4_mac_instruction =>
            next_state <= execute_4_mac_instruction;
            if(mac_free_flag = '1') then
                next_state <= fetch_execute_instruction;
            end if;
    end case;
end process;

end direct_mode;