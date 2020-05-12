#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# Implementation by Pedro Maat C. Massolino,
# hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/

import time
import random
import sys

from zedboard_sidh import *
import sike_core_utils
import SIDH_round2_spec
import sidh_fp2
import sike_fpga_constants_v128
import sike_fpga_constants_v256


tests_prom_folder = "../assembler/"

sike_core_mac_ram_start_address =                           0x00000;
sike_core_mac_ram_last_address =                            0x07FFF;
sike_core_base_alu_ram_start_address =                      0x0C000;
sike_core_base_alu_ram_last_address =                       0x0C3FF;
sike_core_keccak_core_start_address =                       0x0D000;
sike_core_keccak_core_last_address =                        0x0D007;
sike_core_reg_program_counter_address =                     0x0E000;
sike_core_reg_status_address =                              0x0E001;
sike_core_reg_operands_size_address =                       0x0E002;
sike_core_reg_prime_line_equal_one_address =                0x0E003;
sike_core_reg_prime_address_address =                       0x0E004;
sike_core_reg_prime_plus_one_address_address =              0x0E005;
sike_core_reg_prime_line_address_address =                  0x0E006;
sike_core_reg_2prime_address_address =                      0x0E007;
sike_core_reg_initial_stack_address_address =               0x0E008;
sike_core_reg_flag_address =                                0x0E009;
sike_core_reg_scalar_address_address =                      0x0E00A;

sike_core_mac_ram_prime_address =                           0x00000;
sike_core_mac_ram_prime_plus_one_address =                  0x00001;
sike_core_mac_ram_prime_line_address =                      0x00002;
sike_core_mac_ram_2prime_address =                          0x00003;
sike_core_mac_ram_const_r_address =                         0x00004;
sike_core_mac_ram_const_r2_address =                        0x00005;
sike_core_mac_ram_const_1_address =                         0x00006;
sike_core_mac_ram_inv_4_mont_address =                      0x00007;
sike_core_mac_ram_sidh_xpa_mont_address =                   0x00008;
sike_core_mac_ram_sidh_xpai_mont_address =                  0x00009;
sike_core_mac_ram_sidh_xqa_mont_address =                   0x0000A;
sike_core_mac_ram_sidh_xqai_mont_address =                  0x0000B;
sike_core_mac_ram_sidh_xra_mont_address =                   0x0000C;
sike_core_mac_ram_sidh_xrai_mont_address =                  0x0000D;
sike_core_mac_ram_sidh_xpb_mont_address =                   0x0000E;
sike_core_mac_ram_sidh_xpbi_mont_address =                  0x0000F;
sike_core_mac_ram_sidh_xqb_mont_address =                   0x00010;
sike_core_mac_ram_sidh_xqbi_mont_address =                  0x00011;
sike_core_mac_ram_sidh_xrb_mont_address =                   0x00012;
sike_core_mac_ram_sidh_xrbi_mont_address =                  0x00013;

sike_core_base_alu_ram_sike_s_start_address =               0x000FB;
sike_core_base_alu_ram_sike_sk_start_address =              0x0011B;
sike_core_base_alu_ram_sike_m_start_address =               0x0013B;
sike_core_base_alu_ram_sike_ss_start_address =              0x0015B;
sike_core_base_alu_ram_sike_c1_start_address =              0x0017B;
sike_core_base_alu_ram_sike_message_length_address =        0x0019B;
sike_core_base_alu_ram_sike_shared_secret_length_address =  0x0019C;
sike_core_base_alu_ram_oa_mask_address =                    0x0019D;
sike_core_base_alu_ram_ob_mask_address =                    0x0019E;
sike_core_base_alu_ram_oa_bits_address =                    0x0019F;
sike_core_base_alu_ram_ob_bits_address =                    0x001A0;
sike_core_base_alu_ram_prime_size_bits_address =            0x001A1;
sike_core_base_alu_ram_splits_alice_start_address =         0x001A2;
sike_core_base_alu_ram_max_row_alice_address =              0x002D0;
sike_core_base_alu_ram_splits_bob_start_address =           0x002D1;
sike_core_base_alu_ram_max_row_bob_address =                0x003FF;

sike_core_mac_ram_input_function_start_address =            0x00014;
sike_core_mac_ram_output_function_start_address =           0x00024;

