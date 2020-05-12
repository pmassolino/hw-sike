#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# Implementation by Pedro Maat C. Massolino,
# hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/

import time
import random
import sys

from zedboard_sidh import *
import sike_core_utils
import ecc_fpga_constants_v128
import ecc_fpga_constants_v256


tests_prom_folder = "../assembler/"

program_start_address_test_sike_kem_keygen = 1
program_start_address_test_sike_kem_enc = 3
program_start_address_test_sike_kem_dec = 5
program_start_address_test_sidh_keygen_alice = 7
program_start_address_test_sidh_keygen_bob = 9
program_start_address_test_sidh_shared_secret_alice = 11
program_start_address_test_sidh_shared_secret_bob = 13
program_start_address_test_ecc_scalar_multiplication = 15

sike_core_mac_ram_start_address =                           0x00000;
sike_core_mac_ram_last_address =                            0x07FFF;
sike_core_base_alu_ram_start_address =                      0x0C000;
sike_core_base_alu_ram_last_address =                       0x0C3FF;
sike_core_keccak_core_start_address =                       0x0D000;
sike_core_keccak_core_last_address =                        0x0D007;
sike_core_reg_program_counter_address =                     0x0E000;
sike_core_reg_status_address =                              0x0E001;
sike_core_reg_operands_size_address =                       0x0E002;
sike_core_reg_prime_line_equal_one_address =                0x0E003;
sike_core_reg_prime_address_address =                       0x0E004;
sike_core_reg_prime_plus_one_address_address =              0x0E005;
sike_core_reg_prime_line_address_address =                  0x0E006;
sike_core_reg_2prime_address_address =                      0x0E007;
sike_core_reg_initial_stack_address_address =               0x0E008;
sike_core_reg_flag_address =                                0x0E009;
sike_core_reg_scalar_address_address =                      0x0E00A;

sike_core_mac_ram_prime_address =                           0x00000;
sike_core_mac_ram_prime_plus_one_address =                  0x00001;
sike_core_mac_ram_prime_line_address =                      0x00002;
sike_core_mac_ram_2prime_address =                          0x00003;
sike_core_mac_ram_const_r_address =                         0x00004;
sike_core_mac_ram_const_r2_address =                        0x00005;
sike_core_mac_ram_const_1_address =                         0x00006;
sike_core_mac_ram_inv_4_mont_address =                      0x00007;
sike_core_mac_ram_sidh_xpa_mont_address =                   0x00008;
sike_core_mac_ram_sidh_xpai_mont_address =                  0x00009;
sike_core_mac_ram_sidh_xqa_mont_address =                   0x0000A;
sike_core_mac_ram_sidh_xqai_mont_address =                  0x0000B;
sike_core_mac_ram_sidh_xra_mont_address =                   0x0000C;
sike_core_mac_ram_sidh_xrai_mont_address =                  0x0000D;
sike_core_mac_ram_sidh_xpb_mont_address =                   0x0000E;
sike_core_mac_ram_sidh_xpbi_mont_address =                  0x0000F;
sike_core_mac_ram_sidh_xqb_mont_address =                   0x00010;
sike_core_mac_ram_sidh_xqbi_mont_address =                  0x00011;
sike_core_mac_ram_sidh_xrb_mont_address =                   0x00012;
sike_core_mac_ram_sidh_xrbi_mont_address =                  0x00013;

sike_core_base_alu_ram_sike_s_start_address =               0x000FB;
sike_core_base_alu_ram_sike_sk_start_address =              0x0011B;
sike_core_base_alu_ram_sike_m_start_address =               0x0013B;
sike_core_base_alu_ram_sike_ss_start_address =              0x0015B;
sike_core_base_alu_ram_sike_c1_start_address =              0x0017B;
sike_core_base_alu_ram_sike_message_length_address =        0x0019B;
sike_core_base_alu_ram_sike_shared_secret_length_address =  0x0019C;
sike_core_base_alu_ram_oa_mask_address =                    0x0019D;
sike_core_base_alu_ram_ob_mask_address =                    0x0019E;
sike_core_base_alu_ram_oa_bits_address =                    0x0019F;
sike_core_base_alu_ram_ob_bits_address =                    0x001A0;
sike_core_base_alu_ram_prime_size_bits_address =            0x001A1;
sike_core_base_alu_ram_splits_alice_start_address =         0x001A2;
sike_core_base_alu_ram_max_row_alice_address =              0x002D0;
sike_core_base_alu_ram_splits_bob_start_address =           0x002D1;
sike_core_base_alu_ram_max_row_bob_address =                0x003FF;

