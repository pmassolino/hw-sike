import time
import random
import sys

from zedboard_sidh import *
import sike_core_utils
import SIKE_round2_constants
import SIKE_round2_spec
import sidh_fp2


tests_prom_folder = "../assembler/"

starting_position_stack_sidh_core = 224
program_start_address_test_sike_kem_keygen = 1
program_start_address_test_sike_kem_enc = 3
program_start_address_test_sike_kem_dec = 5

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
sike_core_reg_initial_stack_address_address =               0x0E007;
sike_core_reg_flag_address =                                0x0E008;
sike_core_reg_scalar_address_address =                      0x0E009;

sike_core_mac_ram_prime_address =                           0x00000;
sike_core_mac_ram_prime_plus_one_address =                  0x00001;
sike_core_mac_ram_prime_line_address =                      0x00002;
sike_core_mac_ram_const_r_address =                         0x00003;
sike_core_mac_ram_const_r2_address =                        0x00004;
sike_core_mac_ram_const_1_address =                         0x00005;
sike_core_mac_ram_inv_4_mont_address =                      0x00006;
sike_core_mac_ram_sidh_xpa_mont_address =                   0x00007;
sike_core_mac_ram_sidh_xpai_mont_address =                  0x00008;
sike_core_mac_ram_sidh_xqa_mont_address =                   0x00009;
sike_core_mac_ram_sidh_xqai_mont_address =                  0x0000A;
sike_core_mac_ram_sidh_xra_mont_address =                   0x0000B;
sike_core_mac_ram_sidh_xrai_mont_address =                  0x0000C;
sike_core_mac_ram_sidh_xpb_mont_address =                   0x0000D;
sike_core_mac_ram_sidh_xpbi_mont_address =                  0x0000E;
sike_core_mac_ram_sidh_xqb_mont_address =                   0x0000F;
sike_core_mac_ram_sidh_xqbi_mont_address =                  0x00010;
sike_core_mac_ram_sidh_xrb_mont_address =                   0x00011;
sike_core_mac_ram_sidh_xrbi_mont_address =                  0x00012;

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

