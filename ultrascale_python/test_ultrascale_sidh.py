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

from ultrascale_sidh import *
import sike_core_utils
import SIDH_round2_spec
import sidh_fp2
import sike_fpga_constants_v128
import sike_fpga_constants_v256


tests_prom_folder = "../assembler/"

program_start_address_test_sike_kem_keygen = 1
program_start_address_test_sike_kem_enc = 3
program_start_address_test_sike_kem_dec = 5
program_start_address_test_sidh_keygen_alice = 7
program_start_address_test_sidh_keygen_bob = 9
program_start_address_test_sidh_shared_secret_alice = 11
program_start_address_test_sidh_shared_secret_bob = 13

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

def load_program(ultrascale, prom_file_name, base_word_size, base_word_size_signed_number_words):
    prom_file = open(prom_file_name, 'r')
    program = []
    prom_file.seek(0, 2)
    prom_file_size = prom_file.tell()
    prom_file.seek(0)
    while (prom_file.tell() != prom_file_size):
        program += [sike_core_utils.load_list_value_VHDL_MAC_memory_as_integer(prom_file, base_word_size, base_word_size_signed_number_words, 1, False)]
    print("Loading program into SIKE core:" + str(prom_file_name))
    ultrascale.write_program_prom(0, program)
    print("Reading program uploaded into SIKE core")
    program_written = ultrascale.read_program_prom(0, len(program))
    print("Verifying program uploaded into SIKE core")
    if(program_written == program):
        return True
    print(program)
    print(program_written)
    return False

def load_constants(ultrascale, param):
    
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
    
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_prime_address, prime_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_prime_plus_one_address, prime_plus_one_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_prime_line_address, prime_line_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_2prime_address, prime2_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_const_r_address, r_mod_prime_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_const_r2_address, r2_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_const_1_address, constant_1_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_inv_4_mont_address, constant_inv_4_list, number_of_words)
    
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_sidh_xpa_mont_address,  test_value_xpa_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_sidh_xpai_mont_address, test_value_xpai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_sidh_xqa_mont_address,  test_value_xqa_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_sidh_xqai_mont_address, test_value_xqai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_sidh_xra_mont_address,  test_value_xra_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_sidh_xrai_mont_address, test_value_xrai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_sidh_xpb_mont_address,  test_value_xpb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_sidh_xpbi_mont_address, test_value_xpbi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_sidh_xqb_mont_address,  test_value_xqb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_sidh_xqbi_mont_address, test_value_xqbi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_sidh_xrb_mont_address,  test_value_xrb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_sidh_xrbi_mont_address, test_value_xrbi_mont_list, number_of_words)
    
    ultrascale.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_message_length_address, sike_message_length)
    ultrascale.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_shared_secret_length_address, sike_shared_secret_length)
    ultrascale.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_oa_mask_address, oa_mask)
    ultrascale.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_ob_mask_address, ob_mask)
    ultrascale.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_oa_bits_address, oa_bits)
    ultrascale.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_ob_bits_address, ob_bits)
    ultrascale.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_prime_size_bits_address, prime_size_bits)
    start_address = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_splits_alice_start_address
    for i in range(0, len(alice_splits)):
        ultrascale.write_package(start_address+i, alice_splits[i])
    for i in range(len(alice_splits), 302):
        ultrascale.write_package(start_address+i, 0)
    ultrascale.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_max_row_alice_address, alice_max_row)
    start_address = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_splits_bob_start_address
    for i in range(0, len(bob_splits)):
        ultrascale.write_package(start_address+i, bob_splits[i])
    for i in range(len(bob_splits), 302):
        ultrascale.write_package(start_address+i, 0)
    ultrascale.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_max_row_bob_address, bob_max_row)
    
    ultrascale.write_package(sike_core_reg_operands_size_address, number_of_words - 1)
    ultrascale.write_package(sike_core_reg_prime_line_equal_one_address, enable_special_prime_line_arithmetic)
    ultrascale.write_package(sike_core_reg_prime_address_address, 0)
    ultrascale.write_package(sike_core_reg_prime_plus_one_address_address, 1)
    ultrascale.write_package(sike_core_reg_prime_line_address_address, 2)
    ultrascale.write_package(sike_core_reg_2prime_address_address, 3)
    ultrascale.write_package(sike_core_reg_scalar_address_address, 0)
    ultrascale.write_package(sike_core_reg_initial_stack_address_address, starting_position_stack_sidh_core)

