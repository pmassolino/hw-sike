# -*- coding: utf-8 -*-
#
# Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/
#
import random
import sidh_fp2
import SIKE_round2_constants

def inv_3_way(fp2, z1, z2, z3):
    t0 = z1*z2
    t1 = z3*t0
    t1 = t1**(-1)
    t2 = z3*t1
    new_z1 = t2*z2
    new_z2 = t2*z1
    new_z3 = t0*t1
    return new_z1, new_z2, new_z3

def xDBL(fp2, Px, Pz, a24_plus, c24):
    t0  = Px - Pz
    t1  = Px + Pz
    t0 = t0**2
    t1 = t1**2
    P2z = c24*t0
    P2x = P2z*t1
    t1 = t1 - t0
    t0 = a24_plus*t1
    P2z = P2z + t0
    P2z = P2z*t1
    return P2x, P2z

def xDBLe(fp2, Px, Pz, a24_plus, c24, e):
    new_Px = fp2(Px)
    new_Pz = fp2(Pz)
    for i in range(0, e):
        new_Px, new_Pz = xDBL(fp2, new_Px, new_Pz, a24_plus, c24)
    return new_Px, new_Pz

def xDBLADD(fp2, Px, Pz, Qx, Qz, QPx, QPz, a24):
    t0 = Px + Pz
    t1 = Px - Pz
    P2x = t0**2
    t2 = Qx - Qz
    P_plus_Qx = Qx + Qz
    t0 = t0*t2
    P2z = t1**2
    t1 = t1*P_plus_Qx
    t2 = P2x - P2z
    P2x = P2x*P2z
    P_plus_Qx = a24*t2
    P_plus_Qz = t0 - t1
    P2z = P_plus_Qx + P2z
    P_plus_Qx = t0 + t1
    P2z = P2z*t2
    P_plus_Qz = P_plus_Qz**2
    P_plus_Qx = P_plus_Qx**2
    P_plus_Qz = QPx*P_plus_Qz
    P_plus_Qx = QPz*P_plus_Qx
    return P2x, P2z, P_plus_Qx, P_plus_Qz

def xTPL(fp2, Px, Pz, a24_plus, a24_minus):
    t0 = Px - Pz
    t2 = t0**2
    t1 =  Px + Pz
    t3 = t1**2
    t4 = t1 + t0
    t0 = t1 - t0
    t1 = t4**2
    t1 = t1 - t3
    t1 = t1 - t2
    t5 = t3*a24_plus
    t3 = t5*t3
    t6 = t2*a24_minus
    t2 = t2*t6
    t3 = t2 - t3
    t2 = t5 - t6
    t1 = t2*t1
    t2 = t3+t1
    t2 = t2**2
    P3x = t2*t4
    t1 = t3-t1
    t1 = t1**2
    P3z = t1*t0
    return P3x, P3z

def xTPLe(fp2, Px, Pz, a24_plus, a24_minus, e):
    new_Px = fp2(Px)
    new_Pz = fp2(Pz)
    for i in range(0, e):
        new_Px, new_Pz = xTPL(fp2, new_Px, new_Pz, a24_plus, a24_minus)
    return new_Px, new_Pz

def ladder3pt(fp2, Px, Qx, QPx, a, sk, sk_bits_length):
    x0 = fp2(Qx) ; z0 = fp2(1);
    x1 = fp2(Px) ; z1 = fp2(1);
    x2 = fp2(QPx); z2 = fp2(1);
    a24 = ((a + fp2(2))*(fp2(4)**(-1)))
    sk_bits = int(sk)
    for i in range(sk_bits_length):
        if ( sk_bits & 1 ) == 1:
            x0, z0, x1, z1 = xDBLADD(fp2, x0, z0, x1, z1, x2, z2, a24)
        else:
            x0, z0, x2, z2 = xDBLADD(fp2, x0, z0, x2, z2, x1, z1, a24)
        sk_bits = sk_bits//2
    return x1, z1

def j_invariant(fp2, a, c):
    j = a**2
    t1 = c**2
    t0 = t1 + t1
    t0 = j - t0
    t0 = t0 - t1
    j = t0 - t1
    t1 = t1**2
    j = j*t1
    t0 = t0 + t0
    t0 = t0 + t0
    t1 = t0**2
    t0 = t0*t1
    t0 = t0 + t0
    t0 = t0 + t0
    j = j**(-1)
    j = t0*j
    return j

