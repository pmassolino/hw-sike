import binascii

proof.arithmetic(False)
if 'script_working_folder' not in globals() and 'script_working_folder' not in locals():
    script_working_folder = "/home/pedro/hw-sidh/vhdl_project/sage/"
load(script_working_folder+"base_tests_for_sidh_basic_procedures/all_sidh_basic_procedures.sage")
load(script_working_folder+"base_tests_for_ecc/ecc_constants.sage")

def sage_scalar_multiplication_weierstrass(fp, scalar, elliptic_curve_point):
    final_point = scalar*elliptic_curve_point
    
    return final_point[0], final_point[1]
    
def scalar_multiplication_weierstrass(arithmetic_parameters, scalar, scalar_max_size, elliptic_curve_point, const_a, const_a2, const_b3):
    extended_word_size_signed = arithmetic_parameters[0]
    number_of_words = arithmetic_parameters[9]
    
    const_r = arithmetic_parameters[12]
    
    r0x = 0
    r0y = const_r
    r0z = 0
    
    r1x = enter_montgomery_domain(arithmetic_parameters, int(elliptic_curve_point[0]))
    r1y = enter_montgomery_domain(arithmetic_parameters, int(elliptic_curve_point[1]))
    r1z = enter_montgomery_domain(arithmetic_parameters, int(elliptic_curve_point[2]))
    
    scalar_list = unsigned_integer_to_list(1, scalar_max_size, scalar)
    
    for i, scalar_bit in enumerate(scalar_list[::-1]):
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
            ma =     [r0y, r1y, r0z, r1z]
            mb =     [r0x, r1x, r0y, r1y]
            sign_a = [  1,  1,   1,    1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t0 = mo[0]
            t1 = mo[1]
            t2 = mo[2]
            t3 = mo[3]
            #
            # t4 := X1+Z1;
            # t5 := X2+Z2;
            ma =     [r0z, r1z, 0, 0]
            mb =     [r0x, r1x, 0, 0]
            sign_a = [  1,  1,  1, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t4 = mo[0]
            t5 = mo[1]

            # Step 2
            #
            # t6  := t0*t1;
            # t7  := t2*t3;
            # t8  := t4*t5;
            # t9  := X1*X2;
            # t10 := Y1*Y2;
            # t11 := Z1*Z2;
            ma  = [t0, t2, t4, r0x, r0y, r0z, 0, 0]
            mb  = [t1, t3, t5, r1x, r1y, r1z, 0, 0]
            mo  = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            t6  = mo[0]
            t7  = mo[1]
            t8  = mo[2]
            t9  = mo[3]
            t10 = mo[4]
            t11 = mo[5]
            
            # Step 3
            #
            # t3 := t6-t9;
            # t4 := t7-t10;
            # t5 := t8-t11;
            ma =     [t9, t10, t11, 0]
            mb =     [t6,  t7,  t8, 0]
            sign_a = [ 0,   0,   0, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t3 = mo[0]
            t4 = mo[1]
            t5 = mo[2]
            
            # Step 4
            #
            # t0 := t3-t10;
            # t1 := t4-t11;
            # t2 := t5-t9;
            ma =     [t10, t11, t9, 0]
            mb =     [t3,   t4, t5, 0]
            sign_a = [ 0,    0,  0, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t0 = mo[0]
            t1 = mo[1]
            t2 = mo[2]
            
            # Step 5
            #
            # t3 := b3*t11;
            # t4 := a*t11;
            # t5 := a*t2;
            # t6 := b3*t2;
            # t7 := a*t9;
            # t8 := a^2*t11;
            ma  = [const_b3, const_a, const_a, const_b3, const_a, const_a2, 0, 0]
            mb  = [     t11,     t11,      t2,       t2,      t9,      t11, 0, 0]
            mo  = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            t3  = mo[0]
            t4  = mo[1]
            t5  = mo[2]
            t6  = mo[3]
            t7  = mo[4]
            t8  = mo[5]
            
            # Step 6
            #
            # t2  := t3+t5;
            # t11 := t9+t4;
            # t12 := t9+t9;
            # t13 := t6+t7;
            ma =     [t5, t4, t9, t7]
            mb =     [t3, t9, t9, t6]
            sign_a = [ 1,  1,  1,   1]
            mo  = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t2  = mo[0]
            t11 = mo[1]
            t12 = mo[2]
            t13 = mo[3]
            
            # Step 7
            #
            # t3 := t13-t8;
            # t4 := t12+t11;
            # t5 := t10-t2;
            # t6 := t10+t2;
            ma =     [ t8, t11,  t2,  t2]
            mb =     [t13, t12, t10, t10]
            sign_a = [  0,   1,   0,   1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t3 = mo[0]
            t4 = mo[1]
            t5 = mo[2]
            t6 = mo[3]
            
            # Step 8
            #
            # t2 := t0*t5;
            # t7 := t0*t4;
            # t8 := t1*t3;
            # t9 := t4*t3;
            # t10 := t6*t5;
            # t11 := t1*t6;
            ma  = [t5, t4, t3, t3, t5, t6, 0, 0]
            mb  = [t0, t0, t1, t4, t6, t1, 0, 0]
            mo  = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            t2  = mo[0]
            t7  = mo[1]
            t8  = mo[2]
            t9  = mo[3]
            t10 = mo[4]
            t11 = mo[5]
            
            # Step 9
            #
            # X3 := t2-t8;
            # Y3 := t10+t9;
            # Z3 := t11+t7;
            ma =     [t8,  t9,  t7, 0]
            mb =     [t2, t10, t11, 0]
            sign_a = [ 0,   1,   1, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            r0x = mo[0]
            r0y = mo[1]
            r0z = mo[2]
            
            #
            # Point Doubling with Addition
            #
            # Step 1
            #
            # t14 := X1+Y1;
            # t15 := X2+Y2;
            # t16 := Y1+Z1;
            # t17 := Y2+Z2;
            ma =     [r1y, r1y, r1z, r1z]
            mb =     [r1x, r1x, r1y, r1y]
            sign_a = [  1,   1,   1,   1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t14 = mo[0]
            t15 = mo[1]
            t16 = mo[2]
            t17 = mo[3]
            #
            # t18 := X1+Z1;
            # t19 := X2+Z2;
            ma =     [r1z, r1z, 0, 0]
            mb =     [r1x, r1x, 0, 0]
            sign_a = [  1,  1,  1, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t18 = mo[0]
            t19 = mo[1]
            
            # Step 2
            #
            # t20 := t14*t15;
            # t21 := t16*t17;
            # t22 := t18*t19;
            # t23 := X1*X2;
            # t24 := Y1*Y2;
            # t25 := Z1*Z2;
            ma = [t15, t17, t19, r1x, r1y, r1z, 0, 0]
            mb = [t14, t16, t18, r1x, r1y, r1z, 0, 0]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            t20 = mo[0]
            t21 = mo[1]
            t22 = mo[2]
            t23 = mo[3]
            t24 = mo[4]
            t25 = mo[5]
            
            # Step 3
            #
            # t17 := t20-t23;
            # t18 := t21-t24;
            # t19 := t22-t25;
            ma =     [t23, t24, t25, 0]
            mb =     [t20, t21, t22, 0]
            sign_a = [  0,   0,   0, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t17 = mo[0]
            t18 = mo[1]
            t19 = mo[2]
            
            # Step 4
            #
            # t14 := t17-t24;
            # t15 := t18-t25;
            # t16 := t19-t23;
            ma =     [t24, t25, t23, 0]
            mb =     [t17, t18, t19, 0]
            sign_a = [ 0,    0,   0, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t14 = mo[0]
            t15 = mo[1]
            t16 = mo[2]
            
            # Step 5
            #
            # t17 := b3*t25;
            # t18 := a*t25;
            # t19 := a*t16;
            # t20 := b3*t16;
            # t21 := a*t23;
            # t22 := a^2*t25;
            ma  = [const_b3, const_a, const_a, const_b3, const_a, const_a2, 0, 0]
            mb  = [     t25,     t25,     t16,      t16,     t23,      t25, 0, 0]
            mo  = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            t17 = mo[0]
            t18 = mo[1]
            t19 = mo[2]
            t20 = mo[3]
            t21 = mo[4]
            t22 = mo[5]
            
            # Step 6
            #
            # t16 := t17+t19;
            # t25 := t23+t18;
            # t26 := t23+t23;
            # t27 := t20+t21;
            ma =     [t19, t18, t23, t21]
            mb =     [t17, t23, t23, t20]
            sign_a = [ 1,    1,   1,   1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t16 = mo[0]
            t25 = mo[1]
            t26 = mo[2]
            t27 = mo[3]
            
            # Step 7
            #
            # t17 := t27-t22;
            # t18 := t26+t25;
            # t19 := t24-t16;
            # t20 := t24+t16;
            ma =     [t22, t25, t16, t16]
            mb =     [t27, t26, t24, t24]
            sign_a = [  0,   1,   0,   1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t17 = mo[0]
            t18 = mo[1]
            t19 = mo[2]
            t20 = mo[3]
            
            # Step 8
            #
            # t16 := t14*t19;
            # t21 := t14*t18;
            # t22 := t15*t17;
            # t23 := t18*t17;
            # t24 := t20*t19;
            # t25 := t15*t20;
            ma  = [t19, t18, t17, t17, t19, t20, 0, 0]
            mb  = [t14, t14, t15, t18, t20, t15, 0, 0]
            mo  = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            t16  = mo[0]
            t21  = mo[1]
            t22  = mo[2]
            t23  = mo[3]
            t24  = mo[4]
            t25  = mo[5]
            
            # Step 9
            #
            # X3 := t16-t22;
            # Y3 := t24+t23;
            # Z3 := t25+t21;
            ma =     [t22, t23, t21, 0]
            mb =     [t16, t24, t25, 0]
            sign_a = [ 0,    1,   1, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            r1x = mo[0]
            r1y = mo[1]
            r1z = mo[2]
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
            ma =     [r0y, r1y, r0z, r1z]
            mb =     [r0x, r1x, r0y, r1y]
            sign_a = [  1,  1,   1,    1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t0 = mo[0]
            t1 = mo[1]
            t2 = mo[2]
            t3 = mo[3]
            #
            # t4 := X1+Z1;
            # t5 := X2+Z2;
            ma =     [r0z, r1z, 0, 0]
            mb =     [r0x, r1x, 0, 0]
            sign_a = [  1,  1,  1, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t4 = mo[0]
            t5 = mo[1]
            
            # Step 2
            #
            # t6  := t0*t1;
            # t7  := t2*t3;
            # t8  := t4*t5;
            # t9  := X1*X2;
            # t10 := Y1*Y2;
            # t11 := Z1*Z2;
            ma  = [t0, t2, t4, r0x, r0y, r0z, 0, 0]
            mb  = [t1, t3, t5, r1x, r1y, r1z, 0, 0]
            mo  = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            t6  = mo[0]
            t7  = mo[1]
            t8  = mo[2]
            t9  = mo[3]
            t10 = mo[4]
            t11 = mo[5]
            
            # Step 3
            #
            # t3 := t6-t9;
            # t4 := t7-t10;
            # t5 := t8-t11;
            ma =     [t9, t10, t11, 0]
            mb =     [t6,  t7,  t8, 0]
            sign_a = [ 0,   0,   0, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t3 = mo[0]
            t4 = mo[1]
            t5 = mo[2]
            
            # Step 4
            #
            # t0 := t3-t10;
            # t1 := t4-t11;
            # t2 := t5-t9;
            ma =     [t10, t11, t9, 0]
            mb =     [t3,   t4, t5, 0]
            sign_a = [ 0,    0,  0, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t0 = mo[0]
            t1 = mo[1]
            t2 = mo[2]
            
            # Step 5
            #
            # t3 := b3*t11;
            # t4 := a*t11;
            # t5 := a*t2;
            # t6 := b3*t2;
            # t7 := a*t9;
            # t8 := a^2*t11;
            ma  = [const_b3, const_a, const_a, const_b3, const_a, const_a2, 0, 0]
            mb  = [     t11,     t11,      t2,       t2,      t9,      t11, 0, 0]
            mo  = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            t3  = mo[0]
            t4  = mo[1]
            t5  = mo[2]
            t6  = mo[3]
            t7  = mo[4]
            t8  = mo[5]
            
            # Step 6
            #
            # t2  := t3+t5;
            # t11 := t9+t4;
            # t12 := t9+t9;
            # t13 := t6+t7;
            ma =     [t5, t4, t9, t7]
            mb =     [t3, t9, t9, t6]
            sign_a = [ 1,  1,  1,   1]
            mo  = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t2  = mo[0]
            t11 = mo[1]
            t12 = mo[2]
            t13 = mo[3]
            
            # Step 7
            #
            # t3 := t13-t8;
            # t4 := t12+t11;
            # t5 := t10-t2;
            # t6 := t10+t2;
            ma =     [ t8, t11,  t2,  t2]
            mb =     [t13, t12, t10, t10]
            sign_a = [  0,   1,   0,   1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t3 = mo[0]
            t4 = mo[1]
            t5 = mo[2]
            t6 = mo[3]
            
            # Step 8
            #
            # t2 := t0*t5;
            # t7 := t0*t4;
            # t8 := t1*t3;
            # t9 := t4*t3;
            # t10 := t6*t5;
            # t11 := t1*t6;
            ma  = [t5, t4, t3, t3, t5, t6, 0, 0]
            mb  = [t0, t0, t1, t4, t6, t1, 0, 0]
            mo  = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            t2  = mo[0]
            t7  = mo[1]
            t8  = mo[2]
            t9  = mo[3]
            t10 = mo[4]
            t11 = mo[5]
            
            # Step 9
            #
            # X3 := t2-t8;
            # Y3 := t10+t9;
            # Z3 := t11+t7;
            ma =     [t8,  t9,  t7, 0]
            mb =     [t2, t10, t11, 0]
            sign_a = [ 0,   1,   1, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            r1x = mo[0]
            r1y = mo[1]
            r1z = mo[2]
            
            #
            # Point Doubling with Addition
            #
            # Step 1
            #
            # t14 := X1+Y1;
            # t15 := X2+Y2;
            # t16 := Y1+Z1;
            # t17 := Y2+Z2;
            ma =     [r0y, r0y, r0z, r0z]
            mb =     [r0x, r0x, r0y, r0y]
            sign_a = [  1,   1,   1,   1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t14 = mo[0]
            t15 = mo[1]
            t16 = mo[2]
            t17 = mo[3]
            #
            # t18 := X1+Z1;
            # t19 := X2+Z2;
            ma =     [r0z, r0z, 0, 0]
            mb =     [r0x, r0x, 0, 0]
            sign_a = [  1,  1,  1, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t18 = mo[0]
            t19 = mo[1]
            
            # Step 2
            #
            # t20 := t14*t15;
            # t21 := t16*t17;
            # t22 := t18*t19;
            # t23 := X1*X2;
            # t24 := Y1*Y2;
            # t25 := Z1*Z2;
            ma = [t15, t17, t19, r0x, r0y, r0z, 0, 0]
            mb = [t14, t16, t18, r0x, r0y, r0z, 0, 0]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            t20 = mo[0]
            t21 = mo[1]
            t22 = mo[2]
            t23 = mo[3]
            t24 = mo[4]
            t25 = mo[5]
            
            # Step 3
            #
            # t17 := t20-t23;
            # t18 := t21-t24;
            # t19 := t22-t25;
            ma =     [t23, t24, t25, 0]
            mb =     [t20, t21, t22, 0]
            sign_a = [  0,   0,   0, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t17 = mo[0]
            t18 = mo[1]
            t19 = mo[2]
            
            # Step 4
            #
            # t14 := t17-t24;
            # t15 := t18-t25;
            # t16 := t19-t23;
            ma =     [t24, t25, t23, 0]
            mb =     [t17, t18, t19, 0]
            sign_a = [ 0,    0,   0, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t14 = mo[0]
            t15 = mo[1]
            t16 = mo[2]
            
            # Step 5
            #
            # t17 := b3*t25;
            # t18 := a*t25;
            # t19 := a*t16;
            # t20 := b3*t16;
            # t21 := a*t23;
            # t22 := a^2*t25;
            ma  = [const_b3, const_a, const_a, const_b3, const_a, const_a2, 0, 0]
            mb  = [     t25,     t25,     t16,      t16,     t23,      t25, 0, 0]
            mo  = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            t17 = mo[0]
            t18 = mo[1]
            t19 = mo[2]
            t20 = mo[3]
            t21 = mo[4]
            t22 = mo[5]
            
            # Step 6
            #
            # t16 := t17+t19;
            # t25 := t23+t18;
            # t26 := t23+t23;
            # t27 := t20+t21;
            ma =     [t19, t18, t23, t21]
            mb =     [t17, t23, t23, t20]
            sign_a = [ 1,    1,   1,   1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t16 = mo[0]
            t25 = mo[1]
            t26 = mo[2]
            t27 = mo[3]
            
            # Step 7
            #
            # t17 := t27-t22;
            # t18 := t26+t25;
            # t19 := t24-t16;
            # t20 := t24+t16;
            ma =     [t22, t25, t16, t16]
            mb =     [t27, t26, t24, t24]
            sign_a = [  0,   1,   0,   1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t17 = mo[0]
            t18 = mo[1]
            t19 = mo[2]
            t20 = mo[3]
            
            # Step 8
            #
            # t16 := t14*t19;
            # t21 := t14*t18;
            # t22 := t15*t17;
            # t23 := t18*t17;
            # t24 := t20*t19;
            # t25 := t15*t20;
            ma  = [t19, t18, t17, t17, t19, t20, 0, 0]
            mb  = [t14, t14, t15, t18, t20, t15, 0, 0]
            mo  = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            t16  = mo[0]
            t21  = mo[1]
            t22  = mo[2]
            t23  = mo[3]
            t24  = mo[4]
            t25  = mo[5]
            
            # Step 9
            #
            # X3 := t16-t22;
            # Y3 := t24+t23;
            # Z3 := t25+t21;
            ma =     [t22, t23, t21, 0]
            mb =     [t16, t24, t25, 0]
            sign_a = [ 0,    1,   1, 1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            r0x = mo[0]
            r0y = mo[1]
            r0z = mo[2]
            
    o = fp_inv(arithmetic_parameters, r0z, r1z)
    
    inv_r0z  = o[0]
    inv_r1z  = o[1]
    
    ma = [inv_r0z, inv_r0z, inv_r1z, inv_r1z, 0, 0, 0, 0]
    mb = [    r0x,     r0y,     r1x,     r1y, 0, 0, 0, 0]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    r0x = mo[0]
    r0y = mo[1]
    r0z = 1
    r1x = mo[2]
    r1y = mo[3]
    r1z = 1
    
    r0x = iterative_reduction(arithmetic_parameters, remove_montgomery_domain(arithmetic_parameters, r0x))
    r0y = iterative_reduction(arithmetic_parameters, remove_montgomery_domain(arithmetic_parameters, r0y))
    
    r1x = iterative_reduction(arithmetic_parameters, remove_montgomery_domain(arithmetic_parameters, r1x))
    r1y = iterative_reduction(arithmetic_parameters, remove_montgomery_domain(arithmetic_parameters, r1y))
    
    return r0x, r0y

def test_single_scalar_multiplication_weierstrass(arithmetic_parameters, fp, scalar, scalar_max_size, elliptic_curve_constants, elliptic_curve_point, const_a, const_a2, const_b3, debug=False):
    extended_word_size_signed = arithmetic_parameters[0]
    prime = arithmetic_parameters[3]
    number_of_words = arithmetic_parameters[9]
    
    true_final_point = sage_scalar_multiplication_weierstrass(fp, scalar, elliptic_curve_point)
    
    test_final_point = scalar_multiplication_weierstrass(arithmetic_parameters, scalar, scalar_max_size, elliptic_curve_point, const_a, const_a2, const_b3)
    
    if((debug) or (test_final_point[0] != true_final_point[0]) or (test_final_point[1] != true_final_point[1])):
        print("Error in scalar multiplication ")
        print('')
        print("Curve")
        print(elliptic_curve_constants[0])
        print("Prime")
        print(prime)
        print('')
        print("Elliptic curve point")
        print(elliptic_curve_point[0])
        print(elliptic_curve_point[1])
        print(elliptic_curve_point[2])
        print('')
        print("Scalar")
        print(scalar)
        print('')
        print("Test final point")
        print(test_final_point[0])
        print(test_final_point[1])
        print('')
        print("True final point")
        print(true_final_point[0])
        print(true_final_point[1])
        print('')
        return True

    return False
    
def test_scalar_multiplication_weierstrass(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, elliptic_curve_constants, number_of_tests):
    prime = elliptic_curve_constants[1]
    prime_size_bits = int(prime).bit_length()
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    
    error_computation = False
        
    fp = GF(prime)
    
    const_a_mont  = enter_montgomery_domain(arithmetic_parameters, (elliptic_curve_constants[3]) % prime)
    const_a2_mont = enter_montgomery_domain(arithmetic_parameters, (elliptic_curve_constants[3]*elliptic_curve_constants[3]) % prime)
    const_b3_mont = enter_montgomery_domain(arithmetic_parameters, (3*elliptic_curve_constants[4]) % prime)
    
    ell = EllipticCurve(fp, [0, 0, 0, elliptic_curve_constants[3], elliptic_curve_constants[4]])
    ell.set_order(elliptic_curve_constants[2])
    
    elliptic_curve_point = ell(fp(elliptic_curve_constants[5]), fp(elliptic_curve_constants[6]))
    
    scalar_max_size = prime_size_bits
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, elliptic_curve_constants[2]-2]
    for test in fixed_tests:
        scalar = test
        error_computation = test_single_scalar_multiplication_weierstrass(arithmetic_parameters, fp, scalar, scalar_max_size, elliptic_curve_constants, elliptic_curve_point, const_a_mont, const_a2_mont, const_b3_mont)
        tests_already_performed += 1
        if(error_computation):
            break
            
    # Random tests
    if(not error_computation):
        for i in range(tests_already_performed, number_of_tests):
            if(((i %(1000)) == 0)):
                print(i)
            
            scalar = randint(1, elliptic_curve_constants[2]-1)
            
            error_computation = test_single_scalar_multiplication_weierstrass(arithmetic_parameters, fp, scalar, scalar_max_size, elliptic_curve_constants, elliptic_curve_point, const_a_mont, const_a2_mont, const_b3_mont)
            
            if(error_computation):
                break
        
    return error_computation

def print_scalar_multiplication_weierstrass(VHDL_memory_file_name, base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, elliptic_curve_constants, number_of_tests):
    
    VHDL_memory_file = open(VHDL_memory_file_name, 'w')
    
    prime = elliptic_curve_constants[1]
    prime_size_bits = int(prime).bit_length()
    
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
    
    const_a_mont  = enter_montgomery_domain(arithmetic_parameters, (elliptic_curve_constants[3]) % prime)
    const_a2_mont = enter_montgomery_domain(arithmetic_parameters, (elliptic_curve_constants[3]*elliptic_curve_constants[3]) % prime)
    const_b3_mont = enter_montgomery_domain(arithmetic_parameters, (3*elliptic_curve_constants[4]) % prime)
    
    const_a_mont_list  = integer_to_list(extended_word_size_signed, number_of_words, const_a_mont)
    const_a2_mont_list = integer_to_list(extended_word_size_signed, number_of_words, const_a2_mont)
    const_b3_mont_list = integer_to_list(extended_word_size_signed, number_of_words, const_b3_mont)
    
    VHDL_memory_file.write((("{0:0d}").format(number_of_tests)))
    VHDL_memory_file.write('\n')
    
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_plus_one_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_line_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime2_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, r_mod_prime_constant_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, r2_constant_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, constant_1, maximum_number_of_words)
    
    ell = EllipticCurve(fp, [0, 0, 0, elliptic_curve_constants[3], elliptic_curve_constants[4]])
    ell.set_order(elliptic_curve_constants[2])
    
    elliptic_curve_point = ell(fp(elliptic_curve_constants[5]), fp(elliptic_curve_constants[6]))
    
    elliptic_curve_point_x_list = integer_to_list(extended_word_size_signed, number_of_words, int(elliptic_curve_point[0]))
    elliptic_curve_point_y_list = integer_to_list(extended_word_size_signed, number_of_words, int(elliptic_curve_point[1]))
    elliptic_curve_point_z_list = integer_to_list(extended_word_size_signed, number_of_words, int(elliptic_curve_point[2]))
    
    scalar_max_size = prime_size_bits
    
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, const_a_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, const_a2_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, const_b3_mont_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, elliptic_curve_point_x_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, elliptic_curve_point_y_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, elliptic_curve_point_z_list, maximum_number_of_words)
    
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, scalar_max_size, False)
    print_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, prime_size_bits, False)
    
    # Fixed test
    tests_already_performed = 0
    fixed_tests = [1, elliptic_curve_constants[2]-2]
    for test in fixed_tests:
        scalar = test
        
        test_value_scalar_list  = integer_to_list(extended_word_size_signed, number_of_words, scalar)
        
        test_value_o1, test_value_o2 = scalar_multiplication_weierstrass(arithmetic_parameters, scalar, scalar_max_size, elliptic_curve_point, const_a_mont, const_a2_mont, const_b3_mont)
        
        test_value_o1_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1))
        test_value_o2_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_scalar_list, maximum_number_of_words)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        tests_already_performed += 1
        
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        scalar = randint(1, elliptic_curve_constants[2]-1)
        
        test_value_scalar_list  = integer_to_list(extended_word_size_signed, number_of_words, scalar)
        
        test_value_o1, test_value_o2 = scalar_multiplication_weierstrass(arithmetic_parameters, scalar, scalar_max_size, elliptic_curve_point, const_a_mont, const_a2_mont, const_b3_mont)
        
        test_value_o1_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o1))
        test_value_o2_list  = integer_to_list(extended_word_size_signed, number_of_words, int(test_value_o2))
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_scalar_list, maximum_number_of_words)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o1_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o2_list, maximum_number_of_words)
        tests_already_performed += 1
        
    VHDL_memory_file.close()
    
def load_VHDL_scalar_multiplication_weierstrass(VHDL_memory_file_name, base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, elliptic_curve_constants, number_of_tests = 0, debug_mode=False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
    prime = elliptic_curve_constants[1]
    prime_size_bits = int(prime).bit_length()
    
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
    
    fp = GF(prime)
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size_signed
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
    loaded_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime != prime):
        print("Error in scalar multiplication : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error in scalar multiplication : " + str(current_test))
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error in scalar multiplication : " + str(current_test))
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_prime2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime2 != prime2):
        print("Error in scalar multiplication : " + str(current_test))
        print("Error loading the 2*prime")
        print("Loaded 2*prime")
        print(loaded_prime2)
        print("Input 2*prime")
        print(prime2)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r_mod_prime != r_mod_prime_constant):
        print("Error in scalar multiplication : " + str(current_test))
        print("Error loading the r")
        print("Loaded r")
        print(loaded_r_mod_prime)
        print("Input r")
        print(r_mod_prime_constant)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_r2 != r2_constant):
        print("Error in scalar multiplication : " + str(current_test))
        print("Error loading the r2")
        print("Loaded r2")
        print(loaded_r2)
        print("Input r2")
        print(r2_constant)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_constant_1 != 1):
        print("Error in scalar multiplication : " + str(current_test))
        print("Error loading the constant 1")
        print("Loaded constant 1")
        print(loaded_constant_1)
        print("Input constant 1")
        print(1)
    
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    const_a_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    const_a2_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    const_b3_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_elliptic_curve_point_x = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_elliptic_curve_point_y = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_elliptic_curve_point_z = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_scalar_max_size  = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    loaded_prime_size  = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size_signed, False)
    
    while(current_test != (number_of_tests-1)):
    
        loaded_scalar         = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        elliptic_curve_point = [loaded_elliptic_curve_point_x, loaded_elliptic_curve_point_y, loaded_elliptic_curve_point_z]
        
        computed_test_value_o1, computed_test_value_o2 = scalar_multiplication_weierstrass(arithmetic_parameters, loaded_scalar, loaded_scalar_max_size, elliptic_curve_point, const_a_mont, const_a2_mont, const_b3_mont)
        
        
        if((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o2 != loaded_test_value_o2)):
            print("Error in scalar multiplication : " + str(current_test))
            print("Loaded scalar")
            print(loaded_scalar)
            print("Loaded value o1")
            print(loaded_test_value_o1)
            print("Computed value o1")
            print(computed_test_value_o1)
            print("Loaded value o2")
            print(loaded_test_value_o2)
            print("Computed value o2")
            print(computed_test_value_o2)
        current_test += 1
    
    loaded_scalar                 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
        
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    elliptic_curve_point = [loaded_elliptic_curve_point_x, loaded_elliptic_curve_point_y, loaded_elliptic_curve_point_z]
    
    computed_test_value_o1, computed_test_value_o2 = scalar_multiplication_weierstrass(arithmetic_parameters, loaded_scalar, loaded_scalar_max_size, elliptic_curve_point, const_a_mont, const_a2_mont, const_b3_mont)
    
    
    if(debug_mode or ((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o2 != loaded_test_value_o2))):
        print("Error in scalar multiplication : " + str(current_test))
        print("Loaded scalar")
        print(loaded_scalar)
        print("Loaded value o1")
        print('{:0x}'.format(loaded_test_value_o1))
        print("Computed value o1")
        print('{:0x}'.format(computed_test_value_o1))
        print("Loaded value o2")
        print('{:0x}'.format(loaded_test_value_o2))
        print("Computed value o2")
        print('{:0x}'.format(computed_test_value_o2))
    
    VHDL_memory_file.close()
    
    
def test_all_scalar_multiplication_weierstrass(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, ecc_constants):
    error_computation = False
    for param in ecc_constants:
        print("Testing ECC Weierstrass " +  param[0])
        error_computation = test_scalar_multiplication_weierstrass(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, param, number_of_tests)
        if error_computation:
            break;

def print_all_scalar_multiplication_weierstrass(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, ecc_constants, VHDL_file_names):
    for i, param in enumerate(ecc_constants):
        print("Printing ECC Weierstrass " +  param[0])
        VHDL_memory_file_name = VHDL_file_names[i]
        tests_working_folder + "scalar_multiplication_weierstrass_" + str(param[0]) + ".dat"
        print_scalar_multiplication_weierstrass(VHDL_memory_file_name, base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, param, number_of_tests)

def load_all_scalar_multiplication_weierstrass(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, ecc_constants, VHDL_file_names):
    error_computation = False
    for i, param in enumerate(ecc_constants):
        print("Loading ECC Weierstrass " +  param[0])
        VHDL_memory_file_name = VHDL_file_names[i]
        error_computation = load_VHDL_scalar_multiplication_weierstrass(VHDL_memory_file_name, base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, param)
        if error_computation:
            break;


number_of_bits_added = 9
base_word_size = 16
extended_word_size = 256
accumulator_word_size = extended_word_size*2+32
number_of_tests = 100
tests_working_folder = script_working_folder + "../hw_sike_ecc_tests_v256/"


#number_of_bits_added = 9
#base_word_size = 16
#extended_word_size = 128
#accumulator_word_size = extended_word_size*2+32
#number_of_tests = 100
#tests_working_folder = script_working_folder + "../hw_sike_ecc_tests_v128/"

VHDL_file_names = [tests_working_folder + "scalar_multiplication_weierstrass_" + str(param[0]) + ".dat" for param in ecc_constants]

#test_all_scalar_multiplication_weierstrass(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, ecc_constants)
#print_all_scalar_multiplication_weierstrass(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, ecc_constants, VHDL_file_names)
#load_all_scalar_multiplication_weierstrass(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, ecc_constants, VHDL_file_names)

#i = 0
#param = ecc_constants[i]
#print("Loading ECC Weierstrass " +  param[i])
#VHDL_memory_file_name = VHDL_file_names[i]
#error_computation = load_VHDL_scalar_multiplication_weierstrass(VHDL_memory_file_name, base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, param, number_of_tests=1, debug_mode=True)