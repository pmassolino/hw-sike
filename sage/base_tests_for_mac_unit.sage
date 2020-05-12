if 'script_working_folder' not in globals() and 'script_working_folder' not in locals():
    script_working_folder = "/home/pedro/hw-sidh/vhdl_project/sage/"

def print_list_convert_format_VHDL_BASE_memory(file, base_word_size, list_a, final_size, signed_integer):
    positive_word = 2**(base_word_size)
    word_full_of_ones = positive_word - 1
    maximum_positive_value = positive_word//2 - 1
    for j in range(0, len(list_a)):
        if((list_a[j] > maximum_positive_value) and signed_integer):
            temp_line = (("{0:0"+str(base_word_size)+"b}").format(((-list_a[j])^^(word_full_of_ones)) + 1)) + '\n'
        else:
            temp_line = (("{0:0"+str(base_word_size)+"b}").format(list_a[j])) + '\n'
        file.write(temp_line)
    fill_value = 0
    for i in range (len(list_a),final_size):
        temp_line = ((("{0:0"+str(base_word_size)+"b}").format(fill_value))) + '\n'
        file.write(temp_line)

def print_value_convert_format_VHDL_BASE_memory(file, base_word_size, value_a, signed_integer):
    positive_word = 2**(base_word_size)
    word_full_of_ones = positive_word - 1
    maximum_positive_value = positive_word//2 - 1
    if((value_a > maximum_positive_value) and signed_integer):
        temp_line = (("{0:0"+str(base_word_size)+"b}").format(((-value_a)^^(word_full_of_ones)) + 1)) + '\n'
    else:
        temp_line = (("{0:0"+str(base_word_size)+"b}").format(value_a)) + '\n'
    file.write(temp_line)
        
def load_list_convert_format_VHDL_BASE_memory(file, base_word_size, number_of_words, signed_integer):
    positive_word = 2**(base_word_size)
    word_full_of_ones = positive_word - 1
    maximum_positive_value = positive_word//2 - 1
    list_o = [0 for i in range(number_of_words)]
    for i in range (0, number_of_words):
        value_read = int(file.read(base_word_size), base=2)
        file.read(1) # throw away the \n
        if((value_read > maximum_positive_value) and signed_integer):
            value_read = -((value_read ^^ word_full_of_ones) + 1)
        list_o[i] = value_read
    return list_o
    
def load_value_convert_format_VHDL_BASE_memory(file, base_word_size, signed_integer):
    positive_word = 2**(base_word_size)
    word_full_of_ones = positive_word - 1
    maximum_positive_value = positive_word//2 - 1
    value_o = int(file.read(base_word_size), base=2)
    file.read(1) # throw away the \n
    if((value_o > maximum_positive_value) and signed_integer):
            value_o = -((value_o ^^ word_full_of_ones) + 1)
    return value_o

def print_list_convert_format_VHDL_MAC_memory(file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, list_a, final_size):
    list_a_base = integer_to_list(base_word_size_signed, base_word_size_signed_number_words*len(list_a), list_to_integer(extended_word_size_signed, len(list_a), list_a))
    base_word_size_total_bits = base_word_size_signed_number_words*base_word_size_signed
    word_full_of_ones = 2**base_word_size_signed-1
    temp_line = ""
    for j in range(0, len(list_a_base)-1):
        temp_line = (("{0:0"+str(base_word_size_signed)+"b}").format(list_a_base[j])) + temp_line
        if((j % base_word_size_signed_number_words) == (base_word_size_signed_number_words - 1)):
            temp_line = temp_line + '\n'
            file.write(temp_line)
            temp_line = ""
    if(list_a_base[-1] >= 0):
        temp_line = (("{0:0"+str(base_word_size_signed)+"b}").format(list_a_base[-1])) + temp_line
        fill_value = 0
    else:
        temp_line = ((("{0:0"+str(base_word_size_signed)+"b}").format(((-list_a_base[-1])^^(word_full_of_ones)) + 1))) + temp_line
        fill_value = 2**(base_word_size_total_bits)-1
    temp_line = temp_line + '\n'
    file.write(temp_line)
    temp_line = ""
    for i in range (len(list_a),final_size):
        temp_line = ((("{0:0"+str(base_word_size_total_bits)+"b}").format(fill_value))) + temp_line + '\n'
        file.write(temp_line)
        temp_line = ""

def print_value_convert_format_VHDL_MAC_memory(file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, value, final_size):
    list_a_base = integer_to_list(base_word_size_signed, base_word_size_signed_number_words, value)
    base_word_size_total_bits = base_word_size_signed_number_words*base_word_size_signed
    word_full_of_ones = 2**base_word_size_signed-1
    temp_line = ""
    for j in range(0, len(list_a_base)-1):
        temp_line = (("{0:0"+str(base_word_size_signed)+"b}").format(list_a_base[j])) + temp_line
    if(list_a_base[-1] >= 0):
        temp_line = (("{0:0"+str(base_word_size_signed)+"b}").format(list_a_base[-1])) + temp_line
        fill_value = 0
    else:
        temp_line = ((("{0:0"+str(base_word_size_signed)+"b}").format(((-list_a_base[-1])^^(word_full_of_ones)) + 1))) + temp_line
        fill_value = 2**(base_word_size_total_bits)-1
    temp_line = temp_line + '\n'
    file.write(temp_line)
    temp_line = ""
    final_size = final_size - 1
    if(final_size > 0):
        for i in range (final_size):
            temp_line = ((("{0:0"+str(base_word_size_total_bits)+"b}").format(fill_value))) + temp_line + '\n'
            file.write(temp_line)
            temp_line = ""
            
