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

def xTPLe(arithmetic_parameters, x, xi, z, zi, a24m, a24mi, a24p, a24pi, e):
    # t0 = X; t1 = Y
    t0  = x
    t0i = xi
    t1  = z
    t1i = zi
    
    for i in range(0,e):
        #t2 = t0+t1
        #t3 = t0+t0
        ma =     [t1i, t1, t0i, t0]
        mb =     [t0i, t0, t0i, t0]
        sign_a = [  1,  1,   1,  1]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t2i = mo[0]
        t2  = mo[1]
        t3i = mo[2]
        t3  = mo[3]
        
        #t4 = t2^2
        #t5 = t3^2
        ma = [t2i,  t2, t2, t2i, t3i,  t3, t3, t3i]
        mb = [ t2, t2i, t2, t2i,  t3, t3i, t3, t3i]
        mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
        ma =     [mo[0], mo[3], mo[4], mo[7]]
        mb =     [mo[1], mo[2], mo[5], mo[6]]
        sign_a = [    1,     0,     1,     0]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t4i = mo[0]
        t4  = mo[1]
        t5i = mo[2]
        t5  = mo[3]
        
        #t2 = t5-t4
        #t6 = t0-t1
        ma =     [t4i, t4, t1i, t1]
        mb =     [t5i, t5, t0i, t0]
        sign_a = [  0,  0,   0,  0]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t2i = mo[0]
        t2  = mo[1]
        t6i = mo[2]
        t6  = mo[3]
        
        #t5 = t6^2
        #t7 = A24p*t4
        ma = [t6i,  t6, t6, t6i, a24pi, a24p, a24p, a24pi]
        mb = [ t6, t6i, t6, t6i,    t4,  t4i,   t4,   t4i]
        mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
        ma =     [mo[0], mo[3], mo[4], mo[7]]
        mb =     [mo[1], mo[2], mo[5], mo[6]]
        sign_a = [    1,     0,     1,     0]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t5i = mo[0]
        t5  = mo[1]
        t7i = mo[2]
        t7  = mo[3]
        
        #t6 = t7*t4
        #t8 = A24m*t5
        ma = [t7i,  t7, t7, t7i, a24mi, a24m, a24m, a24mi]
        mb = [ t4, t4i, t4, t4i,    t5,  t5i,   t5,   t5i]
        mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
        ma =     [mo[0], mo[3], mo[4], mo[7]]
        mb =     [mo[1], mo[2], mo[5], mo[6]]
        sign_a = [    1,     0,     1,     0]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t6i = mo[0]
        t6  = mo[1]
        t8i = mo[2]
        t8  = mo[3]
        
        #t4 = t2-t5
        #t9 = t7-t8
        ma =     [t5i, t5, t8i, t8]
        mb =     [t2i, t2, t7i, t7]
        sign_a = [  0,  0,   0,  0]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t4i = mo[0]
        t4  = mo[1]
        t9i = mo[2]
        t9  = mo[3]
        
        #t2 = t4*t9
        #t7 = t5*t8
        ma = [t4i,  t4, t4, t4i, t5i,  t5, t5, t5i]
        mb = [ t9, t9i, t9, t9i,  t8, t8i, t8, t8i]
        mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
        ma =     [mo[0], mo[3], mo[4], mo[7]]
        mb =     [mo[1], mo[2], mo[5], mo[6]]
        sign_a = [    1,     0,     1,     0]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t2i = mo[0]
        t2  = mo[1]
        t7i = mo[2]
        t7  = mo[3]
        
        #t4 = t7-t6
        #t5 = t1+t1
        ma =     [t6i, t6, t1i, t1]
        mb =     [t7i, t7, t1i, t1]
        sign_a = [  0,  0,   1,  1]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t4i = mo[0]
        t4  = mo[1]
        t5i = mo[2]
        t5  = mo[3]
        
        #t6 = t4-t2
        #t7 = t4+t2
        ma =     [t2i, t2, t2i, t2]
        mb =     [t4i, t4, t4i, t4]
        sign_a = [  0,  0,   1,  1]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t6i = mo[0]
        t6  = mo[1]
        t7i = mo[2]
        t7  = mo[3]
        
        #t2 = t6^2
        #t4 = t7^2
        ma = [t6i,  t6, t6, t6i, t7i,  t7, t7, t7i]
        mb = [ t6, t6i, t6, t6i,  t7, t7i, t7, t7i]
        mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
        ma =     [mo[0], mo[3], mo[4], mo[7]]
        mb =     [mo[1], mo[2], mo[5], mo[6]]
        sign_a = [    1,     0,     1,     0]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t2i = mo[0]
        t2  = mo[1]
        t4i = mo[2]
        t4  = mo[3]
        
        #t0 = t3*t4
        #t1 = t5*t2
        ma = [t3i,  t3, t3, t3i, t5i,  t5, t5, t5i]
        mb = [ t4, t4i, t4, t4i,  t2, t2i, t2, t2i]
        mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
        ma =     [mo[0], mo[3], mo[4], mo[7]]
        mb =     [mo[1], mo[2], mo[5], mo[6]]
        sign_a = [    1,     0,     1,     0]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t0i = mo[0]
        t0  = mo[1]
        t1i = mo[2]
        t1  = mo[3]
        
    return t0, t0i, t1, t1i