def test_single_sidh_keygen_alice(ultrascale, fp2, base_word_size, extended_word_size, number_of_words, alice_gen_points, bob_gen_points, sk_alice, oa_bits, alice_splits, alice_max_row, alice_max_int_points, debug_mode=False):

    sk_alice_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, sk_alice)
    
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 0, sk_alice_list, number_of_words)
    
    ultrascale.write_package(sike_core_reg_program_counter_address, program_start_address_test_sidh_keygen_alice)
    
    true_pk_alice = SIDH_round2_spec.ephemeral_key_generation_alice(fp2, alice_gen_points, bob_gen_points, sk_alice, alice_splits, alice_max_row, alice_max_int_points, oa_bits)
    
    true_value_o1  = true_pk_alice[0].polynomial()[0]
    true_value_o1i = true_pk_alice[0].polynomial()[1]
    true_value_o2  = true_pk_alice[1].polynomial()[0]
    true_value_o2i = true_pk_alice[1].polynomial()[1]
    true_value_o3  = true_pk_alice[2].polynomial()[0]
    true_value_o3i = true_pk_alice[2].polynomial()[1]
    
    #time.sleep(0.1)
    
    while(not ultrascale.isFree()):
        time.sleep(0.1)
    
    computed_test_value_o1_list  = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 0, number_of_words)
    computed_test_value_o1i_list = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 1, number_of_words)
    computed_test_value_o2_list  = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 2, number_of_words)
    computed_test_value_o2i_list = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 3, number_of_words)
    computed_test_value_o3_list  = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 4, number_of_words)
    computed_test_value_o3i_list = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 5, number_of_words)
    
    computed_test_value_o1  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o1_list)
    computed_test_value_o1i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o1i_list)
    computed_test_value_o2  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o2_list)
    computed_test_value_o2i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o2i_list)
    computed_test_value_o3  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o3_list)
    computed_test_value_o3i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o3i_list)
    
    if((debug_mode) or ((computed_test_value_o1 != true_value_o1) or (computed_test_value_o1i != true_value_o1i) or (computed_test_value_o2 != true_value_o2) or (computed_test_value_o2i != true_value_o2i) or (computed_test_value_o3 != true_value_o3) or (computed_test_value_o3i != true_value_o3i))):
        print("Error in SIDH Alice key generation ")
        print("SIDH secret key alice")
        print(sk_alice)
        print("Computed SIDH PK 0")
        print(computed_test_value_o1)
        print(computed_test_value_o1i)
        print("True SIDH PK 0")
        print(true_value_o1)
        print(true_value_o1i)
        print("Computed SIDH PK 1")
        print(computed_test_value_o2)
        print(computed_test_value_o2i)
        print("True SIDH PK 1")
        print(true_value_o2)
        print(true_value_o2i)
        print("Computed SIDH PK 2")
        print(computed_test_value_o3)
        print(computed_test_value_o3i)
        print("True SIDH PK 2")
        print(true_value_o3)
        print(true_value_o3i)
        return True
    return False