def test_single_sike_keygen(zedboard, fp2, arithmetic_parameters, alice_gen_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, ob, ob_bits, sike_message_length, sike_sk, sike_s, debug_mode=False):

    extended_word_size = arithmetic_parameters[0]
    base_word_size = arithmetic_parameters[1]
    number_of_words = arithmetic_parameters[9]

    test_value_sike_sk_list  = sike_core_utils.integer_to_list(base_word_size, 32, sike_sk)
    start_address_sike_sk = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_sk_start_address
    for j in range(32):
        zedboard.write_package(start_address_sike_sk+j, test_value_sike_sk_list[j])
    
    start_address_sike_s = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_s_start_address
    for j in range(0, len(sike_s), 2):
        zedboard.write_package(start_address_sike_s+(j//2), sike_s[j+1]*256 + sike_s[j])
    for j in range(len(sike_s), 32, 2):
        zedboard.write_package(start_address_sike_s+(j//2), 0)
    
    zedboard.write_package(sike_core_reg_program_counter_address, program_start_address_test_sike_kem_keygen)
    
    true_sike_s, true_sike_sk, true_sike_pk = SIKE_round2_spec.SIKE_KEM_gen_key(fp2, alice_gen_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, ob, ob_bits, sike_message_length, sike_sk, sike_s)
    
    true_value_o3  = true_sike_pk[0].polynomial()[0]
    true_value_o3i = true_sike_pk[0].polynomial()[1]
    true_value_o4  = true_sike_pk[1].polynomial()[0]
    true_value_o4i = true_sike_pk[1].polynomial()[1]
    true_value_o5  = true_sike_pk[2].polynomial()[0]
    true_value_o5i = true_sike_pk[2].polynomial()[1]
    
    time.sleep(0.1)
    
    while(not zedboard.isFree()):
        time.sleep(0.1)
    
    computed_test_value_o3_list  = zedboard.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 0, number_of_words)
    computed_test_value_o3i_list = zedboard.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 1, number_of_words)
    computed_test_value_o4_list  = zedboard.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 2, number_of_words)
    computed_test_value_o4i_list = zedboard.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 3, number_of_words)
    computed_test_value_o5_list  = zedboard.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 4, number_of_words)
    computed_test_value_o5i_list = zedboard.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 5, number_of_words)
    
    computed_test_value_o3  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o3_list)
    computed_test_value_o3i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o3i_list)
    computed_test_value_o4  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o4_list)
    computed_test_value_o4i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o4i_list)
    computed_test_value_o5  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o5_list)
    computed_test_value_o5i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o5i_list)
    
    computed_test_value_o1_list = [0 for i in range(32)]
    start_address_sike_sk = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_sk_start_address
    for j in range(32):
        computed_test_value_o1_list[j] = zedboard.read_package(start_address_sike_sk+j)
    
    computed_test_value_o2_list = bytearray(sike_message_length)
    start_address_sike_s = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_s_start_address
    for j in range(0, len(computed_test_value_o2_list), 2):
        temp_value = zedboard.read_package(start_address_sike_s+(j//2))
        computed_test_value_o2_list[j]   = temp_value & 255;
        computed_test_value_o2_list[j+1] = (temp_value >> 8) & 255;
    
    if((debug_mode) or ((computed_test_value_o1_list != test_value_sike_sk_list) or (computed_test_value_o2_list != sike_s) or (computed_test_value_o3 != true_value_o3) or (computed_test_value_o3i != true_value_o3i) or (computed_test_value_o4 != true_value_o4) or (computed_test_value_o4i != true_value_o4i) or (computed_test_value_o5 != true_value_o5) or (computed_test_value_o5i != true_value_o5i))):
        print("Error in SIKE key generation ")
        print("SIKE sk")
        print(sike_sk)
        print("SIKE s")
        print(binascii.hexlify(sike_s))
        print("Computed SIKE sk")
        print(computed_test_value_o1_list)
        print(test_value_sike_sk_list)
        print("Computed SIKE s")
        print(binascii.hexlify(computed_test_value_o2_list))
        print(binascii.hexlify(sike_s))
        print("Computed SIKE PK 0")
        print(computed_test_value_o3)
        print(computed_test_value_o3i)
        print("True SIKE PK 0")
        print(true_value_o3)
        print(true_value_o3i)
        print("Computed SIKE PK 1")
        print(computed_test_value_o4)
        print(computed_test_value_o4i)
        print("True SIKE PK 1")
        print(true_value_o4)
        print(true_value_o4i)
        print("Computed SIKE PK 2")
        print(computed_test_value_o5)
        print(computed_test_value_o5i)
        print("True SIKE PK 2")
        print(true_value_o5)
        print(true_value_o5i)
        return True
    return False

def test_sike_keygen(zedboard, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, alice_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, oa, ob, sike_message_length, sike_shared_secret_length, number_of_tests, debug_mode=False):

    arithmetic_parameters = sike_core_utils.generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    
    prime_list = arithmetic_parameters[4]
    prime_plus_one_list = arithmetic_parameters[6]
    prime_line_list = arithmetic_parameters[18]
    r_mod_prime_list = arithmetic_parameters[13]
    r2_list = arithmetic_parameters[15]
    constant_1_list = arithmetic_parameters[20]
    number_of_words = arithmetic_parameters[9]
    
    error_computation = False
        
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    oa_bits = int(oa-1).bit_length()
    ob_bits = int(ob-1).bit_length()
    t_bits_mask = oa_bits - (((oa_bits + (base_word_size - 1))//base_word_size)-1)*base_word_size
    oa_mask = 2**t_bits_mask-1
    t_bits_mask = ob_bits - (((ob_bits + (base_word_size - 1))//base_word_size)-1)*base_word_size
    ob_mask = 2**t_bits_mask-1
    
    inv_4 = (fp2(4)**(-1)).polynomial()[0]
    inv_4_mont = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    constant_inv_4_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, inv_4_mont)
    
    test_value_xpa_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[0])
    test_value_xpai_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[1])
    test_value_xqa_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[2])
    test_value_xqai_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[3])
    test_value_xra_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[4])
    test_value_xrai_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[5])
    test_value_xpb_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[0])
    test_value_xpbi_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[1])
    test_value_xqb_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[2])
    test_value_xqbi_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[3])
    test_value_xrb_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[4])
    test_value_xrbi_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[5])
    
    test_value_xpa_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xpa_mont)
    test_value_xpai_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xpai_mont)
    test_value_xqa_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xqa_mont)
    test_value_xqai_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xqai_mont)
    test_value_xra_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xra_mont)
    test_value_xrai_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xrai_mont)
    test_value_xpb_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xpb_mont)
    test_value_xpbi_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xpbi_mont)
    test_value_xqb_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xqb_mont)
    test_value_xqbi_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xqbi_mont)
    test_value_xrb_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xrb_mont)
    test_value_xrbi_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xrbi_mont)
    
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_address, prime_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_plus_one_address, prime_plus_one_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_line_address, prime_line_list, number_of_words)
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
    zedboard.write_package(sike_core_reg_prime_line_equal_one_address, 0)
    zedboard.write_package(sike_core_reg_prime_address_address, 0)
    zedboard.write_package(sike_core_reg_prime_plus_one_address_address, 1)
    zedboard.write_package(sike_core_reg_prime_line_address_address, 2)
    zedboard.write_package(sike_core_reg_initial_stack_address_address, starting_position_stack_sidh_core)
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [[[0 for j in range(sike_message_length)], 0], [[0 for j in range(sike_message_length)], ob-1]]
    for test in fixed_tests:
        sike_s  = bytearray(test[0])
        sike_sk = test[1]
        error_computation = test_single_sike_keygen(zedboard, fp2, arithmetic_parameters, alice_gen_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, ob, ob_bits, sike_message_length, sike_sk, sike_s, debug_mode)
        tests_already_performed += 1
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            sike_s  = bytearray([random.randint(0, 255) for j in range(sike_message_length)])
            sike_sk = random.randint(0, ob-1)
            error_computation = test_single_sike_keygen(zedboard, fp2, arithmetic_parameters, alice_gen_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, ob, ob_bits, sike_message_length, sike_sk, sike_s, debug_mode)
        
            if(error_computation):
                break
    
    return error_computation

