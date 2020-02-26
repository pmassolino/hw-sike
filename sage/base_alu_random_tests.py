import random;

def print_value_VHDL_memory(file, word_size, value, final_size, fill_value):
    file.write((("{0:0"+str(word_size)+"b}").format(value)))
    file.write('\n')
    final_size = final_size - 1
    if(final_size > 0):
        for i in range (final_size):
            file.write((("{0:0"+str(word_size)+"b}").format(fill_value)))
            file.write('\n')

def load_value_unsigned_VHDL_memory(file, word_size, final_size):
    value = int(file.read(word_size), base=2)
    file.read(1) # throw away the \n
    final_size = final_size - 1
    if(final_size > 0):
        for i in range (final_size):
            file.read(word_size + 1) # throw away the filling
    return value
    
def load_value_signed_VHDL_memory(file, word_size, final_size):
    maximum_positive_value = 2**(word_size - 1) - 1
    word_full_of_ones = 2**word_size - 1
    value = int(file.read(word_size), base=2)
    if(value > maximum_positive_value):
        value = -((value ^ word_full_of_ones) + 1)
    file.read(1) # throw away the \n
    final_size = final_size - 1
    if(final_size > 0):
        for i in range (final_size):
            file.read(word_size + 1) # throw away the filling
    return value
    
# Rotation functions obtained from 
# https://www.falatic.com/index.php/108/python-and-bitwise-rotation
rol = lambda val, r_bits, max_bits: (val << r_bits%max_bits) & (2**max_bits-1) | ((val & (2**max_bits-1)) >> (max_bits-(r_bits%max_bits)))
ror = lambda val, r_bits, max_bits: ((val & (2**max_bits-1)) >> r_bits%max_bits) | (val << (max_bits-(r_bits%max_bits)) & (2**max_bits-1))

shl = lambda val, s_bits, max_bits : ((val << s_bits) & (2**max_bits-1))
shr = lambda val, s_bits, max_bits : ((val & (2**max_bits-1)) >> s_bits)


def print_simple_unsigned_test(file, a, b, rotation_amount, word_size):
    word_full_of_ones = 2**word_size - 1
    double_word_full_of_ones = 2**(2*word_size) - 1
    print_value_VHDL_memory(file, word_size, a, 1, 0)
    print_value_VHDL_memory(file, word_size, b, 1, 0)
    print_value_VHDL_memory(file, word_size, rotation_amount, 1, 0)
    o = (b+a)&word_full_of_ones
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = (b-a)&word_full_of_ones
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = (b*a)&(double_word_full_of_ones)
    print_value_VHDL_memory(file, 2*word_size, o, 1, 0)
    o = shr(b, rotation_amount, word_size)
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = ror(b, rotation_amount, word_size)
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = shl(b, rotation_amount, word_size)
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = rol(b, rotation_amount, word_size)
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    if(a == b):
        o = 1
    else:
        o = 0
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    if(a > b):
        o = 1
    else:
        o = 0
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = a & b
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = a | b
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = a ^ b
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    
    
    
def print_simple_signed_test(file, a, b, rotation_amount, word_size):
    word_full_of_ones = 2**(word_size) - 1
    double_word_full_of_ones = 2**(2*word_size) - 1
    print_value_VHDL_memory(file, word_size, a & word_full_of_ones, 1, 0)
    print_value_VHDL_memory(file, word_size, b & word_full_of_ones, 1, 0)
    print_value_VHDL_memory(file, word_size, rotation_amount, 1, 0)
    o = (b+a)&word_full_of_ones
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = (b-a)&word_full_of_ones
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = (b*a)&(double_word_full_of_ones)
    print_value_VHDL_memory(file, 2*word_size, o, 1, 0)
    o = shr(b, rotation_amount, word_size)
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = ror(b, rotation_amount, word_size)
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = shl(b, rotation_amount, word_size)
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = rol(b, rotation_amount, word_size)
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    if(a == b):
        o = 1
    else:
        o = 0
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    if(a > b):
        o = 1
    else:
        o = 0
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = (a & b)&word_full_of_ones
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = (a | b)&word_full_of_ones
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    o = (a ^ b)&word_full_of_ones
    print_value_VHDL_memory(file, word_size, o, 1, 0)
    

