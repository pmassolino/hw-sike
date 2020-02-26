import time

from ultrascale_sidh import *
from sidh_constants import *

tests_prom_folder = "../assembler/"

enable_loading_verification_of_values = True

starting_position_stack_sidh_core = 224
program_start_address_test_ketgen_alice = 1
program_start_address_test_shared_secret_alice = 5
program_start_address_test_ketgen_bob = 3
program_start_address_test_shared_secret_bob = 7

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
    
def load_VHDL_keygen_alice_fast_test(ultrascale, VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, prime, number_of_tests = 0, debug_mode=False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
    number_of_bits = (((prime_size_bits+number_of_bits_added) + ((extended_word_size)-1))//(extended_word_size))*(extended_word_size)
    number_of_words = number_of_bits//(extended_word_size) 
    base_word_size_signed_number_words = (((extended_word_size) + ((base_word_size)-1))//(base_word_size))
    maximum_number_of_words = number_of_words
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
    loaded_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime != prime):
        print("Error in keygen Alice fast computation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_constant_inv_4 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_oa_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    loaded_ob_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in keygen Alice fast computation : " + str(current_test))
        print("Error loading prime size in bits")
        print("Loaded prime size in bits")
        print(loaded_prime_size_bits)
        print("Input prime size in bits")
        print(prime_size_bits)
    
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file

    loaded_splits_alice   = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, 302, False)
    loaded_splits_bob     = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, 302, False)
    loaded_max_row_alice  = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    loaded_max_row_bob    = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
        
    test_value_xpa_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqa_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xra_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_prime_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_prime)
    loaded_prime_plus_one_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_prime_plus_one)
    loaded_prime_line_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_prime_line)
    loaded_r_mod_prime_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_r_mod_prime)
    loaded_r2_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_r2)
    loaded_constant_1_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_constant_1)
    loaded_constant_inv_4_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_constant_inv_4)
    
    test_value_xpa_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpa_mont)
    test_value_xpai_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpai_mont)
    test_value_xqa_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqa_mont)
    test_value_xqai_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqai_mont)
    test_value_xra_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xra_mont)
    test_value_xrai_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xrai_mont)
    test_value_xpb_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpb_mont)
    test_value_xpbi_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpbi_mont)
    test_value_xqb_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqb_mont)
    test_value_xqbi_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqbi_mont)
    test_value_xrb_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xrb_mont)
    test_value_xrbi_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xrbi_mont)
    
    
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_prime_address, loaded_prime_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_prime_plus_one_address, loaded_prime_plus_one_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_prime_line_address, loaded_prime_line_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_const_r_address, loaded_r_mod_prime_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_const_r2_address, loaded_r2_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_const_1_address, loaded_constant_1_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_inv_4_mont_address, loaded_constant_inv_4_list, number_of_words)
    
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpa_mont_address,  test_value_xpa_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpai_mont_address, test_value_xpai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqa_mont_address,  test_value_xqa_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqai_mont_address, test_value_xqai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xra_mont_address,  test_value_xra_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xrai_mont_address, test_value_xrai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpb_mont_address,  test_value_xpb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpbi_mont_address, test_value_xpbi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqb_mont_address,  test_value_xqb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqbi_mont_address, test_value_xqbi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xrb_mont_address,  test_value_xrb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xrbi_mont_address, test_value_xrbi_mont_list, number_of_words)
    
    if(enable_loading_verification_of_values):
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_prime_address, number_of_words)
        if(value_to_verify != loaded_prime_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_prime_plus_one_address, number_of_words)
        if(value_to_verify != loaded_prime_plus_one_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: prime plus one')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_plus_one_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_prime_line_address, number_of_words)
        if(value_to_verify != loaded_prime_line_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: prime line')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_line_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_const_r_address, number_of_words)
        if(value_to_verify != loaded_r_mod_prime_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: R mod prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_r_mod_prime_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_const_r2_address, number_of_words)
        if(value_to_verify != loaded_r2_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: R^2 mod prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_r2_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_const_1_address, number_of_words)
        if(value_to_verify != loaded_constant_1_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: constant 1')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_constant_1_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_inv_4_mont_address, number_of_words)
        if(value_to_verify != loaded_constant_inv_4_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: 4^-1 mod prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_constant_inv_4_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpa_mont_address, number_of_words)
        if(value_to_verify != test_value_xpa_mont_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: XPA')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpa_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpai_mont_address, number_of_words)
        if(value_to_verify != test_value_xpai_mont_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: XPAi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpai_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqa_mont_address, number_of_words)
        if(value_to_verify != test_value_xqa_mont_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: XQA')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqa_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqai_mont_address, number_of_words)
        if(value_to_verify != test_value_xqai_mont_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: XQAi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqai_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xra_mont_address, number_of_words)
        if(value_to_verify != test_value_xra_mont_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: XRA')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xra_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xrai_mont_address, number_of_words)
        if(value_to_verify != test_value_xrai_mont_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: XRAi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xrai_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpb_mont_address, number_of_words)
        if(value_to_verify != test_value_xpb_mont_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: XPB')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpb_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpbi_mont_address, number_of_words)
        if(value_to_verify != test_value_xpbi_mont_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: XPBi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpbi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqb_mont_address, number_of_words)
        if(value_to_verify != test_value_xqb_mont_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: XQB')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqb_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqbi_mont_address, number_of_words)
        if(value_to_verify != test_value_xqbi_mont_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: XQBi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqbi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xrb_mont_address, number_of_words)
        if(value_to_verify != test_value_xrb_mont_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: XRB')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xrb_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xrbi_mont_address, number_of_words)
        if(value_to_verify != test_value_xrbi_mont_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: XRBi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xrbi_mont_list)
    
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_oa_bits_address, loaded_oa_bits)
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_ob_bits_address, loaded_ob_bits)
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_prime_size_bits_address, loaded_prime_size_bits)
    start_address = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_alice_start_address
    for i in range(302):
        ultrascale.write_package(start_address+i, loaded_splits_alice[i])
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_alice_address, loaded_max_row_alice)
    start_address = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_bob_start_address
    for i in range(302):
        ultrascale.write_package(start_address+i, loaded_splits_bob[i])
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_bob_address, loaded_max_row_bob)
    
    if(enable_loading_verification_of_values):
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_oa_bits_address)
        if(value_to_verify != loaded_oa_bits):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: oa bits')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_oa_bits)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_ob_bits_address)
        if(value_to_verify != loaded_ob_bits):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: ob bits')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_ob_bits)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_prime_size_bits_address)
        if(value_to_verify != loaded_prime_size_bits):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: prime number of bits')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_size_bits)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_alice_address)
        if(value_to_verify != loaded_max_row_alice):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: Max row for Alice strategy')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_max_row_alice)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_bob_address)
        if(value_to_verify != loaded_max_row_bob):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: Max row for Bob strategy')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_max_row_bob)
        start_address_a = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_alice_start_address
        start_address_b = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_bob_start_address
        read_loaded_splits_alice = [0]*302
        read_loaded_splits_bob = [0]*302
        for i in range(302):
            read_loaded_splits_alice[i] = ultrascale.read_package(start_address_a+i)
            read_loaded_splits_bob[i] = ultrascale.read_package(start_address_b+i)
        if(read_loaded_splits_alice != loaded_splits_alice):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: Alice strategy')
            print('Loaded value')
            print(read_loaded_splits_alice)
            print('Input value')
            print(loaded_splits_alice)
        if(read_loaded_splits_bob != loaded_splits_bob):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: Bob strategy')
            print('Loaded value')
            print(read_loaded_splits_bob)
            print('Input value')
            print(loaded_splits_bob)
    
    while(current_test != (number_of_tests-1)):
        print("Current test : " + str(current_test))
        loaded_sk             = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        loaded_sk_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_sk)
        
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, loaded_sk_list, number_of_words)
        
        if(enable_loading_verification_of_values):
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, number_of_words)
            if(value_to_verify != loaded_sk_list):
                print("Error in keygen Alice fast computation : " + str(current_test))
                print('Error loading: Secret key')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(loaded_sk_list)
        
        ultrascale.write_package(sidh_core_reg_operands_size_address, number_of_words - 1)
        ultrascale.write_package(sidh_core_reg_prime_line_equal_one_address, 0)
        ultrascale.write_package(sidh_core_reg_prime_address_address, 0)
        ultrascale.write_package(sidh_core_reg_prime_plus_one_address_address, 1)
        ultrascale.write_package(sidh_core_reg_prime_line_address_address, 2)
        ultrascale.write_package(sidh_core_reg_initial_stack_address_address, 4*starting_position_stack_sidh_core)
        ultrascale.write_package(sidh_core_reg_program_counter_address, program_start_address_test_ketgen_alice)
        
        time.sleep(0.01)
        
        while(not ultrascale.isFree()):
            time.sleep(0.01)
        
        computed_test_value_o1_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 0, number_of_words)
        computed_test_value_o1i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 1, number_of_words)
        computed_test_value_o2_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 2, number_of_words)
        computed_test_value_o2i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 3, number_of_words)
        computed_test_value_o3_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 4, number_of_words)
        computed_test_value_o3i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 5, number_of_words)
        
        computed_test_value_o1  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1_list)
        computed_test_value_o1i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1i_list)
        computed_test_value_o2  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o2_list)
        computed_test_value_o2i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o2i_list)
        computed_test_value_o3  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o3_list)
        computed_test_value_o3i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o3i_list)
        
        if((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i) or (computed_test_value_o3 != loaded_test_value_o3) or (computed_test_value_o3i != loaded_test_value_o3i)):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print("Loaded sk")
            print(loaded_sk)
            print("Loaded value o1")
            print(loaded_test_value_o1)
            print(loaded_test_value_o1i)
            print("Computed value o1")
            print(computed_test_value_o1)
            print(computed_test_value_o1i)
            print("Loaded value o2")
            print(loaded_test_value_o2)
            print(loaded_test_value_o2i)
            print("Computed value o2")
            print(computed_test_value_o2)
            print(computed_test_value_o2i)
            print("Loaded value o3")
            print(loaded_test_value_o3)
            print(loaded_test_value_o3i)
            print("Computed value o3")
            print(computed_test_value_o3)
            print(computed_test_value_o3i)
        current_test += 1
        
    print("Current test : " + str(current_test))
    loaded_sk             = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_sk_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_sk)
    loaded_test_value_o1_list  = integer_to_list(extended_word_size, maximum_number_of_words, loaded_test_value_o1)
    loaded_test_value_o1i_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_test_value_o1i)
    loaded_test_value_o2_list  = integer_to_list(extended_word_size, maximum_number_of_words, loaded_test_value_o2)
    loaded_test_value_o2i_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_test_value_o2i)
    loaded_test_value_o3_list  = integer_to_list(extended_word_size, maximum_number_of_words, loaded_test_value_o3)
    loaded_test_value_o3i_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_test_value_o3i)
        
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, loaded_sk_list, number_of_words)
    
    if(enable_loading_verification_of_values):
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, number_of_words)
        if(value_to_verify != loaded_sk_list):
            print("Error in keygen Alice fast computation : " + str(current_test))
            print('Error loading: Secret key')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_sk_list)
    
    ultrascale.write_package(sidh_core_reg_operands_size_address, number_of_words - 1)
    ultrascale.write_package(sidh_core_reg_prime_line_equal_one_address, 0)
    ultrascale.write_package(sidh_core_reg_prime_address_address, 0)
    ultrascale.write_package(sidh_core_reg_prime_plus_one_address_address, 1)
    ultrascale.write_package(sidh_core_reg_prime_line_address_address, 2)
    ultrascale.write_package(sidh_core_reg_initial_stack_address_address, 4*starting_position_stack_sidh_core)
    ultrascale.write_package(sidh_core_reg_program_counter_address, program_start_address_test_ketgen_alice)
    
    while(not ultrascale.isFree()):
        time.sleep(0.01)
        
    computed_test_value_o1_list  = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 0, number_of_words)
    computed_test_value_o1i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 1, number_of_words)
    computed_test_value_o2_list  = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 2, number_of_words)
    computed_test_value_o2i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 3, number_of_words)
    computed_test_value_o3_list  = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 4, number_of_words)
    computed_test_value_o3i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 5, number_of_words)
    
    computed_test_value_o1  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1_list)
    computed_test_value_o1i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1i_list)
    computed_test_value_o2  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o2_list)
    computed_test_value_o2i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o2i_list)
    computed_test_value_o3  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o3_list)
    computed_test_value_o3i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o3i_list)
        
    if(debug_mode or ((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i) or (computed_test_value_o3 != loaded_test_value_o3) or (computed_test_value_o3i != loaded_test_value_o3i))):
        print("Error in keygen Alice fast computation : " + str(current_test))
        print("Loaded sk")
        print(loaded_sk)
        print("Loaded value o1")
        print(loaded_test_value_o1)
        print(loaded_test_value_o1i)
        print("Computed value o1")
        print(computed_test_value_o1)
        print(computed_test_value_o1i)
        print("Loaded value o2")
        print(loaded_test_value_o2)
        print(loaded_test_value_o2i)
        print("Computed value o2")
        print(computed_test_value_o2)
        print(computed_test_value_o2i)
        print("Loaded value o3")
        print(loaded_test_value_o3)
        print(loaded_test_value_o3i)
        print("Computed value o3")
        print(computed_test_value_o3)
        print(computed_test_value_o3i)
    
    VHDL_memory_file.close()

