if 'script_working_folder' not in globals() and 'script_working_folder' not in locals():
    script_working_folder = "/home/pedro/hw-sidh/vhdl_project/sage/"
load(script_working_folder+"base_functions.sage")

def fp_inv(arithmetic_parameters, a, b, debug=False):
    prime = arithmetic_parameters[3]
    r = arithmetic_parameters[12]
    reg = [r, a, r, b]
    
    prime_list = unsigned_integer_to_list(1, 2000, prime-2)
    
    i = len(prime_list) - 1
    
    while(prime_list[i] != 1):
        i = i - 1
    
    while i != 0:
        if(prime_list[i] == 1):
            ma = [reg[1], reg[0], reg[3], reg[2], 0, 0, 0, 0]
            mb = [reg[1], reg[1], reg[3], reg[3], 0, 0, 0, 0]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            reg[1] = mo[0]
            reg[0] = mo[1]
            reg[3] = mo[2]
            reg[2] = mo[3]
        else:
            ma = [reg[0], reg[0], reg[2], reg[2], 0, 0, 0, 0]
            mb = [reg[0], reg[1], reg[2], reg[3], 0, 0, 0, 0]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            reg[0] = mo[0]
            reg[1] = mo[1]
            reg[2] = mo[2]
            reg[3] = mo[3]
        i = i - 1
        
    if(prime_list[i] == 1):
        ma = [reg[1], reg[0], reg[3], reg[2], 0, 0, 0, 0]
        mb = [reg[1], reg[1], reg[3], reg[3], 0, 0, 0, 0]
        mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
        reg[1] = mo[0]
        reg[0] = mo[1]
        reg[3] = mo[2]
        reg[2] = mo[3]
    else:
        ma = [reg[0], reg[0], reg[2], reg[2], 0, 0, 0, 0]
        mb = [reg[0], reg[1], reg[2], reg[3], 0, 0, 0, 0]
        mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
        reg[0] = mo[0]
        reg[1] = mo[1]
        reg[2] = mo[2]
        reg[3] = mo[3]
    
    return [reg[0], reg[2]]

def sage_fp_inv(fp, a, b):
    if(fp(a).divides(fp(1))):
        o1 = fp(a)^(-1)
    else:
        o1 = fp(0)
    if(fp(b).divides(fp(1))):
        o2 = fp(b)^(-1)
    else:
        o2 = fp(0)
    return o1, o2

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

