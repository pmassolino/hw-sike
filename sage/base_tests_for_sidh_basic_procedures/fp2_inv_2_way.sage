#
# Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/
#
proof.arithmetic(False)
home_folder = "/home/pedro/"
script_working_folder = home_folder + "hw-sidh/vhdl_project/sage/"
load(script_working_folder+"base_functions.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/fp2_inv.sage")

def inv_2_way(arithmetic_parameters, z1, z1i, z2, z2i, z3, z3i, z4, z4i, debug=False):
    
    #t1 = z1*z2
    #t3 = z3*z4
    ma = [z1i,  z1, z1, z1i, z3i,  z3, z3, z3i]
    mb = [ z2, z2i, z2, z2i,  z4, z4i, z4, z4i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t1i = mo[0]
    t1  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    #t0 = 1 / t1
    #t4 = 1 / t3
    t0, t0i, t4, t4i = fp2_inv(arithmetic_parameters, t1, t1i, t3, t3i)
    
    #t1 = t0*z2
    #t3 = t4*z4
    ma = [z2i,  z2, z2, z2i, z4i,  z4, z4, z4i]
    mb = [ t0, t0i, t0, t0i,  t4, t4i, t4, t4i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t1i = mo[0]
    t1  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    #t2 = t0*z1
    #t5 = t4*z3
    ma = [z1i,  z1, z1, z1i, z3i,  z3, z3, z3i]
    mb = [ t0, t0i, t0, t0i,  t4, t4i, t4, t4i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t5i = mo[2]
    t5  = mo[3]
    
    return t1, t1i, t2, t2i, t3, t3i, t5, t5i

def sage_inv_2_way(fp2, z1, z1i, z2, z2i, z3, z3i, z4, z4i, debug=False):
    
    tz1 = fp2([z1,z1i])
    tz2 = fp2([z2,z2i])
    tz3 = fp2([z3,z3i])
    tz4 = fp2([z4,z4i])
    
    t1 = tz1*tz2
    t3 = tz3*tz4
    if(t1.divides(fp2(1))):
        t0 = t1^(-1)
    else:
        t0 = 0
    if(t3.divides(fp2(1))):
        t4 = t3^(-1)
    else:
        t4 = 0
    t1 = t0*tz2
    t3 = t4*tz4
    t2 = t0*tz1
    t5 = t4*tz3
    
    ft1  = t1.polynomial()[0]
    ft1i = t1.polynomial()[1]
    ft2  = t2.polynomial()[0]
    ft2i = t2.polynomial()[1]
    ft3  = t3.polynomial()[0]
    ft3i = t3.polynomial()[1]
    ft5  = t5.polynomial()[0]
    ft5i = t5.polynomial()[1]
    
    return ft1, ft1i, ft2, ft2i, ft3, ft3i, ft5, ft5i
    
def test_single_inv_2_way(arithmetic_parameters, fp2, test_value_z1, test_value_z1i, test_value_z2, test_value_z2i, test_value_z3, test_value_z3i, test_value_z4, test_value_z4i):
    prime = arithmetic_parameters[3]
    
    test_value_z1_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z1)
    test_value_z1i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z1i)
    test_value_z2_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z2)
    test_value_z2i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z2i)
    test_value_z3_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z3)
    test_value_z3i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z3i)
    test_value_z4_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z4)
    test_value_z4i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z4i)
    
    test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont, test_value_o3_mont, test_value_o3i_mont, test_value_o4_mont, test_value_o4i_mont = inv_2_way(arithmetic_parameters, test_value_z1_mont, test_value_z1i_mont, test_value_z2_mont, test_value_z2i_mont, test_value_z3_mont, test_value_z3i_mont, test_value_z4_mont, test_value_z4i_mont)
    test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
    test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
    test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
    test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
    test_value_o3  = remove_montgomery_domain(arithmetic_parameters, test_value_o3_mont)
    test_value_o3i = remove_montgomery_domain(arithmetic_parameters, test_value_o3i_mont)
    test_value_o4  = remove_montgomery_domain(arithmetic_parameters, test_value_o4_mont)
    test_value_o4i = remove_montgomery_domain(arithmetic_parameters, test_value_o4i_mont)
    
    test_value_z1_inv  = test_value_o1
    test_value_z1i_inv = test_value_o1i
    test_value_z2_inv  = test_value_o2
    test_value_z2i_inv = test_value_o2i
    test_value_z3_inv  = test_value_o3
    test_value_z3i_inv = test_value_o3i
    test_value_z4_inv  = test_value_o4
    test_value_z4i_inv = test_value_o4i
    
    true_value_z1_inv, true_value_z1i_inv, true_value_z2_inv, true_value_z2i_inv, true_value_z3_inv, true_value_z3i_inv, true_value_z4_inv, true_value_z4i_inv = sage_inv_2_way(fp2, test_value_z1, test_value_z1i, test_value_z2, test_value_z2i, test_value_z3, test_value_z3i, test_value_z4, test_value_z4i)
    
    if((test_value_z1_inv != true_value_z1_inv) or (test_value_z1i_inv != true_value_z1i_inv) or (test_value_z2_inv != true_value_z2_inv) or (test_value_z2i_inv != true_value_z2i_inv)):
        print("Error during the get A procedure ")
        print('')
        print("Prime")
        print(prime)
        print('')
        print("Value Z1")
        print(test_value_z1)
        print(test_value_z1i)
        print("Value Z2")
        print(test_value_z2)
        print(test_value_z2i)
        print('')
        print("Test Z1^-1")
        print(test_value_z1_inv)
        print(test_value_z1i_inv)
        print("True Z1^-1")
        print(true_value_z1_inv)
        print(true_value_z1i_inv)
        print('')
        print("Test Z2^-1")
        print(test_value_z2_inv)
        print(test_value_z2i_inv)
        print("True Z2^-1")
        print(true_value_z2_inv)
        print(true_value_z2i_inv)
        print('')
        print('')
        return True
    
    if((test_value_z3_inv != true_value_z3_inv) or (test_value_z3i_inv != true_value_z3i_inv) or (test_value_z4_inv != true_value_z4_inv) or (test_value_z4i_inv != true_value_z4i_inv)):
        print("Error during the get A procedure ")
        print('')
        print("Prime")
        print(prime)
        print('')
        print("Value Z3")
        print(test_value_z3)
        print(test_value_z3i)
        print("Value Z4")
        print(test_value_z4)
        print(test_value_z4i)
        print('')
        print("Test Z3^-1")
        print(test_value_z3_inv)
        print(test_value_z3i_inv)
        print("True Z3^-1")
        print(true_value_z3_inv)
        print(true_value_z3i_inv)
        print('')
        print("Test Z4^-1")
        print(test_value_z4_inv)
        print(test_value_z4i_inv)
        print("True Z4^-1")
        print(true_value_z4_inv)
        print(true_value_z4i_inv)
        print('')
        print('')
        return True
            
    return False
    
