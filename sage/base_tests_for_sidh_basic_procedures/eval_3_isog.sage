proof.arithmetic(False)
home_folder = "/home/pedro/"
script_working_folder = home_folder + "hw-sidh/vhdl_project/sage/"
load(script_working_folder+"base_tests_for_sidh_basic_procedures/all_sidh_basic_procedures.sage")

def test_single_eval_3_isog(arithmetic_parameters, fp2, test_value_x, test_value_xi, test_value_z, test_value_zi, test_value_k1, test_value_k1i, test_value_k2, test_value_k2i):
    prime = arithmetic_parameters[3]
    
    test_value_x_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_x)
    test_value_xi_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_xi)
    test_value_z_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_z)
    test_value_zi_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_zi)
    test_value_k1_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_k1)
    test_value_k1i_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_k1i)
    test_value_k2_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_k2)
    test_value_k2i_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_k2i)
    
    test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = eval_3_isog(arithmetic_parameters, test_value_x_mont, test_value_xi_mont, test_value_z_mont, test_value_zi_mont, test_value_k1_mont, test_value_k1i_mont, test_value_k2_mont, test_value_k2i_mont)
    
    test_value_o1 = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
    test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
    test_value_o2 = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
    test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
    
    test_value_final_t0 = [test_value_o1, test_value_o1i]
    test_value_final_t1 = [test_value_o2, test_value_o2i]
    
    true_value_final = sage_eval_3_isog(fp2, test_value_x, test_value_xi, test_value_z, test_value_zi, test_value_k1, test_value_k1i, test_value_k2, test_value_k2i)
    
    true_value_final_t0 = true_value_final[0:2]
    true_value_final_t1 = true_value_final[2:4]
    
    if((test_value_final_t0[0] != true_value_final_t0[0]) or (test_value_final_t0[1] != true_value_final_t0[1]) or (test_value_final_t1[0] != true_value_final_t1[0]) or (test_value_final_t1[1] != true_value_final_t1[1])):
        print("Error during the evaluate 3 isogenies procedure ")
        print('')
        print("Prime")
        print(prime)
        print('')
        print("Value x")
        print(test_value_x)
        print(test_value_xi)
        print("Value z")
        print(test_value_z)
        print(test_value_zi)
        print("Value k1")
        print(test_value_k1)
        print(test_value_k1i)
        print("Value k2")
        print(test_value_k2)
        print(test_value_k2i)
        print('')
        print("Test t0")
        print(test_value_final_t0)
        print('')
        print("True t0")
        print(true_value_final_t0)
        print('')
        print("Test t1")
        print(test_value_final_t1)
        print('')
        print("True t1")
        print(true_value_final_t1)
        print('')
        return True
            
    return False
    
