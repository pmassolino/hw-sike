proof.arithmetic(False)
home_folder = "/home/pedro/"
script_working_folder = home_folder + "hw-sidh/vhdl_project/sage/"
load(script_working_folder+"base_tests_for_sidh_v2/all_sidh_functions.sage")

def bytearray_to_int(value):
    int_value = 0
    multiplication_factor = 1
    for each_byte in value:
        int_value += each_byte*multiplication_factor
        multiplication_factor *= 256
    return int_value

def int_to_bytearray(value, byte_length=0):
    value_byte_length = (int(value).bit_length()+7)//8
    if(value_byte_length == 0):
        value_byte_length = 1
    if(value_byte_length > byte_length):
        final_bytearray = bytearray.fromhex((("{:0" + str(2*value_byte_length) + "x}").format(value)))[::-1]
        if(byte_length != 0):
            final_bytearray = final_bytearray[:(2*byte_length)]
    else:
        final_bytearray = bytearray.fromhex((("{:0" + str(2*byte_length) + "x}").format(value)))[::-1]
    return final_bytearray

def sage_keygen_sike(fp2, sike_s, sike_sk, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, inv_4):
    
    sike_pk_phiPX, sike_pk_phiPXi, sike_pk_phiQX, sike_pk_phiQXi, sike_pk_phiRX, sike_pk_phiRXi = sage_keygen_bob_fast(fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sike_sk, ob_bits, splits_bob, max_row_bob, max_int_points_bob, inv_4)
    
    return sike_s, sike_sk, sike_pk_phiPX, sike_pk_phiPXi, sike_pk_phiQX, sike_pk_phiQXi, sike_pk_phiRX, sike_pk_phiRXi

def keygen_sike(arithmetic_parameters, sike_s, sike_sk, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, inv_4):
    extended_word_size_signed = arithmetic_parameters[0]
    number_of_words = arithmetic_parameters[9]
    
    const_r = arithmetic_parameters[12]
    
    sike_pk_phiPX_mont, sike_pk_phiPXi_mont, sike_pk_phiQX_mont, sike_pk_phiQXi_mont, sike_pk_phiRX_mont, sike_pk_phiRXi_mont = keygen_bob_fast(arithmetic_parameters, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sike_sk, ob_bits, splits_bob, max_row_bob, max_int_points_bob, inv_4)
    
    sike_pk_phiPX   = remove_montgomery_domain(arithmetic_parameters, sike_pk_phiPX_mont)
    sike_pk_phiPXi  = remove_montgomery_domain(arithmetic_parameters, sike_pk_phiPXi_mont)
    sike_pk_phiQX   = remove_montgomery_domain(arithmetic_parameters, sike_pk_phiQX_mont)
    sike_pk_phiQXi  = remove_montgomery_domain(arithmetic_parameters, sike_pk_phiQXi_mont)
    sike_pk_phiRX   = remove_montgomery_domain(arithmetic_parameters, sike_pk_phiRX_mont)
    sike_pk_phiRXi  = remove_montgomery_domain(arithmetic_parameters, sike_pk_phiRXi_mont)
    
    sike_pk_phiPX   = iterative_reduction(arithmetic_parameters, sike_pk_phiPX)
    sike_pk_phiPXi  = iterative_reduction(arithmetic_parameters, sike_pk_phiPXi)
    sike_pk_phiQX   = iterative_reduction(arithmetic_parameters, sike_pk_phiQX)
    sike_pk_phiQXi  = iterative_reduction(arithmetic_parameters, sike_pk_phiQXi)
    sike_pk_phiRX   = iterative_reduction(arithmetic_parameters, sike_pk_phiRX)
    sike_pk_phiRXi  = iterative_reduction(arithmetic_parameters, sike_pk_phiRXi)
    
    return sike_s, sike_sk, sike_pk_phiPX, sike_pk_phiPXi, sike_pk_phiQX, sike_pk_phiQXi, sike_pk_phiRX, sike_pk_phiRXi