def get_A(fp2, Px, Qx, Rx):
    t1 = Px+Qx
    t0 = Px*Qx
    a = Rx*t1
    a = a + t0
    t0 = t0*Rx
    a = a - fp2(1)
    t0 = t0 + t0
    t1 = t1 + Rx
    t0 = t0 + t0
    a = a**2
    t0 = t0**(-1)
    a = a*t0
    a = a - t1
    return a

def get_2_isog(fp2, P2x, P2z):
    a24_plus = P2x**2
    c24 = P2z**2
    a24_plus = c24 - a24_plus
    return a24_plus, c24

def eval_2_isog(fp2, Px, Pz, Q2x, Q2z):
    t0 = Q2x + Q2z
    t1 = Q2x - Q2z
    t2 = Px + Pz
    t3 = Px - Pz
    t0 = t0*t3
    t1 = t1*t2
    t2 = t0 + t1
    t3 = t0 - t1
    new_Px = Px*t2
    new_Pz = Pz*t3
    return new_Px, new_Pz

def get_4_isog(fp2, P4x, P4z):
    k2 = P4x - P4z
    k3 = P4x + P4z
    k1 = P4z**2
    k1 = k1 + k1
    c24 = k1**2
    k1 = k1 + k1
    a24_plus = P4x**2
    a24_plus = a24_plus + a24_plus
    a24_plus = a24_plus**2
    return a24_plus, c24, k1, k2, k3

def eval_4_isog(fp2, Px, Pz, k1, k2, k3):
    t0 = Px+Pz
    t1 = Px-Pz
    t2 = t0*k2
    t3 = t1*k3
    t0 = t0*t1
    t0 = t0*k1
    t1 = t2 + t3
    t3 = t2 - t3
    t1 = t1**2
    t3 = t3**2
    t2 = t0 + t1
    t0 = t3 - t0
    new_Px = t2*t1
    new_Pz = t3*t0
    return new_Px, new_Pz

def get_3_isog(fp2, P3x, P3z):
    k1 = P3x - P3z
    t0 = k1**2
    k2 = P3x + P3z
    t1 = k2**2
    t2 = t0 + t1
    t3 = k1 + k2
    t3 = t3**2
    t3 = t3 - t2
    t2 = t1 + t3
    t3 = t3 + t0
    t4 = t3 + t0
    t4 = t4 + t4
    t4 = t1 + t4
    a24_minus = t2*t4
    t4 = t1 + t2
    t4 = t4 + t4
    t4 = t0 + t4
    a24_plus = t3*t4
    return a24_plus, a24_minus, k1, k2

def eval_3_isog(fp2, Qx, Qz, k1, k2):
    t0 = Qx + Qz
    t1 = Qx - Qz
    t0 = t0*k1
    t1 = t1*k2
    t2 = t0 + t1
    t0 = t1 - t0
    t2 = t2**2
    t0 = t0**2
    new_Qx = Qx*t2
    new_Qz = Qz*t0
    return new_Qx, new_Qz

