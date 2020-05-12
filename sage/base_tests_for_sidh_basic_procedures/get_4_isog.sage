proof.arithmetic(False)
if 'script_working_folder' not in globals() and 'script_working_folder' not in locals():
    script_working_folder = "/home/pedro/hw-sidh/vhdl_project/sage/"
load(script_working_folder+"base_tests_for_sidh_basic_procedures/all_sidh_basic_procedures.sage")

def test_single_get_4_isog(arithmetic_parameters, fp2, test_value_x4, test_value_x4i, test_value_z4, test_value_z4i):
    prime = arithmetic_parameters[3]
    
    test_value_x4_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_x4)
    test_value_x4i_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_x4i)
    test_value_z4_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_z4)
    test_value_z4i_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_z4i)
    
    test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont, test_value_o3_mont, test_value_o3i_mont, test_value_o4_mont, test_value_o4i_mont, test_value_o5_mont, test_value_o5i_mont = get_4_isog(arithmetic_parameters, test_value_x4_mont, test_value_x4i_mont, test_value_z4_mont, test_value_z4i_mont)
    
    test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
    test_value_o1  = iterative_reduction(arithmetic_parameters, test_value_o1)
    test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
    test_value_o1i = iterative_reduction(arithmetic_parameters, test_value_o1i)
    test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
    test_value_o2  = iterative_reduction(arithmetic_parameters, test_value_o2)
    test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
    test_value_o2i = iterative_reduction(arithmetic_parameters, test_value_o2i)
    test_value_o3  = remove_montgomery_domain(arithmetic_parameters, test_value_o3_mont)
    test_value_o3  = iterative_reduction(arithmetic_parameters, test_value_o3)
    test_value_o3i = remove_montgomery_domain(arithmetic_parameters, test_value_o3i_mont)
    test_value_o3i = iterative_reduction(arithmetic_parameters, test_value_o3i)
    test_value_o4  = remove_montgomery_domain(arithmetic_parameters, test_value_o4_mont)
    test_value_o4  = iterative_reduction(arithmetic_parameters, test_value_o4)
    test_value_o4i = remove_montgomery_domain(arithmetic_parameters, test_value_o4i_mont)
    test_value_o4i = iterative_reduction(arithmetic_parameters, test_value_o4i)
    test_value_o5  = remove_montgomery_domain(arithmetic_parameters, test_value_o5_mont)
    test_value_o5  = iterative_reduction(arithmetic_parameters, test_value_o5)
    test_value_o5i = remove_montgomery_domain(arithmetic_parameters, test_value_o5i_mont)
    test_value_o5i = iterative_reduction(arithmetic_parameters, test_value_o5i)
    test_value_final_t2 = [test_value_o1, test_value_o1i]
    test_value_final_t3 = [test_value_o2, test_value_o2i]
    test_value_final_t4 = [test_value_o3, test_value_o3i]
    test_value_final_t0 = [test_value_o4, test_value_o4i]
    test_value_final_t1 = [test_value_o5, test_value_o5i]
    
    true_value_final = sage_get_4_isog(fp2, test_value_x4, test_value_x4i, test_value_z4, test_value_z4i)
    
    true_value_final_t2 = true_value_final[0:2]
    true_value_final_t3 = true_value_final[2:4]
    true_value_final_t4 = true_value_final[4:6]
    true_value_final_t0 = true_value_final[6:8]
    true_value_final_t1 = true_value_final[8:10]
    
    if((test_value_final_t2[0] != true_value_final_t2[0]) or (test_value_final_t2[1] != true_value_final_t2[1]) or (test_value_final_t3[0] != true_value_final_t3[0]) or (test_value_final_t3[1] != true_value_final_t3[1]) or (test_value_final_t4[0] != true_value_final_t4[0]) or (test_value_final_t4[1] != true_value_final_t4[1]) or (test_value_final_t0[0] != true_value_final_t0[0]) or (test_value_final_t0[1] != true_value_final_t0[1]) or (test_value_final_t1[0] != true_value_final_t1[0]) or (test_value_final_t1[1] != true_value_final_t1[1])):
        print("Error during the get 4 isogenies procedure ")
        print('')
        print("Prime")
        print(prime)
        print('')
        print("Value x4")
        print(test_value_x4)
        print(test_value_x4i)
        print("Value z4")
        print(test_value_z4)
        print(test_value_z4i)
        print('')
        print("Test t2")
        print(test_value_final_t2)
        print('')
        print("True t2")
        print(true_value_final_t2)
        print('')
        print("Test t3")
        print(test_value_final_t3)
        print('')
        print("True t3")
        print(true_value_final_t3)
        print('')
        print("Test t4")
        print(test_value_final_t4)
        print('')
        print("True t4")
        print(true_value_final_t4)
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
    
