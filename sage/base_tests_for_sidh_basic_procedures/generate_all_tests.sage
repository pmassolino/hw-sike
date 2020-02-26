proof.arithmetic(False)
home_folder = "/home/pedro/"
script_working_folder = home_folder + "hw-sidh/vhdl_project/sage/"
load(script_working_folder+"base_functions.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/fp_inv.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/fp2_inv.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/fp2_inv_2_way.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/xTPLe.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/xDBLe.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/ladder_3_pt.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/j_inv.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/get_A.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/get_4_isog.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/get_3_isog.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/get_2_isog.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/eval_4_isog.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/eval_3_isog.sage")
load(script_working_folder+"base_tests_for_sidh_basic_procedures/eval_2_isog.sage")


number_of_bits_added = 8
base_word_size_signed = 16
extended_word_size_signed = 128
accumulator_word_size = extended_word_size_signed*2+32
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sidh_tests_v128/"

primes = [2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1, 2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
oas = [2^(8), 2^(216), 2^(250), 2^(305), 2^(372), 2^(486)]
obs = [3^(5), 3^(137), 3^(159), 3^(192), 3^(239), 3^(301)]
max_repetition_values = [11, 11, 11, 11, 11, 11]
primes_file_name_end_without_dat = ["8_5", "216_137", "250_159", "305_192", "372_239", "486_301"]
primes_file_name_end = [each_file + ".dat" for each_file in primes_file_name_end_without_dat]

print('Generating fp inversion')
VHDL_fp_inv_file_names = [(tests_working_folder + "fp_inv_test_" + ending) for ending in primes_file_name_end]
test_all_fp_inv(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_fp_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_fp_inv_file_names, 100)
load_all_VHDL_fp_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_fp_inv_file_names)

print('Generating fp2 inversion')
VHDL_fp2_inv_file_names = [(tests_working_folder + "fp2_inv_test_" + ending) for ending in primes_file_name_end]
test_all_fp2_inv(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_fp2_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_fp2_inv_file_names, 100)
load_all_VHDL_fp2_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_fp2_inv_file_names)

print('Generating fp2 2 way inversion')
VHDL_inv_2_way_file_names = [(tests_working_folder + "inv_2_way_test_" + ending) for ending in primes_file_name_end]
test_all_inv_2_way(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_inv_2_way_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_inv_2_way_file_names, 100)
load_all_VHDL_inv_2_way_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_inv_2_way_file_names)

print('Generating xTPLe')
VHDL_xTPLe_file_names = [(tests_working_folder + "xTPLe_test_" + ending) for ending in primes_file_name_end]
test_all_xTPLe(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, max_repetition_values, 1000)
print_all_VHDL_xTPLe_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, max_repetition_values, VHDL_xTPLe_file_names, 100)
load_all_VHDL_xTPLe_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_xTPLe_file_names)

print('Generating xDBLe')
VHDL_xDBLe_file_names = [(tests_working_folder + "xDBLe_test_" + ending) for ending in primes_file_name_end]
test_all_xDBLe(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, max_repetition_values, 1000)
print_all_VHDL_xDBLe_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, max_repetition_values, VHDL_xDBLe_file_names, 100)
load_all_VHDL_xDBLe_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_xDBLe_file_names)

print('Generating ladder 3 pt')
VHDL_ladder_3_pt_file_names = [(tests_working_folder + "ladder_3_pt_test_" + ending) for ending in primes_file_name_end_without_dat]
test_all_ladder_3_pt(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, oas, obs, 100)
print_all_VHDL_ladder_3_pt_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, oas, obs, VHDL_ladder_3_pt_file_names, 100)
load_all_VHDL_ladder_3_pt_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_ladder_3_pt_file_names)

print('Generating j inversion')
VHDL_j_inv_file_names = [(tests_working_folder + "j_inv_test_" + ending) for ending in primes_file_name_end]
test_all_j_inv(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_j_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_j_inv_file_names, 100)
load_all_VHDL_j_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_j_inv_file_names)

