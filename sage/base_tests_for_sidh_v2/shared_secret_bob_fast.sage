proof.arithmetic(False)
if 'script_working_folder' not in globals() and 'script_working_folder' not in locals():
    script_working_folder = "/home/pedro/hw-sidh/vhdl_project/sage/"
load(script_working_folder+"base_tests_for_sidh_v2/all_sidh_functions.sage")
load(script_working_folder+"base_tests_for_sidh_v2/sidh_constants.sage")

def test_single_shared_secret_bob_fast(arithmetic_parameters, fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_alice, oa_bits, sk_bob, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice,  max_int_points_bob, debug=False):
    prime = arithmetic_parameters[3]
    
    inv_4 = (fp2(4)^(-1)).polynomial()[0]
    inv_4_mont = enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    
    alice_phiPX, alice_phiPXi, alice_phiQX, alice_phiQXi, alice_phiRX, alice_phiRXi = sage_keygen_alice_fast(fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_alice, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4)
    
    alice_phiPX_mont  = enter_montgomery_domain(arithmetic_parameters, int(alice_phiPX))
    alice_phiPXi_mont = enter_montgomery_domain(arithmetic_parameters, int(alice_phiPXi))
    alice_phiQX_mont  = enter_montgomery_domain(arithmetic_parameters, int(alice_phiQX))
    alice_phiQXi_mont = enter_montgomery_domain(arithmetic_parameters, int(alice_phiQXi))
    alice_phiRX_mont  = enter_montgomery_domain(arithmetic_parameters, int(alice_phiRX))
    alice_phiRXi_mont = enter_montgomery_domain(arithmetic_parameters, int(alice_phiRXi))
    
    test_value_o1_mont, test_value_o1i_mont = shared_secret_bob_fast(arithmetic_parameters, alice_phiPX_mont, alice_phiPXi_mont, alice_phiQX_mont, alice_phiQXi_mont, alice_phiRX_mont, alice_phiRXi_mont, sk_bob, ob_bits, splits_bob, max_row_bob, max_int_points_bob, inv_4_mont)
    
    test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
    test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
    test_value_j_inv  = iterative_reduction(arithmetic_parameters, test_value_o1)
    test_value_j_invi = iterative_reduction(arithmetic_parameters, test_value_o1i)
    
    true_value_j_inv, true_value_j_invi = sage_shared_secret_bob_fast(fp2, alice_phiPX, alice_phiPXi, alice_phiQX, alice_phiQXi, alice_phiRX, alice_phiRXi, sk_bob, ob_bits, splits_bob, max_row_bob, max_int_points_bob, inv_4)
    
    if((debug) or (test_value_j_inv != true_value_j_inv) or (test_value_j_invi != true_value_j_invi)):
        print("Error in shared key generation Bob ")
        print('')
        print("Prime")
        print(prime)
        print('')
        print("Value sk_alice")
        print(sk_alice)
        print("Value oa bits")
        print(oa_bits)
        print('')
        print("Value sk_bob")
        print(sk_bob)
        print("Value ob bits")
        print(ob_bits)
        print('')
        print("Test j_inv")
        print(test_value_j_inv)
        print(test_value_j_invi)
        print('')
        print("True phiPX")
        print(true_value_j_inv)
        print(true_value_j_invi)
        print('')
        return True

    return False
    
def test_shared_secret_bob_fast(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, la, oa, lb, ob, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, number_of_tests):

    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
    
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
    
    oa_bits = int(oa-1).bit_length()
    ob_bits = int(ob-1).bit_length()
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [[0, 0], [oa-1, 0], [0, ob-1], [oa-1, ob-1]]
    for test in fixed_tests:
        sk_alice = test[0]
        sk_bob = test[1]
        error_computation = test_single_shared_secret_bob_fast(arithmetic_parameters, fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_alice, oa_bits, sk_bob, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob)
        tests_already_performed += 1
        if(error_computation):
            break
            
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            sk_alice = randint(0, oa-1)
            sk_bob = randint(0, ob-1)
            error_computation = test_single_shared_secret_bob_fast(arithmetic_parameters, fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_alice, oa_bits, sk_bob, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob)
            if(error_computation):
                break
        
    return error_computation
    