def test_get_4_isog(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
        
    # Maximum tests
    max_value = prime
    maximum_tests = [1, max_value - 1]
    maximum_tests_input = []
    for test_value_x4 in maximum_tests:
        for test_value_x4i in maximum_tests:
            for test_value_z4 in maximum_tests:
                for test_value_z4i in maximum_tests:
                    maximum_tests_input += [[test_value_x4, test_value_x4i, test_value_z4, test_value_z4i]]
    for test in maximum_tests_input:
        error_computation = test_single_get_4_isog(arithmetic_parameters, fp2, test[0], test[1], test[2], test[3])
        if(error_computation):
            break
    # Random tests
    if(not error_computation):
        for i in range(number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_x4   = randint(1, max_value-1)
            test_value_x4i  = randint(1, max_value-1)
            test_value_z4   = randint(1, max_value-1)
            test_value_z4i  = randint(1, max_value-1)
            
            error_computation = test_single_get_4_isog(arithmetic_parameters, fp2, test_value_x4, test_value_x4i, test_value_z4, test_value_z4i)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_get_4_isog_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    
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
    
    inv_4 = (fp2(4)^(-1)).polynomial()[0]
    inv_4_mont = enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    inv_4_mont_list = integer_to_list(extended_word_size_signed, number_of_words, inv_4_mont)
    
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
    
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, prime_size_bits, False)
    
    # Maximum tests
    max_value = prime
    maximum_tests = [1, max_value - 1]
    maximum_tests_input = []
    for test_value_x4 in maximum_tests:
        for test_value_x4i in maximum_tests:
            for test_value_z4 in maximum_tests:
                for test_value_z4i in maximum_tests:
                    maximum_tests_input += [[test_value_x4, test_value_x4i, test_value_z4, test_value_z4i]]
    for test in maximum_tests_input:
        
        test_value_x4_list = integer_to_list(extended_word_size_signed, number_of_words, test[0])
        test_value_x4i_list = integer_to_list(extended_word_size_signed, number_of_words, test[1])
        test_value_z4_list = integer_to_list(extended_word_size_signed, number_of_words, test[2])
        test_value_z4i_list = integer_to_list(extended_word_size_signed, number_of_words, test[3])
        
        test_value_x4_mont    = enter_montgomery_domain(arithmetic_parameters, test[0])
        test_value_x4i_mont   = enter_montgomery_domain(arithmetic_parameters, test[1])
        test_value_z4_mont    = enter_montgomery_domain(arithmetic_parameters, test[2])
        test_value_z4i_mont   = enter_montgomery_domain(arithmetic_parameters, test[3])
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont, test_value_o3_mont, test_value_o3i_mont, test_value_o4_mont, test_value_o4i_mont, test_value_o5_mont, test_value_o5i_mont = get_4_isog(arithmetic_parameters, test_value_x4_mont, test_value_x4i_mont, test_value_z4_mont, test_value_z4i_mont)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1  = iterative_reduction(arithmetic_parameters, test_value_o1)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_o1i = iterative_reduction(arithmetic_parameters, test_value_o1i)
        test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_o2  = iterative_reduction(arithmetic_parameters, test_value_o2)
        test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        test_value_o2i = iterative_reduction(arithmetic_parameters, test_value_o2i)
        test_value_o3  = remove_montgomery_domain(arithmetic_parameters, test_value_o3_mont)
        test_value_o3  = iterative_reduction(arithmetic_parameters, test_value_o3)
        test_value_o3i = remove_montgomery_domain(arithmetic_parameters, test_value_o3i_mont)
        test_value_o3i = iterative_reduction(arithmetic_parameters, test_value_o3i)
        test_value_o4  = remove_montgomery_domain(arithmetic_parameters, test_value_o4_mont)
        test_value_o4  = iterative_reduction(arithmetic_parameters, test_value_o4)
        test_value_o4i = remove_montgomery_domain(arithmetic_parameters, test_value_o4i_mont)
        test_value_o4i = iterative_reduction(arithmetic_parameters, test_value_o4i)
        test_value_o5  = remove_montgomery_domain(arithmetic_parameters, test_value_o5_mont)
        test_value_o5  = iterative_reduction(arithmetic_parameters, test_value_o5)
        test_value_o5i = remove_montgomery_domain(arithmetic_parameters, test_value_o5i_mont)
        test_value_o5i = iterative_reduction(arithmetic_parameters, test_value_o5i)
    
        test_value_o1_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1))
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1i))
        test_value_o2_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2))
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2i))
        test_value_o3_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o3))
        test_value_o3i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o3i))
        test_value_o4_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o4))
        test_value_o4i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o4i))
        test_value_o5_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o5))
        test_value_o5i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o5i))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_x4_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_x4i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z4_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z4i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o3_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o3i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o4_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o4i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o5_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o5i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        
        test_value_x4  = randint(1, max_value-1)
        test_value_x4i = randint(1, max_value-1)
        test_value_z4  = randint(1, max_value-1)
        test_value_z4i = randint(1, max_value-1)
        
        test_value_x4_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_x4)
        test_value_x4i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_x4i)
        test_value_z4_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_z4)
        test_value_z4i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_z4i)
        
        test_value_x4_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_x4)
        test_value_x4i_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_x4i)
        test_value_z4_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_z4)
        test_value_z4i_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_z4i)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont, test_value_o3_mont, test_value_o3i_mont, test_value_o4_mont, test_value_o4i_mont, test_value_o5_mont, test_value_o5i_mont = get_4_isog(arithmetic_parameters, test_value_x4_mont, test_value_x4i_mont, test_value_z4_mont, test_value_z4i_mont)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1  = iterative_reduction(arithmetic_parameters, test_value_o1)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_o1i = iterative_reduction(arithmetic_parameters, test_value_o1i)
        test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_o2  = iterative_reduction(arithmetic_parameters, test_value_o2)
        test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        test_value_o2i = iterative_reduction(arithmetic_parameters, test_value_o2i)
        test_value_o3  = remove_montgomery_domain(arithmetic_parameters, test_value_o3_mont)
        test_value_o3  = iterative_reduction(arithmetic_parameters, test_value_o3)
        test_value_o3i = remove_montgomery_domain(arithmetic_parameters, test_value_o3i_mont)
        test_value_o3i = iterative_reduction(arithmetic_parameters, test_value_o3i)
        test_value_o4  = remove_montgomery_domain(arithmetic_parameters, test_value_o4_mont)
        test_value_o4  = iterative_reduction(arithmetic_parameters, test_value_o4)
        test_value_o4i = remove_montgomery_domain(arithmetic_parameters, test_value_o4i_mont)
        test_value_o4i = iterative_reduction(arithmetic_parameters, test_value_o4i)
        test_value_o5  = remove_montgomery_domain(arithmetic_parameters, test_value_o5_mont)
        test_value_o5  = iterative_reduction(arithmetic_parameters, test_value_o5)
        test_value_o5i = remove_montgomery_domain(arithmetic_parameters, test_value_o5i_mont)
        test_value_o5i = iterative_reduction(arithmetic_parameters, test_value_o5i)
    
        
        test_value_o1_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1))
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1i))
        test_value_o2_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2))
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2i))
        test_value_o3_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o3))
        test_value_o3i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o3i))
        test_value_o4_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o4))
        test_value_o4i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o4i))
        test_value_o5_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o5))
        test_value_o5i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o5i))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_x4_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_x4i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z4_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z4i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o3_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o3i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o4_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o4i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o5_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o5i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    VHDL_memory_file.close()
    
