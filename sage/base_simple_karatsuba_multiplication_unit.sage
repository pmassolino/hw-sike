def print_list_VHDL_memory(file, word_size, list_a, final_size):
    word_full_of_ones = 2**word_size-1
    for i in range (0, len(list_a) - 1):
        file.write(("0" + ("{0:0"+str(word_size - 1)+"b}").format(list_a[i])))
        file.write('\n')
    if(list_a[-1] >= 0):
        file.write((("{0:0"+str(word_size)+"b}").format(list_a[-1])))
        fill_value = 0
    else:
        file.write((("{0:0"+str(word_size)+"b}").format(((-list_a[-1])^^(word_full_of_ones)) + 1)))
        fill_value = word_full_of_ones
    file.write('\n')
    for i in range (len(list_a),final_size):
        file.write((("{0:0"+str(word_size)+"b}").format(fill_value)))
        file.write('\n')

def print_value_VHDL_memory(file, word_size, value, final_size):
    word_full_of_ones = 2**word_size-1
    if(value >= 0):
        file.write((("{0:0"+str(word_size)+"b}").format(value)))
        fill_value = 0
    else:
        file.write((("{0:0"+str(word_size)+"b}").format(((-value)^^(word_full_of_ones)) + 1)))
        fill_value = word_full_of_ones
    file.write('\n')
    final_size = final_size - 1
    if(final_size > 0):
        for i in range (final_size):
            file.write((("{0:0"+str(word_size)+"b}").format(fill_value)))
            file.write('\n')
            
def load_list_VHDL_memory(file, word_size, final_size):
    maximum_positive_value = 2**(word_size - 1) - 1
    word_full_of_ones = 2**word_size-1
    list_a = [0 for i in range(final_size)]
    for i in range (0, len(final_size-1)):
        list_a[i] = int(file.read(word_size), base=2)
        file.read(1) # throw away the \n
    list_a[-1] = int(file.read(word_size), base=2)
    file.read(1) # throw away the \n
    if(list_a[-1] > maximum_positive_value):
        list_a[-1] = -((list_a[-1] ^^ word_full_of_ones) + 1)
    return list_a
    
def load_value_VHDL_memory(file, word_size, final_size):
    maximum_positive_value = 2**(word_size - 1) - 1
    word_full_of_ones = 2**word_size-1
    value = int(file.read(word_size), base=2)
    if(value > maximum_positive_value):
        value = -((value ^^ word_full_of_ones) + 1)
    file.read(1) # throw away the \n
    final_size = final_size - 1
    if(final_size > 0):
        for i in range (final_size):
            file.read(word_size + 1) # throw away the filling
    return value

def integer_to_list(word_size, list_size, a):
    list_a = [0 for i in range(list_size)]
    word_modulus = 2**(word_size-1)
    word_full_of_ones = word_modulus - 1
    j = a
    for i in range(0, list_size - 1):
        list_a[i] = (j)&(word_full_of_ones)
        j = j//word_modulus
    list_a[-1] = (j)&(word_full_of_ones)
    if(j < 0):
        list_a[-1] = -((list_a[-1] ^^ word_full_of_ones) + 1)
    return list_a

def list_to_integer(word_size, list_size, list_a):
    a = 0
    word_modulus = 2**(word_size-1)
    for i in range(list_size-1, -1, -1):
        a = a*word_modulus
        a = a + list_a[i]
    return a

def print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, test_value_a, test_value_b):
    test_value_o = test_value_a*test_value_b
    
    print_value_VHDL_memory(VHDL_memory_file, number_of_bits, test_value_a, 1)
    print_value_VHDL_memory(VHDL_memory_file, number_of_bits, test_value_b, 1)
    print_value_VHDL_memory(VHDL_memory_file, 2*number_of_bits, test_value_o, 1)
    
def print_VHDL_montgomery_multiplication_test(VHDL_memory_file_name, number_of_bits, number_of_tests):
    
    VHDL_memory_file = open(VHDL_memory_file_name, 'w')
    
    minimum_value = -2**(number_of_bits-1)
    maximum_value = 2**(number_of_bits-1) - 1
    
    VHDL_memory_file.write((("{0:0d}").format(number_of_tests)))
    VHDL_memory_file.write('\n')
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, 0, maximum_value)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, 0, minimum_value)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, 1, minimum_value)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, 1, maximum_value)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, -1, maximum_value)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, -1, minimum_value)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, minimum_value, minimum_value)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, minimum_value + 1, minimum_value + 1)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, maximum_value, maximum_value)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, maximum_value - 1, maximum_value - 1)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, minimum_value, maximum_value)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, minimum_value + 1, maximum_value)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, minimum_value, maximum_value - 1)
    number_of_tests -= 1
    print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, minimum_value + 1, maximum_value - 1)
    number_of_tests -= 1
    
    for i in range(number_of_tests):
        
        test_value_a = randint(minimum_value, maximum_value)
        test_value_b = randint(minimum_value, maximum_value)
        print_single_VHDL_montgomery_multiplication_test(VHDL_memory_file, number_of_bits, test_value_a, test_value_b)
        
    VHDL_memory_file.close()
    
def load_VHDL_montgomery_multiplication_test(VHDL_memory_file_name, number_of_bits, number_of_tests = -1):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
    
    while((current_test != total_number_of_tests_file) and (current_test != number_of_tests)):
        loaded_test_value_a = load_value_VHDL_memory(VHDL_memory_file, number_of_bits, 1)
        loaded_test_value_b = load_value_VHDL_memory(VHDL_memory_file, number_of_bits, 1)
        loaded_test_value_o = load_value_VHDL_memory(VHDL_memory_file, 2*number_of_bits, 1)
        
        computed_test_value_o = loaded_test_value_a*loaded_test_value_b
        
        if(computed_test_value_o != loaded_test_value_o):
            print "Error in computation at test number : " + str(current_test)
            print loaded_test_value_a
            print loaded_test_value_b
            print loaded_test_value_o
            print computed_test_value_o
        current_test += 1
        
    VHDL_memory_file.close()

home_folder = "/home/pedro/"
working_folder = home_folder + "/hw-sidh/vhdl_project/"
file_name = "hw_sidh_tests_v257/multiplication_test_257.dat"
number_of_bits = 257
number_of_tests = 100

print_VHDL_montgomery_multiplication_test(working_folder+file_name, number_of_bits, number_of_tests)
load_VHDL_montgomery_multiplication_test(working_folder+file_name, number_of_bits)

file_name = "hw_sidh_tests_v129/multiplication_test_129.dat"
number_of_bits = 129
number_of_tests = 100

print_VHDL_montgomery_multiplication_test(working_folder+file_name, number_of_bits, number_of_tests)
load_VHDL_montgomery_multiplication_test(working_folder+file_name, number_of_bits)
