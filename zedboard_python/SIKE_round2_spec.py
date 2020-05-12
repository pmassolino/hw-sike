# -*- coding: utf-8 -*-
#
# Implementation by Pedro Maat C. Massolino,
# hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/

import random

import sidh_fp2
import SIKE_round2_constants
import SIDH_round2_spec
import CompactFIPS202

import binascii

def bytearray_to_int(value):
    int_value = 0
    multiplication_factor = 1
    for each_byte in value:
        int_value += each_byte*multiplication_factor
        multiplication_factor *= 256
    return int_value

def int_to_bytearray(value, byte_length=0):
    value_byte_length = (value.bit_length()+7)//8
    if(value_byte_length == 0):
        value_byte_length = 1
    if(value_byte_length > byte_length):
        final_bytearray = bytearray.fromhex((("{:0" + str(2*value_byte_length) + "x}").format(value)))[::-1]
        if(byte_length != 0):
            final_bytearray = final_bytearray[:(2*byte_length)]
    else:
        final_bytearray = bytearray.fromhex((("{:0" + str(2*byte_length) + "x}").format(value)))[::-1]
    return final_bytearray

def generate_random_bytes(byte_length):
    return bytearray([random.randint(0, 255) for i in range(byte_length)])

def generate_random_sike_sk(ob):
    return random.randint(0, ob-1)

def SIKE_KEM_gen_key(fp2, alice_gen_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, ob, ob_bits, message_length, sike_sk=None, sike_s=None):
    if(sike_s == None):
        sike_s = generate_random_bytes(message_length)
    if(sike_sk == None):
        sike_sk = generate_random_sike_sk(ob)
    sike_pk = SIDH_round2_spec.ephemeral_key_generation_bob(fp2, alice_gen_points, bob_gen_points, sike_sk, bob_splits, bob_max_row, bob_max_int_points, ob_bits)
    return sike_s, sike_sk, sike_pk