def test_inv_2_way(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
        
    # Maximum tests
    max_value = prime
    maximum_tests = [1, max_value - 1]
    maximum_tests_input = []
    for test_value_z1 in maximum_tests:
        for test_value_z1i in maximum_tests:
            for test_value_z2 in maximum_tests:
                for test_value_z2i in maximum_tests:
                    maximum_tests_input += [[test_value_z1, test_value_z1i, test_value_z2, test_value_z2i]]
    if((len(maximum_tests_input) % 2) == 1):
        maximum_tests_input += [[1, 1, 1, 1]]
    i = 0
    while(i < len(maximum_tests_input)):
        test_value_z1, test_value_z1i, test_value_z2, test_value_z2i = maximum_tests_input[i]
        test_value_z3, test_value_z3i, test_value_z4, test_value_z4i = maximum_tests_input[i+1]
        error_computation = test_single_inv_2_way(arithmetic_parameters, fp2, test_value_z1, test_value_z1i, test_value_z2, test_value_z2i, test_value_z3, test_value_z3i, test_value_z4, test_value_z4i)
        if(error_computation):
            break                    
        i += 2
    # Random tests
    if(not error_computation):
        for i in range(number_of_tests):
            if(((i %(1000)) == 0) and (i != 0)):
                print(i)
            test_value_z1  = randint(1, max_value-1)
            test_value_z1i = randint(1, max_value-1)
            test_value_z2  = randint(1, max_value-1)
            test_value_z2i = randint(1, max_value-1)
            test_value_z3  = randint(1, max_value-1)
            test_value_z3i = randint(1, max_value-1)
            test_value_z4  = randint(1, max_value-1)
            test_value_z4i = randint(1, max_value-1)
            
            error_computation = test_single_inv_2_way(arithmetic_parameters, fp2, test_value_z1, test_value_z1i, test_value_z2, test_value_z2i, test_value_z3, test_value_z3i, test_value_z4, test_value_z4i)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_inv_2_way_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    
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
    for test_value_z1 in maximum_tests:
        for test_value_z1i in maximum_tests:
            for test_value_z2 in maximum_tests:
                for test_value_z2i in maximum_tests:
                    maximum_tests_input += [[test_value_z1, test_value_z1i, test_value_z2, test_value_z2i]]
    if((len(maximum_tests_input) % 2) == 1):
        maximum_tests_input += [[1, 1, 1, 1]]
    i = 0
    while(i < len(maximum_tests_input)):
        test_value_z1, test_value_z1i, test_value_z2, test_value_z2i = maximum_tests_input[i]
        test_value_z3, test_value_z3i, test_value_z4, test_value_z4i = maximum_tests_input[i+1]
        test_value_z1_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_z1)
        test_value_z1i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_z1i)
        test_value_z2_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_z2)
        test_value_z2i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_z2i)
        test_value_z3_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_z3)
        test_value_z3i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_z3i)
        test_value_z4_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_z4)
        test_value_z4i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_z4i)
        
        test_value_z1_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z1)
        test_value_z1i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z1i)
        test_value_z2_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z2)
        test_value_z2i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z2i)
        test_value_z3_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z3)
        test_value_z3i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z3i)
        test_value_z4_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z4)
        test_value_z4i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z4i)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont, test_value_o3_mont, test_value_o3i_mont, test_value_o4_mont, test_value_o4i_mont = inv_2_way(arithmetic_parameters, test_value_z1_mont, test_value_z1i_mont, test_value_z2_mont, test_value_z2i_mont,  test_value_z3_mont, test_value_z3i_mont, test_value_z4_mont, test_value_z4i_mont)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        test_value_o3  = remove_montgomery_domain(arithmetic_parameters, test_value_o3_mont)
        test_value_o3i = remove_montgomery_domain(arithmetic_parameters, test_value_o3i_mont)
        test_value_o4  = remove_montgomery_domain(arithmetic_parameters, test_value_o4_mont)
        test_value_o4i = remove_montgomery_domain(arithmetic_parameters, test_value_o4i_mont)
        
        test_value_o1_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_o1)
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_o1i)
        test_value_o2_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_o2)
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_o2i)
        test_value_o3_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_o3)
        test_value_o3i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_o3i)
        test_value_o4_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_o4)
        test_value_o4i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_o4i)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z2i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z3_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z3i_list, maximum_number_of_words)
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
        
        tests_already_performed += 1
        i += 2
        
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        test_value_z1  = randint(1, max_value-1)
        test_value_z1i = randint(1, max_value-1)
        test_value_z2  = randint(1, max_value-1)
        test_value_z2i = randint(1, max_value-1)
        test_value_z3  = randint(1, max_value-1)
        test_value_z3i = randint(1, max_value-1)
        test_value_z4  = randint(1, max_value-1)
        test_value_z4i = randint(1, max_value-1)
        
        test_value_z1_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_z1)
        test_value_z1i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_z1i)
        test_value_z2_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_z2)
        test_value_z2i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_z2i)
        test_value_z3_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_z3)
        test_value_z3i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_z3i)
        test_value_z4_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_z4)
        test_value_z4i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_z4i)
        
        test_value_z1_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z1)
        test_value_z1i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z1i)
        test_value_z2_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z2)
        test_value_z2i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z2i)
        test_value_z3_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z3)
        test_value_z3i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z3i)
        test_value_z4_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z4)
        test_value_z4i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z4i)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont, test_value_o3_mont, test_value_o3i_mont, test_value_o4_mont, test_value_o4i_mont = inv_2_way(arithmetic_parameters, test_value_z1_mont, test_value_z1i_mont, test_value_z2_mont, test_value_z2i_mont,  test_value_z3_mont, test_value_z3i_mont, test_value_z4_mont, test_value_z4i_mont)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        test_value_o3  = remove_montgomery_domain(arithmetic_parameters, test_value_o3_mont)
        test_value_o3i = remove_montgomery_domain(arithmetic_parameters, test_value_o3i_mont)
        test_value_o4  = remove_montgomery_domain(arithmetic_parameters, test_value_o4_mont)
        test_value_o4i = remove_montgomery_domain(arithmetic_parameters, test_value_o4i_mont)
        
        test_value_o1_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_o1)
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_o1i)
        test_value_o2_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_o2)
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_o2i)
        test_value_o3_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_o3)
        test_value_o3i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_o3i)
        test_value_o4_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_o4)
        test_value_o4i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_o4i)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z2i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z3_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z3i_list, maximum_number_of_words)
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
        
    VHDL_memory_file.close()
    