def load_all_keygen_alice_fast(ultrascale, base_word_size, extended_word_size, number_of_bits_added, tests_working_folder):
    error_computation = False
    for param in sidh_constants:
        print("Loading Alice key generation " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        VHDL_memory_file_name = tests_working_folder + "keygen_alice_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat"
        error_computation = load_VHDL_keygen_alice_fast_test(ultrascale, VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, prime)
        if error_computation:
            break;
    
def load_VHDL_shared_secret_alice_fast_test(ultrascale, VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, prime, number_of_tests = 0, debug_mode=False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
    number_of_bits = (((prime_size_bits+number_of_bits_added) + ((extended_word_size)-1))//(extended_word_size))*(extended_word_size)
    number_of_words = number_of_bits//(extended_word_size) 
    base_word_size_signed_number_words = (((extended_word_size) + ((base_word_size)-1))//(base_word_size))
    maximum_number_of_words = number_of_words
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
    loaded_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime != prime):
        print("Error in shared secret Alice fast computation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_constant_inv_4 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_oa_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    loaded_ob_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in shared secret Alice fast computation : " + str(current_test))
        print("Error loading prime size in bits")
        print("Loaded prime size in bits")
        print(loaded_prime_size_bits)
        print("Input prime size in bits")
        print(prime_size_bits)
    
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    loaded_splits_alice   = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, 302, False)
    loaded_splits_bob     = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, 302, False)
    loaded_max_row_alice  = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    loaded_max_row_bob    = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    
    test_value_xpa_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqa_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xra_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_prime_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_prime)
    loaded_prime_plus_one_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_prime_plus_one)
    loaded_prime_line_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_prime_line)
    loaded_r_mod_prime_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_r_mod_prime)
    loaded_r2_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_r2)
    loaded_constant_1_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_constant_1)
    loaded_constant_inv_4_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_constant_inv_4)
    
    test_value_xpa_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpa_mont)
    test_value_xpai_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpai_mont)
    test_value_xqa_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqa_mont)
    test_value_xqai_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqai_mont)
    test_value_xra_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xra_mont)
    test_value_xrai_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xrai_mont)
    test_value_xpb_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpb_mont)
    test_value_xpbi_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpbi_mont)
    test_value_xqb_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqb_mont)
    test_value_xqbi_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqbi_mont)
    test_value_xrb_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xrb_mont)
    test_value_xrbi_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xrbi_mont)
    
    
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_prime_address, loaded_prime_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_prime_plus_one_address, loaded_prime_plus_one_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_prime_line_address, loaded_prime_line_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_const_r_address, loaded_r_mod_prime_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_const_r2_address, loaded_r2_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_const_1_address, loaded_constant_1_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_inv_4_mont_address, loaded_constant_inv_4_list, number_of_words)
    
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpa_mont_address,  test_value_xpa_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpai_mont_address, test_value_xpai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqa_mont_address,  test_value_xqa_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqai_mont_address, test_value_xqai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xra_mont_address,  test_value_xra_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xrai_mont_address, test_value_xrai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpb_mont_address,  test_value_xpb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpbi_mont_address, test_value_xpbi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqb_mont_address,  test_value_xqb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqbi_mont_address, test_value_xqbi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xrb_mont_address,  test_value_xrb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xrbi_mont_address, test_value_xrbi_mont_list, number_of_words)
    
    if(enable_loading_verification_of_values):
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_prime_address, number_of_words)
        if(value_to_verify != loaded_prime_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_prime_plus_one_address, number_of_words)
        if(value_to_verify != loaded_prime_plus_one_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: prime plus one')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_plus_one_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_prime_line_address, number_of_words)
        if(value_to_verify != loaded_prime_line_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: prime line')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_line_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_const_r_address, number_of_words)
        if(value_to_verify != loaded_r_mod_prime_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: R mod prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_r_mod_prime_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_const_r2_address, number_of_words)
        if(value_to_verify != loaded_r2_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: R^2 mod prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_r2_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_const_1_address, number_of_words)
        if(value_to_verify != loaded_constant_1_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: constant 1')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_constant_1_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_inv_4_mont_address, number_of_words)
        if(value_to_verify != loaded_constant_inv_4_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: 4^-1 mod prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_constant_inv_4_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpa_mont_address, number_of_words)
        if(value_to_verify != test_value_xpa_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: XPA')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpa_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpai_mont_address, number_of_words)
        if(value_to_verify != test_value_xpai_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: XPAi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpai_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqa_mont_address, number_of_words)
        if(value_to_verify != test_value_xqa_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: XQA')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqa_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqai_mont_address, number_of_words)
        if(value_to_verify != test_value_xqai_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: XQAi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqai_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xra_mont_address, number_of_words)
        if(value_to_verify != test_value_xra_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: XRA')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xra_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xrai_mont_address, number_of_words)
        if(value_to_verify != test_value_xrai_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: XRAi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xrai_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpb_mont_address, number_of_words)
        if(value_to_verify != test_value_xpb_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: XPB')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpb_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpbi_mont_address, number_of_words)
        if(value_to_verify != test_value_xpbi_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: XPBi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpbi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqb_mont_address, number_of_words)
        if(value_to_verify != test_value_xqb_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: XQB')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqb_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqbi_mont_address, number_of_words)
        if(value_to_verify != test_value_xqbi_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: XQBi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqbi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xrb_mont_address, number_of_words)
        if(value_to_verify != test_value_xrb_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: XRB')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xrb_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xrbi_mont_address, number_of_words)
        if(value_to_verify != test_value_xrbi_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: XRBi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xrbi_mont_list)
    
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_oa_bits_address, loaded_oa_bits)
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_ob_bits_address, loaded_ob_bits)
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_prime_size_bits_address, loaded_prime_size_bits)
    start_address = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_alice_start_address
    for i in range(302):
        ultrascale.write_package(start_address+i, loaded_splits_alice[i])
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_alice_address, loaded_max_row_alice)
    start_address = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_bob_start_address
    for i in range(302):
        ultrascale.write_package(start_address+i, loaded_splits_bob[i])
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_bob_address, loaded_max_row_bob)
    
    if(enable_loading_verification_of_values):
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_oa_bits_address)
        if(value_to_verify != loaded_oa_bits):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: oa bits')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_oa_bits)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_ob_bits_address)
        if(value_to_verify != loaded_ob_bits):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: ob bits')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_ob_bits)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_prime_size_bits_address)
        if(value_to_verify != loaded_prime_size_bits):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: prime number of bits')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_size_bits)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_alice_address)
        if(value_to_verify != loaded_max_row_alice):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: Max row for Alice strategy')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_max_row_alice)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_bob_address)
        if(value_to_verify != loaded_max_row_bob):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: Max row for Bob strategy')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_max_row_bob)
        start_address_a = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_alice_start_address
        start_address_b = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_bob_start_address
        read_loaded_splits_alice = [0]*302
        read_loaded_splits_bob = [0]*302
        for i in range(302):
            read_loaded_splits_alice[i] = ultrascale.read_package(start_address_a+i)
            read_loaded_splits_bob[i] = ultrascale.read_package(start_address_b+i)
        if(read_loaded_splits_alice != loaded_splits_alice):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: Alice strategy')
            print('Loaded value')
            print(read_loaded_splits_alice)
            print('Input value')
            print(loaded_splits_alice)
        if(read_loaded_splits_bob != loaded_splits_bob):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: Bob strategy')
            print('Loaded value')
            print(read_loaded_splits_bob)
            print('Input value')
            print(loaded_splits_bob)
        
    while(current_test != (number_of_tests-1)):
        print("Current test : " + str(current_test))
        test_value_bob_phiPX_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_bob_phiPXi_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_bob_phiQX_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_bob_phiQXi_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_bob_phiRX_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_bob_phiRXi_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        loaded_sk             = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        test_value_bob_phiPX_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_bob_phiPX_mont)
        test_value_bob_phiPXi_mont_list = integer_to_list(extended_word_size, maximum_number_of_words, test_value_bob_phiPXi_mont)
        test_value_bob_phiQX_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_bob_phiQX_mont)
        test_value_bob_phiQXi_mont_list = integer_to_list(extended_word_size, maximum_number_of_words, test_value_bob_phiQXi_mont)
        test_value_bob_phiRX_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_bob_phiRX_mont)
        test_value_bob_phiRXi_mont_list = integer_to_list(extended_word_size, maximum_number_of_words, test_value_bob_phiRXi_mont)

        loaded_sk_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_sk)
        
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, test_value_bob_phiPX_mont_list, number_of_words)
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 1, test_value_bob_phiPXi_mont_list, number_of_words)
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 2, test_value_bob_phiQX_mont_list, number_of_words)
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 3, test_value_bob_phiQXi_mont_list, number_of_words)
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 4, test_value_bob_phiRX_mont_list, number_of_words)
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 5, test_value_bob_phiRXi_mont_list, number_of_words)
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 6, loaded_sk_list, number_of_words)
        
        if(enable_loading_verification_of_values):
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, number_of_words)
            if(value_to_verify != test_value_bob_phiPX_mont_list):
                print("Error in shared secret Alice fast computation : " + str(current_test))
                print('Error loading: Bob phiPX')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(test_value_bob_phiPX_mont_list)
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 1, number_of_words)
            if(value_to_verify != test_value_bob_phiPXi_mont_list):
                print("Error in shared secret Alice fast computation : " + str(current_test))
                print('Error loading: Bob phiPXi')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(test_value_bob_phiPXi_mont_list)
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 2, number_of_words)
            if(value_to_verify != test_value_bob_phiQX_mont_list):
                print("Error in shared secret Alice fast computation : " + str(current_test))
                print('Error loading: Bob phiQX')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(test_value_bob_phiQX_mont_list)
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 3, number_of_words)
            if(value_to_verify != test_value_bob_phiQXi_mont_list):
                print("Error in shared secret Alice fast computation : " + str(current_test))
                print('Error loading: Bob phiQXi')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(test_value_bob_phiQXi_mont_list)
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 4, number_of_words)
            if(value_to_verify != test_value_bob_phiRX_mont_list):
                print("Error in shared secret Alice fast computation : " + str(current_test))
                print('Error loading: Bob phiRX')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(test_value_bob_phiRX_mont_list)
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 5, number_of_words)
            if(value_to_verify != test_value_bob_phiRXi_mont_list):
                print("Error in shared secret Alice fast computation : " + str(current_test))
                print('Error loading: Bob phiRXi')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(test_value_bob_phiRXi_mont_list)
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 6, number_of_words)
            if(value_to_verify != loaded_sk_list):
                print("Error in shared secret Alice fast computation : " + str(current_test))
                print('Error loading: Secret key')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(loaded_sk_list)
        
        ultrascale.write_package(sidh_core_reg_operands_size_address, number_of_words - 1)
        ultrascale.write_package(sidh_core_reg_prime_line_equal_one_address, 0)
        ultrascale.write_package(sidh_core_reg_prime_address_address, 0)
        ultrascale.write_package(sidh_core_reg_prime_plus_one_address_address, 1)
        ultrascale.write_package(sidh_core_reg_prime_line_address_address, 2)
        ultrascale.write_package(sidh_core_reg_initial_stack_address_address, 4*starting_position_stack_sidh_core)
        ultrascale.write_package(sidh_core_reg_program_counter_address, program_start_address_test_shared_secret_alice)
        
        while(not ultrascale.isFree()):
            time.sleep(0.01)
        
        computed_test_value_o1_list  = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 0, number_of_words)
        computed_test_value_o1i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 1, number_of_words)
        
        computed_test_value_o1  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1_list)
        computed_test_value_o1i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1i_list)
        
        if((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i)):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print("Loaded sk")
            print(loaded_sk)
            print("Loaded bob phiPX")
            print(test_value_bob_phiPX_mont)
            print(test_value_bob_phiPXi_mont)
            print("Loaded bob phiQX")
            print(test_value_bob_phiQX_mont)
            print(test_value_bob_phiQXi_mont)
            print("Loaded bob phiRX")
            print(test_value_bob_phiRX_mont)
            print(test_value_bob_phiRXi_mont)
            print("Loaded value o1")
            print(loaded_test_value_o1)
            print(loaded_test_value_o1i)
            print("Computed value o1")
            print(computed_test_value_o1)
            print(computed_test_value_o1i)
        current_test += 1
    
    print("Current test : " + str(current_test))
    test_value_bob_phiPX_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_bob_phiPXi_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_bob_phiQX_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_bob_phiQXi_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_bob_phiRX_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_bob_phiRXi_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_sk             = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    test_value_bob_phiPX_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_bob_phiPX_mont)
    test_value_bob_phiPXi_mont_list = integer_to_list(extended_word_size, maximum_number_of_words, test_value_bob_phiPXi_mont)
    test_value_bob_phiQX_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_bob_phiQX_mont)
    test_value_bob_phiQXi_mont_list = integer_to_list(extended_word_size, maximum_number_of_words, test_value_bob_phiQXi_mont)
    test_value_bob_phiRX_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_bob_phiRX_mont)
    test_value_bob_phiRXi_mont_list = integer_to_list(extended_word_size, maximum_number_of_words, test_value_bob_phiRXi_mont)

    loaded_sk_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_sk)

    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, test_value_bob_phiPX_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 1, test_value_bob_phiPXi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 2, test_value_bob_phiQX_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 3, test_value_bob_phiQXi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 4, test_value_bob_phiRX_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 5, test_value_bob_phiRXi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 6, loaded_sk_list, number_of_words)
    
    if(enable_loading_verification_of_values):
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, number_of_words)
        if(value_to_verify != test_value_bob_phiPX_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: Bob phiPX')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_bob_phiPX_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 1, number_of_words)
        if(value_to_verify != test_value_bob_phiPXi_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: Bob phiPXi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_bob_phiPXi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 2, number_of_words)
        if(value_to_verify != test_value_bob_phiQX_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: Bob phiQX')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_bob_phiQX_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 3, number_of_words)
        if(value_to_verify != test_value_bob_phiQXi_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: Bob phiQXi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_bob_phiQXi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 4, number_of_words)
        if(value_to_verify != test_value_bob_phiRX_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: Bob phiRX')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_bob_phiRX_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 5, number_of_words)
        if(value_to_verify != test_value_bob_phiRXi_mont_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: Bob phiRXi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_bob_phiRXi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 6, number_of_words)
        if(value_to_verify != loaded_sk_list):
            print("Error in shared secret Alice fast computation : " + str(current_test))
            print('Error loading: Secret key')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_sk_list)
    
    ultrascale.write_package(sidh_core_reg_operands_size_address, number_of_words - 1)
    ultrascale.write_package(sidh_core_reg_prime_line_equal_one_address, 0)
    ultrascale.write_package(sidh_core_reg_prime_address_address, 0)
    ultrascale.write_package(sidh_core_reg_prime_plus_one_address_address, 1)
    ultrascale.write_package(sidh_core_reg_prime_line_address_address, 2)
    ultrascale.write_package(sidh_core_reg_initial_stack_address_address, 4*starting_position_stack_sidh_core)
    ultrascale.write_package(sidh_core_reg_program_counter_address, program_start_address_test_shared_secret_alice)
    
    while(not ultrascale.isFree()):
        time.sleep(0.01)
    
    computed_test_value_o1_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 0, number_of_words)
    computed_test_value_o1i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 1, number_of_words)
    
    computed_test_value_o1  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1_list)
    computed_test_value_o1i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1i_list)
    
    if(debug_mode or ((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i))):
        print("Error in shared secret Alice fast computation : " + str(current_test))
        print("Loaded sk")
        print(loaded_sk)
        print("Loaded bob phiPX")
        print(test_value_bob_phiPX_mont)
        print(test_value_bob_phiPXi_mont)
        print("Loaded bob phiQX")
        print(test_value_bob_phiQX_mont)
        print(test_value_bob_phiQXi_mont)
        print("Loaded bob phiRX")
        print(test_value_bob_phiRX_mont)
        print(test_value_bob_phiRXi_mont)
        print("Loaded value o1")
        print(loaded_test_value_o1)
        print(loaded_test_value_o1i)
        print("Computed value o1")
        print(computed_test_value_o1)
        print(computed_test_value_o1i)
    
    VHDL_memory_file.close()

