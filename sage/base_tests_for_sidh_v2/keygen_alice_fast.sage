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
load(script_working_folder+"base_tests_for_sidh_basic_procedures/ladder_3_pt.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/xDBLe.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/get_2_isog.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/eval_2_isog.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/get_4_isog.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/eval_4_isog.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/fp2_inv_2_way.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/fp2_inv.sage")
load(script_working_folder+"base_tests_for_sidh_v2/sidh_constants.sage")

def sage_keygen_alice_fast(fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk, oa_bits, splits, max_row, max_int_points, inv_4):
    
    phiPX  = xpb
    phiPXi = xpbi
    phiQX  = xqb
    phiQXi = xqbi
    phiRX  = xrb
    phiRXi = xrbi
    phiPZ  = 1
    phiPZi = 0
    phiQZ  = 1
    phiQZi = 0
    phiRZ  = 1
    phiRZi = 0
    A24plus = 1
    A24plusi = 0
    C24i = 0
    Ai = 0
    A24plus = A24plus + A24plus
    C24  = A24plus + A24plus
    A = C24 + A24plus
    A24plus = C24 + C24
    
    RX, RXi, RZ, RZi = sage_ladder_3_pt(fp2, sk, oa_bits, xpa, xpai, xqa, xqai, xra, xrai, A, Ai, inv_4)
    
    if(oa_bits % 2 == 1):
        SX, SXi, SZ, SZi = sage_xDBLe(fp2, RX, RXi, RZ, RZi, A24plus, A24plusi, C24, C24i, oa_bits-1)
        A24plus, A24plusi, C24, C24i = sage_get_2_isog(fp2, SX, SXi, SZ, SZi)
        phiPX, phiPXi, phiPZ, phiPZi = sage_eval_2_isog(fp2, SX, SXi, SZ, SZi, phiPX, phiPXi, phiPZ, phiPZi)
        phiQX, phiQXi, phiQZ, phiQZi = sage_eval_2_isog(fp2, SX, SXi, SZ, SZi, phiQX, phiQXi, phiQZ, phiQZi)
        phiRX, phiRXi, phiRZ, phiRZi = sage_eval_2_isog(fp2, SX, SXi, SZ, SZi, phiRX, phiRXi, phiRZ, phiRZi)
        RX, RXi, RZ, RZi = sage_eval_2_isog(fp2, SX, SXi, SZ, SZi, RX, RXi, RZ, RZi)
    
    index = 0
    npts = 0
    max_npts = max_int_points
    ptsX  = [0 for i in range(max_int_points)]
    ptsXi = [0 for i in range(max_int_points)]
    ptsZ  = [0 for i in range(max_int_points)]
    ptsZi = [0 for i in range(max_int_points)]
    pts_index = [0 for i in range(max_int_points)]
    ii = 0
    k1  = 0
    k1i = 0
    k2  = 0
    k2i = 0
    k3  = 0
    k3i = 0
    
    for row in range(1, max_row):
        while (index < max_row-row):
            ptsX[npts]  = RX
            ptsXi[npts] = RXi
            ptsZ[npts]  = RZ
            ptsZi[npts] = RZi
            pts_index[npts] = index;
            npts += 1
            m = splits[ii]
            ii += 1
            RX, RXi, RZ, RZi = sage_xDBLe(fp2, RX, RXi, RZ, RZi, A24plus, A24plusi, C24, C24i, (2*m));
            index += m;
            if(npts > max_npts):
                max_npts = npts

        A24plus, A24plusi, C24, C24i, k1, k1i, k2, k2i, k3, k3i = sage_get_4_isog(fp2, RX, RXi, RZ, RZi)
        
        for i in range(npts):
            ptsX[i], ptsXi[i], ptsZ[i], ptsZi[i] = sage_eval_4_isog(fp2, ptsX[i], ptsXi[i], ptsZ[i], ptsZi[i], k1, k1i, k2, k2i, k3, k3i)

        phiPX, phiPXi, phiPZ, phiPZi = sage_eval_4_isog(fp2, phiPX, phiPXi, phiPZ, phiPZi, k1, k1i, k2, k2i, k3, k3i)
        phiQX, phiQXi, phiQZ, phiQZi = sage_eval_4_isog(fp2, phiQX, phiQXi, phiQZ, phiQZi, k1, k1i, k2, k2i, k3, k3i)
        phiRX, phiRXi, phiRZ, phiRZi = sage_eval_4_isog(fp2, phiRX, phiRXi, phiRZ, phiRZi, k1, k1i, k2, k2i, k3, k3i)
        
        RX  = ptsX[npts-1]
        RXi = ptsXi[npts-1]
        RZ  = ptsZ[npts-1]
        RZi = ptsZi[npts-1]
        index = pts_index[npts-1];
        npts -= 1;
        
        
    A24plus, A24plusi, C24, C24i, k1, k1i, k2, k2i, k3, k3i = sage_get_4_isog(fp2, RX, RXi, RZ, RZi)
    phiPX, phiPXi, phiPZ, phiPZi = sage_eval_4_isog(fp2, phiPX, phiPXi, phiPZ, phiPZi, k1, k1i, k2, k2i, k3, k3i)
    phiQX, phiQXi, phiQZ, phiQZi = sage_eval_4_isog(fp2, phiQX, phiQXi, phiQZ, phiQZi, k1, k1i, k2, k2i, k3, k3i)
    phiRX, phiRXi, phiRZ, phiRZi = sage_eval_4_isog(fp2, phiRX, phiRXi, phiRZ, phiRZi, k1, k1i, k2, k2i, k3, k3i)
    
    o = sage_inv_2_way(fp2, phiPZ, phiPZi, phiQZ, phiQZi, phiRZ, phiRZi, 1, 1)
    
    phiPX = (fp2([phiPX, phiPXi])*fp2([o[0], o[1]]))
    phiQX = (fp2([phiQX, phiQXi])*fp2([o[2], o[3]]))
    phiRX = (fp2([phiRX, phiRXi])*fp2([o[4], o[5]]))
    
    fphiPX  = int(phiPX.polynomial()[0])
    fphiPXi = int(phiPX.polynomial()[1])
    fphiQX  = int(phiQX.polynomial()[0])
    fphiQXi = int(phiQX.polynomial()[1])
    fphiRX  = int(phiRX.polynomial()[0])
    fphiRXi = int(phiRX.polynomial()[1])
    
    return fphiPX, fphiPXi, fphiQX, fphiQXi, fphiRX, fphiRXi
    
