import binascii

proof.arithmetic(False)
home_folder = "/home/pedro/"
script_working_folder = home_folder + "hw-sidh/vhdl_project/sage/"
load(script_working_folder+"base_tests_for_sidh_v2/all_sidh_functions.sage")
load(script_working_folder+"base_tests_for_sidh_v2/sidh_constants.sage")

load(script_working_folder+"base_tests_for_sike_v2/all_sike_functions.sage")
load(script_working_folder+"base_tests_for_sike_v2/CompactFIPS202.py")

def test_single_keygen_sike(arithmetic_parameters, fp2, sike_s, sike_sk, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, debug=False):
    extended_word_size_signed = arithmetic_parameters[0]
    prime = arithmetic_parameters[3]
    number_of_words = arithmetic_parameters[9]
    
    test_value_xpa_mont   = enter_montgomery_domain(arithmetic_parameters, xpa)
    test_value_xpai_mont  = enter_montgomery_domain(arithmetic_parameters, xpai)
    test_value_xqa_mont   = enter_montgomery_domain(arithmetic_parameters, xqa)
    test_value_xqai_mont  = enter_montgomery_domain(arithmetic_parameters, xqai)
    test_value_xra_mont   = enter_montgomery_domain(arithmetic_parameters, xra)
    test_value_xrai_mont  = enter_montgomery_domain(arithmetic_parameters, xrai)
    test_value_xpb_mont   = enter_montgomery_domain(arithmetic_parameters, xpb)
    test_value_xpbi_mont  = enter_montgomery_domain(arithmetic_parameters, xpbi)
    test_value_xqb_mont   = enter_montgomery_domain(arithmetic_parameters, xqb)
    test_value_xqbi_mont  = enter_montgomery_domain(arithmetic_parameters, xqbi)
    test_value_xrb_mont   = enter_montgomery_domain(arithmetic_parameters, xrb)
    test_value_xrbi_mont  = enter_montgomery_domain(arithmetic_parameters, xrbi)
    
    inv_4 = (fp2(4)^(-1)).polynomial()[0]
    inv_4_mont = enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    
    test_value_o1, test_value_o2, test_value_sike_pk_phiPX, test_value_sike_pk_phiPXi, test_value_sike_pk_phiQX, test_value_sike_pk_phiQXi, test_value_sike_pk_phiRX, test_value_sike_pk_phiRXi = keygen_sike(arithmetic_parameters, sike_s, sike_sk, test_value_xpa_mont, test_value_xpai_mont, test_value_xqa_mont, test_value_xqai_mont, test_value_xra_mont, test_value_xrai_mont, test_value_xpb_mont, test_value_xpbi_mont, test_value_xqb_mont, test_value_xqbi_mont, test_value_xrb_mont, test_value_xrbi_mont, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, inv_4_mont)
    
    true_value_o1, true_value_o2, true_value_sike_pk_phiPX, true_value_sike_pk_phiPXi, true_value_sike_pk_phiQX, true_value_sike_pk_phiQXi, true_value_sike_pk_phiRX, true_value_sike_pk_phiRXi = sage_keygen_sike(fp2, sike_s, sike_sk, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, inv_4)
    
    if((debug) or (test_value_sike_pk_phiPX != true_value_sike_pk_phiPX) or (test_value_sike_pk_phiPXi != true_value_sike_pk_phiPXi) or (test_value_sike_pk_phiQX != true_value_sike_pk_phiQX) or (test_value_sike_pk_phiQXi != true_value_sike_pk_phiQXi) or (test_value_sike_pk_phiRX != true_value_sike_pk_phiRX) or (test_value_sike_pk_phiRXi != true_value_sike_pk_phiRXi)):
        print("Error in SIKE key generation ")
        print('')
        print("Prime")
        print(prime)
        print('')
        print("Value sike_sk")
        print(sike_sk)
        print('')
        print("Test phiPX")
        print(test_value_sike_pk_phiPX)
        print(test_value_sike_pk_phiPXi)
        print('')
        print("True phiPX")
        print(true_value_sike_pk_phiPX)
        print(true_value_sike_pk_phiPXi)
        print('')
        print("Test phiQX")
        print(test_value_sike_pk_phiQX)
        print(test_value_sike_pk_phiQXi)
        print('')
        print("True phiQX")
        print(true_value_sike_pk_phiQX)
        print(true_value_sike_pk_phiQXi)
        print('')
        print("Test phiRX")
        print(test_value_sike_pk_phiRX)
        print(test_value_sike_pk_phiRXi)
        print('')
        print("True phiRX")
        print(true_value_sike_pk_phiRX)
        print(true_value_sike_pk_phiRXi)
        print('')
        return True

    return False
    
