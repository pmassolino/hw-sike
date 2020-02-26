proof.arithmetic(False)
home_folder = "/home/pedro/"
script_working_folder = home_folder + "hw-sidh/vhdl_project/sage/"
load(script_working_folder+"base_tests_for_sidh_basic_procedures/all_sidh_basic_procedures.sage")

def test_single_ladder_3_pt(arithmetic_parameters, fp2, test_value_m, test_value_m_bits, test_value_xp, test_value_xpi, test_value_xq, test_value_xqi, test_value_xpq, test_value_xpqi, test_value_a, test_value_ai):
    prime = arithmetic_parameters[3]
    
    test_value_xp_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_xp)
    test_value_xpi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xpi)
    test_value_xq_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_xq)
    test_value_xqi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xqi)
    test_value_xpq_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xpq)
    test_value_xpqi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_xpqi)
    test_value_a_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_a)
    test_value_ai_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_ai)
    
    inv_4 = (fp2(4)^(-1)).polynomial()[0]
    inv_4_mont = enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    
    test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = ladder_3_pt(arithmetic_parameters, test_value_m, test_value_m_bits, test_value_xp_mont, test_value_xpi_mont, test_value_xq_mont, test_value_xqi_mont, test_value_xpq_mont, test_value_xpqi_mont, test_value_a_mont, test_value_ai_mont, inv_4_mont)
    
    test_value_o1 = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
    test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
    test_value_o2 = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
    test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
    test_value_final_r1 = [test_value_o1, test_value_o1i]
    test_value_final_z1 = [test_value_o2, test_value_o2i]
    
    true_value_final = sage_ladder_3_pt(fp2, test_value_m, test_value_m_bits, test_value_xp, test_value_xpi, test_value_xq, test_value_xqi, test_value_xpq, test_value_xpqi, test_value_a, test_value_ai, inv_4)
    
    true_value_final_r1 = true_value_final[0:2]
    true_value_final_z1 = true_value_final[2:4]
    
    if((test_value_final_r1[0] != true_value_final_r1[0]) or (test_value_final_r1[1] != true_value_final_r1[1]) or (test_value_final_z1[0] != true_value_final_z1[0]) or (test_value_final_z1[1] != true_value_final_z1[1])):
        print("Error during the ladder 3 points procedure ")
        print('')
        print("Prime")
        print(prime)
        print('')
        print("Value m")
        print(test_value_m)
        print("Value xp")
        print(test_value_xp)
        print(test_value_xpi)
        print("Value xq")
        print(test_value_xq)
        print(test_value_xqi)
        print("Value xpq")
        print(test_value_xpq)
        print(test_value_xpqi)
        print("Value a")
        print(test_value_a)
        print(test_value_ai)
        print('')
        print("Test r1")
        print(test_value_final_r1)
        print('')
        print("True r1")
        print(true_value_final_r1)
        print('')
        print("Test z1")
        print(test_value_final_z1)
        print('')
        print("True z1")
        print(true_value_final_z1)
        print('')
        return True

    return False
    