def load_VHDL_inv_2_way_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
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
        print("Error in 2 way inversion computation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error in 2 way inversion computation : " + str(current_test))
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error in 2 way inversion computation : " + str(current_test))
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r_mod_prime != r_mod_prime_constant):
        print("Error in 2 way inversion computation : " + str(current_test))
        print("Error loading the r")
        print("Loaded r")
        print(loaded_r_mod_prime)
        print("Input r")
        print(r_mod_prime_constant)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r2 != r2_constant):
        print("Error in 2 way inversion computation : " + str(current_test))
        print("Error loading the r2")
        print("Loaded r2")
        print(loaded_r2)
        print("Input r2")
        print(r2_constant)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_1 != 1):
        print("Error in 2 way inversion computation : " + str(current_test))
        print("Error loading the constant 1")
        print("Loaded constant 1")
        print(loaded_constant_1)
        print("Input constant 1")
        print(1)
    loaded_inv_4_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_inv_4_mont != inv_4_mont):
        print("Error in 2 way inversion computation : " + str(current_test))
        print("Error loading inversion 4")
        print("Loaded inversion 4")
        print(loaded_inv_4_mont)
        print("Input inversion 4")
        print(inv_4_mont)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in 2 way inversion computation : " + str(current_test))
        print("Error loading prime size in bits")
        print("Loaded prime size in bits")
        print(loaded_prime_size_bits)
        print("Input prime size in bits")
        print(prime_size_bits)
        
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    
    while(current_test != (number_of_tests-1)):
        test_value_z1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_z1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_z2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_z2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_z3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_z3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_z4  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_z4i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o4  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o4i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        test_value_z1_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z1)
        test_value_z1i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z1i)
        test_value_z2_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z2)
        test_value_z2i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z2i)
        test_value_z3_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z3)
        test_value_z3i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z3i)
        test_value_z4_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z4)
        test_value_z4i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z4i)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont, test_value_o3_mont, test_value_o3i_mont, test_value_o4_mont, test_value_o4i_mont = inv_2_way(arithmetic_parameters, test_value_z1_mont, test_value_z1i_mont, test_value_z2_mont, test_value_z2i_mont, test_value_z3_mont, test_value_z3i_mont, test_value_z4_mont, test_value_z4i_mont)
        
        computed_test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        computed_test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        computed_test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        computed_test_value_o3  = remove_montgomery_domain(arithmetic_parameters, test_value_o3_mont)
        computed_test_value_o3i = remove_montgomery_domain(arithmetic_parameters, test_value_o3i_mont)
        computed_test_value_o4  = remove_montgomery_domain(arithmetic_parameters, test_value_o4_mont)
        computed_test_value_o4i = remove_montgomery_domain(arithmetic_parameters, test_value_o4i_mont)
        
        if((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i)):
            print("Error in 2 way inversion computation : " + str(current_test))
            print("Loaded value z1")
            print(test_value_z1)
            print(test_value_z1i)
            print("Loaded value z2")
            print(test_value_z2)
            print(test_value_z2i)
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
        if((computed_test_value_o3 != loaded_test_value_o3) or (computed_test_value_o3i != loaded_test_value_o3i) or (computed_test_value_o4 != loaded_test_value_o4) or (computed_test_value_o4i != loaded_test_value_o4i)):
            print("Error in 2 way inversion computation : " + str(current_test))
            print("Loaded value z3")
            print(test_value_z3)
            print(test_value_z3i)
            print("Loaded value z4")
            print(test_value_z4)
            print(test_value_z4i)
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
        current_test += 1
    
    test_value_z1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_z1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_z2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_z2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_z3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_z3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_z4  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_z4i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o4  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o4i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
    test_value_z1_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z1)
    test_value_z1i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z1i)
    test_value_z2_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z2)
    test_value_z2i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z2i)
    test_value_z3_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z3)
    test_value_z3i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z3i)
    test_value_z4_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_z4)
    test_value_z4i_mont = enter_montgomery_domain(arithmetic_parameters, test_value_z4i)
    
    test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont, test_value_o3_mont, test_value_o3i_mont, test_value_o4_mont, test_value_o4i_mont = inv_2_way(arithmetic_parameters, test_value_z1_mont, test_value_z1i_mont, test_value_z2_mont, test_value_z2i_mont, test_value_z3_mont, test_value_z3i_mont, test_value_z4_mont, test_value_z4i_mont)
    
    computed_test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
    computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
    computed_test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
    computed_test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
    computed_test_value_o3  = remove_montgomery_domain(arithmetic_parameters, test_value_o3_mont)
    computed_test_value_o3i = remove_montgomery_domain(arithmetic_parameters, test_value_o3i_mont)
    computed_test_value_o4  = remove_montgomery_domain(arithmetic_parameters, test_value_o4_mont)
    computed_test_value_o4i = remove_montgomery_domain(arithmetic_parameters, test_value_o4i_mont)
                
        
    if(debug_mode or ((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i)) or ((computed_test_value_o3 != loaded_test_value_o3) or (computed_test_value_o3i != loaded_test_value_o3i) or (computed_test_value_o4 != loaded_test_value_o4) or (computed_test_value_o4i != loaded_test_value_o4i))):
        print("Error in 2 way inversion computation : " + str(current_test))
        print("Loaded value z1")
        print(test_value_z1)
        print(test_value_z1i)
        print("Loaded value z2")
        print(test_value_z2)
        print(test_value_z2i)
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
        print('')
        print("Loaded value z3")
        print(test_value_z3)
        print(test_value_z3i)
        print("Loaded value z4")
        print(test_value_z4)
        print(test_value_z4i)
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
    
    VHDL_memory_file.close()
    