def load_all_shared_secret_alice_fast(ultrascale, base_word_size, extended_word_size, number_of_bits_added, tests_working_folder):
    error_computation = False
    for param in sidh_constants:
        print("Loading Alice shared secret " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        VHDL_memory_file_name = tests_working_folder + "shared_secret_alice_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat"
        error_computation = load_VHDL_shared_secret_alice_fast_test(ultrascale, VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, prime)
        if error_computation:
            break;

def load_VHDL_keygen_bob_fast_test(ultrascale, VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, prime, number_of_tests = 0, debug_mode=False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
    number_of_bits = (((prime_size_bits+number_of_bits_added) + ((extended_word_size)-1))//(extended_word_size))*(extended_word_size)
    number_of_words = number_of_bits//(extended_word_size) 
    base_word_size_signed_number_words = (((extended_word_size) + ((base_word_size)-1))//(base_word_size))
    maximum_number_of_words = number_of_words
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
    loaded_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime != prime):
        print("Error in keygen Bob fast computation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_constant_inv_4 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_oa_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    loaded_ob_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in keygen Bob fast computation : " + str(current_test))
        print("Error loading prime size in bits")
        print("Loaded prime size in bits")
        print(loaded_prime_size_bits)
        print("Input prime size in bits")
        print(prime_size_bits)
    
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file

    loaded_splits_alice   = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, 302, False)
    loaded_splits_bob     = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, 302, False)
    loaded_max_row_alice  = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    loaded_max_row_bob    = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
        
    test_value_xpa_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqa_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xra_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        
    
    loaded_prime_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_prime)
    loaded_prime_plus_one_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_prime_plus_one)
    loaded_prime_line_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_prime_line)
    loaded_r_mod_prime_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_r_mod_prime)
    loaded_r2_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_r2)
    loaded_constant_1_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_constant_1)
    loaded_constant_inv_4_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_constant_inv_4)
    
    test_value_xpa_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpa_mont)
    test_value_xpai_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpai_mont)
    test_value_xqa_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqa_mont)
    test_value_xqai_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqai_mont)
    test_value_xra_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xra_mont)
    test_value_xrai_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xrai_mont)
    test_value_xpb_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpb_mont)
    test_value_xpbi_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpbi_mont)
    test_value_xqb_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqb_mont)
    test_value_xqbi_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqbi_mont)
    test_value_xrb_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xrb_mont)
    test_value_xrbi_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xrbi_mont)
    
    
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_prime_address, loaded_prime_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_prime_plus_one_address, loaded_prime_plus_one_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_prime_line_address, loaded_prime_line_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_const_r_address, loaded_r_mod_prime_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_const_r2_address, loaded_r2_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_const_1_address, loaded_constant_1_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_inv_4_mont_address, loaded_constant_inv_4_list, number_of_words)
    
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpa_mont_address,  test_value_xpa_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpai_mont_address, test_value_xpai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqa_mont_address,  test_value_xqa_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqai_mont_address, test_value_xqai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xra_mont_address,  test_value_xra_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xrai_mont_address, test_value_xrai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpb_mont_address,  test_value_xpb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpbi_mont_address, test_value_xpbi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqb_mont_address,  test_value_xqb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqbi_mont_address, test_value_xqbi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xrb_mont_address,  test_value_xrb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xrbi_mont_address, test_value_xrbi_mont_list, number_of_words)
    
    if(enable_loading_verification_of_values):
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_prime_address, number_of_words)
        if(value_to_verify != loaded_prime_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_prime_plus_one_address, number_of_words)
        if(value_to_verify != loaded_prime_plus_one_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: prime plus one')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_plus_one_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_prime_line_address, number_of_words)
        if(value_to_verify != loaded_prime_line_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: prime line')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_line_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_const_r_address, number_of_words)
        if(value_to_verify != loaded_r_mod_prime_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: R mod prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_r_mod_prime_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_const_r2_address, number_of_words)
        if(value_to_verify != loaded_r2_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: R^2 mod prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_r2_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_const_1_address, number_of_words)
        if(value_to_verify != loaded_constant_1_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: constant 1')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_constant_1_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_inv_4_mont_address, number_of_words)
        if(value_to_verify != loaded_constant_inv_4_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: 4^-1 mod prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_constant_inv_4_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpa_mont_address, number_of_words)
        if(value_to_verify != test_value_xpa_mont_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: XPA')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpa_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpai_mont_address, number_of_words)
        if(value_to_verify != test_value_xpai_mont_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: XPAi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpai_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqa_mont_address, number_of_words)
        if(value_to_verify != test_value_xqa_mont_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: XQA')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqa_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqai_mont_address, number_of_words)
        if(value_to_verify != test_value_xqai_mont_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: XQAi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqai_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xra_mont_address, number_of_words)
        if(value_to_verify != test_value_xra_mont_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: XRA')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xra_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xrai_mont_address, number_of_words)
        if(value_to_verify != test_value_xrai_mont_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: XRAi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xrai_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpb_mont_address, number_of_words)
        if(value_to_verify != test_value_xpb_mont_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: XPB')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpb_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpbi_mont_address, number_of_words)
        if(value_to_verify != test_value_xpbi_mont_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: XPBi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpbi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqb_mont_address, number_of_words)
        if(value_to_verify != test_value_xqb_mont_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: XQB')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqb_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqbi_mont_address, number_of_words)
        if(value_to_verify != test_value_xqbi_mont_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: XQBi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqbi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xrb_mont_address, number_of_words)
        if(value_to_verify != test_value_xrb_mont_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: XRB')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xrb_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xrbi_mont_address, number_of_words)
        if(value_to_verify != test_value_xrbi_mont_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: XRBi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xrbi_mont_list)
    
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_oa_bits_address, loaded_oa_bits)
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_ob_bits_address, loaded_ob_bits)
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_prime_size_bits_address, loaded_prime_size_bits)
    start_address = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_alice_start_address
    for i in range(302):
        ultrascale.write_package(start_address+i, loaded_splits_alice[i])
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_alice_address, loaded_max_row_alice)
    start_address = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_bob_start_address
    for i in range(302):
        ultrascale.write_package(start_address+i, loaded_splits_bob[i])
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_bob_address, loaded_max_row_bob)
    
    if(enable_loading_verification_of_values):
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_oa_bits_address)
        if(value_to_verify != loaded_oa_bits):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: oa bits')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_oa_bits)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_ob_bits_address)
        if(value_to_verify != loaded_ob_bits):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: ob bits')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_ob_bits)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_prime_size_bits_address)
        if(value_to_verify != loaded_prime_size_bits):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: prime number of bits')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_size_bits)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_alice_address)
        if(value_to_verify != loaded_max_row_alice):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: Max row for Alice strategy')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_max_row_alice)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_bob_address)
        if(value_to_verify != loaded_max_row_bob):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: Max row for Bob strategy')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_max_row_bob)
        start_address_a = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_alice_start_address
        start_address_b = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_bob_start_address
        read_loaded_splits_alice = [0]*302
        read_loaded_splits_bob = [0]*302
        for i in range(302):
            read_loaded_splits_alice[i] = ultrascale.read_package(start_address_a+i)
            read_loaded_splits_bob[i] = ultrascale.read_package(start_address_b+i)
        if(read_loaded_splits_alice != loaded_splits_alice):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: Alice strategy')
            print('Loaded value')
            print(read_loaded_splits_alice)
            print('Input value')
            print(loaded_splits_alice)
        if(read_loaded_splits_bob != loaded_splits_bob):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: Bob strategy')
            print('Loaded value')
            print(read_loaded_splits_bob)
            print('Input value')
            print(loaded_splits_bob)
    
    while(current_test != (number_of_tests-1)):
        print("Current test : " + str(current_test))
        loaded_sk             = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        loaded_sk_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_sk)
        
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, loaded_sk_list, number_of_words)
        
        if(enable_loading_verification_of_values):
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, number_of_words)
            if(value_to_verify != loaded_sk_list):
                print("Error in keygen Bob fast computation : " + str(current_test))
                print('Error loading: Secret key')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(loaded_sk_list)
        
        ultrascale.write_package(sidh_core_reg_operands_size_address, number_of_words - 1)
        ultrascale.write_package(sidh_core_reg_prime_line_equal_one_address, 0)
        ultrascale.write_package(sidh_core_reg_prime_address_address, 0)
        ultrascale.write_package(sidh_core_reg_prime_plus_one_address_address, 1)
        ultrascale.write_package(sidh_core_reg_prime_line_address_address, 2)
        ultrascale.write_package(sidh_core_reg_initial_stack_address_address, 4*starting_position_stack_sidh_core)
        ultrascale.write_package(sidh_core_reg_program_counter_address, program_start_address_test_ketgen_bob)
        
        while(not ultrascale.isFree()):
            time.sleep(0.01)
        
        computed_test_value_o1_list  = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 0, number_of_words)
        computed_test_value_o1i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 1, number_of_words)
        computed_test_value_o2_list  = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 2, number_of_words)
        computed_test_value_o2i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 3, number_of_words)
        computed_test_value_o3_list  = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 4, number_of_words)
        computed_test_value_o3i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 5, number_of_words)
        
        computed_test_value_o1  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1_list)
        computed_test_value_o1i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1i_list)
        computed_test_value_o2  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o2_list)
        computed_test_value_o2i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o2i_list)
        computed_test_value_o3  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o3_list)
        computed_test_value_o3i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o3i_list)
        
        if((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i) or (computed_test_value_o3 != loaded_test_value_o3) or (computed_test_value_o3i != loaded_test_value_o3i)):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print("Loaded sk")
            print(loaded_sk)
            print("Loaded value o1")
            print(loaded_test_value_o1)
            print(loaded_test_value_o1i)
            print("Computed value o1")
            print(computed_test_value_o1)
            print(computed_test_value_o1i)
            print("Loaded value o2")
            print(loaded_test_value_o2)
            print(loaded_test_value_o2i)
            print("Computed value o2")
            print(computed_test_value_o2)
            print(computed_test_value_o2i)
            print("Computed value o3")
            print(computed_test_value_o3)
            print(computed_test_value_o3i)
        current_test += 1
    
    print("Current test : " + str(current_test))
    loaded_sk             = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o2i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o3  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o3i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_sk_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_sk)
    
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, loaded_sk_list, number_of_words)
    
    if(enable_loading_verification_of_values):
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, number_of_words)
        if(value_to_verify != loaded_sk_list):
            print("Error in keygen Bob fast computation : " + str(current_test))
            print('Error loading: Secret key')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_sk_list)
    
    ultrascale.write_package(sidh_core_reg_operands_size_address, number_of_words - 1)
    ultrascale.write_package(sidh_core_reg_prime_line_equal_one_address, 0)
    ultrascale.write_package(sidh_core_reg_prime_address_address, 0)
    ultrascale.write_package(sidh_core_reg_prime_plus_one_address_address, 1)
    ultrascale.write_package(sidh_core_reg_prime_line_address_address, 2)
    ultrascale.write_package(sidh_core_reg_initial_stack_address_address, 4*starting_position_stack_sidh_core)
    ultrascale.write_package(sidh_core_reg_program_counter_address, program_start_address_test_ketgen_bob)
    
    while(not ultrascale.isFree()):
        time.sleep(0.01)
    
    computed_test_value_o1_list  = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 0, number_of_words)
    computed_test_value_o1i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 1, number_of_words)
    computed_test_value_o2_list  = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 2, number_of_words)
    computed_test_value_o2i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 3, number_of_words)
    computed_test_value_o3_list  = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 4, number_of_words)
    computed_test_value_o3i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 5, number_of_words)
    
    computed_test_value_o1  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1_list)
    computed_test_value_o1i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1i_list)
    computed_test_value_o2  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o2_list)
    computed_test_value_o2i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o2i_list)
    computed_test_value_o3  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o3_list)
    computed_test_value_o3i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o3i_list)
        
    
    if(debug_mode or ((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i) or (computed_test_value_o2 != loaded_test_value_o2) or (computed_test_value_o2i != loaded_test_value_o2i) or (computed_test_value_o3 != loaded_test_value_o3) or (computed_test_value_o3i != loaded_test_value_o3i))):
        print("Error in keygen Bob fast computation : " + str(current_test))
        print("Loaded sk")
        print(loaded_sk)
        print("Loaded value o1")
        print(loaded_test_value_o1)
        print(loaded_test_value_o1i)
        print("Computed value o1")
        print(computed_test_value_o1)
        print(computed_test_value_o1i)
        print("Loaded value o2")
        print(loaded_test_value_o2)
        print(loaded_test_value_o2i)
        print("Computed value o2")
        print(computed_test_value_o2)
        print(computed_test_value_o2i)
        print("Computed value o3")
        print(computed_test_value_o3)
        print(computed_test_value_o3i)
    
    VHDL_memory_file.close()
    
