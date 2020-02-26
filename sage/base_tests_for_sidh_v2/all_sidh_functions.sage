proof.arithmetic(False)
home_folder = "/home/pedro/"
script_working_folder = home_folder + "hw-sidh/vhdl_project/sage/"
load(script_working_folder+"base_tests_for_sidh_basic_procedures/all_sidh_basic_procedures.sage")

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

def sage_keygen_bob_fast(fp2, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk, ob_bits, splits, max_row, max_int_points, inv_4):
    
    phiPX  = xpa
    phiPXi = xpai
    phiQX  = xqa
    phiQXi = xqai
    phiRX  = xra
    phiRXi = xrai
    phiPZ  = 1
    phiPZi = 0
    phiQZ  = 1
    phiQZi = 0
    phiRZ  = 1
    phiRZi = 0
    A24plus = 1
    A24plusi = 0
    Ai = 0
    A24minusi = 0
    
    A24plus = A24plus + A24plus
    A24minus = A24plus + A24plus
    A = A24minus + A24plus
    A24plus = A24minus + A24minus
    
    RX, RXi, RZ, RZi = sage_ladder_3_pt(fp2, sk, ob_bits-1, xpb, xpbi, xqb, xqbi, xrb, xrbi, A, Ai, inv_4)
    
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
            RX, RXi, RZ, RZi = sage_xTPLe(fp2, RX, RXi, RZ, RZi, A24minus, A24minusi, A24plus, A24plusi, m);
            index += m;
            if(npts > max_npts):
                max_npts = npts

        A24minus, A24minusi, A24plus, A24plusi, k1, k1i, k2, k2i = sage_get_3_isog(fp2, RX, RXi, RZ, RZi)
        
        for i in range(npts):
            ptsX[i], ptsXi[i], ptsZ[i], ptsZi[i] = sage_eval_3_isog(fp2, ptsX[i], ptsXi[i], ptsZ[i], ptsZi[i], k1, k1i, k2, k2i)
        
        phiPX, phiPXi, phiPZ, phiPZi = sage_eval_3_isog(fp2, phiPX, phiPXi, phiPZ, phiPZi, k1, k1i, k2, k2i)
        phiQX, phiQXi, phiQZ, phiQZi = sage_eval_3_isog(fp2, phiQX, phiQXi, phiQZ, phiQZi, k1, k1i, k2, k2i)
        phiRX, phiRXi, phiRZ, phiRZi = sage_eval_3_isog(fp2, phiRX, phiRXi, phiRZ, phiRZi, k1, k1i, k2, k2i)
        
        RX  = ptsX[npts-1]
        RXi = ptsXi[npts-1]
        RZ  = ptsZ[npts-1]
        RZi = ptsZi[npts-1]
        index = pts_index[npts-1];
        npts -= 1;
        
        
    A24minus, A24minusi, A24plus, A24plusi, k1, k1i, k2, k2i = sage_get_3_isog(fp2, RX, RXi, RZ, RZi)
    phiPX, phiPXi, phiPZ, phiPZi = sage_eval_3_isog(fp2, phiPX, phiPXi, phiPZ, phiPZi, k1, k1i, k2, k2i)
    phiQX, phiQXi, phiQZ, phiQZi = sage_eval_3_isog(fp2, phiQX, phiQXi, phiQZ, phiQZi, k1, k1i, k2, k2i)
    phiRX, phiRXi, phiRZ, phiRZi = sage_eval_3_isog(fp2, phiRX, phiRXi, phiRZ, phiRZi, k1, k1i, k2, k2i)
    
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

