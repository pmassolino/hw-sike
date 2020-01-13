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
load(script_working_folder+"base_tests_for_sidh_v2/keygen_alice_fast.sage")
load(script_working_folder+"base_tests_for_sidh_v2/keygen_bob_fast.sage")
load(script_working_folder+"base_tests_for_sidh_v2/shared_secret_alice_fast.sage")
load(script_working_folder+"base_tests_for_sidh_v2/shared_secret_bob_fast.sage")
load(script_working_folder+"base_tests_for_sidh_v2/sidh_constants.sage")



number_of_bits_added = 8
base_word_size = 16
extended_word_size = 128
accumulator_word_size = extended_word_size_signed*2+32
number_of_tests = 10
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sidh_tests_v128/"

print('Generating Bob key generation')
VHDL_file_names = [tests_working_folder + "keygen_bob_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_keygen_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_keygen_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_keygen_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)

print('Generating Alice key generation')
VHDL_file_names = [tests_working_folder + "keygen_alice_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_keygen_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_keygen_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_keygen_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)

print('Generating Alice shared secret')
VHDL_file_names = [tests_working_folder + "shared_secret_alice_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_shared_secret_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_shared_secret_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_shared_secret_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)

print('Generating Bob shared secret')
VHDL_file_names = [tests_working_folder + "shared_secret_bob_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_shared_secret_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_shared_secret_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_shared_secret_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)


number_of_bits_added = 8
base_word_size = 16
extended_word_size = 256
accumulator_word_size = extended_word_size_signed*2+32
number_of_tests = 10
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sidh_tests_v256/"

print('Generating Bob key generation')
VHDL_file_names = [tests_working_folder + "keygen_bob_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_keygen_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_keygen_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_keygen_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)

print('Generating Alice key generation')
VHDL_file_names = [tests_working_folder + "keygen_alice_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_keygen_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_keygen_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_keygen_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)

print('Generating Alice shared secret')
VHDL_file_names = [tests_working_folder + "shared_secret_alice_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_shared_secret_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_shared_secret_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_shared_secret_alice_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)

print('Generating Bob shared secret')
VHDL_file_names = [tests_working_folder + "shared_secret_bob_fast_" + str(param[4]) + "_" + str(param[5]) + ".dat" for param in sidh_constants]
test_all_shared_secret_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants)
print_all_shared_secret_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, number_of_tests, sidh_constants, VHDL_file_names)
load_all_shared_secret_bob_fast(base_word_size, extended_word_size, number_of_bits_added, accumulator_word_size, sidh_constants, VHDL_file_names)