def sage_xTPLe(fp2, x, xi, z, zi, a24m, a24mi, a24p, a24pi, e):
    t0 = fp2([x, xi])
    t1 = fp2([z, zi])
    a24m = fp2([a24m, a24mi])
    a24p = fp2([a24p, a24pi])
    
    for i in range(0,e):
        # (3) t1 = xp+zp
        # (5) t4 = t1+t0 <= xp+zp+xp-zp = xp+xp
        t2 = t0+t1
        t3 = t0+t0
        
        # (4) t3 = t1^2
        # (7) t1 = t4^2
        t4 = t2^2
        t5 = t3^2
        
        # (8) t1 = t1-t3
        # (1) t0 = xp-zp
        t2 = t5-t4
        t6 = t0-t1
        
        # (2)  t2 = t0^2
        # (10) t5 = t3*a24p
        t5 = t6^2
        t7 = a24p*t4
        
        # (11) t3 = t5*t3
        # (12) t6 = t2*a24m
        t6 = t7*t4
        t8 = a24m*t5
        
        # (9)  t1 = t1-t2
        # (15) t2 = t5-t6
        t4 = t2-t5
        t9 = t7-t8
        
        # (16) t1 = t2*t1
        # (13) t2 = t2*t6
        t2 = t4*t9
        t7 = t5*t8
        
        # (14) t3 = t2-t3
        # (6)  t0 = t1-t0 = xp+zp-xp+zp = zp+zp
        t4 = t7-t6
        t5 = t1+t1
        
        # (20) t1 = t3-t1
        # (17) t2 = t3+t1
        t6 = t4-t2
        t7 = t4+t2
        
        # (21) t1 = t1^2
        # (18) t2 = t2^2
        t2 = t6^2
        t4 = t7^2
        
        # (19) x3p = t2*t4
        # (21) z3p = t1*t0
        t0 = t3*t4
        t1 = t5*t2
    
    ft0  = t0.polynomial()[0]
    ft0i = t0.polynomial()[1]
    ft1  = t1.polynomial()[0]
    ft1i = t1.polynomial()[1]
    
    return ft0, ft0i, ft1, ft1i
    
