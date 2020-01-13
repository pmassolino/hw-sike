# -*- coding: utf-8 -*-
#
# Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/
#

import sys
import os
import tempfile

def instruction_nop(command, internal_labels, final_pass=True):
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0000000'
    machine_code_operand_o = '00000000000000000'
    machine_code_operand_b = '0000000000000000000'
    machine_code_operand_a = '0000000000000000000'
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_jumpeq(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0000001'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0] == '#'):
        if(command[1][1] == '('):
            multiplicative_factor, constant = command[1][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[1][1:]
        if(constant in internal_labels):
            machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):    
            machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[0] == 'jump'):
        machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format(int(0))
        machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format(int(0))
    else:
        if(command[2] in internal_labels):
            machine_code_operand_b = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
        elif(command[2][0:3] == '*rd'):
            machine_code_operand_b = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(internal_labels[command[2]])
        elif(command[2][0:3] == '*rm'):
            machine_code_operand_b = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(internal_labels[command[2]])
        elif(command[2][0:3] == '*rl'):
            machine_code_operand_b = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(internal_labels[command[2]])
        elif(command[2][0] == '#'):
            if(command[2][1] == '('):
                multiplicative_factor, constant = command[2][2:].split(')', 1)
                multiplicative_factor = int(multiplicative_factor)
            else:
                multiplicative_factor = 1
                constant = command[2][1:]
            if(constant in internal_labels):
                machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
            elif(constant.isdigit()):
                machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
            else:
                error_during_assembly = True
        else:
            error_during_assembly = True
        if(command[3] in internal_labels):
            machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[3]])
        elif(command[3][0:3] == '*rd'):
            machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(internal_labels[command[3]])
        elif(command[3][0:3] == '*rm'):
            machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(internal_labels[command[3]])
        elif(command[3][0:3] == '*rl'):
            machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(internal_labels[command[3]])
        elif(command[3][0] == '#'):
            if(command[3][1] == '('):
                multiplicative_factor, constant = command[3][2:].split(')', 1)
                multiplicative_factor = int(multiplicative_factor)
            else:
                multiplicative_factor = 1
                constant = command[3][1:]
            if(constant in internal_labels):
                machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
            elif(constant.isdigit()):
                machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
            else:
                error_during_assembly = True
        else:
            error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions

def instruction_jumpl(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0000010'
    if(command[0] == 'jumpl'):
        machine_code_operand_b_signed = "0"
        machine_code_operand_a_signed = "0"
    elif(command[0] == 'jumpls'):
        machine_code_operand_b_signed = "1"
        machine_code_operand_a_signed = "1"
    else:
        error_during_assembly = True
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0] == '#'):
        if(command[1][1] == '('):
            multiplicative_factor, constant = command[1][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[1][1:]
        if(constant in internal_labels):
            machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_b = machine_code_operand_b_signed + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_b = machine_code_operand_b_signed + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_b = machine_code_operand_b_signed + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_b = machine_code_operand_b_signed + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(internal_labels[command[2]])
    elif(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_b = machine_code_operand_b_signed + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*constant)
        elif(constant.isdigit()):
            machine_code_operand_b = machine_code_operand_b_signed + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[3] in internal_labels):
        machine_code_operand_a = machine_code_operand_a_signed + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rd'):
        machine_code_operand_a = machine_code_operand_a_signed + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rm'):
        machine_code_operand_a = machine_code_operand_a_signed + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rl'):
        machine_code_operand_a = machine_code_operand_a_signed + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(internal_labels[command[3]])
    elif(command[3][0] == '#'):
        if(command[3][1] == '('):
            multiplicative_factor, constant = command[3][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[3][1:]
        if(constant in internal_labels):
            machine_code_operand_a = machine_code_operand_a_signed + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = machine_code_operand_a_signed + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_jumpeql(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0000011'
    if(command[0] == 'jumpeql'):
        machine_code_operand_b_signed = "0"
        machine_code_operand_a_signed = "0"
    elif(command[0] == 'jumpeqls'):
        machine_code_operand_b_signed = "1"
        machine_code_operand_a_signed = "1"
    else:
        error_during_assembly = True
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0] == '#'):
        if(command[1][1] == '('):
            multiplicative_factor, constant = command[1][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[1][1:]
        if(constant in internal_labels):
            machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):       
            machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_b = machine_code_operand_b_signed + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_b = machine_code_operand_b_signed + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_b = machine_code_operand_b_signed + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_b = machine_code_operand_b_signed + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(internal_labels[command[2]])
    elif(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_b = machine_code_operand_b_signed + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*constant)
        elif(constant.isdigit()):
            machine_code_operand_b = machine_code_operand_b_signed + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[3] in internal_labels):
        machine_code_operand_a = machine_code_operand_a_signed + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rd'):
        machine_code_operand_a = machine_code_operand_a_signed + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rm'):
        machine_code_operand_a = machine_code_operand_a_signed + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rl'):
        machine_code_operand_a = machine_code_operand_a_signed + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(internal_labels[command[3]])
    elif(command[3][0] == '#'):
        if(command[3][1] == '('):
            multiplicative_factor, constant = command[3][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[3][1:]
        if(constant in internal_labels):
            machine_code_operand_a = machine_code_operand_a_signed + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = machine_code_operand_a_signed + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions

def instruction_push(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0000100'
    machine_code_operand_o = '00000000000000000'
    machine_code_operand_b = '0000000000000000000'
    if(command[1] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0] == '#'):
        if(command[1][1] == '('):
            multiplicative_factor, constant = command[1][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[1][1:]
        if(constant in internal_labels):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions

def instruction_pop(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0000101'
    machine_code_operand_a = '0000000000000000000'
    machine_code_operand_b = '0000000000000000000'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_pushf(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0000110'
    machine_code_operand_o = '00000000000000000'
    machine_code_operand_b = '0000000000000000000'
    if(command[1] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_popf(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0000111'
    machine_code_operand_a = '0000000000000000000'
    machine_code_operand_b = '0000000000000000000'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_pushm(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0001000'
    machine_code_operand_o = '00000000000000000'
    machine_code_operand_b = '0000000000000000000'
    if(command[1] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(13)+"b}").format(internal_labels[command[1]]) + "000"
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_popm(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0001001'
    machine_code_operand_a = '0000000000000000000'
    machine_code_operand_b = '0000000000000000000'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(13)+"b}").format(internal_labels[command[1]]) + "000"
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_copy(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0001010'
    machine_code_operand_b = '0000000000000000000'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_copyf(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0001011'
    machine_code_operand_b = '0000000000000000000'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_copym(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0001100'
    machine_code_operand_b = '0000000000000000000'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(13)+"b}").format(internal_labels[command[1]]) + "000"
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(13)+"b}").format(internal_labels[command[2]]) + "000"
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions

def instruction_copya(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    if(command[1] == 'inc'):
        if(command[2] == 'r'):
            machine_code_intruction_type = '0011011'
        elif(command[2] == 'd'):
            machine_code_intruction_type = '0011001'
        elif(command[2] == 's'):
            machine_code_intruction_type = '0011010'
        elif(command[2] == 'ds'):
            machine_code_intruction_type = '0011000'
        else:
            error_during_assembly = True
    elif(command[1] == 'dec'):
        if(command[2] == 'r'):
            machine_code_intruction_type = '0011111'
        elif(command[2] == 'd'):
            machine_code_intruction_type = '0011101'
        elif(command[2] == 's'):
            machine_code_intruction_type = '0011110'
        elif(command[2] == 'ds'):
            machine_code_intruction_type = '0011100'
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[3] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    else:
        error_during_assembly = True
    if(command[4] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[4]])
    elif(command[4][0] == '#'):
        if(command[4][1] == '('):
            multiplicative_factor, constant = command[4][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[4][1:]
        if(constant in internal_labels):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    elif(command[4][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[4][3:]))
    elif(command[4][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[4][3:]))
    elif(command[4][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[4][3:]))
    else:
        error_during_assembly = True
    if(command[5] in internal_labels):
        machine_code_operand_b = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[5]])
    elif(command[5][0] == '#'):
        if(command[5][1] == '('):
            multiplicative_factor, constant = command[5][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[5][1:]
        if(constant in internal_labels):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    elif(command[5][0:3] == '*rd'):
        machine_code_operand_b = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[5][3:]))
    elif(command[5][0:3] == '*rm'):
        machine_code_operand_b = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[5][3:]))
    elif(command[5][0:3] == '*rl'):
        machine_code_operand_b = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[5][3:]))
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions

def instruction_lconstf(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0001101'
    machine_code_operand_b = '0000000000000000000'
    machine_code_operand_a = '0000000000000000000'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_lconstm(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0001110'
    machine_code_operand_b = '0000000000000000000'
    machine_code_operand_a = '0000000000000000000'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(13)+"b}").format(internal_labels[command[1]]) + "000"
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions

def instruction_call(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0001111'
    machine_code_operand_b = '0000000000000000000'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1].isdigit()):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(int(command[1]))
    else:
        error_during_assembly = True
    machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels['pc'])
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print(command[1])
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_ret(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0010000'
    machine_code_operand_o = '00000000000000000'
    machine_code_operand_b = '0000000000000000000'
    machine_code_operand_a = '0000000000000000000'
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions

def instruction_keccak_init(command, internal_labels, final_pass=True):
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0010010'
    machine_code_operand_o = '00000000000000000'
    machine_code_operand_b = '0000000000000000000'
    machine_code_operand_a = '0000000000000000000'
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions

def instruction_keccak_go(command, internal_labels, final_pass=True):
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0010011'
    machine_code_operand_o = '00000000000000000'
    machine_code_operand_b = '0000000000000000000'
    machine_code_operand_a = '0000000000000000000'
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions

def instruction_badd(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0100000'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_b = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_b = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_b = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_b = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[3] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0] == '#'):
        if(command[3][1] == '('):
            multiplicative_factor, constant = command[3][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[3][1:]
        if(constant in internal_labels):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_bsub(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0100001'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_b = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_b = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_b = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_b = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[3] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0] == '#'):
        if(command[3][1] == '('):
            multiplicative_factor, constant = command[3][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[3][1:]
        if(constant in internal_labels):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_bsmul(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0100010'
    if(command[0] == 'bsmul'):
        machine_code_operand_b_signed = "0"
        machine_code_operand_a_signed = "0"
    elif(command[0] == 'bsmuls'):
        machine_code_operand_b_signed = "1"
        machine_code_operand_a_signed = "1"
    else:
        error_during_assembly = True
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_b = machine_code_operand_b_signed + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_b = machine_code_operand_b_signed + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_b = machine_code_operand_b_signed + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_b = machine_code_operand_b_signed + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_b = machine_code_operand_b_signed + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_b = machine_code_operand_b_signed + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[3] in internal_labels):
        machine_code_operand_a = machine_code_operand_a_signed + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rd'):
        machine_code_operand_a = machine_code_operand_a_signed + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rm'):
        machine_code_operand_a = machine_code_operand_a_signed + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rl'):
        machine_code_operand_a = machine_code_operand_a_signed + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0] == '#'):
        if(command[3][1] == '('):
            multiplicative_factor, constant = command[3][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[3][1:]
        if(constant in internal_labels):
            machine_code_operand_a = machine_code_operand_a_signed + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = machine_code_operand_a_signed + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_bshift(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    if(command[0] == 'bshiftr'):
        machine_code_intruction_type = '0100100'
    elif(command[0] == 'bshiftl'):
        machine_code_intruction_type = '0100110'
    else:
        error_during_assembly = True
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_b = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_b = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_b = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_b = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[3] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0] == '#'):
        if(command[3][1] == '('):
            multiplicative_factor, constant = command[3][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[3][1:]
        if(constant in internal_labels):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_brot(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    if(command[0] == 'brotr'):
        machine_code_intruction_type = '0100101'
    elif(command[0] == 'brotl'):
        machine_code_intruction_type = '0100111'
    else:
        error_during_assembly = True
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_b = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_b = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_b = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_b = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[3] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0] == '#'):
        if(command[3][1] == '('):
            multiplicative_factor, constant = command[3][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[3][1:]
        if(constant in internal_labels):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_bland(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0101000'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_b = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_b = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_b = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_b = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[3] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0] == '#'):
        if(command[3][1] == '('):
            multiplicative_factor, constant = command[3][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[3][1:]
        if(constant in internal_labels):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def instruction_blor(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0101001'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_b = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_b = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_b = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_b = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[3] in internal_labels):
        machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[3]])
    elif(command[3][0:3] == '*rd'):
        machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rm'):
        machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0:3] == '*rl'):
        machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
    elif(command[3][0] == '#'):
        if(command[3][1] == '('):
            multiplicative_factor, constant = command[3][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[3][1:]
        if(constant in internal_labels):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions

def instruction_blxor(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0101010'
    if(command[1] in internal_labels):
        machine_code_operand_o = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[command[1]])
    elif(command[1][0:3] == '*rd'):
        machine_code_operand_o = "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rm'):
        machine_code_operand_o = "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    elif(command[1][0:3] == '*rl'):
        machine_code_operand_o = "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[1][3:]))
    else:
        error_during_assembly = True
    if(command[2] in internal_labels):
        machine_code_operand_b = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[2]])
    elif(command[2][0:3] == '*rd'):
        machine_code_operand_b = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rm'):
        machine_code_operand_b = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0:3] == '*rl'):
        machine_code_operand_b = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[2][3:]))
    elif(command[2][0] == '#'):
        if(command[2][1] == '('):
            multiplicative_factor, constant = command[2][2:].split(')', 1)
            multiplicative_factor = int(multiplicative_factor)
        else:
            multiplicative_factor = 1
            constant = command[2][1:]
        if(constant in internal_labels):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
        elif(constant.isdigit()):
            machine_code_operand_b = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
        else:
            error_during_assembly = True
    else:
        error_during_assembly = True
    if(command[0] == 'blnot'):
        machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format(2**16-1)
    else:
        if(command[3] in internal_labels):
            machine_code_operand_a = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[command[3]])
        elif(command[3][0:3] == '*rd'):
            machine_code_operand_a = "0" + "1" + "1" + '00' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
        elif(command[3][0:3] == '*rm'):
            machine_code_operand_a = "0" + "1" + "1" + '10' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
        elif(command[3][0:3] == '*rl'):
            machine_code_operand_a = "0" + "1" + "1" + '11' + ("{0:0"+str(14)+"b}").format(int(command[3][3:]))
        elif(command[3][0] == '#'):
            if(command[3][1] == '('):
                multiplicative_factor, constant = command[3][2:].split(')', 1)
                multiplicative_factor = int(multiplicative_factor)
            else:
                multiplicative_factor = 1
                constant = command[3][1:]
            if(constant in internal_labels):
                machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((internal_labels[constant])*multiplicative_factor)
            elif(constant.isdigit()):
                machine_code_operand_a = "0" + "0" + "0" + ("{0:0"+str(16)+"b}").format((int(constant))*multiplicative_factor)
            else:
                error_during_assembly = True
        else:
            error_during_assembly = True
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions

def instruction_fin(command, internal_labels, final_pass=True):
    number_of_instructions = 1
    machine_code_processor = '00'
    machine_code_intruction_type = '0111111'
    machine_code_operand_o = '00000000000000000'
    machine_code_operand_b = '0000000000000000000'
    machine_code_operand_a = '0000000000000000000'
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o + machine_code_operand_b + machine_code_operand_a
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    return machine_code, number_of_instructions
    
def intruction_mmuld(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 0
    machine_code_processor = '01'
    machine_code_intruction_type = '0000000'
    machine_code_operand_o = ['00000000000000000' for i in range(8)]
    machine_code_operand_b = ['0000000000000000000' for i in range(8)]
    machine_code_operand_a = ['0000000000000000000' for i in range(8)]
    all_operands = command[1:]
    i = 0
    j = 0
    while((i < len(all_operands))):
        if(all_operands[i] in internal_labels):
            machine_code_operand_o[j] = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_o[j] = "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_o[j] = "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_o[j] = "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        if(all_operands[i] in internal_labels):
            machine_code_operand_b[j] = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_b[j] = "0" + "1" + "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_b[j] = "0" + "1" + "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_b[j] = "0" + "1" + "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        if(all_operands[i] in internal_labels):
            machine_code_operand_a[j] = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_a[j] = "0" + "1" + "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_a[j] = "0" + "1" + "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_a[j] = "0" + "1" + "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        j += 1
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    final_machine_code = ''
    for i in range(7):
        machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o[i] + machine_code_operand_b[i] + machine_code_operand_a[i]
        #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
        final_machine_code = final_machine_code + machine_code + '\n'
        number_of_instructions += 1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o[7] + machine_code_operand_b[7] + machine_code_operand_a[7]
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    final_machine_code = final_machine_code + machine_code
    number_of_instructions += 1
    return final_machine_code, number_of_instructions
    
def intruction_msqud(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 0
    machine_code_processor = '01'
    machine_code_intruction_type = '0000001'
    machine_code_operand_o = ['00000000000000000' for i in range(8)]
    machine_code_operand_b = ['0000000000000000000' for i in range(8)]
    machine_code_operand_a = ['0000000000000000000' for i in range(8)]
    all_operands = command[1:]
    i = 0
    j = 0
    while((i < len(all_operands))):
        if(all_operands[i] in internal_labels):
            machine_code_operand_o[j] = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_o[j] = "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_o[j] = "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_o[j] = "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        if(all_operands[i] in internal_labels):
            machine_code_operand_b[j] = machine_code_operand_a[j] = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_b[j] = machine_code_operand_a[j] = "0" + "1" + "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_b[j] = machine_code_operand_a[j] = "0" + "1" + "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_b[j] = machine_code_operand_a[j] = "0" + "1" + "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        j += 1
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    final_machine_code = ''
    for i in range(7):
        machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o[i] + machine_code_operand_b[i] + machine_code_operand_a[i]
        #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
        final_machine_code = final_machine_code + machine_code + '\n'
        number_of_instructions += 1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o[7] + machine_code_operand_b[7] + machine_code_operand_a[7]
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    final_machine_code = final_machine_code + machine_code
    number_of_instructions += 1
    return final_machine_code, number_of_instructions
    
def intruction_mmulm(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 0
    machine_code_processor = '01'
    machine_code_intruction_type = '0000010'
    machine_code_operand_o = ['00000000000000000' for i in range(8)]
    machine_code_operand_b = ['0000000000000000000' for i in range(8)]
    machine_code_operand_a = ['0000000000000000000' for i in range(8)]
    last_operand = len(command)
    all_operands = command[1:last_operand]
    i = 0
    j = 0
    while((i < len(all_operands))):
        if(all_operands[i] in internal_labels):
            machine_code_operand_o[j] = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_o[j] = "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_o[j] = "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_o[j] = "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        if(all_operands[i] in internal_labels):
            machine_code_operand_b[j] = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_b[j] = "0" + "1" + "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_b[j] = "0" + "1" + "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_b[j] = "0" + "1" + "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        if(all_operands[i] in internal_labels):
            machine_code_operand_a[j] = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_a[j] = "0" + "1" + "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_a[j] = "0" + "1" + "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_a[j] = "0" + "1" + "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        j += 1
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    final_machine_code = ''
    for i in range(7):
        machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o[i] + machine_code_operand_b[i] + machine_code_operand_a[i]
        #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
        final_machine_code = final_machine_code + machine_code + '\n'
        number_of_instructions += 1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o[7] + machine_code_operand_b[7] + machine_code_operand_a[7]
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    final_machine_code = final_machine_code + machine_code
    number_of_instructions += 1
    return final_machine_code, number_of_instructions
    
def intruction_msqum(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 0
    machine_code_processor = '01'
    machine_code_intruction_type = '0000011'
    machine_code_operand_o = ['00000000000000000' for i in range(8)]
    machine_code_operand_b = ['0000000000000000000' for i in range(8)]
    machine_code_operand_a = ['0000000000000000000' for i in range(8)]
    last_operand = len(command)
    all_operands = command[1:last_operand]
    i = 0
    j = 0
    while((i < len(all_operands))):
        if(all_operands[i] in internal_labels):
            machine_code_operand_o[j] = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_o[j] = "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_o[j] = "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_o[j] = "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        if(all_operands[i] in internal_labels):
            machine_code_operand_b[j] = machine_code_operand_a[j] = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_b[j] = machine_code_operand_a[j] = "0" + "1" + "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_b[j] = machine_code_operand_a[j] = "0" + "1" + "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_b[j] = machine_code_operand_a[j] = "0" + "1" + "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        j += 1
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    final_machine_code = ''
    for i in range(7):
        machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o[i] + machine_code_operand_b[i] + machine_code_operand_a[i]
        #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
        final_machine_code = final_machine_code + machine_code + '\n'
        number_of_instructions += 1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o[7] + machine_code_operand_b[7] + machine_code_operand_a[7]
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    final_machine_code = final_machine_code + machine_code
    number_of_instructions += 1
    return final_machine_code, number_of_instructions
    
def instruction_madd_subd(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 0
    machine_code_processor = '01'
    machine_code_intruction_type = '0000100'
    machine_code_operand_o = ['00000000000000000' for i in range(4)]
    machine_code_operand_b = ['0000000000000000000' for i in range(4)]
    machine_code_operand_a = ['0000000000000000000' for i in range(4)]
    all_operands = command[1:]
    i = 0
    j = 0
    while((i < len(all_operands))):
        if(all_operands[i] in internal_labels):
            machine_code_operand_o[j] = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_o[j] = "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_o[j] = "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_o[j] = "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        if(all_operands[i] in internal_labels):
            machine_code_operand_b[j] = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_b[j] = "0" + "1" + "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_b[j] = "0" + "1" + "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_b[j] = "0" + "1" + "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        if(all_operands[i][0] == '+'):
            machine_code_operand_a_sign = "1"
        elif(all_operands[i][0] == '-'):
            machine_code_operand_a_sign = "0"
        else:
            error_during_assembly = True
        i += 1
        if(all_operands[i] in internal_labels):
            machine_code_operand_a[j] = machine_code_operand_a_sign + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_a[j] = machine_code_operand_a_sign + "1" + "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_a[j] = machine_code_operand_a_sign + "1" + "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_a[j] = machine_code_operand_a_sign + "1" + "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        j += 1
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    final_machine_code = ''
    for i in range(3):
        machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o[i] + machine_code_operand_b[i] + machine_code_operand_a[i]
        #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
        final_machine_code = final_machine_code + machine_code + '\n'
        number_of_instructions += 1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o[3] + machine_code_operand_b[3] + machine_code_operand_a[3]
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    final_machine_code = final_machine_code + machine_code
    number_of_instructions += 1
    return final_machine_code, number_of_instructions
    
def instruction_mitred(command, internal_labels, final_pass=True):
    error_during_assembly = False
    number_of_instructions = 0
    machine_code_processor = '01'
    machine_code_intruction_type = '0000101'
    machine_code_operand_o = ['00000000000000000' for i in range(4)]
    machine_code_operand_b = ['0000000000000000000' for i in range(4)]
    machine_code_operand_a = ['0000000000000000000' for i in range(4)]
    last_operand = len(command)
    all_operands = command[1:last_operand]
    i = 0
    j = 0
    while((i < len(all_operands))):
        if(all_operands[i] in internal_labels):
            machine_code_operand_o[j] = "0" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_o[j] = "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_o[j] = "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_o[j] = "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        if(all_operands[i] in internal_labels):
            machine_code_operand_a[j] = "0" + "0" + "1" + ("{0:0"+str(16)+"b}").format(internal_labels[all_operands[i]])
        elif(all_operands[i][0:3] == '*rd'):
            machine_code_operand_a[j] = "0" + "1" + "1" + "00" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rm'):
            machine_code_operand_a[j] = "0" + "1" + "1" + "10" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        elif(all_operands[i][0:3] == '*rl'):
            machine_code_operand_a[j] = "0" + "1" + "1" + "11" + ("{0:0"+str(14)+"b}").format(int(all_operands[i][3:]))
        else:
            error_during_assembly = True
        i += 1
        j += 1
    if(error_during_assembly):
        if(not final_pass):
            return "", number_of_instructions
        else:
            print("Invalid instruction")
            print(command)
            return -1
    final_machine_code = ''
    for i in range(3):
        machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o[i] + machine_code_operand_b[i] + machine_code_operand_a[i]
        #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
        final_machine_code = final_machine_code + machine_code + '\n'
        number_of_instructions += 1
    machine_code = machine_code_processor + machine_code_intruction_type + machine_code_operand_o[3] + machine_code_operand_b[3] + machine_code_operand_a[3]
    #machine_code = ("{0:0"+str(64-64)+"b}").format(0) + machine_code
    final_machine_code = final_machine_code + machine_code
    number_of_instructions += 1
    return final_machine_code, number_of_instructions

instruction_opcodes = {'nop':instruction_nop,'jump':instruction_jumpeq,'jumpeq':instruction_jumpeq,'jumpl':instruction_jumpl,'jumpls':instruction_jumpl, 'jumpeql':instruction_jumpeql, 'jumpeqls':instruction_jumpeql,'push':instruction_push,'pop':instruction_pop,'pushf':instruction_pushf,'popf':instruction_popf,'pushm':instruction_pushm,'popm':instruction_popm,'copy':instruction_copy,'copyf':instruction_copyf,'copym':instruction_copym,'copya':instruction_copya,'lconstf':instruction_lconstf,'lconstm':instruction_lconstm,'call':instruction_call,'ret':instruction_ret,'keccak_init':instruction_keccak_init,'keccak_go':instruction_keccak_go,'badd':instruction_badd,'bsub':instruction_bsub,'bsmul':instruction_bsmul,'bsmuls':instruction_bsmul,'bshiftr':instruction_bshift,'bshiftl':instruction_bshift,'brotr':instruction_brot,'brotl':instruction_brot,'bland':instruction_bland,'blor':instruction_blor,'blxor':instruction_blxor,'blnot':instruction_blxor,'fin':instruction_fin,'mmuld':intruction_mmuld,'msqud':intruction_msqud,'mmulm':intruction_mmulm,'msqum':intruction_msqum,'madd_subd':instruction_madd_subd,'mitred':instruction_mitred}

def remove_coments(line):
    # Remove anything that is after the character ';' (.split(';')[0])
    # Remove any white space that has been added in both the beginning and end of the string (.strip())
    return line.split(';')[0].strip()

def change_all_to_lowercase(line):
    return line.lower()

def check_label_and_add_to_dicionary(line, internal_labels, program_counter, enable_show_program_labels):
    if(':' in line):
        # Only the first ':' is assigned, the remaining are kept, even though the current syntax does not permit.
        new_line = line.split(':', 1)
        label = new_line[0].strip()
        internal_labels[label] = program_counter
        if(enable_show_program_labels):
            print("Label : " + label + " at = " + str(program_counter))
        new_line = new_line[1].strip() + "\n"
    else:
        new_line = line
    return new_line

#    
# First pass of assembly operation:
# - Remove all comments
# - Change all letters case to lower.
#   
def assembly_file_remove_comments_change_to_lower_case(input_file, output_file):
    for line in input_file:
        line_without_comments = remove_coments(line)
        # Only execute if the line still has any command.
        if(line_without_comments):
            line_lower_no_comments = change_all_to_lowercase(line_without_comments)
            output_file.write(line_lower_no_comments + '\n')
                  
#    
# Second pass of assembly operation:
# - Solve constant labels
#   
def assembly_file_add_constant_labels(input_file, output_file, internal_labels):
    for line in input_file:
        if(':' in line):
            line_without_spaces = line.strip()
            line_with_label = line_without_spaces.split(':', 1)
            if(line_with_label[1].isdigit()):
                label = line_with_label[0].strip()
                internal_labels[label] = int(line_with_label[1])
            else:
                output_file.write(line)
        else:
            output_file.write(line)
#    
# Third pass of assembly operation:
# - Solve instructions with no label and write them in assembly
# - Find label positions and add them to a dictionary
#                       
def assembly_file_solve_instructions_add_position_labels(input_file, output_file, internal_labels, enable_show_program_labels):
    program_counter = 0
    for line in input_file:
        line_without_labels = check_label_and_add_to_dicionary(line, internal_labels, program_counter, enable_show_program_labels)
        command = line_without_labels.split()
        if((len(command) == 0) or (not (command[0] in instruction_opcodes))):
            print("Not supported opcode")
            print(line)
            return -1
        mounted_command, number_of_instructions = instruction_opcodes[command[0]](command, internal_labels, False)
        program_counter += number_of_instructions
        if(mounted_command != ""):
            size_command_correct = True
            for separate_mounted_command in mounted_command.splitlines():
                if(((len(separate_mounted_command) % 64) != 0)):
                    print("Wrong instruction size (" + str(len(mounted_command)) + ")")
                    print('1')
                    print(command)
                    size_command_correct = False
            if(size_command_correct):
                output_file.write(mounted_command + '\n')
        else:
            output_file.write(line_without_labels)

#    
# Fourth pass of assembly operation:
# - Solve remaining instructions.
#                   
def assembly_file_solve_remaining_instructions(input_file, output_file, internal_labels):
    program_counter = 0
    for line in input_file:
            command = line.split()
            if(command[0] in instruction_opcodes):
                mounted_command, number_of_instructions = instruction_opcodes[command[0]](command, internal_labels)
                program_counter += number_of_instructions
                mounted_command = mounted_command + '\n'
            else:
                mounted_command = line
                program_counter += 1
            if(len(mounted_command) != 65):
                print("Wrong instruction size (" + str(len(mounted_command)) + ")")
                print("2")
                print(command)
                return -1
            else:
                output_file.write(mounted_command)
    print("Program size in terms of instructions = " +  str(program_counter))
    
def assembly_file_four_pass(input_file_name, output_file_name, enable_intermediate_files=False, enable_show_program_labels=False):
    program_counter = 0
    internal_labels = dict()
    fill_internal_labels(internal_labels)
    with open(output_file_name, 'w') as output_file, open(input_file_name, 'r') as input_file:
        if(enable_intermediate_files):
            output_file_first_pass = open(output_file_name + '_temp_first_pass.dat', 'w+')
            output_file_second_pass = open(output_file_name + '_temp_second_pass.dat', 'w+')
            output_file_third_pass = open(output_file_name + '_temp_third_pass.dat', 'w+')
        else:
            output_file_first_pass = tempfile.TemporaryFile(mode='r+')
            output_file_second_pass = tempfile.TemporaryFile(mode='r+')
            output_file_third_pass = tempfile.TemporaryFile(mode='r+')
        assembly_file_remove_comments_change_to_lower_case(input_file, output_file_first_pass)
        output_file_first_pass.seek(0)
        assembly_file_add_constant_labels(output_file_first_pass, output_file_second_pass, internal_labels)
        output_file_second_pass.seek(0)
        assembly_file_solve_instructions_add_position_labels(output_file_second_pass, output_file_third_pass, internal_labels, enable_show_program_labels)
        output_file_third_pass.seek(0)
        assembly_file_solve_remaining_instructions(output_file_third_pass, output_file, internal_labels)
        if(enable_intermediate_files):
            output_file_first_pass.close()
            output_file_second_pass.close()
            output_file_third_pass.close()
        
                    
def fill_internal_labels(internal_labels):
    base_words_per_mac_words = 8
    mac_words_per_operand = 8
    # Add MAC ram labels for internal mac instructions
    for i in range(256):
        internal_labels['m' + str(i)] = i
    # Add MAC ram labels for full bus copy instructions
    for i in range(256):
        for j in range(mac_words_per_operand):
            internal_labels['m' + str(i) + '.' + str(j)] =  i*mac_words_per_operand + j
    # Add MAC ram labels for local bus copy instructions
    for i in range(256):
        for j in range(mac_words_per_operand):
            for z in range(base_words_per_mac_words):
                internal_labels['m' + str(i) + '.' + str(j) + '.' + str(z)] = i*mac_words_per_operand*base_words_per_mac_words + j*base_words_per_mac_words + z
    # Add Program rom labels for local bus copy instructions
    # It does not work, but it won't be needed.
    # In order to work, the program memory would need to operate the local bus independently of the full bus.
    # Therefore increasing the amount of necessary memory, for an extra interface.
    #for i in range(256):
    #    for j in range(16):
    #        internal_labels['p' + str(i) + '.' + str(j)] = int("0x04000", base=16) + i*16 + j
    # Add Base ram labels
    for i in range(1024):
        internal_labels['b' + str(i)] = int("0x0C000", base=16) + i
    # Single labels
    for i in range(64):
        internal_labels['rd' + str(i)] = int("0x0C000", base=16) + i
    internal_labels['scalar'] = int("0x0C000", base=16)
    internal_labels['keccak_absorb_byte_lsb'] = int("0x0D000", base=16)
    internal_labels['keccak_absorb_byte_msb'] = int("0x0D080", base=16)
    internal_labels['keccak_absorb'] = int("0x0D100", base=16)
    internal_labels['keccak_absorb_swp'] = int("0x0D180", base=16)
    internal_labels['keccak_squeeze_byte'] = int("0x0D200", base=16)
    internal_labels['keccak_squeeze'] = int("0x0D300", base=16)
    internal_labels['keccak_dout'] = int("0x0D400", base=16)
    internal_labels['pc'] = int("0x0E000", base=16)
    internal_labels['rstatus'] = int("0x0E001", base=16)
    internal_labels['roperands'] = int("0x0E002", base=16)
    internal_labels['rprimeline'] = int("0x0E003", base=16)
    internal_labels['rprimeaddr'] = int("0x0E004", base=16)
    internal_labels['rprimeplusoneaddr'] = int("0x0E005", base=16)
    internal_labels['rprimelineaddr'] = int("0x0E006", base=16)
    internal_labels['stackinitaddr'] = int("0x0E007", base=16)
    internal_labels['flag'] = int("0x0E008", base=16)
    internal_labels['scalarinitaddr'] = int("0x0E009", base=16)
    # User defined labels
    # They are used so it is easier to write assembly programs on the device
    # Add version for full/local bus copy.
    # Add MAC ram labels for local bus copy instructions
    # fp2t0 -> fp2t7
    base_address = 216
    for i in range(8):
        internal_labels['fp2t' + str(i)] = base_address + i
        for j in range(mac_words_per_operand):
            internal_labels['fp2t' + str(i) + '.' + str(j)] =  (base_address + i)*mac_words_per_operand + j
            for z in range(base_words_per_mac_words):
                internal_labels['fp2t' + str(i) + '.' + str(j) + '.' + str(z)] = (base_address + i)*mac_words_per_operand*base_words_per_mac_words + j*base_words_per_mac_words + z
    # tmpf0 -> tmpf39
    base_address = 20
    for i in range(40):
        internal_labels['tmpf' + str(i)] = base_address + i
        for j in range(mac_words_per_operand):
            internal_labels['tmpf' + str(i) + '.' + str(j)] =  (base_address + i)*mac_words_per_operand + j
            for z in range(base_words_per_mac_words):
                internal_labels['tmpf' + str(i) + '.' + str(j) + '.' + str(z)] = (base_address + i)*mac_words_per_operand*base_words_per_mac_words + j*base_words_per_mac_words + z
    # var0  -> var155
    base_address = 60
    for i in range(156):
        internal_labels['var' + str(i)] = base_address + i
        for j in range(mac_words_per_operand):
            internal_labels['var' + str(i) + '.' + str(j)] =  (base_address + i)*mac_words_per_operand + j
            for z in range(base_words_per_mac_words):
                internal_labels['var' + str(i) + '.' + str(j) + '.' + str(z)] = (base_address + i)*mac_words_per_operand*base_words_per_mac_words + j*base_words_per_mac_words + z
                    
def print_main_class_help():
    print('The parameters options are:')
    print('')
    print('assembler.py assembly_program.txt mounted_program.dat [-l] [-d]')
    print('')
    print("assembly_program.txt")
    print("The input program")
    print('')
    print("mounted_program.dat")
    print("The name of the output, if not specified it will just use the original program name with the .dat extension.")
    print('')
    print("-l")
    print("Enable showing the position of all program labels. This is useful to know certain program positions.")
    print('')
    print("-d")
    print("Enable intermediate output files used by the assembling process. Applied in case of debugging the assembler.")
    
    

if __name__ == "__main__":
    argc = len(sys.argv)
    if(argc >= 2):
        input_file_name = sys.argv[1]
        enable_intermediate_files = False
        enable_show_program_labels = False
        if('-d' in sys.argv):
            enable_intermediate_files = True
            argc -= 1
        if('-l' in sys.argv):
            enable_show_program_labels = True
            argc -= 1
        if(argc == 1):
            print("Unknown amount of options")
            print('')
            print_main_class_help() 
        if(argc == 3):
            output_file_name = sys.argv[2]
        elif(argc == 2):
            output_file_name = input_file_name.rsplit('.', 1)[0] + '.dat'
        assembly_file_four_pass(input_file_name, output_file_name, enable_intermediate_files, enable_show_program_labels)
    else:
        print("Unknown amount of options")
        print('')
        print_main_class_help() 