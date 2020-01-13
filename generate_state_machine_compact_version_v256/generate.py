# -*- coding: utf-8 -*-
#
# Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/
#
import sys

nop_4_stages = {}
nop_8_stages = {}

nop_4_stages['next_sm_rotation_size'] = '10'
nop_4_stages['next_sel_address_a'] = '0'
nop_4_stages['next_sel_address_b_prime'] = '00'
nop_4_stages['next_sm_specific_carmela_address_a'] = '000'
nop_4_stages['next_sm_specific_carmela_address_b'] = '000'
nop_4_stages['next_sm_specific_carmela_address_o'] = '000'
nop_4_stages['next_sm_specific_carmela_next_address_o'] = '001'
nop_4_stages['next_carmela_enable_signed_a'] = '0'
nop_4_stages['next_carmela_enable_signed_b'] = '0'
nop_4_stages['next_carmela_sel_load_reg_a'] = '11'
nop_4_stages['next_carmela_clear_reg_b'] = '1'
nop_4_stages['next_carmela_clear_reg_acc'] = '1'
nop_4_stages['next_carmela_sel_shift_reg_o'] = '0'
nop_4_stages['next_carmela_enable_update_reg_s'] = '0'
nop_4_stages['next_carmela_sel_reg_s_reg_o_sign'] = '0'
nop_4_stages['next_carmela_reg_s_reg_o_positive'] = '0'
nop_4_stages['next_sm_sign_a_mode'] = '0'
nop_4_stages['next_sm_carmela_operation_mode'] = '01'
nop_4_stages['next_carmela_enable_reg_s_mask'] = '0'
nop_4_stages['next_carmela_subtraction_reg_a_b'] = '0'
nop_4_stages['next_carmela_sel_multiply_two_a_b'] = '0'
nop_4_stages['next_carmela_sel_reg_y_output'] = '0'
nop_4_stages['next_sm_carmela_write_enable_output'] = '0'
nop_4_stages['next_carmela_memory_double_mode'] = '0'
nop_4_stages['next_carmela_memory_only_write_mode'] = '0'
nop_4_stages['next_base_address_generator_o_increment_previous_address'] = '0'
nop_4_stages['last_state'] = '1'
nop_4_stages['current_operand_size'] = '000'
nop_4_stages['next_operation_same_operand_size'] = '00000'
nop_4_stages['next_operation_different_operand_size'] = '0000000'
nop_4_stages['comment'] = '-- NOP 4 stages                  \n-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;\n'

nop_8_stages['next_sm_rotation_size'] = '11'
nop_8_stages['next_sel_address_a'] = '0'
nop_8_stages['next_sel_address_b_prime'] = '00'
nop_8_stages['next_sm_specific_carmela_address_a'] = '000'
nop_8_stages['next_sm_specific_carmela_address_b'] = '000'
nop_8_stages['next_sm_specific_carmela_address_o'] = '000'
nop_8_stages['next_sm_specific_carmela_next_address_o'] = '001'
nop_8_stages['next_carmela_enable_signed_a'] = '0'
nop_8_stages['next_carmela_enable_signed_b'] = '0'
nop_8_stages['next_carmela_sel_load_reg_a'] = '11'
nop_8_stages['next_carmela_clear_reg_b'] = '1'
nop_8_stages['next_carmela_clear_reg_acc'] = '1'
nop_8_stages['next_carmela_sel_shift_reg_o'] = '0'
nop_8_stages['next_carmela_enable_update_reg_s'] = '0'
nop_8_stages['next_carmela_sel_reg_s_reg_o_sign'] = '0'
nop_8_stages['next_carmela_reg_s_reg_o_positive'] = '0'
nop_8_stages['next_sm_sign_a_mode'] = '0'
nop_8_stages['next_sm_carmela_operation_mode'] = '10'
nop_8_stages['next_carmela_enable_reg_s_mask'] = '0'
nop_8_stages['next_carmela_subtraction_reg_a_b'] = '0'
nop_8_stages['next_carmela_sel_multiply_two_a_b'] = '0'
nop_8_stages['next_carmela_sel_reg_y_output'] = '0'
nop_8_stages['next_sm_carmela_write_enable_output'] = '0'
nop_8_stages['next_carmela_memory_double_mode'] = '0'
nop_8_stages['next_carmela_memory_only_write_mode'] = '0'
nop_8_stages['next_base_address_generator_o_increment_previous_address'] = '0'
nop_8_stages['last_state'] = '1'
nop_8_stages['current_operand_size'] = '000'
nop_8_stages['next_operation_same_operand_size'] = '00000'
nop_8_stages['next_operation_different_operand_size'] = '0000000'
nop_8_stages['comment'] = '-- NOP 8 stages                  \n-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;\n'