def test_keygen_sike(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, la, oa, lb, ob, sike_message_length, sike_shared_length, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
    
    oa_bits = int(oa-1).bit_length()
    ob_bits = int(ob-1).bit_length()
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [[[0 for j in range(sike_message_length)], 0], [[0 for j in range(sike_message_length)], ob-1]]
    for test in fixed_tests:
        sike_s  = test[0]
        sike_sk = test[1]
        error_computation = test_single_keygen_sike(arithmetic_parameters, fp2, sike_s, sike_sk, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob)
        tests_already_performed += 1
        if(error_computation):
            break
            
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            sike_s  = bytearray([randint(0, 255) for j in range(sike_message_length)])
            sike_sk = randint(0, ob-1)
            error_computation = test_single_keygen_sike(arithmetic_parameters, fp2, sike_s, sike_sk, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob)
        
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_keygen_sike_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, la, oa, lb, ob, sike_message_length, sike_shared_length, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, number_of_tests):
    
    VHDL_memory_file = open(VHDL_memory_file_name, 'w')
    
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    base_word_size_signed = arithmetic_parameters[1]
    base_word_size_signed_number_words = (((extended_word_size_signed) + ((base_word_size_signed)-1))//(base_word_size_signed))
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    prime = arithmetic_parameters[3]
    prime_list = arithmetic_parameters[4]
    prime_plus_one = arithmetic_parameters[5]
    prime_plus_one_list = arithmetic_parameters[6]
    prime_line_list = arithmetic_parameters[18]
    prime_line_zero = arithmetic_parameters[19]
    r_constant = arithmetic_parameters[10]
    r_mod_prime_constant = arithmetic_parameters[12]
    r_mod_prime_constant_list = arithmetic_parameters[13]
    r2_constant_list = arithmetic_parameters[15]
    accumulator_word_modulus = arithmetic_parameters[23]
    constant_1 = arithmetic_parameters[20]
    
    tests_already_performed = 0
    
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
    
    inv_4 = (fp2(4)^(-1)).polynomial()[0]
    inv_4_mont = enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    inv_4_mont_list = integer_to_list(extended_word_size_signed, number_of_words, inv_4_mont)
    
    oa_bits = int(oa-1).bit_length()
    ob_bits = int(ob-1).bit_length()
    
    t_bits_mask = oa_bits - (((oa_bits + (base_word_size_signed - 1))//base_word_size_signed)-1)*base_word_size_signed
    oa_mask = 2**t_bits_mask-1
    t_bits_mask = ob_bits - (((ob_bits + (base_word_size_signed - 1))//base_word_size_signed)-1)*base_word_size_signed
    ob_mask = 2**t_bits_mask-1
    
    test_value_xpa_mont   = enter_montgomery_domain(arithmetic_parameters, xpa)
    test_value_xpai_mont  = enter_montgomery_domain(arithmetic_parameters, xpai)
    test_value_xqa_mont   = enter_montgomery_domain(arithmetic_parameters, xqa)
    test_value_xqai_mont  = enter_montgomery_domain(arithmetic_parameters, xqai)
    test_value_xra_mont   = enter_montgomery_domain(arithmetic_parameters, xra)
    test_value_xrai_mont  = enter_montgomery_domain(arithmetic_parameters, xrai)
    test_value_xpb_mont   = enter_montgomery_domain(arithmetic_parameters, xpb)
    test_value_xpbi_mont  = enter_montgomery_domain(arithmetic_parameters, xpbi)
    test_value_xqb_mont   = enter_montgomery_domain(arithmetic_parameters, xqb)
    test_value_xqbi_mont  = enter_montgomery_domain(arithmetic_parameters, xqbi)
    test_value_xrb_mont   = enter_montgomery_domain(arithmetic_parameters, xrb)
    test_value_xrbi_mont  = enter_montgomery_domain(arithmetic_parameters, xrbi)
    
    test_value_xpa_mont_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_xpa_mont)
    test_value_xpai_mont_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_xpai_mont)
    test_value_xqa_mont_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_xqa_mont)
    test_value_xqai_mont_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_xqai_mont)
    test_value_xra_mont_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_xra_mont)
    test_value_xrai_mont_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_xrai_mont)
    test_value_xpb_mont_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_xpb_mont)
    test_value_xpbi_mont_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_xpbi_mont)
    test_value_xqb_mont_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_xqb_mont)
    test_value_xqbi_mont_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_xqbi_mont)
    test_value_xrb_mont_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_xrb_mont)
    test_value_xrbi_mont_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_xrbi_mont)
    
    VHDL_memory_file.write((("{0:0d}").format(number_of_tests)))
    VHDL_memory_file.write('\n')
    
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_plus_one_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_line_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, r_mod_prime_constant_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, r2_constant_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, constant_1, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, inv_4_mont_list, maximum_number_of_words)
    
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, sike_message_length, False)
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, sike_shared_length, False)
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, oa_mask, False)
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, ob_mask, False)
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, oa_bits, False)
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, ob_bits, False)
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, prime_size_bits, False)
    print_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, splits_alice, 302, False)
    print_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, splits_bob, 302, False)
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, max_row_alice, False)
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, max_row_bob, False)
    
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xpa_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xpai_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xqa_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xqai_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xra_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xrai_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xpb_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xpbi_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xqb_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xqbi_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xrb_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xrbi_mont_list, maximum_number_of_words)
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [0, ob-1]
    for test in fixed_tests:
        sike_s = bytearray([0 for i in range(32)])
        sike_sk = test
        
        test_value_sike_sk_list  = integer_to_list(base_word_size_signed, 32, sike_sk)
        
        test_value_o1, test_value_o2, test_value_o3, test_value_o3i, test_value_o4, test_value_o4i, test_value_o5, test_value_o5i = keygen_sike(arithmetic_parameters, sike_s, sike_sk, test_value_xpa_mont, test_value_xpai_mont, test_value_xqa_mont, test_value_xqai_mont, test_value_xra_mont, test_value_xrai_mont, test_value_xpb_mont, test_value_xpbi_mont, test_value_xqb_mont, test_value_xqbi_mont, test_value_xrb_mont, test_value_xrbi_mont, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, inv_4_mont)
        
        test_value_o1_list = integer_to_list(base_word_size_signed, 32, bytearray_to_int(test_value_o1))
        test_value_o2_list = integer_to_list(base_word_size_signed, 32, test_value_o2)
        test_value_o3_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o3))
        test_value_o3i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o3i))
        test_value_o4_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o4))
        test_value_o4i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o4i))
        test_value_o5_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o5))
        test_value_o5i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o5i))
        
        print_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, test_value_o1_list, 32, False)
        print_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, test_value_o2_list, 32, False)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o3_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o3i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o4_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o4i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o5_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o5i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        sike_s  = bytearray([randint(0, 255) for j in range(sike_message_length)])
        sike_sk = randint(0, ob-1)
        
        test_value_sike_sk_list  = integer_to_list(base_word_size_signed, 32, sike_sk)
        
        test_value_o1, test_value_o2, test_value_o3, test_value_o3i, test_value_o4, test_value_o4i, test_value_o5, test_value_o5i = keygen_sike(arithmetic_parameters, sike_s, sike_sk, test_value_xpa_mont, test_value_xpai_mont, test_value_xqa_mont, test_value_xqai_mont, test_value_xra_mont, test_value_xrai_mont, test_value_xpb_mont, test_value_xpbi_mont, test_value_xqb_mont, test_value_xqbi_mont, test_value_xrb_mont, test_value_xrbi_mont, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, inv_4_mont)
        
        test_value_o1_list = integer_to_list(base_word_size_signed, 32, bytearray_to_int(test_value_o1))
        test_value_o2_list = integer_to_list(base_word_size_signed, 32, test_value_o2)
        test_value_o3_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o3))
        test_value_o3i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o3i))
        test_value_o4_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o4))
        test_value_o4i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o4i))
        test_value_o5_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o5))
        test_value_o5i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o5i))
        
        print_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, test_value_o1_list, 32, False)
        print_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, test_value_o2_list, 32, False)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o3_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o3i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o4_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o4i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o5_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o5i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    VHDL_memory_file.close()
    