def test_single_xTPLe(arithmetic_parameters, fp2, test_value_x, test_value_xi, test_value_z, test_value_zi, test_value_a24m, test_value_a24mi, test_value_a24p, test_value_a24pi, test_value_e):
    prime = arithmetic_parameters[3]
    
    test_value_x_mont      = enter_montgomery_domain(arithmetic_parameters, test_value_x)
    test_value_xi_mont     = enter_montgomery_domain(arithmetic_parameters, test_value_xi)
    test_value_z_mont      = enter_montgomery_domain(arithmetic_parameters, test_value_z)
    test_value_zi_mont     = enter_montgomery_domain(arithmetic_parameters, test_value_zi)
    test_value_a24m_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_a24m)
    test_value_a24mi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a24mi)
    test_value_a24p_mont   = enter_montgomery_domain(arithmetic_parameters, test_value_a24p)
    test_value_a24pi_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a24pi)
    
    
    test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = xTPLe(arithmetic_parameters, test_value_x_mont, test_value_xi_mont, test_value_z_mont, test_value_zi_mont, test_value_a24m_mont, test_value_a24mi_mont, test_value_a24p_mont, test_value_a24pi_mont, test_value_e)
    
    test_value_o1 = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
    test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
    test_value_o2 = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
    test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
    test_value_final_t0 = [test_value_o1, test_value_o1i]
    test_value_final_t1 = [test_value_o2, test_value_o2i]
    
    true_value_final = sage_xTPLe(fp2, test_value_x, test_value_xi, test_value_z, test_value_zi, test_value_a24m, test_value_a24mi, test_value_a24p, test_value_a24pi, test_value_e)
    
    true_value_final_t0 = true_value_final[0:2]
    true_value_final_t1 = true_value_final[2:4]
    
    if((test_value_final_t0[0] != true_value_final_t0[0]) or (test_value_final_t0[1] != true_value_final_t0[1]) or (test_value_final_t1[0] != true_value_final_t1[0]) or (test_value_final_t1[1] != true_value_final_t1[1])):
        print("Error during the xTPLe procedure ")
        print('')
        print("Prime")
        print(prime)
        print('')
        print("Value t0")
        print(test_value_x)
        print(test_value_xi)
        print("Value t1")
        print(test_value_z)
        print(test_value_zi)
        print("Value a24m")
        print(test_value_a24m)
        print(test_value_a24mi)
        print("Value a24p")
        print(test_value_a24p)
        print(test_value_a24pi)
        print("Value e")
        print(test_value_e)
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
    