def keygen_alice_fast(arithmetic_parameters, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk, oa_bits, splits, max_row, max_int_points, inv_4):
    extended_word_size_signed = arithmetic_parameters[0]
    number_of_words = arithmetic_parameters[9]
    
    const_r = arithmetic_parameters[12]
    
    Ai     = 0
    phiPX  = xpb
    phiPXi = xpbi
    phiQX  = xqb
    phiQXi = xqbi
    phiRX  = xrb
    phiRXi = xrbi
    phiPZ  = const_r
    phiPZi = 0
    phiQZ  = const_r
    phiQZi = 0
    phiRZ  = const_r
    phiRZi = 0
    A24plusi = 0
    C24i = 0
    
    ma =     [ const_r, 0, 0, 0]
    mb =     [ const_r, 0, 0, 0]
    sign_a = [       1, 0, 0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    A24plus = mo[0]
    ma =     [ A24plus, 0, 0, 0]
    mb =     [ A24plus, 0, 0, 0]
    sign_a = [       1, 0, 0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    C24 = mo[0]
    ma =     [ C24,     C24, 0, 0]
    mb =     [ A24plus, C24, 0, 0]
    sign_a = [       1,   1, 0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    A = mo[0]
    A24plus = mo[1]
    
    RX, RXi, RZ, RZi = ladder_3_pt(arithmetic_parameters, sk, oa_bits, xpa, xpai, xqa, xqai, xra, xrai, A, Ai, inv_4)
    
    if((oa_bits & 1) == 1):
        SX, SXi, SZ, SZi = xDBLe(arithmetic_parameters, RX, RXi, RZ, RZi, A24plus, A24plusi, C24, C24i, oa_bits-1)
        A24plus, A24plusi, C24, C24i = get_2_isog(arithmetic_parameters, SX, SXi, SZ, SZi)
        phiPX, phiPXi, phiPZ, phiPZi = eval_2_isog(arithmetic_parameters, SX, SXi, SZ, SZi, phiPX, phiPXi, phiPZ, phiPZi)
        phiQX, phiQXi, phiQZ, phiQZi = eval_2_isog(arithmetic_parameters, SX, SXi, SZ, SZi, phiQX, phiQXi, phiQZ, phiQZi)
        phiRX, phiRXi, phiRZ, phiRZi = eval_2_isog(arithmetic_parameters, SX, SXi, SZ, SZi, phiRX, phiRXi, phiRZ, phiRZi)
        RX, RXi, RZ, RZi = eval_2_isog(arithmetic_parameters, SX, SXi, SZ, SZi, RX, RXi, RZ, RZi)
    
    
    index = 0
    npts = 0
    ii = 0
    ptsX  = [0 for i in range(max_int_points)]
    ptsXi = [0 for i in range(max_int_points)]
    ptsZ  = [0 for i in range(max_int_points)]
    ptsZi = [0 for i in range(max_int_points)]
    pts_index = [0 for i in range(max_int_points)]
    
    for row in range(1, max_row):
        while (index < max_row-row):
            ptsX[npts]  = RX
            ptsXi[npts] = RXi
            ptsZ[npts]  = RZ
            ptsZi[npts] = RZi
            pts_index[npts] = index;
            npts += 1
            m = splits[ii]
            ii += 1
            double_m = m+m
            index += m;
            RX, RXi, RZ, RZi = xDBLe(arithmetic_parameters, RX, RXi, RZ, RZi, A24plus, A24plusi, C24, C24i, double_m);
            
        
        A24plus, A24plusi, C24, C24i, k1, k1i, k2, k2i, k3, k3i = get_4_isog(arithmetic_parameters, RX, RXi, RZ, RZi)
        
        for i in range(npts):
            ptsX[i], ptsXi[i], ptsZ[i], ptsZi[i] = eval_4_isog(arithmetic_parameters, ptsX[i], ptsXi[i], ptsZ[i], ptsZi[i], k1, k1i, k2, k2i, k3, k3i)
        
            
        phiPX, phiPXi, phiPZ, phiPZi = eval_4_isog(arithmetic_parameters, phiPX, phiPXi, phiPZ, phiPZi, k1, k1i, k2, k2i, k3, k3i)
        phiQX, phiQXi, phiQZ, phiQZi = eval_4_isog(arithmetic_parameters, phiQX, phiQXi, phiQZ, phiQZi, k1, k1i, k2, k2i, k3, k3i)
        phiRX, phiRXi, phiRZ, phiRZi = eval_4_isog(arithmetic_parameters, phiRX, phiRXi, phiRZ, phiRZi, k1, k1i, k2, k2i, k3, k3i)
        
        npts -= 1;
        RX  = ptsX[npts]
        RXi = ptsXi[npts]
        RZ  = ptsZ[npts]
        RZi = ptsZi[npts]
        index = pts_index[npts];
        
        
    A24plus, A24plusi, C24, C24i, k1, k1i, k2, k2i, k3, k3i = get_4_isog(arithmetic_parameters, RX, RXi, RZ, RZi)
    phiPX, phiPXi, phiPZ, phiPZi = eval_4_isog(arithmetic_parameters, phiPX, phiPXi, phiPZ, phiPZi, k1, k1i, k2, k2i, k3, k3i)
    phiQX, phiQXi, phiQZ, phiQZi = eval_4_isog(arithmetic_parameters, phiQX, phiQXi, phiQZ, phiQZi, k1, k1i, k2, k2i, k3, k3i)
    phiRX, phiRXi, phiRZ, phiRZi = eval_4_isog(arithmetic_parameters, phiRX, phiRXi, phiRZ, phiRZi, k1, k1i, k2, k2i, k3, k3i)
    
    o = inv_2_way(arithmetic_parameters, phiPZ, phiPZi, phiQZ, phiQZi, phiRZ, phiRZi, const_r, const_r)
    
    inv_phiPZ  = o[0]
    inv_phiPZi = o[1]
    inv_phiQZ  = o[2]
    inv_phiQZi = o[3]
    inv_phiRZ  = o[4]
    inv_phiRZi = o[5]
    
    ma = [inv_phiPZi, inv_phiPZ, inv_phiPZ, inv_phiPZi, inv_phiQZi, inv_phiQZ, inv_phiQZ, inv_phiQZi]
    mb = [     phiPX,    phiPXi,     phiPX,     phiPXi,      phiQX,    phiQXi,     phiQX,     phiQXi]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    phiPXi = mo[0]
    phiPX  = mo[1]
    phiQXi = mo[2]
    phiQX  = mo[3]
    
    ma = [inv_phiRZi, inv_phiRZ, inv_phiRZ, inv_phiRZi, 0, 0, 0, 0]
    mb = [     phiRX,    phiRXi,     phiRX,     phiRXi, 0, 0, 0, 0]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    phiRXi = mo[0]
    phiRX  = mo[1]
    
    
    return phiPX, phiPXi, phiQX, phiQXi, phiRX, phiRXi

def test_single_keygen_alice_fast(arithmetic_parameters, fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk, oa_bits, splits, max_row, max_int_points, debug=False):
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
    
    test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont, test_value_o3_mont, test_value_o3i_mont = keygen_alice_fast(arithmetic_parameters, test_value_xpa_mont, test_value_xpai_mont, test_value_xqa_mont, test_value_xqai_mont, test_value_xra_mont, test_value_xrai_mont, test_value_xpb_mont, test_value_xpbi_mont, test_value_xqb_mont, test_value_xqbi_mont, test_value_xrb_mont, test_value_xrbi_mont, sk, oa_bits, splits, max_row, max_int_points, inv_4_mont)
    
    test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
    test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
    test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
    test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
    test_value_o3  = remove_montgomery_domain(arithmetic_parameters, test_value_o3_mont)
    test_value_o3i = remove_montgomery_domain(arithmetic_parameters, test_value_o3i_mont)
    test_value_final_phiPX  = iterative_reduction(arithmetic_parameters, test_value_o1)
    test_value_final_phiPXi = iterative_reduction(arithmetic_parameters, test_value_o1i)
    test_value_final_phiQX  = iterative_reduction(arithmetic_parameters, test_value_o2)
    test_value_final_phiQXi = iterative_reduction(arithmetic_parameters, test_value_o2i)
    test_value_final_phiRX  = iterative_reduction(arithmetic_parameters, test_value_o3)
    test_value_final_phiRXi = iterative_reduction(arithmetic_parameters, test_value_o3i)
    
    true_value_final_phiPX, true_value_final_phiPXi, true_value_final_phiQX, true_value_final_phiQXi, true_value_final_phiRX, true_value_final_phiRXi = sage_keygen_alice_fast(fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk, oa_bits, splits, max_row, max_int_points, inv_4)
    
    if((debug) or (test_value_final_phiPX != true_value_final_phiPX) or (test_value_final_phiPXi != true_value_final_phiPXi) or (test_value_final_phiQX != true_value_final_phiQX) or (test_value_final_phiQXi != true_value_final_phiQXi) or (test_value_final_phiRX != true_value_final_phiRX) or (test_value_final_phiRXi != true_value_final_phiRXi)):
        print("Error in key generation Alice ")
        print('')
        print("Prime")
        print(prime)
        print('')
        print("Value sk_alice")
        print(sk)
        print("Value oa_bits")
        print(oa_bits)
        print('')
        print("Test phiPX")
        print(test_value_final_phiPX)
        print(test_value_final_phiPXi)
        print('')
        print("True phiPX")
        print(true_value_final_phiPX)
        print(true_value_final_phiPXi)
        print('')
        print("Test phiQX")
        print(test_value_final_phiQX)
        print(test_value_final_phiQXi)
        print('')
        print("True phiQX")
        print(true_value_final_phiQX)
        print(true_value_final_phiQXi)
        print('')
        print("Test phiRX")
        print(test_value_final_phiRX)
        print(test_value_final_phiRXi)
        print('')
        print("True phiRX")
        print(true_value_final_phiRX)
        print(true_value_final_phiRXi)
        print('')
        return True

    return False
    
def test_keygen_alice_fast(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, la, oa, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, splits, max_row, max_int_points, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
    
    oa_bits = int(oa-1).bit_length()
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [0, oa-1]
    for test in fixed_tests:
        sk_alice = test
        error_computation = test_single_keygen_alice_fast(arithmetic_parameters, fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_alice, oa_bits, splits, max_row, max_int_points)
        tests_already_performed += 1
        if(error_computation):
            break
            
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print i
            sk_alice = randint(0, oa-1)
    
            error_computation = test_single_keygen_alice_fast(arithmetic_parameters, fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_alice, oa_bits, splits, max_row, max_int_points)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_keygen_alice_fast_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, la, oa, lb, ob, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, number_of_tests):
    
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
    fixed_tests = [0, oa-1]
    for test in fixed_tests:
        sk_alice = test
        
        test_value_sk_alice_list  = integer_to_list(extended_word_size_signed, number_of_words, sk_alice)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont, test_value_o3_mont, test_value_o3i_mont = keygen_alice_fast(arithmetic_parameters, test_value_xpa_mont, test_value_xpai_mont, test_value_xqa_mont, test_value_xqai_mont, test_value_xra_mont, test_value_xrai_mont, test_value_xpb_mont, test_value_xpbi_mont, test_value_xqb_mont, test_value_xqbi_mont, test_value_xrb_mont, test_value_xrbi_mont, sk_alice, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4_mont)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        test_value_o3  = remove_montgomery_domain(arithmetic_parameters, test_value_o3_mont)
        test_value_o3i = remove_montgomery_domain(arithmetic_parameters, test_value_o3i_mont)
        
        test_value_o1_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1))
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1i))
        test_value_o2_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2))
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2i))
        test_value_o3_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o3))
        test_value_o3i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o3i))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_sk_alice_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o3_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o3i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        
        sk_alice = randint(0, oa-1)
    
        test_value_sk_alice_list  = integer_to_list(extended_word_size_signed, number_of_words, sk_alice)
        
        test_value_o1_mont, test_value_o1i_mont, test_value_o2_mont, test_value_o2i_mont, test_value_o3_mont, test_value_o3i_mont = keygen_alice_fast(arithmetic_parameters, test_value_xpa_mont, test_value_xpai_mont, test_value_xqa_mont, test_value_xqai_mont, test_value_xra_mont, test_value_xrai_mont, test_value_xpb_mont, test_value_xpbi_mont, test_value_xqb_mont, test_value_xqbi_mont, test_value_xrb_mont, test_value_xrbi_mont, sk_alice, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4_mont)
        
        test_value_o1  = remove_montgomery_domain(arithmetic_parameters, test_value_o1_mont)
        test_value_o1i = remove_montgomery_domain(arithmetic_parameters, test_value_o1i_mont)
        test_value_o2  = remove_montgomery_domain(arithmetic_parameters, test_value_o2_mont)
        test_value_o2i = remove_montgomery_domain(arithmetic_parameters, test_value_o2i_mont)
        test_value_o3  = remove_montgomery_domain(arithmetic_parameters, test_value_o3_mont)
        test_value_o3i = remove_montgomery_domain(arithmetic_parameters, test_value_o3i_mont)
        
        test_value_o1_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1))
        test_value_o1i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1i))
        test_value_o2_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2))
        test_value_o2i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2i))
        test_value_o3_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o3))
        test_value_o3i_list = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o3i))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_sk_alice_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2i_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o3_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o3i_list, maximum_number_of_words)
        tests_already_performed += 1
        
    VHDL_memory_file.close()
    