sike_core_mac_ram_input_function_start_address =            0x00014;
sike_core_mac_ram_output_function_start_address =           0x00024;

sike_core_ecc_base_alu_ram_scalar_max_size_address =        0x000FA;

def scalar_multiplication_weierstrass(prime, const_a, const_a2, const_b3, scalar, elliptic_curve_point):
    
    r0x = 0
    r0y = 1
    r0z = 0
    
    r1x = elliptic_curve_point[0]
    r1y = elliptic_curve_point[1]
    r1z = elliptic_curve_point[2]
    # Scalar position 0 is the most significant bit.
    scalar_list = [int(x) for x in (bin(scalar)[2:])]
    for i, scalar_bit in enumerate(scalar_list):
        if(scalar_bit == 1):
            #
            # Point Addition
            #
            # Step 1
            #
            # t0 := X1+Y1;
            # t1 := X2+Y2;
            # t2 := Y1+Z1;
            # t3 := Y2+Z2;
            t0 = (r0x+r0y) % prime
            t1 = (r1x+r1y) % prime
            t2 = (r0y+r0z) % prime
            t3 = (r1y+r1z) % prime
            #
            # t4 := X1+Z1;
            # t5 := X2+Z2;
            t4 = (r0x+r0z) % prime
            t5 = (r1x+r1z) % prime

            # Step 2
            #
            # t6  := t0*t1;
            # t7  := t2*t3;
            # t8  := t4*t5;
            # t9  := X1*X2;
            # t10 := Y1*Y2;
            # t11 := Z1*Z2;
            t6  = (t0*t1) % prime
            t7  = (t2*t3) % prime
            t8  = (t4*t5) % prime
            t9  = (r1x*r0x) % prime
            t10 = (r1y*r0y) % prime
            t11 = (r1z*r0z) % prime
            
            # Step 3
            #
            # t3 := t6-t9;
            # t4 := t7-t10;
            # t5 := t8-t11;
            t3 = (t6-t9) % prime
            t4 = (t7-t10) % prime
            t5 = (t8-t11) % prime
            
            # Step 4
            #
            # t0 := t3-t10;
            # t1 := t4-t11;
            # t2 := t5-t9;
            t0 = (t3-t10) % prime
            t1 = (t4-t11) % prime
            t2 = (t5-t9) % prime
            
            # Step 5
            #
            # t3 := b3*t11;
            # t4 := a*t11;
            # t5 := a*t2;
            # t6 := b3*t2;
            # t7 := a*t9;
            # t8 := a^2*t11;
            t3  = (const_b3*t11) % prime
            t4  = (const_a*t11) % prime
            t5  = (const_a*t2) % prime
            t6  = (const_b3*t2) % prime
            t7  = (const_a*t9) % prime
            t8  = (const_a2*t11) % prime
            
            # Step 6
            #
            # t2  := t3+t5;
            # t11 := t9+t4;
            # t12 := t9+t9;
            # t13 := t6+t7;
            t2  = (t3+t5) % prime
            t11 = (t9+t4) % prime
            t12 = (t9+t9) % prime
            t13 = (t6+t7) % prime
            
            # Step 7
            #
            # t3 := t13-t8;
            # t4 := t12+t11;
            # t5 := t10-t2;
            # t6 := t10+t2;
            t3 = (t13-t8) % prime
            t4 = (t12+t11) % prime
            t5 = (t10-t2) % prime
            t6 = (t10+t2) % prime
            
            # Step 8
            #
            # t2 := t0*t5;
            # t7 := t0*t4;
            # t8 := t1*t3;
            # t9 := t4*t3;
            # t10 := t6*t5;
            # t11 := t1*t6;
            t2  = (t0*t5) % prime
            t7  = (t0*t4) % prime
            t8  = (t1*t3) % prime
            t9  = (t4*t3) % prime
            t10 = (t6*t5) % prime
            t11 = (t1*t6) % prime
            
            # Step 9
            #
            # X3 := t2-t8;
            # Y3 := t10+t9;
            # Z3 := t11+t7;
            r0x = (t2-t8) % prime
            r0y = (t10+t9) % prime
            r0z = (t11+t7) % prime
            
            #
            # Point Doubling with Addition
            #
            # Step 1
            #
            # t14 := X1+Y1;
            # t15 := X2+Y2;
            # t16 := Y1+Z1;
            # t17 := Y2+Z2;
            t14 = (r1x+r1y) % prime
            t15 = (r1x+r1y) % prime
            t16 = (r1y+r1z) % prime
            t17 = (r1y+r1z) % prime
            #
            # t18 := X1+Z1;
            # t19 := X2+Z2;
            t18 = (r1x+r1z) % prime
            t19 = (r1x+r1z) % prime
            
            # Step 2
            #
            # t20 := t14*t15;
            # t21 := t16*t17;
            # t22 := t18*t19;
            # t23 := X1*X2;
            # t24 := Y1*Y2;
            # t25 := Z1*Z2;
            t20 = (t14*t15) % prime
            t21 = (t16*t17) % prime
            t22 = (t18*t19) % prime
            t23 = (r1x*r1x) % prime
            t24 = (r1y*r1y) % prime
            t25 = (r1z*r1z) % prime
            
            # Step 3
            #
            # t17 := t20-t23;
            # t18 := t21-t24;
            # t19 := t22-t25;
            t17 = (t20-t23) % prime
            t18 = (t21-t24) % prime
            t19 = (t22-t25) % prime
            
            # Step 4
            #
            # t14 := t17-t24;
            # t15 := t18-t25;
            # t16 := t19-t23;
            t14 = (t17-t24) % prime
            t15 = (t18-t25) % prime
            t16 = (t19-t23) % prime
            
            # Step 5
            #
            # t17 := b3*t25;
            # t18 := a*t25;
            # t19 := a*t16;
            # t20 := b3*t16;
            # t21 := a*t23;
            # t22 := a^2*t25;
            t17 = (const_b3*t25) % prime
            t18 = (const_a*t25) % prime
            t19 = (const_a*t16) % prime
            t20 = (const_b3*t16) % prime
            t21 = (const_a*t23) % prime
            t22 = (const_a2*t25) % prime
            
            # Step 6
            #
            # t16 := t17+t19;
            # t25 := t23+t18;
            # t26 := t23+t23;
            # t27 := t20+t21;
            t16 = (t17+t19) % prime
            t25 = (t23+t18) % prime
            t26 = (t23+t23) % prime
            t27 = (t20+t21) % prime
            
            # Step 7
            #
            # t17 := t27-t22;
            # t18 := t26+t25;
            # t19 := t24-t16;
            # t20 := t24+t16;
            t17 = (t27-t22) % prime
            t18 = (t26+t25) % prime
            t19 = (t24-t16) % prime
            t20 = (t24+t16) % prime
            
            # Step 8
            #
            # t16 := t14*t19;
            # t21 := t14*t18;
            # t22 := t15*t17;
            # t23 := t18*t17;
            # t24 := t20*t19;
            # t25 := t15*t20;
            t16  = (t14*t19) % prime
            t21  = (t14*t18) % prime
            t22  = (t15*t17) % prime
            t23  = (t18*t17) % prime
            t24  = (t20*t19) % prime
            t25  = (t15*t20) % prime
            
            # Step 9
            #
            # X3 := t16-t22;
            # Y3 := t24+t23;
            # Z3 := t25+t21;
            r1x = (t16-t22) % prime
            r1y = (t24+t23) % prime
            r1z = (t25+t21) % prime
        else:
            #
            # Point Addition
            #
            # Step 1
            #
            # t0 := X1+Y1;
            # t1 := X2+Y2;
            # t2 := Y1+Z1;
            # t3 := Y2+Z2;
            t0 = (r0x+r0y) % prime
            t1 = (r1x+r1y) % prime
            t2 = (r0y+r0z) % prime
            t3 = (r1y+r1z) % prime
            #
            # t4 := X1+Z1;
            # t5 := X2+Z2;
            t4 = (r0x+r0z) % prime
            t5 = (r1x+r1z) % prime
            
            # Step 2
            #
            # t6  := t0*t1;
            # t7  := t2*t3;
            # t8  := t4*t5;
            # t9  := X1*X2;
            # t10 := Y1*Y2;
            # t11 := Z1*Z2;
            t6  = (t0*t1) % prime
            t7  = (t2*t3) % prime
            t8  = (t4*t5) % prime
            t9  = (r1x*r0x) % prime
            t10 = (r1y*r0y) % prime
            t11 = (r1z*r0z) % prime
            
            # Step 3
            #
            # t3 := t6-t9;
            # t4 := t7-t10;
            # t5 := t8-t11;
            t3 = (t6-t9) % prime
            t4 = (t7-t10) % prime
            t5 = (t8-t11) % prime
            
            # Step 4
            #
            # t0 := t3-t10;
            # t1 := t4-t11;
            # t2 := t5-t9;
            t0 = (t3-t10) % prime
            t1 = (t4-t11) % prime
            t2 = (t5-t9) % prime
            
            # Step 5
            #
            # t3 := b3*t11;
            # t4 := a*t11;
            # t5 := a*t2;
            # t6 := b3*t2;
            # t7 := a*t9;
            # t8 := a^2*t11;
            t3  = (const_b3*t11) % prime
            t4  = (const_a*t11) % prime
            t5  = (const_a*t2) % prime
            t6  = (const_b3*t2) % prime
            t7  = (const_a*t9) % prime
            t8  = (const_a2*t11) % prime
            
            # Step 6
            #
            # t2  := t3+t5;
            # t11 := t9+t4;
            # t12 := t9+t9;
            # t13 := t6+t7;
            t2  = (t3+t5) % prime
            t11 = (t9+t4) % prime
            t12 = (t9+t9) % prime
            t13 = (t6+t7) % prime
            
            # Step 7
            #
            # t3 := t13-t8;
            # t4 := t12+t11;
            # t5 := t10-t2;
            # t6 := t10+t2;
            t3 = (t13-t8) % prime
            t4 = (t12+t11) % prime
            t5 = (t10-t2) % prime
            t6 = (t10+t2) % prime
            
            # Step 8
            #
            # t2 := t0*t5;
            # t7 := t0*t4;
            # t8 := t1*t3;
            # t9 := t4*t3;
            # t10 := t6*t5;
            # t11 := t1*t6;
            t2  = (t0*t5) % prime
            t7  = (t0*t4) % prime
            t8  = (t1*t3) % prime
            t9  = (t4*t3) % prime
            t10 = (t6*t5) % prime
            t11 = (t1*t6) % prime
            
            # Step 9
            #
            # X3 := t2-t8;
            # Y3 := t10+t9;
            # Z3 := t11+t7;
            r1x = (t2-t8) % prime
            r1y = (t10+t9) % prime
            r1z = (t11+t7) % prime
            
            #
            # Point Doubling with Addition
            #
            # Step 1
            #
            # t14 := X1+Y1;
            # t15 := X2+Y2;
            # t16 := Y1+Z1;
            # t17 := Y2+Z2;
            t14 = (r0x+r0y) % prime
            t15 = (r0x+r0y) % prime
            t16 = (r0y+r0z) % prime
            t17 = (r0y+r0z) % prime
            #
            # t18 := X1+Z1;
            # t19 := X2+Z2;
            t18 = (r0x+r0z) % prime
            t19 = (r0x+r0z) % prime
            
            # Step 2
            #
            # t20 := t14*t15;
            # t21 := t16*t17;
            # t22 := t18*t19;
            # t23 := X1*X2;
            # t24 := Y1*Y2;
            # t25 := Z1*Z2;
            t20 = (t14*t15) % prime
            t21 = (t16*t17) % prime
            t22 = (t18*t19) % prime
            t23 = (r0x*r0x) % prime
            t24 = (r0y*r0y) % prime
            t25 = (r0z*r0z) % prime
            
            # Step 3
            #
            # t17 := t20-t23;
            # t18 := t21-t24;
            # t19 := t22-t25;
            t17 = (t20-t23) % prime
            t18 = (t21-t24) % prime
            t19 = (t22-t25) % prime
            
            # Step 4
            #
            # t14 := t17-t24;
            # t15 := t18-t25;
            # t16 := t19-t23;
            t14 = (t17-t24) % prime
            t15 = (t18-t25) % prime
            t16 = (t19-t23) % prime
            
            # Step 5
            #
            # t17 := b3*t25;
            # t18 := a*t25;
            # t19 := a*t16;
            # t20 := b3*t16;
            # t21 := a*t23;
            # t22 := a^2*t25;
            t17 = (const_b3*t25) % prime
            t18 = (const_a*t25) % prime
            t19 = (const_a*t16) % prime
            t20 = (const_b3*t16) % prime
            t21 = (const_a*t23) % prime
            t22 = (const_a2*t25) % prime
            
            # Step 6
            #
            # t16 := t17+t19;
            # t25 := t23+t18;
            # t26 := t23+t23;
            # t27 := t20+t21;
            t16 = (t17+t19) % prime
            t25 = (t23+t18) % prime
            t26 = (t23+t23) % prime
            t27 = (t20+t21) % prime
            
            # Step 7
            #
            # t17 := t27-t22;
            # t18 := t26+t25;
            # t19 := t24-t16;
            # t20 := t24+t16;
            t17 = (t27-t22) % prime
            t18 = (t26+t25) % prime
            t19 = (t24-t16) % prime
            t20 = (t24+t16) % prime
            
            # Step 8
            #
            # t16 := t14*t19;
            # t21 := t14*t18;
            # t22 := t15*t17;
            # t23 := t18*t17;
            # t24 := t20*t19;
            # t25 := t15*t20;
            t16  = (t14*t19) % prime
            t21  = (t14*t18) % prime
            t22  = (t15*t17) % prime
            t23  = (t18*t17) % prime
            t24  = (t20*t19) % prime
            t25  = (t15*t20) % prime
            
            # Step 9
            #
            # X3 := t16-t22;
            # Y3 := t24+t23;
            # Z3 := t25+t21;
            r0x = (t16-t22) % prime
            r0y = (t24+t23) % prime
            r0z = (t25+t21) % prime
    
    inv_r0z  = pow(r0z, prime-2, prime)
    inv_r1z  = pow(r1z, prime-2, prime)
    
    r0x = (r0x*inv_r0z) % prime
    r0y = (r0y*inv_r0z) % prime
    r0z = 1
    r1x = (r1x*inv_r1z) % prime
    r1y = (r1y*inv_r1z) % prime
    r1z = 1
    
    return r0x, r0y
    
    