def print_VHDL_shared_secret_bob_fast_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, la, oa, lb, ob, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, number_of_tests):
    
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
    prime2 = arithmetic_parameters[24]
    prime2_list = arithmetic_parameters[25]
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
    
    oa_bits = int(oa-1).bit_length()
    ob_bits = int(ob-1).bit_length()
    
    inv_4 = (fp2(4)^(-1)).polynomial()[0]
    inv_4_mont = enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    inv_4_mont_list = integer_to_list(extended_word_size_signed, number_of_words, inv_4_mont)
    
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
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime2_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, r_mod_prime_constant_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, r2_constant_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, constant_1, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, inv_4_mont_list, maximum_number_of_words)
    
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
    fixed_tests = [[0, 0], [oa-1, 0], [0, ob-1], [oa-1, ob-1]]
    for test in fixed_tests:
        sk_alice = test[0]
        sk_bob = test[1]
        
        alice_phiPX, alice_phiPXi, alice_phiQX, alice_phiQXi, alice_phiRX, alice_phiRXi = sage_keygen_alice_fast(fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_alice, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4)
    
        alice_phiPX_mont  = enter_montgomery_domain(arithmetic_parameters, int(alice_phiPX))
        alice_phiPXi_mont = enter_montgomery_domain(arithmetic_parameters, int(alice_phiPXi))
        alice_phiQX_mont  = enter_montgomery_domain(arithmetic_parameters, int(alice_phiQX))
        alice_phiQXi_mont = enter_montgomery_domain(arithmetic_parameters, int(alice_phiQXi))
        alice_phiRX_mont  = enter_montgomery_domain(arithmetic_parameters, int(alice_phiRX))
        alice_phiRXi_mont = enter_montgomery_domain(arithmetic_parameters, int(alice_phiRXi))
    
        alice_phiPX_list  = integer_to_list(extended_word_size_signed, number_of_words, alice_phiPX)
        alice_phiPXi_list = integer_to_list(extended_word_size_signed, number_of_words, alice_phiPXi)
        alice_phiQX_list  = integer_to_list(extended_word_size_signed, number_of_words, alice_phiQX)
        alice_phiQXi_list = integer_to_list(extended_word_size_signed, number_of_words, alice_phiQXi)
        alice_phiRX_list  = integer_to_list(extended_word_size_signed, number_of_words, alice_phiRX)
        alice_phiRXi_list = integer_to_list(extended_word_size_signed, number_of_words, alice_phiRXi)
        
        test_value_sk_bob_list  = integer_to_list(extended_word_size_signed, number_of_words, sk_bob)
        
        test_value_o1_mont, test_value_o1i_mont = shared_secret_bob_fast(arithmetic_parameters, alice_phiPX_mont, alice_phiPXi_mont, alice_phiQX_mont, alice_phiQXi_mont, alice_phiRX_mont, alice_phiRXi_mont, sk_bob, ob_bits, splits_bob, max_row_bob, max_int_points_bob, inv_4_mont)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        
        test_value_o1_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1))
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1i))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, alice_phiPX_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, alice_phiPXi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, alice_phiQX_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, alice_phiQXi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, alice_phiRX_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, alice_phiRXi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_sk_bob_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        sk_alice = randint(0, oa-1)
        sk_bob = randint(0, ob-1)
    
        alice_phiPX, alice_phiPXi, alice_phiQX, alice_phiQXi, alice_phiRX, alice_phiRXi = sage_keygen_alice_fast(fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_alice, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4)
    
        alice_phiPX_mont  = enter_montgomery_domain(arithmetic_parameters, int(alice_phiPX))
        alice_phiPXi_mont = enter_montgomery_domain(arithmetic_parameters, int(alice_phiPXi))
        alice_phiQX_mont  = enter_montgomery_domain(arithmetic_parameters, int(alice_phiQX))
        alice_phiQXi_mont = enter_montgomery_domain(arithmetic_parameters, int(alice_phiQXi))
        alice_phiRX_mont  = enter_montgomery_domain(arithmetic_parameters, int(alice_phiRX))
        alice_phiRXi_mont = enter_montgomery_domain(arithmetic_parameters, int(alice_phiRXi))
    
        alice_phiPX_list  = integer_to_list(extended_word_size_signed, number_of_words, alice_phiPX)
        alice_phiPXi_list = integer_to_list(extended_word_size_signed, number_of_words, alice_phiPXi)
        alice_phiQX_list  = integer_to_list(extended_word_size_signed, number_of_words, alice_phiQX)
        alice_phiQXi_list = integer_to_list(extended_word_size_signed, number_of_words, alice_phiQXi)
        alice_phiRX_list  = integer_to_list(extended_word_size_signed, number_of_words, alice_phiRX)
        alice_phiRXi_list = integer_to_list(extended_word_size_signed, number_of_words, alice_phiRXi)
        
        test_value_sk_bob_list  = integer_to_list(extended_word_size_signed, number_of_words, sk_bob)
        
        test_value_o1_mont, test_value_o1i_mont = shared_secret_bob_fast(arithmetic_parameters, alice_phiPX_mont, alice_phiPXi_mont, alice_phiQX_mont, alice_phiQXi_mont, alice_phiRX_mont, alice_phiRXi_mont, sk_bob, ob_bits, splits_bob, max_row_bob, max_int_points_bob, inv_4_mont)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        
        test_value_o1_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1))
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1i))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, alice_phiPX_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, alice_phiPXi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, alice_phiQX_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, alice_phiQXi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, alice_phiRX_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, alice_phiRXi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_sk_bob_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    VHDL_memory_file.close()
    
