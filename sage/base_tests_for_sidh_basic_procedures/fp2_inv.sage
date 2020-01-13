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
load(script_working_folder+"base_tests_for_sidh_basic_procedures/fp_inv.sage")

def fp2_inv(arithmetic_parameters, a, ai, b, bi, debug=False):
    # t0 = a^2 + ai^2
    ma = [ai, a, bi, b, 0, 0, 0, 0]
    mo = mac_8_montgomery_squaring(arithmetic_parameters, ma)
    ma =     [mo[0], mo[2], 0, 0]
    mb =     [mo[1], mo[3], 0, 0]
    sign_a = [    1,     1, 1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    # t0 = t0^(-1)
    ma = mo[0]
    mb = mo[1]
    mo = fp_inv(arithmetic_parameters, ma, mb)
    t0a = mo[0]
    t0b = mo[1]
    # o = (a - ai*x)
    ma =     [ ai, a, bi, b]
    mb =     [  0, 0,  0, 0]
    sign_a = [  0, 1,  0, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    o1i = mo[0]
    o1  = mo[1]
    o2i = mo[2]
    o2  = mo[3]
    # o = o*t0 + oi*t0
    ma = [o1i,  o1, o2i,  o2, 0, 0, 0, 0]
    mb = [t0a, t0a, t0b, t0b, 0, 0, 0, 0]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    o1i = mo[0]
    o1  = mo[1]
    o2i = mo[2]
    o2  = mo[3]
    
    return o1, o1i, o2, o2i
    
def sage_fp2_inv(fp2, a, ai, b, bi, debug=False):
    if((fp2([a, ai])).divides(fp2(1))):
        temp1 = fp2([a, ai])^(-1)
    else:
        temp1 = fp2(0)
    if((fp2([b, bi])).divides(fp2(1))):
        temp2 = fp2([b, bi])^(-1)
    else:
        temp2 = fp2(0)

    o1  = temp1.polynomial()[0]
    o1i = temp1.polynomial()[1]
    o2  = temp2.polynomial()[0]
    o2i = temp2.polynomial()[1]
    
    return o1, o1i, o2, o2i
    
def test_single_fp2_inv(arithmetic_parameters, fp2, test_value_a, test_value_ai, test_value_b, test_value_bi):
    prime = arithmetic_parameters[3]
    test_value_a_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a)
    test_value_ai_mont = enter_montgomery_domain(arithmetic_parameters, test_value_ai)
    test_value_b_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_b)
    test_value_bi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_bi)
    
    test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = fp2_inv(arithmetic_parameters, test_value_a_mont, test_value_ai_mont, test_value_b_mont, test_value_bi_mont)
    
    test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
    test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
    test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
    test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
    test_value_a_inv = test_value_o1
    test_value_ai_inv = test_value_o1i
    test_value_b_inv = test_value_o2
    test_value_bi_inv = test_value_o2i
    
    
    true_value_a_inv, true_value_ai_inv, true_value_b_inv, true_value_bi_inv = sage_fp2_inv(fp2, test_value_a, test_value_ai, test_value_b, test_value_bi, debug=False)
    
    
    if((test_value_a_inv != true_value_a_inv) or (test_value_ai_inv != true_value_ai_inv)):
        print("Error during the fp2 inversion procedure ")
        print('')
        print("Prime")
        print(prime)
        print('')
        print("Value a")
        print(test_value_a)
        print(test_value_ai)
        print('')
        print("Test a^(-1)")
        print(test_value_a_inv)
        print(test_value_ai_inv)
        print('')
        print("True a^(-1)")
        print(true_value_a_inv)
        print(true_value_ai_inv)
        print('')
        return True
    if((test_value_b_inv != true_value_b_inv) or (test_value_bi_inv != true_value_bi_inv)):
        print("Error during the fp2 inversion procedure ")
        print('')
        print("Prime")
        print(prime)
        print('')
        print("Value a")
        print(test_value_b)
        print(test_value_bi)
        print('')
        print("Test a^(-1)")
        print(test_value_b_inv)
        print(test_value_bi_inv)
        print('')
        print("True a^(-1)")
        print(true_value_b_inv)
        print(true_value_bi_inv)
        print('')
        return True
    
            
    return False
    