def check_decode_state_name(line):
    line_without_spaces_lowercase = line.lower().strip(' ').split(' ')
    state_name = None
    state_number = None
    if(line_without_spaces_lowercase[0] == 'when'):
        full_state_name = line_without_spaces_lowercase[1]
        state_name, state_number = full_state_name.rsplit('_', 1)
    return state_name, state_number

def check_comment(line):
    line_without_spaces_lowercase = line.lower().strip(' ')
    line_without_leading_spaces = None
    if(line_without_spaces_lowercase[0:2] == '--'):
        line_without_leading_spaces = line.strip()
    return line_without_leading_spaces
    
def decode_state_value(line):
    line_lowercase_no_spaces = line.lower().strip(' ')
    command_split = line_lowercase_no_spaces.partition('<=')
    command_split_name = command_split[0].strip()
    first_index = command_split[2].find('"')
    if(first_index == -1):
        first_index = command_split[2].find("'")
    last_index = command_split[2].rfind('"')
    if(last_index == -1):
        last_index = command_split[2].rfind("'")
    command_split_value = command_split[2][first_index+1:last_index]
    return command_split_name, command_split_value
    
    
def check_if(line):
    line_lowercase = line.lower()
    line_lowercase_no_parenthesis = line.replace('(', ' ').replace(')', ' ')
    line_lowercase_no_spaces = line_lowercase_no_parenthesis.strip().split(' ')
    if(line_lowercase_no_spaces[0] == 'if'):
        return True
    return False
    
def check_next_state_number(line):
    line_lowercase_no_spaces = line.lower().strip(' ')
    command_split = line_lowercase_no_spaces.partition('<=')
    next_state_name_clean = command_split[2].strip().strip(';')
    state_name, state_number = next_state_name_clean.rsplit('_', 1)
    return state_name, state_number

def write_value_and_comment(file, state_name, state_number, state_value, program_counter, is_last):
    file.write('-- ' + ' (' + str(program_counter) + ') ' + state_name + '_' + state_number + '\n')
    file.write(state_value['comment'])
    
    state_value_list = ['0' for i in range(30)]
    
    state_value_list[0]  = state_value['next_sm_rotation_size']
    state_value_list[1]  = state_value['next_sel_address_a']
    state_value_list[2]  = state_value['next_sel_address_b_prime']
    state_value_list[3]  = state_value['next_sm_specific_carmela_address_a']
    state_value_list[4]  = state_value['next_sm_specific_carmela_address_b']
    state_value_list[5]  = state_value['next_sm_specific_carmela_address_o']
    state_value_list[6]  = state_value['next_sm_specific_carmela_next_address_o']
    state_value_list[7]  = state_value['next_carmela_enable_signed_a']
    state_value_list[8]  = state_value['next_carmela_enable_signed_b']
    state_value_list[9] = state_value['next_carmela_sel_load_reg_a']
    state_value_list[10] = state_value['next_carmela_clear_reg_b']
    state_value_list[11] = state_value['next_carmela_clear_reg_acc']
    state_value_list[12] = state_value['next_carmela_sel_shift_reg_o']
    state_value_list[13] = state_value['next_carmela_enable_update_reg_s']
    state_value_list[14] = state_value['next_carmela_sel_reg_s_reg_o_sign']
    state_value_list[15] = state_value['next_carmela_reg_s_reg_o_positive']
    state_value_list[16] = state_value['next_sm_sign_a_mode']
    state_value_list[17] = state_value['next_sm_carmela_operation_mode']
    state_value_list[18] = state_value['next_carmela_enable_reg_s_mask']
    state_value_list[19] = state_value['next_carmela_subtraction_reg_a_b']
    state_value_list[20] = state_value['next_carmela_sel_multiply_two_a_b']
    state_value_list[21] = state_value['next_carmela_sel_reg_y_output']
    state_value_list[22] = state_value['next_sm_carmela_write_enable_output']
    state_value_list[23] = state_value['next_carmela_memory_double_mode']
    state_value_list[24] = state_value['next_carmela_memory_only_write_mode']
    state_value_list[25] = state_value['next_base_address_generator_o_increment_previous_address']
    
    state_value_list[26] = state_value['last_state']
    state_value_list[27] = state_value['current_operand_size']
    state_value_list[28] = state_value['next_operation_same_operand_size']
    state_value_list[29] = state_value['next_operation_different_operand_size']
    
    state_value_string = ''
    for value in state_value_list:
        state_value_string = value + state_value_string
    
    string_value_formated = '"' + state_value_string + '"'
    if(not is_last):
        string_value_formated = string_value_formated + ','
    string_value_formated = string_value_formated + '\n'
    file.write(string_value_formated)
    