def test_eval_3_isog(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
        
    # Maximum tests
    max_value = prime
    maximum_tests = [1, max_value - 1]
    maximum_tests_input = []
    for test_value_x in maximum_tests:
        for test_value_xi in maximum_tests:
            for test_value_z in maximum_tests:
                for test_value_zi in maximum_tests:
                    for test_value_k1 in maximum_tests:
                        for test_value_k1i in maximum_tests:
                            for test_value_k2 in maximum_tests:
                                for test_value_k2i in maximum_tests:
                                    maximum_tests_input += [[test_value_x, test_value_xi, test_value_z, test_value_zi, test_value_k1, test_value_k1i, test_value_k2, test_value_k2i]]
    for test in maximum_tests_input:
        error_computation = test_single_eval_3_isog(arithmetic_parameters, fp2, test[0], test[1], test[2], test[3], test[4], test[5], test[6], test[7])
        if(error_computation):
            break
    # Random tests
    if(not error_computation):
        for i in range(number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_x   = randint(1, max_value-1)
            test_value_xi  = randint(1, max_value-1)
            test_value_z   = randint(1, max_value-1)
            test_value_zi  = randint(1, max_value-1)
            test_value_k1  = randint(1, max_value-1)
            test_value_k1i = randint(1, max_value-1)
            test_value_k2  = randint(1, max_value-1)
            test_value_k2i = randint(1, max_value-1)
            
            error_computation = test_single_eval_3_isog(arithmetic_parameters, fp2, test_value_x, test_value_xi, test_value_z, test_value_zi, test_value_k1, test_value_k1i, test_value_k2, test_value_k2i)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_eval_3_isog_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    
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
    maximum_tests_input = []
    for test_value_x in maximum_tests:
        for test_value_xi in maximum_tests:
            for test_value_z in maximum_tests:
                for test_value_zi in maximum_tests:
                    for test_value_k1 in maximum_tests:
                        for test_value_k1i in maximum_tests:
                            for test_value_k2 in maximum_tests:
                                for test_value_k2i in maximum_tests:
                                    maximum_tests_input += [[test_value_x, test_value_xi, test_value_z, test_value_zi, test_value_k1, test_value_k1i, test_value_k2, test_value_k2i]]
    for test in maximum_tests_input:
        
        test_value_x_list   = integer_to_list(extended_word_size_signed, number_of_words, test[0])
        test_value_xi_list  = integer_to_list(extended_word_size_signed, number_of_words, test[1])
        test_value_z_list   = integer_to_list(extended_word_size_signed, number_of_words, test[2])
        test_value_zi_list  = integer_to_list(extended_word_size_signed, number_of_words, test[3])
        test_value_k1_list  = integer_to_list(extended_word_size_signed, number_of_words, test[4])
        test_value_k1i_list = integer_to_list(extended_word_size_signed, number_of_words, test[5])
        test_value_k2_list  = integer_to_list(extended_word_size_signed, number_of_words, test[6])
        test_value_k2i_list = integer_to_list(extended_word_size_signed, number_of_words, test[7])
        
        test_value_x_mont    = enter_montgomery_domain(arithmetic_parameters, test[0])
        test_value_xi_mont   = enter_montgomery_domain(arithmetic_parameters, test[1])
        test_value_z_mont    = enter_montgomery_domain(arithmetic_parameters, test[2])
        test_value_zi_mont   = enter_montgomery_domain(arithmetic_parameters, test[3])
        test_value_k1_mont   = enter_montgomery_domain(arithmetic_parameters, test[4])
        test_value_k1i_mont  = enter_montgomery_domain(arithmetic_parameters, test[5])
        test_value_k2_mont   = enter_montgomery_domain(arithmetic_parameters, test[6])
        test_value_k2i_mont  = enter_montgomery_domain(arithmetic_parameters, test[7])
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = eval_3_isog(arithmetic_parameters, test_value_x_mont, test_value_xi_mont, test_value_z_mont, test_value_zi_mont, test_value_k1_mont, test_value_k1i_mont, test_value_k2_mont, test_value_k2i_mont)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        
        test_value_o1_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1))
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1i))
        test_value_o2_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2))
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2i))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_x_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_zi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_k1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_k1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_k2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_k2i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        
        test_value_x  = randint(1, max_value-1)
        test_value_xi = randint(1, max_value-1)
        test_value_z  = randint(1, max_value-1)
        test_value_zi = randint(1, max_value-1)
        test_value_k1  = randint(1, max_value-1)
        test_value_k1i = randint(1, max_value-1)
        test_value_k2  = randint(1, max_value-1)
        test_value_k2i = randint(1, max_value-1)
        
        test_value_x_list   = integer_to_list(extended_word_size_signed, number_of_words, test_value_x)
        test_value_xi_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_xi)
        test_value_z_list   = integer_to_list(extended_word_size_signed, number_of_words, test_value_z)
        test_value_zi_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_zi)
        test_value_k1_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_k1)
        test_value_k1i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_k1i)
        test_value_k2_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_k2)
        test_value_k2i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_k2i)
        
        test_value_x_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_x)
        test_value_xi_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_xi)
        test_value_z_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_z)
        test_value_zi_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_zi)
        test_value_k1_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_k1)
        test_value_k1i_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_k1i)
        test_value_k2_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_k2)
        test_value_k2i_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_k2i)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = eval_3_isog(arithmetic_parameters, test_value_x_mont, test_value_xi_mont, test_value_z_mont, test_value_zi_mont, test_value_k1_mont, test_value_k1i_mont, test_value_k2_mont, test_value_k2i_mont)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        
        test_value_o1_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1))
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1i))
        test_value_o2_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2))
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2i))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_x_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_zi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_k1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_k1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_k2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_k2i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    VHDL_memory_file.close()
    