def print_all_tests_unsigned(filename, word_size, number_of_tests):
    test_file = open(filename, 'w')
    
    test_file.write((("{0:0d}").format(number_of_tests)))
    test_file.write('\n')
    
    # Maximum tests
    max_value = 2**word_size
    max_rotation = word_size
    maximum_tests = [0, 1, 2, 3, 4, max_value - 4, max_value - 3, max_value - 2, max_value - 1]
    maximum_tests_rotation = [0, 1, 2, 3, 4, max_rotation - 4, max_rotation - 3, max_rotation - 2, max_rotation - 1]
    for test_value_b in maximum_tests:
        for test_value_a, test_rotation in zip(maximum_tests, maximum_tests_rotation):
            print_simple_unsigned_test(test_file, test_value_a, test_value_b, test_rotation, word_size)
            number_of_tests -= 1
    for i in range(number_of_tests):
        test_value_a = random.randint(0, max_value-1)
        test_value_b = random.randint(0, max_value-1)
        test_rotation = random.randint(0, max_rotation-1)
        print_simple_unsigned_test(test_file, test_value_a, test_value_b, test_rotation, word_size)
    
    test_file.close()

def print_all_tests_signed(filename, word_size, number_of_tests):
    test_file = open(filename, 'w')
    
    test_file.write((("{0:0d}").format(number_of_tests)))
    test_file.write('\n')
    
    # Maximum tests
    max_value = 2**(word_size-1)
    max_rotation = word_size
    maximum_tests = [-max_value, -max_value + 1, -max_value + 2, 0, 1, 2, max_value - 3, max_value - 2, max_value - 1]
    maximum_tests_rotation = [0, 1, 2, 3, 4, max_rotation - 4, max_rotation - 3, max_rotation - 2, max_rotation - 1]
    for test_value_b in maximum_tests:
        for test_value_a, test_rotation in zip(maximum_tests, maximum_tests_rotation):
            print_simple_signed_test(test_file, test_value_a, test_value_b, test_rotation, word_size)
            number_of_tests -= 1

    for i in range(number_of_tests):
        test_value_a = random.randint(-max_value, max_value-1)
        test_value_b = random.randint(-max_value, max_value-1)
        test_rotation = random.randint(0, max_rotation-1)
        print_simple_signed_test(test_file, test_value_a, test_value_b, test_rotation, word_size)
    
    test_file.close()