def test_sidh_keygen_alice(ultrascale, param, number_of_tests, debug_mode=False):
    
    load_constants(ultrascale, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
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
    
    alice_gen_points_mont = param[21:27]
    bob_gen_points_mont = param[27:33]
    alice_gen_points = param[42:48]
    bob_gen_points = param[48:54]
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [0, oa-1]
    for test in fixed_tests:
        sk_alice = test
        error_computation = test_single_sidh_keygen_alice(ultrascale, fp2, base_word_size, extended_word_size, number_of_words, alice_gen_points, bob_gen_points, sk_alice, oa_bits, alice_splits, alice_max_row, alice_max_int_points, debug_mode)
        tests_already_performed += 1
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            sk_alice = random.randint(0, oa-1)
            error_computation = test_single_sidh_keygen_alice(ultrascale, fp2, base_word_size, extended_word_size, number_of_words, alice_gen_points, bob_gen_points, sk_alice, oa_bits, alice_splits, alice_max_row, alice_max_int_points, debug_mode)
        
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_keygen_alice(ultrascale, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH key generation Alice " +  param[0])
        error_computation = test_sidh_keygen_alice(ultrascale, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_single_sidh_keygen_bob(ultrascale, fp2, base_word_size, extended_word_size, number_of_words, alice_gen_points, bob_gen_points, sk_bob, ob_bits, bob_splits, bob_max_row, bob_max_int_points, debug_mode=False):

    sk_bob_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, sk_bob)
    
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 0, sk_bob_list, number_of_words)
    
    ultrascale.write_package(sike_core_reg_program_counter_address, program_start_address_test_sidh_keygen_bob)
    
    true_pk_bob = SIDH_round2_spec.ephemeral_key_generation_bob(fp2, alice_gen_points, bob_gen_points, sk_bob, bob_splits, bob_max_row, bob_max_int_points, ob_bits)
    
    true_value_o1  = true_pk_bob[0].polynomial()[0]
    true_value_o1i = true_pk_bob[0].polynomial()[1]
    true_value_o2  = true_pk_bob[1].polynomial()[0]
    true_value_o2i = true_pk_bob[1].polynomial()[1]
    true_value_o3  = true_pk_bob[2].polynomial()[0]
    true_value_o3i = true_pk_bob[2].polynomial()[1]
    
    #time.sleep(0.1)
    
    while(not ultrascale.isFree()):
        time.sleep(0.1)
    
    computed_test_value_o1_list  = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 0, number_of_words)
    computed_test_value_o1i_list = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 1, number_of_words)
    computed_test_value_o2_list  = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 2, number_of_words)
    computed_test_value_o2i_list = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 3, number_of_words)
    computed_test_value_o3_list  = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 4, number_of_words)
    computed_test_value_o3i_list = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 5, number_of_words)
    
    computed_test_value_o1  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o1_list)
    computed_test_value_o1i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o1i_list)
    computed_test_value_o2  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o2_list)
    computed_test_value_o2i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o2i_list)
    computed_test_value_o3  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o3_list)
    computed_test_value_o3i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o3i_list)
    
    if((debug_mode) or ((computed_test_value_o1 != true_value_o1) or (computed_test_value_o1i != true_value_o1i) or (computed_test_value_o2 != true_value_o2) or (computed_test_value_o2i != true_value_o2i) or (computed_test_value_o3 != true_value_o3) or (computed_test_value_o3i != true_value_o3i))):
        print("Error in SIDH Bob key generation ")
        print("SIDH secret key bob")
        print(sk_bob)
        print("Computed SIDH PK 0")
        print(computed_test_value_o1)
        print(computed_test_value_o1i)
        print("True SIDH PK 0")
        print(true_value_o1)
        print(true_value_o1i)
        print("Computed SIDH PK 1")
        print(computed_test_value_o2)
        print(computed_test_value_o2i)
        print("True SIDH PK 1")
        print(true_value_o2)
        print(true_value_o2i)
        print("Computed SIDH PK 2")
        print(computed_test_value_o3)
        print(computed_test_value_o3i)
        print("True SIDH PK 2")
        print(true_value_o3)
        print(true_value_o3i)
        return True
    return False

def test_sidh_keygen_bob(ultrascale, param, number_of_tests, debug_mode=False):
    
    load_constants(ultrascale, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
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
    
    alice_gen_points_mont = param[21:27]
    bob_gen_points_mont = param[27:33]
    alice_gen_points = param[42:48]
    bob_gen_points = param[48:54]
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [0, ob-1]
    for test in fixed_tests:
        sk_bob = test
        error_computation = test_single_sidh_keygen_bob(ultrascale, fp2, base_word_size, extended_word_size, number_of_words, alice_gen_points, bob_gen_points, sk_bob, ob_bits, bob_splits, bob_max_row, bob_max_int_points, debug_mode)
        tests_already_performed += 1
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            sk_bob = random.randint(0, ob-1)
            error_computation = test_single_sidh_keygen_bob(ultrascale, fp2, base_word_size, extended_word_size, number_of_words, alice_gen_points, bob_gen_points, sk_bob, ob_bits, bob_splits, bob_max_row, bob_max_int_points, debug_mode)
        
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_keygen_bob(ultrascale, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH key generation Bob " +  param[0])
        error_computation = test_sidh_keygen_bob(ultrascale, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_single_sidh_shared_secret_alice(ultrascale, fp2, base_word_size, extended_word_size, number_of_words, alice_gen_points, bob_gen_points, sk_alice, sk_bob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, debug_mode=False):

    pk_bob = SIDH_round2_spec.ephemeral_key_generation_bob(fp2, alice_gen_points, bob_gen_points, sk_bob, bob_splits, bob_max_row, bob_max_int_points, ob_bits)
    
    pk_bob_phipx_list   = sike_core_utils.integer_to_list(extended_word_size, number_of_words, pk_bob[0].polynomial()[0])
    pk_bob_phipxi_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, pk_bob[0].polynomial()[1])
    pk_bob_phiqx_list   = sike_core_utils.integer_to_list(extended_word_size, number_of_words, pk_bob[1].polynomial()[0])
    pk_bob_phiqxi_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, pk_bob[1].polynomial()[1])
    pk_bob_phirx_list   = sike_core_utils.integer_to_list(extended_word_size, number_of_words, pk_bob[2].polynomial()[0])
    pk_bob_phirxi_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, pk_bob[2].polynomial()[1])

    sk_alice_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, sk_alice)
    
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 0, pk_bob_phipx_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 1, pk_bob_phipxi_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 2, pk_bob_phiqx_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 3, pk_bob_phiqxi_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 4, pk_bob_phirx_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 5, pk_bob_phirxi_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 6, sk_alice_list, number_of_words)
    
    ultrascale.write_package(sike_core_reg_program_counter_address, program_start_address_test_sidh_shared_secret_alice)
    
    true_j_invariant = SIDH_round2_spec.ephemeral_shared_secret_alice(fp2, pk_bob, sk_alice, alice_splits, alice_max_row, alice_max_int_points, oa_bits)
    
    true_value_o1  = true_j_invariant.polynomial()[0]
    true_value_o1i = true_j_invariant.polynomial()[1]
    
    #time.sleep(0.1)
    
    while(not ultrascale.isFree()):
        time.sleep(0.1)
    
    computed_test_value_o1_list  = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 0, number_of_words)
    computed_test_value_o1i_list = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 1, number_of_words)
    
    computed_test_value_o1  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o1_list)
    computed_test_value_o1i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o1i_list)
    
    if((debug_mode) or ((computed_test_value_o1 != true_value_o1) or (computed_test_value_o1i != true_value_o1i))):
        print("Error in SIDH Alice shared secret ")
        print("SIDH secret key bob")
        print(sk_bob)
        print("SIDH secret key alice")
        print(sk_alice)
        print("Computed SIDH j invariant")
        print(computed_test_value_o1)
        print(computed_test_value_o1i)
        print("True SIDH j invariant")
        print(true_value_o1)
        print(true_value_o1i)
        return True
    return False

