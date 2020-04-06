# Obtained from
# https://en.wikibooks.org/wiki/Algorithm_Implementation/Mathematics/Extended_Euclidean_algorithm
#
def xgcd(a, b):
    """return (g, x, y) such that a*x + b*y = g = gcd(a, b)"""
    x0, x1, y0, y1 = 0, 1, 1, 0
    while a != 0:
        (q, a), b = divmod(b, a), a
        y0, y1 = y1, y0 - q * y1
        x0, x1 = x1, x0 - q * x1
    return b, x0, y0

def load_list_value_VHDL_MAC_memory_as_integer(file, base_word_size, base_word_size_signed_number_words, number_of_words, signed_integer):
    positive_word = 2**(base_word_size)
    maximum_positive_value = positive_word//2 - 1
    word_full_of_ones = 2**base_word_size - 1
    positive_full_word = 2**((base_word_size)*base_word_size_signed_number_words)
    final_value = 0
    value = 0
    multiplication_factor = 1
    for i in range (0, number_of_words - 1):
        for j in range(base_word_size_signed_number_words):
            value = int(file.read(base_word_size), base=2) + value*positive_word
        file.read(1) # throw away the \n
        final_value += value*multiplication_factor
        multiplication_factor = multiplication_factor*positive_full_word
        value = 0
    value_read = int(file.read(base_word_size), base=2)
    if((value_read > maximum_positive_value) and signed_integer):
        value_read = -((value_read ^ word_full_of_ones) + 1)
    value = int(file.read(base_word_size), base=2) + value_read*positive_word
    for j in range(2, base_word_size_signed_number_words):
        value = int(file.read(base_word_size), base=2) + value*positive_word
    file.read(1) # throw away the \n
    final_value += value*multiplication_factor
    return final_value

def load_list_convert_format_VHDL_BASE_memory(file, base_word_size, number_of_words, signed_integer):
    positive_word = 2**(base_word_size)
    word_full_of_ones = positive_word - 1
    maximum_positive_value = positive_word//2 - 1
    list_o = [0 for i in range(number_of_words)]
    for i in range (0, number_of_words):
        value_read = int(file.read(base_word_size), base=2)
        file.read(1) # throw away the \n
        if((value_read > maximum_positive_value) and signed_integer):
            value_read = -((value_read ^ word_full_of_ones) + 1)
        list_o[i] = value_read
    return list_o

def load_value_convert_format_VHDL_BASE_memory(file, base_word_size, signed_integer):
    positive_word = 2**(base_word_size)
    word_full_of_ones = positive_word - 1
    maximum_positive_value = positive_word//2 - 1
    value_o = int(file.read(base_word_size), base=2)
    file.read(1) # throw away the \n
    if((value_o > maximum_positive_value) and signed_integer):
            value_o = -((value_o ^ word_full_of_ones) + 1)
    return value_o

def integer_to_list(word_size, list_size, a):
    list_a = [0 for i in range(list_size)]
    word_modulus = 2**(word_size)
    word_full_of_ones = word_modulus - 1
    j = a
    for i in range(0, list_size - 1):
        list_a[i] = (j)&(word_full_of_ones)
        j = j//word_modulus
    list_a[-1] = (j)&(word_full_of_ones)
    if(j < 0):
        list_a[-1] = -((list_a[-1] ^ word_full_of_ones) + 1)
    return list_a

def list_to_integer(word_size, list_size, list_a):
    a = 0
    word_modulus = 2**(word_size)
    for i in range(list_size-1, -1, -1):
        a = a*word_modulus
        a = a + list_a[i]
    return a

def signed_to_hex(a, word_size):
    b = a
    word_modulus = 2**(word_size)
    word_full_of_ones = word_modulus - 1
    if(b < 0):
        b  = -((b ^ word_full_of_ones) + 1)
    return ("{0:0"+str(word_size//4)+"x}").format(b)

def signed_integer_to_string(a, size):
    if(a < 0):
        mask = (2**size)-1
        a = ((-a) ^ mask) + 1
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

def generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime = 0):
    arithmetic_parameters = [0]*24
    if(prime == 0):
    # No prime has been chosen, generate one on the fly
        prime = random_prime(2**prime_size_bits, True, 2**(prime_size_bits-1))
    number_of_bits = (((prime_size_bits+number_of_bits_added) + ((extended_word_size)-1))//(extended_word_size))*(extended_word_size)
    number_of_words = number_of_bits//(extended_word_size) 
    r = 2**(number_of_bits)
    r_mod_prime = r % prime
    r2 = (r_mod_prime * r_mod_prime) % prime
    value_d,r_inverse,prime_line = xgcd(r, -prime)
    if(r_inverse < 0):
        r_inverse = r_inverse + prime
    if(prime_line < 0):
        prime_line = prime_line + r
    prime_line_list = integer_to_list(extended_word_size, number_of_words, prime_line)
    #number_of_bits += 1 # sign bit
    
    prime_plus_one = prime + 1
    
    arithmetic_parameters[0]  = extended_word_size                                                         # Extended word size
    arithmetic_parameters[1]  = base_word_size                                                             # Base word size
    arithmetic_parameters[2]  = prime_size_bits                                                            # Prime size
    arithmetic_parameters[3]  = prime                                                                      # Prime n (integer representation)
    arithmetic_parameters[4]  = integer_to_list(extended_word_size, number_of_words, prime)                # Prime n (list representation)
    arithmetic_parameters[5]  = prime_plus_one                                                             # Prime n+1 (integer representation)
    arithmetic_parameters[6]  = integer_to_list(extended_word_size, number_of_words, prime_plus_one)       # Prime n+1 (list representation)
    arithmetic_parameters[7]  = number_of_bits_added                                                       # Number of bits added
    arithmetic_parameters[8]  = number_of_bits                                                             # Montgomery constant R number of bits
    arithmetic_parameters[9]  = number_of_words                                                            # Number of words on Montgomery constant R and others variables
    arithmetic_parameters[10] = r                                                                          # Montgomery constant R (integer representation)
    arithmetic_parameters[11] = integer_to_list(extended_word_size, number_of_words+1, r)                  # Montgomery constant R (list representation)
    arithmetic_parameters[12] = r_mod_prime                                                                # Montgomery constant R mod n (integer representation)
    arithmetic_parameters[13] = integer_to_list(extended_word_size, number_of_words, r_mod_prime)          # Montgomery constant R mod n (list representation)
    arithmetic_parameters[14] = r2                                                                         # Montgomery constant R^2 mod n (integer representation)
    arithmetic_parameters[15] = integer_to_list(extended_word_size, number_of_words, r2)                   # Montgomery constant R^2 mod n (list representation)
    arithmetic_parameters[16] = r_inverse                                                                  # Montgomery constant R^(-1) (integer representation)
    arithmetic_parameters[17] = prime_line                                                                 # Montgomery constant n'     (integer representation)
    arithmetic_parameters[18] = prime_line_list                                                            # Montgomery constant n'     (list representation)
    arithmetic_parameters[19] = (prime_line) % (2**(extended_word_size))                                   # Montgomery constant n' mod 2^(word size) (integer representation)
    arithmetic_parameters[20] = integer_to_list(extended_word_size, number_of_words, 1)                    # Constant 1 (list representation)
    arithmetic_parameters[21] = 2**(extended_word_size)                                                    # Internal word division
    arithmetic_parameters[22] = (2**(extended_word_size))-1                                                # Internal word modulus
    arithmetic_parameters[23] = (2**(accumulator_word_size))-1                                             # Accumulator word modulus
    
    return arithmetic_parameters