def ephemeral_key_generation_alice(fp2, alice_gen_points, bob_gen_points, sk, splits, max_row, max_int_points, oa_bits):
    max_npts = max_int_points
    ptsX = [0 for i in range(max_int_points)]
    ptsZ = [0 for i in range(max_int_points)]
    
    pts_index = [0 for i in range(max_int_points)]
    m = 0; npts = 0; ii = 0;
    
    # Initialize basis points
    PAx = fp2(alice_gen_points[0:2]); QAx = fp2(alice_gen_points[2:4]); RAx = fp2(alice_gen_points[4:6]);
    phiPx = fp2(bob_gen_points[0:2]); phiQx = fp2(bob_gen_points[2:4]); phiRx = fp2(bob_gen_points[4:6]);
    phiPz = fp2(1);                   phiQz = fp2(1);                   phiRz = fp2(1);
    
    # Initialize constants: A24plus = A+2C, C24 = 4C, where A=6, C=1
    a24_plus = fp2(1);
    a24_plus = a24_plus + a24_plus;
    c24 = a24_plus + a24_plus;
    a = c24 + a24_plus
    a24_plus = c24 + c24;
    
    # Retrieve kernel point
    Rx, Rz = ladder3pt(fp2, PAx, QAx, RAx, a, sk, oa_bits)
    
    if(oa_bits % 2 == 1):
        Sx, Sz = xDBLe(fp2, Rx, Rz, a24_plus, c24, oa_bits-1)
        a24_plus, c24 = get_2_isog(fp2, Sx, Sz)
        phiPx, phiPz = eval_2_isog(fp2, phiPx, phiPz, Sx, Sz)
        phiQx, phiQz = eval_2_isog(fp2, phiQx, phiQz, Sx, Sz)
        phiRx, phiRz = eval_2_isog(fp2, phiRx, phiRz, Sx, Sz)
        Rx, Rz = eval_2_isog(fp2, Rx, Rz, Sx, Sz)
    
    index = 0
    for row in range(1, max_row):
        while (index < max_row-row):
            ptsX[npts] = Rx
            ptsZ[npts] = Rz
            pts_index[npts] = index
            npts += 1
            m = splits[ii]
            ii += 1
            Rx, Rz = xDBLe(fp2, Rx, Rz, a24_plus, c24, (2*m))
            index += m;
            if(npts > max_npts):
                max_npts = npts
        
        a24_plus, c24, k1, k2, k3 = get_4_isog(fp2, Rx, Rz)
        
        for i in range(npts):
            ptsX[i], ptsZ[i] = eval_4_isog(fp2, ptsX[i], ptsZ[i], k1, k2, k3)
        
        phiPx, phiPz = eval_4_isog(fp2, phiPx, phiPz, k1, k2, k3)
        phiQx, phiQz = eval_4_isog(fp2, phiQx, phiQz, k1, k2, k3)
        phiRx, phiRz = eval_4_isog(fp2, phiRx, phiRz, k1, k2, k3)
        
        Rx  = ptsX[npts-1]
        Rz  = ptsZ[npts-1]
        index = pts_index[npts-1]
        npts -= 1
    
    a24_plus, c24, k1, k2, k3 = get_4_isog(fp2, Rx, Rz)
    phiPx, phiPz = eval_4_isog(fp2, phiPx, phiPz, k1, k2, k3)
    phiQx, phiQz = eval_4_isog(fp2, phiQx, phiQz, k1, k2, k3)
    phiRx, phiRz = eval_4_isog(fp2, phiRx, phiRz, k1, k2, k3)
    
    phiPz, phiQz, phiRz = inv_3_way(fp2, phiPz, phiQz, phiRz)
    phiPx = phiPx*phiPz
    phiQx = phiQx*phiQz
    phiRx = phiRx*phiRz
    
    return phiPx, phiQx, phiRx

def ephemeral_key_generation_bob(fp2, alice_gen_points, bob_gen_points, sk, splits, max_row, max_int_points, ob_bits):
    max_npts = max_int_points
    ptsX = [0 for i in range(max_int_points)]
    ptsZ = [0 for i in range(max_int_points)]
    
    pts_index = [0 for i in range(max_int_points)]
    m = 0; npts = 0; ii = 0;
    
    # Initialize basis points
    PBx = fp2(bob_gen_points[0:2]);     QBx = fp2(bob_gen_points[2:4]);     RBx = fp2(bob_gen_points[4:6]);
    phiPx = fp2(alice_gen_points[0:2]); phiQx = fp2(alice_gen_points[2:4]); phiRx = fp2(alice_gen_points[4:6]);
    phiPz = fp2(1);                     phiQz = fp2(1);                     phiRz = fp2(1);
    
    # Initialize constants: A24plus = A+2C, C24 = 4C, where A=6, C=1
    a24_plus = fp2(1);
    a24_plus = a24_plus + a24_plus;
    a24_minus = a24_plus + a24_plus;
    a = a24_minus + a24_plus
    a24_plus = a24_minus + a24_minus;
    
    # Retrieve kernel point
    Rx, Rz = ladder3pt(fp2, PBx, QBx, RBx, a, sk, ob_bits-1)
    
    index = 0
    for row in range(1, max_row):
        while (index < max_row-row):
            ptsX[npts] = Rx
            ptsZ[npts] = Rz
            pts_index[npts] = index
            npts += 1
            m = splits[ii]
            ii += 1
            Rx, Rz = xTPLe(fp2, Rx, Rz, a24_plus, a24_minus, m)
            index += m;
            if(npts > max_npts):
                max_npts = npts
        
        a24_plus, a24_minus, k1, k2 = get_3_isog(fp2, Rx, Rz)
        
        for i in range(npts):
            ptsX[i], ptsZ[i] = eval_3_isog(fp2, ptsX[i], ptsZ[i], k1, k2)
        
        phiPx, phiPz = eval_3_isog(fp2, phiPx, phiPz, k1, k2)
        phiQx, phiQz = eval_3_isog(fp2, phiQx, phiQz, k1, k2)
        phiRx, phiRz = eval_3_isog(fp2, phiRx, phiRz, k1, k2)
        
        Rx  = ptsX[npts-1]
        Rz  = ptsZ[npts-1]
        index = pts_index[npts-1]
        npts -= 1
    
    a24_plus, a24_minus, k1, k2 = get_3_isog(fp2, Rx, Rz)
    phiPx, phiPz = eval_3_isog(fp2, phiPx, phiPz, k1, k2)
    phiQx, phiQz = eval_3_isog(fp2, phiQx, phiQz, k1, k2)
    phiRx, phiRz = eval_3_isog(fp2, phiRx, phiRz, k1, k2)
    
    phiPz, phiQz, phiRz = inv_3_way(fp2, phiPz, phiQz, phiRz)
    phiPx = phiPx*phiPz
    phiQx = phiQx*phiQz
    phiRx = phiRx*phiRz
    
    
    return phiPx, phiQx, phiRx