def sage_enc_sike(fp2, sike_m, prime_str_length, message_length, shared_secret_length, sike_pk_phiPX, sike_pk_phiPXi, sike_pk_phiQX, sike_pk_phiQXi, sike_pk_phiRX, sike_pk_phiRXi, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, inv_4):
    
    temp_pk = bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiPX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiPXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiQX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiQXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiRX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiRXi)))[::-1]
    temp = sike_m + temp_pk
    ephemeral_sk = SHAKE256(temp, (oa_bits+7)//8)
    ephemeral_sk = bytearray_to_int(ephemeral_sk)
    ephemeral_sk = ephemeral_sk % (2**(oa_bits+1))
    sike_c0_phiPX, sike_c0_phiPXi, sike_c0_phiQX, sike_c0_phiQXi, sike_c0_phiRX, sike_c0_phiRXi = sage_keygen_alice_fast(fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, ephemeral_sk, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4)
    sike_j_invar, sike_j_invar_i = sage_shared_secret_alice_fast(fp2, sike_pk_phiPX, sike_pk_phiPXi, sike_pk_phiQX, sike_pk_phiQXi, sike_pk_phiRX, sike_pk_phiRXi, ephemeral_sk, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4)
    temp = bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_j_invar)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_j_invar_i)))[::-1]
    sike_h = SHAKE256(temp, message_length)
    sike_c1 = bytearray([sike_m[i] ^^ sike_h[i] for i in range(message_length)])
    temp_c0 = bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiPX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiPXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiQX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiQXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiRX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiRXi)))[::-1]
    temp = sike_m + temp_c0 + sike_c1
    sike_ss = SHAKE256(temp, shared_secret_length)
    
    return sike_ss, sike_c0_phiPX, sike_c0_phiPXi, sike_c0_phiQX, sike_c0_phiQXi, sike_c0_phiRX, sike_c0_phiRXi, sike_c1
    