def test_all_sike_keygen(zedboard, base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests):
    error_computation = False
    for param in SIKE_round2_constants.sidh_constants:
        print("Testing SIKE key generation " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        oa = (param[2])**(param[4])
        ob = (param[3])**(param[5])
        alice_gen_points = param[6:12]
        alice_splits = param[18]
        alice_max_row = param[19]
        alice_max_int_points = param[20]
        bob_gen_points = param[12:18]
        bob_splits = param[21]
        bob_max_row = param[22]
        bob_max_int_points = param[23]
        sike_message_length = param[24]
        sike_shared_secret_length = param[25]
        error_computation = test_sike_keygen(zedboard, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, alice_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, oa, ob, sike_message_length, sike_shared_secret_length, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_single_sike_encryption(zedboard, fp2, arithmetic_parameters, alice_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, oa, ob, oa_bits, ob_bits, sike_message_length, sike_shared_secret_length, sike_sk, sike_s, sike_m, debug_mode=False):

    extended_word_size = arithmetic_parameters[0]
    base_word_size = arithmetic_parameters[1]
    number_of_words = arithmetic_parameters[9]
    
    true_sike_s, true_sike_sk, true_sike_pk = SIKE_round2_spec.SIKE_KEM_gen_key(fp2, alice_gen_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, ob, ob_bits, sike_message_length, sike_sk, sike_s)
    
    true_sike_pk_phiPx  = true_sike_pk[0].polynomial()[0]
    true_sike_pk_phiPxi = true_sike_pk[0].polynomial()[1]
    true_sike_pk_phiQx  = true_sike_pk[1].polynomial()[0]
    true_sike_pk_phiQxi = true_sike_pk[1].polynomial()[1]
    true_sike_pk_phiRx  = true_sike_pk[2].polynomial()[0]
    true_sike_pk_phiRxi = true_sike_pk[2].polynomial()[1]
    
    true_sike_pk_phiPx_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_pk_phiPx)
    true_sike_pk_phiPxi_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_pk_phiPxi)
    true_sike_pk_phiQx_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_pk_phiQx)
    true_sike_pk_phiQxi_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_pk_phiQxi)
    true_sike_pk_phiRx_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_pk_phiRx)
    true_sike_pk_phiRxi_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_pk_phiRxi)
    
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 0, true_sike_pk_phiPx_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 1, true_sike_pk_phiPxi_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 2, true_sike_pk_phiQx_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 3, true_sike_pk_phiQxi_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 4, true_sike_pk_phiRx_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 5, true_sike_pk_phiRxi_list, number_of_words)
    
    start_address_sike_m = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_m_start_address
    for j in range(0, len(sike_m), 2):
        zedboard.write_package(start_address_sike_m+(j//2), sike_m[j+1]*256 + sike_m[j])
    for j in range(len(sike_m), 32, 2):
        zedboard.write_package(start_address_sike_m+(j//2), 0)
    
    zedboard.write_package(sike_core_reg_program_counter_address, program_start_address_test_sike_kem_enc)
    
    true_sike_ss, true_sike_c0, true_sike_c1 = SIKE_round2_spec.SIKE_KEM_enc(fp2, alice_gen_points, bob_gen_points, alice_splits, alice_max_row, alice_max_int_points, oa, oa_bits, true_sike_pk, sike_message_length, sike_shared_secret_length, sike_m)
    
    true_value_o3  = true_sike_c0[0].polynomial()[0]
    true_value_o3i = true_sike_c0[0].polynomial()[1]
    true_value_o4  = true_sike_c0[1].polynomial()[0]
    true_value_o4i = true_sike_c0[1].polynomial()[1]
    true_value_o5  = true_sike_c0[2].polynomial()[0]
    true_value_o5i = true_sike_c0[2].polynomial()[1]
    
    while(not zedboard.isFree()):
        time.sleep(0.1)
    
    computed_test_value_o3_list  = zedboard.read_mac_ram_operand(sike_core_mac_ram_output_function_start_address + 0, number_of_words)
    computed_test_value_o3i_list = zedboard.read_mac_ram_operand(sike_core_mac_ram_output_function_start_address + 1, number_of_words)
    computed_test_value_o4_list  = zedboard.read_mac_ram_operand(sike_core_mac_ram_output_function_start_address + 2, number_of_words)
    computed_test_value_o4i_list = zedboard.read_mac_ram_operand(sike_core_mac_ram_output_function_start_address + 3, number_of_words)
    computed_test_value_o5_list  = zedboard.read_mac_ram_operand(sike_core_mac_ram_output_function_start_address + 4, number_of_words)
    computed_test_value_o5i_list = zedboard.read_mac_ram_operand(sike_core_mac_ram_output_function_start_address + 5, number_of_words)
    
    computed_test_value_o3  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o3_list)
    computed_test_value_o3i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o3i_list)
    computed_test_value_o4  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o4_list)
    computed_test_value_o4i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o4i_list)
    computed_test_value_o5  = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o5_list)
    computed_test_value_o5i = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_value_o5i_list)
    
    computed_test_value_o1_list = bytearray(sike_shared_secret_length)
    start_address_sike_ss = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_ss_start_address
    for j in range(0, len(computed_test_value_o1_list), 2):
        temp_value = zedboard.read_package(start_address_sike_ss+(j//2))
        computed_test_value_o1_list[j]   = temp_value & 255;
        computed_test_value_o1_list[j+1] = (temp_value >> 8) & 255;
    
    computed_test_value_o2_list = bytearray(sike_message_length)
    start_address_sike_c1 = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_c1_start_address
    for j in range(0, len(computed_test_value_o2_list), 2):
        temp_value = zedboard.read_package(start_address_sike_c1+(j//2))
        computed_test_value_o2_list[j]   = temp_value & 255;
        computed_test_value_o2_list[j+1] = (temp_value >> 8) & 255;
    
    if((debug_mode) or ((computed_test_value_o1_list != true_sike_ss) or (computed_test_value_o2_list != true_sike_c1) or (computed_test_value_o3 != true_value_o3) or (computed_test_value_o3i != true_value_o3i) or (computed_test_value_o4 != true_value_o4) or (computed_test_value_o4i != true_value_o4i) or (computed_test_value_o5 != true_value_o5) or (computed_test_value_o5i != true_value_o5i))):
        print("Error in SIKE encryption ")
        print("SIKE sk")
        print(sike_sk)
        print("SIKE s")
        print(binascii.hexlify(sike_s))
        print("SIKE m")
        print(binascii.hexlify(sike_m))
        print("Computed SIKE ss")
        print(binascii.hexlify(computed_test_value_o1_list))
        print("True SIKE ss")
        print(binascii.hexlify(true_sike_ss))
        print("Computed SIKE c1")
        print(binascii.hexlify(computed_test_value_o2_list))
        print("True SIKE c1")
        print(binascii.hexlify(true_sike_c1))
        print("Computed SIKE C0 0")
        print(hex(computed_test_value_o3))
        print(hex(computed_test_value_o3i))
        print("True SIKE C0 0")
        print(hex(true_value_o3))
        print(hex(true_value_o3i))
        print("Computed SIKE C0 1")
        print(hex(computed_test_value_o4))
        print(hex(computed_test_value_o4i))
        print("True SIKE C0 1")
        print(hex(true_value_o4))
        print(hex(true_value_o4i))
        print("Computed SIKE C0 2")
        print(hex(computed_test_value_o5))
        print(hex(computed_test_value_o5i))
        print("True SIKE C0 2")
        print(hex(true_value_o5))
        print(hex(true_value_o5i))
        return True
    return False

def test_sike_encryption(zedboard, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, alice_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, oa, ob, sike_message_length, sike_shared_secret_length, number_of_tests, debug_mode=False):

    arithmetic_parameters = sike_core_utils.generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    
    prime_list = arithmetic_parameters[4]
    prime_plus_one_list = arithmetic_parameters[6]
    prime_line_list = arithmetic_parameters[18]
    r_mod_prime_list = arithmetic_parameters[13]
    r2_list = arithmetic_parameters[15]
    constant_1_list = arithmetic_parameters[20]
    number_of_words = arithmetic_parameters[9]
    
    error_computation = False
        
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    oa_bits = int(oa-1).bit_length()
    ob_bits = int(ob-1).bit_length()
    t_bits_mask = oa_bits - (((oa_bits + (base_word_size - 1))//base_word_size)-1)*base_word_size
    oa_mask = 2**t_bits_mask-1
    t_bits_mask = ob_bits - (((ob_bits + (base_word_size - 1))//base_word_size)-1)*base_word_size
    ob_mask = 2**t_bits_mask-1
    
    inv_4 = (fp2(4)**(-1)).polynomial()[0]
    inv_4_mont = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    constant_inv_4_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, inv_4_mont)
    
    test_value_xpa_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[0])
    test_value_xpai_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[1])
    test_value_xqa_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[2])
    test_value_xqai_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[3])
    test_value_xra_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[4])
    test_value_xrai_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[5])
    test_value_xpb_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[0])
    test_value_xpbi_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[1])
    test_value_xqb_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[2])
    test_value_xqbi_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[3])
    test_value_xrb_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[4])
    test_value_xrbi_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[5])
    
    test_value_xpa_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xpa_mont)
    test_value_xpai_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xpai_mont)
    test_value_xqa_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xqa_mont)
    test_value_xqai_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xqai_mont)
    test_value_xra_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xra_mont)
    test_value_xrai_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xrai_mont)
    test_value_xpb_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xpb_mont)
    test_value_xpbi_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xpbi_mont)
    test_value_xqb_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xqb_mont)
    test_value_xqbi_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xqbi_mont)
    test_value_xrb_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xrb_mont)
    test_value_xrbi_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xrbi_mont)
    
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_address, prime_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_plus_one_address, prime_plus_one_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_line_address, prime_line_list, number_of_words)
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
    zedboard.write_package(sike_core_reg_prime_line_equal_one_address, 0)
    zedboard.write_package(sike_core_reg_prime_address_address, 0)
    zedboard.write_package(sike_core_reg_prime_plus_one_address_address, 1)
    zedboard.write_package(sike_core_reg_prime_line_address_address, 2)
    zedboard.write_package(sike_core_reg_initial_stack_address_address, starting_position_stack_sidh_core)
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [[[0 for j in range(sike_message_length)], 0, [0 for j in range(sike_message_length)]], [[0 for j in range(sike_message_length)], ob-1, [0 for j in range(sike_message_length)]], [[0 for j in range(sike_message_length)], 0, [100 for j in range(sike_message_length)]], [[0 for j in range(sike_message_length)], ob-1, [100 for j in range(sike_message_length)]]]
    for test in fixed_tests:
        sike_s  = bytearray(test[0])
        sike_sk = test[1]
        sike_m  = bytearray(test[2])
        error_computation = test_single_sike_encryption(zedboard, fp2, arithmetic_parameters, alice_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, oa, ob, oa_bits, ob_bits, sike_message_length, sike_shared_secret_length, sike_sk, sike_s, sike_m, debug_mode=False)
        tests_already_performed += 1
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            sike_s  = bytearray([random.randint(0, 255) for j in range(sike_message_length)])
            sike_sk = random.randint(0, ob-1)
            sike_m  = bytearray([random.randint(0, 255) for j in range(sike_message_length)])
            error_computation = test_single_sike_encryption(zedboard, fp2, arithmetic_parameters, alice_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, oa, ob, oa_bits, ob_bits, sike_message_length, sike_shared_secret_length, sike_sk, sike_s, sike_m, debug_mode=False)
        
            if(error_computation):
                break
    
    return error_computation