def test_all_inv_2_way(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, number_of_tests):
    error_computation = False
    for prime in primes:
        print("Testing prime : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        error_computation = test_inv_2_way(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests)
        if(error_computation):
            break
        
def print_all_VHDL_inv_2_way_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_file_names, number_of_tests):
    for i in range(len(primes)):
        prime = primes[i]
        VHDL_file_name = VHDL_file_names[i]
        print("Printing prime : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        print_VHDL_inv_2_way_test(VHDL_file_name, base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests)

def load_all_VHDL_inv_2_way_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_file_names):
    for i in range(len(primes)):
        prime = primes[i]
        VHDL_file_name = VHDL_file_names[i]
        print("Loading prime test of : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        load_VHDL_inv_2_way_test(VHDL_file_name, base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    
number_of_bits_added = 8
base_word_size_signed = 16
extended_word_size_signed = 256
accumulator_word_size = (extended_word_size_signed - 1)*2+32
primes = [2^(4)*3^(3)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1, 2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
primes_file_name_end = ["4_3.dat", "216_137.dat", "250_159.dat", "305_192.dat", "372_239.dat", "486_301.dat"]
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sidh_tests_v257/"
VHDL_inv_2_way_file_names = [(tests_working_folder + "inv_2_way_test_" + ending) for ending in primes_file_name_end]

#test_all_inv_2_way(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
#print_all_VHDL_inv_2_way_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_inv_2_way_file_names, 100)
#load_all_VHDL_inv_2_way_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_inv_2_way_file_names)