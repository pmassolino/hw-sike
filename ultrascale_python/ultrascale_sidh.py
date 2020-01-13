# -*- coding: utf-8 -*-
#
# Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/
#
import serial
import time
import binascii

DEBUG_MODE = False

sidh_core_mac_ram_start_address =                           0x00000;
sidh_core_mac_ram_last_address =                            0x07FFF;
sidh_core_base_alu_ram_start_address =                      0x0C000;
sidh_core_base_alu_ram_last_address =                       0x0C3FF;
sidh_core_keccak_core_start_address =                       0x0D000;
sidh_core_keccak_core_last_address =                        0x0D007;
sidh_core_reg_program_counter_address =                     0x0E000;
sidh_core_reg_status_address =                              0x0E001;
sidh_core_reg_operands_size_address =                       0x0E002;
sidh_core_reg_prime_line_equal_one_address =                0x0E003;
sidh_core_reg_prime_address_address =                       0x0E004;
sidh_core_reg_prime_plus_one_address_address =              0x0E005;
sidh_core_reg_prime_line_address_address =                  0x0E006;
sidh_core_reg_initial_stack_address_address =               0x0E007;
sidh_core_reg_flag_address =                                0x0E008;
sidh_core_reg_scalar_address_address =                      0x0E009;

sidh_core_mac_ram_prime_address =                           0x00000;
sidh_core_mac_ram_prime_plus_one_address =                  0x00001;
sidh_core_mac_ram_prime_line_address =                      0x00002;
sidh_core_mac_ram_const_r_address =                         0x00003;
sidh_core_mac_ram_const_r2_address =                        0x00004;
sidh_core_mac_ram_const_1_address =                         0x00005;
sidh_core_mac_ram_inv_4_mont_address =                      0x00006;
sidh_core_mac_ram_sidh_xpa_mont_address =                   0x00007;
sidh_core_mac_ram_sidh_xpai_mont_address =                  0x00008;
sidh_core_mac_ram_sidh_xqa_mont_address =                   0x00009;
sidh_core_mac_ram_sidh_xqai_mont_address =                  0x0000A;
sidh_core_mac_ram_sidh_xra_mont_address =                   0x0000B;
sidh_core_mac_ram_sidh_xrai_mont_address =                  0x0000C;
sidh_core_mac_ram_sidh_xpb_mont_address =                   0x0000D;
sidh_core_mac_ram_sidh_xpbi_mont_address =                  0x0000E;
sidh_core_mac_ram_sidh_xqb_mont_address =                   0x0000F;
sidh_core_mac_ram_sidh_xqbi_mont_address =                  0x00010;
sidh_core_mac_ram_sidh_xrb_mont_address =                   0x00011;
sidh_core_mac_ram_sidh_xrbi_mont_address =                  0x00012;

sidh_core_mac_ram_input_function_start_address =            0x00014;
sidh_core_mac_ram_output_function_start_address =           0x00024;

sidh_core_base_alu_ram_oa_bits_address =                    0x0019F;
sidh_core_base_alu_ram_ob_bits_address =                    0x001A0;
sidh_core_base_alu_ram_prime_size_bits_address =            0x001A1;
sidh_core_base_alu_ram_splits_alice_start_address =         0x001A2;
sidh_core_base_alu_ram_max_row_alice_address =              0x002D0;
sidh_core_base_alu_ram_splits_bob_start_address =           0x002D1;
sidh_core_base_alu_ram_max_row_bob_address =                0x003FF;

def integerToBytearray(a, fixed_size=0):
    if(fixed_size == 0):
        bytearray_a = bytearray()
    else:
        bytearray_a = bytearray(fixed_size)
    j = 0
    while a != 0:
        if(j >= len(bytearray_a)):
            bytearray_a.append(a%256)
        else:
            bytearray_a[j] = a%256
        a = a//256
        j += 1
    return bytearray_a

def bytearrayToInteger(a):
    integer_a = 0
    j = 1
    for i in range(len(a)):
        integer_a = integer_a + a[i]*j
        j = j * 256
    return integer_a