test_program_start_fp_inv_test      = 1;
test_program_start_fp2_inv_test     = 27;
test_program_start_j_inv_test       = 55;
test_program_start_get_A_test       = 83;
test_program_start_inv_2_way_test   = 113;
test_program_start_ladder_3_pt_test = 149;
test_program_start_xDBLe_test       = 181;
test_program_start_get_4_isog_test  = 213;
test_program_start_eval_4_isog_test = 257;
test_program_start_xTPLe_test       = 299;
test_program_start_get_3_isog_test  = 331;
test_program_start_eval_3_isog_test = 363;
test_program_start_get_2_isog_test  = 395;
test_program_start_eval_2_isog_test = 423;

def load_program(zedboard, prom_file_name, base_word_size, base_word_size_signed_number_words):
    prom_file = open(prom_file_name, 'r')
    program = []
    prom_file.seek(0, 2)
    prom_file_size = prom_file.tell()
    prom_file.seek(0)
    while (prom_file.tell() != prom_file_size):
        program += [sike_core_utils.load_list_value_VHDL_MAC_memory_as_integer(prom_file, base_word_size, base_word_size_signed_number_words, 1, False)]
    print("Loading program into SIKE core:" + str(prom_file_name))
    zedboard.write_program_prom(0, program)
    print("Reading program uploaded into SIKE core")
    program_written = zedboard.read_program_prom(0, len(program))
    print("Verifying program uploaded into SIKE core")
    if(program_written == program):
        return True
    print(program)
    print(program_written)
    return False

def load_constants(zedboard, param):
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    prime_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[5])
    prime_plus_one_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[7])
    prime_line_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[8])
    prime2 = param[10]
    prime2_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[10])
    r_mod_prime_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[17])
    r2_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[18])
    constant_1_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[19])
    constant_inv_4_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[20])
    
    error_computation = False
        
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    oa = param[11]
    ob = param[12]
    oa_bits = param[15]
    ob_bits = param[16]
    oa_mask = param[13]
    ob_mask = param[14]
    
    prime_size_bits = param[6]
    sike_message_length = param[39]
    sike_shared_secret_length = param[40]
    
    alice_splits = param[33]
    alice_max_row = param[34]
    alice_max_int_points = param[35]
    bob_splits = param[36]
    bob_max_row = param[37]
    bob_max_int_points = param[38]
    
    starting_position_stack_sidh_core = param[41]
    
    enable_special_prime_line_arithmetic = param[9]
    
    alice_gen_points_mont = param[21:27]
    bob_gen_points_mont = param[27:33]
    alice_gen_points = param[42:48]
    bob_gen_points = param[48:54]
    
    test_value_xpa_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, alice_gen_points_mont[0])
    test_value_xpai_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, alice_gen_points_mont[1])
    test_value_xqa_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, alice_gen_points_mont[2])
    test_value_xqai_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, alice_gen_points_mont[3])
    test_value_xra_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, alice_gen_points_mont[4])
    test_value_xrai_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, alice_gen_points_mont[5])
    test_value_xpb_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, bob_gen_points_mont[0])
    test_value_xpbi_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, bob_gen_points_mont[1])
    test_value_xqb_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, bob_gen_points_mont[2])
    test_value_xqbi_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, bob_gen_points_mont[3])
    test_value_xrb_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, bob_gen_points_mont[4])
    test_value_xrbi_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, bob_gen_points_mont[5])
    
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_address, prime_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_plus_one_address, prime_plus_one_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_line_address, prime_line_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_2prime_address, prime2_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_const_r_address, r_mod_prime_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_const_r2_address, r2_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_const_1_address, constant_1_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_inv_4_mont_address, constant_inv_4_list, number_of_words)
    
    zedboard.write_mac_ram_operand(sike_core_mac_ram_sidh_xpa_mont_address,  test_value_xpa_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_sidh_xpai_mont_address, test_value_xpai_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_sidh_xqa_mont_address,  test_value_xqa_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_sidh_xqai_mont_address, test_value_xqai_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_sidh_xra_mont_address,  test_value_xra_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_sidh_xrai_mont_address, test_value_xrai_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_sidh_xpb_mont_address,  test_value_xpb_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_sidh_xpbi_mont_address, test_value_xpbi_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_sidh_xqb_mont_address,  test_value_xqb_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_sidh_xqbi_mont_address, test_value_xqbi_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_sidh_xrb_mont_address,  test_value_xrb_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_sidh_xrbi_mont_address, test_value_xrbi_mont_list, number_of_words)
    
    zedboard.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_message_length_address, sike_message_length)
    zedboard.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_shared_secret_length_address, sike_shared_secret_length)
    zedboard.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_oa_mask_address, oa_mask)
    zedboard.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_ob_mask_address, ob_mask)
    zedboard.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_oa_bits_address, oa_bits)
    zedboard.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_ob_bits_address, ob_bits)
    zedboard.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_prime_size_bits_address, prime_size_bits)
    start_address = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_splits_alice_start_address
    for i in range(0, len(alice_splits)):
        zedboard.write_package(start_address+i, alice_splits[i])
    for i in range(len(alice_splits), 302):
        zedboard.write_package(start_address+i, 0)
    zedboard.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_max_row_alice_address, alice_max_row)
    start_address = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_splits_bob_start_address
    for i in range(0, len(bob_splits)):
        zedboard.write_package(start_address+i, bob_splits[i])
    for i in range(len(bob_splits), 302):
        zedboard.write_package(start_address+i, 0)
    zedboard.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_max_row_bob_address, bob_max_row)
    
    zedboard.write_package(sike_core_reg_operands_size_address, number_of_words - 1)
    zedboard.write_package(sike_core_reg_prime_line_equal_one_address, enable_special_prime_line_arithmetic)
    zedboard.write_package(sike_core_reg_prime_address_address, 0)
    zedboard.write_package(sike_core_reg_prime_plus_one_address_address, 1)
    zedboard.write_package(sike_core_reg_prime_line_address_address, 2)
    zedboard.write_package(sike_core_reg_2prime_address_address, 3)
    zedboard.write_package(sike_core_reg_scalar_address_address, 0)
    zedboard.write_package(sike_core_reg_initial_stack_address_address, starting_position_stack_sidh_core)
    