def read_state_description_and_fill_dictionary(filename_state_output):
    file_state = open(filename_state_output, 'r')
    all_state_values = {'multiplication_direct':{}, 'square_direct':{}, 'multiplication_with_reduction':{}, 'multiplication_with_reduction_special_prime':{}, 'square_with_reduction':{}, 'square_with_reduction_special_prime':{}, 'addition_subtraction_direct':{}, 'iterative_modular_reduction':{}}
    
    state_name = None
    state_number = None
    while(state_name == None):
        current_line = file_state.readline()
        state_name, state_number = check_decode_state_name(current_line)

    current_state_name = state_name
    current_state_number = state_number
    current_values = {}
    current_values['last_state'] = '0'
    current_values['current_operand_size'] = '000'
    current_values['next_operation_same_operand_size'] = '00000'
    current_values['next_operation_different_operand_size'] = '0000000'
    current_line = file_state.readline()
    while(current_line != ''):
        # A new state has been reached
        state_name, state_number = check_decode_state_name(current_line)
        if(state_name != None):
            current_dict = all_state_values[current_state_name]
            current_dict[current_state_number] = current_values
            if(int(state_number) != int(current_state_number) + 1):
                if((current_state_name == 'addition_subtraction_direct') or (current_state_name == 'iterative_modular_reduction')):
                    current_dict[str(int(current_state_number) + 1)] = nop_4_stages
                else:
                    current_dict[str(int(current_state_number) + 1)] = nop_8_stages
            all_state_values[current_state_name] = current_dict
            current_state_name = state_name
            current_state_number = state_number
            current_values = {}
            current_values['last_state'] = '0'
            current_values['current_operand_size'] = '000'
            current_values['next_operation_same_operand_size'] = '00000'
            current_values['next_operation_different_operand_size'] = '0000000'
        else:
            comment_line = check_comment(current_line)
            if(comment_line != None):
                # A comment line has been reached
                comment_line = comment_line + '\n'
                if('comment' in current_values):
                    current_values['comment'] = current_values['comment'] + comment_line
                else:
                    current_values['comment'] = comment_line
            else:
                # It is most likely a command
                command_name, command_value = decode_state_value(current_line)
                current_values[command_name] = command_value
            
        current_line = file_state.readline()
        
    current_dict = all_state_values[current_state_name]
    current_dict[current_state_number] = current_values
    if((current_state_name == 'addition_subtraction_direct') or (current_state_name == 'iterative_modular_reduction')):
        current_dict[str(int(current_state_number) + 1)] = nop_4_stages
    else:
        current_dict[str(int(current_state_number) + 1)] = nop_8_stages
        all_state_values[current_state_name] = current_dict
    
    file_state.close()
    return all_state_values
    
