# -*- coding: utf-8 -*-
#
# Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/
#
def generate_VHDL_instantiation_multiplication(temp_number, temp_range):
    temp_name = 'temp_mult_' + str(temp_number)
    final_string = 'signal ' + temp_name + ' : ' + 'std_logic_vector('
    final_string = final_string + str(temp_range[1]) + ' downto ' + str(temp_range[0]) + ');'
    return final_string

def generate_VHDL_instantiation_partial_product(partial_number, partial_range):
    temp_name = 'partial_product_' + str(partial_number)
    final_string = 'signal ' + temp_name + ' : ' + 'std_logic_vector('
    final_string = final_string + str(partial_range[1]) + ' downto ' + str(partial_range[0]) + ');'
    return final_string

def generate_VHDL_multiplication(temp_number, a_range, b_range):
    temp_name = 'temp_mult_' + str(temp_number)
    
    final_string = temp_name + ' <= ' + 'std_logic_vector('
    final_string = final_string + 'unsigned(' + 'a(' + str(a_range[1]) + ' downto ' + str(a_range[0]) + '))' + ' * ' + 'unsigned(' + 'b(' + str(b_range[1]) + ' downto ' + str(b_range[0]) + '))' + '); '
    return final_string

def generate_VHDL_partial_product_assoc(partial_number, partial_position, temp_number):
    partial_name = 'partial_product_' + str(partial_number) + '(' + str(partial_position) + ')'
    if(temp_number == None):
        temp_name = "'0'"
    else:
        temp_name = 'temp_mult_' + str(temp_number) + '(' + str(partial_position) + ')'
    final_string = partial_name + ' <= ' + temp_name + ';'
    return final_string

def add_multiplication(all_multiplications, a_range, b_range):
    all_multiplications += [[a_range[0], a_range[1], b_range[0], b_range[1], a_range[0] + b_range[0], a_range[1] + b_range[1] + 1]]
    return all_multiplications

def add_all_multiplications_256(all_multiplications):
    for j in range(0, 8):
        for i in range(0, 5):
            all_multiplications = add_multiplication(all_multiplications, [17*j, 17*j+16], [24*i, 24*i+23])
    
    for j in range(0, 5):
        for i in range(0, 8):
            all_multiplications = add_multiplication(all_multiplications, [24*j, 24*j+23], [17*i+120, 17*i+16+120])
    
    for j in range(0, 5):
        for i in range(0, 8):
            all_multiplications = add_multiplication(all_multiplications, [24*j+136, 24*j+23+136], [17*i, 17*i+16])
    
    for j in range(0, 8):
        for i in range(0, 5):
            all_multiplications = add_multiplication(all_multiplications, [17*j+120, 17*j+16+120], [24*i+136, 24*i+23+136])

    all_multiplications = add_multiplication(all_multiplications, [120, 135], [120, 135])

    return all_multiplications

def count_max_depth(all_multiplications, max_mult):
    max_depth = 0
    for i in range(0, max_mult):
        current_depth = 0
        for each_mult in all_multiplications:
            if((i >= each_mult[4]) and (i <= each_mult[5])):
                current_depth = current_depth + 1
        if(current_depth > max_depth):
            max_depth = current_depth
    return max_depth

def add_used_flag_on_multiplications(all_multiplications):
    all_multiplications_flag = []
    for each_multiplication in all_multiplications:
        all_multiplications_flag += [each_multiplication + [False]]
    return all_multiplications_flag

def check_if_all_multiplications_are_added(all_multiplications_for_partial_product):
    summed_flag = True
    for each_multiplication in all_multiplications_for_partial_product:
        summed_flag = summed_flag and each_multiplication[6]
    return summed_flag

def add_multiplications_to_partial_products(all_multiplications_for_partial_product, partial_products):
    for i in range(len(partial_products)):
        j = 0
        while(j < len(partial_products[i])):
            z = 0
            while(z < len(all_multiplications_for_partial_product)):
                if((all_multiplications_for_partial_product[z][6] == False) and (j == all_multiplications_for_partial_product[z][4])):
                    break
                z = z + 1
            if(z != len(all_multiplications_for_partial_product)):
                while(j <= all_multiplications_for_partial_product[z][5]):
                    partial_products[i][j] = z
                    j = j + 1
                all_multiplications_for_partial_product[z][6] = True
            else:
                j = j + 1
    return partial_products


max_multiplication_size = 512

all_multiplications = []

all_multiplications = add_all_multiplications_256(all_multiplications)

max_depth_multiplications = count_max_depth(all_multiplications, max_multiplication_size)

all_multiplications_for_partial_product = add_used_flag_on_multiplications(all_multiplications)

partial_products = [0 for i in range(max_depth_multiplications)]

for i in range(len(partial_products)):
    partial_products[i] = [None for j in range(max_multiplication_size+1)]

partial_products = add_multiplications_to_partial_products(all_multiplications_for_partial_product, partial_products)

for i, each_mult in enumerate(all_multiplications):
    print(generate_VHDL_instantiation_multiplication(i, each_mult[4:6]))

for i, each_partial in enumerate(partial_products):
    print(generate_VHDL_instantiation_partial_product(i, [0, 512]))

print('begin')

for i, each_mult in enumerate(all_multiplications):
    print(generate_VHDL_multiplication(i, each_mult[0:2], each_mult[2:4]))

for i, each_partial in enumerate(partial_products):
    for j in range(len(each_partial)):
        print(generate_VHDL_partial_product_assoc(i, j, each_partial[j]))