def test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, starting_program_address, debug_mode=False):

    values_to_load_list = [sike_core_utils.integer_to_list(extended_word_size, number_of_words, each_value)  for each_value in values_to_load]

    for i in range(len(values_to_load_list)):
        zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + i, values_to_load_list[i], number_of_words)
    
    zedboard.write_package(sike_core_reg_program_counter_address, starting_program_address)
    
    time.sleep(0.1)
    
    while(not zedboard.isFree()):
        time.sleep(0.1)
    
    computed_test_value_o_list = [zedboard.read_mac_ram_operand(sike_core_mac_ram_output_function_start_address + i, number_of_words) for i in range(len(expected_output))]
    
    computed_test_value_o = [sike_core_utils.list_to_integer(extended_word_size, number_of_words, x) for x in computed_test_value_o_list]
    
    error_computation = False
    for i in range(len(computed_test_value_o)):
        if(computed_test_value_o[i] != expected_output[i]):
            error_computation = True
            break
    
    if((debug_mode) or (error_computation)):
        print("Error in computation ")
        print("Values loaded")
        for each_value in values_to_load:
            print(each_value)
        print("")
        print("Expected values")
        for each_value in expected_output:
            print(each_value)
        print("")
        print("Computed values")
        for each_value in computed_test_value_o:
            print(each_value)
        print("")
        return True
    return False