def load_list_value_VHDL_MAC_memory_as_integer(file, base_word_size_signed, base_word_size_signed_number_words, number_of_words, signed_integer):
    positive_word = 2**(base_word_size_signed)
    maximum_positive_value = positive_word//2 - 1
    word_full_of_ones = 2**base_word_size_signed - 1
    positive_full_word = 2**((base_word_size_signed)*base_word_size_signed_number_words)
    final_value = 0
    value = 0
    multiplication_factor = 1
    for i in range (0, number_of_words - 1):
        for j in range(base_word_size_signed_number_words):
            value = int(file.read(base_word_size_signed), base=2) + value*positive_word
        file.read(1) # throw away the \n
        final_value += value*multiplication_factor
        multiplication_factor = multiplication_factor*positive_full_word
        value = 0
    value_read = int(file.read(base_word_size_signed), base=2)
    if((value_read > maximum_positive_value) and signed_integer):
        value_read = -((value_read ^^ word_full_of_ones) + 1)
    value = int(file.read(base_word_size_signed), base=2) + value_read*positive_word
    for j in range(2, base_word_size_signed_number_words):
        value = int(file.read(base_word_size_signed), base=2) + value*positive_word
    file.read(1) # throw away the \n
    final_value += value*multiplication_factor
    return final_value

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
        list_a[-1] = -((list_a[-1] ^^ word_full_of_ones) + 1)
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
        b  = -((b ^^ word_full_of_ones) + 1)
    return ("{0:0"+str(word_size//4)+"x}").format(b)
    
def addition_subtraction_no_reduction(internal_word_division, internal_word_modulus, internal_acc_modulus, operands_size, a, b, sign_a, debug=False):
    acc = 0
    o = [0]*(operands_size)
    C = 0
    C_S = 0
    S = 0
    
    if(debug):
        print("Debug mode active")
        print("(sign) a")
        if(sign_a == '1'):
            print("(-) " + str(a))
        else:
            print("(+) " + str(a))
        print("b")
        print(b)
    
    # Operand size 1 or more
    if(sign_a == 1):
        C_S = acc + b[0] + a[0]
    else:
        C_S = acc + b[0] - a[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    if(operands_size == 1):
        if((acc < 0)):
            o[0] = -((o[0] ^^ internal_word_modulus) + 1)
        return o
        
    # Operand size 2 or more
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[1] + a[1]
    else:
        C_S = acc + b[1] - a[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    if(operands_size == 2):
        if(acc < 0):
            o[1] = -((o[1] ^^ internal_word_modulus) + 1)
        return o
    
    # Operand size 3 or more
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[2] + a[2]
    else:
        C_S = acc + b[2] - a[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    if(operands_size == 3):
        if(acc < 0):
            o[2] = -((o[2] ^^ internal_word_modulus) + 1)
        return o
    
    # Operand size 4 or more
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[3] + a[3]
    else:
        C_S = acc + b[3] - a[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    if(operands_size == 4):
        if(acc < 0):
            o[3] = -((o[3] ^^ internal_word_modulus) + 1)
        return o

    # Operand size 5 or more
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[4] + a[4]
    else:
        C_S = acc + b[4] - a[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    if(operands_size == 5):
        if(acc < 0):
            o[4] = -((o[4] ^^ internal_word_modulus) + 1)
        return o

    # Operand size 6 or more
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[5] + a[5]
    else:
        C_S = acc + b[5] - a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    if(operands_size == 6):
        if(acc < 0):
            o[5] = -((o[5] ^^ internal_word_modulus) + 1)
        return o

    # Operand size 7 or more
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[6] + a[6]
    else:
        C_S = acc + b[6] - a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    if(operands_size == 7):
        if(acc < 0):
            o[6] = -((o[6] ^^ internal_word_modulus) + 1)
        return o

    # Operand size 8
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[7] + a[7]
    else:
        C_S = acc + b[7] - a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[7] = acc&(internal_word_modulus)
    if(acc < 0):
        o[7] = -((o[7] ^^ internal_word_modulus) + 1)
    return o

def addition_subtraction_with_reduction(internal_word_division, internal_word_modulus, internal_acc_modulus, operands_size, prime2, a, b, sign_a, debug=False):
    acc = 0
    o = [0]*(operands_size)
    C = 0
    C_S = 0
    S = 0
    
    if(debug):
        print("Debug mode active")
        print("(sign) a")
        if(sign_a == '1'):
            print("(-) " + str(a))
        else:
            print("(+) " + str(a))
        print("b")
        print(b)
    
    # Operand size 1
    if(operands_size == 1):
        if(sign_a == 1):
            C_S = acc + b[0] + a[0]
        else:
            C_S = acc + b[0] - a[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[0] = -((o[0] ^^ internal_word_modulus) + 1)
            s = 0
        else:
            s = 1
        
        C_S = acc - s*prime2[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[0] = -((o[0] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        C_S = acc + s*prime2[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[0] = -((o[0] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        C_S = acc + s*prime2[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[0] = -((o[0] ^^ internal_word_modulus) + 1)
        
        return o
        
    # Operand size 2
    elif(operands_size == 2):
        if(sign_a == 1):
            C_S = acc + b[0] + a[0]
        else:
            C_S = acc + b[0] - a[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[1] + a[1]
        else:
            C_S = acc + b[1] - a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[1] = -((o[1] ^^ internal_word_modulus) + 1)
            s = 0
        else:
            s = 1
        
        acc = 0
        C_S = acc - s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[1] = -((o[1] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[1] = -((o[1] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[1] = -((o[1] ^^ internal_word_modulus) + 1)
        
        return o
    
    # Operand size 3
    elif(operands_size == 3):
        if(sign_a == 1):
            C_S = acc + b[0] + a[0]
        else:
            C_S = acc + b[0] - a[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[1] + a[1]
        else:
            C_S = acc + b[1] - a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[2] + a[2]
        else:
            C_S = acc + b[2] - a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[2] = -((o[2] ^^ internal_word_modulus) + 1)
            s = 0
        else:
            s = 1
        
        acc = 0
        C_S = acc - s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[2] = -((o[2] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[2] = -((o[2] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[2] = -((o[2] ^^ internal_word_modulus) + 1)
        
        return o
    
    # Operand size 4
    elif(operands_size == 4):
        if(sign_a == 1):
            C_S = acc + b[0] + a[0]
        else:
            C_S = acc + b[0] - a[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[1] + a[1]
        else:
            C_S = acc + b[1] - a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[2] + a[2]
        else:
            C_S = acc + b[2] - a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[3] + a[3]
        else:
            C_S = acc + b[3] - a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[3] = -((o[3] ^^ internal_word_modulus) + 1)
            s = 0
        else:
            s = 1
        
        acc = 0
        C_S = acc - s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[3] + o[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[3] = -((o[3] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[3] + o[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[3] = -((o[3] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[3] + o[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[3] = -((o[3] ^^ internal_word_modulus) + 1)
        
        return o

    # Operand size 5
    elif(operands_size == 5):
        if(sign_a == 1):
            C_S = acc + b[0] + a[0]
        else:
            C_S = acc + b[0] - a[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[1] + a[1]
        else:
            C_S = acc + b[1] - a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[2] + a[2]
        else:
            C_S = acc + b[2] - a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[3] + a[3]
        else:
            C_S = acc + b[3] - a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[4] + a[4]
        else:
            C_S = acc + b[4] - a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[4] = -((o[4] ^^ internal_word_modulus) + 1)
            s = 0
        else:
            s = 1
        
        acc = 0
        C_S = acc - s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[3] + o[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[4] + o[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[4] = -((o[4] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[3] + o[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[4] + o[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[4] = -((o[4] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[3] + o[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[4] + o[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[4] = -((o[4] ^^ internal_word_modulus) + 1)
        
        return o

    # Operand size 6
    elif(operands_size == 6):
        if(sign_a == 1):
            C_S = acc + b[0] + a[0]
        else:
            C_S = acc + b[0] - a[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[1] + a[1]
        else:
            C_S = acc + b[1] - a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[2] + a[2]
        else:
            C_S = acc + b[2] - a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[3] + a[3]
        else:
            C_S = acc + b[3] - a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[4] + a[4]
        else:
            C_S = acc + b[4] - a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[5] + a[5]
        else:
            C_S = acc + b[5] - a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[5] = -((o[5] ^^ internal_word_modulus) + 1)
            s = 0
        else:
            s = 1
        
        acc = 0
        C_S = acc - s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[3] + o[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[4] + o[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[5] + o[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[5] = -((o[5] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[3] + o[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[4] + o[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[5] + o[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[5] = -((o[5] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[3] + o[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[4] + o[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[5] + o[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[5] = -((o[5] ^^ internal_word_modulus) + 1)
        
        return o

    # Operand size 7
    elif(operands_size == 7):
        if(sign_a == 1):
            C_S = acc + b[0] + a[0]
        else:
            C_S = acc + b[0] - a[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[1] + a[1]
        else:
            C_S = acc + b[1] - a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[2] + a[2]
        else:
            C_S = acc + b[2] - a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[3] + a[3]
        else:
            C_S = acc + b[3] - a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[4] + a[4]
        else:
            C_S = acc + b[4] - a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[5] + a[5]
        else:
            C_S = acc + b[5] - a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(sign_a == 1):
            C_S = acc + b[6] + a[6]
        else:
            C_S = acc + b[6] - a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[6] = -((o[6] ^^ internal_word_modulus) + 1)
            s = 0
        else:
            s = 1
        
        acc = 0
        C_S = acc - s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[3] + o[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[4] + o[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[5] + o[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc - s*prime2[6] + o[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[6] = -((o[6] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[3] + o[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[4] + o[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[5] + o[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[6] + o[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[6] = -((o[6] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + s*prime2[0] + o[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[1] + o[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[2] + o[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[3] + o[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[4] + o[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[5] + o[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + s*prime2[6] + o[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[6] = -((o[6] ^^ internal_word_modulus) + 1)
        
        return o

    # Operand size 8
    if(sign_a == 1):
        C_S = acc + b[0] + a[0]
    else:
        C_S = acc + b[0] - a[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[1] + a[1]
    else:
        C_S = acc + b[1] - a[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[2] + a[2]
    else:
        C_S = acc + b[2] - a[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[3] + a[3]
    else:
        C_S = acc + b[3] - a[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[4] + a[4]
    else:
        C_S = acc + b[4] - a[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[5] + a[5]
    else:
        C_S = acc + b[5] - a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[6] + a[6]
    else:
        C_S = acc + b[6] - a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(sign_a == 1):
        C_S = acc + b[7] + a[7]
    else:
        C_S = acc + b[7] - a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[7] = acc&(internal_word_modulus)
    if((acc < 0)):
        o[7] = -((o[7] ^^ internal_word_modulus) + 1)
        s = 0
    else:
        s = 1
    
    acc = 0
    C_S = acc - s*prime2[0] + o[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc - s*prime2[1] + o[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc - s*prime2[2] + o[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc - s*prime2[3] + o[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc - s*prime2[4] + o[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc - s*prime2[5] + o[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc - s*prime2[6] + o[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc - s*prime2[7] + o[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[7] = acc&(internal_word_modulus)
    if((acc < 0)):
        o[7] = -((o[7] ^^ internal_word_modulus) + 1)
        s = 1
    else:
        s = 0
    
    acc = 0
    C_S = acc + s*prime2[0] + o[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[1] + o[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[2] + o[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[3] + o[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[4] + o[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[5] + o[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[6] + o[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[7] + o[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[7] = acc&(internal_word_modulus)
    if((acc < 0)):
        o[7] = -((o[7] ^^ internal_word_modulus) + 1)
        s = 1
    else:
        s = 0
    
    acc = 0
    C_S = acc + s*prime2[0] + o[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[1] + o[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[2] + o[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[3] + o[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[4] + o[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[5] + o[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[6] + o[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + s*prime2[7] + o[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[7] = acc&(internal_word_modulus)
    if((acc < 0)):
        o[7] = -((o[7] ^^ internal_word_modulus) + 1)
    
    return o
    
def iterative_modular_reduction(internal_word_division, internal_word_modulus, internal_acc_modulus, operands_size, prime, a, debug=False):
    acc = 0
    o = [0]*(operands_size)
    C_S = 0
    
    s = 0
    
    if(debug):
        print("Debug mode active")
        print("prime")
        print(prime)
        print("a")
        print(a)
        
    if(operands_size == 1):
        # Operand size 1
        if(a[0] < 0):
            s = 0
        else:
            s = 1
        C_S = acc + a[0] - s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        if(acc < 0):
            o[0] = -((o[0] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        if(acc < 0):
            o[0] = -((o[0] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        if(acc < 0):
            o[0] = -((o[0] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        return o
        
    if(operands_size == 2):
        # Operand size 2
        if(a[1] < 0):
            s = 0
        else:
            s = 1
        C_S = acc + a[0] - s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[1] - s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        if(acc < 0):
            o[1] = -((o[1] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[1] + s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        if(acc < 0):
            o[1] = -((o[1] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[1] + s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        if(acc < 0):
            o[1] = -((o[1] ^^ internal_word_modulus) + 1)
        
        return o
        
    if(operands_size == 3):
        # Operand size 3
        if(a[2] < 0):
            s = 0
        else:
            s = 1
        C_S = acc + a[0] - s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[1] - s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[2] - s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        if(acc < 0):
            o[2] = -((o[2] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[1] + s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[2] + s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        if(acc < 0):
            o[2] = -((o[2] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[1] + s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[2] + s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        if(acc < 0):
            o[2] = -((o[2] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        return o
    
    if(operands_size == 4):
        # Operand size 4
        if(a[3] < 0):
            s = 0
        else:
            s = 1
        C_S = acc + a[0] - s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[1] - s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[2] - s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[3] - s*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        if(acc < 0):
            o[3] = -((o[3] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
            
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[1] + s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[2] + s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[3] + s*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        if(acc < 0):
            o[3] = -((o[3] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[1] + s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[2] + s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[3] + s*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        if(acc < 0):
            o[3] = -((o[3] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        return o

    if(operands_size == 5):
        # Operand size 5
        if(a[4] < 0):
            s = 0
        else:
            s = 1
        C_S = acc + a[0] - s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[1] - s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[2] - s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[3] - s*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[4] - s*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        if(acc < 0):
            o[4] = -((o[4] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
            
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[1] + s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[2] + s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[3] + s*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[4] + s*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        if(acc < 0):
            o[4] = -((o[4] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[1] + s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[2] + s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[3] + s*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[4] + s*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        if(acc < 0):
            o[4] = -((o[4] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        return o
        
    if(operands_size == 6):
        # Operand size 6
        if(a[5] < 0):
            s = 0
        else:
            s = 1
        C_S = acc + a[0] - s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[1] - s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[2] - s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[3] - s*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[4] - s*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[5] - s*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        if(acc < 0):
            o[5] = -((o[5] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
            
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[1] + s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[2] + s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[3] + s*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[4] + s*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[5] + s*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        if(acc < 0):
            o[5] = -((o[5] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[1] + s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[2] + s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[3] + s*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[4] + s*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[5] + s*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        if(acc < 0):
            o[5] = -((o[5] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        return o
        
    if(operands_size == 7):
        # Operand size 7
        if(a[6] < 0):
            s = 0
        else:
            s = 1
        C_S = acc + a[0] - s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[1] - s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[2] - s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[3] - s*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[4] - s*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[5] - s*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + a[6] - s*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        if(acc < 0):
            o[6] = -((o[6] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
            
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[1] + s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[2] + s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[3] + s*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[4] + s*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[5] + s*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[6] + s*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        if(acc < 0):
            o[6] = -((o[6] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        acc = 0
        C_S = acc + o[0] + s*prime[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[1] + s*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[2] + s*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[3] + s*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[4] + s*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[5] + s*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        C_S = acc + o[6] + s*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        if(acc < 0):
            o[6] = -((o[6] ^^ internal_word_modulus) + 1)
            s = 1
        else:
            s = 0
        
        return o
        
    # Operand size 8
    if(a[7] < 0):
        s = 0
    else:
        s = 1
    C_S = acc + a[0] - s*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + a[1] - s*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + a[2] - s*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + a[3] - s*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + a[4] - s*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + a[5] - s*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + a[6] - s*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + a[7] - s*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[7] = acc&(internal_word_modulus)
    if(acc < 0):
        o[7] = -((o[7] ^^ internal_word_modulus) + 1)
        s = 1
    else:
        s = 0
        
    acc = 0
    C_S = acc + o[0] + s*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[1] + s*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[2] + s*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[3] + s*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[4] + s*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[5] + s*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[6] + s*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[7] + s*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[7] = acc&(internal_word_modulus)
    if(acc < 0):
        o[7] = -((o[7] ^^ internal_word_modulus) + 1)
        s = 1
    else:
        s = 0
    
    acc = 0
    C_S = acc + o[0] + s*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[1] + s*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[2] + s*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[3] + s*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[4] + s*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[5] + s*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[6] + s*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    C_S = acc + o[7] + s*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[7] = acc&(internal_word_modulus)
    if(acc < 0):
        o[7] = -((o[7] ^^ internal_word_modulus) + 1)
        s = 1
    else:
        s = 0
    
    return o
    
def multiplication_no_reduction(internal_word_division, internal_word_modulus, internal_acc_modulus, operands_size, a, b, debug=False):
    acc = 0
    o = [0]*(2*operands_size)
    C = 0
    C_S = 0
    S = 0
    
    if(debug):
        print("Debug mode active")
        print("a")
        print(a)
        print("b")
        print(b)
    
    # First loop, i = 0
    C_S = acc + a[0]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 1):
        o[1] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[1] = -((o[1] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 1
    C_S = acc + a[0]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 2):
        # Second loop, i = 2
        C_S = acc + a[1]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 3
        o[3] = acc&(internal_word_modulus)
        if(acc < 0):
            o[3] = -((o[3] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 2
    C_S = acc + a[0]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 3):
        # Second loop, i = 3
        C_S = acc + a[1]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 4
        C_S = acc + a[2]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 5
        o[5] = acc&(internal_word_modulus)
        if(acc < 0):
            o[5] = -((o[5] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 3
    C_S = acc + a[0]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 4):
        # Second loop, i = 4
        C_S = acc + a[1]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 5
        C_S = acc + a[2]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 6
        C_S = acc + a[3]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 7
        o[7] = acc&(internal_word_modulus)
        if(acc < 0):
            o[7] = -((o[7] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 4
    C_S = acc + a[0]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 5):
        # Second loop, i = 5
        C_S = acc + a[1]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 6
        C_S = acc + a[2]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 7
        C_S = acc + a[3]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[7] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + a[4]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[8] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        o[9] = acc&(internal_word_modulus)
        if(acc < 0):
            o[9] = -((o[9] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 5
    C_S = acc + a[0]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 6):
        # Second loop, i = 6
        C_S = acc + a[1]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 7
        C_S = acc + a[2]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[7] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + a[3]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[8] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + a[4]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[9] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + a[5]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[10] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        o[11] = acc&(internal_word_modulus)
        if(acc < 0):
            o[11] = -((o[11] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 6
    C_S = acc + a[0]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 7):
        # Second loop, i = 7
        C_S = acc + a[1]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[7] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + a[2]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[8] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + a[3]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[9] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + a[4]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[10] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        C_S = acc + a[5]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[11] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 12
        C_S = acc + a[6]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[12] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        o[13] = acc&(internal_word_modulus)
        if(acc < 0):
            o[13] = -((o[13] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 7
    C_S = acc + a[0]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[7] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 8
    C_S = acc + a[1]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[8] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 9
    C_S = acc + a[2]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[9] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 10
    C_S = acc + a[3]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[10] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 11
    C_S = acc + a[4]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[11] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 12
    C_S = acc + a[5]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[12] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 13
    C_S = acc + a[6]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[13] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 14
    C_S = acc + a[7]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[14] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 13
    o[15] = acc&(internal_word_modulus)
    if(acc < 0):
        o[15] = -((o[15] ^^ internal_word_modulus) + 1)
    return o
    
def square_no_reduction(internal_word_division, internal_word_modulus, internal_acc_modulus, operands_size, a, debug=False):
    acc = 0
    o = [0]*(2*operands_size)
    C = 0
    C_S = 0
    S = 0
    
    if(debug):
        print("Debug mode active")
        print("a")
        print(a)
    
    # First loop, i = 0
    C_S = acc + a[0]*a[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 1):
        o[1] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[1] = -((o[1] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 1
    C_S = acc + 2*a[0]*a[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 2):
        # Second loop, i = 2
        C_S = acc + a[1]*a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 3
        o[3] = acc&(internal_word_modulus)
        if(acc < 0):
            o[3] = -((o[3] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 2
    C_S = acc + 2*a[0]*a[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*a[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 3):
        # Second loop, i = 3
        C_S = acc + 2*a[1]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 4
        C_S = acc + a[2]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 5
        o[5] = acc&(internal_word_modulus)
        if(acc < 0):
            o[5] = -((o[5] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 3
    C_S = acc + 2*a[0]*a[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[1]*a[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 4):
        # Second loop, i = 4
        C_S = acc + 2*a[1]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 5
        C_S = acc + 2*a[2]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 6
        C_S = acc + a[3]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 7
        o[7] = acc&(internal_word_modulus)
        if(acc < 0):
            o[7] = -((o[7] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 4
    C_S = acc + 2*a[0]*a[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[1]*a[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*a[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 5):
        # Second loop, i = 5
        C_S = acc + 2*a[1]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 6
        C_S = acc + 2*a[2]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 7
        C_S = acc + 2*a[3]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[7] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + a[4]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[8] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        o[9] = acc&(internal_word_modulus)
        if(acc < 0):
            o[9] = -((o[9] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 5
    C_S = acc + 2*a[0]*a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[1]*a[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[2]*a[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 6):
        # Second loop, i = 6
        C_S = acc + 2*a[1]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 7
        C_S = acc + 2*a[2]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[7] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + 2*a[3]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[8] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + 2*a[4]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[9] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + a[5]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[10] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        o[11] = acc&(internal_word_modulus)
        if(acc < 0):
            o[11] = -((o[11] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 6
    C_S = acc + 2*a[0]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[1]*a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[2]*a[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*a[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    if(operands_size == 7):
        # Second loop, i = 7
        C_S = acc + 2*a[1]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[7] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + 2*a[2]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[8] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + 2*a[3]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[4]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[9] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + 2*a[4]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[10] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        C_S = acc + 2*a[5]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[11] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 12
        C_S = acc + a[6]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[12] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        o[13] = acc&(internal_word_modulus)
        if(acc < 0):
            o[13] = -((o[13] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 7
    C_S = acc + 2*a[0]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[1]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[2]*a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[3]*a[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[7] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 8
    C_S = acc + 2*a[1]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[2]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[3]*a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*a[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[8] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 9
    C_S = acc + 2*a[2]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[3]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[4]*a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[9] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 10
    C_S = acc + 2*a[3]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[4]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[10] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 11
    C_S = acc + 2*a[4]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[5]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[11] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 12
    C_S = acc + 2*a[5]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[12] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 13
    C_S = acc + 2*a[6]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[13] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 14
    C_S = acc + a[7]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[14] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 15
    o[15] = acc&(internal_word_modulus)
    if(acc < 0):
        o[15] = -((o[15] ^^ internal_word_modulus) + 1)
    return o
    
def  montgomery_squaring(internal_word_division, internal_word_modulus, internal_acc_modulus, operands_size, prime, prime_sharp, prime_line_0, a, debug=False):
    acc = 0
    o = [0]*operands_size
    C = 0
    C_S = 0
    S = 0
    
    if(prime_line_0 == 1):
        return montgomery_squaring_with_prime_line_0(internal_word_division, internal_word_modulus, internal_acc_modulus, operands_size, prime_sharp, a, debug)
    
    if(debug):
        print("Debug mode active")
        print("prime")
        print(prime)
        print("prime line 0")
        print(prime_line_0)
        print("a")
        print(a)
    
    # First loop, i = 0
    C_S = acc + a[0]*a[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    o[0] = (o[0]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[0]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 1):
        o[0] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[0] = -((o[0] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 1
    C_S = acc + 2*a[0]*a[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    o[1] = (o[1]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[1]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 2):
        # Second loop, i = 2
        C_S = acc + a[1]*a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 3
        o[1] = acc&(internal_word_modulus)
        if(acc < 0):
            o[1] = -((o[1] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 2
    C_S = acc + 2*a[0]*a[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*a[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    o[2] = (o[2]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[2]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 3):
        # Second loop, i = 3
        C_S = acc + 2*a[1]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 4
        C_S = acc + a[2]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 5
        o[2] = acc&(internal_word_modulus)
        if(acc < 0):
            o[2] = -((o[2] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 3
    C_S = acc + 2*a[0]*a[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[1]*a[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    o[3] = (o[3]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[3]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 4):
        # Second loop, i = 4
        C_S = acc + 2*a[1]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 5
        C_S = acc + 2*a[2]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 6
        C_S = acc + a[3]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 7
        o[3] = acc&(internal_word_modulus)
        if(acc < 0):
            o[3] = -((o[3] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 4
    C_S = acc + 2*a[0]*a[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[1]*a[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*a[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    o[4] = (o[4]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[4]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 5):
        # Second loop, i = 5
        C_S = acc + 2*a[1]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 6
        C_S = acc + 2*a[2]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 7
        C_S = acc + 2*a[3]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + a[4]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        o[4] = acc&(internal_word_modulus)
        if(acc < 0):
            o[4] = -((o[4] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 5
    C_S = acc + 2*a[0]*a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[1]*a[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[2]*a[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    o[5] = (o[5]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[5]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 6):
        # Second loop, i = 6
        C_S = acc + 2*a[1]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 7
        C_S = acc + 2*a[2]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + 2*a[3]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + 2*a[4]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + a[5]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        o[5] = acc&(internal_word_modulus)
        if(acc < 0):
            o[5] = -((o[5] ^^ internal_word_modulus) + 1)
        return o

    # First loop, i = 6
    C_S = acc + 2*a[0]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[1]*a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[2]*a[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*a[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    o[6] = (o[6]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[6]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 7):
        # Second loop, i = 7
        C_S = acc + 2*a[1]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + 2*a[2]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + 2*a[3]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[4]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + 2*a[4]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        C_S = acc + 2*a[5]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 12
        C_S = acc + a[6]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        o[6] = acc&(internal_word_modulus)
        if(acc < 0):
            o[6] = -((o[6] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 7
    C_S = acc + 2*a[0]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[1]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[2]*a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[3]*a[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[7] = acc&(internal_word_modulus)
    o[7] = (o[7]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[7]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    # Second loop, i = 8
    C_S = acc + 2*a[1]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[2]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[3]*a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*a[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 9
    C_S = acc + 2*a[2]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[3]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[4]*a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 10
    C_S = acc + 2*a[3]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[4]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*a[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 11
    C_S = acc + 2*a[4]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + 2*a[5]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 12
    C_S = acc + 2*a[5]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*a[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 13
    C_S = acc + 2*a[6]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 14
    C_S = acc + a[7]*a[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 13
    o[7] = acc&(internal_word_modulus)
    if(acc < 0):
        o[7] = -((o[7] ^^ internal_word_modulus) + 1)
    return o

def  montgomery_squaring_with_prime_line_0(internal_word_division, internal_word_modulus, internal_acc_modulus, operands_size, prime_sharp, a, debug=False):
    acc = 0
    o = [0]*operands_size
    C = 0
    C_S = 0
    S = 0
    
    prime_sharp_number_of_zeroes = 0
    for each_prime_sharp in prime_sharp:
        if(each_prime_sharp == 0):
            prime_sharp_number_of_zeroes = prime_sharp_number_of_zeroes + 1
        else:
            break;
    
    if(debug):
        print("Debug mode active")
        print("prime + 1")
        print(prime_sharp)
        print("a")
        print(a)

    if(prime_sharp_number_of_zeroes == 1):
        # First loop, i = 0
        C_S = acc + a[0]*a[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 1): # This is extremely unlikely, but is left here in such a case.
            o[0] = acc&(internal_word_modulus)
            if((acc < 0)):
                o[0] = -((o[0] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 1
        C_S = acc + 2*a[0]*a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 2):
            # Second loop, i = 2
            C_S = acc + a[1]*a[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 3
            o[1] = acc&(internal_word_modulus)
            if(acc < 0):
                o[1] = -((o[1] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 2
        C_S = acc + 2*a[0]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 3):
            # Second loop, i = 3
            C_S = acc + 2*a[1]*a[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 4
            C_S = acc + a[2]*a[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 5
            o[2] = acc&(internal_word_modulus)
            if(acc < 0):
                o[2] = -((o[2] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 3
        C_S = acc + 2*a[0]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 4):
            # Second loop, i = 4
            C_S = acc + 2*a[1]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*a[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 5
            C_S = acc + 2*a[2]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 6
            C_S = acc + a[3]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            o[3] = acc&(internal_word_modulus)
            if(acc < 0):
                o[3] = -((o[3] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 4
        C_S = acc + 2*a[0]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 5):
            # Second loop, i = 5
            C_S = acc + 2*a[1]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[2]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 6
            C_S = acc + 2*a[2]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            C_S = acc + 2*a[3]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + a[4]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            o[4] = acc&(internal_word_modulus)
            if(acc < 0):
                o[4] = -((o[4] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 5
        C_S = acc + 2*a[0]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 6):
            # Second loop, i = 6
            C_S = acc + 2*a[1]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[2]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            C_S = acc + 2*a[2]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[3]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + 2*a[3]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            C_S = acc + 2*a[4]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 10
            C_S = acc + a[5]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[4] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 11
            o[5] = acc&(internal_word_modulus)
            if(acc < 0):
                o[5] = -((o[5] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 6
        C_S = acc + 2*a[0]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 7):
            # Second loop, i = 7
            C_S = acc + 2*a[1]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[2]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[3]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + 2*a[2]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[3]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            C_S = acc + 2*a[3]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[4]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 10
            C_S = acc + 2*a[4]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 11
            C_S = acc + 2*a[5]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[4] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 12
            C_S = acc + a[6]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[5] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 13
            o[6] = acc&(internal_word_modulus)
            if(acc < 0):
                o[6] = -((o[6] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 7
        C_S = acc + 2*a[0]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[7] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + 2*a[1]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + 2*a[2]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[4]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + 2*a[3]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[4]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        C_S = acc + 2*a[4]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[5]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 12
        C_S = acc + 2*a[5]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        C_S = acc + 2*a[6]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 14
        C_S = acc + a[7]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        o[7] = acc&(internal_word_modulus)
        if(acc < 0):
            o[7] = -((o[6] ^^ internal_word_modulus) + 1)
        return o
    
    # TODO: Expand this for other cases smaller than 5.
    elif(prime_sharp_number_of_zeroes == 2):
        # First loop, i = 0
        C_S = acc + a[0]*a[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # First loop, i = 1
        C_S = acc + 2*a[0]*a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 2):
            # Second loop, i = 2
            C_S = acc + a[1]*a[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 3
            o[1] = acc&(internal_word_modulus)
            if(acc < 0):
                o[1] = -((o[1] ^^ internal_word_modulus) + 1)
            return o
            
        # First loop, i = 2
        C_S = acc + 2*a[0]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 3):
            # Second loop, i = 3
            C_S = acc + 2*a[1]*a[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 4
            C_S = acc + a[2]*a[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 5
            o[2] = acc&(internal_word_modulus)
            if(acc < 0):
                o[2] = -((o[2] ^^ internal_word_modulus) + 1)
            return o
            
        # First loop, i = 3
        C_S = acc + 2*a[0]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 4):
            # Second loop, i = 4
            C_S = acc + 2*a[1]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*a[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 5
            C_S = acc + 2*a[2]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 6
            C_S = acc + a[3]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            o[3] = acc&(internal_word_modulus)
            if(acc < 0):
                o[3] = -((o[3] ^^ internal_word_modulus) + 1)
            return o
            
        # First loop, i = 4
        C_S = acc + 2*a[0]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 5):
            # Second loop, i = 5
            C_S = acc + 2*a[1]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[2]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 6
            C_S = acc + 2*a[2]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            C_S = acc + 2*a[3]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + a[4]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            o[4] = acc&(internal_word_modulus)
            if(acc < 0):
                o[4] = -((o[4] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 5
        C_S = acc + 2*a[0]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 6):
            # Second loop, i = 6
            C_S = acc + 2*a[1]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[2]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            C_S = acc + 2*a[2]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[3]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + 2*a[3]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            C_S = acc + 2*a[4]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 10
            C_S = acc + a[5]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[4] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 11
            o[5] = acc&(internal_word_modulus)
            if(acc < 0):
                o[5] = -((o[5] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 6
        C_S = acc + 2*a[0]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 7):
            # Second loop, i = 7
            C_S = acc + 2*a[1]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[2]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[3]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + 2*a[2]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[3]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            C_S = acc + 2*a[3]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[4]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 10
            C_S = acc + 2*a[4]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 11
            C_S = acc + 2*a[5]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[4] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 12
            C_S = acc + a[6]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[5] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 13
            o[6] = acc&(internal_word_modulus)
            if(acc < 0):
                o[6] = -((o[6] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 7
        C_S = acc + 2*a[0]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[7] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + 2*a[1]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + 2*a[2]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[4]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + 2*a[3]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[4]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        C_S = acc + 2*a[4]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[5]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 12
        C_S = acc + 2*a[5]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        C_S = acc + 2*a[6]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 14
        C_S = acc + a[7]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        o[7] = acc&(internal_word_modulus)
        if(acc < 0):
            o[7] = -((o[6] ^^ internal_word_modulus) + 1)
        return o
        
    else:
        # First loop, i = 0
        C_S = acc + a[0]*a[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # First loop, i = 1
        C_S = acc + 2*a[0]*a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # First loop, i = 2
        C_S = acc + 2*a[0]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*a[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 3):
            # Second loop, i = 3
            C_S = acc + 2*a[1]*a[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 4
            C_S = acc + a[2]*a[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 5
            o[2] = acc&(internal_word_modulus)
            if(acc < 0):
                o[2] = -((o[2] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 3
        C_S = acc + 2*a[0]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 4):
            # Second loop, i = 4
            C_S = acc + 2*a[1]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*a[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 5
            C_S = acc + 2*a[2]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 6
            C_S = acc + a[3]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            o[3] = acc&(internal_word_modulus)
            if(acc < 0):
                o[3] = -((o[3] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 4
        C_S = acc + 2*a[0]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*a[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 5):
            # Second loop, i = 5
            C_S = acc + 2*a[1]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[2]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 6
            C_S = acc + 2*a[2]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            C_S = acc + 2*a[3]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + a[4]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            o[4] = acc&(internal_word_modulus)
            if(acc < 0):
                o[4] = -((o[4] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 5
        C_S = acc + 2*a[0]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 6):
            # Second loop, i = 6
            C_S = acc + 2*a[1]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[2]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*a[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            C_S = acc + 2*a[2]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[3]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + 2*a[3]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            C_S = acc + 2*a[4]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 10
            C_S = acc + a[5]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[4] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 11
            o[5] = acc&(internal_word_modulus)
            if(acc < 0):
                o[5] = -((o[5] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 6
        C_S = acc + 2*a[0]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*a[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 7):
            # Second loop, i = 7
            C_S = acc + 2*a[1]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[2]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[3]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + 2*a[2]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[3]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*a[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            C_S = acc + 2*a[3]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + 2*a[4]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 10
            C_S = acc + 2*a[4]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*a[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 11
            C_S = acc + 2*a[5]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[4] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 12
            C_S = acc + a[6]*a[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[5] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 13
            o[6] = acc&(internal_word_modulus)
            if(acc < 0):
                o[6] = -((o[6] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 7
        C_S = acc + 2*a[0]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[1]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[7] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + 2*a[1]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[2]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*a[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + 2*a[2]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[3]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[4]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + 2*a[3]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[4]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*a[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        C_S = acc + 2*a[4]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + 2*a[5]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 12
        C_S = acc + 2*a[5]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*a[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        C_S = acc + 2*a[6]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 14
        C_S = acc + a[7]*a[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 15
        o[7] = acc&(internal_word_modulus)
        if(acc < 0):
            o[7] = -((o[7] ^^ internal_word_modulus) + 1)
        return o
        
    
    
def  montgomery_multiplication(internal_word_division, internal_word_modulus, internal_acc_modulus, operands_size, prime, prime_sharp, prime_line_0, a, b, debug=False):
    acc = 0
    o = [0]*operands_size
    C = 0
    C_S = 0
    S = 0
    
    if(prime_line_0 == 1):
        return montgomery_multiplication_with_prime_line_0(internal_word_division, internal_word_modulus, internal_acc_modulus, operands_size, prime_sharp, a, b, debug=False)
    
    if(debug):
        print("Debug mode active")
        print("prime")
        print(str(prime))
        print("prime line 0")
        print(str(prime_line_0))
        print("a")
        print(str(a))
        print("b")
        print(str(b))
        
    # First loop, i = 0
    C_S = acc + a[0]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    o[0] = (o[0]*prime_line_0)&(internal_word_modulus)
    if(debug):
        print("o[0]")
        print(o[0])
    C_S = acc + o[0]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 1):
        o[0] = acc&(internal_word_modulus)
        if((acc < 0)):
            o[0] = -((o[0] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 1
    C_S = acc + a[0]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    o[1] = (o[1]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[1]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 2):
        # Second loop, i = 2
        C_S = acc + a[1]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 3
        o[1] = acc&(internal_word_modulus)
        if(acc < 0):
            o[1] = -((o[1] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 2
    C_S = acc + a[0]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    o[2] = (o[2]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[2]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 3):
        # Second loop, i = 3
        C_S = acc + a[1]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 4
        C_S = acc + a[2]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 5
        o[2] = acc&(internal_word_modulus)
        if(acc < 0):
            o[2] = -((o[2] ^^ internal_word_modulus) + 1)
        return o
    
    # First loop, i = 3
    C_S = acc + a[0]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    o[3] = (o[3]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[3]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 4):
        # Second loop, i = 4
        C_S = acc + a[1]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 5
        C_S = acc + a[2]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 6
        C_S = acc + a[3]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 7
        o[3] = acc&(internal_word_modulus)
        if(acc < 0):
            o[3] = -((o[3] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 4
    C_S = acc + a[0]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    o[4] = (o[4]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[4]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 5):
        # Second loop, i = 5
        C_S = acc + a[1]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 6
        C_S = acc + a[2]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 7
        C_S = acc + a[3]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + a[4]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        o[4] = acc&(internal_word_modulus)
        if(acc < 0):
            o[4] = -((o[4] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 5
    C_S = acc + a[0]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    o[5] = (o[5]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[5]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 6):
        # Second loop, i = 6
        C_S = acc + a[1]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 7
        C_S = acc + a[2]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + a[3]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + a[4]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + a[5]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        o[5] = acc&(internal_word_modulus)
        if(acc < 0):
            o[5] = -((o[5] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 6
    C_S = acc + a[0]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    o[6] = (o[6]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[6]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    if(operands_size == 7):
        # Second loop, i = 7
        C_S = acc + a[1]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + a[2]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + a[3]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + a[4]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        C_S = acc + a[5]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 12
        C_S = acc + a[6]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        o[6] = acc&(internal_word_modulus)
        if(acc < 0):
            o[6] = -((o[6] ^^ internal_word_modulus) + 1)
        return o
        
    # First loop, i = 7
    C_S = acc + a[0]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[0]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[1]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[7] = acc&(internal_word_modulus)
    o[7] = (o[7]*prime_line_0)&(internal_word_modulus)
    C_S = acc + o[7]*prime[0]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    acc = acc//(internal_word_division)
    # Second loop, i = 8
    C_S = acc + a[1]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[1]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[2]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[1]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[0] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 9
    C_S = acc + a[2]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[2]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[3]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[2]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[1] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 10
    C_S = acc + a[3]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[3]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[4]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[3]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[2] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 11
    C_S = acc + a[4]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[4]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[5]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[4]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[3] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 12
    C_S = acc + a[5]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[5]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[6]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[5]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[4] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 13
    C_S = acc + a[6]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[6]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + a[7]*b[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[6]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[5] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 14
    C_S = acc + a[7]*b[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    C_S = acc + o[7]*prime[7]
    acc = C_S&(internal_acc_modulus)
    if(C_S < 0):
        acc = -((acc ^^ internal_acc_modulus) + 1)
    o[6] = acc&(internal_word_modulus)
    acc = acc//(internal_word_division)
    # Second loop, i = 15
    o[7] = acc&(internal_word_modulus)
    if(acc < 0):
        o[7] = -((o[7] ^^ internal_word_modulus) + 1)
    return o

def montgomery_multiplication_with_prime_line_0(internal_word_division, internal_word_modulus, internal_acc_modulus, operands_size, prime_sharp, a, b, debug=False):
    acc = 0
    o = [0]*operands_size
    C = 0
    C_S = 0
    S = 0
    
    prime_sharp_number_of_zeroes = 0
    for each_prime_sharp in prime_sharp:
        if(each_prime_sharp == 0):
            prime_sharp_number_of_zeroes = prime_sharp_number_of_zeroes + 1
        else:
            break
    
    if(debug):
        print("Debug mode active")
        print("prime plus one")
        print(prime_sharp)
        print("a")
        print(a)
        print("b")
        print(b)
    
    if(prime_sharp_number_of_zeroes == 1):
        # First loop, i = 0
        C_S = acc + a[0]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 1): # This is extremely unlikely, but is left here in such a case.
            o[0] = acc&(internal_word_modulus)
            if((acc < 0)):
                o[0] = -((o[0] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 1
        C_S = acc + a[0]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 2):
            # Second loop, i = 2
            C_S = acc + a[1]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 3
            o[1] = acc&(internal_word_modulus)
            if(acc < 0):
                o[1] = -((o[1] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 2
        C_S = acc + a[0]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 3):
            # Second loop, i = 3
            C_S = acc + a[1]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 4
            C_S = acc + a[2]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 5
            o[2] = acc&(internal_word_modulus)
            if(acc < 0):
                o[2] = -((o[2] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 3
        C_S = acc + a[0]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 4):
            # Second loop, i = 4
            C_S = acc + a[1]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 5
            C_S = acc + a[2]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 6
            C_S = acc + a[3]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            o[3] = acc&(internal_word_modulus)
            if(acc < 0):
                o[3] = -((o[3] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 4
        C_S = acc + a[0]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 5):
            # Second loop, i = 5
            C_S = acc + a[1]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 6
            C_S = acc + a[2]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            C_S = acc + a[3]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + a[4]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            o[4] = acc&(internal_word_modulus)
            if(acc < 0):
                o[4] = -((o[4] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 5
        C_S = acc + a[0]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 6):
            # Second loop, i = 6
            C_S = acc + a[1]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            C_S = acc + a[2]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + a[3]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            C_S = acc + a[4]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 10
            C_S = acc + a[5]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[4] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 11
            o[5] = acc&(internal_word_modulus)
            if(acc < 0):
                o[5] = -((o[5] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 6
        C_S = acc + a[0]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 7):
            # Second loop, i = 7
            C_S = acc + a[1]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + a[2]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            C_S = acc + a[3]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 10
            C_S = acc + a[4]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 11
            C_S = acc + a[5]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[4] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 12
            C_S = acc + a[6]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[5] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 13
            o[6] = acc&(internal_word_modulus)
            if(acc < 0):
                o[6] = -((o[6] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 7
        C_S = acc + a[0]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[7] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + a[1]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + a[2]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + a[3]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        C_S = acc + a[4]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 12
        C_S = acc + a[5]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        C_S = acc + a[6]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 14
        C_S = acc + a[7]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 15
        o[7] = acc&(internal_word_modulus)
        if(acc < 0):
            o[7] = -((o[7] ^^ internal_word_modulus) + 1)
        return o
            
    elif(prime_sharp_number_of_zeroes == 2):
        # First loop, i = 0
        C_S = acc + a[0]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # First loop, i = 1
        C_S = acc + a[0]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 2):
            # Second loop, i = 2
            C_S = acc + a[1]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 3
            o[1] = acc&(internal_word_modulus)
            if(acc < 0):
                o[1] = -((o[1] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 2
        C_S = acc + a[0]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 3):
            # Second loop, i = 3
            C_S = acc + a[1]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 4
            C_S = acc + a[2]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 5
            o[2] = acc&(internal_word_modulus)
            if(acc < 0):
                o[2] = -((o[2] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 3
        C_S = acc + a[0]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 4):
            # Second loop, i = 4
            C_S = acc + a[1]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 5
            C_S = acc + a[2]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 6
            C_S = acc + a[3]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            o[3] = acc&(internal_word_modulus)
            if(acc < 0):
                o[3] = -((o[3] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 4
        C_S = acc + a[0]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 5):
            # Second loop, i = 5
            C_S = acc + a[1]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 6
            C_S = acc + a[2]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            C_S = acc + a[3]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + a[4]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            o[4] = acc&(internal_word_modulus)
            if(acc < 0):
                o[4] = -((o[4] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 5
        C_S = acc + a[0]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 6):
            # Second loop, i = 6
            C_S = acc + a[1]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            C_S = acc + a[2]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + a[3]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            C_S = acc + a[4]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 10
            C_S = acc + a[5]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[4] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 11
            o[5] = acc&(internal_word_modulus)
            if(acc < 0):
                o[5] = -((o[5] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 6
        C_S = acc + a[0]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 7):
            # Second loop, i = 7
            C_S = acc + a[1]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + a[2]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            C_S = acc + a[3]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 10
            C_S = acc + a[4]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 11
            C_S = acc + a[5]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[4] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 12
            C_S = acc + a[6]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[5] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 13
            o[6] = acc&(internal_word_modulus)
            if(acc < 0):
                o[6] = -((o[6] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 7
        C_S = acc + a[0]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[7] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + a[1]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + a[2]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + a[3]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        C_S = acc + a[4]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 12
        C_S = acc + a[5]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        C_S = acc + a[6]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 14
        C_S = acc + a[7]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 15
        o[7] = acc&(internal_word_modulus)
        if(acc < 0):
            o[7] = -((o[7] ^^ internal_word_modulus) + 1)
        return o
        
    else:
        # First loop, i = 0
        C_S = acc + a[0]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # First loop, i = 1
        C_S = acc + a[0]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # First loop, i = 2
        C_S = acc + a[0]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 3):
            # Second loop, i = 3
            C_S = acc + a[1]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 4
            C_S = acc + a[2]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 5
            o[2] = acc&(internal_word_modulus)
            if(acc < 0):
                o[2] = -((o[2] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 3
        C_S = acc + a[0]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 4):
            # Second loop, i = 4
            C_S = acc + a[1]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 5
            C_S = acc + a[2]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 6
            C_S = acc + a[3]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            o[3] = acc&(internal_word_modulus)
            if(acc < 0):
                o[3] = -((o[3] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 4
        C_S = acc + a[0]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 5):
            # Second loop, i = 5
            C_S = acc + a[1]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 6
            C_S = acc + a[2]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            C_S = acc + a[3]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + a[4]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            o[4] = acc&(internal_word_modulus)
            if(acc < 0):
                o[4] = -((o[4] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 5
        C_S = acc + a[0]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 6):
            # Second loop, i = 6
            C_S = acc + a[1]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 7
            C_S = acc + a[2]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + a[3]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            C_S = acc + a[4]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 10
            C_S = acc + a[5]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[4] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 11
            o[5] = acc&(internal_word_modulus)
            if(acc < 0):
                o[5] = -((o[5] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 6
        C_S = acc + a[0]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        if(operands_size == 7):
            # Second loop, i = 7
            C_S = acc + a[1]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[1]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[2]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[1]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[0] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 8
            C_S = acc + a[2]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[2]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[3]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[2]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[1] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 9
            C_S = acc + a[3]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[3]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[4]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[3]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[2] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 10
            C_S = acc + a[4]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[4]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[5]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[4]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[3] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 11
            C_S = acc + a[5]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[5]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + a[6]*b[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[5]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[4] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 12
            C_S = acc + a[6]*b[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            C_S = acc + o[6]*prime_sharp[6]
            acc = C_S&(internal_acc_modulus)
            if(C_S < 0):
                acc = -((acc ^^ internal_acc_modulus) + 1)
            o[5] = acc&(internal_word_modulus)
            acc = acc//(internal_word_division)
            # Second loop, i = 13
            o[6] = acc&(internal_word_modulus)
            if(acc < 0):
                o[6] = -((o[6] ^^ internal_word_modulus) + 1)
            return o
        
        # First loop, i = 7
        C_S = acc + a[0]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[0]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[1]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[0]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[7] = (acc)&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 8
        C_S = acc + a[1]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[1]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[2]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[1]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[0] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 9
        C_S = acc + a[2]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[2]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[3]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[2]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[1] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 10
        C_S = acc + a[3]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[3]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[4]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[3]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[2] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 11
        C_S = acc + a[4]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[4]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[5]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[4]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[3] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 12
        C_S = acc + a[5]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[5]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[6]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[5]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[4] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        C_S = acc + a[6]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[6]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + a[7]*b[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[6]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[5] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 14
        C_S = acc + a[7]*b[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        C_S = acc + o[7]*prime_sharp[7]
        acc = C_S&(internal_acc_modulus)
        if(C_S < 0):
            acc = -((acc ^^ internal_acc_modulus) + 1)
        o[6] = acc&(internal_word_modulus)
        acc = acc//(internal_word_division)
        # Second loop, i = 13
        o[7] = acc&(internal_word_modulus)
        if(acc < 0):
            o[7] = -((o[7] ^^ internal_word_modulus) + 1)
        return o

def generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime = 0):
    arithmetic_parameters = [0]*26
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
    arithmetic_parameters[24] = 2*prime                                                                    # Prime 2*n (integer representation)
    arithmetic_parameters[25] = integer_to_list(extended_word_size, number_of_words, 2*prime)              # Prime 2*n (list representation)
    
    return arithmetic_parameters

def test_single_montgomery_multiplication(arithmetic_parameters, test_value_a, test_value_b):
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    prime = arithmetic_parameters[3]
    prime_list = arithmetic_parameters[4]
    prime_plus_one = arithmetic_parameters[5]
    prime_plus_one_list = arithmetic_parameters[6]
    prime_line = arithmetic_parameters[17]
    prime_line_zero = arithmetic_parameters[19]
    r_constant = arithmetic_parameters[10]
    r2_constant_list = arithmetic_parameters[15]
    one_constant_list = arithmetic_parameters[20]
    accumulator_word_modulus = arithmetic_parameters[23]
    
    test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
    test_value_b_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
    
    test_value_ar2_list = montgomery_multiplication(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, prime_plus_one_list, prime_line_zero, test_value_a_list, r2_constant_list)
    test_value_br2_list = montgomery_multiplication(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, prime_plus_one_list, prime_line_zero, test_value_b_list, r2_constant_list)
    test_value_or2_list = montgomery_multiplication(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, prime_plus_one_list, prime_line_zero, test_value_ar2_list, test_value_br2_list)
    test_value_o_list = montgomery_multiplication(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, prime_plus_one_list, prime_line_zero, test_value_or2_list, one_constant_list)
    test_value_o = list_to_integer(extended_word_size_signed, number_of_words, test_value_o_list)
    
    true_value_o = (test_value_a*test_value_b) % prime
    
    if(test_value_o != true_value_o):
        print("Error during the multiplication procedure with reduction")
        print("Prime")
        print(prime)
        print("Value a")
        print(test_value_a)
        print("Value b")
        print(test_value_b)
        print("Computed value")
        print(test_value_o)
        print("True value")
        print(true_value_o)
        print('')
        return True
            
    return False
    
def test_montgomery_multiplication(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    # Maximum tests
    max_value = prime
    min_value = -prime
    maximum_tests = [min_value + 1, min_value + 2, -1, 0, 1, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        for test_value_b in maximum_tests:
            error_computation = test_single_montgomery_multiplication(arithmetic_parameters, test_value_a, test_value_b)
            if(error_computation):
                break
        if(error_computation):
            break
    # Random tests
    if(not error_computation):
        for i in range(number_of_tests):
            if(((i %(10000)) == 0) and (i != 0)):
                print(i)
            test_value_a = randint(min_value + 1, max_value - 1)
            test_value_b = randint(min_value + 1, max_value - 1)
            
            error_computation = test_single_montgomery_multiplication(arithmetic_parameters, test_value_a, test_value_b)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_montgomery_multiplication_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    
    VHDL_memory_file = open(VHDL_memory_file_name, 'w')
    
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
    r2_constant_list = arithmetic_parameters[15]
    accumulator_word_modulus = arithmetic_parameters[23]
    
    tests_already_performed = 0
    
    VHDL_memory_file.write((("{0:0d}").format(number_of_tests)))
    VHDL_memory_file.write('\n')
    
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_plus_one_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_line_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime2_list, maximum_number_of_words)
    
    # Maximum tests
    max_value = prime
    min_value = -prime
    maximum_tests = [min_value + 1, min_value + 2, -1, 0, 1, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        for test_value_b in maximum_tests:
            test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
            test_value_b_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
            
            test_value_o_list = montgomery_multiplication(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, prime_plus_one_list, prime_line_zero, test_value_a_list, test_value_b_list)
            
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_b_list, maximum_number_of_words)
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)
            tests_already_performed += 1
        
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        
        test_value_a = randint(min_value+1, max_value-1)
        test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        test_value_b = randint(min_value+1, max_value-1)
        test_value_b_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
        
        test_value_o_list = montgomery_multiplication(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, prime_plus_one_list, prime_line_zero, test_value_a_list, test_value_b_list)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_b_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)

    VHDL_memory_file.close()
    
def load_VHDL_montgomery_multiplication_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
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
    r2_constant_list = arithmetic_parameters[15]
    r_inverse = arithmetic_parameters[16]
    accumulator_word_modulus = arithmetic_parameters[23]
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size_signed
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
    loaded_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime != prime):
        print("Error in multiplication with Montgomery reduction at test number : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error in multiplication with Montgomery reduction at test number : " + str(current_test))
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error in multiplication with Montgomery reduction at test number : " + str(current_test))
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_prime2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime2 != prime2):
        print("Error in multiplication with Montgomery reduction at test number : " + str(current_test))
        print("Error loading the 2*prime")
        print("Loaded 2*prime")
        print(loaded_prime2)
        print("Input 2*prime")
        print(prime2)
    
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file

    while(current_test != (number_of_tests-1)):
        loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        loaded_test_value_b = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        
        loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
        loaded_test_value_b_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_b)
        
        computed_test_value_o_list = montgomery_multiplication(extended_word_division, extended_word_modulus, accumulator_word_modulus, maximum_number_of_words, prime_list, prime_plus_one_list, prime_line_zero, loaded_test_value_a_list, loaded_test_value_b_list)
        computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in multiplication with Montgomery reduction at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("True value o")
            print(((loaded_test_value_a*loaded_test_value_b*r_inverse) % prime))
            print("Computed value o")
            print(computed_test_value_o)
        current_test += 1
    
    loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    loaded_test_value_b = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    
    loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
    loaded_test_value_b_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_b)
    
    computed_test_value_o_list = montgomery_multiplication(extended_word_division, extended_word_modulus, accumulator_word_modulus, maximum_number_of_words, prime_list, prime_plus_one_list, prime_line_zero, loaded_test_value_a_list, loaded_test_value_b_list, debug_mode)
    computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
    
    if(debug_mode or (computed_test_value_o != loaded_test_value_o)):
        print("Error in multiplication with Montgomery reduction at test number : " + str(current_test))
        print("Loaded value a")
        print(loaded_test_value_a)
        print("Loaded value b")
        print(loaded_test_value_b)
        print("Loaded value o")
        print(loaded_test_value_o)
        print("True value o")
        print(((loaded_test_value_a*loaded_test_value_b*r_inverse) % prime))
        print("Computed value o")
        print(computed_test_value_o)
    
    VHDL_memory_file.close()
    
def test_single_montgomery_squaring(arithmetic_parameters, test_value_a):
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    prime = arithmetic_parameters[3]
    prime_list = arithmetic_parameters[4]
    prime_plus_one = arithmetic_parameters[5]
    prime_plus_one_list = arithmetic_parameters[6]
    prime_line = arithmetic_parameters[17]
    prime_line_zero = arithmetic_parameters[19]
    r_constant = arithmetic_parameters[10]
    r2_constant_list = arithmetic_parameters[15]
    one_constant_list = arithmetic_parameters[20]
    accumulator_word_modulus = arithmetic_parameters[23]
    
    test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
    
    test_value_ar2_list = montgomery_multiplication(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, prime_plus_one_list, prime_line_zero, test_value_a_list, r2_constant_list)
    test_value_or2_list = montgomery_squaring(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, prime_plus_one_list, prime_line_zero, test_value_ar2_list)
    test_value_o_list = montgomery_multiplication(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, prime_plus_one_list, prime_line_zero, test_value_or2_list, one_constant_list)
    test_value_o = list_to_integer(extended_word_size_signed, number_of_words, test_value_o_list)
    
    true_value_o = (test_value_a*test_value_a) % prime
    
    if(test_value_o != true_value_o):
        print("Error during the squaring procedure with reduction")
        print("Prime")
        print(prime)
        print("Value a")
        print(test_value_a)
        print("Computed value")
        print(test_value_o)
        print("True value")
        print(true_value_o)
        print('')
        return True
            
    return False
    
def test_montgomery_squaring(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    # Maximum tests
    max_value = prime
    min_value = -prime
    maximum_tests = [min_value + 1, min_value + 2, -1, 0, 1, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        error_computation = test_single_montgomery_squaring(arithmetic_parameters, test_value_a)
        if(error_computation):
            break
    # Random tests
    if(not error_computation):
        for i in range(number_of_tests):
            if(((i %(10000)) == 0) and (i != 0)):
                print(i)
            test_value_a = randint(min_value+1, max_value-1)
            
            error_computation = test_single_montgomery_squaring(arithmetic_parameters, test_value_a)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_montgomery_squaring_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    
    VHDL_memory_file = open(VHDL_memory_file_name, 'w')
    
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
    r2_constant_list = arithmetic_parameters[15]
    accumulator_word_modulus = arithmetic_parameters[23]
    
    tests_already_performed = 0
    
    VHDL_memory_file.write((("{0:0d}").format(number_of_tests)))
    VHDL_memory_file.write('\n')
    
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_plus_one_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_line_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime2_list, maximum_number_of_words)
        
    # Maximum tests
    max_value = prime
    min_value = -prime
    maximum_tests = [min_value + 1, min_value + 2, -1, 0, 1, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        
        test_value_o_list = montgomery_squaring(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, prime_plus_one_list, prime_line_zero, test_value_a_list)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)
        tests_already_performed += 1
    
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        test_value_a = randint(min_value+1, max_value-1)
        test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        
        test_value_o_list = montgomery_squaring(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, prime_plus_one_list, prime_line_zero, test_value_a_list)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)

    VHDL_memory_file.close()
    
def load_VHDL_montgomery_squaring_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
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
    r2_constant_list = arithmetic_parameters[15]
    r_inverse = arithmetic_parameters[16]
    accumulator_word_modulus = arithmetic_parameters[23]
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size_signed
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
    loaded_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime != prime):
        print("Error in squaring with Montgomery reduction at test number : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error in squaring with Montgomery reduction at test number : " + str(current_test))
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error in squaring with Montgomery reduction at test number : " + str(current_test))
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_prime2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime2 != prime2):
        print("Error loading the prime")
        print("Loaded 2*prime")
        print(loaded_prime2)
        print("Input prime")
        print(prime2)
        
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
        
    while(current_test != (number_of_tests-1)):
        loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        
        loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
        
        computed_test_value_o_list = montgomery_squaring(extended_word_division, extended_word_modulus, accumulator_word_modulus, maximum_number_of_words, prime_list, prime_plus_one_list, prime_line_zero, loaded_test_value_a_list)
        computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in squaring with Montgomery reduction at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("True value o")
            print(((loaded_test_value_a*loaded_test_value_a*r_inverse) % prime))
            print("Computed value o")
            print(computed_test_value_o)
        current_test += 1
        
    loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    
    loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
    
    computed_test_value_o_list = montgomery_squaring(extended_word_division, extended_word_modulus, accumulator_word_modulus, maximum_number_of_words, prime_list, prime_plus_one_list, prime_line_zero, loaded_test_value_a_list, debug_mode)
    computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
    
    if(computed_test_value_o != loaded_test_value_o):
        print("Error in squaring with Montgomery reduction at test number : " + str(current_test))
        print("Loaded value a")
        print(loaded_test_value_a)
        print("Loaded value o")
        print(loaded_test_value_o)
        print("True value o")
        print(((loaded_test_value_a*loaded_test_value_a*r_inverse) % prime))
        print("Computed value o")
        print(computed_test_value_o)
        
    VHDL_memory_file.close()

def test_single_multiplication_no_reduction(arithmetic_parameters, test_value_a, test_value_b):
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    accumulator_word_modulus = arithmetic_parameters[23]
    
    test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
    test_value_b_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
    test_value_o_list = multiplication_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_a_list, test_value_b_list, debug=False)
    test_value_o = list_to_integer(extended_word_size_signed, 2*number_of_words, test_value_o_list)
    
    true_value_o = (test_value_a*test_value_b)
    
    if(test_value_o != true_value_o):
        print("Error during the multiplication procedure with no reduction")
        print("Prime")
        print(prime)
        print("Value a")
        print(test_value_a)
        print("Value b")
        print(test_value_b)
        print("Computed value")
        print(test_value_o)
        print("True value")
        print(true_value_o)
        print('')
        return True
            
    return False
    
def test_multiplication_no_reduction(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
    
    # Maximum tests
    max_value = prime
    min_value = -prime
    maximum_tests = [min_value + 1, min_value + 2, -1, 0, 1, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        for test_value_b in maximum_tests:
            error_computation = test_single_multiplication_no_reduction(arithmetic_parameters, test_value_a, test_value_b)
            if(error_computation):
                break
        if(error_computation):
            break
    # Random tests
    if(not error_computation):
        for i in range(number_of_tests):
            if(((i %(10000)) == 0) and (i != 0)):
                print(i)
            test_value_a = randint(min_value+1, max_value-1)
            test_value_b = randint(min_value+1, max_value-1)
            
            error_computation = test_single_multiplication_no_reduction(arithmetic_parameters, test_value_a, test_value_b)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_multiplication_no_reduction_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    
    VHDL_memory_file = open(VHDL_memory_file_name, 'w')
    
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    base_word_size_signed = arithmetic_parameters[1]
    base_word_size_signed_number_words = (((extended_word_size_signed) + ((base_word_size_signed)-1))//(base_word_size_signed))
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    prime = arithmetic_parameters[3]
    accumulator_word_modulus = arithmetic_parameters[23]
    
    tests_already_performed = 0
    
    VHDL_memory_file.write((("{0:0d}").format(number_of_tests)))
    VHDL_memory_file.write('\n')
    
    # Maximum tests
    max_value = prime
    min_value = -prime
    maximum_tests = [min_value + 1, min_value + 2, -1, 0, 1, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        for test_value_b in maximum_tests:
            test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
            test_value_b_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
            
            test_value_o_list = multiplication_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_a_list, test_value_b_list)
            
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_b_list, maximum_number_of_words)
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, 2*maximum_number_of_words)
            tests_already_performed += 1
            
            
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        
        test_value_a = randint(min_value+1, max_value-1)
        test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        test_value_b = randint(min_value+1, max_value-1)
        test_value_b_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
        
        test_value_o_list = multiplication_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_a_list, test_value_b_list)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_b_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, 2*maximum_number_of_words)

    VHDL_memory_file.close()
    
def load_VHDL_multiplication_no_reduction_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode = False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    base_word_size_signed = arithmetic_parameters[1]
    base_word_size_signed_number_words = (((extended_word_size_signed) + ((base_word_size_signed)-1))//(base_word_size_signed))
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    accumulator_word_modulus = arithmetic_parameters[23]
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size_signed
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
        
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    while(current_test != (number_of_tests-1)):
        loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        loaded_test_value_b = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, 2*maximum_number_of_words, True)
        
        loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
        loaded_test_value_b_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_b)
        
        computed_test_value_o_list = multiplication_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, maximum_number_of_words, loaded_test_value_a_list, loaded_test_value_b_list)
        computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in computation at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("True value o")
            print(loaded_test_value_a*loaded_test_value_b)
            print("Computed value o")
            print(computed_test_value_o)
        current_test += 1

    loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    loaded_test_value_b = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, 2*maximum_number_of_words, True)
    
    loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
    loaded_test_value_b_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_b)
    
    computed_test_value_o_list = multiplication_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, maximum_number_of_words, loaded_test_value_a_list, loaded_test_value_b_list, debug_mode)
    computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
    
    if(computed_test_value_o != loaded_test_value_o):
        print("Error in multiplication with no reduction at test number : " + str(current_test))
        print("Loaded value a")
        print(loaded_test_value_a)
        print("Loaded value b")
        print(loaded_test_value_b)
        print("Loaded value o")
        print(loaded_test_value_o)
        print("True value o")
        print(loaded_test_value_a*loaded_test_value_b)
        print("Computed value o")
        print(computed_test_value_o)
        
    VHDL_memory_file.close()
    
def test_single_square_no_reduction(arithmetic_parameters, test_value_a):
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    accumulator_word_modulus = arithmetic_parameters[23]
    
    test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
    test_value_o_list = square_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_a_list, debug=False)
    test_value_o = list_to_integer(extended_word_size_signed, 2*number_of_words, test_value_o_list)
    
    true_value_o = (test_value_a*test_value_a)
    
    if(test_value_o != true_value_o):
        print("Value a")
        print(test_value_a)
        print("Computed square")
        print(test_value_o)
        print("True square")
        print(true_value_o)
        print('')
        print('')
        return True
            
    return False
    
def test_square_no_reduction(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    # Maximum tests
    error_computation = False
    max_value = prime
    min_value = -prime
    maximum_tests = [min_value + 1, min_value + 2, -1, 0, 1, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        error_computation = test_single_square_no_reduction(arithmetic_parameters, test_value_a)
        if(error_computation):
            break
    # Random tests
    if(not error_computation):
        for i in range(number_of_tests):
            if(((i %(10000)) == 0) and (i != 0)):
                print(i)
            test_value_a = randint(min_value+1, max_value-1)
            
            error_computation = test_single_square_no_reduction(arithmetic_parameters, test_value_a)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_square_no_reduction_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    
    VHDL_memory_file = open(VHDL_memory_file_name, 'w')
    
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    base_word_size_signed = arithmetic_parameters[1]
    base_word_size_signed_number_words = (((extended_word_size_signed) + ((base_word_size_signed)-1))//(base_word_size_signed))
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    prime = arithmetic_parameters[3]
    accumulator_word_modulus = arithmetic_parameters[23]
    
    tests_already_performed = 0
    
    VHDL_memory_file.write((("{0:0d}").format(number_of_tests)))
    VHDL_memory_file.write('\n')
    
    # Maximum tests
    max_value = prime
    min_value = -prime
    maximum_tests = [min_value + 1, min_value + 2, -1, 0, 1, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        
        test_value_o_list = square_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_a_list)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, 2*maximum_number_of_words)
        tests_already_performed += 1
        
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        
        test_value_a = randint(min_value+1, max_value-1)
        test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        
        test_value_o_list = square_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_a_list)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, 2*maximum_number_of_words)

    VHDL_memory_file.close()
    
def load_VHDL_square_no_reduction_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    base_word_size_signed = arithmetic_parameters[1]
    base_word_size_signed_number_words = (((extended_word_size_signed) + ((base_word_size_signed)-1))//(base_word_size_signed))
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    accumulator_word_modulus = arithmetic_parameters[23]
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size_signed
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
        
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    while(current_test != (number_of_tests-1)):
        loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, 2*maximum_number_of_words, True)
        
        loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
        
        computed_test_value_o_list = square_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, maximum_number_of_words, loaded_test_value_a_list)
        computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in computation at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("True value o")
            print(loaded_test_value_a*loaded_test_value_a)
            print("Computed value o")
            print(computed_test_value_o)
        current_test += 1
    
    loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, 2*maximum_number_of_words, True)
    
    loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
    
    computed_test_value_o_list = square_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, maximum_number_of_words, loaded_test_value_a_list, debug_mode)
    computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
    
    if(computed_test_value_o != loaded_test_value_o):
        print("Error in squaring with no reduction at test number : " + str(current_test))
        print("Loaded value a")
        print(loaded_test_value_a)
        print("Loaded value o")
        print(loaded_test_value_o)
        print("True value o")
        print(loaded_test_value_a*loaded_test_value_a)
        print("Computed value o")
        print(computed_test_value_o)
        
    VHDL_memory_file.close()

def test_single_addition_subtraction_no_reduction(arithmetic_parameters, test_value_a, test_value_b):
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    accumulator_word_modulus = arithmetic_parameters[23]
    
    test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
    test_value_b_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
    
    test_value_o1_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_a_list, test_value_b_list, 1)
    test_value_o1 = list_to_integer(extended_word_size_signed, number_of_words, test_value_o1_list)
    test_value_o2_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_a_list, test_value_b_list, 0)
    test_value_o2 = list_to_integer(extended_word_size_signed, number_of_words, test_value_o2_list)
    test_value_o3_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_b_list, test_value_a_list, 0)
    test_value_o3 = list_to_integer(extended_word_size_signed, number_of_words, test_value_o3_list)
    
    true_value_o1 = (test_value_a+test_value_b)
    true_value_o2 = (test_value_b-test_value_a)
    true_value_o3 = (test_value_a-test_value_b)
    
    if((test_value_o1 != true_value_o1) or (test_value_o2 != true_value_o2) or (test_value_o3 != true_value_o3)):
        print("Error during the addition procedure with no reduction")
        print("Value a")
        print(test_value_a)
        print("Value b")
        print(test_value_b)
        print("Computed value o1")
        print(test_value_o1)
        print("True value o1")
        print(true_value_o1)
        print('')
        print("Computed value o2")
        print(test_value_o2)
        print("True value o2")
        print(true_value_o2)
        print('')
        print("Computed value o3")
        print(test_value_o3)
        print("True value o3")
        print(true_value_o3)
        print('')
        print('')
        return True
            
    return False
    
def test_addition_subtraction_no_reduction(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    # Maximum tests
    max_value = prime
    min_value = -prime
    maximum_tests = [min_value + 1, min_value + 2, -1, 0, 1, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        for test_value_b in maximum_tests:
            error_computation = test_single_addition_subtraction_no_reduction(arithmetic_parameters, test_value_a, test_value_b)
            if(error_computation):
                break
        if(error_computation):
            break
    # Random tests
    if(not error_computation):
        for i in range(number_of_tests):
            if(((i %(10000)) == 0) and (i != 0)):
                print(i)
            test_value_a = randint(min_value+1, max_value-1)
            test_value_b = randint(min_value+1, max_value-1)
            
            error_computation = test_single_addition_subtraction_no_reduction(arithmetic_parameters, test_value_a, test_value_b)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_addition_subtraction_no_reduction_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    
    VHDL_memory_file = open(VHDL_memory_file_name, 'w')
    
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    base_word_size_signed = arithmetic_parameters[1]
    base_word_size_signed_number_words = (((extended_word_size_signed) + ((base_word_size_signed)-1))//(base_word_size_signed))
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    accumulator_word_modulus = arithmetic_parameters[23]
    
    tests_already_performed = 0
    
    VHDL_memory_file.write((("{0:0d}").format(number_of_tests)))
    VHDL_memory_file.write('\n')
        
    # Maximum tests
    max_value = prime
    min_value = -prime
    maximum_tests = [min_value + 1, min_value + 2, -1, 0, 1, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        for test_value_b in maximum_tests:
            test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
            test_value_b_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
            
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_b_list, maximum_number_of_words)
            
            test_value_o_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_a_list, test_value_b_list, 1)
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)
    
            test_value_o_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_a_list, test_value_b_list, 0)
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)
    
            test_value_o_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_b_list, test_value_a_list, 0)
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)
            
            tests_already_performed += 1
    
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        
        test_value_a = randint(min_value+1, max_value-1)
        test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        test_value_b = randint(min_value+1, max_value-1)
        test_value_b_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_b_list, maximum_number_of_words)
        
        test_value_o_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_a_list, test_value_b_list, 1)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)

        test_value_o_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_a_list, test_value_b_list, 0)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)

        test_value_o_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, test_value_b_list, test_value_a_list, 0)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)
        
    VHDL_memory_file.close()
    
def load_VHDL_addition_subtraction_no_reduction_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    base_word_size_signed = arithmetic_parameters[1]
    base_word_size_signed_number_words = (((extended_word_size_signed) + ((base_word_size_signed)-1))//(base_word_size_signed))
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    accumulator_word_modulus = arithmetic_parameters[23]
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size_signed
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
        
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    while(current_test != (number_of_tests-1)):
        loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        loaded_test_value_b = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        
        loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
        loaded_test_value_b_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_b)

        loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        computed_test_value_o_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, loaded_test_value_a_list, loaded_test_value_b_list, 1)
        computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in addition with no reduction at test number : " + str(current_test) + " at part 0")
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("True value o")
            print(loaded_test_value_a + loaded_test_value_b)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        computed_test_value_o_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, loaded_test_value_a_list, loaded_test_value_b_list, 0)
        computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in subtraction with no reduction at test number : " + str(current_test) + " at part 1")
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("True value o")
            print(loaded_test_value_b - loaded_test_value_a)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        computed_test_value_o_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, loaded_test_value_b_list, loaded_test_value_a_list, 0)
        computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in subtraction with no reduction at test number : " + str(current_test) + " at part 2")
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("True value o")
            print(loaded_test_value_a - loaded_test_value_b)
            print("Computed value o")
            print(computed_test_value_o)
        current_test += 1
        
    loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    loaded_test_value_b = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    
    loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
    loaded_test_value_b_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_b)

    loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    computed_test_value_o_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, loaded_test_value_a_list, loaded_test_value_b_list, 1, debug_mode)
    computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
    
    if(computed_test_value_o != loaded_test_value_o):
        print("Error in addition with no reduction at test number : " + str(current_test) + " at part 0")
        print("Loaded value a")
        print(loaded_test_value_a)
        print("Loaded value b")
        print(loaded_test_value_b)
        print("Loaded value o")
        print(loaded_test_value_o)
        print("True value o")
        print(loaded_test_value_a + loaded_test_value_b)
        print("Computed value o")
        print(computed_test_value_o)
    
    loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    computed_test_value_o_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, loaded_test_value_a_list, loaded_test_value_b_list, 0, debug_mode)
    computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
    
    if(computed_test_value_o != loaded_test_value_o):
        print("Error in subtraction with no reduction at test number : " + str(current_test) + " at part 1")
        print("Loaded value a")
        print(loaded_test_value_a)
        print("Loaded value b")
        print(loaded_test_value_b)
        print("Loaded value o")
        print(loaded_test_value_o)
        print("True value o")
        print(loaded_test_value_b - loaded_test_value_a)
        print("Computed value o")
        print(computed_test_value_o)
    
    loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    computed_test_value_o_list = addition_subtraction_no_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, loaded_test_value_b_list, loaded_test_value_a_list, 0, debug_mode)
    computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
    
    if(computed_test_value_o != loaded_test_value_o):
        print("Error in subtraction with no reduction at test number : " + str(current_test) + " at part 2")
        print("Loaded value a")
        print(loaded_test_value_a)
        print("Loaded value b")
        print(loaded_test_value_b)
        print("Loaded value o")
        print(loaded_test_value_o)
        print("True value o")
        print(loaded_test_value_a - loaded_test_value_b)
        print("Computed value o")
        print(computed_test_value_o)
    
    VHDL_memory_file.close()
    
def test_single_addition_subtraction_with_reduction(arithmetic_parameters, test_value_a, test_value_b):
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    accumulator_word_modulus = arithmetic_parameters[23]
    prime2 = arithmetic_parameters[24]
    prime2_list = arithmetic_parameters[25]
    
    test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
    test_value_b_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
    
    test_value_o1_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, test_value_a_list, test_value_b_list, 1)
    test_value_o1 = list_to_integer(extended_word_size_signed, number_of_words, test_value_o1_list)
    test_value_o2_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, test_value_a_list, test_value_b_list, 0)
    test_value_o2 = list_to_integer(extended_word_size_signed, number_of_words, test_value_o2_list)
    test_value_o3_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, test_value_b_list, test_value_a_list, 0)
    test_value_o3 = list_to_integer(extended_word_size_signed, number_of_words, test_value_o3_list)
    
    true_value_o1 = (test_value_a+test_value_b) % prime2
    true_value_o2 = (test_value_b-test_value_a) % prime2
    true_value_o3 = (test_value_a-test_value_b) % prime2
    
    if((test_value_o1 != true_value_o1) or (test_value_o2 != true_value_o2) or (test_value_o3 != true_value_o3)):
        print("Error during the addition/subtraction procedure with reduction")
        print("2*Prime")
        print(prime2)
        print("Value a")
        print(test_value_a)
        print("Value b")
        print(test_value_b)
        print("Computed value o1 = a+b")
        print(test_value_o1)
        print("True value o1")
        print(true_value_o1)
        print('')
        print("Computed value o2 = b-a")
        print(test_value_o2)
        print("True value o2")
        print(true_value_o2)
        print('')
        print("Computed value o3 = a-b")
        print(test_value_o3)
        print("True value o3")
        print(true_value_o3)
        print('')
        print('')
        return True
            
    return False
    
def test_addition_subtraction_with_reduction(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    # Maximum tests
    max_value = 2*prime
    min_value = -2*prime
    maximum_tests = [min_value + 1, min_value + 2, -1, 0, 1, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        for test_value_b in maximum_tests:
            error_computation = test_single_addition_subtraction_with_reduction(arithmetic_parameters, test_value_a, test_value_b)
            if(error_computation):
                break
        if(error_computation):
            break
    # Random tests
    if(not error_computation):
        for i in range(number_of_tests):
            if(((i %(10000)) == 0) and (i != 0)):
                print(i)
            test_value_a = randint(min_value+1, max_value-1)
            test_value_b = randint(min_value+1, max_value-1)
            
            error_computation = test_single_addition_subtraction_with_reduction(arithmetic_parameters, test_value_a, test_value_b)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_addition_subtraction_with_reduction_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    
    VHDL_memory_file = open(VHDL_memory_file_name, 'w')
    
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    base_word_size_signed = arithmetic_parameters[1]
    base_word_size_signed_number_words = (((extended_word_size_signed) + ((base_word_size_signed)-1))//(base_word_size_signed))
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    accumulator_word_modulus = arithmetic_parameters[23]
    prime = arithmetic_parameters[3]
    prime_list = arithmetic_parameters[4]
    prime_plus_one = arithmetic_parameters[5]
    prime_plus_one_list = arithmetic_parameters[6]
    prime_line = arithmetic_parameters[17]
    prime_line_list = arithmetic_parameters[18]
    prime_line_zero = arithmetic_parameters[19]
    prime2 = arithmetic_parameters[24]
    prime2_list = arithmetic_parameters[25]
    
    tests_already_performed = 0
    
    VHDL_memory_file.write((("{0:0d}").format(number_of_tests)))
    VHDL_memory_file.write('\n')

    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_plus_one_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_line_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime2_list, maximum_number_of_words)
    
    # Maximum tests
    max_value = 2*prime
    min_value = -2*prime
    maximum_tests = [min_value + 1, min_value + 2, -1, 0, 1, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        for test_value_b in maximum_tests:
            test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
            test_value_b_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
            
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_b_list, maximum_number_of_words)
            
            test_value_o_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, test_value_a_list, test_value_b_list, 1)
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)
    
            test_value_o_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, test_value_a_list, test_value_b_list, 0)
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)
    
            test_value_o_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, test_value_b_list, test_value_a_list, 0)
            print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)
            
            tests_already_performed += 1
    
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        
        test_value_a = randint(min_value+1, max_value-1)
        test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        test_value_b = randint(min_value+1, max_value-1)
        test_value_b_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_b)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_b_list, maximum_number_of_words)
        
        test_value_o_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, test_value_a_list, test_value_b_list, 1)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)

        test_value_o_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, test_value_a_list, test_value_b_list, 0)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)

        test_value_o_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, test_value_b_list, test_value_a_list, 0)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)
        
    VHDL_memory_file.close()
    
def load_VHDL_addition_subtraction_with_reduction_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    base_word_size_signed = arithmetic_parameters[1]
    base_word_size_signed_number_words = (((extended_word_size_signed) + ((base_word_size_signed)-1))//(base_word_size_signed))
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    accumulator_word_modulus = arithmetic_parameters[23]
    prime = arithmetic_parameters[3]
    prime_list = arithmetic_parameters[4]
    prime_plus_one = arithmetic_parameters[5]
    prime_plus_one_list = arithmetic_parameters[6]
    prime_line = arithmetic_parameters[17]
    prime_line_list = arithmetic_parameters[18]
    prime_line_zero = arithmetic_parameters[19]
    prime2 = arithmetic_parameters[24]
    prime2_list = arithmetic_parameters[25]
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size_signed
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())

    loaded_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime != prime):
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_prime2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime2 != prime2):
        print("Error loading the prime")
        print("Loaded 2*prime")
        print(loaded_prime2)
        print("Input prime")
        print(prime2)
    
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    while(current_test != (number_of_tests-1)):
        loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        loaded_test_value_b = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        
        loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
        loaded_test_value_b_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_b)

        loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        computed_test_value_o_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, loaded_test_value_a_list, loaded_test_value_b_list, 1)
        computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in addition with reduction at test number : " + str(current_test) + " at part 0")
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("True value o")
            print(loaded_test_value_a + loaded_test_value_b)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        computed_test_value_o_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, loaded_test_value_a_list, loaded_test_value_b_list, 0)
        computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in subtraction with reduction at test number : " + str(current_test) + " at part 1")
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("True value o")
            print(loaded_test_value_b - loaded_test_value_a)
            print("Computed value o")
            print(computed_test_value_o)
        
        loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        computed_test_value_o_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, loaded_test_value_b_list, loaded_test_value_a_list, 0)
        computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error in subtraction with reduction at test number : " + str(current_test) + " at part 2")
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value b")
            print(loaded_test_value_b)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("True value o")
            print(loaded_test_value_a - loaded_test_value_b)
            print("Computed value o")
            print(computed_test_value_o)
        current_test += 1
        
    loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    loaded_test_value_b = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    
    loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
    loaded_test_value_b_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_b)

    loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    computed_test_value_o_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, loaded_test_value_a_list, loaded_test_value_b_list, 1, debug_mode)
    computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
    
    if(computed_test_value_o != loaded_test_value_o):
        print("Error in addition with reduction at test number : " + str(current_test) + " at part 0")
        print("Loaded value a")
        print(loaded_test_value_a)
        print("Loaded value b")
        print(loaded_test_value_b)
        print("Loaded value o")
        print(loaded_test_value_o)
        print("True value o")
        print(loaded_test_value_a + loaded_test_value_b)
        print("Computed value o")
        print(computed_test_value_o)
    
    loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    computed_test_value_o_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, loaded_test_value_a_list, loaded_test_value_b_list, 0, debug_mode)
    computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
    
    if(computed_test_value_o != loaded_test_value_o):
        print("Error in subtraction with reduction at test number : " + str(current_test) + " at part 1")
        print("Loaded value a")
        print(loaded_test_value_a)
        print("Loaded value b")
        print(loaded_test_value_b)
        print("Loaded value o")
        print(loaded_test_value_o)
        print("True value o")
        print(loaded_test_value_b - loaded_test_value_a)
        print("Computed value o")
        print(computed_test_value_o)
    
    loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    computed_test_value_o_list = addition_subtraction_with_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime2_list, loaded_test_value_b_list, loaded_test_value_a_list, 0, debug_mode)
    computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
    
    if(computed_test_value_o != loaded_test_value_o):
        print("Error in subtraction with reduction at test number : " + str(current_test) + " at part 2")
        print("Loaded value a")
        print(loaded_test_value_a)
        print("Loaded value b")
        print(loaded_test_value_b)
        print("Loaded value o")
        print(loaded_test_value_o)
        print("True value o")
        print(loaded_test_value_a - loaded_test_value_b)
        print("Computed value o")
        print(computed_test_value_o)
    
    VHDL_memory_file.close()
    
def test_single_iterative_modular_reduction(arithmetic_parameters, test_value_a):
    extended_word_size_signed = arithmetic_parameters[0]
    extended_word_division = arithmetic_parameters[21]
    extended_word_modulus = arithmetic_parameters[22]
    number_of_words = arithmetic_parameters[9]
    maximum_number_of_words = number_of_words
    prime = arithmetic_parameters[3]
    prime_list = arithmetic_parameters[4]
    accumulator_word_modulus = arithmetic_parameters[23]
    
    test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
    
    test_value_o1_list = iterative_modular_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, test_value_a_list)
    test_value_o1 = list_to_integer(extended_word_size_signed, number_of_words, test_value_o1_list)
    
    true_value_o1 = (test_value_a) % prime
    
    if((test_value_o1 != true_value_o1)):
        print("Error during the iterative modular reduction procedure")
        print("Value a")
        print(test_value_a)
        print("Computed value o1")
        print(test_value_o1)
        print("True value o1")
        print(true_value_o1)
        print('')
        return True
            
    return False
    
def test_iterative_modular_reduction(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    arithmetic_parameters = generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    error_computation = False
        
    # Maximum tests
    max_value = 2*prime
    min_value = -2*prime
    maximum_tests = [min_value + 1, min_value + 2, -prime, -1, 0, 1, prime, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        error_computation = test_single_iterative_modular_reduction(arithmetic_parameters, test_value_a)
        if(error_computation):
            break
    # Random tests
    if(not error_computation):
        for i in range(number_of_tests):
            if(((i %(10000)) == 0) and (i != 0)):
                print(i)
            test_value_a = randint(min_value+1, max_value-1)
            
            error_computation = test_single_iterative_modular_reduction(arithmetic_parameters, test_value_a)
            if(error_computation):
                break
        
    return error_computation

def print_VHDL_iterative_modular_reduction_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests):
    
    VHDL_memory_file = open(VHDL_memory_file_name, 'w')
    
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
    r2_constant_list = arithmetic_parameters[15]
    accumulator_word_modulus = arithmetic_parameters[23]
    
    tests_already_performed = 0
    
    VHDL_memory_file.write((("{0:0d}").format(number_of_tests)))
    VHDL_memory_file.write('\n')
    
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_plus_one_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime_line_list, maximum_number_of_words)
    print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, prime2_list, maximum_number_of_words)
    
    # Maximum tests
    max_value = 2*prime
    min_value = -2*prime
    maximum_tests = [min_value + 1, min_value + 2, -prime, -1, 0, 1, prime, max_value - 2, max_value - 1]
    for test_value_a in maximum_tests:
        test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        
        test_value_o_list = iterative_modular_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, test_value_a_list)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)
        
        tests_already_performed += 1
            
    # Random tests
    for i in range(tests_already_performed, number_of_tests):
        
        test_value_a = randint(min_value+1, max_value-1)
        test_value_a_list = integer_to_list(extended_word_size_signed, number_of_words, test_value_a)
        
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_a_list, maximum_number_of_words)
        
        test_value_o_list = iterative_modular_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, test_value_a_list)
        print_list_convert_format_VHDL_MAC_memory(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, extended_word_size_signed, test_value_o_list, maximum_number_of_words)
        
    VHDL_memory_file.close()
    
def load_VHDL_iterative_modular_reduction_test(VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_tests = 0, debug_mode=False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
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
    r2_constant_list = arithmetic_parameters[15]
    accumulator_word_modulus = arithmetic_parameters[23]
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size_signed
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
    loaded_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime != prime):
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_plus_one != prime_plus_one):
        print("Error loading the prime plus one")
        print("Loaded prime plus one")
        print(loaded_prime_plus_one)
        print("Input prime plus one")
        print(prime_plus_one)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime_line != prime_line):
        print("Error loading the prime line 0")
        print("Loaded prime line 0")
        print(loaded_prime_line)
        print("Input prime line 0")
        print(prime_line)
    loaded_prime2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime2 != prime2):
        print("Error loading the prime")
        print("Loaded 2*prime")
        print(loaded_prime2)
        print("Input prime")
        print(prime2)
    
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    while(current_test != (number_of_tests-1)):
        loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
        
        loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
        
        computed_test_value_o_list = iterative_modular_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, loaded_test_value_a_list)
        computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
        
        if(computed_test_value_o != loaded_test_value_o):
            print("Error during the iterative modular reduction procedure at test number : " + str(current_test))
            print("Loaded value a")
            print(loaded_test_value_a)
            print("Loaded value o")
            print(loaded_test_value_o)
            print("True value o")
            print((loaded_test_value_a) % prime)
            print("Computed value o")
            print(computed_test_value_o)
        
        current_test += 1
        
    loaded_test_value_a = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    loaded_test_value_o = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size_signed, base_word_size_signed_number_words, maximum_number_of_words, True)
    
    loaded_test_value_a_list = integer_to_list(extended_word_size_signed, maximum_number_of_words, loaded_test_value_a)
    
    computed_test_value_o_list = iterative_modular_reduction(extended_word_division, extended_word_modulus, accumulator_word_modulus, number_of_words, prime_list, loaded_test_value_a_list)
    computed_test_value_o = list_to_integer(extended_word_size_signed, len(computed_test_value_o_list), computed_test_value_o_list)
    
    if((computed_test_value_o != loaded_test_value_o) or debug_mode):
        print("Error during the iterative modular reduction procedure at test number : " + str(current_test))
        print("Loaded value a")
        print(loaded_test_value_a)
        print("Loaded value o")
        print(loaded_test_value_o)
        print("True value o")
        print((loaded_test_value_a) % prime)
        print("Computed value o")
        print(computed_test_value_o)
        
    VHDL_memory_file.close()
    
    
def test_all_operations(number_of_random_tests=100000):
    number_of_bits_added = 3
    base_word_size_signed = 16
    extended_word_size_signed = 128
    accumulator_word_size = (extended_word_size_signed)*2+32
    primes = [2^(128)*2503155504993241601315571986085827 - 1, 2^(128)*369988485035126972924700782451696644186473100389722973815184405301748242 - 1, 2^(128)*54687564869829362182513248937549525219772952158835913478965817740815987158012171902102365647884201078947650423 - 1, 2^(128)*8083304946930585013911810590884932969503714762980550286204433743937610914334142973787308373287276300034802855732870950234095113357081569792347792290 - 1, 2^(128)*1194783842005001366872669673930715104684379915202413516958309593884097707862672257897327618239887790786549346048626664496721871548575328400043101228717425477619608889629973635327326175179 - 1, 2^(128)*176599601089934078359548270864285863603827251393046775434920390764769898521366084669687132105709979857873800115716040400421172212786462009325232075541447482362180166602559904626487994750416695920834514229486516405288106797329 - 1, 2^(128)*26102980312143604580379781426139335779091260301758026221495303393196039344305009624874488017227324790317412920525253886011853217074287636537729904547128731845728160914486066244742089352609334182138245049106257642108402738856230144495829015803277090696341313660203 - 1, 2^(256)*42391158275216203514294433068 - 1, 2^(256)*369988485035126972924700782451696644186473100389722973815184405301747940 - 1, 2^(256)*5468756486982936218251324893754952521977295215883591347896581774081598715801217190210236564788420107894765046 - 1, 2^(256)*8083304946930585013911810590884932969503714762980550286204433743937610914334142973787308373287276300034802855732870950234095113357081569792347792715 - 1, 2^(256)*1194783842005001366872669673930715104684379915202413516958309593884097707862672257897327618239887790786549346048626664496721871548575328400043101228717425477619608889629973635327326175170 - 1, 2^(256)*176599601089934078359548270864285863603827251393046775434920390764769898521366084669687132105709979857873800115716040400421172212786462009325232075541447482362180166602559904626487994750416695920834514229486516405288106797569 - 1, 2^(384)*2503155504993241601315571986085684 - 1, 2^(384)*369988485035126972924700782451696644186473100389722973815184405301747903 - 1, 2^(384)*54687564869829362182513248937549525219772952158835913478965817740815987158012171902102365647884201078947650478 - 1, 2^(384)*8083304946930585013911810590884932969503714762980550286204433743937610914334142973787308373287276300034802855732870950234095113357081569792347792989 - 1, 2^(384)*1194783842005001366872669673930715104684379915202413516958309593884097707862672257897327618239887790786549346048626664496721871548575328400043101228717425477619608889629973635327326175125 - 1, 3^(63)+2, 3^(139)+2, 3^(235)+2, 3^(315)+2, 3^(391)+2, 3^(480)+326, 3^(562)+4, 3^(637)+286, 2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1,  2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
    start_test = 0
    end_test = len(primes)
    for i in range(start_test,end_test):
        prime = primes[i]
        print("Testing prime: " + str(prime))
        prime_size_bits = int(prime).bit_length()
        arithmetic_parameters = generate_arithmetic_parameters(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print("Number of bits: " + str(arithmetic_parameters[8]))
        print("Number of words: " + str(arithmetic_parameters[9]))
        print("Testing Montgomery multiplication")
        error = test_montgomery_multiplication(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
        print("Done")
        if(not error):
            print("Testing Montgomery squaring")
            error = test_montgomery_squaring(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
            print("Done")
        if(not error):
            print("Testing multiplication no reduction")
            error = test_multiplication_no_reduction(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
            print("Done")
        if(not error):
            print("Testing square no reduction")
            error = test_square_no_reduction(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
            print("Done")
        if(not error):
            print("Testing addition/subtraction no reduction")
            error = test_addition_subtraction_no_reduction(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
            print("Done")
        if(not error):
            print("Testing addition/subtraction with reduction")
            error = test_addition_subtraction_with_reduction(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
            print("Done")
        if(not error):
            print("Testing iterative modular reduction")
            error = test_iterative_modular_reduction(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
            print("Done")
        if(error):
            break
    number_of_bits_added = 3
    base_word_size_signed = 16
    extended_word_size_signed = 256
    accumulator_word_size = (extended_word_size_signed)*2+32
    primes = [2^(253)-1, 2^(509)-1, 2^(765)-1, 2^(1021)-1, 3^(139)+2, 3^(315)+2, 3^(480)+326, 3^(637)+286, 2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1,  2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
    start_test = 0
    end_test = len(primes)
    for i in range(start_test,end_test):
        prime = primes[i]
        print("Testing prime: " + str(prime))
        prime_size_bits = int(prime).bit_length()
        arithmetic_parameters = generate_arithmetic_parameters(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print("Number of bits: " + str(arithmetic_parameters[8]))
        print("Number of words: " + str(arithmetic_parameters[9]))
        print("Testing Montgomery multiplication")
        error = test_montgomery_multiplication(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
        print("Done")
        if(not error):
            print("Testing Montgomery squaring")
            error = test_montgomery_squaring(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
            print("Done")
        if(not error):
            print("Testing multiplication no reduction")
            error = test_multiplication_no_reduction(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
            print("Done")
        if(not error):
            print("Testing square no reduction")
            error = test_square_no_reduction(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
            print("Done")
        if(not error):
            print("Testing addition/subtraction no reduction")
            error = test_addition_subtraction_no_reduction(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
            print("Done")
        if(not error):
            print("Testing addition/subtraction with reduction")
            error = test_addition_subtraction_with_reduction(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
            print("Done")
        if(not error):
            print("Testing iterative modular reduction")
            error = test_iterative_modular_reduction(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)
            print("Done")
        if(error):
            break

def print_all_VHDL_tests():
    tests_folder_name = script_working_folder + "../hw_sidh_tests_v128/"
    number_of_bits_added = 16
    base_word_size_signed = 16
    extended_word_size_signed = 128
    accumulator_word_size = (extended_word_size_signed)*2+32
    primes = [2^(128-number_of_bits_added)-1, 2^(2*128-number_of_bits_added)-1, 2^(3*128-number_of_bits_added)-1, 2^(4*128-number_of_bits_added)-1, 2^(5*128-number_of_bits_added)-1, 2^(6*128-number_of_bits_added)-1, 2^(7*128-number_of_bits_added)-1, 2^(8*128-number_of_bits_added)-1, 2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1,  2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
    files_name_prime_append = ["1_word_max", "2_words_max", "3_words_max", "4_words_max", "5_words_max", "6_words_max", "7_words_max", "8_words_max","8_5", "216_137", "250_159", "305_192", "372_239", "486_301"]
    number_of_each_test = 100
    start_test = 0
    end_test = len(primes)
    for i in range(start_test,end_test):
        prime = primes[i]
        file_name_prime_append = files_name_prime_append[i]
        prime_size_bits = int(prime).bit_length()
        print("Generating VHDL tests for prime: " + str(prime))
        print("")
        print_VHDL_montgomery_multiplication_test(tests_folder_name + "montgomery_multiplication_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_montgomery_multiplication_test(tests_folder_name + "montgomery_multiplication_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print_VHDL_montgomery_squaring_test(tests_folder_name + "montgomery_squaring_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_montgomery_squaring_test(tests_folder_name + "montgomery_squaring_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print_VHDL_multiplication_no_reduction_test(tests_folder_name + "multiplication_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_multiplication_no_reduction_test(tests_folder_name + "multiplication_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print_VHDL_square_no_reduction_test(tests_folder_name + "square_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_square_no_reduction_test(tests_folder_name + "square_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print_VHDL_addition_subtraction_no_reduction_test(tests_folder_name + "addition_subtraction_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_addition_subtraction_no_reduction_test(tests_folder_name + "addition_subtraction_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print_VHDL_addition_subtraction_with_reduction_test(tests_folder_name + "addition_subtraction_with_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_addition_subtraction_with_reduction_test(tests_folder_name + "addition_subtraction_with_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print_VHDL_iterative_modular_reduction_test(tests_folder_name + "iterative_modular_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_iterative_modular_reduction_test(tests_folder_name + "iterative_modular_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print("Done")
        print("")
        
    tests_folder_name = script_working_folder + "../hw_sidh_tests_v256/"
    number_of_bits_added = 16
    base_word_size_signed = 16
    extended_word_size_signed = 256
    accumulator_word_size = (extended_word_size_signed)*2+32
    primes = [2^(256-number_of_bits_added)-1, 2^(2*256-number_of_bits_added)-1, 2^(3*256-number_of_bits_added)-1, 2^(4*256-number_of_bits_added)-1, 2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1,  2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
    files_name_prime_append = ["1_word_max", "2_words_max", "3_words_max", "4_words_max","8_5", "216_137", "250_159", "305_192", "372_239", "486_301"]
    number_of_each_test = 100
    start_test = 0
    end_test = len(primes)
    for i in range(start_test,end_test):
        prime = primes[i]
        file_name_prime_append = files_name_prime_append[i]
        prime_size_bits = int(prime).bit_length()
        print("Generating VHDL tests for prime: " + str(prime))
        print('')
        print_VHDL_montgomery_multiplication_test(tests_folder_name + "montgomery_multiplication_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_montgomery_multiplication_test(tests_folder_name + "montgomery_multiplication_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print_VHDL_montgomery_squaring_test(tests_folder_name + "montgomery_squaring_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_montgomery_squaring_test(tests_folder_name + "montgomery_squaring_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print_VHDL_multiplication_no_reduction_test(tests_folder_name + "multiplication_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_multiplication_no_reduction_test(tests_folder_name + "multiplication_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print_VHDL_square_no_reduction_test(tests_folder_name + "square_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_square_no_reduction_test(tests_folder_name + "square_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print_VHDL_addition_subtraction_no_reduction_test(tests_folder_name + "addition_subtraction_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_addition_subtraction_no_reduction_test(tests_folder_name + "addition_subtraction_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print_VHDL_addition_subtraction_with_reduction_test(tests_folder_name + "addition_subtraction_with_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_addition_subtraction_with_reduction_test(tests_folder_name + "addition_subtraction_with_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print_VHDL_iterative_modular_reduction_test(tests_folder_name + "iterative_modular_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_each_test)
        load_VHDL_iterative_modular_reduction_test(tests_folder_name + "iterative_modular_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print("Done")
        print('')
        
        
def load_all_VHDL_tests():
    tests_folder_name = script_working_folder + "../hw_sidh_tests_v128/"
    number_of_bits_added = 16
    base_word_size_signed = 16
    extended_word_size_signed = 128
    accumulator_word_size = (extended_word_size_signed)*2+32
    primes = [2^(128-number_of_bits_added)-1, 2^(2*128-number_of_bits_added)-1, 2^(3*128-number_of_bits_added)-1, 2^(4*128-number_of_bits_added)-1, 2^(5*128-number_of_bits_added)-1, 2^(6*128-number_of_bits_added)-1, 2^(7*128-number_of_bits_added)-1, 2^(8*128-number_of_bits_added)-1, 2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1,  2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
    files_name_prime_append = ["1_word_max", "2_words_max", "3_words_max", "4_words_max", "5_words_max", "6_words_max", "7_words_max", "8_words_max","8_5", "216_137", "250_159", "305_192", "372_239", "486_301"]
    start_test = 0
    end_test = len(primes)
    for i in range(start_test,end_test):
        prime = primes[i]
        file_name_prime_append = files_name_prime_append[i]
        prime_size_bits = int(prime).bit_length()
        print("Loading all VHDL tests for prime: " + str(prime))
        print('')
        load_VHDL_montgomery_multiplication_test(tests_folder_name + "montgomery_multiplication_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_montgomery_squaring_test(tests_folder_name + "montgomery_squaring_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_multiplication_no_reduction_test(tests_folder_name + "multiplication_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_square_no_reduction_test(tests_folder_name + "square_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_addition_subtraction_no_reduction_test(tests_folder_name + "addition_subtraction_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_addition_subtraction_with_reduction_test(tests_folder_name + "addition_subtraction_with_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_iterative_modular_reduction_test(tests_folder_name + "iterative_modular_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print("Done")
        print('')
        
    tests_folder_name = script_working_folder + "../hw_sidh_tests_v256/"
    number_of_bits_added = 16
    base_word_size_signed = 16
    extended_word_size_signed = 256
    accumulator_word_size = (extended_word_size_signed)*2+32
    primes = [2^(256-number_of_bits_added)-1, 2^(2*256-number_of_bits_added)-1, 2^(3*256-number_of_bits_added)-1, 2^(4*256-number_of_bits_added)-1, 2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1,  2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
    files_name_prime_append = ["1_word_max", "2_words_max", "3_words_max", "4_words_max","8_5", "216_137", "250_159", "305_192", "372_239", "486_301"]
    start_test = 0
    end_test = len(primes)
    for i in range(start_test,end_test):
        prime = primes[i]
        file_name_prime_append = files_name_prime_append[i]
        prime_size_bits = int(prime).bit_length()
        print("Loading all VHDL tests for prime: " + str(prime))
        print('')
        load_VHDL_montgomery_multiplication_test(tests_folder_name + "montgomery_multiplication_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_montgomery_squaring_test(tests_folder_name + "montgomery_squaring_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_multiplication_no_reduction_test(tests_folder_name + "multiplication_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_square_no_reduction_test(tests_folder_name + "square_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_addition_subtraction_no_reduction_test(tests_folder_name + "addition_subtraction_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_addition_subtraction_with_reduction_test(tests_folder_name + "addition_subtraction_with_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        load_VHDL_iterative_modular_reduction_test(tests_folder_name + "iterative_modular_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
        print("Done")
        print('')

def load_VHDL_test(prime_test=0, operation_type=0, debug_test_number=0, extended_word_size_signed=128):
    if(extended_word_size_signed == 128):
        tests_folder_name = script_working_folder + "../hw_sidh_tests_v128/"
        primes = [2^(128-number_of_bits_added)-1, 2^(2*128-number_of_bits_added)-1, 2^(3*128-number_of_bits_added)-1, 2^(4*128-number_of_bits_added)-1, 2^(5*128-number_of_bits_added)-1, 2^(6*128-number_of_bits_added)-1, 2^(7*128-number_of_bits_added)-1, 2^(8*128-number_of_bits_added)-1, 2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1,  2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
        files_name_prime_append = ["1_word_max", "2_words_max", "3_words_max", "4_words_max", "5_words_max", "6_words_max", "7_words_max", "8_words_max","8_5", "216_137", "250_159", "305_192", "372_239", "486_301"]
    elif(extended_word_size_signed == 256):
        tests_folder_name = script_working_folder + "../hw_sidh_tests_v256/"
        primes = [2^(256-number_of_bits_added)-1, 2^(2*256-number_of_bits_added)-1, 2^(3*256-number_of_bits_added)-1, 2^(4*256-number_of_bits_added)-1, 2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1,  2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
        files_name_prime_append = ["1_word_max", "2_words_max", "3_words_max", "4_words_max","8_5", "216_137", "250_159", "305_192", "372_239", "486_301"]
    else:
        print('Not a valid size')
    number_of_bits_added = 16
    base_word_size_signed = 16
    accumulator_word_size = (extended_word_size_signed)*2+32
    prime = primes[prime_test]
    file_name_prime_append = files_name_prime_append[prime_test]
    prime_size_bits = int(prime).bit_length()
    print("Loading VHDL tests for prime: " + str(prime))
    print('')
    if(operation_type == 0):
        load_VHDL_montgomery_multiplication_test(tests_folder_name + "montgomery_multiplication_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, debug_test_number, True)
    elif(operation_type == 1):
        load_VHDL_montgomery_squaring_test(tests_folder_name + "montgomery_squaring_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, debug_test_number, True)
    elif(operation_type == 2):
        load_VHDL_multiplication_no_reduction_test(tests_folder_name + "multiplication_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, debug_test_number, True)
    elif(operation_type == 3):
        load_VHDL_square_no_reduction_test(tests_folder_name + "square_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, debug_test_number, True)
    elif(operation_type == 4):
        load_VHDL_addition_subtraction_no_reduction_test(tests_folder_name + "addition_subtraction_no_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, debug_test_number, True)
    elif(operation_type == 5):
        load_VHDL_addition_subtraction_with_reduction_test(tests_folder_name + "addition_subtraction_with_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, debug_test_number, True)
    else:
        load_VHDL_iterative_modular_reduction_test(tests_folder_name + "iterative_modular_reduction_test_" + file_name_prime_append + ".dat", base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, debug_test_number, True)

#test_all_operations(100)
#print_all_VHDL_tests()
#load_all_VHDL_tests()

#load_VHDL_test(prime_test=7, operation_type=0, debug_test_number=1, extended_word_size_signed=256)


#number_of_bits_added = 16
#base_word_size_signed = 16
#extended_word_size_signed = 256
#accumulator_word_size = (extended_word_size_signed)*2+32
#number_of_random_tests = 1
#primes = [2^112-1, 2^240-1, 2^368-1, 2^496-1, 2^624-1, 2^752-1, 2^880-1, 2^1008-1, 2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1,  2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
#start_test = 0
#end_test = len(primes)
#
#prime = primes[11]
#prime_size_bits = int(prime).bit_length()
#test_montgomery_multiplication(base_word_size_signed, extended_word_size_signed, prime_size_bits, number_of_bits_added, accumulator_word_size, prime, number_of_random_tests)