class Ultrascale():
    def __init__(self, portName):
        self.serial = serial.Serial(portName, baudrate=115200, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE, timeout=None, xonxoff=False, rtscts=False, write_timeout=None, dsrdtr=False, inter_byte_timeout=None)

    def __del__(self):
        self.serial.close()

    def read_initial_message(self, size):
        response_msg = self.serial.read(size)
        print(bytearray(response_msg))
        
    def disconnect(self):
        return self.serial.close()

    def flush(self):
        self.serial.reset_input_buffer()
        self.serial.reset_output_buffer()

    def write_package(self, address, value):
        real_address = address*4
        send_msg = bytearray(6)
        address_bytearray = integerToBytearray(real_address, 3)
        value_bytearray = integerToBytearray(value, 2)
        
        send_msg[0] = 0x02;
        send_msg[1] = address_bytearray[0];
        send_msg[2] = address_bytearray[1];
        send_msg[3] = address_bytearray[2];
        send_msg[4] = value_bytearray[0];
        send_msg[5] = value_bytearray[1];
        
        self.serial.write(send_msg)
        if(DEBUG_MODE):
            print('W {0:#04x} = {1:#04x}'.format(real_address, value))

        response_msg = self.serial.read(2)
        response_msg_bytearray = bytearray(response_msg)
        response_value = bytearrayToInteger(response_msg_bytearray)
        
        if(response_value != 0xffff):
            print('Error during writing')

    def read_package(self, address):
        real_address = address*4
        send_msg = bytearray(6)
        address_bytearray = integerToBytearray(real_address, 3)
        
        send_msg[0] = 0x01;
        send_msg[1] = address_bytearray[0];
        send_msg[2] = address_bytearray[1];
        send_msg[3] = address_bytearray[2];
        send_msg[4] = 0;
        send_msg[5] = 0;
        
        self.serial.write(send_msg)
        
        response_msg = self.serial.read(2)
        response_msg_bytearray = bytearray(response_msg)
        response_value = bytearrayToInteger(response_msg_bytearray)
        if(DEBUG_MODE):
            print('R {0:#04x} = {1:#04x}'.format(real_address, response_value))
        
        return response_value

    def isFree(self):
        
        send_msg = bytearray(6)
        
        send_msg[0] = 0x04;
        send_msg[1] = 0;
        send_msg[2] = 0;
        send_msg[3] = 0;
        send_msg[4] = 0;
        send_msg[5] = 0;
        
        self.serial.write(send_msg)
        
        response_msg = self.serial.read(2)
        response_msg_bytearray = bytearray(response_msg)
        response_value = bytearrayToInteger(response_msg_bytearray)
        
        if(response_value == 1):
            return True
        else:
            return False

    def write_mac_ram_value(self, address, value):
        value_mask = 2**16-1
        effective_address = address
        effective_value = 0
        for i in range(16):
            effective_value = value & value_mask
            self.write_package(effective_address, effective_value)
            value = value >> 16
            effective_address += 1

    def read_mac_ram_value(self, address):
        value_mask = 2**16-1
        effective_address = address
        effective_value = 0
        shift_amount = 0
        for i in range(16):
            temp_value = self.read_package(effective_address)
            effective_value |= temp_value << shift_amount
            shift_amount += 16
            effective_address += 1
        return effective_value

    def write_prom_value(self, address, value):
        value_mask = 2**16-1
        effective_address = 2**16 + address
        effective_value = 0
        for i in range(4):
            effective_value = value & value_mask
            self.write_package(effective_address, effective_value)
            value = value >> 16
            effective_address += 1

    def read_prom_value(self, address):
        value_mask = 2**16-1
        effective_address = 2**16 + address
        effective_value = 0
        shift_amount = 0
        for i in range(4):
            temp_value = self.read_package(effective_address)
            effective_value |= temp_value << shift_amount
            shift_amount += 16
            effective_address += 1
        return effective_value

    def write_program_prom(self, address, program):
        effective_address = address*4*16
        for i in range(len(program)):
            self.write_prom_value(effective_address, program[i])
            effective_address += 4
            
    def read_program_prom(self, address, program_size):
        effective_address = address*4*16
        program = [0 for i in range(program_size)]
        for i in range(program_size):
            program[i] = self.read_prom_value(effective_address)
            effective_address += 4
        return program

    def write_mac_ram_operand(self, address, operand, operand_size):
        value_mask = 2**16-1
        effective_address = address*4*16 + sidh_core_mac_ram_start_address
        for i in range(operand_size):
            self.write_mac_ram_value(effective_address, operand[i])
            effective_address += 16

    def read_mac_ram_operand(self, address, operand_size):
        value_mask = 2**16-1
        effective_address = address*4*16 + sidh_core_mac_ram_start_address
        operand = [0]*operand_size
        for i in range(operand_size):
            operand[i] = self.read_mac_ram_value(effective_address)
            effective_address += 16
        return operand
