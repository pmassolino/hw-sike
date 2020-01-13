# -*- coding: utf-8 -*-
# Algorithms taken from paper:
# Authors: Debapriya Basu Roy, Debdeep Mukhopadhyay, Masami Izumi, Junko Takahashi
# Tile: Before Multiplication: An Efficient Strategy to Optimize DSP Multiplier for Accelerating Prime Field ECC for NIST Curves
#
# Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/
#
def check_if_b_mw2_nw1(b, w2, w1):
    m = 0
    n = 0
    a = 0
    for x in range(1, ((b//w2) + 2)):
        for y in range(1, ((b//w1)+2)):
            new_a = (x*w2+y*w1)
            if(abs(new_a - b) < abs(a - b)):
                m = x
                n = y
                a = new_a
    return m, n, a

def non_standard_tiling(b, w2, w1):
    # if (b = mw2 + nw1) #
    m, n, a = check_if_b_mw2_nw1(b, w2, w1)
    num = ((a*a) - abs(m*w2-n*w1)**2)/(w2*w1)
    P = None
    if(abs(m*w2-n*w1) == ((a*a) - (w2*w1)*((a*a)//(w2*w1)))):
        B = True
        R = 0
        return (P, num, m, n, a, B, R)
    else:
        p = ((a*a)//(w2*w1)) - ((a*a) - abs(m*w2-n*w1)**2)/(w2*w1) 
        q = (a*a) - (w2*w1)*((a*a)//(w2*w1))
        B = False
        R = abs(m*w2-n*w1)
        answers = []
        answers += [(P, num, m, n, a, B, R)]
        print(answers)
        answers += [non_standard_tiling(abs(m*w2-n*w1), w2, w1)]
        return answers

non_standard_tiling(256, 24, 17)