def test_sidh_function_fp_inv(zedboard, param, number_of_tests, debug_mode=False):
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [[1, 2], [prime - 2, prime - 1]]
    for test in fixed_tests:
        test_value_1 = test[0]
        test_value_2 = test[1]
        values_to_load = [test_value_1, test_value_2]
        expected_output = [pow(test_value_1, prime-2, prime), pow(test_value_2, prime-2, prime)]
        error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_fp_inv_test, debug_mode)
        tests_already_performed += 2
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests, 2):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_1 = random.randint(0, prime)
            test_value_2 = random.randint(0, prime)
            values_to_load = [test_value_1, test_value_2]
            expected_output = [pow(test_value_1, prime-2, prime), pow(test_value_2, prime-2, prime)]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_fp_inv_test, debug_mode)        
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_fp_inv(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function fp inv " +  param[0])
        error_computation = test_sidh_function_fp_inv(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_fp2_inv(zedboard, param, number_of_tests, debug_mode=False):
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    for test_value_1 in fixed_tests:
        for test_value_1i in fixed_tests:
            for test_value_2 in fixed_tests:
                for test_value_2i in fixed_tests:
                    values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i]
                    expected_value_1 = fp2([test_value_1, test_value_1i])**(-1)
                    expected_value_2 = fp2([test_value_2, test_value_2i])**(-1)
                    expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
                    error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_fp2_inv_test, debug_mode)
                    tests_already_performed += 2
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests, 2):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_1   = random.randint(1, prime)
            test_value_1i  = random.randint(1, prime)
            test_value_2   = random.randint(1, prime)
            test_value_2i  = random.randint(1, prime)
            values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i]
            expected_value_1 = fp2([test_value_1, test_value_1i])**(-1)
            expected_value_2 = fp2([test_value_2, test_value_2i])**(-1)
            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_fp2_inv_test, debug_mode)
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_fp2_inv(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function fp2 inv " +  param[0])
        error_computation = test_sidh_function_fp2_inv(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_j_invariant(zedboard, param, number_of_tests, debug_mode=False):
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    for test_value_1 in fixed_tests:
        for test_value_1i in fixed_tests:
            for test_value_2 in fixed_tests:
                for test_value_2i in fixed_tests:
                    values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i]
                    expected_value_1 = SIDH_round2_spec.j_invariant(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]))
                    expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1]]
                    error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_j_inv_test, debug_mode)
                    tests_already_performed += 2
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_1  = random.randint(0, prime)
            test_value_1i = random.randint(0, prime)
            test_value_2  = random.randint(0, prime)
            test_value_2i = random.randint(0, prime)
            values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i]
            expected_value_1 = SIDH_round2_spec.j_invariant(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]))
            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_j_inv_test, debug_mode)
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_j_invariant(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function j invariant " +  param[0])
        error_computation = test_sidh_function_j_invariant(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_get_A(zedboard, param, number_of_tests, debug_mode=False):
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    for test_value_1 in fixed_tests:
        for test_value_1i in fixed_tests:
            for test_value_2 in fixed_tests:
                for test_value_2i in fixed_tests:
                    for test_value_3 in fixed_tests:
                        for test_value_3i in fixed_tests:
                            values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i, test_value_3, test_value_3i]
                            expected_value_1 = SIDH_round2_spec.get_A(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]), fp2([test_value_3, test_value_3i]))
                            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1]]
                            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_get_A_test, debug_mode)
                            tests_already_performed += 1
                            if(error_computation):
                                break
                        if(error_computation):
                            break
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_1  = random.randint(0, prime)
            test_value_1i = random.randint(0, prime)
            test_value_2  = random.randint(0, prime)
            test_value_2i = random.randint(0, prime)
            test_value_3  = random.randint(0, prime)
            test_value_3i = random.randint(0, prime)
            values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i, test_value_3, test_value_3i]
            expected_value_1 = SIDH_round2_spec.get_A(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]), fp2([test_value_3, test_value_3i]))
            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_get_A_test, debug_mode)
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_get_A(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function get A " +  param[0])
        error_computation = test_sidh_function_get_A(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_inv_2_way(zedboard, param, number_of_tests, debug_mode=False):
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    for test_value_1 in fixed_tests:
        for test_value_1i in fixed_tests:
            for test_value_2 in fixed_tests:
                for test_value_2i in fixed_tests:
                    for test_value_3 in fixed_tests:
                        for test_value_3i in fixed_tests:
                            for test_value_4 in fixed_tests:
                                for test_value_4i in fixed_tests:
                                    values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i]
                                    expected_value_1 = fp2([test_value_1, test_value_1i])**(-1)
                                    expected_value_2 = fp2([test_value_2, test_value_2i])**(-1)
                                    expected_value_3 = fp2([test_value_3, test_value_3i])**(-1)
                                    expected_value_4 = fp2([test_value_4, test_value_4i])**(-1)
                                    expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1], expected_value_3.polynomial()[0], expected_value_3.polynomial()[1], expected_value_4.polynomial()[0], expected_value_4.polynomial()[1]]
                                    error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_inv_2_way_test, debug_mode)
                                    tests_already_performed += 1
                                    if(error_computation):
                                        break
                                if(error_computation):
                                    break
                            if(error_computation):
                                break
                        if(error_computation):
                            break
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_1  = random.randint(1, prime)
            test_value_1i = random.randint(1, prime)
            test_value_2  = random.randint(1, prime)
            test_value_2i = random.randint(1, prime)
            test_value_3  = random.randint(1, prime)
            test_value_3i = random.randint(1, prime)
            test_value_4  = random.randint(1, prime)
            test_value_4i = random.randint(1, prime)
            values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i]
            expected_value_1 = fp2([test_value_1, test_value_1i])**(-1)
            expected_value_2 = fp2([test_value_2, test_value_2i])**(-1)
            expected_value_3 = fp2([test_value_3, test_value_3i])**(-1)
            expected_value_4 = fp2([test_value_4, test_value_4i])**(-1)
            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1], expected_value_3.polynomial()[0], expected_value_3.polynomial()[1], expected_value_4.polynomial()[0], expected_value_4.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_inv_2_way_test, debug_mode)
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_inv_2_way(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function 2 way inversion " +  param[0])
        error_computation = test_sidh_function_inv_2_way(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_ladder_3_pt(zedboard, param, number_of_tests, debug_mode=False):
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    oa_bits = param[15]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    max_exponent_bit_length = oa_bits
    fixed_exponent_tests = [1, 2**max_exponent_bit_length-1]
    for test_value_1 in fixed_exponent_tests:
        for test_value_2 in fixed_tests:
            for test_value_2i in fixed_tests:
                for test_value_3 in fixed_tests:
                    for test_value_3i in fixed_tests:
                        for test_value_4 in fixed_tests:
                            for test_value_4i in fixed_tests:
                                for test_value_5 in fixed_tests:
                                    for test_value_5i in fixed_tests:
                                        values_to_load = [test_value_1, max_exponent_bit_length, test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i, test_value_5, test_value_5i]
                                        expected_value_1, expected_value_2 = SIDH_round2_spec.ladder3pt(fp2, fp2([test_value_2, test_value_2i]), fp2([test_value_3, test_value_3i]), fp2([test_value_4, test_value_4i]), fp2([test_value_5, test_value_5i]), test_value_1, max_exponent_bit_length)
                                        expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
                                        error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_ladder_3_pt_test, debug_mode)
                                        tests_already_performed += 1
                                        if(error_computation):
                                            break
                                    if(error_computation):
                                        break
                                if(error_computation):
                                    break
                            if(error_computation):
                                break
                        if(error_computation):
                            break
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_1  = random.randint(1, 2**max_exponent_bit_length-1)
            test_value_2  = random.randint(1, prime)
            test_value_2i = random.randint(1, prime)
            test_value_3  = random.randint(1, prime)
            test_value_3i = random.randint(1, prime)
            test_value_4  = random.randint(1, prime)
            test_value_4i = random.randint(1, prime)
            test_value_5  = random.randint(1, prime)
            test_value_5i = random.randint(1, prime)
            values_to_load = [test_value_1, max_exponent_bit_length, test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i, test_value_5, test_value_5i]
            expected_value_1, expected_value_2 = SIDH_round2_spec.ladder3pt(fp2, fp2([test_value_2, test_value_2i]), fp2([test_value_3, test_value_3i]), fp2([test_value_4, test_value_4i]), fp2([test_value_5, test_value_5i]), test_value_1, max_exponent_bit_length)
            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_ladder_3_pt_test, debug_mode)
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_ladder_3_pt(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function ladder 3 points " +  param[0])
        error_computation = test_sidh_function_ladder_3_pt(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_xdble(zedboard, param, number_of_tests, debug_mode=False):
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    test_value_1 = 100
    for test_value_2 in fixed_tests:
        for test_value_2i in fixed_tests:
            for test_value_3 in fixed_tests:
                for test_value_3i in fixed_tests:
                    for test_value_4 in fixed_tests:
                        for test_value_4i in fixed_tests:
                            for test_value_5 in fixed_tests:
                                for test_value_5i in fixed_tests:
                                    values_to_load = [test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i, test_value_5, test_value_5i, test_value_1]
                                    expected_value_1, expected_value_2 = SIDH_round2_spec.xDBLe(fp2, fp2([test_value_2, test_value_2i]), fp2([test_value_3, test_value_3i]), fp2([test_value_4, test_value_4i]), fp2([test_value_5, test_value_5i]), test_value_1)
                                    expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
                                    error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_xDBLe_test, debug_mode)
                                    tests_already_performed += 1
                                    if(error_computation):
                                        break
                                if(error_computation):
                                    break
                            if(error_computation):
                                break
                        if(error_computation):
                            break
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        test_value_1 = 100
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_2  = random.randint(1, prime)
            test_value_2i = random.randint(1, prime)
            test_value_3  = random.randint(1, prime)
            test_value_3i = random.randint(1, prime)
            test_value_4  = random.randint(1, prime)
            test_value_4i = random.randint(1, prime)
            test_value_5  = random.randint(1, prime)
            test_value_5i = random.randint(1, prime)
            values_to_load = [test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i, test_value_5, test_value_5i, test_value_1]
            expected_value_1, expected_value_2 = SIDH_round2_spec.xDBLe(fp2, fp2([test_value_2, test_value_2i]), fp2([test_value_3, test_value_3i]), fp2([test_value_4, test_value_4i]), fp2([test_value_5, test_value_5i]), test_value_1)
            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_xDBLe_test, debug_mode)
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_xdble(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function xdble " +  param[0])
        error_computation = test_sidh_function_xdble(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_get_4_isog(zedboard, param, number_of_tests, debug_mode=False):
    
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    for test_value_1 in fixed_tests:
        for test_value_1i in fixed_tests:
            for test_value_2 in fixed_tests:
                for test_value_2i in fixed_tests:
                    values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i]
                    expected_value_1, expected_value_2, expected_value_3, expected_value_4, expected_value_5 = SIDH_round2_spec.get_4_isog(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]))
                    expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1], expected_value_3.polynomial()[0], expected_value_3.polynomial()[1], expected_value_4.polynomial()[0], expected_value_4.polynomial()[1], expected_value_5.polynomial()[0], expected_value_5.polynomial()[1]]
                    error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_get_4_isog_test, debug_mode)
                    tests_already_performed += 1
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_1  = random.randint(1, prime)
            test_value_1i = random.randint(1, prime)
            test_value_2  = random.randint(1, prime)
            test_value_2i = random.randint(1, prime)
            values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i]
            expected_value_1, expected_value_2, expected_value_3, expected_value_4, expected_value_5 = SIDH_round2_spec.get_4_isog(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]))
            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1], expected_value_3.polynomial()[0], expected_value_3.polynomial()[1], expected_value_4.polynomial()[0], expected_value_4.polynomial()[1], expected_value_5.polynomial()[0], expected_value_5.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_get_4_isog_test, debug_mode)
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_get_4_isog(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function get 4 isog " +  param[0])
        error_computation = test_sidh_function_get_4_isog(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_eval_4_isog(zedboard, param, number_of_tests, debug_mode=False):
    
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    for test_value_1 in fixed_tests:
        for test_value_1i in fixed_tests:
            for test_value_2 in fixed_tests:
                for test_value_2i in fixed_tests:
                    for test_value_3 in fixed_tests:
                        for test_value_3i in fixed_tests:
                            for test_value_4 in fixed_tests:
                                for test_value_4i in fixed_tests:
                                    for test_value_5 in fixed_tests:
                                        for test_value_5i in fixed_tests:
                                            values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i, test_value_5, test_value_5i]
                                            expected_value_1, expected_value_2 = SIDH_round2_spec.eval_4_isog(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]), fp2([test_value_3, test_value_3i]), fp2([test_value_4, test_value_4i]), fp2([test_value_5, test_value_5i]))
                                            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
                                            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_eval_4_isog_test, debug_mode)
                                            tests_already_performed += 1
                                            if(error_computation):
                                                break
                                        if(error_computation):
                                            break
                                    if(error_computation):
                                        break
                                if(error_computation):
                                    break
                            if(error_computation):
                                break
                        if(error_computation):
                            break
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_1  = random.randint(1, prime)
            test_value_1i = random.randint(1, prime)
            test_value_2  = random.randint(1, prime)
            test_value_2i = random.randint(1, prime)
            test_value_3  = random.randint(1, prime)
            test_value_3i = random.randint(1, prime)
            test_value_4  = random.randint(1, prime)
            test_value_4i = random.randint(1, prime)
            test_value_5  = random.randint(1, prime)
            test_value_5i = random.randint(1, prime)
            values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i, test_value_5, test_value_5i]
            expected_value_1, expected_value_2 = SIDH_round2_spec.eval_4_isog(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]), fp2([test_value_3, test_value_3i]), fp2([test_value_4, test_value_4i]), fp2([test_value_5, test_value_5i]))
            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_eval_4_isog_test, debug_mode)
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_eval_4_isog(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function eval 4 isog " +  param[0])
        error_computation = test_sidh_function_eval_4_isog(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_xtple(zedboard, param, number_of_tests, debug_mode=False):
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    test_value_1 = 100
    for test_value_2 in fixed_tests:
        for test_value_2i in fixed_tests:
            for test_value_3 in fixed_tests:
                for test_value_3i in fixed_tests:
                    for test_value_4 in fixed_tests:
                        for test_value_4i in fixed_tests:
                            for test_value_5 in fixed_tests:
                                for test_value_5i in fixed_tests:
                                    values_to_load = [test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i, test_value_5, test_value_5i, test_value_1]
                                    expected_value_1, expected_value_2 = SIDH_round2_spec.xTPLe(fp2, fp2([test_value_2, test_value_2i]), fp2([test_value_3, test_value_3i]), fp2([test_value_5, test_value_5i]), fp2([test_value_4, test_value_4i]), test_value_1)
                                    expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
                                    error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_xTPLe_test, debug_mode)
                                    tests_already_performed += 1
                                    if(error_computation):
                                        break
                                if(error_computation):
                                    break
                            if(error_computation):
                                break
                        if(error_computation):
                            break
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        test_value_1 = 100
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_2  = random.randint(1, prime)
            test_value_2i = random.randint(1, prime)
            test_value_3  = random.randint(1, prime)
            test_value_3i = random.randint(1, prime)
            test_value_4  = random.randint(1, prime)
            test_value_4i = random.randint(1, prime)
            test_value_5  = random.randint(1, prime)
            test_value_5i = random.randint(1, prime)
            values_to_load = [test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i, test_value_5, test_value_5i, test_value_1]
            expected_value_1, expected_value_2 = SIDH_round2_spec.xTPLe(fp2, fp2([test_value_2, test_value_2i]), fp2([test_value_3, test_value_3i]), fp2([test_value_5, test_value_5i]), fp2([test_value_4, test_value_4i]), test_value_1)
            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_xTPLe_test, debug_mode)
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_xtple(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function xtple " +  param[0])
        error_computation = test_sidh_function_xtple(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_get_3_isog(zedboard, param, number_of_tests, debug_mode=False):
    
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    for test_value_1 in fixed_tests:
        for test_value_1i in fixed_tests:
            for test_value_2 in fixed_tests:
                for test_value_2i in fixed_tests:
                    values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i]
                    expected_value_1, expected_value_2, expected_value_3, expected_value_4 = SIDH_round2_spec.get_3_isog(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]))
                    expected_output = [expected_value_2.polynomial()[0], expected_value_2.polynomial()[1], expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_3.polynomial()[0], expected_value_3.polynomial()[1], expected_value_4.polynomial()[0], expected_value_4.polynomial()[1]]
                    error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_get_3_isog_test, debug_mode)
                    tests_already_performed += 1
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_1  = random.randint(1, prime)
            test_value_1i = random.randint(1, prime)
            test_value_2  = random.randint(1, prime)
            test_value_2i = random.randint(1, prime)
            values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i]
            expected_value_1, expected_value_2, expected_value_3, expected_value_4 = SIDH_round2_spec.get_3_isog(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]))
            expected_output = [expected_value_2.polynomial()[0], expected_value_2.polynomial()[1], expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_3.polynomial()[0], expected_value_3.polynomial()[1], expected_value_4.polynomial()[0], expected_value_4.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_get_3_isog_test, debug_mode)
            
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_get_3_isog(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function get 3 isog " +  param[0])
        error_computation = test_sidh_function_get_3_isog(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_eval_3_isog(zedboard, param, number_of_tests, debug_mode=False):
    
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    for test_value_1 in fixed_tests:
        for test_value_1i in fixed_tests:
            for test_value_2 in fixed_tests:
                for test_value_2i in fixed_tests:
                    for test_value_3 in fixed_tests:
                        for test_value_3i in fixed_tests:
                            for test_value_4 in fixed_tests:
                                for test_value_4i in fixed_tests:
                                    values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i]
                                    expected_value_1, expected_value_2 = SIDH_round2_spec.eval_3_isog(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]), fp2([test_value_3, test_value_3i]), fp2([test_value_4, test_value_4i]))
                                    expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
                                    error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_eval_3_isog_test, debug_mode)
                                    tests_already_performed += 1
                                    if(error_computation):
                                        break
                                if(error_computation):
                                    break
                            if(error_computation):
                                break
                        if(error_computation):
                            break
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_1  = random.randint(1, prime)
            test_value_1i = random.randint(1, prime)
            test_value_2  = random.randint(1, prime)
            test_value_2i = random.randint(1, prime)
            test_value_3  = random.randint(1, prime)
            test_value_3i = random.randint(1, prime)
            test_value_4  = random.randint(1, prime)
            test_value_4i = random.randint(1, prime)
            values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i]
            expected_value_1, expected_value_2 = SIDH_round2_spec.eval_3_isog(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]), fp2([test_value_3, test_value_3i]), fp2([test_value_4, test_value_4i]))
            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_eval_3_isog_test, debug_mode)
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_eval_3_isog(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function eval 3 isog " +  param[0])
        error_computation = test_sidh_function_eval_3_isog(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_get_2_isog(zedboard, param, number_of_tests, debug_mode=False):
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    for test_value_1 in fixed_tests:
        for test_value_1i in fixed_tests:
            for test_value_2 in fixed_tests:
                for test_value_2i in fixed_tests:
                    values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i]
                    expected_value_1, expected_value_2 = SIDH_round2_spec.get_2_isog(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]))
                    expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
                    error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_get_2_isog_test, debug_mode)
                    tests_already_performed += 1
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_1  = random.randint(1, prime)
            test_value_1i = random.randint(1, prime)
            test_value_2  = random.randint(1, prime)
            test_value_2i = random.randint(1, prime)
            values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i]
            expected_value_1, expected_value_2 = SIDH_round2_spec.get_2_isog(fp2, fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]))
            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_get_2_isog_test, debug_mode)
            
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_get_2_isog(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function get 2 isog " +  param[0])
        error_computation = test_sidh_function_get_2_isog(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_sidh_function_eval_2_isog(zedboard, param, number_of_tests, debug_mode=False):
    
    
    load_constants(zedboard, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    error_computation = False
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, prime-1]
    for test_value_1 in fixed_tests:
        for test_value_1i in fixed_tests:
            for test_value_2 in fixed_tests:
                for test_value_2i in fixed_tests:
                    for test_value_3 in fixed_tests:
                        for test_value_3i in fixed_tests:
                            for test_value_4 in fixed_tests:
                                for test_value_4i in fixed_tests:
                                    values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i]
                                    expected_value_1, expected_value_2 = SIDH_round2_spec.eval_2_isog(fp2, fp2([test_value_3, test_value_3i]), fp2([test_value_4, test_value_4i]), fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]))
                                    expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
                                    error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_eval_2_isog_test, debug_mode)
                                    tests_already_performed += 1
                                    if(error_computation):
                                        break
                                if(error_computation):
                                    break
                            if(error_computation):
                                break
                        if(error_computation):
                            break
                    if(error_computation):
                        break
                if(error_computation):
                    break
            if(error_computation):
                break
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_1  = random.randint(1, prime)
            test_value_1i = random.randint(1, prime)
            test_value_2  = random.randint(1, prime)
            test_value_2i = random.randint(1, prime)
            test_value_3  = random.randint(1, prime)
            test_value_3i = random.randint(1, prime)
            test_value_4  = random.randint(1, prime)
            test_value_4i = random.randint(1, prime)
            values_to_load = [test_value_1, test_value_1i, test_value_2, test_value_2i, test_value_3, test_value_3i, test_value_4, test_value_4i]
            expected_value_1, expected_value_2 = SIDH_round2_spec.eval_2_isog(fp2, fp2([test_value_3, test_value_3i]), fp2([test_value_4, test_value_4i]), fp2([test_value_1, test_value_1i]), fp2([test_value_2, test_value_2i]))
            expected_output = [expected_value_1.polynomial()[0], expected_value_1.polynomial()[1], expected_value_2.polynomial()[0], expected_value_2.polynomial()[1]]
            error_computation = test_single_sidh_function(zedboard, base_word_size, extended_word_size, number_of_words, values_to_load, expected_output, test_program_start_eval_2_isog_test, debug_mode)
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_function_eval_2_isog(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH function eval 2 isog " +  param[0])
        error_computation = test_sidh_function_eval_2_isog(zedboard, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_all_sidh_basic_procedures(zedboard, version, only_one_parameter=None):
    sike_base_word_size = 16
    if(version == '256'):
        sike_extended_word_size = 256
        sike_fpga_constants = sike_fpga_constants_v256.sike_fpga_constants_v256
    elif(version == '128'):
        sike_extended_word_size = 128
        sike_fpga_constants = sike_fpga_constants_v128.sike_fpga_constants_v128
    number_of_tests = 100
    tests_working_folder = "../hw_sidh_tests_v"+str(sike_extended_word_size)+"/"
    if(load_program(zedboard, tests_prom_folder + "test_sidh_basic_procedures_v" + str(sike_extended_word_size)+ ".dat", sike_base_word_size, 4)):
        print("Program loaded correctly into SIKE core")
        test_all_sidh_function_fp_inv(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_fp2_inv(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_j_invariant(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_get_A(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_inv_2_way(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_ladder_3_pt(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_xdble(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_get_4_isog(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_eval_4_isog(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_xtple(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_get_3_isog(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_eval_3_isog(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_get_2_isog(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
        test_all_sidh_function_eval_2_isog(zedboard, sike_fpga_constants, number_of_tests, only_one_parameter)
    else:
        print('Program loading failed')

zedboard = Zedboard('COM4', sys.argv[1])
#zedboard.read_initial_message(34)
while(not zedboard.isFree()):
    time.sleep(0.01)
zedboard.flush()

test_all_sidh_basic_procedures(zedboard, sys.argv[1])

zedboard.disconnect()