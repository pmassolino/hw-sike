proof.arithmetic(False)
home_folder = "/home/pedro/"
script_working_folder = home_folder + "hw-sidh/vhdl_project/sage/"
load(script_working_folder+"base_tests_for_sike_v2/keygen_sike.sage")
load(script_working_folder+"base_tests_for_sike_v2/enc_sike.sage")
load(script_working_folder+"base_tests_for_sike_v2/dec_sike.sage")
load(script_working_folder+"base_tests_for_sidh_v2/sidh_constants.sage")

number_of_bits_added = 8
base_word_size = 16
extended_word_size = 128
accumulator_word_size = extended_word_size*2+32
number_of_tests = 10
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sike_tests_v128/"

print('Generating key tests')
VHDL_file_names = [tests_working_folder + "keygen_sike_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_keygen_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_keygen_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_keygen_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)

print('Generating encryption tests')
VHDL_file_names = [tests_working_folder + "enc_sike_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_enc_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_enc_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_enc_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)

print('Generating decryption tests')
VHDL_file_names = [tests_working_folder + "dec_sike_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_dec_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_dec_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_dec_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)

number_of_bits_added = 8
base_word_size = 16
extended_word_size = 256
accumulator_word_size = extended_word_size*2+32
number_of_tests = 10
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sike_tests_v256/"

print('Generating key tests')
VHDL_file_names = [tests_working_folder + "keygen_sike_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_keygen_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_keygen_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_keygen_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)

print('Generating encryption tests')
VHDL_file_names = [tests_working_folder + "enc_sike_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_enc_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_enc_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_enc_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)

print('Generating decryption tests')
VHDL_file_names = [tests_working_folder + "dec_sike_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_dec_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_dec_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_dec_sike(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)