def test_fp2_inv(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
        
    # Maximum tests
    max_value = prime
    maximum_tests = [1, 2, max_value - 2, max_value - 1]
    maximum_tests_input = []
    for test_value_a in maximum_tests:
        for test_value_ai in maximum_tests:
            maximum_tests_input += [[test_value_a, test_value_ai]]
    if((len(maximum_tests_input) % 2) == 1):
        maximum_tests_input += [[1, 1]]
    tests_already_performed = 0
    for i in range(0, len(maximum_tests_input), 2):
        test_value_a, test_value_ai = maximum_tests_input[i]
        test_value_b, test_value_bi = maximum_tests_input[i+1]
        error_computation = test_single_fp2_inv(arithmetic_parameters, fp2, test_value_a, test_value_ai, test_value_b, test_value_bi)
        if(error_computation):
            break
    tests_already_performed += len(maximum_tests_input)
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_a   = randint(1, max_value-1)
            test_value_ai  = randint(1, max_value-1)
            test_value_b   = randint(1, max_value-1)
            test_value_bi  = randint(1, max_value-1)
            
            error_computation = test_single_fp2_inv(arithmetic_parameters, fp2, test_value_a, test_value_ai, test_value_b, test_value_bi)
            if(error_computation):
                break
        
    return error_computation
    
def print_VHDL_fp2_inv_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    
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
    
    
    VHDL_memory_file.write((("{0:0d}").format(number_of_tests)))
    VHDL_memory_file.write('\n')
    
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
    
    inv_4 = (fp2(4)^(-1)).polynomial()[0]
    inv_4_mont = enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    inv_4_mont_list = integer_to_list(extended_word_size_signed, number_of_words, inv_4_mont)
    
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
    maximum_tests = [1, 2, max_value - 2, max_value - 1]
    maximum_tests_input = []
    for test_value_a in maximum_tests:
        for test_value_ai in maximum_tests:
            maximum_tests_input += [[test_value_a, test_value_ai]]
    if((len(maximum_tests_input) % 2) == 1):
        maximum_tests_input += [[1, 1]]
    i = 0
    while(i < len(maximum_tests_input)):
        test_value_a, test_value_ai = maximum_tests_input[i]
        test_value_b, test_value_bi = maximum_tests_input[i+1]
        test_value_a_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        test_value_ai_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_ai)
        test_value_b_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
        test_value_bi_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_bi)
        test_value_a_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a)
        test_value_ai_mont = enter_montgomery_domain(arithmetic_parameters, test_value_ai)
        test_value_b_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_b)
        test_value_bi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_bi)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = fp2_inv(arithmetic_parameters, test_value_a_mont, test_value_ai_mont, test_value_b_mont, test_value_bi_mont)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        test_value_o1_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_o1)
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_o1i)
        test_value_o2_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_o2)
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_o2i)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_ai_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_b_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_bi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2i_list, maximum_number_of_words)
        tests_already_performed += 1
        i += 2
        
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        
        test_value_a  = randint(1, max_value-1)
        test_value_ai = randint(1, max_value-1)
        test_value_b  = randint(1, max_value-1)
        test_value_bi = randint(1, max_value-1)
        
        test_value_a_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        test_value_ai_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_ai)
        test_value_b_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
        test_value_bi_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_bi)
        test_value_a_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a)
        test_value_ai_mont = enter_montgomery_domain(arithmetic_parameters, test_value_ai)
        test_value_b_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_b)
        test_value_bi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_bi)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = fp2_inv(arithmetic_parameters, test_value_a_mont, test_value_ai_mont, test_value_b_mont, test_value_bi_mont)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        test_value_o1_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_o1)
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_o1i)
        test_value_o2_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_o2)
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_o2i)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_ai_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_b_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_bi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2i_list, maximum_number_of_words)
        tests_already_performed += 1
        i += 2
        
    VHDL_memory_file.close()
    