def load_VHDL_shared_secret_bob_fast_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
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
    prime2 = arithmetic_parameters[24]
    prime2_list = arithmetic_parameters[25]
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
        print("Error in shared secret Bob fast computation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error in shared secret Bob fast computation : " + str(current_test))
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error in shared secret Bob fast computation : " + str(current_test))
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_prime2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime2 != prime2):
        print("Error in shared secret Bob fast computation : " + str(current_test))
        print("Error loading the 2*prime")
        print("Loaded 2*prime")
        print(loaded_prime2)
        print("Input 2*prime")
        print(prime2)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r_mod_prime != r_mod_prime_constant):
        print("Error in shared secret Bob fast computation : " + str(current_test))
        print("Error loading the r")
        print("Loaded r")
        print(loaded_r_mod_prime)
        print("Input r")
        print(r_mod_prime_constant)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r2 != r2_constant):
        print("Error in shared secret Bob fast computation : " + str(current_test))
        print("Error loading the r2")
        print("Loaded r2")
        print(loaded_r2)
        print("Input r2")
        print(r2_constant)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_1 != 1):
        print("Error in shared secret Bob fast computation : " + str(current_test))
        print("Error loading the constant 1")
        print("Loaded constant 1")
        print(loaded_constant_1)
        print("Input constant 1")
        print(1)
    loaded_constant_inv_4 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_inv_4 != inv_4_mont):
        print("Error in shared secret Bob fast computation : " + str(current_test))
        print("Error loading the inversion 4")
        print("Loaded inversion 4")
        print(loaded_constant_inv_4)
        print("Input inversion 4")
        print(inv_4_mont)
    loaded_oa_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_ob_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in shared secret Bob fast computation : " + str(current_test))
        print("Error loading prime size in bits")
        print("Loaded prime size in bits")
        print(loaded_prime_size_bits)
        print("Input prime size in bits")
        print(prime_size_bits)
    
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    loaded_splits_alice   = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, 302, False)
    loaded_splits_bob   = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, 302, False)
    loaded_max_row_alice  = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_max_row_bob  = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    
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
    
        test_value_alice_phiPX  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_alice_phiPXi = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_alice_phiQX  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_alice_phiQXi = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_alice_phiRX  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_alice_phiRXi = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        test_value_alice_phiPX_mont  = enter_montgomery_domain(arithmetic_parameters, int(test_value_alice_phiPX))
        test_value_alice_phiPXi_mont = enter_montgomery_domain(arithmetic_parameters, int(test_value_alice_phiPXi))
        test_value_alice_phiQX_mont  = enter_montgomery_domain(arithmetic_parameters, int(test_value_alice_phiQX))
        test_value_alice_phiQXi_mont = enter_montgomery_domain(arithmetic_parameters, int(test_value_alice_phiQXi))
        test_value_alice_phiRX_mont  = enter_montgomery_domain(arithmetic_parameters, int(test_value_alice_phiRX))
        test_value_alice_phiRXi_mont = enter_montgomery_domain(arithmetic_parameters, int(test_value_alice_phiRXi))
        
        loaded_sk             = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        computed_test_value_o1_mont, computed_test_value_o1i_mont = shared_secret_bob_fast(arithmetic_parameters, test_value_alice_phiPX_mont, test_value_alice_phiPXi_mont, test_value_alice_phiQX_mont, test_value_alice_phiQXi_mont, test_value_alice_phiRX_mont, test_value_alice_phiRXi_mont, loaded_sk, loaded_ob_bits, loaded_splits_bob, loaded_max_row_bob, 12, loaded_constant_inv_4)
        
        computed_test_value_o1 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1_mont)
        computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1i_mont)
        
        if((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i)):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print("Loaded sk")
            print(loaded_sk)
            print("Loaded alice phiPX")
            print(test_value_alice_phiPX_mont)
            print(test_value_alice_phiPXi_mont)
            print("Loaded alice phiQX")
            print(test_value_alice_phiQX_mont)
            print(test_value_alice_phiQXi_mont)
            print("Loaded alice phiRX")
            print(test_value_alice_phiRX_mont)
            print(test_value_alice_phiRXi_mont)
            print("Loaded value o1")
            print(loaded_test_value_o1)
            print(loaded_test_value_o1i)
            print("Computed value o1")
            print(computed_test_value_o1)
            print(computed_test_value_o1i)
        current_test += 1
    
    test_value_alice_phiPX  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_alice_phiPXi = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_alice_phiQX  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_alice_phiQXi = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_alice_phiRX  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_alice_phiRXi = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    test_value_alice_phiPX_mont  = enter_montgomery_domain(arithmetic_parameters, int(test_value_alice_phiPX))
    test_value_alice_phiPXi_mont = enter_montgomery_domain(arithmetic_parameters, int(test_value_alice_phiPXi))
    test_value_alice_phiQX_mont  = enter_montgomery_domain(arithmetic_parameters, int(test_value_alice_phiQX))
    test_value_alice_phiQXi_mont = enter_montgomery_domain(arithmetic_parameters, int(test_value_alice_phiQXi))
    test_value_alice_phiRX_mont  = enter_montgomery_domain(arithmetic_parameters, int(test_value_alice_phiRX))
    test_value_alice_phiRXi_mont = enter_montgomery_domain(arithmetic_parameters, int(test_value_alice_phiRXi))
    
    loaded_sk             = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    computed_test_value_o1_mont, computed_test_value_o1i_mont = shared_secret_bob_fast(arithmetic_parameters, test_value_alice_phiPX_mont, test_value_alice_phiPXi_mont, test_value_alice_phiQX_mont, test_value_alice_phiQXi_mont, test_value_alice_phiRX_mont, test_value_alice_phiRXi_mont, loaded_sk, loaded_ob_bits, loaded_splits_bob, loaded_max_row_bob, 12, loaded_constant_inv_4)
    
    computed_test_value_o1 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1_mont)
    computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1i_mont)
        
    if(debug_mode or ((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i))):
        print("Error in shared secret Bob fast computation : " + str(current_test))
        print("Loaded sk")
        print(loaded_sk)
        print("Loaded alice phiPX")
        print(test_value_alice_phiPX_mont)
        print(test_value_alice_phiPXi_mont)
        print("Loaded alice phiQX")
        print(test_value_alice_phiQX_mont)
        print(test_value_alice_phiQXi_mont)
        print("Loaded alice phiRX")
        print(test_value_alice_phiRX_mont)
        print(test_value_alice_phiRXi_mont)
        print("Loaded value o1")
        print(loaded_test_value_o1)
        print(loaded_test_value_o1i)
        print("Computed value o1")
        print(computed_test_value_o1)
        print(computed_test_value_o1i)
    
    VHDL_memory_file.close()