def eval_2_isog(arithmetic_parameters, x2, x2i, z2, z2i, xq, xqi, zq, zqi):
    #t0 = x2+z2
    #t1 = x2-z2
    ma =     [z2i, z2, z2i, z2]
    mb =     [x2i, x2, x2i, x2]
    sign_a = [ 1,   1,   0,  0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    t1i = mo[2]
    t1  = mo[3]
    
    #t2 = xq+zq
    #t3 = xq-zq
    ma =     [zqi, zq, zqi, zq]
    mb =     [xqi, xq, xqi, xq]
    sign_a = [  1,  1,   0,  0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    #t4 = t0*t3
    #t5 = t1*t2
    ma = [t0i,  t0, t0, t0i, t1i,  t1, t1, t1i]
    mb = [ t3, t3i, t3, t3i,  t2, t2i, t2, t2i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t4i = mo[0]
    t4  = mo[1]
    t5i = mo[2]
    t5  = mo[3]
    
    #t2 = t4+t5
    #t3 = t4-t5
    ma =     [t5i, t5, t5i, t5]
    mb =     [t4i, t4, t4i, t4]
    sign_a = [  1,  1,   0,  0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    #t0 = xq*t2
    #t1 = zq*t3
    ma = [xqi,  xq, xq, xqi, zqi,  zq, zq, zqi]
    mb = [ t2, t2i, t2, t2i,  t3, t3i, t3, t3i]
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

def sage_eval_2_isog(fp2, x2, x2i, z2, z2i, xq, xqi, zq, zqi):
    x2 = fp2([x2, x2i])
    z2 = fp2([z2, z2i])
    xq = fp2([xq, xqi])
    zq = fp2([zq, zqi])
    
    # (1) t0 = xp2 + zp2
    # (2) t1 = xp2 - zp2
    t0 = x2+z2
    t1 = x2-z2
    
    # (3) t2 = xq + zq
    # (4) t3 = xq - zq
    t2 = xq+zq
    t3 = xq-zq
    
    # (5) t0 = t0*t3
    # (6) t1 = t1*t2
    t4 = t0*t3
    t5 = t1*t2
    
    # (7) t2 = t0 + t1
    # (8) t3 = t0 - t1
    t2 = t4+t5
    t3 = t4-t5
    
    # (9)  xq = xq*t2
    # (10) zq = zq*t3
    t0 = xq*t2
    t1 = zq*t3
    
    ft0  = t0.polynomial()[0]
    ft0i = t0.polynomial()[1]
    ft1  = t1.polynomial()[0]
    ft1i = t1.polynomial()[1]
    
    return ft0, ft0i, ft1, ft1i

def eval_3_isog(arithmetic_parameters, x, xi, z, zi, k1, k1i, k2, k2i):
    # t0 = x+z
    # t1 = x-z
    ma =     [zi, z, zi, z]
    mb =     [xi, x, xi, x]
    sign_a = [ 1, 1,  0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    t1i = mo[2]
    t1  = mo[3]
    
    # t2 = k1*t0
    # t3 = k2*t1
    ma = [k1i,  k1, k1, k1i, k2i,  k2, k2, k2i]
    mb = [ t0, t0i, t0, t0i,  t1, t1i, t1, t1i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    # t0 = t3+t2
    # t1 = t3-t2
    ma =     [t2i, t2, t2i, t2]
    mb =     [t3i, t3, t3i, t3]
    sign_a = [  1,  1,   0,  0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    t1i = mo[2]
    t1  = mo[3]
    
    # t2 = t0^2
    # t3 = t1^2
    ma = [t0i,  t0, t0, t0i, t1i,  t1, t1, t1i]
    mb = [ t0, t0i, t0, t0i,  t1, t1i, t1, t1i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    # t0 = x*t2
    # t1 = z*t3
    ma = [ xi,   x,  x,  xi, zi,   z,  z,  zi]
    mb = [ t2, t2i, t2, t2i, t3, t3i, t3, t3i]
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

def sage_eval_3_isog(fp2, x, xi, z, zi, k1, k1i, k2, k2i):
    x = fp2([x, xi])
    z = fp2([z, zi])
    k1 = fp2([k1, k1i])
    k2 = fp2([k2, k2i])
    
    # (1) t0 = xq+zq
    # (2) t1 = xq-zq
    t0 = x+z
    t1 = x-z
    
    # (3) t0 = k1*t0
    # (4) t1 = k2*t1
    t2 = k1*t0
    t3 = k2*t1
    
    # (5) t2 = t1+t0
    # (6) t0 = t1-t0
    t0 = t3+t2
    t1 = t3-t2
    
    # (7) t2 = t2^2
    # (8) t0 = t0^2
    t2 = t0^2
    t3 = t1^2
    
    # (9) xq = xq*t2
    # (10) zq = zq*t0
    t0 = x*t2
    t1 = z*t3
    
    ft0  = t0.polynomial()[0]
    ft0i = t0.polynomial()[1]
    ft1  = t1.polynomial()[0]
    ft1i = t1.polynomial()[1]
    
    return ft0, ft0i, ft1, ft1i

def eval_4_isog(arithmetic_parameters, x, xi, z, zi, k1, k1i, k2, k2i, k3, k3i):
    #t0 = x+z
    #t1 = x-z
    ma =     [zi, z, zi, z]
    mb =     [xi, x, xi, x]
    sign_a = [ 1, 1,  0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    t1i = mo[2]
    t1  = mo[3]
    
    #t2 = k2*t0
    #t3 = k3*t1
    ma = [k2i,  k2, k2, k2i, k3i,  k3, k3, k3i]
    mb = [ t0, t0i, t0, t0i,  t1, t1i, t1, t1i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    #t4 = t3+t2
    #t5 = t3-t2
    ma =     [t2i, t2, t2i, t2]
    mb =     [t3i, t3, t3i, t3]
    sign_a = [  1,  1,   0,  0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t4i = mo[0]
    t4  = mo[1]
    t5i = mo[2]
    t5  = mo[3]
    
    #t2 = t4^2
    #t3 = t0*t1
    ma = [t4i,  t4, t4, t4i, t0i,  t0, t0, t0i]
    mb = [ t4, t4i, t4, t4i,  t1, t1i, t1, t1i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    #t0 = t5^2
    #t1 = k1*t3
    ma = [t5i,  t5, t5, t5i, k1i,  k1, k1, k1i]
    mb = [ t5, t5i, t5, t5i,  t3, t3i, t3, t3i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    t1i = mo[2]
    t1  = mo[3]
    
    #t3 = t2+t1
    #t4 = t0-t1
    ma =     [t1i, t1, t1i, t1]
    mb =     [t2i, t2, t0i, t0]
    sign_a = [  1,  1,   0,  0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t3i = mo[0]
    t3  = mo[1]
    t4i = mo[2]
    t4  = mo[3]
    
    #t1 = t2*t3
    #t5 = t0*t4
    ma = [t2i,  t2, t2, t2i, t0i,  t0, t0, t0i]
    mb = [ t3, t3i, t3, t3i,  t4, t4i, t4, t4i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t1i = mo[0]
    t1  = mo[1]
    t5i = mo[2]
    t5  = mo[3]
    
    return t1, t1i, t5, t5i

def sage_eval_4_isog(fp2, x, xi, z, zi, k1, k1i, k2, k2i, k3, k3i):
    tx = fp2([x, xi])
    tz = fp2([z, zi])
    tk1 = fp2([k1, k1i])
    tk2 = fp2([k2, k2i])
    tk3 = fp2([k3, k3i])
    
    # (1) t0 = xq+zq
    # (2) t1 = xq-zq
    t0 = tx+tz
    t1 = tx-tz
    
    # (3) xq = t0*k2
    # (4) zq = t1*k3
    t2 = tk2*t0
    t3 = tk3*t1
    
    # (7) t1 = xq+zq
    # (8) zq = xq-zq
    t4 = t3+t2
    t5 = t3-t2
    
    # (9) t1 = t1**2
    # (5) t0 = t0*t1
    t2 = t4^2
    t3 = t0*t1
    
    # (10) zq = zq**2
    # (6) t0 = t0*k1
    t0 = t5^2
    t1 = tk1*t3
    
    # (11) xq = t0+t1
    # (12) t0 = zq-t0
    t3 = t2+t1
    t4 = t0-t1
    
    # (13) xq = xq*t1
    # (14) zq = zq*t0
    t1 = t2*t3
    t5 = t0*t4
    
    ft1  = t1.polynomial()[0]
    ft1i = t1.polynomial()[1]
    ft5  = t5.polynomial()[0]
    ft5i = t5.polynomial()[1]
    
    return ft1, ft1i, ft5, ft5i

def get_2_isog(arithmetic_parameters, x2, x2i, z2, z2i):
    #t0 = x2^2
    #t1 = z2^2
    ma = [x2i, x2, x2, x2i, z2i, z2, z2, z2i]
    mb = [x2, x2i, x2, x2i, z2, z2i, z2, z2i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    t1i = mo[2]
    t1  = mo[3]
    
    #t2 = t1-t0
    ma =     [t0i, t0, 0, 0]
    mb =     [t1i, t1, 0, 0]
    sign_a = [  0,  0, 1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    
    return t2, t2i, t1, t1i

def sage_get_2_isog(fp2, x2, x2i, z2, z2i):
    x2 = fp2([x2, x2i])
    z2 = fp2([z2, z2i])
    
    # (1) a24_plus = xp2^2
    # (2) c24 = zp2^4
    t0 = x2^2
    t1 = z2^2
    
    # (3) a24_plus = c24 - a24_plus
    t2 = t1-t0
    
    ft2  = t2.polynomial()[0]
    ft2i = t2.polynomial()[1]
    ft1  = t1.polynomial()[0]
    ft1i = t1.polynomial()[1]
    
    return ft2, ft2i, ft1, ft1i

def get_3_isog(arithmetic_parameters, x3, x3i, z3, z3i):
    # t0 = X3+X3
    # t1 = Z3+Z3
    ma =     [x3i, x3, z3i, z3]
    mb =     [x3i, x3, z3i, z3]
    sign_a = [  1,  1,   1,  1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    t1i = mo[2]
    t1  = mo[3]
    
    # t2 = X3-Z3
    # t3 = t1+t1
    ma =     [z3i, z3, t1i, t1]
    mb =     [x3i, x3, t1i, t1]
    sign_a = [  0,  0,   1,  1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t3i = mo[2]
    t3  = mo[3]

    # t1 = t0+t2
    # t4 = X3+Z3
    ma =     [t2i, t2, z3i, z3]
    mb =     [t0i, t0, x3i, x3]
    sign_a = [  1,  1,   1,  1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t1i = mo[0]
    t1  = mo[1]
    t4i = mo[2]
    t4  = mo[3]

    # t0 = t3^2
    # t5 = t1^2
    ma = [t3i,  t3, t3, t3i, t1i,  t1, t1, t1i]
    mb = [ t3, t3i, t3, t3i,  t1, t1i, t1, t1i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    t5i = mo[2]
    t5  = mo[3]
    
    # t3 = t1*t4
    # t6 = X3*Z3
    ma = [t1i,  t1, t1, t1i, x3i,  x3, x3, x3i]
    mb = [ t4, t4i, t4, t4i,  z3, z3i, z3, z3i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t3i = mo[0]
    t3  = mo[1]
    t6i = mo[2]
    t6  = mo[3]
    
    # t1 = t5*t3
    # t7 = t0*t6
    ma = [t5i,  t5, t5, t5i, t0i,  t0, t0, t0i]
    mb = [ t3, t3i, t3, t3i,  t6, t6i, t6, t6i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t1i = mo[0]
    t1  = mo[1]
    t7i = mo[2]
    t7  = mo[3]
    
    # t3 = t1-t7
    ma =     [t7i, t7, 0, 0]
    mb =     [t1i, t1, 0, 0]
    sign_a = [  0,  0, 1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t3i = mo[0]
    t3  = mo[1]

    return t1, t1i, t3, t3i, t2, t2i, t4, t4i

def sage_get_3_isog(fp2, x3, x3i, z3, z3i):
    tx3 = fp2([x3, x3i])
    tz3 = fp2([z3, z3i])
    
    t0 = tx3+tx3
    t1 = tz3+tz3
    
    t2 = tx3-tz3
    t3 = t1+t1

    t1 = t0+t2
    t4 = tx3+tz3
    
    t0 = t3^2
    t5 = t1^2
    
    t3 = t1*t4
    t6 = tx3*tz3
    
    t1 = t5*t3
    t7 = t0*t6
    
    t3 = t1-t7
    
    ft1  = t1.polynomial()[0]
    ft1i = t1.polynomial()[1]
    ft3  = t3.polynomial()[0]
    ft3i = t3.polynomial()[1]
    ft2  = t2.polynomial()[0]
    ft2i = t2.polynomial()[1]
    ft4  = t4.polynomial()[0]
    ft4i = t4.polynomial()[1]
    
    return ft1, ft1i, ft3, ft3i, ft2, ft2i, ft4, ft4i

def get_4_isog(arithmetic_parameters, x4, x4i, z4, z4i):
    #t0 = x4-z4
    #t1 = x4+z4
    ma =     [z4i, z4, z4i, z4]
    mb =     [x4i, x4, x4i, x4]
    sign_a = [  0,  0,   1,  1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    t1i = mo[2]
    t1  = mo[3]
    
    #t2 = x4^2
    #t3 = z4^2
    ma = [x4i, x4, x4, x4i, z4i, z4, z4, z4i]
    mb = [x4, x4i, x4, x4i, z4, z4i, z4, z4i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    #t4 = t2+t2
    #t5 = t3+t3
    ma =     [t2i, t2, t3i, t3]
    mb =     [t2i, t2, t3i, t3]
    sign_a = [  1,  1,   1,  1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t4i = mo[0]
    t4  = mo[1]
    t5i = mo[2]
    t5  = mo[3]
    
    #t2 = t4^2
    #t3 = t5^2
    ma = [t4i, t4, t4, t4i, t5i, t5, t5, t5i]
    mb = [t4, t4i, t4, t4i, t5, t5i, t5, t5i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    #t4 = t5+t5
    ma =     [t5i, t5, 0, 0]
    mb =     [t5i, t5, 0, 0]
    sign_a = [  1,  1, 1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t4i = mo[0]
    t4  = mo[1]
    
    return t2, t2i, t3, t3i, t4, t4i, t0, t0i, t1, t1i

def sage_get_4_isog(fp2, x4, x4i, z4, z4i):
    x4 = fp2([x4, x4i])
    z4 = fp2([z4, z4i])
    
    # (1) k2 = xp4-zp4
    # (2) k3 = xp4+zp4
    t0 = x4-z4
    t1 = x4+z4
    
    # (7) a24_plus = xp4^2
    # (3) k1 = zp4^4
    t2 = x4^2
    t3 = z4^2
    
    # (8) a24_plus = a24_plus + a24_plus
    # (4) k1 = k1+k1
    t4 = t2+t2
    t5 = t3+t3
    
    # (9) a24_plus = a24_plus^2
    # (5) c24_plus = k1^2
    t2 = t4^2
    t3 = t5^2
    
    # (6) k1 = k1+k1
    t4 = t5+t5
    
    ft2  = t2.polynomial()[0]
    ft2i = t2.polynomial()[1]
    ft3  = t3.polynomial()[0]
    ft3i = t3.polynomial()[1]
    ft4  = t4.polynomial()[0]
    ft4i = t4.polynomial()[1]
    ft0  = t0.polynomial()[0]
    ft0i = t0.polynomial()[1]
    ft1  = t1.polynomial()[0]
    ft1i = t1.polynomial()[1]
    
    return ft2, ft2i, ft3, ft3i, ft4, ft4i, ft0, ft0i, ft1, ft1i

def get_A(arithmetic_parameters, xp, xpi, xq, xqi, xr, xri, debug=False):
    # A = (XP*XQ+XP*XR+XQ*XR-1)^2 
    #       / (4*XP*XQ*XR) - XP - XQ - XR
    
    #t0 = XP+XQ
    #t1 = XR+XR
    ma =     [xpi, xp, xri, xr]
    mb =     [xqi, xq, xri, xr]
    sign_a = [ 1,   1,  1,   1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    t1i = mo[2]
    t1  = mo[3]

    #t2 = XP*XQ
    #t3 = t0*XR
    ma = [xpi,  xp, xp, xpi, t0i,  t0, t0, t0i]
    mb = [ xq, xqi, xq, xqi,  xr, xri, xr, xri]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    #t4 = t0+XR
    #t5 = t2+t3
    ma =     [t0i, t0, t2i, t2]
    mb =     [xri, xr, t3i, t3]
    sign_a = [ 1,   1,  1,   1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t4i = mo[0]
    t4  = mo[1]
    t5i = mo[2]
    t5  = mo[3]

    const_r = arithmetic_parameters[12]
    #t0 = t5-1
    #t3 = t2+t2
    ma =     [   0, const_r, t2i, t2]
    mb =     [ t5i,      t5, t2i, t2]
    sign_a = [   0,       0,   1,  1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    #t2 = t0^2
    #t5 = t3*t1
    ma = [t0i,  t0, t0, t0i, t3i,  t3, t3, t3i]
    mb = [ t0, t0i, t0, t0i,  t1, t1i, t1, t1i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t5i = mo[2]
    t5  = mo[3]
    
    #t0 = 1/t5
    mo = fp2_inv(arithmetic_parameters, t5, t5i, 0, 0)
    t0  = mo[0]
    t0i = mo[1]
    
    #t1 = t2*t0
    ma = [t2i,  t2, t2, t2i, 0, 0, 0, 0]
    mb = [ t0, t0i, t0, t0i, 0, 0, 0, 0]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], 0, 0]
    mb =     [mo[1], mo[2], 0, 0]
    sign_a = [    1,     0, 1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t1i = mo[0]
    t1  = mo[1]
    
    #t0 = t1-t4
    ma =     [t4i, t4, 0, 0]
    mb =     [t1i, t1, 0, 0]
    sign_a = [  0,  0, 1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    
    return t0, t0i

def sage_get_A(fp2, xp, xpi, xq, xqi, xr, xri, debug=False):
    
    txp = fp2([xp, xpi])
    txq = fp2([xq, xqi])
    txr = fp2([xr, xri])
    
    # (1) t1 = xp+xq
    # () = xq-p+xq-p
    t0 = txp+txq
    t1 = txr+txr
    
    # (2) t0 = xp*xq
    # (3) A  = xq-p*t1
    t2 = txp*txq
    t3 = t0*txr
    
    # (8) t1 = t1+xq-p
    # (4) A  = A+t0
    t4 = t0+txr
    t5 = t2+t3
    
    # (6) A  = A-1
    # ()     = 2*xp*xq
    t0 = t5-fp2(1)
    t3 = t2+t2
    
    # (10) A = A^2
    # (9,7,5) t0 = t0+t0 = t0+t0+t0+t0 = 4*xp*xq*xq-p = (2*xp*xq)*(2*xq-p)
    t2 = t0^2
    t5 = t3*t1
    
    # (11) t0 = 1/t0
    if(not t5.divides(1)):
        t0 = fp2(0)
    else:
        t0 = 1/t5
    
    # (12) A = A*t0
    t1 = t2*t0
    
    # (13) A = A-t1
    t0 = t1-t4
    
    ft0  = t0.polynomial()[0]
    ft0i = t0.polynomial()[1]
    
    return ft0, ft0i

def j_inv(arithmetic_parameters, a, ai, c, ci, debug=False):
    # j = 256*(A^2-3*C^2)^3 / (C^4*(A^2-4*C^2))
    ma = [0 for i in range(8)]
    mb = [0 for i in range(8)]
    
    #t0 = A^2
    #t1 = C^2
    ma = [ai, a, a, ai, ci, c, c, ci]
    mb = [a, ai, a, ai, c, ci, c, ci]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    t1i = mo[2]
    t1  = mo[3]
    #t2 = t0-t1
    #t3 = t1+t1
    ma =     [t1i, t1, t1i, t1]
    mb =     [t0i, t0, t1i, t1]
    sign_a = [  0,  0,  1,   1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    #t0 = t2-t3
    ma =     [t3i, t3,  0, 0]
    mb =     [t2i, t2,  0, 0]
    sign_a = [  0,  0,  1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    
    #t2 = t0+t0
    #t3 = t0-t1
    ma =     [t0i, t0, t1i, t1]
    mb =     [t0i, t0, t0i, t0]
    sign_a = [  1,  1,   0,  0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t3i = mo[2]
    t3  = mo[3]
    
    #t0 = t2+t2
    ma =     [t2i, t2, 0, 0]
    mb =     [t2i, t2, 0, 0]
    sign_a = [  1,  1, 0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    
    #t2 = t0^2
    #t4 = t1^2
    ma = [t0i, t0, t0, t0i, t1i, t1, t1, t1i]
    mb = [t0, t0i, t0, t0i, t1, t1i, t1, t1i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    t4i = mo[2]
    t4  = mo[3]
    
    #t1 = t0*t2
    #t5 = t3*t4
    ma = [t0i, t0, t0, t0i, t3i, t3, t3, t3i]
    mb = [t2, t2i, t2, t2i, t4, t4i, t4, t4i]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], mo[4], mo[7]]
    mb =     [mo[1], mo[2], mo[5], mo[6]]
    sign_a = [    1,     0,     1,     0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t1i = mo[0]
    t1  = mo[1]
    t5i = mo[2]
    t5  = mo[3]
    
    #t0 = 1 / t5
    mo = fp2_inv(arithmetic_parameters, t5, t5i, 0, 0)
    t0  = mo[0]
    t0i = mo[1]
    
    #t2 = t1*t0
    ma = [t1i, t1, t1, t1i, 0, 0, 0, 0]
    mb = [t0, t0i, t0, t0i, 0, 0, 0, 0]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    ma =     [mo[0], mo[3], 0, 0]
    mb =     [mo[1], mo[2], 0, 0]
    sign_a = [    1,     0, 1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t2i = mo[0]
    t2  = mo[1]
    
    #t0 = t2+t2
    ma =     [t2i, t2, 0, 0]
    mb =     [t2i, t2, 0, 0]
    sign_a = [  1,  1, 0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t0i = mo[0]
    t0  = mo[1]
    
    #t1 = t0+t0
    ma =     [t0i, t0, 0, 0]
    mb =     [t0i, t0, 0, 0]
    sign_a = [  1,  1, 0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    t1i = mo[0]
    t1  = mo[1]
    
    return t1, t1i

def sage_j_inv(fp2, a, ai, c, ci, debug=False):
    ta = fp2([a, ai])
    tc = fp2([c, ci])
    
    # (1) j  = A^2
    # (2) t1 = C^2
    t0 = ta^2
    t1 = tc^2
    
    # (4) t0 = j-t0 = j-2*t1
    # (3) t0 = t1+t1
    t2 = t0-t1
    t3 = t1+t1
    
    # (5) t0 = t0-t1 = j-t0-t1 = j-2*t1-t1 = j-3*t1
    t0 = t2-t3
    
    # (9) t0 = t0+t0
    # (6) j  = t0-t1
    t2 = t0+t0
    t3 = t0-t1
    
    # (10) t0 = t0+t0
    t0 = t2+t2
    
    # (11) t1 = t0^2
    # (7) t4  = t1^2
    t2 = t0^2
    t4 = t1^2
    
    # (12) t0 = t0*t1
    # (8)  j  = j*t1
    t1 = t0*t2
    t5 = t3*t4
    
    # (15) j = 1/j
    if(not t5.divides(1)):
        t0 = fp2(0)
    else:
        t0 = t5^(-1)
    
    # (16) j = t0*j
    t2 = t1*t0
    
    # (13) t0 = t0+t0
    t0 = t2+t2
    
    # (14) t0 = t0+t0
    t1 = t0+t0
    
    ft1  = t1.polynomial()[0]
    ft1i = t1.polynomial()[1]
    
    return ft1, ft1i

def xDBLe(arithmetic_parameters, x, xi, z, zi, a24, a24i, c24, c24i, e):
    # t0 = X; t1 = Z
    t0  = x
    t0i = xi
    t1  = z
    t1i = zi
    
    for i in range(0,e):
        # t4 = t0-t1
        # t5 = t0+t1
        ma =     [t1i, t1, t1i, t1]
        mb =     [t0i, t0, t0i, t0]
        sign_a = [  0,  0,   1,  1]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t4i = mo[0]
        t4  = mo[1]
        t5i = mo[2]
        t5  = mo[3]
        
        # t2 = t4^2
        # t3 = t5^2
        ma = [t4i, t4, t4, t4i, t5i, t5, t5, t5i]
        mb = [t4, t4i, t4, t4i, t5, t5i, t5, t5i]
        mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
        ma =     [mo[0], mo[3], mo[4], mo[7]]
        mb =     [mo[1], mo[2], mo[5], mo[6]]
        sign_a = [    1,     0,     1,     0]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t2i = mo[0]
        t2  = mo[1]
        t3i = mo[2]
        t3  = mo[3]
        
        # t0 = t3-t2
        ma =     [t2i, t2, 0, 0]
        mb =     [t3i, t3, 0, 0]
        sign_a = [  0,  0, 1, 1]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t0i = mo[0]
        t0  = mo[1]
        
        # t4 = A24*t0
        # t1 = C24*t2
        ma = [a24i, a24, a24, a24i, c24i, c24, c24, c24i]
        mb = [  t0, t0i,  t0,  t0i,   t2, t2i,  t2,  t2i]
        mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
        ma =     [mo[0], mo[3], mo[4], mo[7]]
        mb =     [mo[1], mo[2], mo[5], mo[6]]
        sign_a = [    1,     0,     1,     0]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t4i = mo[0]
        t4  = mo[1]
        t1i = mo[2]
        t1  = mo[3]
        
        # t2 = t1+t4
        ma =     [t4i, t4, 0, 0]
        mb =     [t1i, t1, 0, 0]
        sign_a = [  1,  1, 1, 1]
        mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
        t2i = mo[0]
        t2  = mo[1]
        
        # t0 = t3*t1
        # t1 = t0*t2
        ma = [t3i,  t3, t3, t3i, t0i,  t0, t0, t0i]
        mb = [ t1, t1i, t1, t1i,  t2, t2i, t2, t2i]
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

def sage_xDBLe(fp2, x, xi, z, zi, a24, a24i, c24, c24i, e):
    tx   = fp2([x, xi])
    tz   = fp2([z, zi])
    ta24 = fp2([a24, a24i])
    tc24 = fp2([c24, c24i])
    
    for i in range(0,e):
        # (1) t0 = Xp - Zp
        # (2) t1 = Xp + Zp
        t0 = tx-tz
        t1 = tx+tz
        
        # (3) t0 = t0^2
        # (4) t1 = t1^2
        t2 = t0^2
        t3 = t1^2
        
        # (7) t1 = t1-t0
        t0 = t3-t2
        
        # (5) Z2P = C24*t0
        # (8) t0  = A24*t1
        t1 = tc24*t2
        t4 = ta24*t0
        
        # (9) Z2P = Z2P+t0
        t2 = t1+t4
        
        # (6)  X2P = Z2P*t1
        # (10) Z2P = Z2P*t1
        t4 = t3*t1
        t5 = t0*t2
        
        tx = t4
        tz = t5
    
    ft0  = tx.polynomial()[0]
    ft0i = tx.polynomial()[1]
    ft1  = tz.polynomial()[0]
    ft1i = tz.polynomial()[1]
    
    return ft0, ft0i, ft1, ft1i

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

def ladder_3_pt(arithmetic_parameters, m, m_bits, xp, xpi, xq, xqi, xpq, xpqi, a, ai, inv_4):
    extended_word_size_signed = arithmetic_parameters[0]
    number_of_words = arithmetic_parameters[9]
    const_r = arithmetic_parameters[12]
    
    #A24 = (A+2) / 4
    ma =     [ 0, 2*const_r, 0, 0]
    mb =     [ai, a, 0, 0]
    sign_a = [ 1, 1, 1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    a2i = mo[0]
    a2  = mo[1]
    ma = [   a2i,    a2,  0, 0, 0, 0, 0, 0]
    mb = [ inv_4, inv_4,  0, 0, 0, 0, 0, 0]
    mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
    a24i = mo[0]
    a24  = mo[1]
    
    #r0 = XQ;  z0 = 1
    #r1 = XP;  z1 = 1
    #r2 = XPQ; z2 = 1
    r0  = xq
    r0i = xqi
    r1  = xp
    r1i = xpi
    r2  = xpq
    r2i = xpqi
    z0 = const_r
    z0i = 0
    z1 = const_r
    z1i = 0
    z2 = const_r
    z2i = 0
    exponent = m
    t0 = t0i = t1 = t1i = t2 = t2i = t3 = t3i = t7 = t7i = t8 = t8i = 0
    for i in range(0,m_bits):
        if (exponent & 1) == 1:
            #r0, r0i, z0, z0i, r1, r1i, z1, z1i = xDBLADD(arithmetic_parameters, r0, r0i, z0, z0i, r1, r1i, z1, z1i, r2, r2i, a24, a24i)

            #t0 = r0+z0
            #t1 = r0-z0
            ma =     [z0i, z0, z0i, z0]
            mb =     [r0i, r0, r0i, r0]
            sign_a = [  1,  1,   0,  0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t0i = mo[0]
            t0  = mo[1]
            t1i = mo[2]
            t1  = mo[3]

            #t2 = r1+z1
            #t3 = r1-z1
            ma =     [z1i, z1, z1i, z1]
            mb =     [r1i, r1, r1i, r1]
            sign_a = [  1,  1,   0,  0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t2i = mo[0]
            t2  = mo[1]
            t3i = mo[2]
            t3  = mo[3]

            #z1 = t0*t3
            #t7 = t1*t2
            ma = [t0i, t0, t0, t0i, t1i, t1, t1, t1i]
            mb = [t3, t3i, t3, t3i, t2, t2i, t2, t2i]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            ma =     [mo[0], mo[3], mo[4], mo[7]]
            mb =     [mo[1], mo[2], mo[5], mo[6]]
            sign_a = [    1,     0,     1,     0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            z1i = mo[0]
            z1  = mo[1]
            t7i = mo[2]
            t7  = mo[3]

            #t2 = t0^2
            #t3 = t1^2
            ma = [t0i, t0, t0, t0i, t1i, t1, t1, t1i]
            mb = [t0, t0i, t0, t0i, t1, t1i, t1, t1i]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            ma =     [mo[0], mo[3], mo[4], mo[7]]
            mb =     [mo[1], mo[2], mo[5], mo[6]]
            sign_a = [    1,     0,     1,     0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t2i = mo[0]
            t2  = mo[1]
            t3i = mo[2]
            t3  = mo[3]

            #t0 = t2-t3
            #t1 = z1-t7
            ma =     [t3i, t3, t7i, t7]
            mb =     [t2i, t2, z1i, z1]
            sign_a = [  0,  0,   0,  0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t0i = mo[0]
            t0  = mo[1]
            t1i = mo[2]
            t1  = mo[3]

            #r1 = A24*t0
            #r0 = t2*t3
            ma = [a24i, a24, a24, a24i, t2i, t2, t2, t2i]
            mb = [  t0, t0i,  t0,  t0i, t3, t3i, t3, t3i]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            ma =     [mo[0], mo[3], mo[4], mo[7]]
            mb =     [mo[1], mo[2], mo[5], mo[6]]
            sign_a = [    1,     0,     1,     0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            r1i = mo[0]
            r1  = mo[1]
            r0i = mo[2]
            r0  = mo[3]

            #t2 = r1+t3
            #t8 = z1+t7
            ma =     [t3i, t3, t7i, t7]
            mb =     [r1i, r1, z1i, z1]
            sign_a = [  1,  1,   1,  1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t2i = mo[0]
            t2  = mo[1]
            t8i = mo[2]
            t8  = mo[3]

            #t3 = t1^2
            #r1 = t8^2
            ma = [t1i,  t1, t1, t1i, t8i,  t8, t8, t8i]
            mb = [ t1, t1i, t1, t1i,  t8, t8i, t8, t8i]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            ma =     [mo[0], mo[3], mo[4], mo[7]]
            mb =     [mo[1], mo[2], mo[5], mo[6]]
            sign_a = [    1,     0,     1,     0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t3i = mo[0]
            t3  = mo[1]
            r1i = mo[2]
            r1  = mo[3]

            #z0 = t2*t0
            #z1 = r2*t3
            ma = [ t2i,  t2,  t2,  t2i, r2i,  r2, r2, r2i]
            mb = [  t0, t0i,  t0,  t0i,  t3, t3i, t3, t3i]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            ma =     [mo[0], mo[3], mo[4], mo[7]]
            mb =     [mo[1], mo[2], mo[5], mo[6]]
            sign_a = [    1,     0,     1,     0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            z0i = mo[0]
            z0  = mo[1]
            z1i = mo[2]
            z1  = mo[3]

            #r0  = t5
            #r0i = t5i
            #z0  = t1
            #z0i = t1i
            #r1  = t4
            #r1i = t4i
            #z1  = t6
            #z1i = t6i
            
            #r1 = r1*z2
            ma = [ r1i,  r1,  r1,  r1i, 0, 0, 0, 0]
            mb = [  z2, z2i,  z2,  z2i, 0, 0, 0, 0]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            ma =     [mo[0], mo[3], 0, 0]
            mb =     [mo[1], mo[2], 0, 0]
            sign_a = [    1,     0, 1, 0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            r1i = mo[0]
            r1  = mo[1]
        else:
            #r0, r0i, z0, z0i, r2, r2i, z2, z2i = xDBLADD(arithmetic_parameters, r0, r0i, z0, z0i, r2, r2i, z2, z2i, r1, r1i, a24, a24i)

            #t0 = r0+z0
            #t1 = r0-z0
            ma =     [z0i, z0, z0i, z0]
            mb =     [r0i, r0, r0i, r0]
            sign_a = [  1,  1,   0,  0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t0i = mo[0]
            t0  = mo[1]
            t1i = mo[2]
            t1  = mo[3]

            #t2 = r2+z2
            #t3 = r2-z2
            ma =     [z2i, z2, z2i, z2]
            mb =     [r2i, r2, r2i, r2]
            sign_a = [  1,  1,   0,  0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t2i = mo[0]
            t2  = mo[1]
            t3i = mo[2]
            t3  = mo[3]

            #z2 = t0*t3
            #t7 = t1*t2
            ma = [t0i, t0, t0, t0i, t1i, t1, t1, t1i]
            mb = [t3, t3i, t3, t3i, t2, t2i, t2, t2i]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            ma =     [mo[0], mo[3], mo[4], mo[7]]
            mb =     [mo[1], mo[2], mo[5], mo[6]]
            sign_a = [    1,     0,     1,     0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            z2i = mo[0]
            z2  = mo[1]
            t7i = mo[2]
            t7  = mo[3]

            #t2 = t0^2
            #t3 = t1^2
            ma = [t0i, t0, t0, t0i, t1i, t1, t1, t1i]
            mb = [t0, t0i, t0, t0i, t1, t1i, t1, t1i]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            ma =     [mo[0], mo[3], mo[4], mo[7]]
            mb =     [mo[1], mo[2], mo[5], mo[6]]
            sign_a = [    1,     0,     1,     0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t2i = mo[0]
            t2  = mo[1]
            t3i = mo[2]
            t3  = mo[3]

            #t0 = t2-t3
            #t1 = z2-t7
            ma =     [t3i, t3, t7i, t7]
            mb =     [t2i, t2, z2i, z2]
            sign_a = [  0,  0,   0,  0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t0i = mo[0]
            t0  = mo[1]
            t1i = mo[2]
            t1  = mo[3]

            #r2 = A24*t0
            #r0 = t2*t3
            ma = [a24i, a24, a24, a24i, t2i, t2, t2, t2i]
            mb = [  t0, t0i,  t0,  t0i, t3, t3i, t3, t3i]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            ma =     [mo[0], mo[3], mo[4], mo[7]]
            mb =     [mo[1], mo[2], mo[5], mo[6]]
            sign_a = [    1,     0,     1,     0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            r2i = mo[0]
            r2  = mo[1]
            r0i = mo[2]
            r0  = mo[3]

            #t2 = r2+t3
            #t8 = z2+t7
            ma =     [t3i, t3, t7i, t7]
            mb =     [r2i, r2, z2i, z2]
            sign_a = [  1,  1,   1,  1]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t2i = mo[0]
            t2  = mo[1]
            t8i = mo[2]
            t8  = mo[3]

            #t3 = t1^2
            #r2 = t8^2
            ma = [t1i,  t1, t1, t1i, t8i,  t8, t8, t8i]
            mb = [ t1, t1i, t1, t1i,  t8, t8i, t8, t8i]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            ma =     [mo[0], mo[3], mo[4], mo[7]]
            mb =     [mo[1], mo[2], mo[5], mo[6]]
            sign_a = [    1,     0,     1,     0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            t3i = mo[0]
            t3  = mo[1]
            r2i = mo[2]
            r2  = mo[3]

            #z0 = t2*t0
            #z2 = r1*t3
            ma = [ t2i,  t2,  t2,  t2i, r1i,  r1, r1, r1i]
            mb = [  t0, t0i,  t0,  t0i,  t3, t3i, t3, t3i]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            ma =     [mo[0], mo[3], mo[4], mo[7]]
            mb =     [mo[1], mo[2], mo[5], mo[6]]
            sign_a = [    1,     0,     1,     0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            z0i = mo[0]
            z0  = mo[1]
            z2i = mo[2]
            z2  = mo[3]

            #r0  = t5
            #r0i = t5i
            #z0  = t1
            #z0i = t1i
            #r2  = t4
            #r2i = t4i
            #z2  = t6
            #z2i = t6i
            
            #r2 = r2*z1
            ma = [ r2i,  r2,  r2,  r2i, 0, 0, 0, 0]
            mb = [  z1, z1i,  z1,  z1i, 0, 0, 0, 0]
            mo = mac_8_montgomery_multiplication(arithmetic_parameters, ma, mb)
            ma =     [mo[0], mo[3], 0, 0]
            mb =     [mo[1], mo[2], 0, 0]
            sign_a = [    1,     0, 1, 0]
            mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
            r2i = mo[0]
            r2  = mo[1]
        exponent = exponent // 2
    return r1, r1i, z1, z1i

def sage_ladder_3_pt(fp2, m, m_bits, xp, xpi, xq, xqi, xpq, xpqi, a, ai, inv_4):
    a24 = (fp2([a, ai])+fp2(2)) * inv_4
    r0  = fp2([xq, xqi]);   z0 = fp2(1)
    r1  = fp2([xp, xpi]);   z1 = fp2(1)
    r2  = fp2([xpq, xpqi]); z2 = fp2(1)
    
    exponent = m
    for i in range(0,m_bits):
        if ( exponent & 1 ) == 1:
            # (1) t0  = xp+zp
            # (2) t1  = xp-zp
            t0 = r0+z0
            t1 = r0-z0
            
            # (5) xp+q  = xq+zq
            # (4) t2    = xq-zq
            t2 = r1+z1
            t3 = r1-z1
            
            # (6) t0 = t0*t2
            # (8) t1 = t1*xp+q
            t6 = t0*t3
            t7 = t1*t2
            
            # (3) x2p = t0^2
            # (7) z2p = t1^2
            t2 = t0^2
            t3 = t1^2
            
            # (9) t2    = x2p-z2p
            # (12) zp+q = t0-t1
            t0 = t2-t3
            t1 = t6-t7
            
            # (11) xp+q = a24*t2
            # (10) x2p = x2p*z2p 
            t4 = a24*t0
            t5 = t2*t3
            
            # (13) z2p  = xp+q+z2p
            # (14) xp+q = t0+t1
            t2 = t4+t3
            t8 = t6+t7
            
            # (16) zp+q = zp+q^2
            # (17) xp+q = xp+q^2
            t3 = t1^2
            t4 = t8^2
            
            # (15) z2p = z2p*t2
            # (18) zp+q = xq-p*zp+q
            t1 = t2*t0
            t6 = r2*t3
            
            r0 = t5
            z0 = t1
            r1 = t4
            z1 = t6
            
            # (19) xp+q = zq-p*xp+q
            r1 = r1*z2
        else:
            # (1) t0  = xp+zp
            # (2) t1  = xp-zp
            t0 = r0+z0
            t1 = r0-z0
            
            # (5) xp+q  = xq+zq
            # (4) t2    = xq-zq
            t2 = r2+z2
            t3 = r2-z2
            
            # (6) t0 = t0*t2
            # (8) t1 = t1*xp+q
            t6 = t0*t3
            t7 = t1*t2
            
            # (3) x2p = t0^2
            # (7) z2p = t1^2
            t2 = t0^2
            t3 = t1^2
            
            # (9) t2    = x2p-z2p
            # (12) zp+q = t0-t1
            t0 = t2-t3
            t1 = t6-t7
            
            # (11) xp+q = a24*t2
            # (10) x2p = x2p*z2p 
            t4 = a24*t0
            t5 = t2*t3
            
            # (13) z2p  = xp+q+z2p
            # (14) xp+q = t0+t1
            t2 = t4+t3
            t8 = t6+t7
            
            # (16) zp+q = zp+q^2
            # (17) xp+q = xp+q^2
            t3 = t1^2
            t4 = t8^2
            
            # (15) z2p = z2p*t2
            # (18) zp+q = xq-p*zp+q
            t1 = t2*t0
            t6 = r1*t3
            
            r0 = t5
            z0 = t1
            r2 = t4
            z2 = t6
            
            # (19) xp+q = zq-p*xp+q
            r2 = r2*z1
        exponent = exponent // 2
    fr1  = r1.polynomial()[0]
    fr1i = r1.polynomial()[1]
    fz1  = z1.polynomial()[0]
    fz1i = z1.polynomial()[1]
    
    return fr1, fr1i, fz1, fz1i