def test_ladder_3_pt(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, test_value_m_bits, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
        
    # Maximum tests
    max_value = prime
    maximum_tests = [1, max_value - 1]
    max_exponent_value = 2**test_value_m_bits
    maximum_exponent = [max_exponent_value-1]
    maximum_tests_input = []
    for test_value_m in maximum_exponent:
        for test_value_xp in maximum_tests:
            for test_value_xpi in maximum_tests:
                for test_value_xq in maximum_tests:
                    for test_value_xqi in maximum_tests:
                        for test_value_xpq in maximum_tests:
                            for test_value_xpqi in maximum_tests:
                                for test_value_a in maximum_tests:
                                    for test_value_ai in maximum_tests:
                                        maximum_tests_input += [[test_value_m, test_value_xp, test_value_xpi, test_value_xq, test_value_xqi, test_value_xpq, test_value_xpqi, test_value_a, test_value_ai]]
    for test in maximum_tests_input:
        error_computation = test_single_ladder_3_pt(arithmetic_parameters, fp2, test[0], test_value_m_bits, test[1], test[2], test[3], test[4], test[5], test[6], test[7], test[8])
        if(error_computation):
            break
    # Random tests
    if(not error_computation):
        for i in range(number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_m  = randint(1, max_exponent_value-1)
            test_value_xp  = randint(1, max_value-1)
            test_value_xpi = randint(1, max_value-1)
            test_value_xq  = randint(1, max_value-1)
            test_value_xqi = randint(1, max_value-1)
            test_value_xpq  = randint(1, max_value-1)
            test_value_xpqi = randint(1, max_value-1)
            test_value_a  = randint(1, max_value-1)
            test_value_ai = randint(1, max_value-1)
            
            error_computation = test_single_ladder_3_pt(arithmetic_parameters, fp2, test_value_m, test_value_m_bits, test_value_xp, test_value_xpi, test_value_xq, test_value_xqi, test_value_xpq, test_value_xpqi, test_value_a, test_value_ai)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_ladder_3_pt_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, test_value_m_bits, number_of_tests):
    
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
    
    VHDL_memory_file.write((("{0:0d}").format(number_of_tests)))
    VHDL_memory_file.write('\n')
    
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_plus_one_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_line_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, r_mod_prime_constant_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, r2_constant_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, constant_1, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, inv_4_mont_list, maximum_number_of_words)
    
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, prime_size_bits, False)
    
    # Maximum tests
    max_value = prime
    maximum_tests = [1, max_value - 1]
    max_exponent_value = 2**test_value_m_bits
    maximum_exponent = [max_exponent_value-1]
    maximum_tests_input = []
    for test_value_m in maximum_exponent:
        for test_value_xp in maximum_tests:
            for test_value_xpi in maximum_tests:
                for test_value_xq in maximum_tests:
                    for test_value_xqi in maximum_tests:
                        for test_value_xpq in maximum_tests:
                            for test_value_xpqi in maximum_tests:
                                for test_value_a in maximum_tests:
                                    for test_value_ai in maximum_tests:
                                        maximum_tests_input += [[test_value_m, test_value_xp, test_value_xpi, test_value_xq, test_value_xqi, test_value_xpq, test_value_xpqi, test_value_a, test_value_ai]]
    for test in maximum_tests_input:
        
        test_value_m_list = integer_to_list(extended_word_size_signed, number_of_words, test[0])
        test_value_m_bits_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_m_bits)
        test_value_xp_list = integer_to_list(extended_word_size_signed, number_of_words, test[1])
        test_value_xpi_list = integer_to_list(extended_word_size_signed, number_of_words, test[2])
        test_value_xq_list = integer_to_list(extended_word_size_signed, number_of_words, test[3])
        test_value_xqi_list = integer_to_list(extended_word_size_signed, number_of_words, test[4])
        test_value_xpq_list = integer_to_list(extended_word_size_signed, number_of_words, test[5])
        test_value_xpqi_list = integer_to_list(extended_word_size_signed, number_of_words, test[6])
        test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test[7])
        test_value_ai_list = integer_to_list(extended_word_size_signed, number_of_words, test[8])
        
        test_value_xp_mont   = enter_montgomery_domain(arithmetic_parameters, test[1])
        test_value_xpi_mont  = enter_montgomery_domain(arithmetic_parameters, test[2])
        test_value_xq_mont   = enter_montgomery_domain(arithmetic_parameters, test[3])
        test_value_xqi_mont  = enter_montgomery_domain(arithmetic_parameters, test[4])
        test_value_xpq_mont  = enter_montgomery_domain(arithmetic_parameters, test[5])
        test_value_xpqi_mont = enter_montgomery_domain(arithmetic_parameters, test[6])
        test_value_a_mont    = enter_montgomery_domain(arithmetic_parameters, test[7])
        test_value_ai_mont   = enter_montgomery_domain(arithmetic_parameters, test[8])
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = ladder_3_pt(arithmetic_parameters, test[0], test_value_m_bits, test_value_xp_mont, test_value_xpi_mont, test_value_xq_mont, test_value_xqi_mont, test_value_xpq_mont, test_value_xpqi_mont, test_value_a_mont, test_value_ai_mont, inv_4_mont)
            
        test_value_final_o1 = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_final_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_final_o2 = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_final_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        
        test_value_o1_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_final_o1))
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_final_o1i))
        test_value_o2_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_final_o2))
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_final_o2i))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_m_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_m_bits_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xp_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xpi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xq_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xqi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xpq_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xpqi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_ai_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        
        test_value_m = randint(1, max_exponent_value-1)
        test_value_xp = randint(1, max_value-1)
        test_value_xpi = randint(1, max_value-1)
        test_value_xq = randint(1, max_value-1)
        test_value_xqi = randint(1, max_value-1)
        test_value_xpq = randint(1, max_value-1)
        test_value_xpqi = randint(1, max_value-1)
        test_value_a = randint(1, max_value-1)
        test_value_ai = randint(1, max_value-1)
        
        test_value_m_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_m)
        test_value_m_bits_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_m_bits)
        test_value_xp_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_xp)
        test_value_xpi_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_xpi)
        test_value_xq_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_xq)
        test_value_xqi_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_xqi)
        test_value_xpq_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_xpq)
        test_value_xpqi_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_xpqi)
        test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        test_value_ai_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_ai)
        
        test_value_xp_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_xp)
        test_value_xpi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xpi)
        test_value_xq_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_xq)
        test_value_xqi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xqi)
        test_value_xpq_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xpq)
        test_value_xpqi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_xpqi)
        test_value_a_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_a)
        test_value_ai_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_ai)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = ladder_3_pt(arithmetic_parameters, test_value_m, test_value_m_bits, test_value_xp_mont, test_value_xpi_mont, test_value_xq_mont, test_value_xqi_mont, test_value_xpq_mont, test_value_xpqi_mont, test_value_a_mont, test_value_ai_mont, inv_4_mont)
            
        test_value_final_o1 = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_final_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_final_o2 = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_final_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        
        test_value_o1_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_final_o1)
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_final_o1i)
        test_value_o2_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_final_o2)
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_final_o2i)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_m_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_m_bits_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xp_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xpi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xq_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xqi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xpq_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xpqi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_ai_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    VHDL_memory_file.close()
    