def keygen_bob_fast(arithmetic_parameters, xpa, xpai, xqa, xqai, xra, xrai, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk, ob_bits, splits, max_row, max_int_points, inv_4):
    const_r = arithmetic_parameters[12]
    
    phiPX  = xpa
    phiPXi = xpai
    phiQX  = xqa
    phiQXi = xqai
    phiRX  = xra
    phiRXi = xrai
    phiPZ  = const_r
    phiPZi = 0
    phiQZ  = const_r
    phiQZi = 0
    phiRZ  = const_r
    phiRZi = 0
    
    ma =     [ const_r, 0, 0, 0]
    mb =     [ const_r, 0, 0, 0]
    sign_a = [       1, 0, 0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    A24plus = mo[0]
    ma =     [ A24plus, 0, 0, 0]
    mb =     [ A24plus, 0, 0, 0]
    sign_a = [       1, 0, 0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    A24minus = mo[0]
    A24minusi = 0
    ma =     [ A24minus, A24minus, 0, 0]
    mb =     [ A24plus,  A24minus, 0, 0]
    sign_a = [       1,         1, 0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    A = mo[0]
    A24plus = mo[1]
    Ai     = 0
    A24plusi = 0
    
    RX, RXi, RZ, RZi = ladder_3_pt(arithmetic_parameters, sk, ob_bits-1, xpb, xpbi, xqb, xqbi, xrb, xrbi, A, Ai, inv_4)
    
    index = 0
    npts = 0
    ptsX  = [0 for i in range(max_int_points)]
    ptsXi = [0 for i in range(max_int_points)]
    ptsZ  = [0 for i in range(max_int_points)]
    ptsZi = [0 for i in range(max_int_points)]
    pts_index = [0 for i in range(max_int_points)]
    ii = 0
    
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
            index += m;
            RX, RXi, RZ, RZi = xTPLe(arithmetic_parameters, RX, RXi, RZ, RZi, A24minus, A24minusi, A24plus, A24plusi, m);
            

        A24minus, A24minusi, A24plus, A24plusi, k1, k1i, k2, k2i = get_3_isog(arithmetic_parameters, RX, RXi, RZ, RZi)
        
        for i in range(npts):
            ptsX[i], ptsXi[i], ptsZ[i], ptsZi[i] = eval_3_isog(arithmetic_parameters, ptsX[i], ptsXi[i], ptsZ[i], ptsZi[i], k1, k1i, k2, k2i)

            
        phiPX, phiPXi, phiPZ, phiPZi = eval_3_isog(arithmetic_parameters, phiPX, phiPXi, phiPZ, phiPZi, k1, k1i, k2, k2i)
        phiQX, phiQXi, phiQZ, phiQZi = eval_3_isog(arithmetic_parameters, phiQX, phiQXi, phiQZ, phiQZi, k1, k1i, k2, k2i)
        phiRX, phiRXi, phiRZ, phiRZi = eval_3_isog(arithmetic_parameters, phiRX, phiRXi, phiRZ, phiRZi, k1, k1i, k2, k2i)
        
        
        npts -= 1;
        RX  = ptsX[npts]
        RXi = ptsXi[npts]
        RZ  = ptsZ[npts]
        RZi = ptsZi[npts]
        index = pts_index[npts];
        
    A24minus, A24minusi, A24plus, A24plusi, k1, k1i, k2, k2i = get_3_isog(arithmetic_parameters, RX, RXi, RZ, RZi)
    phiPX, phiPXi, phiPZ, phiPZi = eval_3_isog(arithmetic_parameters, phiPX, phiPXi, phiPZ, phiPZi, k1, k1i, k2, k2i)
    phiQX, phiQXi, phiQZ, phiQZi = eval_3_isog(arithmetic_parameters, phiQX, phiQXi, phiQZ, phiQZi, k1, k1i, k2, k2i)
    phiRX, phiRXi, phiRZ, phiRZi = eval_3_isog(arithmetic_parameters, phiRX, phiRXi, phiRZ, phiRZi, k1, k1i, k2, k2i)
    
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

def sage_shared_secret_alice_fast(fp2, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk, oa_bits, splits, max_row, max_int_points, inv_4):
    
    a, ai = sage_get_A(fp2, xpb, xpbi, xqb, xqbi, xrb, xrbi)
    
    C24  = 2
    A24plus = a + C24 
    A24plusi = ai
    C24  = C24 + C24
    C24i = 0
    
    RX, RXi, RZ, RZi = sage_ladder_3_pt(fp2, sk, oa_bits, xpb, xpbi, xqb, xqbi, xrb, xrbi, a, ai, inv_4)
    
    if(oa_bits % 2 == 1):
        SX, SXi, SZ, SZi = sage_xDBLe(fp2, RX, RXi, RZ, RZi, A24plus, A24plusi, C24, C24i, oa_bits-1)
        A24plus, A24plusi, C24, C24i = sage_get_2_isog(fp2, SX, SXi, SZ, SZi)
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
        
        RX  = ptsX[npts-1]
        RXi = ptsXi[npts-1]
        RZ  = ptsZ[npts-1]
        RZi = ptsZi[npts-1]
        index = pts_index[npts-1];
        npts -= 1;
        
        
    A24plus, A24plusi, C24, C24i, k1, k1i, k2, k2i, k3, k3i = sage_get_4_isog(fp2, RX, RXi, RZ, RZi)
    a  = 2*(2*A24plus-C24)
    ai = 2*(2*A24plusi-C24i)
    c  = C24
    ci = C24i
    
    value_j_inv, value_j_invi = sage_j_inv(fp2, a, ai, c, ci)
    
    return value_j_inv, value_j_invi

def shared_secret_alice_fast(arithmetic_parameters, xpb, xpbi, xqb, xqbi, xrb, xrbi, sk, oa_bits, splits, max_row, max_int_points, inv_4):
    
    const_r = arithmetic_parameters[12]
    
    a, ai = get_A(arithmetic_parameters, xpb, xpbi, xqb, xqbi, xrb, xrbi)
    
    ma =     [ const_r, 0, 0, 0]
    mb =     [ const_r, 0, 0, 0]
    sign_a = [       1, 0, 0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    C24 = mo[0]
    
    ma =     [ C24,  0, C24, 0]
    mb =     [   a, ai, C24, 0]
    sign_a = [   1,  1,   1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    A24plus  = mo[0]
    A24plusi = mo[1]
    C24  = mo[2]
    C24i = mo[3]
    
    RX, RXi, RZ, RZi = ladder_3_pt(arithmetic_parameters, sk, oa_bits, xpb, xpbi, xqb, xqbi, xrb, xrbi, a, ai, inv_4)
    
    if(oa_bits % 2 == 1):
        SX, SXi, SZ, SZi = xDBLe(arithmetic_parameters, RX, RXi, RZ, RZi, A24plus, A24plusi, C24, C24i, oa_bits-1)
        A24plus, A24plusi, C24, C24i = get_2_isog(arithmetic_parameters, SX, SXi, SZ, SZi)
        RX, RXi, RZ, RZi = eval_2_isog(arithmetic_parameters, SX, SXi, SZ, SZi, RX, RXi, RZ, RZi)
    
    index = 0
    npts = 0
    ptsX  = [0 for i in range(max_int_points)]
    ptsXi = [0 for i in range(max_int_points)]
    ptsZ  = [0 for i in range(max_int_points)]
    ptsZi = [0 for i in range(max_int_points)]
    pts_index = [0 for i in range(max_int_points)]
    ii = 0
    
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
        
        npts -= 1;
        RX  = ptsX[npts]
        RXi = ptsXi[npts]
        RZ  = ptsZ[npts]
        RZi = ptsZi[npts]
        index = pts_index[npts];
    
        
    A24plus, A24plusi, C24, C24i, k1, k1i, k2, k2i, k3, k3i = get_4_isog(arithmetic_parameters, RX, RXi, RZ, RZi)
    
    ma =     [ A24plusi, A24plus, 0, 0]
    mb =     [ A24plusi, A24plus, 0, 0]
    sign_a = [        1,       1, 1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    ai = mo[0]
    a  = mo[1]
    
    ma =     [ C24i, C24, 0, 0]
    mb =     [   ai,   a, 0, 0]
    sign_a = [    0,   0, 1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    ai = mo[0]
    a  = mo[1]
    
    ma =     [ ai, a, 0, 0]
    mb =     [ ai, a, 0, 0]
    sign_a = [  1, 1, 1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    ai = mo[0]
    a  = mo[1]
    
    c  = C24
    ci = C24i
    
    value_j_inv, value_j_invi = j_inv(arithmetic_parameters, a, ai, c, ci)
    value_j_inv  = int(value_j_inv)
    value_j_invi = int(value_j_invi)
    return value_j_inv, value_j_invi

def sage_shared_secret_bob_fast(fp2, xpa, xpai, xqa, xqai, xra, xrai, sk, ob_bits, splits, max_row, max_int_points, inv_4):
    
    a, ai = sage_get_A(fp2, xpa, xpai, xqa, xqai, xra, xrai)
    A24plus   = a + 2 
    A24plusi  = ai
    A24minus  = a - 2
    A24minusi = ai
    
    RX, RXi, RZ, RZi = sage_ladder_3_pt(fp2, sk, ob_bits-1, xpa, xpai, xqa, xqai, xra, xrai, a, ai, inv_4)
    
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
            RX, RXi, RZ, RZi = sage_xTPLe(fp2, RX, RXi, RZ, RZi, A24minus, A24minusi, A24plus, A24plusi, m);
            index += m;
            if(npts > max_npts):
                max_npts = npts

        A24minus, A24minusi, A24plus, A24plusi, k1, k1i, k2, k2i = sage_get_3_isog(fp2, RX, RXi, RZ, RZi)
        
        for i in range(npts):
            ptsX[i], ptsXi[i], ptsZ[i], ptsZi[i] = sage_eval_3_isog(fp2, ptsX[i], ptsXi[i], ptsZ[i], ptsZi[i], k1, k1i, k2, k2i)
        
        RX  = ptsX[npts-1]
        RXi = ptsXi[npts-1]
        RZ  = ptsZ[npts-1]
        RZi = ptsZi[npts-1]
        index = pts_index[npts-1];
        npts -= 1;
        
        
    A24minus, A24minusi, A24plus, A24plusi, k1, k1i, k2, k2i = sage_get_3_isog(fp2, RX, RXi, RZ, RZi)
    a  = 2*(A24plus+A24minus)
    ai = 2*(A24plusi+A24minusi)
    c  = A24plus-A24minus
    ci = A24plusi-A24minusi
    
    value_j_inv, value_j_invi = sage_j_inv(fp2, a, ai, c, ci)
    value_j_inv  = int(value_j_inv)
    value_j_invi = int(value_j_invi)
    return value_j_inv, value_j_invi

def shared_secret_bob_fast(arithmetic_parameters, xpa, xpai, xqa, xqai, xra, xrai, sk, ob_bits, splits, max_row, max_int_points, inv_4):
    
    const_r = arithmetic_parameters[12]

    a, ai = get_A(arithmetic_parameters, xpa, xpai, xqa, xqai, xra, xrai)
    
    ma =     [ const_r, 0, 0, 0]
    mb =     [ const_r, 0, 0, 0]
    sign_a = [       1, 0, 0, 0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    temp_2 = mo[0]
    
    ma =     [ temp_2,  0, temp_2,  0]
    mb =     [      a, ai,      a, ai]
    sign_a = [      1,  1,      0,  0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    A24plus   = mo[0]
    A24plusi  = mo[1]
    A24minus  = mo[2]
    A24minusi = mo[3]
    
    RX, RXi, RZ, RZi = ladder_3_pt(arithmetic_parameters, sk, ob_bits-1, xpa, xpai, xqa, xqai, xra, xrai, a, ai, inv_4)
    
    index = 0
    npts = 0
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
            index += m;
            RX, RXi, RZ, RZi = xTPLe(arithmetic_parameters, RX, RXi, RZ, RZi, A24minus, A24minusi, A24plus, A24plusi, m);

        A24minus, A24minusi, A24plus, A24plusi, k1, k1i, k2, k2i = get_3_isog(arithmetic_parameters, RX, RXi, RZ, RZi)
        
        for i in range(npts):
            ptsX[i], ptsXi[i], ptsZ[i], ptsZi[i] = eval_3_isog(arithmetic_parameters, ptsX[i], ptsXi[i], ptsZ[i], ptsZi[i], k1, k1i, k2, k2i)
        
        npts -= 1;
        RX  = ptsX[npts]
        RXi = ptsXi[npts]
        RZ  = ptsZ[npts]
        RZi = ptsZi[npts]
        index = pts_index[npts];
        
    
        
    A24minus, A24minusi, A24plus, A24plusi, k1, k1i, k2, k2i = get_3_isog(arithmetic_parameters, RX, RXi, RZ, RZi)
    
    ma =     [ A24minusi, A24minus, A24minusi, A24minus]
    mb =     [  A24plusi,  A24plus,  A24plusi,  A24plus]
    sign_a = [        1,         1,        0,         0]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    ai = mo[0]
    a  = mo[1]
    ci = mo[2]
    c  = mo[3]
    
    ma =     [ ai, a, 0, 0]
    mb =     [ ai, a, 0, 0]
    sign_a = [  1, 1, 1, 1]
    mo = mac_4_addition_subtraction_no_reduction(arithmetic_parameters, ma, mb, sign_a)
    ai = mo[0]
    a  = mo[1]
    
    value_j_inv, value_j_invi = j_inv(arithmetic_parameters, a, ai, c, ci)
    value_j_inv  = int(value_j_inv)
    value_j_invi = int(value_j_invi)
    
    return value_j_inv, value_j_invi