def test_all_sike_encryption(zedboard, base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests):
    error_computation = False
    for param in SIKE_round2_constants.sidh_constants:
        print("Testing SIKE encryption " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        oa = (param[2])**(param[4])
        ob = (param[3])**(param[5])
        alice_gen_points = param[6:12]
        alice_splits = param[18]
        alice_max_row = param[19]
        alice_max_int_points = param[20]
        bob_gen_points = param[12:18]
        bob_splits = param[21]
        bob_max_row = param[22]
        bob_max_int_points = param[23]
        sike_message_length = param[24]
        sike_shared_secret_length = param[25]
        error_computation = test_sike_encryption(zedboard, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, alice_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, oa, ob, sike_message_length, sike_shared_secret_length, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_single_sike_decryption(zedboard, fp2, arithmetic_parameters, alice_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, oa, ob, oa_bits, ob_bits, sike_message_length, sike_shared_secret_length, sike_sk, sike_s, sike_m, debug_mode=False):

    extended_word_size = arithmetic_parameters[0]
    base_word_size = arithmetic_parameters[1]
    number_of_words = arithmetic_parameters[9]
    
    true_sike_s, true_sike_sk, true_sike_pk = SIKE_round2_spec.SIKE_KEM_gen_key(fp2, alice_gen_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, ob, ob_bits, sike_message_length, sike_sk, sike_s)
    
    true_sike_ss, true_sike_c0, true_sike_c1 = SIKE_round2_spec.SIKE_KEM_enc(fp2, alice_gen_points, bob_gen_points, alice_splits, alice_max_row, alice_max_int_points, oa, oa_bits, true_sike_pk, sike_message_length, sike_shared_secret_length, sike_m)
    
    true_sike_pk_phiPx  = true_sike_pk[0].polynomial()[0]
    true_sike_pk_phiPxi = true_sike_pk[0].polynomial()[1]
    true_sike_pk_phiQx  = true_sike_pk[1].polynomial()[0]
    true_sike_pk_phiQxi = true_sike_pk[1].polynomial()[1]
    true_sike_pk_phiRx  = true_sike_pk[2].polynomial()[0]
    true_sike_pk_phiRxi = true_sike_pk[2].polynomial()[1]
    
    true_sike_c0_phiPx  = true_sike_c0[0].polynomial()[0]
    true_sike_c0_phiPxi = true_sike_c0[0].polynomial()[1]
    true_sike_c0_phiQx  = true_sike_c0[1].polynomial()[0]
    true_sike_c0_phiQxi = true_sike_c0[1].polynomial()[1]
    true_sike_c0_phiRx  = true_sike_c0[2].polynomial()[0]
    true_sike_c0_phiRxi = true_sike_c0[2].polynomial()[1]
    
    true_sike_pk_phiPx_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_pk_phiPx)
    true_sike_pk_phiPxi_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_pk_phiPxi)
    true_sike_pk_phiQx_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_pk_phiQx)
    true_sike_pk_phiQxi_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_pk_phiQxi)
    true_sike_pk_phiRx_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_pk_phiRx)
    true_sike_pk_phiRxi_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_pk_phiRxi)
    
    true_sike_c0_phiPx_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_c0_phiPx)
    true_sike_c0_phiPxi_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_c0_phiPxi)
    true_sike_c0_phiQx_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_c0_phiQx)
    true_sike_c0_phiQxi_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_c0_phiQxi)
    true_sike_c0_phiRx_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_c0_phiRx)
    true_sike_c0_phiRxi_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, true_sike_c0_phiRxi)
    
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 0, true_sike_pk_phiPx_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 1, true_sike_pk_phiPxi_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 2, true_sike_pk_phiQx_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 3, true_sike_pk_phiQxi_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 4, true_sike_pk_phiRx_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 5, true_sike_pk_phiRxi_list, number_of_words)
    
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 6, true_sike_c0_phiPx_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 7, true_sike_c0_phiPxi_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 8, true_sike_c0_phiQx_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 9, true_sike_c0_phiQxi_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 10, true_sike_c0_phiRx_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_input_function_start_address + 11, true_sike_c0_phiRxi_list, number_of_words)
    
    test_value_sike_sk_list  = sike_core_utils.integer_to_list(base_word_size, 32, sike_sk)
    start_address_sike_sk = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_sk_start_address
    for j in range(32):
        zedboard.write_package(start_address_sike_sk+j, test_value_sike_sk_list[j])
    
    start_address_sike_s = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_s_start_address
    for j in range(0, len(sike_s), 2):
        zedboard.write_package(start_address_sike_s+(j//2), sike_s[j+1]*256 + sike_s[j])
    for j in range(len(sike_s), 32, 2):
        zedboard.write_package(start_address_sike_s+(j//2), 0)
    
    start_address_sike_c1 = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_c1_start_address
    for j in range(0, len(true_sike_c1), 2):
        zedboard.write_package(start_address_sike_c1+(j//2), true_sike_c1[j+1]*256 + true_sike_c1[j])
    for j in range(len(true_sike_c1), 32, 2):
        zedboard.write_package(start_address_sike_c1+(j//2), 0)
    
    zedboard.write_package(sike_core_reg_program_counter_address, program_start_address_test_sike_kem_dec)
    
    time.sleep(0.1)
    
    while(not zedboard.isFree()):
        time.sleep(0.1)
    
    computed_test_value_o1_list = bytearray(sike_shared_secret_length)
    start_address_sike_ss = sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_sike_ss_start_address
    for j in range(0, len(computed_test_value_o1_list), 2):
        temp_value = zedboard.read_package(start_address_sike_ss+(j//2))
        computed_test_value_o1_list[j]   = temp_value & 255;
        computed_test_value_o1_list[j+1] = (temp_value >> 8) & 255;
    
    if((debug_mode) or (computed_test_value_o1_list != true_sike_ss)):
        print("Error in SIKE decryption ")
        print("SIKE sk")
        print(sike_sk)
        print("SIKE s")
        print(binascii.hexlify(sike_s))
        print("SIKE m")
        print(binascii.hexlify(sike_m))
        print("Computed SIKE ss")
        print(binascii.hexlify(computed_test_value_o1_list))
        print("True SIKE ss")
        print(binascii.hexlify(true_sike_ss))
        return True
    return False

def test_sike_decryption(zedboard, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, alice_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, oa, ob, sike_message_length, sike_shared_secret_length, number_of_tests, debug_mode=False):

    arithmetic_parameters = sike_core_utils.generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    
    prime_list = arithmetic_parameters[4]
    prime_plus_one_list = arithmetic_parameters[6]
    prime_line_list = arithmetic_parameters[18]
    r_mod_prime_list = arithmetic_parameters[13]
    r2_list = arithmetic_parameters[15]
    constant_1_list = arithmetic_parameters[20]
    number_of_words = arithmetic_parameters[9]
    
    error_computation = False
        
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    oa_bits = int(oa-1).bit_length()
    ob_bits = int(ob-1).bit_length()
    t_bits_mask = oa_bits - (((oa_bits + (base_word_size - 1))//base_word_size)-1)*base_word_size
    oa_mask = 2**t_bits_mask-1
    t_bits_mask = ob_bits - (((ob_bits + (base_word_size - 1))//base_word_size)-1)*base_word_size
    ob_mask = 2**t_bits_mask-1
    
    inv_4 = (fp2(4)**(-1)).polynomial()[0]
    inv_4_mont = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    constant_inv_4_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, inv_4_mont)
    
    test_value_xpa_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[0])
    test_value_xpai_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[1])
    test_value_xqa_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[2])
    test_value_xqai_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[3])
    test_value_xra_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[4])
    test_value_xrai_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, alice_gen_points[5])
    test_value_xpb_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[0])
    test_value_xpbi_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[1])
    test_value_xqb_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[2])
    test_value_xqbi_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[3])
    test_value_xrb_mont   = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[4])
    test_value_xrbi_mont  = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, bob_gen_points[5])
    
    test_value_xpa_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xpa_mont)
    test_value_xpai_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xpai_mont)
    test_value_xqa_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xqa_mont)
    test_value_xqai_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xqai_mont)
    test_value_xra_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xra_mont)
    test_value_xrai_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xrai_mont)
    test_value_xpb_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xpb_mont)
    test_value_xpbi_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xpbi_mont)
    test_value_xqb_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xqb_mont)
    test_value_xqbi_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xqbi_mont)
    test_value_xrb_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xrb_mont)
    test_value_xrbi_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, test_value_xrbi_mont)
    
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_address, prime_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_plus_one_address, prime_plus_one_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_line_address, prime_line_list, number_of_words)
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
    zedboard.write_package(sike_core_reg_prime_line_equal_one_address, 0)
    zedboard.write_package(sike_core_reg_prime_address_address, 0)
    zedboard.write_package(sike_core_reg_prime_plus_one_address_address, 1)
    zedboard.write_package(sike_core_reg_prime_line_address_address, 2)
    zedboard.write_package(sike_core_reg_initial_stack_address_address, starting_position_stack_sidh_core)
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [[[0 for j in range(sike_message_length)], 0, [0 for j in range(sike_message_length)]], [[0 for j in range(sike_message_length)], ob-1, [0 for j in range(sike_message_length)]], [[0 for j in range(sike_message_length)], 0, [100 for j in range(sike_message_length)]], [[0 for j in range(sike_message_length)], ob-1, [100 for j in range(sike_message_length)]]]
    for test in fixed_tests:
        sike_s  = bytearray(test[0])
        sike_sk = test[1]
        sike_m  = bytearray(test[2])
        error_computation = test_single_sike_decryption(zedboard, fp2, arithmetic_parameters, alice_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, oa, ob, oa_bits, ob_bits, sike_message_length, sike_shared_secret_length, sike_sk, sike_s, sike_m, debug_mode=False)
        tests_already_performed += 1
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            sike_s  = bytearray([random.randint(0, 255) for j in range(sike_message_length)])
            sike_sk = random.randint(0, ob-1)
            sike_m  = bytearray([random.randint(0, 255) for j in range(sike_message_length)])
            error_computation = test_single_sike_decryption(zedboard, fp2, arithmetic_parameters, alice_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, oa, ob, oa_bits, ob_bits, sike_message_length, sike_shared_secret_length, sike_sk, sike_s, sike_m, debug_mode=False)
        
            if(error_computation):
                break
    
    return error_computation