def load_all_keygen_bob_fast(ultrascale, base_word_size, extended_word_size, number_of_bits_added, tests_working_folder):
    error_computation = False
    for param in sidh_constants:
        print("Loading Bob key generation " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        VHDL_memory_file_name = tests_working_folder + "keygen_bob_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat"
        error_computation = load_VHDL_keygen_bob_fast_test(ultrascale, VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, prime)
        if error_computation:
            break;
            
def load_VHDL_shared_secret_bob_fast_test(ultrascale, VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, prime, number_of_tests = 0, debug_mode=False):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    VHDL_memory_file.seek(0, 2)
    VHDL_file_size = VHDL_memory_file.tell()
    VHDL_memory_file.seek(0)
    
    number_of_bits = (((prime_size_bits+number_of_bits_added) + ((extended_word_size)-1))//(extended_word_size))*(extended_word_size)
    number_of_words = number_of_bits//(extended_word_size) 
    base_word_size_signed_number_words = (((extended_word_size) + ((base_word_size)-1))//(base_word_size))
    maximum_number_of_words = number_of_words
    
    VHDL_word_size = base_word_size_signed_number_words*base_word_size
    
    current_test = 0
    total_number_of_tests_file = int(VHDL_memory_file.readline())
    loaded_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    if(loaded_prime != prime):
        print("Error in shared secret bob fast computation : " + str(current_test))
        print("Error loading the prime")
        print("Loaded prime")
        print(loaded_prime)
        print("Input prime")
        print(prime)
    loaded_prime_plus_one = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_prime_line = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_r_mod_prime = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_r2 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_constant_1 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_constant_inv_4 = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_oa_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    loaded_ob_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    loaded_prime_size_bits = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    if(loaded_prime_size_bits != prime_size_bits):
        print("Error in shared secret bob fast computation : " + str(current_test))
        print("Error loading prime size in bits")
        print("Loaded prime size in bits")
        print(loaded_prime_size_bits)
        print("Input prime size in bits")
        print(prime_size_bits)
    
    if((number_of_tests == 0) or (number_of_tests > total_number_of_tests_file)):
        number_of_tests = total_number_of_tests_file
    
    loaded_splits_alice   = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, 302, False)
    loaded_splits_bob   = load_list_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, 302, False)
    loaded_max_row_alice  = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    loaded_max_row_bob  = load_value_convert_format_VHDL_BASE_memory(VHDL_memory_file, base_word_size, False)
    
    test_value_xpa_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqa_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xra_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrai_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xpbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xqbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrb_mont   = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_xrbi_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    
    loaded_prime_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_prime)
    loaded_prime_plus_one_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_prime_plus_one)
    loaded_prime_line_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_prime_line)
    loaded_r_mod_prime_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_r_mod_prime)
    loaded_r2_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_r2)
    loaded_constant_1_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_constant_1)
    loaded_constant_inv_4_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_constant_inv_4)
    
    test_value_xpa_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpa_mont)
    test_value_xpai_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpai_mont)
    test_value_xqa_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqa_mont)
    test_value_xqai_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqai_mont)
    test_value_xra_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xra_mont)
    test_value_xrai_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xrai_mont)
    test_value_xpb_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpb_mont)
    test_value_xpbi_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xpbi_mont)
    test_value_xqb_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqb_mont)
    test_value_xqbi_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xqbi_mont)
    test_value_xrb_mont_list   = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xrb_mont)
    test_value_xrbi_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_xrbi_mont)
    
    
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_prime_address, loaded_prime_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_prime_plus_one_address, loaded_prime_plus_one_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_prime_line_address, loaded_prime_line_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_const_r_address, loaded_r_mod_prime_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_const_r2_address, loaded_r2_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_const_1_address, loaded_constant_1_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_inv_4_mont_address, loaded_constant_inv_4_list, number_of_words)
    
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpa_mont_address,  test_value_xpa_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpai_mont_address, test_value_xpai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqa_mont_address,  test_value_xqa_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqai_mont_address, test_value_xqai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xra_mont_address,  test_value_xra_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xrai_mont_address, test_value_xrai_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpb_mont_address,  test_value_xpb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xpbi_mont_address, test_value_xpbi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqb_mont_address,  test_value_xqb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xqbi_mont_address, test_value_xqbi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xrb_mont_address,  test_value_xrb_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_sidh_xrbi_mont_address, test_value_xrbi_mont_list, number_of_words)
    
    if(enable_loading_verification_of_values):
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_prime_address, number_of_words)
        if(value_to_verify != loaded_prime_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_prime_plus_one_address, number_of_words)
        if(value_to_verify != loaded_prime_plus_one_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: prime plus one')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_plus_one_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_prime_line_address, number_of_words)
        if(value_to_verify != loaded_prime_line_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: prime line')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_line_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_const_r_address, number_of_words)
        if(value_to_verify != loaded_r_mod_prime_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: R mod prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_r_mod_prime_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_const_r2_address, number_of_words)
        if(value_to_verify != loaded_r2_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: R^2 mod prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_r2_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_const_1_address, number_of_words)
        if(value_to_verify != loaded_constant_1_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: constant 1')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_constant_1_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_inv_4_mont_address, number_of_words)
        if(value_to_verify != loaded_constant_inv_4_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: 4^-1 mod prime')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_constant_inv_4_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpa_mont_address, number_of_words)
        if(value_to_verify != test_value_xpa_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: XPA')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpa_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpai_mont_address, number_of_words)
        if(value_to_verify != test_value_xpai_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: XPAi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpai_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqa_mont_address, number_of_words)
        if(value_to_verify != test_value_xqa_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: XQA')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqa_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqai_mont_address, number_of_words)
        if(value_to_verify != test_value_xqai_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: XQAi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqai_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xra_mont_address, number_of_words)
        if(value_to_verify != test_value_xra_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: XRA')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xra_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xrai_mont_address, number_of_words)
        if(value_to_verify != test_value_xrai_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: XRAi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xrai_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpb_mont_address, number_of_words)
        if(value_to_verify != test_value_xpb_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: XPB')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpb_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xpbi_mont_address, number_of_words)
        if(value_to_verify != test_value_xpbi_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: XPBi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xpbi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqb_mont_address, number_of_words)
        if(value_to_verify != test_value_xqb_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: XQB')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqb_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xqbi_mont_address, number_of_words)
        if(value_to_verify != test_value_xqbi_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: XQBi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xqbi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xrb_mont_address, number_of_words)
        if(value_to_verify != test_value_xrb_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: XRB')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xrb_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_sidh_xrbi_mont_address, number_of_words)
        if(value_to_verify != test_value_xrbi_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: XRBi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_xrbi_mont_list)
    
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_oa_bits_address, loaded_oa_bits)
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_ob_bits_address, loaded_ob_bits)
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_prime_size_bits_address, loaded_prime_size_bits)
    start_address = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_alice_start_address
    for i in range(302):
        ultrascale.write_package(start_address+i, loaded_splits_alice[i])
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_alice_address, loaded_max_row_alice)
    start_address = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_bob_start_address
    for i in range(302):
        ultrascale.write_package(start_address+i, loaded_splits_bob[i])
    ultrascale.write_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_bob_address, loaded_max_row_bob)
    
    if(enable_loading_verification_of_values):
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_oa_bits_address)
        if(value_to_verify != loaded_oa_bits):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: oa bits')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_oa_bits)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_ob_bits_address)
        if(value_to_verify != loaded_ob_bits):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: ob bits')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_ob_bits)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_prime_size_bits_address)
        if(value_to_verify != loaded_prime_size_bits):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: prime number of bits')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_prime_size_bits)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_alice_address)
        if(value_to_verify != loaded_max_row_alice):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: Max row for Alice strategy')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_max_row_alice)
        value_to_verify = ultrascale.read_package(sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_max_row_bob_address)
        if(value_to_verify != loaded_max_row_bob):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: Max row for Bob strategy')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_max_row_bob)
        start_address_a = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_alice_start_address
        start_address_b = sidh_core_base_alu_ram_start_address + sidh_core_base_alu_ram_splits_bob_start_address
        read_loaded_splits_alice = [0]*302
        read_loaded_splits_bob = [0]*302
        for i in range(302):
            read_loaded_splits_alice[i] = ultrascale.read_package(start_address_a+i)
            read_loaded_splits_bob[i] = ultrascale.read_package(start_address_b+i)
        if(read_loaded_splits_alice != loaded_splits_alice):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: Alice strategy')
            print('Loaded value')
            print(read_loaded_splits_alice)
            print('Input value')
            print(loaded_splits_alice)
        if(read_loaded_splits_bob != loaded_splits_bob):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: Bob strategy')
            print('Loaded value')
            print(read_loaded_splits_bob)
            print('Input value')
            print(loaded_splits_bob)
    
    while(current_test != (number_of_tests-1)):
        print("Current test : " + str(current_test))
        test_value_alice_phiPX_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_alice_phiPXi_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_alice_phiQX_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_alice_phiQXi_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_alice_phiRX_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        test_value_alice_phiRXi_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        loaded_sk             = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
        
        test_value_alice_phiPX_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_alice_phiPX_mont)
        test_value_alice_phiPXi_mont_list = integer_to_list(extended_word_size, maximum_number_of_words, test_value_alice_phiPXi_mont)
        test_value_alice_phiQX_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_alice_phiQX_mont)
        test_value_alice_phiQXi_mont_list = integer_to_list(extended_word_size, maximum_number_of_words, test_value_alice_phiQXi_mont)
        test_value_alice_phiRX_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_alice_phiRX_mont)
        test_value_alice_phiRXi_mont_list = integer_to_list(extended_word_size, maximum_number_of_words, test_value_alice_phiRXi_mont)
    
        loaded_sk_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_sk)
    
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, test_value_alice_phiPX_mont_list, number_of_words)
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 1, test_value_alice_phiPXi_mont_list, number_of_words)
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 2, test_value_alice_phiQX_mont_list, number_of_words)
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 3, test_value_alice_phiQXi_mont_list, number_of_words)
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 4, test_value_alice_phiRX_mont_list, number_of_words)
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 5, test_value_alice_phiRXi_mont_list, number_of_words)
        ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 6, loaded_sk_list, number_of_words)
        
        if(enable_loading_verification_of_values):
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, number_of_words)
            if(value_to_verify != test_value_alice_phiPX_mont_list):
                print("Error in shared secret Bob fast computation : " + str(current_test))
                print('Error loading: Alice phiPX')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(test_value_alice_phiPX_mont_list)
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 1, number_of_words)
            if(value_to_verify != test_value_alice_phiPXi_mont_list):
                print("Error in shared secret Bob fast computation : " + str(current_test))
                print('Error loading: Alice phiPXi')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(test_value_alice_phiPXi_mont_list)
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 2, number_of_words)
            if(value_to_verify != test_value_alice_phiQX_mont_list):
                print("Error in shared secret Bob fast computation : " + str(current_test))
                print('Error loading: Alice phiQX')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(test_value_alice_phiQX_mont_list)
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 3, number_of_words)
            if(value_to_verify != test_value_alice_phiQXi_mont_list):
                print("Error in shared secret Bob fast computation : " + str(current_test))
                print('Error loading: Alice phiQXi')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(test_value_alice_phiQXi_mont_list)
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 4, number_of_words)
            if(value_to_verify != test_value_alice_phiRX_mont_list):
                print("Error in shared secret Bob fast computation : " + str(current_test))
                print('Error loading: Alice phiRX')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(test_value_alice_phiRX_mont_list)
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 5, number_of_words)
            if(value_to_verify != test_value_alice_phiRXi_mont_list):
                print("Error in shared secret Bob fast computation : " + str(current_test))
                print('Error loading: Alice phiRXi')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(test_value_alice_phiRXi_mont_list)
            value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 6, number_of_words)
            if(value_to_verify != loaded_sk_list):
                print("Error in shared secret Bob fast computation : " + str(current_test))
                print('Error loading: Secret key')
                print('Loaded value')
                print(value_to_verify)
                print('Input value')
                print(loaded_sk_list)
        
        ultrascale.write_package(sidh_core_reg_operands_size_address, number_of_words - 1)
        ultrascale.write_package(sidh_core_reg_prime_line_equal_one_address, 0)
        ultrascale.write_package(sidh_core_reg_prime_address_address, 0)
        ultrascale.write_package(sidh_core_reg_prime_plus_one_address_address, 1)
        ultrascale.write_package(sidh_core_reg_prime_line_address_address, 2)
        ultrascale.write_package(sidh_core_reg_initial_stack_address_address, 4*starting_position_stack_sidh_core)
        ultrascale.write_package(sidh_core_reg_program_counter_address, program_start_address_test_shared_secret_bob)
        
        while(not ultrascale.isFree()):
            time.sleep(0.1)
        
        computed_test_value_o1_list  = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 0, number_of_words)
        computed_test_value_o1i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 1, number_of_words)
        
        computed_test_value_o1  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1_list)
        computed_test_value_o1i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1i_list)
        
        if((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i)):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print("Loaded sk")
            print(loaded_sk)
            print("Loaded alice phiPX")
            print(test_value_alice_phiPX_mont)
            print(test_value_alice_phiPXi_mont)
            print("Loaded alice phiQX")
            print(test_value_alice_phiQX_mont)
            print(test_value_alice_phiQXi_mont)
            print("Loaded alice phiRX")
            print(test_value_alice_phiRX_mont)
            print(test_value_alice_phiRXi_mont)
            print("Loaded value o1")
            print(loaded_test_value_o1)
            print(loaded_test_value_o1i)
            print("Computed value o1")
            print(computed_test_value_o1)
            print(computed_test_value_o1i)
        current_test += 1
    
    print("Current test : " + str(current_test))
    test_value_alice_phiPX_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_alice_phiPXi_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_alice_phiQX_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_alice_phiQXi_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_alice_phiRX_mont  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    test_value_alice_phiRXi_mont = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_sk             = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    loaded_test_value_o1  = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    loaded_test_value_o1i = load_list_value_VHDL_MAC_memory_as_integer(VHDL_memory_file, base_word_size, base_word_size_signed_number_words, maximum_number_of_words, False)
    
    test_value_alice_phiPX_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_alice_phiPX_mont)
    test_value_alice_phiPXi_mont_list = integer_to_list(extended_word_size, maximum_number_of_words, test_value_alice_phiPXi_mont)
    test_value_alice_phiQX_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_alice_phiQX_mont)
    test_value_alice_phiQXi_mont_list = integer_to_list(extended_word_size, maximum_number_of_words, test_value_alice_phiQXi_mont)
    test_value_alice_phiRX_mont_list  = integer_to_list(extended_word_size, maximum_number_of_words, test_value_alice_phiRX_mont)
    test_value_alice_phiRXi_mont_list = integer_to_list(extended_word_size, maximum_number_of_words, test_value_alice_phiRXi_mont)
    
    loaded_sk_list = integer_to_list(extended_word_size, maximum_number_of_words, loaded_sk)
    
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, test_value_alice_phiPX_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 1, test_value_alice_phiPXi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 2, test_value_alice_phiQX_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 3, test_value_alice_phiQXi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 4, test_value_alice_phiRX_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 5, test_value_alice_phiRXi_mont_list, number_of_words)
    ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 6, loaded_sk_list, number_of_words)
    
    if(enable_loading_verification_of_values):
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 0, number_of_words)
        if(value_to_verify != test_value_alice_phiPX_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: Alice phiPX')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_alice_phiPX_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 1, number_of_words)
        if(value_to_verify != test_value_alice_phiPXi_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: Alice phiPXi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_alice_phiPXi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 2, number_of_words)
        if(value_to_verify != test_value_alice_phiQX_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: Alice phiQX')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_alice_phiQX_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 3, number_of_words)
        if(value_to_verify != test_value_alice_phiQXi_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: Alice phiQXi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_alice_phiQXi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 4, number_of_words)
        if(value_to_verify != test_value_alice_phiRX_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: Alice phiRX')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_alice_phiRX_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 5, number_of_words)
        if(value_to_verify != test_value_alice_phiRXi_mont_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: Alice phiRXi')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(test_value_alice_phiRXi_mont_list)
        value_to_verify = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address + 6, number_of_words)
        if(value_to_verify != loaded_sk_list):
            print("Error in shared secret Bob fast computation : " + str(current_test))
            print('Error loading: Secret key')
            print('Loaded value')
            print(value_to_verify)
            print('Input value')
            print(loaded_sk_list)
    
    ultrascale.write_package(sidh_core_reg_operands_size_address, number_of_words - 1)
    ultrascale.write_package(sidh_core_reg_prime_line_equal_one_address, 0)
    ultrascale.write_package(sidh_core_reg_prime_address_address, 0)
    ultrascale.write_package(sidh_core_reg_prime_plus_one_address_address, 1)
    ultrascale.write_package(sidh_core_reg_prime_line_address_address, 2)
    ultrascale.write_package(sidh_core_reg_initial_stack_address_address, 4*starting_position_stack_sidh_core)
    ultrascale.write_package(sidh_core_reg_program_counter_address, program_start_address_test_shared_secret_bob)
    
    while(not ultrascale.isFree()):
        time.sleep(0.1)
    
    computed_test_value_o1_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 0, number_of_words)
    computed_test_value_o1i_list = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_output_function_start_address + 1, number_of_words)
    
    computed_test_value_o1  = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1_list)
    computed_test_value_o1i = list_to_integer(extended_word_size, maximum_number_of_words, computed_test_value_o1i_list)
    
    if(debug_mode or ((computed_test_value_o1 != loaded_test_value_o1) or (computed_test_value_o1i != loaded_test_value_o1i))):
        print("Error in shared secret Bob fast computation : " + str(current_test))
        print("Loaded sk")
        print(loaded_sk)
        print("Loaded alice phiPX")
        print(test_value_alice_phiPX_mont)
        print(test_value_alice_phiPXi_mont)
        print("Loaded alice phiQX")
        print(test_value_alice_phiQX_mont)
        print(test_value_alice_phiQXi_mont)
        print("Loaded alice phiRX")
        print(test_value_alice_phiRX_mont)
        print(test_value_alice_phiRXi_mont)
        print("Loaded value o1")
        print(loaded_test_value_o1)
        print(loaded_test_value_o1i)
        print("Computed value o1")
        print(computed_test_value_o1)
        print(computed_test_value_o1i)
    
    VHDL_memory_file.close()