def test_sidh_shared_secret_alice(ultrascale, param, number_of_tests, debug_mode=False):

    load_constants(ultrascale, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
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
    
    alice_gen_points_mont = param[21:27]
    bob_gen_points_mont = param[27:33]
    alice_gen_points = param[42:48]
    bob_gen_points = param[48:54]
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [[0, 0], [0, ob-1], [0, oa-1], [oa-1, ob-1]]
    for test in fixed_tests:
        sk_bob = test[0]
        sk_alice = test[1]
        error_computation = test_single_sidh_shared_secret_alice(ultrascale, fp2, base_word_size, extended_word_size, number_of_words, alice_gen_points, bob_gen_points, sk_alice, sk_bob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, debug_mode)
        tests_already_performed += 1
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            sk_bob = random.randint(0, ob-1)
            sk_alice = random.randint(0, oa-1)
            error_computation = test_single_sidh_shared_secret_alice(ultrascale, fp2, base_word_size, extended_word_size, number_of_words, alice_gen_points, bob_gen_points, sk_alice, sk_bob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, debug_mode)
        
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_shared_secret_alice(ultrascale, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH shared secret Alice " +  param[0])
        error_computation = test_sidh_shared_secret_alice(ultrascale, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_single_sidh_shared_secret_bob(ultrascale, fp2, base_word_size, extended_word_size, number_of_words, alice_gen_points, bob_gen_points, sk_alice, sk_bob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, debug_mode=False):

    pk_alice = SIDH_round2_spec.ephemeral_key_generation_alice(fp2, alice_gen_points, bob_gen_points, sk_alice, alice_splits, alice_max_row, alice_max_int_points, oa_bits)
    
    pk_alice_phipx_list   = sike_core_utils.integer_to_list(extended_word_size, number_of_words, pk_alice[0].polynomial()[0])
    pk_alice_phipxi_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, pk_alice[0].polynomial()[1])
    pk_alice_phiqx_list   = sike_core_utils.integer_to_list(extended_word_size, number_of_words, pk_alice[1].polynomial()[0])
    pk_alice_phiqxi_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, pk_alice[1].polynomial()[1])
    pk_alice_phirx_list   = sike_core_utils.integer_to_list(extended_word_size, number_of_words, pk_alice[2].polynomial()[0])
    pk_alice_phirxi_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, pk_alice[2].polynomial()[1])

    sk_bob_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, sk_bob)
    
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 0, pk_alice_phipx_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 1, pk_alice_phipxi_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 2, pk_alice_phiqx_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 3, pk_alice_phiqxi_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 4, pk_alice_phirx_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 5, pk_alice_phirxi_list, number_of_words)
    ultrascale.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 6, sk_bob_list, number_of_words)
    
    ultrascale.write_package(sike_core_reg_program_counter_address, program_start_address_test_sidh_shared_secret_bob)
    
    true_j_invariant = SIDH_round2_spec.ephemeral_shared_secret_bob(fp2, pk_alice, sk_bob, bob_splits, bob_max_row, bob_max_int_points, ob_bits)
    
    true_value_o1  = true_j_invariant.polynomial()[0]
    true_value_o1i = true_j_invariant.polynomial()[1]
    
    #time.sleep(0.1)
    
    while(not ultrascale.isFree()):
        time.sleep(0.1)
    
    computed_test_value_o1_list  = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 0, number_of_words)
    computed_test_value_o1i_list = ultrascale.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 1, number_of_words)
    
    computed_test_value_o1  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o1_list)
    computed_test_value_o1i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o1i_list)
    
    if((debug_mode) or ((computed_test_value_o1 != true_value_o1) or (computed_test_value_o1i != true_value_o1i))):
        print("Error in SIDH Bob shared secret ")
        print("SIDH secret key alice")
        print(sk_alice)
        print("SIDH secret key bob")
        print(sk_bob)
        print("Computed SIDH j invariant")
        print(computed_test_value_o1)
        print(computed_test_value_o1i)
        print("True SIDH j invariant")
        print(true_value_o1)
        print(true_value_o1i)
        return True
    return False