def test_all_sike_decryption(zedboard, base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests):
    error_computation = False
    for param in SIKE_round2_constants.sidh_constants:
        print("Testing SIKE decryption " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        oa = (param[2])**(param[4])
        ob = (param[3])**(param[5])
        alice_gen_points = param[6:12]
        alice_splits = param[18]
        alice_max_row = param[19]
        alice_max_int_points = param[20]
        bob_gen_points = param[12:18]
        bob_splits = param[21]
        bob_max_row = param[22]
        bob_max_int_points = param[23]
        sike_message_length = param[24]
        sike_shared_secret_length = param[25]
        error_computation = test_sike_decryption(zedboard, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, alice_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, oa, ob, sike_message_length, sike_shared_secret_length, number_of_tests, debug_mode=False)
        if(error_computation):
            break

def test_all_sike_functions(zedboard, version):
    sike_base_word_size = 16
    if(version == '256'):
        sike_extended_word_size = 256
    elif(version == '128'):
        sike_extended_word_size = 128
    sike_accumulator_word_size = 32
    number_of_bits_added = 8
    tests_working_folder = "../hw_sidh_tests_v"+str(sike_extended_word_size)+"/"
    if(load_program(zedboard, tests_prom_folder + "test_sike_functions_v" + str(sike_extended_word_size)+ ".dat", sike_base_word_size, 4)):
        print("Program loaded correctly into SIKE core")
        test_all_sike_keygen(zedboard, sike_base_word_size, sike_extended_word_size, number_of_bits_added, sike_accumulator_word_size, 100)
        test_all_sike_encryption(zedboard, sike_base_word_size, sike_extended_word_size, number_of_bits_added, sike_accumulator_word_size, 100)
        test_all_sike_decryption(zedboard, sike_base_word_size, sike_extended_word_size, number_of_bits_added, sike_accumulator_word_size, 100)
    else:
        print('Program loading failed')

if(sys.argv[1] == '256'):
    starting_position_stack_sidh_core = starting_position_stack_sidh_core*4
elif(sys.argv[1] == '128'):
    starting_position_stack_sidh_core = starting_position_stack_sidh_core*8

zedboard = Zedboard('COM5', sys.argv[1])
#zedboard.read_initial_message(34)
while(not zedboard.isFree()):
    time.sleep(0.01)
zedboard.flush()

test_all_sike_functions(zedboard, sys.argv[1])

zedboard.disconnect()