def load_all_shared_secret_bob_fast(ultrascale, base_word_size, extended_word_size, number_of_bits_added, tests_working_folder):
    error_computation = False
    for param in sidh_constants:
        print("Loading Bob shared secret " +  param[0])
        prime = (param[1])*((param[2])**((param[4])))*((param[3])**((param[5])))-1
        prime_size_bits = int(prime).bit_length()
        VHDL_memory_file_name = tests_working_folder + "shared_secret_bob_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat"
        error_computation = load_VHDL_shared_secret_bob_fast_test(ultrascale, VHDL_memory_file_name, base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, prime)
        if error_computation:
            break;
    
def load_program(ultrascale, prom_file_name, base_word_size, base_word_size_signed_number_words):
    prom_file = open(prom_file_name, 'r')
    program = []
    prom_file.seek(0, 2)
    prom_file_size = prom_file.tell()
    prom_file.seek(0)
    while (prom_file.tell() != prom_file_size):
        program += [load_list_value_VHDL_MAC_memory_as_integer(prom_file, base_word_size, base_word_size_signed_number_words, 1, False)]
    print("Loading program into SIDH core")
    ultrascale.write_program_prom(0, program)
    print("Reading program uploaded into SIDH core")
    program_written = ultrascale.read_program_prom(0, len(program))
    print("Verifying program uploaded into SIDH core")
    if(program_written == program):
        return True
    print(program)
    print(program_written)
    return False

