# -*- coding: utf-8 -*-
#
# Implementation by Pedro Maat C. Massolino,
# hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/
#
class sidh_fp2:
    def __init__(self, prime, a=0, b=0):
        self.prime = prime
        self.a = a
        self.b = b
        self.byte_length = (prime.bit_length()+7)//8
    
    def __call__(self, value):
        if isinstance(value, sidh_fp2):
            return self.__class__(value.prime, value.a, value.b)
        elif isinstance(value, int):
            return self.__class__(self.prime, value, 0)
        else:
            return self.__class__(self.prime, value[0], value[1])
    
    def polynomial(self):
        return [self.a, self.b]
    
    def __square__(self):
        t0 = self.a + self.a
        t1 = self.a + self.b
        t2 = self.a - self.b
        t3 = (t1*t2) % self.prime
        t4 = (t0 * self.b) % self.prime
        return self.__class__(self.prime, t3, t4)
    
    def __add__(self, other):
        new_a = (self.a + other.a) % self.prime
        new_b = (self.b + other.b) % self.prime
        return self.__class__(self.prime, new_a, new_b)
    
    def __sub__(self, other):
        new_a = (self.a - other.a) % self.prime
        new_b = (self.b - other.b) % self.prime
        return self.__class__(self.prime, new_a, new_b)
    
    def __mul__(self, other):
        t0 = self.a * other.a
        t1 = self.b * other.b
        t2 = self.a + self.b
        t3 = other.a + other.b
        t4 = t2*t3
        t5 = t0+t1
        t6 = (t4-t5) % self.prime
        t7 = (t0-t1) % self.prime
        return self.__class__(self.prime, t7, t6)
    
    def __floordiv__(self, other):
        return self.__truediv__(other)
    
    def __truediv__(self, other):
        inverted = other.__pow__(other.prime - 2)
        return self.__mul__(inverted)
    
    def __pow__(self, other):
        if(other == 2):
            return self.__square__()
        exponent = other % ((self.prime)*(self.prime)-1)
        final_value = self.__class__(self.prime, 1, 0)
        exponent = bin(exponent)
        for bin_digit in exponent[2:]:
            final_value = final_value.__square__()
            if(bin_digit == '1'):
                final_value = final_value.__mul__(self)
        return final_value
    
    def __and__(self, other):
        new_x = (self.a & other.a) % self.prime
        new_xi = (self.b & other.b) % self.prime
        return self.__class__(self.prime, new_x, new_xi)
    
    def __xor__(self, other):
        new_x = (self.a ^ other.a) % self.prime
        new_xi = (self.b ^ other.b) % self.prime
        return self.__class__(self.prime, new_x, new_xi)
    
    def __or__(self, other):
        new_x = (self.a | other.a) % self.prime
        new_xi = (self.b | other.b) % self.prime
        return self.__class__(self.prime, new_x, new_xi)
    
    def __eq__(self, other):
        return (self.a == other.a) and (self.b == other.b)
    
    def __ne__(self, other):
        return (self.a != other.a) or (self.b != other.b)
    
    def __str__(self):
        byte_length = str(self.byte_length)
        return(("{0:0" + byte_length + "x}\n{1:0" + byte_length + "x}").format(self.a, self.b))
    
    def __hex__(self):
        byte_length = str(self.byte_length)
        return(("{0:0" + byte_length + "x}\n{1:0" + byte_length + "x}").format(self.a, self.b))
    
    def to_bytearray(self):
        byte_length = str(2*self.byte_length)
        final_bytearray = bytearray.fromhex(("{:0" + byte_length + "x}").format(self.a))[::-1] + bytearray.fromhex(("{:0" + byte_length + "x}").format(self.b))[::-1]
        return final_bytearray