def enc_sike(arithmetic_parameters, sike_m, prime_str_length, message_length, shared_secret_length, sike_pk_phiPX, sike_pk_phiPXi, sike_pk_phiQX, sike_pk_phiQXi, sike_pk_phiRX, sike_pk_phiRXi, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, inv_4):
    extended_word_size_signed = arithmetic_parameters[0]
    number_of_words = arithmetic_parameters[9]
    
    const_r = arithmetic_parameters[12]
    const_r2 = arithmetic_parameters[14]
    
    sike_pk_phiPX_mont  = enter_montgomery_domain(arithmetic_parameters, sike_pk_phiPX)
    sike_pk_phiPXi_mont = enter_montgomery_domain(arithmetic_parameters, sike_pk_phiPXi)
    sike_pk_phiRX_mont  = enter_montgomery_domain(arithmetic_parameters, sike_pk_phiRX)
    sike_pk_phiRXi_mont = enter_montgomery_domain(arithmetic_parameters, sike_pk_phiRXi)
    sike_pk_phiQX_mont  = enter_montgomery_domain(arithmetic_parameters, sike_pk_phiQX) 
    sike_pk_phiQXi_mont = enter_montgomery_domain(arithmetic_parameters, sike_pk_phiQXi)
    
    temp_pk = bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiPX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiPXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiQX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiQXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiRX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiRXi)))[::-1]
    temp = sike_m + temp_pk
    ephemeral_sk = SHAKE256(temp, (oa_bits+7)//8)
    ephemeral_sk = bytearray_to_int(ephemeral_sk)
    ephemeral_sk = ephemeral_sk % (2**(oa_bits+1))
    
    sike_c0_phiPX_mont, sike_c0_phiPXi_mont, sike_c0_phiQX_mont, sike_c0_phiQXi_mont, sike_c0_phiRX_mont, sike_c0_phiRXi_mont = keygen_alice_fast(arithmetic_parameters, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, ephemeral_sk, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4)
    
    sike_j_invar_mont, sike_j_invar_i_mont = shared_secret_alice_fast(arithmetic_parameters, sike_pk_phiPX_mont, sike_pk_phiPXi_mont, sike_pk_phiQX_mont, sike_pk_phiQXi_mont, sike_pk_phiRX_mont, sike_pk_phiRXi_mont, ephemeral_sk, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4)
    
    sike_j_invar    = remove_montgomery_domain(arithmetic_parameters, sike_j_invar_mont)
    sike_j_invar_i  = remove_montgomery_domain(arithmetic_parameters, sike_j_invar_i_mont)
    sike_c0_phiPX   = remove_montgomery_domain(arithmetic_parameters, sike_c0_phiPX_mont)
    sike_c0_phiPXi  = remove_montgomery_domain(arithmetic_parameters, sike_c0_phiPXi_mont)
    sike_c0_phiQX   = remove_montgomery_domain(arithmetic_parameters, sike_c0_phiQX_mont)
    sike_c0_phiQXi  = remove_montgomery_domain(arithmetic_parameters, sike_c0_phiQXi_mont)
    sike_c0_phiRX   = remove_montgomery_domain(arithmetic_parameters, sike_c0_phiRX_mont)
    sike_c0_phiRXi  = remove_montgomery_domain(arithmetic_parameters, sike_c0_phiRXi_mont)
    
    sike_j_invar    = iterative_reduction(arithmetic_parameters, sike_j_invar)
    sike_j_invar_i  = iterative_reduction(arithmetic_parameters, sike_j_invar_i)
    sike_c0_phiPX   = iterative_reduction(arithmetic_parameters, sike_c0_phiPX)
    sike_c0_phiPXi  = iterative_reduction(arithmetic_parameters, sike_c0_phiPXi)
    sike_c0_phiQX   = iterative_reduction(arithmetic_parameters, sike_c0_phiQX)
    sike_c0_phiQXi  = iterative_reduction(arithmetic_parameters, sike_c0_phiQXi)
    sike_c0_phiRX   = iterative_reduction(arithmetic_parameters, sike_c0_phiRX)
    sike_c0_phiRXi  = iterative_reduction(arithmetic_parameters, sike_c0_phiRXi)
    
    temp = bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_j_invar)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_j_invar_i)))[::-1]
    sike_h = SHAKE256(temp, message_length)
    sike_c1 = bytearray([sike_m[i] ^^ sike_h[i] for i in range(message_length)])
    
    temp_c0 = bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiPX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiPXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiQX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiQXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiRX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiRXi)))[::-1]
    temp = sike_m + temp_c0 + sike_c1
    sike_ss = SHAKE256(temp, shared_secret_length)
    
    return sike_ss, sike_c0_phiPX, sike_c0_phiPXi, sike_c0_phiQX, sike_c0_phiQXi, sike_c0_phiRX, sike_c0_phiRXi, sike_c1