def test_all_sidh_functions(ultrascale, sidh_extended_word_size):
    sidh_base_word_size = 16
    sidh_extended_word_size = 256
    sidh_base_word_size_signed_number_words = (((sidh_extended_word_size) + ((sidh_base_word_size)-1))//(sidh_base_word_size))
    number_of_bits_added = 8
    tests_working_folder = "../hw_sidh_tests_v"+str(sidh_extended_word_size+1)+"/"
    if(load_program(ultrascale, tests_prom_folder + "test_sidh_functions_v" + str(sidh_extended_word_size+1)+ ".dat", sidh_base_word_size, 4)):
        print("Program loaded correctly into SIDH core")
        load_all_keygen_alice_fast(ultrascale, sidh_base_word_size, sidh_extended_word_size, number_of_bits_added, tests_working_folder)
        load_all_shared_secret_alice_fast(ultrascale, sidh_base_word_size, sidh_extended_word_size, number_of_bits_added, tests_working_folder)
        load_all_keygen_bob_fast(ultrascale, sidh_base_word_size, sidh_extended_word_size, number_of_bits_added, tests_working_folder)
        load_all_shared_secret_bob_fast(ultrascale, sidh_base_word_size, sidh_extended_word_size, number_of_bits_added, tests_working_folder)
    else:
        print('Program loading failed')

ultrascale = Ultrascale('COM9')
#ultrascale.read_initial_message(34)
while(not ultrascale.isFree()):
    time.sleep(0.01)
ultrascale.flush()

test_all_sidh_functions(ultrascale, 256)



#print('Is it Free? ' + str(ultrascale.isFree()))
#prime = (2**(271))*3**(301)-1
#prime_list = integer_to_list(sidh_extended_word_size, 4, prime)
#ultrascale.write_mac_ram_operand(sidh_core_mac_ram_input_function_start_address, prime_list, 4)
#read_value = ultrascale.read_mac_ram_operand(sidh_core_mac_ram_input_function_start_address, 4)
#print(prime_list[0])
#print(read_value[0])
#print("-----------")
#print(prime_list[1])
#print(read_value[1])
#print("-----------")
#print(prime_list[2])
#print(read_value[2])
#print("-----------")
#print(prime_list[3])
#print(read_value[3])
#print("-----------")
ultrascale.disconnect()