def test_xTPLe(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, max_repetition_value, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    fp = GF(prime)
    r.<t0> = fp[]
    fp2.<i> = fp.extension(t0^2+1)
        
    # Maximum tests
    max_value = prime
    maximum_tests = [1, max_value - 1]
    maximum_exponent = [max_repetition_value-1]
    maximum_tests_input = []
    for test_value_e in maximum_exponent:
        for test_value_x in maximum_tests:
            for test_value_xi in maximum_tests:
                for test_value_z in maximum_tests:
                    for test_value_zi in maximum_tests:
                        for test_value_a in maximum_tests:
                            for test_value_ai in maximum_tests:
                                maximum_tests_input += [[test_value_x, test_value_xi, test_value_z, test_value_zi, test_value_a, test_value_ai, test_value_e]]
    for test in maximum_tests_input:
        test_value_a24m  = (test[4]-2) % prime
        test_value_a24mi = test[5]
        test_value_a24p  = (test[4]+2) % prime
        test_value_a24pi = test[5]
        
        error_computation = test_single_xTPLe(arithmetic_parameters, fp2, test[0], test[1], test[2], test[3], test_value_a24m, test_value_a24mi, test_value_a24p, test_value_a24pi, test[6])
        if(error_computation):
            break
    # Random tests
    if(not error_computation):
        for i in range(number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            test_value_e     = randint(1, max_repetition_value-1)
            test_value_x     = randint(1, max_value-1)
            test_value_xi    = randint(1, max_value-1)
            test_value_z     = randint(1, max_value-1)
            test_value_zi    = randint(1, max_value-1)
            test_value_a     = randint(1, max_value-1)
            test_value_ai    = randint(1, max_value-1)
            test_value_a24m  = (test_value_a-2)# % prime
            test_value_a24mi = test_value_ai
            test_value_a24p  = (test_value_a+2)# % prime
            test_value_a24pi = test_value_ai
            
            error_computation = test_single_xTPLe(arithmetic_parameters, fp2, test_value_x, test_value_xi, test_value_z, test_value_zi, test_value_a24m, test_value_a24mi, test_value_a24p, test_value_a24pi, test_value_e)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_xTPLe_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, max_repetition_value, number_of_tests):
    
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
    r.<t0> = fp[]
    fp2.<i> = fp.extension(t0^2+1)
    
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
    maximum_exponent = [max_repetition_value-1]
    maximum_tests_input = []
    for test_value_e in maximum_exponent:
        for test_value_x in maximum_tests:
            for test_value_xi in maximum_tests:
                for test_value_z in maximum_tests:
                    for test_value_zi in maximum_tests:
                        for test_value_a in maximum_tests:
                            for test_value_ai in maximum_tests:
                                maximum_tests_input += [[test_value_x, test_value_xi, test_value_z, test_value_zi, test_value_a, test_value_ai, test_value_e]]
    
    for test in maximum_tests_input:
        test_value_a24m  = (test[4]-2) % prime
        test_value_a24mi = test[5]
        test_value_a24p  = (test[4]+2) % prime
        test_value_a24pi = test[5]
        
        test_value_x_list = integer_to_list(extended_word_size_signed, number_of_words, test[0])
        test_value_xi_list = integer_to_list(extended_word_size_signed, number_of_words, test[1])
        test_value_z_list = integer_to_list(extended_word_size_signed, number_of_words, test[2])
        test_value_zi_list = integer_to_list(extended_word_size_signed, number_of_words, test[3])
        test_value_a24m_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a24m)
        test_value_a24mi_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a24mi)
        test_value_a24p_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a24p)
        test_value_a24pi_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a24pi)
        test_value_e_list = integer_to_list(extended_word_size_signed, number_of_words, test[6])
        
        test_value_x_mont     = enter_montgomery_domain(arithmetic_parameters, test[0])
        test_value_xi_mont    = enter_montgomery_domain(arithmetic_parameters, test[1])
        test_value_z_mont     = enter_montgomery_domain(arithmetic_parameters, test[2])
        test_value_zi_mont    = enter_montgomery_domain(arithmetic_parameters, test[3])
        test_value_a24m_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a24m)
        test_value_a24mi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_a24mi)
        test_value_a24p_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a24p)
        test_value_a24pi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_a24pi)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = xTPLe(arithmetic_parameters, test_value_x_mont, test_value_xi_mont, test_value_z_mont, test_value_zi_mont, test_value_a24m_mont, test_value_a24mi_mont, test_value_a24p_mont, test_value_a24pi_mont, test[6])
        
        test_value_o1 = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_o2 = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        
        test_value_o1_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1))
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1i))
        test_value_o2_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2))
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2i))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_x_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_zi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a24m_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a24mi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a24p_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a24pi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_e_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        
        test_value_e     = randint(1, max_repetition_value-1)
        test_value_x     = randint(1, max_value-1)
        test_value_xi    = randint(1, max_value-1)
        test_value_z     = randint(1, max_value-1)
        test_value_zi    = randint(1, max_value-1)
        test_value_a     = randint(1, max_value-1)
        test_value_ai    = randint(1, max_value-1)
        test_value_a24m  = (test_value_a-2) % prime
        test_value_a24mi = test_value_ai
        test_value_a24p  = (test_value_a+2) % prime
        test_value_a24pi = test_value_ai
            
        
        test_value_x_list     = integer_to_list(extended_word_size_signed, number_of_words, test_value_x)
        test_value_xi_list    = integer_to_list(extended_word_size_signed, number_of_words, test_value_xi)
        test_value_z_list     = integer_to_list(extended_word_size_signed, number_of_words, test_value_z)
        test_value_zi_list    = integer_to_list(extended_word_size_signed, number_of_words, test_value_zi)
        test_value_a24m_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_a24m)
        test_value_a24mi_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a24mi)
        test_value_a24p_list  = integer_to_list(extended_word_size_signed, number_of_words, test_value_a24p)
        test_value_a24pi_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a24pi)
        test_value_e_list     = integer_to_list(extended_word_size_signed, number_of_words, test_value_e)
        
        test_value_x_mont     = enter_montgomery_domain(arithmetic_parameters, test_value_x)
        test_value_xi_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_xi)
        test_value_z_mont     = enter_montgomery_domain(arithmetic_parameters, test_value_z)
        test_value_zi_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_zi)
        test_value_a24m_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a24m)
        test_value_a24mi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_a24mi)
        test_value_a24p_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a24p)
        test_value_a24pi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_a24pi)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont = xTPLe(arithmetic_parameters, test_value_x_mont, test_value_xi_mont, test_value_z_mont, test_value_zi_mont, test_value_a24m_mont, test_value_a24mi_mont, test_value_a24p_mont, test_value_a24pi_mont, test_value_e)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        
        test_value_o1_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1))
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1i))
        test_value_o2_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2))
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2i))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_x_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_xi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_z_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_zi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a24m_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a24mi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a24p_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a24pi_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_e_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    VHDL_memory_file.close()
    