def load_program(zedboard, prom_file_name, base_word_size, base_word_size_signed_number_words):
    prom_file = open(prom_file_name, 'r')
    program = []
    prom_file.seek(0, 2)
    prom_file_size = prom_file.tell()
    prom_file.seek(0)
    while (prom_file.tell() != prom_file_size):
        program += [sike_core_utils.load_list_value_VHDL_MAC_memory_as_integer(prom_file, base_word_size, base_word_size_signed_number_words, 1, False)]
    print("Loading program into SIKE core:" + str(prom_file_name))
    zedboard.write_program_prom(0, program)
    print("Reading program uploaded into SIKE core")
    program_written = zedboard.read_program_prom(0, len(program))
    print("Verifying program uploaded into SIKE core")
    if(program_written == program):
        return True
    print(program)
    print(program_written)
    return False

def test_single_scalar_multiplication(zedboard, prime, base_word_size, extended_word_size, number_of_words, scalar, elliptic_curve_point, const_a, const_a2, const_b3, const_a_mont, const_a2_mont, const_b3_mont, debug_mode=False):

    scalar_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, scalar)
    
    elliptic_curve_point_x_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, elliptic_curve_point[0])
    elliptic_curve_point_y_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, elliptic_curve_point[1])
    elliptic_curve_point_z_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, elliptic_curve_point[2])
    const_a_mont_list  = sike_core_utils.integer_to_list(extended_word_size, number_of_words, const_a_mont)
    const_a2_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, const_a2_mont)
    const_b3_mont_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, const_b3_mont)
    
    zedboard.write_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_input_function_start_address + 0, scalar_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_input_function_start_address + 1, elliptic_curve_point_x_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_input_function_start_address + 2, elliptic_curve_point_y_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_input_function_start_address + 3, elliptic_curve_point_z_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_input_function_start_address + 4, const_a_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_input_function_start_address + 5, const_a2_mont_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_input_function_start_address + 6, const_b3_mont_list, number_of_words)
    
    zedboard.write_package(sike_core_reg_program_counter_address, program_start_address_test_ecc_scalar_multiplication)
    
    true_ecc_r0x, true_ecc_r0y = scalar_multiplication_weierstrass(prime, const_a, const_a2, const_b3, scalar, elliptic_curve_point)
    
    #time.sleep(0.1)
    
    while(not zedboard.isFree()):
        time.sleep(0.1)
    
    computed_test_ecc_r0x_list = zedboard.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 0, number_of_words)
    computed_test_ecc_r0y_list = zedboard.read_mac_ram_operand(sike_core_mac_ram_start_address + sike_core_mac_ram_output_function_start_address + 1, number_of_words)
    
    computed_test_ecc_r0x = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_ecc_r0x_list)
    computed_test_ecc_r0y = sike_core_utils.list_to_integer(extended_word_size, number_of_words, computed_test_ecc_r0y_list)
    
    if((debug_mode) or ((computed_test_ecc_r0x != true_ecc_r0x) or (computed_test_ecc_r0y != true_ecc_r0y))):
        print("Error in ECC scalar multiplication ")
        print("ECC Point")
        print('{:0x}'.format(elliptic_curve_point[0]))
        print('{:0x}'.format(elliptic_curve_point[1]))
        print('{:0x}'.format(elliptic_curve_point[2]))
        print("ECC scalar")
        print(scalar)
        print("ECC True scalar*Point")
        print('{:0x}'.format(true_ecc_r0x))
        print('{:0x}'.format(true_ecc_r0y))
        print("ECC Computed scalar*Point")
        print('{:0x}'.format(computed_test_ecc_r0x))
        print('{:0x}'.format(computed_test_ecc_r0y))
        return True
    return False