def ephemeral_shared_secret_alice(fp2, pk, sk, splits, max_row, max_int_points, oa_bits):
    max_npts = max_int_points
    ptsX = [0 for i in range(max_int_points)]
    ptsZ = [0 for i in range(max_int_points)]
    
    pts_index = [0 for i in range(max_int_points)]
    m = 0; npts = 0; ii = 0;
    
    # Initialize constants: A24plus = A+2C, C24 = 4C, where C=1
    a = get_A(fp2, pk[0], pk[1], pk[2])
    c24 = fp2(1) + fp2(1)
    a24_plus = c24 + a
    c24 = c24 + c24
    
    # Retrieve kernel point
    Rx, Rz = ladder3pt(fp2, pk[0], pk[1], pk[2], a, sk, oa_bits)
    
    if(oa_bits % 2 == 1):
        Sx, Sz = xDBLe(fp2, Rx, Rz, a24_plus, c24, oa_bits-1)
        a24_plus, c24 = get_2_isog(fp2, Sx, Sz)
        Rx, Rz = eval_2_isog(fp2, Rx, Rz, Sx, Sz)
    
    index = 0
    for row in range(1, max_row):
        while (index < max_row-row):
            ptsX[npts] = Rx
            ptsZ[npts] = Rz
            pts_index[npts] = index
            npts += 1
            m = splits[ii]
            ii += 1
            Rx, Rz = xDBLe(fp2, Rx, Rz, a24_plus, c24, (2*m))
            index += m;
            if(npts > max_npts):
                max_npts = npts
        
        a24_plus, c24, k1, k2, k3 = get_4_isog(fp2, Rx, Rz)
        
        for i in range(npts):
            ptsX[i], ptsZ[i] = eval_4_isog(fp2, ptsX[i], ptsZ[i], k1, k2, k3)
        
        Rx  = ptsX[npts-1]
        Rz  = ptsZ[npts-1]
        index = pts_index[npts-1]
        npts -= 1
    
    a24_plus, c24, k1, k2, k3 = get_4_isog(fp2, Rx, Rz)
    a24_plus = a24_plus + a24_plus
    a24_plus = a24_plus - c24
    a24_plus = a24_plus + a24_plus
    j_inv = j_invariant(fp2, a24_plus, c24)
    
    return j_inv