def load_VHDL_keygen_alice_fast_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
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
        print("Error in keygen Alice fast computation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error in keygen Alice fast computation : " + str(current_test))
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error in keygen Alice fast computation : " + str(current_test))
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r_mod_prime != r_mod_prime_constant):
        print("Error in keygen Alice fast computation : " + str(current_test))
        print("Error loading the r")
        print("Loaded r")
        print(loaded_r_mod_prime)
        print("Input r")
        print(r_mod_prime_constant)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r2 != r2_constant):
        print("Error in keygen Alice fast computation : " + str(current_test))
        print("Error loading the r2")
        print("Loaded r2")
        print(loaded_r2)
        print("Input r2")
        print(r2_constant)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_1 != 1):
        print("Error in keygen Alice fast computation : " + str(current_test))
        print("Error loading the constant 1")
        print("Loaded constant 1")
        print(loaded_constant_1)
        print("Input constant 1")
        print(1)
    loaded_constant_inv_4 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_inv_4 != inv_4_mont):
        print("Error in keygen Alice fast computation : " + str(current_test))
        print("Error loading the inversion 4")
        print("Loaded inversion 4")
        print(loaded_constant_inv_4)
        print("Input inversion 4")
        print(inv_4_mont)
    loaded_oa_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_ob_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in keygen Alice fast computation : " + str(current_test))
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
        
        loaded_sk             = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        computed_test_value_o1_mont, computed_test_value_o1i_mont, computed_test_value_o2_mont, computed_test_value_o2i_mont, computed_test_value_o3_mont, computed_test_value_o3i_mont = keygen_alice_fast(arithmetic_parameters, test_value_xpa_mont, test_value_xpai_mont, test_value_xqa_mont, test_value_xqai_mont, test_value_xra_mont, test_value_xrai_mont, test_value_xpb_mont, test_value_xpbi_mont, test_value_xqb_mont, test_value_xqbi_mont, test_value_xrb_mont, test_value_xrbi_mont, loaded_sk, loaded_oa_bits, loaded_splits_alice, loaded_max_row_alice, 12, loaded_constant_inv_4)
        
        computed_test_value_o1 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1_mont)
        computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1i_mont)
        computed_test_value_o2 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2_mont)
        computed_test_value_o2i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2i_mont)
        computed_test_value_o3 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o3_mont)
        computed_test_value_o3i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o3i_mont)
        
        if((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i) or (computed_test_value_o3 != loaded_test_value_o3) or (computed_test_value_o3i != loaded_test_value_o3i)):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print("Loaded sk")
            print(loaded_sk)
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
        current_test += 1
    
    loaded_sk             = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    computed_test_value_o1_mont, computed_test_value_o1i_mont, computed_test_value_o2_mont, computed_test_value_o2i_mont, computed_test_value_o3_mont, computed_test_value_o3i_mont = keygen_alice_fast(arithmetic_parameters, test_value_xpa_mont, test_value_xpai_mont, test_value_xqa_mont, test_value_xqai_mont, test_value_xra_mont, test_value_xrai_mont, test_value_xpb_mont, test_value_xpbi_mont, test_value_xqb_mont, test_value_xqbi_mont, test_value_xrb_mont, test_value_xrbi_mont, loaded_sk, loaded_oa_bits, loaded_splits_alice, loaded_max_row_alice, 12, loaded_constant_inv_4)
    
    computed_test_value_o1 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1_mont)
    computed_test_value_o1i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o1i_mont)
    computed_test_value_o2 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2_mont)
    computed_test_value_o2i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o2i_mont)
    computed_test_value_o3 = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o3_mont)
    computed_test_value_o3i = remove_montgomery_domain(arithmetic_parameters, computed_test_value_o3i_mont)
        
    if(debug_mode or ((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i) or (computed_test_value_o3 != loaded_test_value_o3) or (computed_test_value_o3i != loaded_test_value_o3i))):
        print("Error in keygen Alice fast computation : " + str(current_test))
        print("Loaded sk")
        print(loaded_sk)
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
    
    VHDL_memory_file.close()
    
    
