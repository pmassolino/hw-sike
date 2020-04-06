import sidh_fp2
import sidh_constants
import sike_core_utils

def generate_fpga_constants(prime_oa, prime_ob, sidh_alice_gen_points, sidh_bob_gen_points, sidh_alice_splits, sidh_alice_max_row, sidh_alice_max_int_points, sidh_bob_splits, sidh_bob_max_row, sidh_bob_max_int_points, sike_message_length, sike_shared_secret_length, base_word_size, extended_word_size, number_of_bits_added):
    sike_fpga_constants = [0 for i in range(53)]
    
    prime = prime_oa*prime_ob - 1
    accumulator_word_size=2*256+32
    prime_size_bits = int(prime).bit_length()
    arithmetic_parameters = sike_core_utils.generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    
    prime_plus_one = arithmetic_parameters[5]
    prime_line = arithmetic_parameters[17]
    
    r_mod_prime = arithmetic_parameters[12]
    r2_mod_prime = arithmetic_parameters[14]
    number_of_words = arithmetic_parameters[9]
    
    prime_line_equal_one = arithmetic_parameters[19]
    
    fp2 = sidh_fp2.sidh_fp2(prime)
    
    oa_bits = int(prime_oa-1).bit_length()
    ob_bits = int(prime_ob-1).bit_length()
    t_bits_mask = oa_bits - (((oa_bits + (base_word_size - 1))//base_word_size)-1)*base_word_size
    oa_mask = 2**t_bits_mask-1
    t_bits_mask = ob_bits - (((ob_bits + (base_word_size - 1))//base_word_size)-1)*base_word_size
    ob_mask = 2**t_bits_mask-1
    
    inv_4 = (fp2(4)**(-1)).polynomial()[0]
    inv_4_mont = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    
    sike_fpga_constants[0]  = "p" + str(prime_size_bits)
    sike_fpga_constants[1]  = base_word_size
    sike_fpga_constants[2]  = extended_word_size
    sike_fpga_constants[3]  = number_of_bits_added
    sike_fpga_constants[4]  = number_of_words
    sike_fpga_constants[5]  = prime
    sike_fpga_constants[6]  = prime_size_bits
    sike_fpga_constants[7]  = prime_plus_one
    sike_fpga_constants[8]  = prime_line
    sike_fpga_constants[9]  = prime_line_equal_one
    sike_fpga_constants[10] = prime_oa
    sike_fpga_constants[11] = prime_ob
    sike_fpga_constants[12] = oa_mask
    sike_fpga_constants[13] = ob_mask
    sike_fpga_constants[14] = oa_bits
    sike_fpga_constants[15] = ob_bits
    sike_fpga_constants[16] = r_mod_prime
    sike_fpga_constants[17] = r2_mod_prime
    sike_fpga_constants[18] = int(1)
    sike_fpga_constants[19] = int(inv_4_mont)
    
    sike_fpga_constants[20] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, sidh_alice_gen_points[0])
    sike_fpga_constants[21] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, sidh_alice_gen_points[1])
    sike_fpga_constants[22] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, sidh_alice_gen_points[2])
    sike_fpga_constants[23] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, sidh_alice_gen_points[3])
    sike_fpga_constants[24] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, sidh_alice_gen_points[4])
    sike_fpga_constants[25] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, sidh_alice_gen_points[5])
    sike_fpga_constants[26] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, sidh_bob_gen_points[0])
    sike_fpga_constants[27] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, sidh_bob_gen_points[1])
    sike_fpga_constants[28] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, sidh_bob_gen_points[2])
    sike_fpga_constants[29] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, sidh_bob_gen_points[3])
    sike_fpga_constants[30] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, sidh_bob_gen_points[4])
    sike_fpga_constants[31] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, sidh_bob_gen_points[5])
    
    sike_fpga_constants[32] = sidh_alice_splits
    sike_fpga_constants[33] = sidh_alice_max_row
    sike_fpga_constants[34] = sidh_alice_max_int_points
    sike_fpga_constants[35] = sidh_bob_splits
    sike_fpga_constants[36] = sidh_bob_max_row
    sike_fpga_constants[37] = sidh_bob_max_int_points
    sike_fpga_constants[38] = sike_message_length
    sike_fpga_constants[39] = sike_shared_secret_length
    sike_fpga_constants[40] = 224*(1024//extended_word_size)
    
    sike_fpga_constants[41] = sidh_alice_gen_points[0]
    sike_fpga_constants[42] = sidh_alice_gen_points[1]
    sike_fpga_constants[43] = sidh_alice_gen_points[2]
    sike_fpga_constants[44] = sidh_alice_gen_points[3]
    sike_fpga_constants[45] = sidh_alice_gen_points[4]
    sike_fpga_constants[46] = sidh_alice_gen_points[5]
    sike_fpga_constants[47] = sidh_bob_gen_points[0]
    sike_fpga_constants[48] = sidh_bob_gen_points[1]
    sike_fpga_constants[49] = sidh_bob_gen_points[2]
    sike_fpga_constants[50] = sidh_bob_gen_points[3]
    sike_fpga_constants[51] = sidh_bob_gen_points[4]
    sike_fpga_constants[52] = sidh_bob_gen_points[5]
    
    return sike_fpga_constants

def print_fpga_constants(filename_constants, sike_fpga_constants_all_parameters):
    with open(filename_constants, 'w') as file_constants:
        file_constants.write(filename_constants[0:-3] + ' = [\n')
        for sike_fpga_constants in sike_fpga_constants_all_parameters:
            file_constants.write('[\n')
            file_constants.write('# ' + ' Parameter name\n')
            file_constants.write('"' + sike_fpga_constants[0] + '"' + ',\n')
            file_constants.write('# ' + ' base word size\n')
            file_constants.write(str(sike_fpga_constants[1]) + ',\n')
            file_constants.write('# ' + ' extended word size\n')
            file_constants.write(str(sike_fpga_constants[2]) + ',\n')
            file_constants.write('# ' + ' number of bits added\n')
            file_constants.write(str(sike_fpga_constants[3]) + ',\n')
            file_constants.write('# ' + ' number of words\n')
            file_constants.write(str(sike_fpga_constants[4]) + ',\n')
            file_constants.write('# ' + ' prime\n')
            file_constants.write(str(sike_fpga_constants[5]) + ',\n')
            file_constants.write('# ' + ' prime size in bits\n')
            file_constants.write(str(sike_fpga_constants[6]) + ',\n')
            file_constants.write('# ' + ' prime+1\n')
            file_constants.write(str(sike_fpga_constants[7]) + ',\n')
            file_constants.write('# ' + " prime' = -1/prime mod r\n")
            file_constants.write(str(sike_fpga_constants[8]) + ',\n')
            file_constants.write('# ' + ' prime line mod word size\n')
            file_constants.write(str(sike_fpga_constants[9]) + ',\n')
            file_constants.write('# ' + ' oa\n')
            file_constants.write(str(sike_fpga_constants[10]) + ',\n')
            file_constants.write('# ' + ' ob\n')
            file_constants.write(str(sike_fpga_constants[11]) + ',\n')
            file_constants.write('# ' + ' oa mask\n')
            file_constants.write(str(sike_fpga_constants[12]) + ',\n')
            file_constants.write('# ' + ' ob mask\n')
            file_constants.write(str(sike_fpga_constants[13]) + ',\n')
            file_constants.write('# ' + ' oa bits\n')
            file_constants.write(str(sike_fpga_constants[14]) + ',\n')
            file_constants.write('# ' + ' ob bits\n')
            file_constants.write(str(sike_fpga_constants[15]) + ',\n')
            file_constants.write('# ' + ' r mod prime\n')
            file_constants.write(str(sike_fpga_constants[16]) + ',\n')
            file_constants.write('# ' + ' r^2 mod prime\n')
            file_constants.write(str(sike_fpga_constants[17]) + ',\n')
            file_constants.write('# ' + ' value 1\n')
            file_constants.write(str(sike_fpga_constants[18]) + ',\n')
            file_constants.write('# ' + ' r/4 mod prime\n')
            file_constants.write(str(sike_fpga_constants[19]) + ',\n')
            file_constants.write('# ' + ' SIDH xPA  in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(sike_fpga_constants[20]) + ',\n')
            file_constants.write('# ' + ' SIDH xPAi in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(sike_fpga_constants[21]) + ',\n')
            file_constants.write('# ' + ' SIDH xQA  in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(sike_fpga_constants[22]) + ',\n')
            file_constants.write('# ' + ' SIDH xQAi in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(sike_fpga_constants[23]) + ',\n')
            file_constants.write('# ' + ' SIDH xRA  in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(sike_fpga_constants[24]) + ',\n')
            file_constants.write('# ' + ' SIDH xRAi in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(sike_fpga_constants[25]) + ',\n')
            file_constants.write('# ' + ' SIDH xPB  in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(sike_fpga_constants[26]) + ',\n')
            file_constants.write('# ' + ' SIDH xPBi in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(sike_fpga_constants[27]) + ',\n')
            file_constants.write('# ' + ' SIDH xQB  in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(sike_fpga_constants[28]) + ',\n')
            file_constants.write('# ' + ' SIDH xQBi in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(sike_fpga_constants[29]) + ',\n')
            file_constants.write('# ' + ' SIDH xRBi in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(sike_fpga_constants[30]) + ',\n')
            file_constants.write('# ' + ' SIDH xRB  in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(sike_fpga_constants[31]) + ',\n')
            file_constants.write('# ' + ' sidh splits alice\n')
            file_constants.write(str(sike_fpga_constants[32]) + ',\n')
            file_constants.write('# ' + ' sidh max row alice\n')
            file_constants.write(str(sike_fpga_constants[33]) + ',\n')
            file_constants.write('# ' + ' sidh max int points alice\n')
            file_constants.write(str(sike_fpga_constants[34]) + ',\n')
            file_constants.write('# ' + ' sidh splits bob\n')
            file_constants.write(str(sike_fpga_constants[35]) + ',\n')
            file_constants.write('# ' + ' sidh max row bob\n')
            file_constants.write(str(sike_fpga_constants[36]) + ',\n')
            file_constants.write('# ' + ' sidh max int points bob\n')
            file_constants.write(str(sike_fpga_constants[37]) + ',\n')
            file_constants.write('# ' + ' SIKE message length\n')
            file_constants.write(str(sike_fpga_constants[38]) + ',\n')
            file_constants.write('# ' + ' SIKE shared secret length\n')
            file_constants.write(str(sike_fpga_constants[39]) + ',\n')
            file_constants.write('# ' + ' SIKE stack starting address\n')
            file_constants.write(str(sike_fpga_constants[40]) + ',\n')
            file_constants.write('# ' + ' SIDH xPA  original\n')
            file_constants.write(str(sike_fpga_constants[41]) + ',\n')
            file_constants.write('# ' + ' SIDH xPAi original\n')
            file_constants.write(str(sike_fpga_constants[42]) + ',\n')
            file_constants.write('# ' + ' SIDH xQA  original\n')
            file_constants.write(str(sike_fpga_constants[43]) + ',\n')
            file_constants.write('# ' + ' SIDH xQAi original\n')
            file_constants.write(str(sike_fpga_constants[44]) + ',\n')
            file_constants.write('# ' + ' SIDH xRA  original\n')
            file_constants.write(str(sike_fpga_constants[45]) + ',\n')
            file_constants.write('# ' + ' SIDH xRAi original\n')
            file_constants.write(str(sike_fpga_constants[46]) + ',\n')
            file_constants.write('# ' + ' SIDH xPB  original\n')
            file_constants.write(str(sike_fpga_constants[47]) + ',\n')
            file_constants.write('# ' + ' SIDH xPBi original\n')
            file_constants.write(str(sike_fpga_constants[48]) + ',\n')
            file_constants.write('# ' + ' SIDH xQB  original\n')
            file_constants.write(str(sike_fpga_constants[49]) + ',\n')
            file_constants.write('# ' + ' SIDH xQBi original\n')
            file_constants.write(str(sike_fpga_constants[50]) + ',\n')
            file_constants.write('# ' + ' SIDH xRBi original\n')
            file_constants.write(str(sike_fpga_constants[51]) + ',\n')
            file_constants.write('# ' + ' SIDH xRB  original\n')
            file_constants.write(str(sike_fpga_constants[52]) + ',\n')
            file_constants.write('],\n')
        file_constants.write(']\n')

def generate_and_print_parameters(base_word_size = 16, extended_word_size = 256, number_of_bits_added = 16, filename_constants = 'sike_fpga_constants.py'):
    sike_fpga_constants_all_parameters = []
    
    for param in sidh_constants.sidh_constants:
    
        prime_oa = (param[2])**(param[4])
        prime_ob = (param[3])**(param[5])
        sidh_alice_gen_points = param[6:12]
        sidh_alice_splits = param[18]
        sidh_alice_max_row = param[19]
        sidh_alice_max_int_points = param[20]
        sidh_bob_gen_points = param[12:18]
        sidh_bob_splits = param[21]
        sidh_bob_max_row = param[22]
        sidh_bob_max_int_points = param[23]
        sike_message_length = param[24]
        sike_shared_secret_length = param[25]
        
        sike_fpga_constants_all_parameters += [generate_fpga_constants(prime_oa, prime_ob, sidh_alice_gen_points, sidh_bob_gen_points, sidh_alice_splits, sidh_alice_max_row, sidh_alice_max_int_points, sidh_bob_splits, sidh_bob_max_row, sidh_bob_max_int_points, sike_message_length, sike_shared_secret_length, base_word_size, extended_word_size, number_of_bits_added)]
        
    print_fpga_constants(filename_constants, sike_fpga_constants_all_parameters)

generate_and_print_parameters(base_word_size = 16, extended_word_size = 256, number_of_bits_added = 16, filename_constants = 'sike_fpga_constants_v256.py')
generate_and_print_parameters(base_word_size = 16, extended_word_size = 128, number_of_bits_added = 16, filename_constants = 'sike_fpga_constants_v128.py')