def load_VHDL_keygen_sike_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    base_word_size_signed = arithmetic_parameters[1]
    base_word_size_signed_number_words = (((extended_word_size_signed) + ((base_word_size_signed)-1))//(base_word_size_signed))
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    prime = arithmetic_parameters[3]
    prime_list = arithmetic_parameters[4]
    prime_plus_one = arithmetic_parameters[5]
    prime_plus_one_list = arithmetic_parameters[6]
    prime_line = arithmetic_parameters[17]
    prime_line_zero = arithmetic_parameters[19]
    r_constant = arithmetic_parameters[10]
    r_mod_prime_constant = arithmetic_parameters[12]
    r_mod_prime_constant_list = arithmetic_parameters[13]
    r2_constant = arithmetic_parameters[14]
    r2_constant_list = arithmetic_parameters[15]
    r_inverse = arithmetic_parameters[16]
    accumulator_word_modulus = arithmetic_parameters[23]
    constant_1 = arithmetic_parameters[20]
    
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
    
    inv_4 = (fp2(4)^(-1)).polynomial()[0]
    inv_4_mont = enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    inv_4_mont_list = integer_to_list(extended_word_size_signed, number_of_words, inv_4_mont)
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size_signed
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
    loaded_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime != prime):
        print("Error in SIKE key generation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error in SIKE key generation : " + str(current_test))
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error in SIKE key generation : " + str(current_test))
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r_mod_prime != r_mod_prime_constant):
        print("Error in SIKE key generation : " + str(current_test))
        print("Error loading the r")
        print("Loaded r")
        print(loaded_r_mod_prime)
        print("Input r")
        print(r_mod_prime_constant)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r2 != r2_constant):
        print("Error in SIKE key generation : " + str(current_test))
        print("Error loading the r2")
        print("Loaded r2")
        print(loaded_r2)
        print("Input r2")
        print(r2_constant)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_1 != 1):
        print("Error in SIKE key generation : " + str(current_test))
        print("Error loading the constant 1")
        print("Loaded constant 1")
        print(loaded_constant_1)
        print("Input constant 1")
        print(1)
    loaded_constant_inv_4 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_inv_4 != inv_4_mont):
        print("Error in SIKE key generation : " + str(current_test))
        print("Error loading the inversion 4")
        print("Loaded inversion 4")
        print(loaded_constant_inv_4)
        print("Input inversion 4")
        print(inv_4_mont)
    loaded_sike_message_length = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_sike_shared_length = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_oa_mask = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_ob_mask = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_oa_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_ob_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in SIKE key generation : " + str(current_test))
        print("Error loading prime size in bits")
        print("Loaded prime size in bits")
        print(loaded_prime_size_bits)
        print("Input prime size in bits")
        print(prime_size_bits)
    
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    loaded_splits_alice   = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, 302, False)
    loaded_splits_bob     = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, 302, False)
    loaded_max_row_alice  = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_max_row_bob    = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
        
    test_value_xpa_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqa_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xra_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    while(current_test != (number_of_tests-1)):
        
        loaded_sike_s          = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, 32, False)
        loaded_sike_sk_list    = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, 32, False)
        loaded_sike_sk         = list_to_integer(base_word_size_signed, 32, loaded_sike_sk_list)
        
        loaded_test_value_o3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o4  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o4i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o5  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o5i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        computed_test_value_o1, computed_test_value_o2, computed_test_value_o3, computed_test_value_o3i, computed_test_value_o4, computed_test_value_o4i, computed_test_value_o5, computed_test_value_o5i = keygen_sike(arithmetic_parameters, loaded_sike_s, loaded_sike_sk, test_value_xpa_mont, test_value_xpai_mont, test_value_xqa_mont, test_value_xqai_mont, test_value_xra_mont, test_value_xrai_mont, test_value_xpb_mont, test_value_xpbi_mont, test_value_xqb_mont, test_value_xqbi_mont, test_value_xrb_mont, test_value_xrbi_mont, loaded_oa_bits, loaded_ob_bits, loaded_splits_alice, loaded_splits_bob, loaded_max_row_alice, loaded_max_row_bob, 12, 12, loaded_constant_inv_4)
        
        if((computed_test_value_o3 != loaded_test_value_o3) or (computed_test_value_o3i != loaded_test_value_o3i) or (computed_test_value_o4 != loaded_test_value_o4) or (computed_test_value_o4i != loaded_test_value_o4i) or (computed_test_value_o5 != loaded_test_value_o5) or (computed_test_value_o5i != loaded_test_value_o5i)):
            print("Error in SIKE key generation : " + str(current_test))
            print("Loaded sike s")
            print(loaded_sike_s)
            print("Loaded sike sk")
            print(loaded_sike_sk)
            print("Loaded value o3")
            print(loaded_test_value_o3)
            print(loaded_test_value_o3i)
            print("Computed value o3")
            print(computed_test_value_o3)
            print(computed_test_value_o3i)
            print("Loaded value o4")
            print(loaded_test_value_o4)
            print(loaded_test_value_o4i)
            print("Computed value o4")
            print(computed_test_value_o4)
            print(computed_test_value_o4i)
            print("Loaded value o5")
            print(loaded_test_value_o5)
            print(loaded_test_value_o5i)
            print("Computed value o5")
            print(computed_test_value_o5)
            print(computed_test_value_o5i)
        current_test += 1
    
    loaded_sike_s          = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, 32, False)
    loaded_sike_sk_list    = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, 32, False)
    loaded_sike_sk         = list_to_integer(base_word_size_signed, 32, loaded_sike_sk_list)
    
    loaded_test_value_o3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o4  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o4i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o5  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o5i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    computed_test_value_o1, computed_test_value_o2, computed_test_value_o3, computed_test_value_o3i, computed_test_value_o4, computed_test_value_o4i, computed_test_value_o5, computed_test_value_o5i = keygen_sike(arithmetic_parameters, loaded_sike_s, loaded_sike_sk, test_value_xpa_mont, test_value_xpai_mont, test_value_xqa_mont, test_value_xqai_mont, test_value_xra_mont, test_value_xrai_mont, test_value_xpb_mont, test_value_xpbi_mont, test_value_xqb_mont, test_value_xqbi_mont, test_value_xrb_mont, test_value_xrbi_mont, loaded_oa_bits, loaded_ob_bits, loaded_splits_alice, loaded_splits_bob, loaded_max_row_alice, loaded_max_row_bob, 12, 12, loaded_constant_inv_4)
    
    if(debug_mode or ((computed_test_value_o3 != loaded_test_value_o3) or (computed_test_value_o3i != loaded_test_value_o3i) or (computed_test_value_o4 != loaded_test_value_o4) or (computed_test_value_o4i != loaded_test_value_o4i) or (computed_test_value_o5 != loaded_test_value_o5) or (computed_test_value_o5i != loaded_test_value_o5i))):
        print("Error in SIKE key generation : " + str(current_test))
        print("Loaded sike s")
        print(loaded_sike_s)
        print("Loaded sike sk")
        print(loaded_sike_sk)
        print("Loaded value o3")
        print(loaded_test_value_o3)
        print(loaded_test_value_o3i)
        print("Computed value o3")
        print(computed_test_value_o3)
        print(computed_test_value_o3i)
        print("Loaded value o4")
        print(loaded_test_value_o4)
        print(loaded_test_value_o4i)
        print("Computed value o4")
        print(computed_test_value_o4)
        print(computed_test_value_o4i)
        print("Loaded value o5")
        print(loaded_test_value_o5)
        print(loaded_test_value_o5i)
        print("Computed value o5")
        print(computed_test_value_o5)
        print(computed_test_value_o5i)
    
    VHDL_memory_file.close()
    
    