def load_all_tests_unsigned(filename, word_size):
    word_full_of_ones = 2**(word_size) - 1
    double_word_full_of_ones = 2**(2*word_size) - 1
    test_file = open(filename, 'r')
    test_file.seek(0, 2)
    tes_file_size = test_file.tell()
    test_file.seek(0)
    
    current_test = 0
    number_of_tests = int(test_file.readline())
    
    while(current_test != (number_of_tests)):
        loaded_test_value_a  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        loaded_test_value_b  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        loaded_test_rotation = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = (loaded_test_value_b+loaded_test_value_a)&word_full_of_ones
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in addition at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
            
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = (loaded_test_value_b-loaded_test_value_a)&word_full_of_ones
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in subtraction at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
            
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, 2*word_size, 1)
        computed_test_value_o = (loaded_test_value_b*loaded_test_value_a)&(double_word_full_of_ones)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in multiplication at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        
        computed_test_value_o = shr(loaded_test_value_b, loaded_test_rotation, word_size)

        if(computed_test_value_o != loaded_test_value_o):
            print("Error in shift right at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = ror(loaded_test_value_b, loaded_test_rotation, word_size)

        if(computed_test_value_o != loaded_test_value_o):
            print("Error in rotation right at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = shl(loaded_test_value_b, loaded_test_rotation, word_size)

        if(computed_test_value_o != loaded_test_value_o):
            print("Error in shift left at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = rol(loaded_test_value_b, loaded_test_rotation, word_size)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in rotation left at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        if(loaded_test_value_a == loaded_test_value_b):
            computed_test_value_o = 1
        else:
            computed_test_value_o = 0
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in comparison equal at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        if(loaded_test_value_a > loaded_test_value_b):
            computed_test_value_o = 1
        else:
            computed_test_value_o = 0
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in comparison bigger at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
            
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = loaded_test_value_a & loaded_test_value_b
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in logical AND at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = loaded_test_value_a | loaded_test_value_b
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in logical OR at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = loaded_test_value_a ^ loaded_test_value_b
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in logical XOR at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        current_test += 1
        
    test_file.close()
    
def load_all_tests_signed(filename, word_size):
    complete_word_full = 2**(word_size) - 1
    maximum_negative_valor = 2**(word_size-1)
    word_full_of_ones = 2**(word_size-1) - 1
    complete_double_word_full = 2**(2*word_size) - 1
    maximum_double_negative_valor = 2**(2*word_size-1)
    double_word_full_of_ones = 2**(2*word_size-1) - 1
    test_file = open(filename, 'r')
    test_file.seek(0, 2)
    tes_file_size = test_file.tell()
    test_file.seek(0)
    
    current_test = 0
    number_of_tests = int(test_file.readline())
    
    while(current_test != (number_of_tests)):
        loaded_test_value_a  = load_value_signed_VHDL_memory(test_file, word_size, 1)
        loaded_test_value_b  = load_value_signed_VHDL_memory(test_file, word_size, 1)
        loaded_test_rotation = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        loaded_test_value_o  = load_value_signed_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = (loaded_test_value_b+loaded_test_value_a) & complete_word_full
        if(computed_test_value_o >= maximum_negative_valor):
            computed_test_value_o = computed_test_value_o & word_full_of_ones
            computed_test_value_o = -((computed_test_value_o ^ word_full_of_ones) + 1)
    
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in addition at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
            
        loaded_test_value_o  = load_value_signed_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = (loaded_test_value_b-loaded_test_value_a) & complete_word_full
        if(computed_test_value_o >= maximum_negative_valor):
            computed_test_value_o = computed_test_value_o & word_full_of_ones
            computed_test_value_o = -((computed_test_value_o ^ word_full_of_ones) + 1)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in subtraction at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
            
        loaded_test_value_o  = load_value_signed_VHDL_memory(test_file, 2*word_size, 1)
        computed_test_value_o = (loaded_test_value_b*loaded_test_value_a) & complete_double_word_full
        if(computed_test_value_o >= maximum_double_negative_valor):
            computed_test_value_o = computed_test_value_o & double_word_full_of_ones
            computed_test_value_o = -((computed_test_value_o ^ double_word_full_of_ones) + 1)
            
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in multiplication at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        
        computed_test_value_o = shr(loaded_test_value_b, loaded_test_rotation, word_size)

        if(computed_test_value_o != loaded_test_value_o):
            print("Error in shift right at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = ror(loaded_test_value_b, loaded_test_rotation, word_size)

        if(computed_test_value_o != loaded_test_value_o):
            print("Error in rotation right at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = shl(loaded_test_value_b, loaded_test_rotation, word_size)

        if(computed_test_value_o != loaded_test_value_o):
            print("Error in shift left at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = rol(loaded_test_value_b, loaded_test_rotation, word_size)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in rotation left at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        if(loaded_test_value_a == loaded_test_value_b):
            computed_test_value_o = 1
        else:
            computed_test_value_o = 0
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in comparison equal at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_unsigned_VHDL_memory(test_file, word_size, 1)
        if(loaded_test_value_a > loaded_test_value_b):
            computed_test_value_o = 1
        else:
            computed_test_value_o = 0
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in comparison bigger at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded rotation")
            print(loaded_test_rotation)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
            
        loaded_test_value_o  = load_value_signed_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = (loaded_test_value_a & loaded_test_value_b) & complete_word_full
        if(computed_test_value_o >= maximum_negative_valor):
            computed_test_value_o = computed_test_value_o & word_full_of_ones
            computed_test_value_o = -((computed_test_value_o ^ word_full_of_ones) + 1)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in logical AND at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_signed_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = (loaded_test_value_a | loaded_test_value_b) & complete_word_full
        if(computed_test_value_o >= maximum_negative_valor):
            computed_test_value_o = computed_test_value_o & word_full_of_ones
            computed_test_value_o = -((computed_test_value_o ^ word_full_of_ones) + 1)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in logical OR at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o  = load_value_signed_VHDL_memory(test_file, word_size, 1)
        computed_test_value_o = (loaded_test_value_a ^ loaded_test_value_b) & complete_word_full
        if(computed_test_value_o >= maximum_negative_valor):
            computed_test_value_o = computed_test_value_o & word_full_of_ones
            computed_test_value_o = -((computed_test_value_o ^ word_full_of_ones) + 1)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in logical XOR at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("Computed value o")
            print(computed_test_value_o)
            
        current_test += 1
        
    test_file.close()
    
print_all_tests_unsigned("base_alu_unsigned_values_test.dat", 16, 1000)
load_all_tests_unsigned("base_alu_unsigned_values_test.dat", 16)
print_all_tests_signed("base_alu_signed_values_test.dat", 16, 1000)
load_all_tests_signed("base_alu_signed_values_test.dat", 16)