def load_VHDL_eval_3_isog_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
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
        print("Error in eval 3 isogenies computation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error in eval 3 isogenies computation : " + str(current_test))
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error in eval 3 isogenies computation : " + str(current_test))
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r_mod_prime != r_mod_prime_constant):
        print("Error in eval 3 isogenies computation : " + str(current_test))
        print("Error loading the r")
        print("Loaded r")
        print(loaded_r_mod_prime)
        print("Input r")
        print(r_mod_prime_constant)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r2 != r2_constant):
        print("Error in eval 3 isogenies computation : " + str(current_test))
        print("Error loading the r2")
        print("Loaded r2")
        print(loaded_r2)
        print("Input r2")
        print(r2_constant)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_1 != 1):
        print("Error in eval 3 isogenies computation : " + str(current_test))
        print("Error loading the constant 1")
        print("Loaded constant 1")
        print(loaded_constant_1)
        print("Input constant 1")
        print(1)
    loaded_inv_4_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_inv_4_mont != inv_4_mont):
        print("Error in eval 3 isogenies computation : " + str(current_test))
        print("Error loading inversion 4")
        print("Loaded inversion 4")
        print(loaded_inv_4_mont)
        print("Input inversion 4")
        print(inv_4_mont)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in eval 3 isogenies computation : " + str(current_test))
        print("Error loading prime size in bits")
        print("Loaded prime size in bits")
        print(loaded_prime_size_bits)
        print("Input prime size in bits")
        print(prime_size_bits)
        
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    while(current_test != (number_of_tests-1)):
        test_value_x          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_xi         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_z          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_zi         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_k1         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_k1i        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_k2         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_k2i        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        test_value_x_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_x)
        test_value_xi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xi)
        test_value_z_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_z)
        test_value_zi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_zi)
        test_value_k1_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_k1)
        test_value_k1i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_k1i)
        test_value_k2_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_k2)
        test_value_k2i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_k2i)
        
        computed_test_value_o1_mont, computed_test_value_o1i_mont, computed_test_value_o2_mont, computed_test_value_o2i_mont = eval_3_isog(arithmetic_parameters, test_value_x_mont, test_value_xi_mont, test_value_z_mont, test_value_zi_mont, test_value_k1_mont, test_value_k1i_mont, test_value_k2_mont, test_value_k2i_mont)
        
        computed_test_value_o1 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1_mont)
        computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1i_mont)
        computed_test_value_o2 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2_mont)
        computed_test_value_o2i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2i_mont)
        
        if((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i)):
            print("Error in eval 3 isogenies computation : " + str(current_test))
            print("Loaded value x")
            print(test_value_x)
            print(test_value_xi)
            print("Loaded value z")
            print(test_value_z)
            print(test_value_zi)
            print("Loaded value k1")
            print(test_value_k1)
            print(test_value_k1i)
            print("Loaded value k2")
            print(test_value_k2)
            print(test_value_k2i)
            print("Loaded value o1")
            print(loaded_test_value_o1)
            print(loaded_test_value_o1i)
            print("Computed value o1")
            print(computed_test_value_o1)
            print(computed_test_value_o1i)
            print("Loaded value o2")
            print(loaded_test_value_o2)
            print(loaded_test_value_o2i)
            print("Computed value o2")
            print(computed_test_value_o2)
            print(computed_test_value_o2i)
        current_test += 1
    
    test_value_x          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xi         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_z          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_zi         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_k1         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_k1i        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_k2         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_k2i        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    test_value_x_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_x)
    test_value_xi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_xi)
    test_value_z_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_z)
    test_value_zi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_zi)
    test_value_k1_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_k1)
    test_value_k1i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_k1i)
    test_value_k2_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_k2)
    test_value_k2i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_k2i)
    
    computed_test_value_o1_mont, computed_test_value_o1i_mont, computed_test_value_o2_mont, computed_test_value_o2i_mont = eval_3_isog(arithmetic_parameters, test_value_x_mont, test_value_xi_mont, test_value_z_mont, test_value_zi_mont, test_value_k1_mont, test_value_k1i_mont, test_value_k2_mont, test_value_k2i_mont)
    
    computed_test_value_o1 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1_mont)
    computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1i_mont)
    computed_test_value_o2 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2_mont)
    computed_test_value_o2i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2i_mont)
        
    if(debug_mode or ((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i))):
        print("Error in eval 3 isogenies computation : " + str(current_test))
        print("Loaded value x")
        print(test_value_x)
        print(test_value_xi)
        print("Loaded value z")
        print(test_value_z)
        print(test_value_zi)
        print("Loaded value k1")
        print(test_value_k1)
        print(test_value_k1i)
        print("Loaded value k2")
        print(test_value_k2)
        print(test_value_k2i)
        print("Loaded value o1")
        print(loaded_test_value_o1)
        print(loaded_test_value_o1i)
        print("Computed value o1")
        print(computed_test_value_o1)
        print(computed_test_value_o1i)
        print("Loaded value o2")
        print(loaded_test_value_o2)
        print(loaded_test_value_o2i)
        print("Computed value o2")
        print(computed_test_value_o2)
        print(computed_test_value_o2i)
    
    VHDL_memory_file.close()
    
def test_all_eval_3_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, number_of_tests):
    error_computation = False
    for i in range(len(primes)):
        prime = primes[i]
        print("Testing prime : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        error_computation = test_eval_3_isog(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests)
        if(error_computation):
            break
        
def print_all_VHDL_eval_3_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_file_names, number_of_tests):
    for i in range(len(primes)):
        prime = primes[i]
        VHDL_file_name = VHDL_file_names[i]
        print("Printing prime : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        print_VHDL_eval_3_isog_test(VHDL_file_name, base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests)

def load_all_VHDL_eval_3_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_file_names):
    for i in range(len(primes)):
        prime = primes[i]
        VHDL_file_name = VHDL_file_names[i]
        print("Loading prime test of : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        load_VHDL_eval_3_isog_test(VHDL_file_name, base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        
        
number_of_bits_added = 16
base_word_size_signed = 16
extended_word_size_signed = 256
accumulator_word_size = (extended_word_size_signed - 1)*2+32
primes = [2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1, 2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
primes_file_name_end = ["8_5.dat", "216_137.dat", "250_159.dat", "305_192.dat", "372_239.dat", "486_301.dat"]
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sidh_tests_v256/"
VHDL_eval_3_isog_file_names = [(tests_working_folder + "eval_3_isog_test_" + ending) for ending in primes_file_name_end]

#test_all_eval_3_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
#print_all_VHDL_eval_3_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_3_isog_file_names, 100)
#load_all_VHDL_eval_3_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_3_isog_file_names)