def load_VHDL_fp2_inv_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
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
        print("Error in fp2 inversion computation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error in fp2 inversion computation : " + str(current_test))
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error in fp2 inversion computation : " + str(current_test))
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r_mod_prime != r_mod_prime_constant):
        print("Error in fp2 inversion computation : " + str(current_test))
        print("Error loading the r")
        print("Loaded r")
        print(loaded_r_mod_prime)
        print("Input r")
        print(r_mod_prime_constant)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r2 != r2_constant):
        print("Error in fp2 inversion computation : " + str(current_test))
        print("Error loading the r2")
        print("Loaded r2")
        print(loaded_r2)
        print("Input r2")
        print(r2_constant)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_1 != 1):
        print("Error in fp2 inversion computation : " + str(current_test))
        print("Error loading the constant 1")
        print("Loaded constant 1")
        print(loaded_constant_1)
        print("Input constant 1")
        print(1)
    loaded_inv_4_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_inv_4_mont != inv_4_mont):
        print("Error in fp2 inversion computation : " + str(current_test))
        print("Error loading inversion 4")
        print("Loaded inversion 4")
        print(loaded_inv_4_mont)
        print("Input inversion 4")
        print(inv_4_mont)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in fp2 inversion computation : " + str(current_test))
        print("Error loading prime size in bits")
        print("Loaded prime size in bits")
        print(loaded_prime_size_bits)
        print("Input prime size in bits")
        print(prime_size_bits)
        
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    while(current_test != (number_of_tests-1)):
        test_value_a          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_ai         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_b          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_bi         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        test_value_a_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a)
        test_value_ai_mont = enter_montgomery_domain(arithmetic_parameters, test_value_ai)
        test_value_b_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_b)
        test_value_bi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_bi)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = fp2_inv(arithmetic_parameters, test_value_a_mont, test_value_ai_mont, test_value_b_mont, test_value_bi_mont)
        
        computed_test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        computed_test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        computed_test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        
        if((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i)):
            print("Error in fp2 inversion computation : " + str(current_test))
            print("Loaded value a")
            print(test_value_a)
            print(test_value_ai)
            print("Loaded value o")
            print(loaded_test_value_o1)
            print(loaded_test_value_o1i)
            print("Computed value o")
            print(computed_test_value_o1)
            print(computed_test_value_o1i)
        if((computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i)):
            print("Error in fp2 inversion computation : " + str(current_test))
            print("Loaded value a")
            print(test_value_b)
            print(test_value_bi)
            print("Loaded value o")
            print(loaded_test_value_o2)
            print(loaded_test_value_o2i)
            print("Computed value o")
            print(computed_test_value_o2)
            print(computed_test_value_o2i)
        current_test += 1
    
    test_value_a          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_ai         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_b          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_bi         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    test_value_a_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a)
    test_value_ai_mont = enter_montgomery_domain(arithmetic_parameters, test_value_ai)
    test_value_b_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_b)
    test_value_bi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_bi)
    
    test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = fp2_inv(arithmetic_parameters, test_value_a_mont, test_value_ai_mont, test_value_b_mont, test_value_bi_mont)
    
    computed_test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
    computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
    computed_test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
    computed_test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
    
    if((debug_mode) or (computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i)):
        print("Error in fp2 inversion computation : " + str(current_test))
        print("Loaded value a")
        print(test_value_a)
        print(test_value_ai)
        print("Loaded value o")
        print(loaded_test_value_o1)
        print(loaded_test_value_o1i)
        print("Computed value o")
        print(computed_test_value_o1)
        print(computed_test_value_o1i)
    if((debug_mode) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i)):
        print("Error in fp2 inversion computation : " + str(current_test))
        print("Loaded value a")
        print(test_value_b)
        print(test_value_bi)
        print("Loaded value o")
        print(loaded_test_value_o2)
        print(loaded_test_value_o2i)
        print("Computed value o")
        print(computed_test_value_o2)
        print(computed_test_value_o2i)
        
    VHDL_memory_file.close()

def test_all_fp2_inv(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, number_of_tests):
    error_computation = False
    for prime in primes:
        print("Testing prime : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        error_computation = test_fp2_inv(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests)
        if(error_computation):
            break
        
def print_all_VHDL_fp2_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_file_names, number_of_tests):
    for i in range(len(primes)):
        prime = primes[i]
        VHDL_file_name = VHDL_file_names[i]
        print("Printing prime : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        print_VHDL_fp2_inv_test(VHDL_file_name, base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests)

def load_all_VHDL_fp2_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_file_names):
    for i in range(len(primes)):
        prime = primes[i]
        VHDL_file_name = VHDL_file_names[i]
        print("Loading prime test of : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        load_VHDL_fp2_inv_test(VHDL_file_name, base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        
number_of_bits_added = 8
base_word_size_signed = 16
extended_word_size_signed = 256
accumulator_word_size = (extended_word_size_signed - 1)*2+32
primes = [2^(4)*3^(3)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1, 2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
primes_file_name_end = ["4_3.dat", "216_137.dat", "250_159.dat", "305_192.dat", "372_239.dat", "486_301.dat"]
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sidh_tests_v257/"
VHDL_fp2_inv_file_names = [(tests_working_folder + "fp2_inv_test_" + ending) for ending in primes_file_name_end]

#test_all_fp2_inv(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
#print_all_VHDL_fp2_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_fp2_inv_file_names, 100)
#load_all_VHDL_fp2_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_fp2_inv_file_names)