def load_VHDL_get_4_isog_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
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
        print("Error in get 4 isogenies computation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error in get 4 isogenies computation : " + str(current_test))
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error in get 4 isogenies computation : " + str(current_test))
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_prime2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime2 != prime2):
        print("Error in get 4 isogenies computation : " + str(current_test))
        print("Error loading the 2*prime")
        print("Loaded 2*prime")
        print(loaded_prime2)
        print("Input 2*prime")
        print(prime2)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r_mod_prime != r_mod_prime_constant):
        print("Error in get 4 isogenies computation : " + str(current_test))
        print("Error loading the r")
        print("Loaded r")
        print(loaded_r_mod_prime)
        print("Input r")
        print(r_mod_prime_constant)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r2 != r2_constant):
        print("Error in get 4 isogenies computation : " + str(current_test))
        print("Error loading the r2")
        print("Loaded r2")
        print(loaded_r2)
        print("Input r2")
        print(r2_constant)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_1 != 1):
        print("Error in get 4 isogenies computation : " + str(current_test))
        print("Error loading the constant 1")
        print("Loaded constant 1")
        print(loaded_constant_1)
        print("Input constant 1")
        print(1)
    loaded_inv_4_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_inv_4_mont != inv_4_mont):
        print("Error in get 4 isogenies computation : " + str(current_test))
        print("Error loading inversion 4")
        print("Loaded inversion 4")
        print(loaded_inv_4_mont)
        print("Input inversion 4")
        print(inv_4_mont)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in get 4 isogenies computation : " + str(current_test))
        print("Error loading prime size in bits")
        print("Loaded prime size in bits")
        print(loaded_prime_size_bits)
        print("Input prime size in bits")
        print(prime_size_bits)
        
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    while(current_test != (number_of_tests-1)):
        test_value_x4         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_x4i        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_z4         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_z4i        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o4  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o4i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o5  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o5i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        test_value_x4_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_x4)
        test_value_x4i_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_x4i)
        test_value_z4_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_z4)
        test_value_z4i_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z4i)
        
        computed_test_value_o1_mont, computed_test_value_o1i_mont, computed_test_value_o2_mont, computed_test_value_o2i_mont, computed_test_value_o3_mont, computed_test_value_o3i_mont, computed_test_value_o4_mont, computed_test_value_o4i_mont, computed_test_value_o5_mont, computed_test_value_o5i_mont = get_4_isog(arithmetic_parameters, test_value_x4_mont, test_value_x4i_mont, test_value_z4_mont, test_value_z4i_mont)
        
        computed_test_value_o1  = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1_mont)
        computed_test_value_o1  = iterative_reduction(arithmetic_parameters, computed_test_value_o1)
        computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1i_mont)
        computed_test_value_o1i = iterative_reduction(arithmetic_parameters, computed_test_value_o1i)
        computed_test_value_o2  = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2_mont)
        computed_test_value_o2  = iterative_reduction(arithmetic_parameters, computed_test_value_o2)
        computed_test_value_o2i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2i_mont)
        computed_test_value_o2i = iterative_reduction(arithmetic_parameters, computed_test_value_o2i)
        computed_test_value_o3  = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o3_mont)
        computed_test_value_o3  = iterative_reduction(arithmetic_parameters, computed_test_value_o3)
        computed_test_value_o3i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o3i_mont)
        computed_test_value_o3i = iterative_reduction(arithmetic_parameters, computed_test_value_o3i)
        computed_test_value_o4  = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o4_mont)
        computed_test_value_o4  = iterative_reduction(arithmetic_parameters, computed_test_value_o4)
        computed_test_value_o4i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o4i_mont)
        computed_test_value_o4i = iterative_reduction(arithmetic_parameters, computed_test_value_o4i)
        computed_test_value_o5  = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o5_mont)
        computed_test_value_o5  = iterative_reduction(arithmetic_parameters, computed_test_value_o5)
        computed_test_value_o5i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o5i_mont)
        computed_test_value_o5i = iterative_reduction(arithmetic_parameters, computed_test_value_o5i)
    
        
        if((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i) or (computed_test_value_o3 != loaded_test_value_o3) or (computed_test_value_o3i != loaded_test_value_o3i) or (computed_test_value_o4 != loaded_test_value_o4) or (computed_test_value_o4i != loaded_test_value_o4i) or (computed_test_value_o5 != loaded_test_value_o5) or (computed_test_value_o5i != loaded_test_value_o5i)):
            print("Error in get 4 isogenies computation : " + str(current_test))
            print("Loaded value x4")
            print(test_value_x4)
            print(test_value_x4i)
            print("Loaded value z4")
            print(test_value_z4)
            print(test_value_z4i)
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
    
    test_value_x4         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_x4i        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_z4         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_z4i        = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o4  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o4i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o5  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o5i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    test_value_x4_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_x4)
    test_value_x4i_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_x4i)
    test_value_z4_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_z4)
    test_value_z4i_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z4i)
    
    computed_test_value_o1_mont, computed_test_value_o1i_mont, computed_test_value_o2_mont, computed_test_value_o2i_mont, computed_test_value_o3_mont, computed_test_value_o3i_mont, computed_test_value_o4_mont, computed_test_value_o4i_mont, computed_test_value_o5_mont, computed_test_value_o5i_mont = get_4_isog(arithmetic_parameters, test_value_x4_mont, test_value_x4i_mont, test_value_z4_mont, test_value_z4i_mont)
    
    computed_test_value_o1  = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1_mont)
    computed_test_value_o1  = iterative_reduction(arithmetic_parameters, computed_test_value_o1)
    computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1i_mont)
    computed_test_value_o1i = iterative_reduction(arithmetic_parameters, computed_test_value_o1i)
    computed_test_value_o2  = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2_mont)
    computed_test_value_o2  = iterative_reduction(arithmetic_parameters, computed_test_value_o2)
    computed_test_value_o2i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2i_mont)
    computed_test_value_o2i = iterative_reduction(arithmetic_parameters, computed_test_value_o2i)
    computed_test_value_o3  = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o3_mont)
    computed_test_value_o3  = iterative_reduction(arithmetic_parameters, computed_test_value_o3)
    computed_test_value_o3i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o3i_mont)
    computed_test_value_o3i = iterative_reduction(arithmetic_parameters, computed_test_value_o3i)
    computed_test_value_o4  = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o4_mont)
    computed_test_value_o4  = iterative_reduction(arithmetic_parameters, computed_test_value_o4)
    computed_test_value_o4i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o4i_mont)
    computed_test_value_o4i = iterative_reduction(arithmetic_parameters, computed_test_value_o4i)
    computed_test_value_o5  = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o5_mont)
    computed_test_value_o5  = iterative_reduction(arithmetic_parameters, computed_test_value_o5)
    computed_test_value_o5i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o5i_mont)
    computed_test_value_o5i = iterative_reduction(arithmetic_parameters, computed_test_value_o5i)
    
        
    if(debug_mode or ((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i) or (computed_test_value_o3 != loaded_test_value_o3) or (computed_test_value_o3i != loaded_test_value_o3i) or (computed_test_value_o4 != loaded_test_value_o4) or (computed_test_value_o4i != loaded_test_value_o4i) or (computed_test_value_o5 != loaded_test_value_o5) or (computed_test_value_o5i != loaded_test_value_o5i))):
        hex_string_format = "{0:0"+str(((number_of_words*extended_word_size) + 3)//4)+"x}"
        print("Error in get 4 isogenies computation : " + str(current_test))
        print("Loaded value x4")
        print(test_value_x4)
        print(test_value_x4i)
        print("Loaded value z4")
        print(test_value_z4)
        print(test_value_z4i)
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
    
def test_all_get_4_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, number_of_tests):
    error_computation = False
    for i in range(len(primes)):
        prime = primes[i]
        print("Testing prime : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        error_computation = test_get_4_isog(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests)
        if(error_computation):
            break
        
def print_all_VHDL_get_4_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_file_names, number_of_tests):
    for i in range(len(primes)):
        prime = primes[i]
        VHDL_file_name = VHDL_file_names[i]
        print("Printing prime : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        print_VHDL_get_4_isog_test(VHDL_file_name, base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests)

def load_all_VHDL_get_4_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_file_names):
    for i in range(len(primes)):
        prime = primes[i]
        VHDL_file_name = VHDL_file_names[i]
        print("Loading prime test of : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        load_VHDL_get_4_isog_test(VHDL_file_name, base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        
        
number_of_bits_added = 16
base_word_size_signed = 16
extended_word_size_signed = 256
accumulator_word_size = (extended_word_size_signed - 1)*2+32
primes = [2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1, 2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
primes_file_name_end = ["8_5.dat", "216_137.dat", "250_159.dat", "305_192.dat", "372_239.dat", "486_301.dat"]
tests_working_folder = script_working_folder + "../hw_sidh_tests_v256/"
VHDL_get_4_isog_file_names = [(tests_working_folder + "get_4_isog_test_" + ending) for ending in primes_file_name_end]

#test_all_get_4_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
#print_all_VHDL_get_4_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_4_isog_file_names, 100)
#load_all_VHDL_get_4_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_4_isog_file_names)


#i = 3
#prime = primes[i]
#VHDL_file_name = VHDL_get_4_isog_file_names[i]
#print("Loading prime test of : " + str(prime))
#prime_size_bits = int(prime).bit_length()
#load_VHDL_get_4_isog_test(VHDL_file_name, base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests=2, debug_mode=True)
