import ecc_constants
import sike_core_utils

def generate_fpga_constants(prime, elliptic_curve_order, elliptic_curve_const_a, elliptic_curve_const_b, elliptic_curve_generator_point_x, elliptic_curve_generator_point_y, base_word_size, extended_word_size, number_of_bits_added):
    ecc_fpga_constants = [0 for i in range(26)]
    
    accumulator_word_size=2*extended_word_size+32
    prime_size_bits = int(prime).bit_length()
    arithmetic_parameters = sike_core_utils.generate_arithmetic_parameters(base_word_size, extended_word_size, prime_size_bits, number_of_bits_added, accumulator_word_size, prime)
    
    prime_plus_one = arithmetic_parameters[5]
    prime_plus_one_list = arithmetic_parameters[6]
    prime_line = arithmetic_parameters[17]
    prime2 = arithmetic_parameters[24]
    
    r_mod_prime = arithmetic_parameters[12]
    r2_mod_prime = arithmetic_parameters[14]
    number_of_words = arithmetic_parameters[9]
    
    prime_line_equal_one = arithmetic_parameters[19]
    
    prime_plus_one_number_of_zeroes = 0
    for i in range(0, number_of_words):
        if(prime_plus_one_list[i] != 0):
            break
        prime_plus_one_number_of_zeroes = prime_plus_one_number_of_zeroes + 1

    if((extended_word_size == 256) and (prime_plus_one_number_of_zeroes > 1)):
        prime_plus_one_number_of_zeroes = 1

    if((extended_word_size == 128) and (prime_plus_one_number_of_zeroes > 3)):
        prime_plus_one_number_of_zeroes = 3
    
    ecc_fpga_constants[0]  = "p" + str(prime_size_bits)
    ecc_fpga_constants[1]  = base_word_size
    ecc_fpga_constants[2]  = extended_word_size
    ecc_fpga_constants[3]  = number_of_bits_added
    ecc_fpga_constants[4]  = number_of_words
    ecc_fpga_constants[5]  = prime
    ecc_fpga_constants[6]  = prime_size_bits
    ecc_fpga_constants[7]  = prime_plus_one
    ecc_fpga_constants[8]  = prime_line
    ecc_fpga_constants[9]  = prime_plus_one_number_of_zeroes
    ecc_fpga_constants[10] = prime2
    ecc_fpga_constants[11] = r_mod_prime
    ecc_fpga_constants[12] = r2_mod_prime
    ecc_fpga_constants[13] = int(1)
    ecc_fpga_constants[14] = elliptic_curve_order
    ecc_fpga_constants[15] = int(elliptic_curve_order).bit_length()
    
    const_a = elliptic_curve_const_a
    const_a2 = (elliptic_curve_const_a*elliptic_curve_const_a) % prime
    const_b3 = (elliptic_curve_const_b*3) % prime
    
    ecc_fpga_constants[16] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, const_a)
    ecc_fpga_constants[17] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, const_a2)
    ecc_fpga_constants[18] = sike_core_utils.enter_montgomery_domain(arithmetic_parameters, const_b3)
    
    ecc_fpga_constants[19] = const_a
    ecc_fpga_constants[20] = const_a2
    ecc_fpga_constants[21] = const_b3
    
    ecc_fpga_constants[22] = elliptic_curve_generator_point_x
    ecc_fpga_constants[23] = elliptic_curve_generator_point_y
    ecc_fpga_constants[24] = 1
    
    ecc_fpga_constants[25] = 224*(1024//extended_word_size)
    
    return ecc_fpga_constants

def print_fpga_constants(filename_constants, ecc_fpga_constants_all_parameters):
    with open(filename_constants, 'w') as file_constants:
        file_constants.write(filename_constants[0:-3] + ' = [\n')
        for ecc_fpga_constants in ecc_fpga_constants_all_parameters:
            file_constants.write('[\n')
            file_constants.write('# ' + ' Parameter name\n')
            file_constants.write('"' + ecc_fpga_constants[0] + '"' + ',\n')
            file_constants.write('# ' + ' base word size\n')
            file_constants.write(str(ecc_fpga_constants[1]) + ',\n')
            file_constants.write('# ' + ' extended word size\n')
            file_constants.write(str(ecc_fpga_constants[2]) + ',\n')
            file_constants.write('# ' + ' number of bits added\n')
            file_constants.write(str(ecc_fpga_constants[3]) + ',\n')
            file_constants.write('# ' + ' number of words\n')
            file_constants.write(str(ecc_fpga_constants[4]) + ',\n')
            file_constants.write('# ' + ' prime\n')
            file_constants.write(str(ecc_fpga_constants[5]) + ',\n')
            file_constants.write('# ' + ' prime size in bits\n')
            file_constants.write(str(ecc_fpga_constants[6]) + ',\n')
            file_constants.write('# ' + ' prime+1\n')
            file_constants.write(str(ecc_fpga_constants[7]) + ',\n')
            file_constants.write('# ' + " prime' = -1/prime mod r\n")
            file_constants.write(str(ecc_fpga_constants[8]) + ',\n')
            file_constants.write('# ' + ' prime plus one number of zeroes\n')
            file_constants.write(str(ecc_fpga_constants[9]) + ',\n')
            file_constants.write('# ' + ' 2*prime\n')
            file_constants.write(str(ecc_fpga_constants[10]) + ',\n')
            file_constants.write('# ' + ' r mod prime\n')
            file_constants.write(str(ecc_fpga_constants[11]) + ',\n')
            file_constants.write('# ' + ' r^2 mod prime\n')
            file_constants.write(str(ecc_fpga_constants[12]) + ',\n')
            file_constants.write('# ' + ' value 1\n')
            file_constants.write(str(ecc_fpga_constants[13]) + ',\n')
            file_constants.write('# ' + ' ECC curve order\n')
            file_constants.write(str(ecc_fpga_constants[14]) + ',\n')
            file_constants.write('# ' + ' ECC curve order bit length\n')
            file_constants.write(str(ecc_fpga_constants[15]) + ',\n')
            file_constants.write('# ' + ' ECC curve constant a  in Montgomery domain (*r mod prime)\n')
            file_constants.write(str(ecc_fpga_constants[16]) + ',\n')
            file_constants.write('# ' + ' ECC curve constant a^2 in Montgomery domain (*r mod prime) \n')
            file_constants.write(str(ecc_fpga_constants[17]) + ',\n')
            file_constants.write('# ' + ' ECC curve constant 3*b in Montgomery domain (*r mod prime) \n')
            file_constants.write(str(ecc_fpga_constants[18]) + ',\n')
            file_constants.write('# ' + ' ECC curve constant a  original\n')
            file_constants.write(str(ecc_fpga_constants[19]) + ',\n')
            file_constants.write('# ' + ' ECC curve constant a^2  original\n')
            file_constants.write(str(ecc_fpga_constants[20]) + ',\n')
            file_constants.write('# ' + ' ECC curve constant 3*b  original\n')
            file_constants.write(str(ecc_fpga_constants[21]) + ',\n')
            file_constants.write('# ' + ' ECC curve generator point x  original\n')
            file_constants.write(str(ecc_fpga_constants[22]) + ',\n')
            file_constants.write('# ' + ' ECC curve generator point y  original\n')
            file_constants.write(str(ecc_fpga_constants[23]) + ',\n')
            file_constants.write('# ' + ' ECC curve generator point z  original\n')
            file_constants.write(str(ecc_fpga_constants[24]) + ',\n')
            file_constants.write('# ' + ' ECC stack starting address\n')
            file_constants.write(str(ecc_fpga_constants[25]) + ',\n')
            file_constants.write('],\n')
        file_constants.write(']\n')

def generate_and_print_parameters(base_word_size, extended_word_size, number_of_bits_added, filename_constants):
    ecc_fpga_constants_all_parameters = []
    
    for param in ecc_constants.ecc_constants:
    
        prime = param[1]
        elliptic_curve_order = param[2]
        elliptic_curve_const_a = param[3]
        elliptic_curve_const_b = param[4]
        elliptic_curve_generator_point_x = param[5]
        elliptic_curve_generator_point_y = param[6]
        
        ecc_fpga_constants_all_parameters += [generate_fpga_constants(prime, elliptic_curve_order, elliptic_curve_const_a, elliptic_curve_const_b, elliptic_curve_generator_point_x, elliptic_curve_generator_point_y, base_word_size, extended_word_size, number_of_bits_added)]
        
    print_fpga_constants(filename_constants, ecc_fpga_constants_all_parameters)

generate_and_print_parameters(base_word_size = 16, extended_word_size = 256, number_of_bits_added = 9, filename_constants = 'ecc_fpga_constants_v256.py')
generate_and_print_parameters(base_word_size = 16, extended_word_size = 128, number_of_bits_added = 9, filename_constants = 'ecc_fpga_constants_v128.py')