def read_state_flow_and_fill_dictionary(filename_state_flow, all_state_values):
    file_state = open(filename_state_flow, 'r')
    state_name = None
    state_number = None
    while(state_name == None):
        current_line = file_state.readline()
        state_name, state_number = check_decode_state_name(current_line)
    current_state_name = state_name
    current_state_number = state_number
    current_operand_size = 1
    next_operation_different_operand_size = 1
    first_internal_if = False
    current_line = file_state.readline()
    while(current_line != ''):
        # A new state has been reached
        state_name, state_number = check_decode_state_name(current_line)
        if(state_name != None):
            all_state_values[current_state_name][current_state_number]['current_operand_size'] = bin(current_operand_size-1)[2:].zfill(3)
            all_state_values[current_state_name][current_state_number]['next_operation_same_operand_size'] = '00001'
            all_state_values[current_state_name][current_state_number]['next_operation_different_operand_size'] = bin(next_operation_different_operand_size)[2:].zfill(7)
            if(state_name != current_state_name):
                current_operand_size = 1
            elif(int(state_number) != int(current_state_number) + 1):
                current_operand_size += 1
            current_state_name = state_name
            current_state_number = state_number
            next_operation_different_operand_size = 1
            first_internal_if = False
        else:
            if(check_if(current_line)):
                if(first_internal_if == False):
                    first_internal_if = True
                else:
                    # Ignore the next two lines
                    current_line = file_state.readline()
                    current_line = file_state.readline()
                    # The line with the far away jump
                    current_line = file_state.readline()
                    jump_state_name, jump_state_number = check_next_state_number(current_line)
                    next_operation_different_operand_size = int(jump_state_number) - int(current_state_number)
                    if(next_operation_different_operand_size >= 128):
                        print('More bits are necessary: ' + str(next_operation_different_operand_size))
                    first_internal_if = False
        current_line = file_state.readline()
    all_state_values[current_state_name][current_state_number]['current_operand_size'] = bin(current_operand_size-1)[2:].zfill(3)
    all_state_values[current_state_name][current_state_number]['next_operation_same_operand_size'] = '00001'
    all_state_values[current_state_name][current_state_number]['next_operation_different_operand_size'] = bin(next_operation_different_operand_size)[2:].zfill(7)
    file_state.close()
    return all_state_values
    
def generate_compact_version(filename_state_output, filename_state_flow, filename_compact_memory):
    all_state_values = read_state_description_and_fill_dictionary(filename_state_output)
    all_state_values = read_state_flow_and_fill_dictionary(filename_state_flow, all_state_values)
    
    list_of_possible_names = ['multiplication_direct', 'square_direct', 'multiplication_with_reduction', 'multiplication_with_reduction_special_prime', 'square_with_reduction', 'square_with_reduction_special_prime', 'addition_subtraction_direct', 'iterative_modular_reduction']
    
    file_compact = open(filename_compact_memory, 'w')
    
    program_counter = 0
    
    for possible_name in list_of_possible_names[0:-1]:
        all_values = all_state_values[possible_name]
        current_number = 0
        current_number_str = str(current_number)
        while(current_number_str in all_values):
            current_value = all_values[current_number_str]
            write_value_and_comment(file_compact, possible_name, current_number_str, current_value, program_counter, False)
            program_counter += 1
            current_number = current_number + 1
            current_number_str = str(current_number)
            
    all_values = all_state_values[list_of_possible_names[-1]]
    current_number = 0
    next_number = 1
    current_number_str = str(current_number)
    next_number_str = str(next_number)
    while(current_number_str in all_values):
        current_value = all_values[current_number_str]
        if(next_number_str in all_values):
            write_value_and_comment(file_compact, list_of_possible_names[-1], current_number_str, current_value, program_counter, False)
        else:
            write_value_and_comment(file_compact, list_of_possible_names[-1], current_number_str, current_value, program_counter, True)
        program_counter += 1
        current_number = next_number
        current_number_str = next_number_str
        next_number = next_number + 1
        next_number_str = str(next_number)
    file_compact.close()
    
    
def print_main_class_help():
    print('The parameters options are:')
    print('')
    print('generate_memory_big_integer_mac_unit_carmela_state_machine_v4_compact.py file_state_output.txt file_state_flow.txt file_state_compact.txt')
    print('')
    print("file_state_output.txt")
    print("The state machine output for each value")
    print('')
    print("file_state_flow.dat")
    print("The state machine flow for each part")
    print('')
    print("file_state_compact.dat")
    print("The compact version")
    print('')
    
    

if __name__ == "__main__":
    argc = len(sys.argv)
    if(argc == 4):
        filename_state_output = sys.argv[1]
        filename_state_flow   = sys.argv[2]
        filename_compact_memory = sys.argv[3]
        generate_compact_version(filename_state_output, filename_state_flow, filename_compact_memory)
    else:
        print("Unknown amount of options")
        print('')
        print_main_class_help() 