def load_VHDL_ladder_3_pt_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
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
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size_signed
    
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
    
    inv_4 = (fp2(4)^(-1)).polynomial()[0]
    inv_4_mont = enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    inv_4_mont_list = integer_to_list(extended_word_size_signed, number_of_words, inv_4_mont)
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
    loaded_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime != prime):
        print("Error in ladder 3 point computation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error in ladder 3 point computation : " + str(current_test))
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error in ladder 3 point computation : " + str(current_test))
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r_mod_prime != r_mod_prime_constant):
        print("Error in ladder 3 point computation : " + str(current_test))
        print("Error loading the r")
        print("Loaded r")
        print(loaded_r_mod_prime)
        print("Input r")
        print(r_mod_prime_constant)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r2 != r2_constant):
        print("Error in ladder 3 point computation : " + str(current_test))
        print("Error loading the r2")
        print("Loaded r2")
        print(loaded_r2)
        print("Input r2")
        print(r2_constant)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_1 != 1):
        print("Error in ladder 3 point computation : " + str(current_test))
        print("Error loading the constant 1")
        print("Loaded constant 1")
        print(loaded_constant_1)
        print("Input constant 1")
        print(1)
    loaded_inv_4_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_inv_4_mont != inv_4_mont):
        print("Error in ladder 3 point computation : " + str(current_test))
        print("Error loading inversion 4")
        print("Loaded inversion 4")
        print(loaded_inv_4_mont)
        print("Input inversion 4")
        print(inv_4_mont)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in ladder 3 point computation : " + str(current_test))
        print("Error loading prime size in bits")
        print("Loaded prime size in bits")
        print(loaded_prime_size_bits)
        print("Input prime size in bits")
        print(prime_size_bits)
        
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    while(current_test != (number_of_tests-1)):
        test_value_m          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_m_bits     = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_xp         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_xpi        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_xq         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_xqi        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_xpq        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_xpqi       = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_a          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_ai         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        test_value_xp_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_xp)
        test_value_xpi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xpi)
        test_value_xq_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_xq)
        test_value_xqi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xqi)
        test_value_xpq_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xpq)
        test_value_xpqi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_xpqi)
        test_value_a_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_a)
        test_value_ai_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_ai)
        
        
        computed_test_value_o1_mont, computed_test_value_o1i_mont, computed_test_value_o2_mont, computed_test_value_o2i_mont = ladder_3_pt(arithmetic_parameters, test_value_m, test_value_m_bits, test_value_xp_mont, test_value_xpi_mont, test_value_xq_mont, test_value_xqi_mont, test_value_xpq_mont, test_value_xpqi_mont, test_value_a_mont, test_value_ai_mont, inv_4_mont)
        
        computed_test_value_final_o1 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1_mont)
        computed_test_value_final_o1i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1i_mont)
        computed_test_value_final_o2 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2_mont)
        computed_test_value_final_o2i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2i_mont)
        
        if((computed_test_value_final_o1 != loaded_test_value_o1) or (computed_test_value_final_o1i != loaded_test_value_o1i) or (computed_test_value_final_o2 != loaded_test_value_o2) or (computed_test_value_final_o2i != loaded_test_value_o2i)):
            print("Error in ladder 3 point computation : " + str(current_test))
            print("Loaded value m")
            print(test_value_m)
            print(test_value_m_bits)
            print("Loaded value XP")
            print(test_value_xp)
            print(test_value_xpi)
            print("Loaded value XQ")
            print(test_value_xq)
            print(test_value_xqi)
            print("Loaded value XPQ")
            print(test_value_xpq)
            print(test_value_xpqi)
            print("Loaded value a")
            print(test_value_a)
            print(test_value_ai)
            print("Loaded value o1")
            print(loaded_test_value_o1)
            print(loaded_test_value_o1i)
            print("Computed value o1")
            print(computed_test_value_final_o1)
            print(computed_test_value_final_o1i)
            print("Loaded value o2")
            print(loaded_test_value_o2)
            print(loaded_test_value_o2i)
            print("Computed value o2")
            print(computed_test_value_final_o2)
            print(computed_test_value_final_o2i)
        current_test += 1
    
    test_value_m          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_m_bits     = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xp         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpi        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xq         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqi        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpq        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpqi       = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_a          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_ai         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    test_value_xp_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_xp)
    test_value_xpi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xpi)
    test_value_xq_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_xq)
    test_value_xqi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xqi)
    test_value_xpq_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xpq)
    test_value_xpqi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_xpqi)
    test_value_a_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_a)
    test_value_ai_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_ai)
    
    computed_test_value_o1_mont, computed_test_value_o1i_mont, computed_test_value_o2_mont, computed_test_value_o2i_mont = ladder_3_pt(arithmetic_parameters, test_value_m, test_value_m_bits, test_value_xp_mont, test_value_xpi_mont, test_value_xq_mont, test_value_xqi_mont, test_value_xpq_mont, test_value_xpqi_mont, test_value_a_mont, test_value_ai_mont, inv_4_mont)
        
    computed_test_value_final_o1 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1_mont)
    computed_test_value_final_o1i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1i_mont)
    computed_test_value_final_o2 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2_mont)
    computed_test_value_final_o2i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2i_mont)
    
        
    if(debug_mode or ((computed_test_value_final_o1 != loaded_test_value_o1) or (computed_test_value_final_o1i != loaded_test_value_o1i) or (computed_test_value_final_o2 != loaded_test_value_o2) or (computed_test_value_final_o2i != loaded_test_value_o2i))):
        print("Error in ladder 3 point computation : " + str(current_test))
        print("Loaded value m")
        print(test_value_m)
        print(test_value_m_bits)
        print("Loaded value XP")
        print(test_value_xp)
        print(test_value_xpi)
        print("Loaded value XQ")
        print(test_value_xq)
        print(test_value_xqi)
        print("Loaded value XPQ")
        print(test_value_xpq)
        print(test_value_xpqi)
        print("Loaded value a")
        print(test_value_a)
        print(test_value_ai)
        print("Loaded value o1")
        print(loaded_test_value_o1)
        print(loaded_test_value_o1i)
        print("Computed value o1")
        print(computed_test_value_final_o1)
        print(computed_test_value_final_o1i)
        print("Loaded value o2")
        print(loaded_test_value_o2)
        print(loaded_test_value_o2i)
        print("Computed value o2")
        print(computed_test_value_final_o2)
        print(computed_test_value_final_o2i)
    
    VHDL_memory_file.close()
    