def test_all_keygen_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_params):
    error_computation = False
    sidh_params = sidh_params
    for param in sidh_params:
        print("Testing SIKE key generation " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        error_computation = test_keygen_sike(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, param[4], param[2]**param[4], param[5], param[3]**param[5], param[24], param[25], param[6], param[7], param[8], param[9], param[10], param[11], param[12], param[13], param[14], param[15], param[16], param[17], param[18], param[21], param[19], param[22], param[20], param[23], number_of_tests)
        if error_computation:
            break;

def print_all_keygen_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_params, VHDL_file_names):
    sidh_params = sidh_params
    VHDL_file_names = VHDL_file_names
    for i, param in enumerate(sidh_params):
        print("Printing SIKE key generation " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        VHDL_memory_file_name = VHDL_file_names[i]
        tests_working_folder + "keygen_sike_" + str(param[4]) + "_" + str(param[5]) + ".dat"
        print_VHDL_keygen_sike_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, param[4], param[2]**param[4], param[5], param[3]**param[5], param[24], param[25], param[6], param[7], param[8], param[9], param[10], param[11], param[12], param[13], param[14], param[15], param[16], param[17], param[18], param[21], param[19], param[22], param[20], param[23], number_of_tests)

def load_all_keygen_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_params, VHDL_file_names):
    error_computation = False
    sidh_params = sidh_params
    VHDL_file_names = VHDL_file_names
    for i, param in enumerate(sidh_params):
        print("Loading SIKE key generation " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        VHDL_memory_file_name = VHDL_file_names[i]
        error_computation = load_VHDL_keygen_sike_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        if error_computation:
            break;

number_of_bits_added = 16
base_word_size = 16
extended_word_size = 256
accumulator_word_size = extended_word_size*2+32
number_of_tests = 10
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sike_tests_v256/"


#number_of_bits_added = 16
#base_word_size = 16
#extended_word_size = 128
#accumulator_word_size = extended_word_size*2+32
#number_of_tests = 10
#tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sike_tests_v128/"

VHDL_file_names = [tests_working_folder + "keygen_sike_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]

#test_all_keygen_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
#print_all_keygen_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
#load_all_keygen_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)

#i = 0
#param = sidh_constants[i]
#prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
#prime_size_bits = int(prime).bit_length()
#VHDL_memory_file_name = VHDL_file_names[i]
#error_computation = load_VHDL_keygen_sike_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, 2, True)