def load_VHDL_xTPLe_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
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
    r.<t0> = fp[]
    fp2.<i> = fp.extension(t0^2+1)
    
    inv_4 = (fp2(4)^(-1)).polynomial()[0]
    inv_4_mont = enter_montgomery_domain(arithmetic_parameters, int(inv_4))
    inv_4_mont_list = integer_to_list(extended_word_size_signed, number_of_words, inv_4_mont)
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
    loaded_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime != prime):
        print("Error in xTPLe computation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error in xTPLe computation : " + str(current_test))
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error in xTPLe computation : " + str(current_test))
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r_mod_prime != r_mod_prime_constant):
        print("Error in xTPLe computation : " + str(current_test))
        print("Error loading the r")
        print("Loaded r")
        print(loaded_r_mod_prime)
        print("Input r")
        print(r_mod_prime_constant)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r2 != r2_constant):
        print("Error in xTPLe computation : " + str(current_test))
        print("Error loading the r2")
        print("Loaded r2")
        print(loaded_r2)
        print("Input r2")
        print(r2_constant)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_1 != 1):
        print("Error in xTPLe computation : " + str(current_test))
        print("Error loading the constant 1")
        print("Loaded constant 1")
        print(loaded_constant_1)
        print("Input constant 1")
        print(1)
    loaded_inv_4_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_inv_4_mont != inv_4_mont):
        print("Error in xTPLe computation : " + str(current_test))
        print("Error loading inversion 4")
        print("Loaded inversion 4")
        print(loaded_inv_4_mont)
        print("Input inversion 4")
        print(inv_4_mont)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in xTPLe computation : " + str(current_test))
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
        test_value_a24m       = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_a24mi      = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_a24p       = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_a24pi      = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_e          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        test_value_x_mont     = enter_montgomery_domain(arithmetic_parameters, test_value_x)
        test_value_xi_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_xi)
        test_value_z_mont     = enter_montgomery_domain(arithmetic_parameters, test_value_z)
        test_value_zi_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_zi)
        test_value_a24m_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a24m)
        test_value_a24mi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_a24mi)
        test_value_a24p_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a24p)
        test_value_a24pi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_a24pi)
        
        computed_test_value_o1_mont, computed_test_value_o1i_mont, computed_test_value_o2_mont, computed_test_value_o2i_mont = xTPLe(arithmetic_parameters, test_value_x_mont, test_value_xi_mont, test_value_z_mont, test_value_zi_mont, test_value_a24m_mont, test_value_a24mi_mont, test_value_a24p_mont, test_value_a24pi_mont, test_value_e)
        
        computed_test_value_o1 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1_mont)
        computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1i_mont)
        computed_test_value_o2 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2_mont)
        computed_test_value_o2i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2i_mont)
        
        if((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i)):
            print("Error in xTPLe computation : " + str(current_test))
            print("Loaded value x")
            print(test_value_x)
            print(test_value_xi)
            print("Loaded value z")
            print(test_value_z)
            print(test_value_zi)
            print("Loaded value a24m")
            print(test_value_a24m)
            print(test_value_a24mi)
            print("Loaded value a24p")
            print(test_value_a24p)
            print(test_value_a24pi)
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
    test_value_a24m       = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_a24mi      = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_a24p       = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_a24pi      = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_e          = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    test_value_x_mont     = enter_montgomery_domain(arithmetic_parameters, test_value_x)
    test_value_xi_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_xi)
    test_value_z_mont     = enter_montgomery_domain(arithmetic_parameters, test_value_z)
    test_value_zi_mont    = enter_montgomery_domain(arithmetic_parameters, test_value_zi)
    test_value_a24m_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a24m)
    test_value_a24mi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_a24mi)
    test_value_a24p_mont  = enter_montgomery_domain(arithmetic_parameters, test_value_a24p)
    test_value_a24pi_mont = enter_montgomery_domain(arithmetic_parameters, test_value_a24pi)
    
    computed_test_value_o1_mont, computed_test_value_o1i_mont, computed_test_value_o2_mont, computed_test_value_o2i_mont = xTPLe(arithmetic_parameters, test_value_x_mont, test_value_xi_mont, test_value_z_mont, test_value_zi_mont, test_value_a24m_mont, test_value_a24mi_mont, test_value_a24p_mont, test_value_a24pi_mont, test_value_e)
    
    computed_test_value_o1 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1_mont)
    computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1i_mont)
    computed_test_value_o2 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2_mont)
    computed_test_value_o2i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2i_mont)
    
        
    if(debug_mode or ((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i))):
        print("Error in xTPLe computation : " + str(current_test))
        print("Loaded value x")
        print(test_value_x)
        print(test_value_xi)
        print("Loaded value z")
        print(test_value_z)
        print(test_value_zi)
        print("Loaded value a24m")
        print(test_value_a24m)
        print(test_value_a24mi)
        print("Loaded value a24p")
        print(test_value_a24p)
        print(test_value_a24pi)
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
    