def SIKE_KEM_enc(fp2, alice_gen_points, bob_gen_points, alice_splits, alice_max_row, alice_max_int_points, oa, oa_bits, sike_pk, message_length, shared_secret_length, sike_m=None):
    if(sike_m == None):
        sike_m  = generate_random_bytes(message_length)
    temp_pk = sike_pk[0].to_bytearray() + sike_pk[1].to_bytearray() + sike_pk[2].to_bytearray()
    temp = sike_m + temp_pk
    ephemeral_sk = CompactFIPS202.SHAKE256(temp, (oa_bits+7)//8)
    ephemeral_sk = bytearray_to_int(ephemeral_sk)
    ephemeral_sk = ephemeral_sk % oa
    sike_c0 = SIDH_round2_spec.ephemeral_key_generation_alice(fp2, alice_gen_points, bob_gen_points, ephemeral_sk, alice_splits, alice_max_row, alice_max_int_points, oa_bits)
    sike_j_invar = SIDH_round2_spec.ephemeral_shared_secret_alice(fp2, sike_pk, ephemeral_sk, alice_splits, alice_max_row, alice_max_int_points, oa_bits)
    sike_h = CompactFIPS202.SHAKE256(sike_j_invar.to_bytearray(), message_length)
    sike_c1 = bytearray([sike_m[i] ^ sike_h[i] for i in range(message_length)])
    temp_c0 = sike_c0[0].to_bytearray() + sike_c0[1].to_bytearray() + sike_c0[2].to_bytearray()
    temp = sike_m + temp_c0 + sike_c1
    sike_ss = CompactFIPS202.SHAKE256(temp, shared_secret_length)
    return sike_ss, sike_c0, sike_c1

def SIKE_KEM_dec(fp2, alice_gen_points, bob_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, oa, oa_bits, ob_bits, sike_c0, sike_c1, sike_sk, sike_pk, sike_s, message_length, shared_secret_length):
    sike_j_invar = SIDH_round2_spec.ephemeral_shared_secret_bob(fp2, sike_c0, sike_sk, bob_splits, bob_max_row, bob_max_int_points, ob_bits)
    sike_h = CompactFIPS202.SHAKE256(sike_j_invar.to_bytearray(), message_length)
    sike_m = bytearray([sike_c1[i] ^ sike_h[i] for i in range(message_length)])
    temp_pk = sike_pk[0].to_bytearray() + sike_pk[1].to_bytearray() + sike_pk[2].to_bytearray()
    temp = sike_m + temp_pk
    ephemeral_sk = CompactFIPS202.SHAKE256(temp, (oa_bits+7)//8)
    ephemeral_sk = bytearray_to_int(ephemeral_sk)
    ephemeral_sk = ephemeral_sk % oa
    temp_c0 = sike_c0[0].to_bytearray() + sike_c0[1].to_bytearray() + sike_c0[2].to_bytearray()
    sike_c02 = SIDH_round2_spec.ephemeral_key_generation_alice(fp2, alice_gen_points, bob_gen_points, ephemeral_sk, alice_splits, alice_max_row, alice_max_int_points, oa_bits)
    if(sike_c02 != sike_c0):
        temp = sike_s + temp_c0 + sike_c1
    else:
        temp = sike_m + temp_c0 + sike_c1
    sike_ss = CompactFIPS202.SHAKE256(temp, shared_secret_length)
    return sike_ss

def test_sike_kem_single(fp2, alice_gen_points, bob_gen_points, oa, ob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, message_length, shared_secret_length, sike_sk, sike_m):
    sike_s, sike_sk, sike_pk = SIKE_KEM_gen_key(fp2, alice_gen_points, bob_gen_points, bob_splits, bob_max_row, bob_max_int_points, ob, ob_bits, message_length, sike_sk)
    sike_ss, sike_c0, sike_c1 = SIKE_KEM_enc(fp2, alice_gen_points, bob_gen_points, alice_splits, alice_max_row, alice_max_int_points, oa, oa_bits, sike_pk, message_length, shared_secret_length, sike_m)
    sike_ss2 = SIKE_KEM_dec(fp2, alice_gen_points, bob_gen_points, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, oa, oa_bits, ob_bits, sike_c0, sike_c1, sike_sk, sike_pk, sike_s, message_length, shared_secret_length)
    if(sike_ss != sike_ss2):
        print('Error in KEM method')
        print('SIKE secret key')
        print(sike_sk)
        print('SIKE public key')
        print(sike_pk[0])
        print(sike_pk[1])
        print(sike_pk[2])
        print('SIKE c0')
        print(sike_c0[0])
        print(sike_c0[1])
        print(sike_c0[2])
        print('SIKE c1')
        print(binascii.hexlify(sike_c1))
        print('SIKE shared secret from encryption')
        print(binascii.hexlify(sike_ss))
        print('SIKE shared secret from decryption')
        print(binascii.hexlify(sike_ss2))
        return True
    return False

def test_sike_kem_param(fp2, alice_gen_points, bob_gen_points, oa, ob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, message_length, shared_secret_length, number_of_tests):
    error_computation = False
    performed_tests = 0
    for sike_sk, sike_m in [[0, 0],[ob-1, 0]]:
        sike_m = int_to_bytearray(sike_m, message_length)
        error_computation = test_sike_kem_single(fp2, alice_gen_points, bob_gen_points, oa, ob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, message_length, shared_secret_length, sike_sk, sike_m)
        if(error_computation):
            break
        performed_tests += 1
    if(error_computation):
        return True
    for i in range(performed_tests, number_of_tests):
        sike_sk = generate_random_sike_sk(ob)
        sike_m = generate_random_bytes(message_length)
        error_computation = test_sike_kem_single(fp2, alice_gen_points, bob_gen_points, oa, ob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, message_length, shared_secret_length, sike_sk, sike_m)
        if(error_computation):
            break
        performed_tests += 1
    return error_computation

def test_all_parameters(sidh_parameters, number_of_tests):
    error_computation = False
    for i, sidh_param in enumerate(sidh_parameters):
        print("SIKE parameter " + sidh_param[0])
        oa = sidh_param[2]**sidh_param[4]
        ob = sidh_param[3]**sidh_param[5]
        prime = sidh_param[1]*(oa)*(ob) - 1
        fp2 = sidh_fp2.sidh_fp2(prime)
        alice_gen_points = sidh_param[6:12]
        bob_gen_points = sidh_param[12:18]
        oa_bits = int(oa-1).bit_length()
        ob_bits = int(ob-1).bit_length()
        alice_splits = sidh_param[18]
        alice_max_row = sidh_param[19]
        alice_max_int_points = sidh_param[20]
        bob_splits = sidh_param[21]
        bob_max_row = sidh_param[22]
        bob_max_int_points = sidh_param[23]
        message_length = sidh_param[24]
        shared_secret_length = sidh_param[25]
        error_computation = test_sike_kem_param(fp2, alice_gen_points, bob_gen_points, oa, ob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, message_length, shared_secret_length, number_of_tests)
        if(error_computation):
            break
    return error_computation

if __name__ == "__main__": 
    sidh_parameters = SIKE_round2_constants.sidh_constants
    test_all_parameters(sidh_parameters, 100)