print('Generating get A')
VHDL_get_A_file_names = [(tests_working_folder + "get_A_test_" + ending) for ending in primes_file_name_end]
test_all_get_A(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_get_A_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_A_file_names, 100)
load_all_VHDL_get_A_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_A_file_names)

print('Generating get 4 isogeny')
VHDL_get_4_isog_file_names = [(tests_working_folder + "get_4_isog_test_" + ending) for ending in primes_file_name_end]
test_all_get_4_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_get_4_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_4_isog_file_names, 100)
load_all_VHDL_get_4_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_4_isog_file_names)

print('Generating get 3 isogeny')
VHDL_get_3_isog_file_names = [(tests_working_folder + "get_3_isog_test_" + ending) for ending in primes_file_name_end]
test_all_get_3_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_get_3_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_3_isog_file_names, 100)
load_all_VHDL_get_3_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_3_isog_file_names)

print('Generating get 2 isogeny')
VHDL_get_2_isog_file_names = [(tests_working_folder + "get_2_isog_test_" + ending) for ending in primes_file_name_end]
test_all_get_2_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_get_2_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_2_isog_file_names, 100)
load_all_VHDL_get_2_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_2_isog_file_names)

print('Generating eval 4 isogeny')
VHDL_eval_4_isog_file_names = [(tests_working_folder + "eval_4_isog_test_" + ending) for ending in primes_file_name_end]
test_all_eval_4_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_eval_4_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_4_isog_file_names, 100)
load_all_VHDL_eval_4_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_4_isog_file_names)

print('Generating eval 3 isogeny')
VHDL_eval_3_isog_file_names = [(tests_working_folder + "eval_3_isog_test_" + ending) for ending in primes_file_name_end]
test_all_eval_3_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_eval_3_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_3_isog_file_names, 100)
load_all_VHDL_eval_3_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_3_isog_file_names)

print('Generating eval 2 isogeny')
VHDL_eval_2_isog_file_names = [(tests_working_folder + "eval_2_isog_test_" + ending) for ending in primes_file_name_end]
test_all_eval_2_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_eval_2_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_2_isog_file_names, 100)
load_all_VHDL_eval_2_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_2_isog_file_names)

number_of_bits_added = 8
base_word_size_signed = 16
extended_word_size_signed = 256
accumulator_word_size = extended_word_size_signed*2+32
tests_working_folder = home_folder + "hw-sidh/vhdl_project/hw_sidh_tests_v256/"

primes = [2^(8)*3^(5)-1, 2^(216)*3^(137)-1, 2^(250)*3^(159)-1, 2^(305)*3^(192)-1, 2^(372)*3^(239)-1, 2^(486)*3^(301)-1]
oas = [2^(8), 2^(216), 2^(250), 2^(305), 2^(372), 2^(486)]
obs = [3^(5), 3^(137), 3^(159), 3^(192), 3^(239), 3^(301)]
max_repetition_values = [11, 11, 11, 11, 11, 11]
primes_file_name_end_without_dat = ["8_5", "216_137", "250_159", "305_192", "372_239", "486_301"]
primes_file_name_end = [each_file + ".dat" for each_file in primes_file_name_end_without_dat]

print('Generating fp inversion')
VHDL_fp_inv_file_names = [(tests_working_folder + "fp_inv_test_" + ending) for ending in primes_file_name_end]
test_all_fp_inv(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_fp_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_fp_inv_file_names, 100)
load_all_VHDL_fp_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_fp_inv_file_names)

print('Generating fp2 inversion')
VHDL_fp2_inv_file_names = [(tests_working_folder + "fp2_inv_test_" + ending) for ending in primes_file_name_end]
test_all_fp2_inv(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_fp2_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_fp2_inv_file_names, 100)
load_all_VHDL_fp2_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_fp2_inv_file_names)

print('Generating fp2 2 way inversion')
VHDL_inv_2_way_file_names = [(tests_working_folder + "inv_2_way_test_" + ending) for ending in primes_file_name_end]
test_all_inv_2_way(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_inv_2_way_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_inv_2_way_file_names, 100)
load_all_VHDL_inv_2_way_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_inv_2_way_file_names)