def sage_dec_sike(fp2, sike_s, sike_sk, prime_str_length, message_length, shared_secret_length, sike_pk_phiPX, sike_pk_phiPXi, sike_pk_phiQX, sike_pk_phiQXi, sike_pk_phiRX, sike_pk_phiRXi, sike_c0_phiPX, sike_c0_phiPXi, sike_c0_phiQX, sike_c0_phiQXi, sike_c0_phiRX, sike_c0_phiRXi, sike_c1, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, inv_4):
    
    sike_j_invar, sike_j_invar_i = sage_shared_secret_bob_fast(fp2, sike_c0_phiPX, sike_c0_phiPXi, sike_c0_phiQX, sike_c0_phiQXi, sike_c0_phiRX, sike_c0_phiRXi, sike_sk, ob_bits, splits_bob, max_row_bob, max_int_points_bob, inv_4)
    temp = bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_j_invar)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_j_invar_i)))[::-1]
    sike_h = SHAKE256(temp, message_length)
    sike_m = bytearray([sike_c1[i] ^^ sike_h[i] for i in range(message_length)])
    temp_pk = bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiPX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiPXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiQX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiQXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiRX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiRXi)))[::-1]
    temp = sike_m + temp_pk
    ephemeral_sk = SHAKE256(temp, (oa_bits+7)//8)
    ephemeral_sk = bytearray_to_int(ephemeral_sk)
    ephemeral_sk = ephemeral_sk % (2**(oa_bits+1))
    temp_c0 = bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiPX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiPXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiQX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiQXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiRX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiRXi)))[::-1]
    sike_c02_phiPX, sike_c02_phiPXi, sike_c02_phiQX, sike_c02_phiQXi, sike_c02_phiRX, sike_c02_phiRXi = sage_keygen_alice_fast(fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, ephemeral_sk, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4)
    if((sike_c02_phiPX != sike_c0_phiPX) or (sike_c02_phiPXi != sike_c0_phiPXi) or (sike_c02_phiRX != sike_c0_phiRX) or (sike_c02_phiRXi != sike_c0_phiRXi) or (sike_c02_phiQX != sike_c0_phiQX) or (sike_c02_phiQXi != sike_c0_phiQXi)):
        print('Should not be here')
        print(ephemeral_sk)
        print('')
        print(sike_c0_phiPX)
        print(sike_c02_phiPX)
        print('')
        print(sike_c0_phiPXi)
        print(sike_c02_phiPXi)
        print('')
        print(sike_c0_phiQX)
        print(sike_c02_phiQX)
        print('')
        print(sike_c0_phiQXi)
        print(sike_c02_phiQXi)
        print('')
        print(sike_c0_phiRX)
        print(sike_c02_phiRX)
        print('')
        print(sike_c0_phiRXi)
        print(sike_c02_phiRXi)
        temp = sike_s + temp_c0 + sike_c1
    else:
        temp = sike_m + temp_c0 + sike_c1
    sike_ss = SHAKE256(temp, shared_secret_length)
    
    return sike_ss
    