def test_scalar_multiplication(zedboard, param, number_of_tests, debug_mode=False):

    base_word_size = param[1]
    extended_word_size = param[2]
    number_of_words = param[4]
    prime = param[5]
    prime_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[5])
    prime_plus_one_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[7])
    prime_line_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[8])
    prime2 = param[10]
    prime2_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[10])
    r_mod_prime_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[11])
    r2_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[12])
    constant_1_list = sike_core_utils.integer_to_list(extended_word_size, number_of_words, param[13])
    
    error_computation = False
    
    prime_size = param[6]
    scalar_max = param[14]
    scalar_max_size = param[15]
    
    starting_position_stack_sidh_core = param[25]
    
    enable_special_prime_line_arithmetic = param[9]
    
    const_a_mont  = param[16]
    const_a2_mont = param[17]
    const_b3_mont = param[18] 
    
    const_a  = param[19]
    const_a2 = param[20]
    const_b3 = param[21] 
    elliptic_curve_point = param[22:25]
    
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_address, prime_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_plus_one_address, prime_plus_one_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_prime_line_address, prime_line_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_2prime_address, prime2_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_const_r_address, r_mod_prime_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_const_r2_address, r2_list, number_of_words)
    zedboard.write_mac_ram_operand(sike_core_mac_ram_const_1_address, constant_1_list, number_of_words)
    
    zedboard.write_package(sike_core_base_alu_ram_start_address + sike_core_base_alu_ram_prime_size_bits_address, prime_size)
    zedboard.write_package(sike_core_base_alu_ram_start_address + sike_core_ecc_base_alu_ram_scalar_max_size_address, scalar_max_size)
    
    zedboard.write_package(sike_core_reg_operands_size_address, number_of_words - 1)
    zedboard.write_package(sike_core_reg_prime_line_equal_one_address, enable_special_prime_line_arithmetic)
    zedboard.write_package(sike_core_reg_prime_address_address, 0)
    zedboard.write_package(sike_core_reg_prime_plus_one_address_address, 1)
    zedboard.write_package(sike_core_reg_prime_line_address_address, 2)
    zedboard.write_package(sike_core_reg_2prime_address_address, 3)
    zedboard.write_package(sike_core_reg_scalar_address_address, 0)
    zedboard.write_package(sike_core_reg_initial_stack_address_address, starting_position_stack_sidh_core)
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, scalar_max-2]
    for test in fixed_tests:
        scalar = test
        error_computation = test_single_scalar_multiplication(zedboard, prime, base_word_size, extended_word_size, number_of_words, scalar, elliptic_curve_point, const_a, const_a2, const_b3, const_a_mont, const_a2_mont, const_b3_mont, debug_mode)
        tests_already_performed += 1
        if(error_computation):
            break
    
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            scalar = random.randint(0, scalar_max-1)
            error_computation = test_single_scalar_multiplication(zedboard, prime, base_word_size, extended_word_size, number_of_words, scalar, elliptic_curve_point, const_a, const_a2, const_b3, const_a_mont, const_a2_mont, const_b3_mont, debug_mode)
        
            if(error_computation):
                break
    
    return error_computation

