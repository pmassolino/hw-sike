#!/usr/bin/python
# -*- coding: utf-8 -*-
import serial
import time
import binascii

DEBUG_MODE = False

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

class Zedboard():
    def __init__(self, portName, version):
        self.serial = serial.Serial(portName, baudrate=115200, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE, timeout=None, xonxoff=False, rtscts=False, write_timeout=None, dsrdtr=False, inter_byte_timeout=None)
        if(version == "256"):
            self.mac_ram_words_per_operand = 4
            self.base_words_per_mac_ram = 16
        elif(version == "128"):
            self.mac_ram_words_per_operand = 8
            self.base_words_per_mac_ram = 8

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
        for i in range(self.base_words_per_mac_ram):
            effective_value = value & value_mask
            self.write_package(effective_address, effective_value)
            value = value >> 16
            effective_address += 1

    def read_mac_ram_value(self, address):
        value_mask = 2**16-1
        effective_address = address
        effective_value = 0
        shift_amount = 0
        for i in range(self.base_words_per_mac_ram):
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
        effective_address = address*4
        for i in range(len(program)):
            self.write_prom_value(effective_address, program[i])
            effective_address += 4
            
    def read_program_prom(self, address, program_size):
        effective_address = address*4
        program = [0 for i in range(program_size)]
        for i in range(program_size):
            program[i] = self.read_prom_value(effective_address)
            effective_address += 4
        return program

    def write_mac_ram_operand(self, address, operand, operand_size):
        value_mask = 2**16-1
        effective_address = address*(self.mac_ram_words_per_operand)*(self.base_words_per_mac_ram)
        for i in range(operand_size):
            self.write_mac_ram_value(effective_address, operand[i])
            effective_address += self.base_words_per_mac_ram

    def read_mac_ram_operand(self, address, operand_size):
        value_mask = 2**16-1
        effective_address = address*(self.mac_ram_words_per_operand)*(self.base_words_per_mac_ram)
        operand = [0]*operand_size
        for i in range(operand_size):
            operand[i] = self.read_mac_ram_value(effective_address)
            effective_address += self.base_words_per_mac_ram
        return operand