def test_all_ladder_3_pt(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, oas, obs, number_of_tests):
    error_computation = False
    for i in range(len(primes)):
        prime = primes[i]
        oa_bits = int(oas[i]-1).bit_length()
        ob_bits = int(obs[i]-1).bit_length()
        print("Testing prime : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        error_computation = test_ladder_3_pt(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, oa_bits, number_of_tests//2)
        error_computation = test_ladder_3_pt(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, ob_bits-1, number_of_tests//2)
        if(error_computation):
            break
        
def print_all_VHDL_ladder_3_pt_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, oas, obs, VHDL_file_names, number_of_tests):
    for i in range(len(primes)):
        prime = primes[i]
        oa_bits = int(oas[i]-1).bit_length()
        ob_bits = int(obs[i]-1).bit_length()
        VHDL_file_name = VHDL_file_names[i]
        print("Printing prime : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        print_VHDL_ladder_3_pt_test(VHDL_file_name+"_oa_bits.dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, oa_bits, number_of_tests)
        print_VHDL_ladder_3_pt_test(VHDL_file_name+"_ob_bits.dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, ob_bits-1, number_of_tests)

def load_all_VHDL_ladder_3_pt_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_file_names):
    for i in range(len(primes)):
        prime = primes[i]
        VHDL_file_name = VHDL_file_names[i]
        print("Loading prime test of : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        load_VHDL_ladder_3_pt_test(VHDL_file_name+"_oa_bits.dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_ladder_3_pt_test(VHDL_file_name+"_ob_bits.dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)

number_of_bits_added = 8
base_word_size_signed = 16
extended_word_size_signed = 256
accumulator_word_size = (extended_word_size_signed - 1)*2+32
oas = [2^(4), 2^(216), 2^(250), 2^(305), 2^(372), 2^(486)]
obs = [3^(3), 3^(137), 3^(159), 3^(192), 3^(239), 3^(301)]
primes = [oas[i]*obs[i]-1 for i in range(len(oas))]
primes_file_name_end = ["4_3", "216_137", "250_159", "305_192", "372_239", "486_301"]
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sidh_tests_v257/"
VHDL_ladder_3_pt_file_names = [(tests_working_folder + "ladder_3_pt_test_" + ending) for ending in primes_file_name_end]

#test_all_ladder_3_pt(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, oas, obs, 100)
#print_all_VHDL_ladder_3_pt_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, oas, obs, VHDL_ladder_3_pt_file_names, 100)
#load_all_VHDL_ladder_3_pt_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_ladder_3_pt_file_names)