def test_all_shared_secret_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_params):
    error_computation = False
    for param in sidh_params:
        print("Testing Bob shared secret " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        error_computation = test_shared_secret_bob_fast(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, param[4], param[2]**param[4], param[5], param[3]**param[5], param[6], param[7], param[8], param[9], param[10], param[11], param[12], param[13], param[14], param[15], param[16], param[17],
        param[18], param[21], param[19], param[22], param[20], param[23], number_of_tests)
        if error_computation:
            break;
            
def print_all_shared_secret_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_params, VHDL_file_names):
    for i, param in enumerate(sidh_params):
        print("Printing Bob shared secret " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        VHDL_memory_file_name = VHDL_file_names[i]
        print_VHDL_shared_secret_bob_fast_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, param[4], param[2]**param[4], param[5], param[3]**param[5], param[6], param[7], param[8], param[9], param[10], param[11], param[12], param[13], param[14], param[15], param[16], param[17],
        param[18], param[21], param[19], param[22], param[20], param[23], number_of_tests)

def load_all_shared_secret_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_params, VHDL_file_names):
    error_computation = False
    for i, param in enumerate(sidh_params):
        print("Loading Bob shared secret " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        VHDL_memory_file_name = VHDL_file_names[i]
        error_computation = load_VHDL_shared_secret_bob_fast_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        if error_computation:
            break;

number_of_bits_added = 16
base_word_size = 16
extended_word_size = 256
accumulator_word_size = (extended_word_size - 1)*2+32
number_of_tests = 10
tests_working_folder = script_working_folder + "../hw_sidh_tests_v256/"

#number_of_bits_added = 16
#base_word_size = 16
#extended_word_size = 128
#accumulator_word_size = extended_word_size*2+32
#number_of_tests = 10
#tests_working_folder = script_working_folder + "../hw_sidh_tests_v128/"

VHDL_file_names = [tests_working_folder + "shared_secret_bob_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]

#test_all_shared_secret_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
#print_all_shared_secret_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
#load_all_shared_secret_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)