def dec_sike(arithmetic_parameters, sike_s, sike_sk, prime_str_length, message_length, shared_secret_length, sike_pk_phiPX, sike_pk_phiPXi, sike_pk_phiQX, sike_pk_phiQXi, sike_pk_phiRX, sike_pk_phiRXi, sike_c0_phiPX, sike_c0_phiPXi, sike_c0_phiQX, sike_c0_phiQXi, sike_c0_phiRX, sike_c0_phiRXi, sike_c1, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, oa_bits, ob_bits, splits_alice, splits_bob, max_row_alice, max_row_bob, max_int_points_alice, max_int_points_bob, inv_4):
    extended_word_size_signed = arithmetic_parameters[0]
    number_of_words = arithmetic_parameters[9]
    
    const_r = arithmetic_parameters[12]
    const_r2 = arithmetic_parameters[14]
    
    sike_pk_phiPX_mont  = enter_montgomery_domain(arithmetic_parameters, sike_pk_phiPX)
    sike_pk_phiPXi_mont = enter_montgomery_domain(arithmetic_parameters, sike_pk_phiPXi)
    sike_pk_phiQX_mont  = enter_montgomery_domain(arithmetic_parameters, sike_pk_phiQX) 
    sike_pk_phiQXi_mont = enter_montgomery_domain(arithmetic_parameters, sike_pk_phiQXi)
    sike_pk_phiRX_mont  = enter_montgomery_domain(arithmetic_parameters, sike_pk_phiRX)
    sike_pk_phiRXi_mont = enter_montgomery_domain(arithmetic_parameters, sike_pk_phiRXi)
    
    sike_c0_phiPX_mont  = enter_montgomery_domain(arithmetic_parameters, sike_c0_phiPX)
    sike_c0_phiPXi_mont = enter_montgomery_domain(arithmetic_parameters, sike_c0_phiPXi)
    sike_c0_phiQX_mont  = enter_montgomery_domain(arithmetic_parameters, sike_c0_phiQX) 
    sike_c0_phiQXi_mont = enter_montgomery_domain(arithmetic_parameters, sike_c0_phiQXi)
    sike_c0_phiRX_mont  = enter_montgomery_domain(arithmetic_parameters, sike_c0_phiRX)
    sike_c0_phiRXi_mont = enter_montgomery_domain(arithmetic_parameters, sike_c0_phiRXi)
    
    sike_j_invar_mont, sike_j_invar_i_mont = shared_secret_bob_fast(arithmetic_parameters, sike_c0_phiPX_mont, sike_c0_phiPXi_mont, sike_c0_phiQX_mont, sike_c0_phiQXi_mont, sike_c0_phiRX_mont, sike_c0_phiRXi_mont, sike_sk, ob_bits, splits_bob, max_row_bob, max_int_points_bob, inv_4)
    
    sike_j_invar    = remove_montgomery_domain(arithmetic_parameters, sike_j_invar_mont)
    sike_j_invar_i  = remove_montgomery_domain(arithmetic_parameters, sike_j_invar_i_mont)
    
    sike_j_invar    = iterative_reduction(arithmetic_parameters, sike_j_invar)
    sike_j_invar_i  = iterative_reduction(arithmetic_parameters, sike_j_invar_i)
    
    temp = bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_j_invar)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_j_invar_i)))[::-1]
    sike_h = SHAKE256(temp, message_length)
    sike_m = bytearray([sike_c1[i] ^^ sike_h[i] for i in range(message_length)])
    temp_pk = bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiPX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiPXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiQX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiQXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiRX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_pk_phiRXi)))[::-1]
    temp = sike_m + temp_pk
    ephemeral_sk = SHAKE256(temp, (oa_bits+7)//8)
    ephemeral_sk = bytearray_to_int(ephemeral_sk)
    ephemeral_sk = ephemeral_sk % (2**(oa_bits+1))
    temp_c0 = bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiPX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiPXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiQX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiQXi)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiRX)))[::-1] + bytearray.fromhex(('{:0' + str(prime_str_length) + 'x}').format(int(sike_c0_phiRXi)))[::-1]
    sike_c02_phiPX_mont, sike_c02_phiPXi_mont, sike_c02_phiQX_mont, sike_c02_phiQXi_mont, sike_c02_phiRX_mont, sike_c02_phiRXi_mont = keygen_alice_fast(arithmetic_parameters, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, ephemeral_sk, oa_bits, splits_alice, max_row_alice, max_int_points_alice, inv_4)
    
    sike_c02_phiPX   = remove_montgomery_domain(arithmetic_parameters, sike_c02_phiPX_mont)
    sike_c02_phiPXi  = remove_montgomery_domain(arithmetic_parameters, sike_c02_phiPXi_mont)
    sike_c02_phiQX   = remove_montgomery_domain(arithmetic_parameters, sike_c02_phiQX_mont)
    sike_c02_phiQXi  = remove_montgomery_domain(arithmetic_parameters, sike_c02_phiQXi_mont)
    sike_c02_phiRX   = remove_montgomery_domain(arithmetic_parameters, sike_c02_phiRX_mont)
    sike_c02_phiRXi  = remove_montgomery_domain(arithmetic_parameters, sike_c02_phiRXi_mont)
    
    sike_c02_phiPX   = iterative_reduction(arithmetic_parameters, sike_c02_phiPX)
    sike_c02_phiPXi  = iterative_reduction(arithmetic_parameters, sike_c02_phiPXi)
    sike_c02_phiQX   = iterative_reduction(arithmetic_parameters, sike_c02_phiQX)
    sike_c02_phiQXi  = iterative_reduction(arithmetic_parameters, sike_c02_phiQXi)
    sike_c02_phiRX   = iterative_reduction(arithmetic_parameters, sike_c02_phiRX)
    sike_c02_phiRXi  = iterative_reduction(arithmetic_parameters, sike_c02_phiRXi)
    if((sike_c02_phiPX != sike_c0_phiPX) or (sike_c02_phiPXi != sike_c0_phiPXi) or (sike_c02_phiRX != sike_c0_phiRX) or (sike_c02_phiRXi != sike_c0_phiRXi) or (sike_c02_phiQX != sike_c0_phiQX) or (sike_c02_phiQXi != sike_c0_phiQXi)):
        temp = sike_s + temp_c0 + sike_c1
    else:
        temp = sike_m + temp_c0 + sike_c1
    sike_ss = SHAKE256(temp, shared_secret_length)
    
    return sike_ss