def ephemeral_shared_secret_bob(fp2, pk, sk, splits, max_row, max_int_points, ob_bits):
    max_npts = max_int_points
    ptsX = [0 for i in range(max_int_points)]
    ptsZ = [0 for i in range(max_int_points)]
    
    pts_index = [0 for i in range(max_int_points)]
    m = 0; npts = 0; ii = 0;
    
    # Initialize constants: A24plus = A+2C, C24 = 4C, where C=1
    a = get_A(fp2, pk[0], pk[1], pk[2])
    a24_minus = fp2(1) + fp2(1)
    a24_plus = a + a24_minus
    a24_minus = a - a24_minus
    
    # Retrieve kernel point
    Rx, Rz = ladder3pt(fp2, pk[0], pk[1], pk[2], a, sk, ob_bits-1)
    
    index = 0
    for row in range(1, max_row):
        while (index < max_row-row):
            ptsX[npts] = Rx
            ptsZ[npts] = Rz
            pts_index[npts] = index
            npts += 1
            m = splits[ii]
            ii += 1
            Rx, Rz = xTPLe(fp2, Rx, Rz, a24_plus, a24_minus, m)
            index += m;
            if(npts > max_npts):
                max_npts = npts
        
        a24_plus, a24_minus, k1, k2 = get_3_isog(fp2, Rx, Rz)
        
        for i in range(npts):
            ptsX[i], ptsZ[i] = eval_3_isog(fp2, ptsX[i], ptsZ[i], k1, k2)
        
        Rx  = ptsX[npts-1]
        Rz  = ptsZ[npts-1]
        index = pts_index[npts-1]
        npts -= 1
    
    a24_plus, a24_minus, k1, k2 = get_3_isog(fp2, Rx, Rz)
    a = a24_plus + a24_minus
    a = a + a
    a24_plus = a24_plus - a24_minus
    j_inv = j_invariant(fp2, a, a24_plus)
    
    return j_inv

def test_single_case(fp2, alice_gen_points, bob_gen_points, oa, ob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, sk_alice, sk_bob):
    pk_alice = ephemeral_key_generation_alice(fp2, alice_gen_points, bob_gen_points, sk_alice, alice_splits, alice_max_row, alice_max_int_points, oa_bits)
    pk_bob = ephemeral_key_generation_bob(fp2, alice_gen_points, bob_gen_points, sk_bob, bob_splits, bob_max_row, bob_max_int_points, ob_bits)
    
    j_inv_alice = ephemeral_shared_secret_alice(fp2, pk_bob, sk_alice, alice_splits, alice_max_row, alice_max_int_points, oa_bits)
    j_inv_bob = ephemeral_shared_secret_bob(fp2, pk_alice, sk_bob, bob_splits, bob_max_row, bob_max_int_points, ob_bits)
    if(j_inv_alice != j_inv_bob):
        print("Error during the key exchange")
        print('Alice secret key')
        print(sk_alice)
        print('Bob secret key')
        print(sk_bob)
        print('Alice public key')
        print(pk_alice)
        print('Bob public key')
        print(pk_bob)
        print('Alice j invariant')
        print(j_inv_alice)
        print('Bob j invariant')
        print(j_inv_bob)
        return True
    return False

def test_single_parameter(fp2, alice_gen_points, bob_gen_points, oa, ob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points,number_of_tests):
    error_computation = False
    performed_tests = 0
    for sk_alice, sk_bob in [[0,0],[oa-1,0],[0,ob-1],[oa-1,ob-1]]:
        error_computation = test_single_case(fp2, alice_gen_points, bob_gen_points, oa, ob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, sk_alice, sk_bob)
        if(error_computation):
            break
        performed_tests += 1
    if(error_computation):
        return True
    for i in range(performed_tests, number_of_tests):
        sk_alice = random.randint(0, oa-1)
        sk_bob = random.randint(0, ob-1)
        
        error_computation = test_single_case(fp2, alice_gen_points, bob_gen_points, oa, ob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points, sk_alice, sk_bob)
        if(error_computation):
            break
        performed_tests += 1
    return error_computation

def test_all_parameters(sidh_parameters, number_of_tests):
    error_computation = False
    for sidh_param in sidh_parameters:
        print("SIDH parameter " + sidh_param[0])
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
        error_computation = test_single_parameter(fp2, alice_gen_points, bob_gen_points, oa, ob, oa_bits, ob_bits, alice_splits, alice_max_row, alice_max_int_points, bob_splits, bob_max_row, bob_max_int_points,number_of_tests)
        if(error_computation):
            break
    return error_computation

if __name__ == "__main__": 
    sidh_parameters = SIKE_round2_constants.sidh_constants
    test_all_parameters(sidh_parameters, 100)