def test_sidh_shared_secret_bob(ultrascale, param, number_of_tests, debug_mode=False):

    load_constants(ultrascale, param)
    
    number_of_words = param[4]
    base_word_size = param[1]
    extended_word_size = param[2]
    prime = param[5]
    
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
    
    alice_gen_points_mont = param[21:27]
    bob_gen_points_mont = param[27:33]
    alice_gen_points = param[42:48]
    bob_gen_points = param[48:54]
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [[0, 0], [0, ob-1], [0, oa-1], [oa-1, ob-1]]
    for test in fixed_tests:
        sk_bob = test[0]
        sk_alice = test[1]
        error_computation = test_single_sidh_shared_secret_bob(ultrascale, fp2, base_word_size, extended_word_size, number_of_words, alice_gen_points, bob_gen_points, sk_alice, sk_bob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, debug_mode)
        tests_already_performed += 1
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            sk_bob = random.randint(0, ob-1)
            sk_alice = random.randint(0, oa-1)
            error_computation = test_single_sidh_shared_secret_bob(ultrascale, fp2, base_word_size, extended_word_size, number_of_words, alice_gen_points, bob_gen_points, sk_alice, sk_bob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, debug_mode)
        
            if(error_computation):
                break
    
    return error_computation

def test_all_sidh_shared_secret_bob(ultrascale, sike_fpga_constants, number_of_tests, only_one_parameter=None):
    error_computation = False
    if(only_one_parameter != None):
        all_testing_parameters = sike_fpga_constants[only_one_parameter:only_one_parameter+1]
    else:
        all_testing_parameters = sike_fpga_constants
    for param in all_testing_parameters:
        print("Testing SIDH shared secret Bob " +  param[0])
        error_computation = test_sidh_shared_secret_bob(ultrascale, param, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_all_sidh_functions(ultrascale, version, only_one_parameter=None):
    sike_base_word_size = 16
    if(version == '256'):
        sike_extended_word_size = 256
        sike_fpga_constants = sike_fpga_constants_v256.sike_fpga_constants_v256
    elif(version == '128'):
        sike_extended_word_size = 128
        sike_fpga_constants = sike_fpga_constants_v128.sike_fpga_constants_v128
    tests_working_folder = "../hw_sidh_tests_v"+str(sike_extended_word_size)+"/"
    if(load_program(ultrascale, tests_prom_folder + "test_sike_sidh_ecc_functions_v" + str(sike_extended_word_size)+ ".dat", sike_base_word_size, 4)):
        print("Program loaded correctly into SIKE core")
        test_all_sidh_keygen_alice(ultrascale, sike_fpga_constants, 100, only_one_parameter)
        test_all_sidh_keygen_bob(ultrascale, sike_fpga_constants, 100, only_one_parameter)
        test_all_sidh_shared_secret_alice(ultrascale, sike_fpga_constants, 100, only_one_parameter)
        test_all_sidh_shared_secret_bob(ultrascale, sike_fpga_constants, 100, only_one_parameter)
    else:
        print('Program loading failed')

ultrascale = Ultrascale('COM9', sys.argv[1])
#ultrascale.read_initial_message(34)
while(not ultrascale.isFree()):
    time.sleep(0.01)
ultrascale.flush()

test_all_sidh_functions(ultrascale, sys.argv[1])

ultrascale.disconnect()