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
load(script_working_folder+"base_tests_for_sidh_v2/keygen_alice_fast.sage")
load(script_working_folder+"base_tests_for_sidh_v2/keygen_bob_fast.sage")
load(script_working_folder+"base_tests_for_sidh_v2/shared_secret_alice_fast.sage")
load(script_working_folder+"base_tests_for_sidh_v2/shared_secret_bob_fast.sage")
load(script_working_folder+"base_tests_for_sidh_v2/sidh_constants.sage")

def test_single_key_exchange(arithmetic_parameters, fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_alice, sk_bob, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, debug=False):
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
    
    true_pk_alice_phiPX, true_pk_alice_phiPXi, true_pk_alice_phiQX, true_pk_alice_phiQXi, true_pk_alice_phiRX, true_pk_alice_phiRXi = sage_keygen_alice_fast(fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_alice, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4)
    true_pk_bob_phiPX, true_pk_bob_phiPXi, true_pk_bob_phiQX, true_pk_bob_phiQXi, true_pk_bob_phiRX, true_pk_bob_phiRXi = sage_keygen_bob_fast(fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_bob, ob_bits, splits_bob, max_row_bob, max_int_points_bob, inv_4)
    true_alice_j_invar, true_alice_j_invar_i = sage_shared_secret_alice_fast(fp2, true_pk_bob_phiPX, true_pk_bob_phiPXi, true_pk_bob_phiQX, true_pk_bob_phiQXi, true_pk_bob_phiRX, true_pk_bob_phiRXi, sk_alice, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4)
    true_bob_j_invar, true_bob_j_invar_i = sage_shared_secret_bob_fast(fp2, true_pk_alice_phiPX, true_pk_alice_phiPXi, true_pk_alice_phiQX, true_pk_alice_phiQXi, true_pk_alice_phiRX, true_pk_alice_phiRXi, sk_bob, ob_bits, splits_bob, max_row_bob, max_int_points_bob, inv_4)
    
    if((debug) or (true_alice_j_invar != true_bob_j_invar) or (true_alice_j_invar_i != true_bob_j_invar_i)):
        print("Error in key exchange ")
        print('')
        print("Prime")
        print(prime)
        print('')
        print("Value sk_alice")
        print(sk_alice)
        print("Value sk_bob")
        print(sk_bob)
        print('')
        print("PK Alice")
        print(true_pk_alice_phiPX)
        print(true_pk_alice_phiPXi)
        print(true_pk_alice_phiQX)
        print(true_pk_alice_phiQXi)
        print(true_pk_alice_phiRX)
        print(true_pk_alice_phiRXi)
        print("PK Bob")
        print(true_pk_bob_phiPX)
        print(true_pk_bob_phiPXi)
        print(true_pk_bob_phiQX)
        print(true_pk_bob_phiQXi)
        print(true_pk_bob_phiRX)
        print(true_pk_bob_phiRXi)
        print('')
        print("Value j invariant Alice")
        print(true_alice_j_invar)
        print(true_alice_j_invar_i)
        print("Value j invariant Bob")
        print(true_bob_j_invar)
        print(true_bob_j_invar_i)
        print('')
        
        return True

    return False

def test_key_exchange(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, oa, ob, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    fp = GF(prime)
    r.<x> = fp[]
    fp2.<i> = fp.extension(x^2+1)
    
    oa_bits = int(oa-1).bit_length()
    ob_bits = int(ob-1).bit_length()
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [[0,0],[oa-1,0],[0,ob-1],[oa-1,ob-1]]
    for test in fixed_tests:
        sk_alice = test[0]
        sk_bob   = test[1]
        error_computation = test_single_key_exchange(arithmetic_parameters, fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_alice, sk_bob, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob)
        tests_already_performed += 1
        if(error_computation):
            break
            
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print i
            sk_alice = randint(0, oa-1)
            sk_bob = randint(0, ob-1)
    
            error_computation = test_single_key_exchange(arithmetic_parameters, fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk_alice, sk_bob, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob)
            if(error_computation):
                break
        
    return error_computation

def test_all_key_exchange(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_params):
    error_computation = False
    for param in sidh_params:
        print("Testing key generation " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        error_computation = test_key_exchange(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, param[2]**param[4], param[3]**param[5], param[6], param[7], param[8], param[9], param[10], param[11], param[12], param[13], param[14], param[15], param[16], param[17], param[18], param[21], param[19], param[22], param[20], param[23], number_of_tests)
        if error_computation:
            break;

number_of_bits_added = 8
base_word_size = 16
extended_word_size = 256
accumulator_word_size = extended_word_size_signed*2+32
number_of_tests = 10

#number_of_bits_added = 8
#base_word_size = 16
#extended_word_size = 128
#accumulator_word_size = extended_word_size_signed*2+32
#number_of_tests = 10

test_all_key_exchange(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)