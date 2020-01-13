#
# Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/
#
enablePrimeCheck = True
enableSuperSingularCurveCheck = True
enableJinvCheck = True
enableCurveOrderCheck = True
enableGenerateBasePoints = True

def check_parameters_and_generate_inital_points(eA, eB, enablePrimeCheck = True, enableSuperSingularCurveCheck = True, enableJinvCheck = True, enableCurveOrderCheck = True, enableGenerateBasePoints = True):
    ## Parameters defining the prime p = f*lA^eA*lB^eB - 1
    f  = 1
    lA = 2
    lB = 3
    
    p = f*lA^eA*lB^eB-1
    if(enablePrimeCheck):
        print("Testing if p : " + str(f) + "*" + str(lA) + "^" + str(eA) + "*" + str(lB) + "^" + str(eB) + "-1 is a prime");
        assert is_prime(p)
        print("Yes, it is\n")
        
    print("Generating base field")
    ## Prime field of order p
    Fp = GF(p, proof=False) 
    ## The quadratic extension via x^2 + 1 since p = 3 mod 4 
    print("Generating extension field")
    R.<x> = Fp[]
    Fp2.<i> = Fp.extension(x^2+1, proof=False, check_irreducible=enablePrimeCheck)
    print("Done\n")
    
    ## Bit lengths of group orders lA^eA and lB^eB, needed during the ladder
    ## functions 
    eAbits = int(lA^eA).bit_length()
    eBbits = int(lB^eB).bit_length()
    
    ## The orders of the points on each side
    oA  = lA^eA;
    oA1 = lA^(eA-1);
    oB  = lB^eB;
    
    ## E0 is the starting curve E0/Fp2: y^2=x^3+x (the A=0 Montgomery curve)
    print("Generating Elliptic curve")
    E0 = EllipticCurve(Fp2, [0,6,0,1,0])
    E0fp = EllipticCurve(Fp, [0,6,0,1,0])
    print("Done\n")
    if(enableSuperSingularCurveCheck):
        print("Checking if Elliptic Curve E0 is supersingular...")
        assert E0.is_supersingular(proof=True)
        print("Yes, it is\n")
    if(enableJinvCheck):
        print("Checking if Elliptic Curve E0 j inv...")
        assert E0.j_invariant() == 287496
        print("Yes, it is\n")
    if(enableCurveOrderCheck):
        print("Checking Elliptic Curve E0 order...")
        assert E0.order() == ((oA*oB)^2)
        print("Yes, it is " + "(" + str(lA) + "^" + str(eA) + "*" +  str(lB) + "^" + str(eB) + ")^2" + "\n")
    E0.set_order(((oA*oB)^2))
    if(enableGenerateBasePoints):
        P3 = E0fp(0,0)
        Q3 = E0fp(0,0)
        P2 = E0(0,0)
        Q2 = E0(0,0)
        
        # Generate Q3
        c = Fp(0)
        while(c <= p-1):
            fc = c^3 + Fp(6)*(c^2) + c
            if(fc.is_square()):
                c = c + Fp(1)
                continue
            fc = Fp2(c)^3 + Fp2(6)*(Fp2(c)^2) + Fp2(c)
            if(not fc.is_square()):
                c = c + Fp(1)
                continue
            all_fc_sqrt = sqrt(fc, all=True)
            fc_sqrt = Fp2(0)
            for each_fc_sqrt in all_fc_sqrt:
                if(each_fc_sqrt.polynomial()[0] == 0):
                    if((int(each_fc_sqrt.polynomial()[1]) % 2) == 0):
                        fc_sqrt = each_fc_sqrt
                        break
                elif((int(each_fc_sqrt.polynomial()[0]) % 2) == 0):
                    fc_sqrt = each_fc_sqrt
                    break
            # Check Q3
            if(not (E0.is_on_curve(c,fc_sqrt))):
                c = c + Fp(1)
                continue
            tQ3 = oA1*(E0(c,each_fc_sqrt))
            if(not (tQ3.order() == oB)):
                c = c + Fp(1)
                continue
            Q3 = tQ3
            break
        
        # Generate P3
        c = Fp(0)
        while(c <= p-1):
            fc = c^3 + Fp(6)*(c^2) + c
            if(not fc.is_square()):
                c = c + Fp(1)
                continue
            all_fc_sqrt = sqrt(fc, all=True)
            fc_sqrt = Fp(0)
            for each_fc_sqrt in all_fc_sqrt:
                if((int(each_fc_sqrt) % 2) == 0):
                    fc_sqrt = each_fc_sqrt
                    break
            # Check P3
            if(not (E0fp.is_on_curve(c,fc_sqrt))):
                c = c + Fp(1)
                continue
            tP3 = oA1*(E0fp(c,fc_sqrt))
            if(not (tP3.order() == oB)):
                c = c + Fp(1)
                continue
            P3 = tP3
            break
        
        # Generate Q2
        c = Fp(0)
        null_point = E0(Fp2(0),Fp2(0))
        while(c <= p-1):
            ic = Fp2(i+c)
            fic = (ic)^3 + Fp2(6)*((ic)^2) + (ic)
            if(not fic.is_square()):
                c = c + Fp(1)
                continue
            all_fic_sqrt = sqrt(fic, all=True)
            fic_sqrt = Fp2(0)
            for each_fic_sqrt in all_fic_sqrt:
                if(each_fic_sqrt.polynomial()[0] == 0):
                    if((int(each_fic_sqrt.polynomial()[1]) % 2) == 0):
                        fic_sqrt = each_fic_sqrt
                        break
                elif((int(each_fic_sqrt.polynomial()[0]) % 2) == 0):
                    fic_sqrt = each_fic_sqrt
                    break
            # Check Q2
            if(not (E0.is_on_curve(ic,fic_sqrt))):
                c = c + Fp(1)
                continue
            tQ2 = oB*(E0(ic,each_fic_sqrt))
            zQ2 = oA1*tQ2
            if(not (zQ2 == null_point)):
                c = c + Fp(1)
                continue
            Q2 = tQ2
            break
        
        # Generate P2
        c = Fp(0)
        all_eight_sqrt = sqrt(Fp2(8), all=True)
        all_special_point = [E0(Fp2(-3)+each_eight_sqrt,Fp2(0)) for each_eight_sqrt in all_eight_sqrt]
        while(c <= p-1):
            ic = Fp2(i+c)
            fic = (ic)^3 + Fp2(6)*((ic)^2) + (ic)
            if(not fic.is_square()):
                c = c + Fp(1)
                continue
            all_fic_sqrt = sqrt(fic, all=True)
            fic_sqrt = Fp2(0)
            for each_fic_sqrt in all_fic_sqrt:
                if(each_fic_sqrt.polynomial()[0] == 0):
                    if((int(each_fic_sqrt.polynomial()[1]) % 2) == 0):
                        fic_sqrt = each_fic_sqrt
                        break
                elif((int(each_fic_sqrt.polynomial()[0]) % 2) == 0):
                    fic_sqrt = each_fic_sqrt
                    break
            # Check P2
            if(not (E0.is_on_curve(ic,fic_sqrt))):
                c = c + Fp(1)
                continue
            tP2 = oB*(E0(ic,each_fic_sqrt))
            sP2 = oA1*tP2
            matches_special_point = False
            for each_special_point in all_special_point:
                if(sP2 == each_special_point):
                    matches_special_point = True
            if(not matches_special_point):
                c = c + Fp(1)
                continue
            P2 = tP2
            break
        
        if((P2 == E0(0,0)) or (Q2 == E0(0,0)) or (P3 == E0fp(0,0)) or (Q3 == E0fp(0,0))):
            print('No valid points could be found')
            return None
        else:
            R3 = E0(P3[0],P3[1]) - Q3
            R2 = P2 - Q2
            
            xP2, yP2 = P2[0], P2[1]
            xQ2, yQ2 = Q2[0], Q2[1]
            xR2, yR2 = R2[0], R2[1]
            xP3, yP3 = P3[0], P3[1]
            xQ3, yQ3 = Q3[0], Q3[1]
            xR3, yR3 = R3[0], R3[1]
            
            xP20 = hex(int(xP2.polynomial()[0]))
            xP21 = hex(int(xP2.polynomial()[1]))
            yP20 = hex(int(yP2.polynomial()[0]))
            yP21 = hex(int(yP2.polynomial()[1]))
            xQ20 = hex(int(xQ2.polynomial()[0]))
            xQ21 = hex(int(xQ2.polynomial()[1]))
            yQ20 = hex(int(yQ2.polynomial()[0]))
            yQ21 = hex(int(yQ2.polynomial()[1]))
            xR20 = hex(int(xR2.polynomial()[0]))
            xR21 = hex(int(xR2.polynomial()[1]))
            yR20 = hex(int(yR2.polynomial()[0]))
            yR21 = hex(int(yR2.polynomial()[1]))
            xP30 = hex(int(xP3.polynomial()[0]))
            xP31 = hex(int(xP3.polynomial()[1]))
            yP30 = hex(int(yP3.polynomial()[0]))
            yP31 = hex(int(yP3.polynomial()[1]))
            xQ30 = hex(int(xQ3.polynomial()[0]))
            xQ31 = hex(int(xQ3.polynomial()[1]))
            yQ30 = hex(int(yQ3.polynomial()[0]))
            yQ31 = hex(int(yQ3.polynomial()[1]))
            xR30 = hex(int(xR3.polynomial()[0]))
            xR31 = hex(int(xR3.polynomial()[1]))
            yR30 = hex(int(yR3.polynomial()[0]))
            yR31 = hex(int(yR3.polynomial()[1]))
            
            print('xP20 = ' + xP20)
            print('xP21 = ' + xP21)
            print('yP20 = ' + yP20)
            print('yP21 = ' + yP21)
            print('xQ20 = ' + xQ20)
            print('xQ21 = ' + xQ21)
            print('yQ20 = ' + yQ20)
            print('yQ21 = ' + yQ21)
            print('xR20 = ' + xR20)
            print('xR21 = ' + xR21)
            print('yR20 = ' + yR20)
            print('yR21 = ' + yR21)
            print('xP30 = ' + xP30)
            print('xP31 = ' + xP31)
            print('yP30 = ' + yP30)
            print('yP31 = ' + yP31)
            print('xQ30 = ' + xQ30)
            print('xQ31 = ' + xQ31)
            print('yQ30 = ' + yQ30)
            print('yQ31 = ' + yQ31)
            print('xR30 = ' + xR30)
            print('xR31 = ' + xR31)
            print('yR30 = ' + yR30)
            print('yR31 = ' + yR31)
    
    return 0

print('')
check_parameters_and_generate_inital_points(4, 3)
print('')
check_parameters_and_generate_inital_points(8, 5)
print('')
check_parameters_and_generate_inital_points(216, 137)
print('')
check_parameters_and_generate_inital_points(250, 159)
print('')
check_parameters_and_generate_inital_points(305, 192)
print('')
check_parameters_and_generate_inital_points(372, 239)
print('')
check_parameters_and_generate_inital_points(486, 301)
