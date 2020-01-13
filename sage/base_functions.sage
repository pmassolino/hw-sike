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
load(script_working_folder+"base_tests_for_mac_unit.sage")

def signed_integer_to_string(a, size=272):
    if(a < 0):
        mask = (2**size)-1
        a = ((-a) ^^ mask) + 1
    return ("{:0" + str(size//4) + "x}").format(a)

def unsigned_integer_to_list(word_size, list_size, a):
    list_a = list_size*[0]
    word_modulus = 2**(word_size)
    word_full_of_ones = word_modulus - 1
    j = a
    for i in range(0, list_size):
        list_a[i] = (j)&(word_full_of_ones)
        j = j//word_modulus
    return list_a

def enter_montgomery_domain(arithmetic_parameters, a, debug=False):
    prime = arithmetic_parameters[3]
    r = arithmetic_parameters[10]
    prime_line = arithmetic_parameters[17]
    r2 = arithmetic_parameters[14]
    temp_mont = a*r2
    o = (((temp_mont*prime_line)%r)*prime + temp_mont)//r
    return o
    
def remove_montgomery_domain(arithmetic_parameters, a, debug=False):
    prime = arithmetic_parameters[3]
    r = arithmetic_parameters[10]
    prime_line = arithmetic_parameters[17]
    o = (((a*prime_line)%r)*prime + a)//r
    return o

def iterative_reduction(arithmetic_parameters, a, debug=False):
    prime = arithmetic_parameters[3]
    if(a >= 0):
        s = 1
    else:
        s = 0
    o = a - s*prime
    if(o < 0):
        s = 1
    else:
        s = 0
    o = o + s*prime
    return o

def mac_4_addition_subtraction_no_reduction(arithmetic_parameters, a, b, sign_a, debug=False):
    r = arithmetic_parameters[10]
    o = 4*[0]
    for i in range(4):
        if(sign_a[i] == 1):
            o[i] = b[i]+a[i]
        else:
            o[i] = b[i]-a[i]
    return o

def mac_8_montgomery_multiplication(arithmetic_parameters, a, b, debug=False):
    prime = arithmetic_parameters[3]
    r = arithmetic_parameters[10]
    prime_line = arithmetic_parameters[17]
    o = 8*[0]
    for i in range(8):
        temp_mont = (a[i]*b[i])
        o[i] = (((temp_mont*prime_line)%r)*prime + temp_mont)//r
    return o
    
def mac_8_montgomery_squaring(arithmetic_parameters, a, debug=False):
    prime = arithmetic_parameters[3]
    r = arithmetic_parameters[10]
    prime_line = arithmetic_parameters[17]
    o = 8*[0]
    for i in range(8):
        temp_mont = a[i]*a[i]
        o[i] = (((temp_mont*prime_line)%r)*prime + temp_mont)//r
    return o