def test_all_scalar_multiplication(zedboard, version, only_one_parameter=None):
    sike_base_word_size = 16
    if(version == '256'):
        sike_extended_word_size = 256
        ecc_fpga_constants = ecc_fpga_constants_v256.ecc_fpga_constants_v256
    elif(version == '128'):
        sike_extended_word_size = 128
        ecc_fpga_constants = ecc_fpga_constants_v128.ecc_fpga_constants_v128
    #if(load_program(zedboard, tests_prom_folder + "test_ecc_scalar_multiplication_v" + str(sike_extended_word_size)+ ".dat", sike_base_word_size, 4)):
    if(load_program(zedboard, tests_prom_folder + "test_sike_sidh_ecc_functions_v" + str(sike_extended_word_size)+ ".dat", sike_base_word_size, 4)):
        print("Program loaded correctly into SIKE core")
        number_of_tests = 100
        error_computation = False
        if(only_one_parameter != None):
            all_testing_parameters = ecc_fpga_constants[only_one_parameter:only_one_parameter+1]
        else:
            all_testing_parameters = ecc_fpga_constants
        for param in all_testing_parameters:
            print("Testing ECC scalar multiplication " +  param[0])
            error_computation = test_scalar_multiplication(zedboard, param, number_of_tests, debug_mode=False)
            if(error_computation):
                break
    else:
        print('Program loading failed')

zedboard = Zedboard('COM4', sys.argv[1])
#zedboard.read_initial_message(34)
while(not zedboard.isFree()):
    time.sleep(0.01)
zedboard.flush()

test_all_scalar_multiplication(zedboard, sys.argv[1])

zedboard.disconnect()