print('Generating xTPLe')
VHDL_xTPLe_file_names = [(tests_working_folder + "xTPLe_test_" + ending) for ending in primes_file_name_end]
test_all_xTPLe(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, max_repetition_values, 1000)
print_all_VHDL_xTPLe_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, max_repetition_values, VHDL_xTPLe_file_names, 100)
load_all_VHDL_xTPLe_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_xTPLe_file_names)

print('Generating xDBLe')
VHDL_xDBLe_file_names = [(tests_working_folder + "xDBLe_test_" + ending) for ending in primes_file_name_end]
test_all_xDBLe(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, max_repetition_values, 1000)
print_all_VHDL_xDBLe_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, max_repetition_values, VHDL_xDBLe_file_names, 100)
load_all_VHDL_xDBLe_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_xDBLe_file_names)

print('Generating ladder 3 pt')
VHDL_ladder_3_pt_file_names = [(tests_working_folder + "ladder_3_pt_test_" + ending) for ending in primes_file_name_end_without_dat]
test_all_ladder_3_pt(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, oas, obs, 100)
print_all_VHDL_ladder_3_pt_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, oas, obs, VHDL_ladder_3_pt_file_names, 100)
load_all_VHDL_ladder_3_pt_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_ladder_3_pt_file_names)

print('Generating j inversion')
VHDL_j_inv_file_names = [(tests_working_folder + "j_inv_test_" + ending) for ending in primes_file_name_end]
test_all_j_inv(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_j_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_j_inv_file_names, 100)
load_all_VHDL_j_inv_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_j_inv_file_names)

print('Generating get A')
VHDL_get_A_file_names = [(tests_working_folder + "get_A_test_" + ending) for ending in primes_file_name_end]
test_all_get_A(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_get_A_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_A_file_names, 100)
load_all_VHDL_get_A_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_A_file_names)

print('Generating get 4 isogeny')
VHDL_get_4_isog_file_names = [(tests_working_folder + "get_4_isog_test_" + ending) for ending in primes_file_name_end]
test_all_get_4_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_get_4_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_4_isog_file_names, 100)
load_all_VHDL_get_4_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_4_isog_file_names)

print('Generating get 3 isogeny')
VHDL_get_3_isog_file_names = [(tests_working_folder + "get_3_isog_test_" + ending) for ending in primes_file_name_end]
test_all_get_3_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_get_3_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_3_isog_file_names, 100)
load_all_VHDL_get_3_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_3_isog_file_names)

print('Generating get 2 isogeny')
VHDL_get_2_isog_file_names = [(tests_working_folder + "get_2_isog_test_" + ending) for ending in primes_file_name_end]
test_all_get_2_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_get_2_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_2_isog_file_names, 100)
load_all_VHDL_get_2_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_get_2_isog_file_names)

print('Generating eval 4 isogeny')
VHDL_eval_4_isog_file_names = [(tests_working_folder + "eval_4_isog_test_" + ending) for ending in primes_file_name_end]
test_all_eval_4_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_eval_4_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_4_isog_file_names, 100)
load_all_VHDL_eval_4_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_4_isog_file_names)

print('Generating eval 3 isogeny')
VHDL_eval_3_isog_file_names = [(tests_working_folder + "eval_3_isog_test_" + ending) for ending in primes_file_name_end]
test_all_eval_3_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_eval_3_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_3_isog_file_names, 100)
load_all_VHDL_eval_3_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_3_isog_file_names)

print('Generating eval 2 isogeny')
VHDL_eval_2_isog_file_names = [(tests_working_folder + "eval_2_isog_test_" + ending) for ending in primes_file_name_end]
test_all_eval_2_isog(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, 1000)
print_all_VHDL_eval_2_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_2_isog_file_names, 100)
load_all_VHDL_eval_2_isog_test(base_word_size_signed, extended_word_size_signed, number_of_bits_added, accumulator_word_size, primes, VHDL_eval_2_isog_file_names)