def test_all_keygen_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_params):
    error_computation = False
    for param in sidh_params:
        print("Testing key generation " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        error_computation = test_keygen_alice_fast(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, param[4], param[2]**param[4], param[6], param[7], param[8], param[9], param[10], param[11], param[12], param[13], param[14], param[15], param[16], param[17], param[18], param[19], param[20], number_of_tests)
        if error_computation:
            break;

def print_all_keygen_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_params, VHDL_file_names):
    for i, param in enumerate(sidh_params):
        print("Printing key generation " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        VHDL_memory_file_name = VHDL_file_names[i]
        tests_working_folder + "keygen_alice_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat"
        print_VHDL_keygen_alice_fast_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, param[4], param[2]**param[4], param[5], param[3]**param[5], param[6], param[7], param[8], param[9], param[10], param[11], param[12], param[13], param[14], param[15], param[16], param[17], param[18], param[21], param[19], param[22], param[20], param[23], number_of_tests)

def load_all_keygen_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_params, VHDL_file_names):
    error_computation = False
    for i, param in enumerate(sidh_params):
        print("Loading key generation " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        VHDL_memory_file_name = VHDL_file_names[i]
        error_computation = load_VHDL_keygen_alice_fast_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        if error_computation:
            break;


number_of_bits_added = 8
base_word_size = 16
extended_word_size = 256
accumulator_word_size = extended_word_size_signed*2+32
number_of_tests = 10
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sidh_tests_v257/"


#number_of_bits_added = 8
#base_word_size = 16
#extended_word_size = 128
#accumulator_word_size = extended_word_size_signed*2+32
#number_of_tests = 10
#tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sidh_tests_v129/"

VHDL_file_names = [tests_working_folder + "keygen_alice_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]

#test_all_keygen_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
#print_all_keygen_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
#load_all_keygen_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)


#param = sidh_constants[2]
#print("Loading key generation " +  param[0])
#prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
#prime_size_bits = int(prime).bit_length()
#VHDL_memory_file_name = tests_working_folder + "keygen_alice_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat"
#error_computation = load_VHDL_keygen_alice_fast_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, 10, False)