def test_all_xTPLe(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, max_repetition_values, number_of_tests):
    error_computation = False
    for i in range(len(primes)):
        prime = primes[i]
        max_repetition_value = max_repetition_values[i]
        print("Testing prime : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        error_computation = test_xTPLe(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, max_repetition_value, number_of_tests)
        if(error_computation):
            break
        
def print_all_VHDL_xTPLe_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, max_repetition_values, VHDL_file_names, number_of_tests):
    for i in range(len(primes)):
        prime = primes[i]
        max_repetition_value = max_repetition_values[i]
        VHDL_file_name = VHDL_file_names[i]
        print("Printing prime : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        print_VHDL_xTPLe_test(VHDL_file_name, base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, max_repetition_value, number_of_tests)

def load_all_VHDL_xTPLe_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_file_names):
    for i in range(len(primes)):
        prime = primes[i]
        VHDL_file_name = VHDL_file_names[i]
        print("Loading prime test of : " + str(prime))
        prime_size_bits = int(prime).bit_length()
        load_VHDL_xTPLe_test(VHDL_file_name, base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        
        
number_of_bits_added = 8
base_word_size_signed = 16
extended_word_size_signed = 256
accumulator_word_size = (extended_word_size_signed - 1)*2+32
primes = [2^(4)*3^(3)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1, 2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
max_repetition_values = [11, 11, 11, 11, 11, 11]
primes_file_name_end = ["4_3.dat", "216_137.dat", "250_159.dat", "305_192.dat", "372_239.dat", "486_301.dat"]
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sidh_tests_v257/"
VHDL_xTPLe_file_names = [(tests_working_folder + "xTPLe_test_" + ending) for ending in primes_file_name_end]

#test_all_xTPLe(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, max_repetition_values, 1000)
#print_all_VHDL_xTPLe_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, max_repetition_values, VHDL_xTPLe_file_names, 100)
#load_all_VHDL_xTPLe_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_xTPLe_file_names)