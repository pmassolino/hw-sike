--
-- Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
--
-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

architecture compact_memory_based of carmela_state_machine_v256 is

type romtype is array(integer range <>) of std_logic_vector(46 downto 0);

constant rom_state_machine_program : romtype(0 to 307) := (
-- 0000 multiplication with no reduction
-- -- In case of size 1
-- Multiplication direct 0
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; o1_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010000111000010000001000110100000000011",
                           
-- NOP 8 stages                         
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 2, 3, 4       
-- Multiplication direct 2          
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00101000010100001000010000001000000100000000011",
-- -- In case of size 2             
-- Multiplication direct 3          
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"00001000010100000000010000010000011001000100011",
-- Multiplication direct 4          
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o; o1_0 = reg_o; Enable sign b; operation : a*b + acc;
"00001000010100001000010000000000101001010000011",
-- Multiplication direct 5          
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 272; o2_0 = reg_o; o3_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010100111000010000010000111110010100011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 3, 4          
-- Multiplication direct 7          
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011000000000010000010000001001000100011",
-- Multiplication direct 8          
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000001001010000011",
-- Multiplication direct 9          
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00111000011000000000010000010000001110010100011",
-- -- In case of size 3             
-- Multiplication direct 10          
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"00001000011000000000010000000000101110100000011",
-- Multiplication direct 11          
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000001000010000000000011110001000011",
-- Multiplication direct 12          
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"00001000011000000000010000010000010011011000011",
-- Multiplication direct 13         
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign b; operation : a*b + acc; Increment o3_0 base address
"00001000011001001000010000000000100011100100011",
-- Multiplication direct 14         
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 272; o4_0 = reg_o; o5_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011000111000010000010000110100101000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 4             
-- Multiplication direct 16          
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000001110100000011",
-- Multiplication direct 17          
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001110001000011",
-- Multiplication direct 18          
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011100000000010000010000000011011000011",
-- Multiplication direct 19         
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000011100100011",
-- Multiplication direct 20         
-- reg_a = a3_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010011001100011",
-- Multiplication direct 21         
-- reg_a = a0_0; reg_b = b3_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign b; operation : a*b + acc; Increment o3_0 base address
"00001000011101001000010000000000100011110000011",
-- Multiplication direct 22         
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011100000000010000010000000100101000011",
-- Multiplication direct 23         
-- reg_a = a3_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100011100011",
-- Multiplication direct 24         
-- reg_a = a1_0; reg_b = b3_0; reg_acc = reg_o; o4_0 = reg_o; Enable sign b; operation : a*b + acc;
"00001000011100001000010000000000100100110100011",
-- Multiplication direct 25         
-- reg_a = a3_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"00001000011100000000010000010000011001101100011",
-- Multiplication direct 26         
-- reg_a = a2_0; reg_b = b3_0; reg_acc = reg_o; o5_0 = reg_o; Enable sign b; operation : a*b + acc;
"00001000011100001000010000000000101001111000011",
-- Multiplication direct 27         
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 272; o6_0 = reg_o; o7_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011100111000010000010000001110111100011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--- 29 Instructions                 
-------------------------------------------------------------
-- 0001 square with no reduction                                                                                           
--                                  
-- -- In case of size 1             
-- Square direct 0                  
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; o1_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010000111000010000001000110100000000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 2, 3, 4       
-- Square direct 2                  
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00100000010100001000010000001000000100000000011",
-- -- In case of size 2             
-- Square direct 3                  
-- reg_a = a1_0; reg_b = a0_0; reg_acc = reg_o >> 272; o1_0 = reg_o; Enable sign a; operation : 2*a*b + acc;
"00001000010100001010010000010000011001000100011",
-- Square direct 4                  
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 272; o2_0 = reg_o; o3_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010100111000010000010000111110010100011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- In case of 3, 4                  
-- Square direct 6                  
-- reg_a = a1_0; reg_b = a0_0; reg_acc = reg_o >> 272; o1_0 = reg_o; operation : 2*a*b + acc;
"00001000011000001010010000010000001001000100011",
-- Square direct 7                  
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00101000011000000000010000010000001110010100011",
-- -- In case of size 3             
-- Square direct 8                  
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign b; operation : 2*a*b + acc;
"00100000011000001010010000000000101110100000011",
-- Square direct 9                  
-- reg_a = a2_0; reg_b = a1_0; reg_acc = reg_o >> 272; o3_0 = reg_o; Enable sign a; operation : 2*a*b + acc; Increment o3_0 base address
"00001000011001001010010000010000010011011000011",
-- Square direct 10                  
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 272; o4_0 = reg_o; o5_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011000111000010000010000110100101000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 4             
-- Square direct 12                  
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; o2_0 = reg_o; operation : 2*a*b + acc;
"00001000011100001010010000000000001110100000011",
-- Square direct 13                 
-- reg_a = a2_0; reg_b = a1_0; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"00001000011100000010010000010000000011011000011",
-- Square direct 14                 
-- reg_a = a3_0; reg_b = a0_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign a; operation : 2*a*b + acc; Increment o3_0 base address
"00001000011101001010010000000000010011001100011",
-- Square direct 15                 
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011100000000010000010000000100101000011",
-- Square direct 16                 
-- reg_a = a3_0; reg_b = a1_0; reg_acc = reg_o; o4_0 = reg_o; Enable sign a; operation : 2*a*b + acc;
"00001000011100001010010000000000010100011100011",
-- Square direct 17                 
-- reg_a = a3_0; reg_b = a2_0; reg_acc = reg_o >> 272; o5_0 = reg_o; Enable sign a; operation : 2*a*b + acc;
"00001000011100001010010000010000011001101100011",
-- Square direct 18                 
-- reg_a = a3_0; reg_b = a3_0; reg_acc = reg_o >> 272; o6_0 = reg_o; o7_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011100111000010000010000111110111100011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--- 49 Instructions                 
-------------------------------------------------------------
-- 0010 multiplication  with reduction and prime line not equal to 1
-- -- In case of size 1             
-- Multiplication with reduction 0  
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
-- Multiplication with reduction 1  
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010000001100011000000010000100000011011",
-- Multiplication with reduction 2  
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010000000000010000000001000100000010011",
-- Multiplication with reduction 3  
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 272; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 2, 3, 4       
-- Multiplication with reduction 5  
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; operation : a*b + acc;
"00001000010100000000010000001000000100000000011",
-- Multiplication with reduction 6  
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010000100000011011",
-- Multiplication with reduction 7  
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"01001000010100000000010000000001000100000010011",
-- -- In case of size 2             
-- Multiplication with reduction 8  
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000010100000000010000010000100100010000011",
-- Multiplication with reduction 9  
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000000000100010010111",
-- Multiplication with reduction 10 
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000010100000000010000000000010100000100011",
-- Multiplication with reduction 11 
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010001001000011011",
-- Multiplication with reduction 12 
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000001000100000010011",
-- Multiplication with reduction 13 
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
-- Multiplication with reduction 14 
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 272; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 3, 4          
-- Multiplication with reduction 16 
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011000000000010000010000000100010000011",
-- Multiplication with reduction 17 
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010010111",
-- Multiplication with reduction 18 
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100000100011",
-- Multiplication with reduction 19 
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001001000011011",
-- Multiplication with reduction 20 
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"01111000011000000000010000000001000100000010011",
-- -- In case of size 3             
-- Multiplication with reduction 21 
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011000000000010000010000100100100000011",
-- Multiplication with reduction 22 
-- reg_a = o0_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100010111",
-- Multiplication with reduction 23 
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
-- Multiplication with reduction 24 
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010110111",
-- Multiplication with reduction 25 
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000000000010000000000010100001000011",
-- Multiplication with reduction 26 
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001110000011011",
-- Multiplication with reduction 27 
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000001000100000010011",
-- Multiplication with reduction 28 
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011000000000010000010000100100100100011",
-- Multiplication with reduction 29 
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
-- Multiplication with reduction 30 
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000000000010000000000010100011000011",
-- Multiplication with reduction 31 
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
-- Multiplication with reduction 32 
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
-- Multiplication with reduction 33 
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 272; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 4             
-- Multiplication with reduction 35 
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011100000000010000010000000100100000011",
-- Multiplication with reduction 36 
-- reg_a = o0_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100010111",
-- Multiplication with reduction 37 
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010100011",
-- Multiplication with reduction 38 
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010110111",
-- Multiplication with reduction 39 
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100001000011",
-- Multiplication with reduction 40 
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010001110000011011",
-- Multiplication with reduction 41 
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
-- Multiplication with reduction 42 
-- reg_a = a0_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110000011",
-- Multiplication with reduction 43 
-- reg_a = o0_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
-- Multiplication with reduction 44 
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100100011",
-- Multiplication with reduction 45 
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
-- Multiplication with reduction 46 
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011000011",
-- Multiplication with reduction 47 
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011010111",
-- Multiplication with reduction 48 
-- reg_a = a3_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100001100011",
-- Multiplication with reduction 49 
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o3_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010000011000011011",
-- Multiplication with reduction 50 
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
-- Multiplication with reduction 51 
-- reg_a = a1_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110100011",
-- Multiplication with reduction 52 
-- reg_a = o1_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
-- Multiplication with reduction 53 
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
-- Multiplication with reduction 54 
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
-- Multiplication with reduction 55 
-- reg_a = a3_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100011100011",
-- Multiplication with reduction 56 
-- reg_a = o3_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
-- Multiplication with reduction 57 
-- reg_a = a2_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100111000011",
-- Multiplication with reduction 58 
-- reg_a = o2_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
-- Multiplication with reduction 59 
-- reg_a = a3_0; reg_b = b2_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100101100011",
-- Multiplication with reduction 60 
-- reg_a = o3_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
-- Multiplication with reduction 61 
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
-- Multiplication with reduction 62 
-- reg_a = o3_0; reg_b = prime3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 272; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--- 113 Instructions                
-------------------------------------------------------------
-- 0010 multiplication  with reduction and prime line equal to 1
-- -- In case of size 1             
--  Multiplication with reduction special prime 0
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
--  Multiplication with reduction special prime 1
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 272; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of sizes 2, 3, 4      
--  Multiplication with reduction special prime 3
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00111000010100001000010000001000000100000000011",
-- -- In case of size 2             
--  Multiplication with reduction special prime 4
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000010100000000010000010000100100010000011",
--  Multiplication with reduction special prime 5
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000000000100010010111",
--  Multiplication with reduction special prime 6
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; o1_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000010100001000010000000000011001000100011",
--  Multiplication with reduction special prime 7
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
--  Multiplication with reduction special prime 8
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 272; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of sizes 3, 4         
--  Multiplication with reduction special prime 10
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011000000000010000010000000100010000011",
--  Multiplication with reduction special prime 11
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010010111",
--  Multiplication with reduction special prime 12
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"01101000011000001000010000000000001001000100011",
-- -- In case of sizes 3            
--  Multiplication with reduction special prime 13
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011000000000010000010000100100100000011",
--  Multiplication with reduction special prime 14
-- reg_a = o0_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100010111",
--  Multiplication with reduction special prime 15
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
--  Multiplication with reduction special prime 16
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010110111",
--  Multiplication with reduction special prime 17
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000001000010000000000011110001000011",
--  Multiplication with reduction special prime 18
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011000000000010000010000100100100100011",
--  Multiplication with reduction special prime 19
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
--  Multiplication with reduction special prime 20
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000000000010000000000010100011000011",
--  Multiplication with reduction special prime 21
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
--  Multiplication with reduction special prime 22
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
--  Multiplication with reduction special prime 23
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 272; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of sizes 4            
--  Multiplication with reduction special prime 25
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011100000000010000010000000100100000011",
--  Multiplication with reduction special prime 26
-- reg_a = o0_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100010111",
--  Multiplication with reduction special prime 27
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010100011",
--  Multiplication with reduction special prime 28
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010110111",
--  Multiplication with reduction special prime 29
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001110001000011",
--  Multiplication with reduction special prime 30
-- reg_a = a0_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110000011",
--  Multiplication with reduction special prime 31
-- reg_a = o0_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
--  Multiplication with reduction special prime 32
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100100011",
--  Multiplication with reduction special prime 33
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
--  Multiplication with reduction special prime 34
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011000011",
--  Multiplication with reduction special prime 35
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011010111",
--  Multiplication with reduction special prime 36
-- reg_a = a3_0; reg_b = b0_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100001000010000000000010011001100011",
--  Multiplication with reduction special prime 37
-- reg_a = a1_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110100011",
--  Multiplication with reduction special prime 38
-- reg_a = o1_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
--  Multiplication with reduction special prime 39
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
--  Multiplication with reduction special prime 40
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
--  Multiplication with reduction special prime 41
-- reg_a = a3_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100011100011",
--  Multiplication with reduction special prime 42
-- reg_a = o3_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
--  Multiplication with reduction special prime 43
-- reg_a = a2_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100111000011",
--  Multiplication with reduction special prime 44
-- reg_a = o2_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
--  Multiplication with reduction special prime 45
-- reg_a = a3_0; reg_b = b2_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100101100011",
--  Multiplication with reduction special prime 46
-- reg_a = o3_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
--  Multiplication with reduction special prime 47
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
--  Multiplication with reduction special prime 48
-- reg_a = o3_0; reg_b = primeSP3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 272; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--- 163  Instructions               
-------------------------------------------------------------
-- 0011 square with reduction and prime line not equal to 1
-- -- In case of size 1             
--  Square with reduction 0         
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
--  Square with reduction 1         
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010000001100011000000010000100000011011",
--  Square with reduction 2         
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010000000000010000000001000100000010011",
--  Square with reduction 3         
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 272; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 2, 3, 4       
--  Square with reduction 5         
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; operation : a*b + acc;
"00001000010100000000010000001000000100000000011",
--  Square with reduction 6         
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010000100000011011",
--  Square with reduction 7         
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"01000000010100000000010000000001000100000010011",
-- -- In case of size 2             
--  Square with reduction 8         
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000010100000010010000010000100100010000011",
--  Square with reduction 9         
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000000000100010010111",
--  Square with reduction 10         
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010001001000111011",
--  Square with reduction 11         
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000001000100000110011",
--  Square with reduction 12         
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
--  Square with reduction 13         
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 272; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 3, 4          
--  Square with reduction 15         
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"00001000011000000010010000010000000100010000011",
--  Square with reduction 16         
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010010111",
--  Square with reduction 17         
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001001000111011",
--  Square with reduction 18         
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"01101000011000000000010000000001000100000110011",
-- -- In case of size 3             
--  Square with reduction 19        
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000010000100100100000011",
--  Square with reduction 20        
-- reg_a = o0_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100010111",
--  Square with reduction 21        
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
--  Square with reduction 22        
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010110111",
--  Square with reduction 23        
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001110000011011",
--  Square with reduction 24        
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000001000100000010011",
--  Square with reduction 25        
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000010000100100100100011",
--  Square with reduction 26        
-- reg_a = o1_0; reg_b  = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
--  Square with reduction 27        
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
--  Square with reduction 28        
-- reg_a = a2_0; reg_b  = a2_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
--  Square with reduction 29        
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 272; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 4             
--  Square with reduction 31        
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"00001000011100000010010000010000000100100000011",
--  Square with reduction 32        
-- reg_a = o0_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100010111",
--  Square with reduction 33        
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010100011",
--  Square with reduction 34        
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010110111",
--  Square with reduction 35        
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010001110000011011",
--  Square with reduction 36        
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
--  Square with reduction 37        
-- reg_a = a0_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110000011",
--  Square with reduction 38        
-- reg_a = o0_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
--  Square with reduction 39        
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o; operation : 2*a*b + acc;
"00001000011100000010010000000000000100100100011",
--  Square with reduction 40        
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
--  Square with reduction 41        
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011010111",
--  Square with reduction 42        
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o3_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010000011000011011",
--  Square with reduction 43        
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
--  Square with reduction 44        
-- reg_a = a1_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110100011",
--  Square with reduction 45        
-- reg_a = o1_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
--  Square with reduction 46        
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
--  Square with reduction 47        
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
--  Square with reduction 48        
-- reg_a = o3_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
--  Square with reduction 49        
-- reg_a = a2_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100111000011",
--  Square with reduction 50        
-- reg_a = o2_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
--  Square with reduction 51        
-- reg_a = o3_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
--  Square with reduction 52        
-- reg_a = a3_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
--  Square with reduction 53        
-- reg_a = o3_0; reg_b = prime3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 272; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--- 218  Instructions               
-------------------------------------------------------------
-- 0011 square with reduction and prime line equal to 1
-- -- In case of size 1             
-- Square with reduction special prime 0
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
-- Square with reduction special prime 1
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 272; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 2, 3, 4       
-- Square with reduction special prime 3
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00110000010100001000010000001000000100000000011",
-- -- In case of size 2             
-- Square with reduction special prime 4
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000010100000010010000010000100100010000011",
-- Square with reduction special prime 5
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000010100001000010000000000001001010010111", 
-- Square with reduction special prime 6
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
-- Square with reduction special prime 7
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 272; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 3, 4          
-- Square with reduction special prime 9
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"00001000011000000010010000010000000100010000011",
-- Square with reduction special prime 10
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"01011000011000001000010000000000001001010010111", 
-- -- In case of size 3             
-- Square with reduction special prime 11
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000010000100100100000011",
-- Square with reduction special prime 12
-- reg_a = o0_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100010111",
-- Square with reduction special prime 13
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
-- Square with reduction special prime 14
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; o2_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000001110010110111",
-- Square with reduction special prime 15
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000010000100100100100011",
-- Square with reduction special prime 16
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
-- Square with reduction special prime 17
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
-- Square with reduction special prime 18
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
-- Square with reduction special prime 19
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 272; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 4             
-- Square with reduction special prime 21
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"00001000011100000010010000010000000100100000011",
-- Square with reduction special prime 22
-- reg_a = o0_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100010111",
-- Square with reduction special prime 23
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010100011",
-- Square with reduction special prime 24
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; o2_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001110010110111",
-- Square with reduction special prime 25
-- reg_a = a0_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110000011",
-- Square with reduction special prime 26
-- reg_a = o0_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
-- Square with reduction special prime 27
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o; operation : 2*a*b + acc;
"00001000011100000010010000000000000100100100011",
-- Square with reduction special prime 28
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
-- Square with reduction special prime 29
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; o3_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000011011010111",
-- Square with reduction special prime 30
-- reg_a = a1_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110100011",
-- Square with reduction special prime 31
-- reg_a = o1_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
-- Square with reduction special prime 32
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
-- Square with reduction special prime 33
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
-- Square with reduction special prime 34
-- reg_a = o3_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
-- Square with reduction special prime 35
-- reg_a = a2_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100111000011",
-- Square with reduction special prime 36
-- reg_a = o2_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
-- Square with reduction special prime 37
-- reg_a = o3_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
-- Square with reduction special prime 38
-- reg_a = a3_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
-- Square with reduction special prime 39
-- reg_a = o3_0; reg_b = primeSP3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 272; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--- 259  Instructions               
-------------------------------------------------------------
-- 0100 addition with no reduction    
-- -- In case of size 1               
-- Addition subtraction direct 0      
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000010000001000000100001000110100000000010",
-- NOP 4 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
-- -- In case of size 2, 3, 4       
-- Addition subtraction direct 2    
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : b +/- a + acc;
"00011000010100001000000100001000000100000000010",
-- -- In case of size 2             
-- Addition subtraction direct 3    
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 272; o1_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000010100001000000100010000111001010100010",
-- NOP 4 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
-- -- In case of size 3, 4          
-- Addition subtraction direct 5    
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 272; o1_0 = reg_o; operation : b +/- a + acc;
"00011000011000001000000100010000001001010100010",
-- -- In case of size 3             
-- Addition subtraction direct 6    
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 272; o2_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000011000001000000100010000110110101000010",
-- NOP 4 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
-- -- In case of size 4             
-- Addition subtraction direct 8    
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 272; o2_0 = reg_o; operation : b +/- a + acc;
"00001000011000001000000100010000000110101000010",
-- Addition subtraction direct 9    
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 272; o3_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000011100001000000100010000110011111100010",
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--- 270  Instructions            
-------------------------------------------------------------
-- 0101 iterative modular reduction
-- -- In case of size 1             
-- Iterative modular reduction 0
"00001000010000000000001000001100110100000010010",
-- Iterative modular reduction 1
"00001000010000000001100011100011110100000010010",
-- Iterative modular reduction 2
"00001000010000000000101001100011110100000010010",
-- Iterative modular reduction 3
"00001000010000001000101001100011110100000010010",
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
-- -- In case of size 2             
-- Iterative modular reduction 5
"00001000010100000000001000001100110100000110010",
-- Iterative modular reduction 6
"00001000010100001001100011101000000100000010010",
-- Iterative modular reduction 7
"00001000010100001001100000010000111001010110010",
-- Iterative modular reduction 8
"00001000010100001000101001101000000100000010110",
-- Iterative modular reduction 9
"00001000010100001000101000010000111001010110110",
-- Iterative modular reduction 10
"00001000010100001000101001101000000100000010110",
-- Iterative modular reduction 11
"00001000010100001000101000010000111001010110110",
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
-- -- In case of size 3             
-- Iterative modular reduction 13
"00001000011000000000001000001100111110101010010",
-- Iterative modular reduction 14
"00001000011000001001100011101000000100000010010",
-- Iterative modular reduction 15
"00001000011000001001100000010000001001010110010",
-- Iterative modular reduction 16
"00001000011000001001100000010000111110101010010",
-- Iterative modular reduction 17
"00001000011000001000101001101000000100000010110",
-- Iterative modular reduction 18
"00001000011000001000101000010000001001010110110",
-- Iterative modular reduction 19
"00001000011000001000101000010000111110101010110",
-- Iterative modular reduction 20
"00001000011000001000101001101000000100000010110",
-- Iterative modular reduction 21
"00001000011000001000101000010000001001010110110",
-- Iterative modular reduction 22
"00001000011000001000101000010000111110101010110",
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
-- -- In case of size 4             
-- Iterative modular reduction 24
"00001000011100000000001000001100110011111110010",
-- Iterative modular reduction 25
"00001000011100001001100011101000000100000010010",
-- Iterative modular reduction 26
"00001000011100001001100000010000001001010110010",
-- Iterative modular reduction 27
"00001000011100001001100000010000001110101010010",
-- Iterative modular reduction 28
"00001000011100001001100000010000110011111110010",
-- Iterative modular reduction 29
"00001000011100001000101001101000000100000010110",
-- Iterative modular reduction 30
"00001000011100001000101000010000001001010110110",
-- Iterative modular reduction 31
"00001000011100001000101000010000001110101010110",
-- Iterative modular reduction 32
"00001000011100001000101000010000110011111110110",
-- Iterative modular reduction 33
"00001000011100001000101001101000000100000010110",
-- Iterative modular reduction 34
"00001000011100001000101000010000001001010110110",
-- Iterative modular reduction 35
"00001000011100001000101000010000001110101010110",
-- Iterative modular reduction 36
"00001000011100001000101000010000110011111110110",
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010"
--------- 308 Instructions                
-----------------------------------------------------------------
);



constant rom_state_machine_fill_nop : romtype(308 to 511) := (others => "00000000000010000000010000001111000100000000011");
constant rom_state_machine : romtype(0 to 511) := rom_state_machine_program & rom_state_machine_fill_nop;

signal rom_state_machine_address : std_logic_vector(8 downto 0);
signal rom_state_machine_output : std_logic_vector(46 downto 0);

signal rom_sm_rotation_size : std_logic_vector(1 downto 0);
signal rom_sel_address_a : std_logic;
signal rom_sel_address_b_prime : std_logic_vector(1 downto 0);
signal rom_sm_specific_mac_address_a : std_logic_vector(1 downto 0);
signal rom_sm_specific_mac_address_b : std_logic_vector(1 downto 0);
signal rom_sm_specific_mac_address_o : std_logic_vector(1 downto 0);
signal rom_sm_specific_mac_next_address_o : std_logic_vector(1 downto 0);
signal rom_mac_enable_signed_a : std_logic;
signal rom_mac_enable_signed_b : std_logic;
signal rom_mac_sel_load_reg_a : std_logic_vector(1 downto 0);
signal rom_mac_clear_reg_b : std_logic;
signal rom_mac_clear_reg_acc : std_logic;
signal rom_mac_sel_shift_reg_o : std_logic;
signal rom_mac_enable_update_reg_s : std_logic;
signal rom_mac_sel_reg_s_reg_o_sign : std_logic;
signal rom_mac_reg_s_reg_o_positive : std_logic;
signal rom_sm_sign_a_mode : std_logic;
signal rom_sm_mac_operation_mode : std_logic_vector(1 downto 0);
signal rom_mac_enable_reg_s_mask : std_logic;
signal rom_mac_subtraction_reg_a_b : std_logic;
signal rom_mac_sel_multiply_two_a_b : std_logic;
signal rom_mac_sel_reg_y_output : std_logic;
signal rom_mac_enable_sign_output : std_logic;
signal rom_sm_mac_write_enable_output : std_logic;
signal rom_mac_memory_double_mode : std_logic;
signal rom_mac_memory_only_write_mode : std_logic;
signal rom_base_address_generator_o_increment_previous_address : std_logic;

signal rom_last_state : std_logic;
signal rom_current_operand_size : std_logic_vector(1 downto 0);
signal rom_next_operation_same_operand_size : std_logic_vector(4 downto 0);
signal rom_next_operation_different_operand_size : std_logic_vector(4 downto 0);

signal adder_a : unsigned(8 downto 0);
signal adder_b : unsigned(4 downto 0);
signal adder_o : unsigned(8 downto 0);

signal internal_sel_output_rom : std_logic;
signal internal_update_rom_address : std_logic;
signal internal_sel_load_new_rom_address : std_logic;
signal internal_sm_rotation_size : std_logic_vector(1 downto 0);
signal internal_sm_circular_shift_enable : std_logic;
signal internal_sel_address_a : std_logic;
signal internal_sel_address_b_prime : std_logic_vector(1 downto 0);
signal internal_sm_specific_mac_address_a : std_logic_vector(1 downto 0);
signal internal_sm_specific_mac_address_b : std_logic_vector(1 downto 0);
signal internal_sm_specific_mac_address_o : std_logic_vector(1 downto 0);
signal internal_sm_specific_mac_next_address_o : std_logic_vector(1 downto 0);
signal internal_mac_enable_signed_a : std_logic;
signal internal_mac_enable_signed_b : std_logic;
signal internal_mac_sel_load_reg_a : std_logic_vector(1 downto 0);
signal internal_mac_clear_reg_b : std_logic;
signal internal_mac_clear_reg_acc : std_logic;
signal internal_mac_sel_shift_reg_o : std_logic;
signal internal_mac_enable_update_reg_s : std_logic;
signal internal_mac_sel_reg_s_reg_o_sign : std_logic;
signal internal_mac_reg_s_reg_o_positive : std_logic;
signal internal_sm_sign_a_mode : std_logic;
signal internal_sm_mac_operation_mode : std_logic_vector(1 downto 0);
signal internal_mac_enable_reg_s_mask : std_logic;
signal internal_mac_subtraction_reg_a_b : std_logic;
signal internal_mac_sel_multiply_two_a_b : std_logic;
signal internal_mac_sel_reg_y_output : std_logic;
signal internal_sm_mac_write_enable_output : std_logic;
signal internal_mac_memory_double_mode : std_logic;
signal internal_mac_memory_only_write_mode : std_logic;
signal internal_base_address_generator_o_increment_previous_address : std_logic;
signal internal_sm_free_flag : std_logic;

-- 0000 multiplication with no reduction
constant first_state_multiplication_direct_operand_size_1 : std_logic_vector(8 downto 0)                                   := "0" & X"00";
constant first_state_multiplication_direct_operand_size_2_3_4 : std_logic_vector(8 downto 0)                               := "0" & X"02";
-- 0001 square with no reduction                                                                                           
constant first_state_square_direct_operand_size_1 : std_logic_vector(8 downto 0)                                           := "0" & X"1D";
constant first_state_square_direct_operand_size_2_3_4 : std_logic_vector(8 downto 0)                                       := "0" & X"1F";
-- 0010 multiplication with reduction and prime line not equal to 1
constant first_state_multiplication_with_reduction_operand_size_1 : std_logic_vector(8 downto 0)                           := "0" & X"31";
constant first_state_multiplication_with_reduction_operand_size_2_3_4 : std_logic_vector(8 downto 0)                       := "0" & X"36";
-- 0010 multiplication with reduction and prime line equal to 1
constant first_state_multiplication_with_reduction_special_prime_operand_size_1 : std_logic_vector(8 downto 0)             := "0" & X"71";
constant first_state_multiplication_with_reduction_special_prime_operand_size_2_3_4 : std_logic_vector(8 downto 0)         := "0" & X"74";
-- 0011 square with reduction and prime line not equal to 1
constant first_state_square_with_reduction_operand_size_1 : std_logic_vector(8 downto 0)                                   := "0" & X"A3";
constant first_state_square_with_reduction_operand_size_2_3_4 : std_logic_vector(8 downto 0)                               := "0" & X"A8";
-- 0011 square with reduction and prime line equal to 1
constant first_state_square_with_reduction_special_prime_operand_size_1 : std_logic_vector(8 downto 0)                     := "0" & X"DA";
constant first_state_square_with_reduction_special_prime_operand_size_2_3_4 : std_logic_vector(8 downto 0)                 := "0" & X"DD";
-- 0100 addition with no reduction
constant first_state_addition_subtraction_direct_operand_size_1 : std_logic_vector(8 downto 0)                             := "1" & X"03";
constant first_state_addition_subtraction_direct_operand_size_2_3_4 : std_logic_vector(8 downto 0)                         := "1" & X"05";
-- 0101 iterative modular reduction
constant first_state_iterative_modular_reduction_operand_size_1 : std_logic_vector(8 downto 0)                             := "1" & X"0E";
constant first_state_iterative_modular_reduction_operand_size_2 : std_logic_vector(8 downto 0)                             := "1" & X"13";
constant first_state_iterative_modular_reduction_operand_size_3 : std_logic_vector(8 downto 0)                             := "1" & X"1B";
constant first_state_iterative_modular_reduction_operand_size_4 : std_logic_vector(8 downto 0)                             := "1" & X"26";

type state is (reset, decode_instruction, begin_instruction_execution, instruction_execution);

signal actual_state, next_state : state;

signal internal_next_sel_output_rom : std_logic;
signal internal_next_update_rom_address : std_logic;
signal internal_next_sel_load_new_rom_address : std_logic;
signal internal_next_sm_rotation_size : std_logic_vector(1 downto 0);
signal internal_next_sm_circular_shift_enable : std_logic;
signal internal_next_sel_address_a : std_logic;
signal internal_next_sel_address_b_prime : std_logic_vector(1 downto 0);
signal internal_next_sm_specific_mac_address_a : std_logic_vector(1 downto 0);
signal internal_next_sm_specific_mac_address_b : std_logic_vector(1 downto 0);
signal internal_next_sm_specific_mac_address_o : std_logic_vector(1 downto 0);
signal internal_next_sm_specific_mac_next_address_o : std_logic_vector(1 downto 0);
signal internal_next_mac_enable_signed_a : std_logic;
signal internal_next_mac_enable_signed_b : std_logic;
signal internal_next_mac_sel_load_reg_a : std_logic_vector(1 downto 0);
signal internal_next_mac_clear_reg_b : std_logic;
signal internal_next_mac_clear_reg_acc : std_logic;
signal internal_next_mac_sel_shift_reg_o : std_logic;
signal internal_next_mac_enable_update_reg_s : std_logic;
signal internal_next_mac_sel_reg_s_reg_o_sign : std_logic;
signal internal_next_mac_reg_s_reg_o_positive : std_logic;
signal internal_next_sm_sign_a_mode : std_logic;
signal internal_next_sm_mac_operation_mode : std_logic_vector(1 downto 0);
signal internal_next_mac_enable_reg_s_mask : std_logic;
signal internal_next_mac_subtraction_reg_a_b : std_logic;
signal internal_next_mac_sel_multiply_two_a_b : std_logic;
signal internal_next_mac_sel_reg_y_output : std_logic;
signal internal_next_sm_mac_write_enable_output : std_logic;
signal internal_next_mac_memory_double_mode : std_logic;
signal internal_next_mac_memory_only_write_mode : std_logic;
signal internal_next_base_address_generator_o_increment_previous_address : std_logic;
signal internal_next_sm_free_flag : std_logic;

begin

registers_state : process(clk, rstn)
begin
    if(rstn = '0') then
        actual_state <= reset;
    elsif(rising_edge(clk)) then
        actual_state <= next_state;
    end if;
end process;

registers_state_output : process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            internal_sel_output_rom <= '0';
            internal_update_rom_address <= '1';
            internal_sel_load_new_rom_address <= '0';
            internal_sm_rotation_size <= "11";
            internal_sm_circular_shift_enable <= '0';
            internal_sel_address_a <= '0';
            internal_sel_address_b_prime <= "00";
            internal_sm_specific_mac_address_a <= "00";
            internal_sm_specific_mac_address_b <= "00";
            internal_sm_specific_mac_address_o <= "00";
            internal_sm_specific_mac_next_address_o <= "01";
            internal_mac_enable_signed_a <= '0';
            internal_mac_enable_signed_b <= '0';
            internal_mac_sel_load_reg_a <= "00";
            internal_mac_clear_reg_b <= '0';
            internal_mac_clear_reg_acc <= '0';
            internal_mac_sel_shift_reg_o <= '0';
            internal_mac_enable_update_reg_s <= '0';
            internal_mac_sel_reg_s_reg_o_sign <= '0';
            internal_mac_reg_s_reg_o_positive <= '0';
            internal_sm_sign_a_mode <= '0';
            internal_sm_mac_operation_mode <= "00";
            internal_mac_enable_reg_s_mask <= '0';
            internal_mac_subtraction_reg_a_b <= '0';
            internal_mac_sel_multiply_two_a_b <= '0';
            internal_mac_sel_reg_y_output <= '0';
            internal_sm_mac_write_enable_output <= '0';
            internal_mac_memory_double_mode <= '0';
            internal_mac_memory_only_write_mode <= '0';
            internal_base_address_generator_o_increment_previous_address <= '0';
            internal_sm_free_flag <= '0';
        else
            internal_sel_output_rom <= internal_next_sel_output_rom;
            internal_update_rom_address <= internal_next_update_rom_address;
            internal_sel_load_new_rom_address <= internal_next_sel_load_new_rom_address;
            internal_sm_rotation_size <= internal_next_sm_rotation_size;
            internal_sm_circular_shift_enable <= internal_next_sm_circular_shift_enable;
            internal_sel_address_a <= internal_next_sel_address_a;
            internal_sel_address_b_prime <= internal_next_sel_address_b_prime;
            internal_sm_specific_mac_address_a <= internal_next_sm_specific_mac_address_a;
            internal_sm_specific_mac_address_b <= internal_next_sm_specific_mac_address_b;
            internal_sm_specific_mac_address_o <= internal_next_sm_specific_mac_address_o;
            internal_sm_specific_mac_next_address_o <= internal_next_sm_specific_mac_next_address_o;
            internal_mac_enable_signed_a <= internal_next_mac_enable_signed_a;
            internal_mac_enable_signed_b <= internal_next_mac_enable_signed_b;
            internal_mac_sel_load_reg_a <= internal_next_mac_sel_load_reg_a;
            internal_mac_clear_reg_b <= internal_next_mac_clear_reg_b;
            internal_mac_clear_reg_acc <= internal_next_mac_clear_reg_acc;
            internal_mac_sel_shift_reg_o <= internal_next_mac_sel_shift_reg_o;
            internal_mac_enable_update_reg_s <= internal_next_mac_enable_update_reg_s;
            internal_mac_sel_reg_s_reg_o_sign <= internal_next_mac_sel_reg_s_reg_o_sign;
            internal_mac_reg_s_reg_o_positive <= internal_next_mac_reg_s_reg_o_positive;
            internal_sm_sign_a_mode <= internal_next_sm_sign_a_mode;
            internal_sm_mac_operation_mode <= internal_next_sm_mac_operation_mode;
            internal_mac_enable_reg_s_mask <= internal_next_mac_enable_reg_s_mask;
            internal_mac_subtraction_reg_a_b <= internal_next_mac_subtraction_reg_a_b;
            internal_mac_sel_multiply_two_a_b <= internal_next_mac_sel_multiply_two_a_b;
            internal_mac_sel_reg_y_output <= internal_next_mac_sel_reg_y_output;
            internal_sm_mac_write_enable_output <= internal_next_sm_mac_write_enable_output;
            internal_mac_memory_double_mode <= internal_next_mac_memory_double_mode;
            internal_mac_memory_only_write_mode <= internal_next_mac_memory_only_write_mode;
            internal_base_address_generator_o_increment_previous_address <= internal_next_base_address_generator_o_increment_previous_address;
            internal_sm_free_flag <= internal_next_sm_free_flag;
        end if;
    end if;
end process;

update_output : process(actual_state, instruction_values_valid, instruction_type)
begin
    case (actual_state) is
        when reset =>
            internal_next_sel_output_rom <= '0';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '1';
            internal_next_sm_rotation_size <= "11";
            internal_next_sm_circular_shift_enable <= '0';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "00";
            internal_next_sm_specific_mac_address_a <= "00";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '0';
            internal_next_mac_enable_signed_b <= '0';
            internal_next_mac_sel_load_reg_a <= "11";
            internal_next_mac_clear_reg_b <= '1';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '0';
            internal_next_sm_mac_operation_mode <= "10";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '0';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
            internal_next_sm_free_flag <= '1';
        when decode_instruction =>
            internal_next_sel_output_rom <= '0';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '1';
            internal_next_sm_free_flag <= '1';
            internal_next_sm_rotation_size <= "11";
            internal_next_sm_circular_shift_enable <= '0';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "00";
            internal_next_sm_specific_mac_address_a <= "00";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '0';
            internal_next_mac_enable_signed_b <= '0';
            internal_next_mac_sel_load_reg_a <= "11";
            internal_next_mac_clear_reg_b <= '1';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '0';
            internal_next_sm_mac_operation_mode <= "10";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '0';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
            if(instruction_values_valid = '1') then
                internal_next_sm_free_flag <= '0';
                if(instruction_type = "0000") then
                    internal_next_sm_rotation_size <= "11";
                elsif(instruction_type = "0001") then
                    internal_next_sm_rotation_size <= "11";
                elsif(instruction_type = "0010") then
                    internal_next_sm_rotation_size <= "11";
                elsif(instruction_type = "0011") then
                    internal_next_sm_rotation_size <= "11";
                elsif(instruction_type = "0100") then
                    internal_next_sm_rotation_size <= "10";
                elsif(instruction_type = "0101") then
                    internal_next_sm_rotation_size <= "10";
                end if;
            end if;
        when begin_instruction_execution =>
            internal_next_sel_output_rom <= '1';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '0';
            internal_next_sm_free_flag <= '0';
            internal_next_sm_rotation_size <= "11";
            internal_next_sm_circular_shift_enable <= '1';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "00";
            internal_next_sm_specific_mac_address_a <= "00";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '0';
            internal_next_mac_enable_signed_b <= '0';
            internal_next_mac_sel_load_reg_a <= "11";
            internal_next_mac_clear_reg_b <= '1';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '0';
            internal_next_sm_mac_operation_mode <= "10";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '0';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when instruction_execution =>
            internal_next_sel_output_rom <= '1';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '0';
            internal_next_sm_free_flag <= '0';
            internal_next_sm_rotation_size <= "11";
            internal_next_sm_circular_shift_enable <= '1';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "00";
            internal_next_sm_specific_mac_address_a <= "00";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '0';
            internal_next_mac_enable_signed_b <= '0';
            internal_next_mac_sel_load_reg_a <= "11";
            internal_next_mac_clear_reg_b <= '1';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '0';
            internal_next_sm_mac_operation_mode <= "10";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '0';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
    end case;
end process;

update_state : process(actual_state, instruction_type, operands_size, instruction_values_valid, penultimate_operation, rom_last_state)
begin
case (actual_state) is
        when reset =>
            next_state <= decode_instruction;
        when decode_instruction =>
            next_state <= decode_instruction;
            if(instruction_values_valid = '1') then
                next_state <= begin_instruction_execution;
            end if;
        when begin_instruction_execution =>
            next_state <= instruction_execution;
        when instruction_execution =>
            next_state <= instruction_execution;
            if((penultimate_operation = '1') and (rom_last_state = '1')) then
                next_state <= decode_instruction;
            end if;
end case;
end process;

adder_a <= unsigned(rom_state_machine_address);
adder_b <= unsigned(rom_next_operation_same_operand_size) when (rom_current_operand_size = operands_size) else unsigned(rom_next_operation_different_operand_size);

adder_o <= adder_a + resize(adder_b, 9);

process(clk)
begin
    if (rising_edge(clk)) then
        if(internal_update_rom_address = '1') then
            if(internal_sel_load_new_rom_address = '1') then
                if(instruction_values_valid = '1') then
                    if(instruction_type = "0000") then
                        if(operands_size = "00") then
                            rom_state_machine_address <= first_state_multiplication_direct_operand_size_1;
                        else
                            rom_state_machine_address <= first_state_multiplication_direct_operand_size_2_3_4;
                        end if;
                    elsif(instruction_type = "0001") then
                        if(operands_size = "00") then
                            rom_state_machine_address <= first_state_square_direct_operand_size_1;
                        else
                            rom_state_machine_address <= first_state_square_direct_operand_size_2_3_4;
                        end if;
                    elsif(instruction_type = "0010") then
                        if(prime_line_equal_one = '1') then
                            if(operands_size = "00") then
                                rom_state_machine_address <= first_state_multiplication_with_reduction_special_prime_operand_size_1;
                            else
                                rom_state_machine_address <= first_state_multiplication_with_reduction_special_prime_operand_size_2_3_4;
                            end if;
                        else
                            if(operands_size = "00") then
                                rom_state_machine_address <= first_state_multiplication_with_reduction_operand_size_1;
                            else
                                rom_state_machine_address <= first_state_multiplication_with_reduction_operand_size_2_3_4;
                            end if;
                        end if;
                    elsif(instruction_type = "0011") then
                        if(prime_line_equal_one = '1') then
                            if(operands_size = "00") then
                                rom_state_machine_address <= first_state_square_with_reduction_special_prime_operand_size_1;
                            else
                                rom_state_machine_address <= first_state_square_with_reduction_special_prime_operand_size_2_3_4;
                            end if;
                        else
                            if(operands_size = "00") then
                                rom_state_machine_address <= first_state_square_with_reduction_operand_size_1;
                            else
                                rom_state_machine_address <= first_state_square_with_reduction_operand_size_2_3_4;
                            end if;
                        end if;
                    elsif(instruction_type = "0100") then
                        if(operands_size = "00") then
                            rom_state_machine_address <= first_state_addition_subtraction_direct_operand_size_1;
                        else
                            rom_state_machine_address <= first_state_addition_subtraction_direct_operand_size_2_3_4;
                        end if;
                    elsif(instruction_type = "0101") then
                        if(operands_size = "00") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_1;
                        elsif(operands_size = "01") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_2;
                        elsif(operands_size = "10") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_3;
                        else
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_4;
                        end if;
                    end if;
                end if;
            elsif(penultimate_operation = '1') then
                rom_state_machine_address <= std_logic_vector(adder_o);
            end if;
        end if;
    end if;
end process;

process(clk)
    begin
        if (rising_edge(clk)) then
            rom_state_machine_output <= rom_state_machine(to_integer(to_01(unsigned(rom_state_machine_address))));
        end if;
end process;

rom_sm_rotation_size <= rom_state_machine_output(1 downto 0);
rom_sel_address_a <= rom_state_machine_output(2);
rom_sel_address_b_prime <= rom_state_machine_output(4 downto 3);
rom_sm_specific_mac_address_a <= rom_state_machine_output(6 downto 5);
rom_sm_specific_mac_address_b <= rom_state_machine_output(8 downto 7);
rom_sm_specific_mac_address_o <= rom_state_machine_output(10 downto 9);
rom_sm_specific_mac_next_address_o <= rom_state_machine_output(12 downto 11);
rom_mac_enable_signed_a <= rom_state_machine_output(13);
rom_mac_enable_signed_b <= rom_state_machine_output(14);
rom_mac_sel_load_reg_a <= rom_state_machine_output(16 downto 15);
rom_mac_clear_reg_b <= rom_state_machine_output(17);
rom_mac_clear_reg_acc <= rom_state_machine_output(18);
rom_mac_sel_shift_reg_o <= rom_state_machine_output(19);
rom_mac_enable_update_reg_s <= rom_state_machine_output(20);
rom_mac_sel_reg_s_reg_o_sign <= rom_state_machine_output(21);
rom_mac_reg_s_reg_o_positive <= rom_state_machine_output(22);
rom_sm_sign_a_mode <= rom_state_machine_output(23);
rom_sm_mac_operation_mode <= rom_state_machine_output(25 downto 24);
rom_mac_enable_reg_s_mask <= rom_state_machine_output(26);
rom_mac_subtraction_reg_a_b <= rom_state_machine_output(27);
rom_mac_sel_multiply_two_a_b <= rom_state_machine_output(28);
rom_mac_sel_reg_y_output <= rom_state_machine_output(29);
rom_sm_mac_write_enable_output <= rom_state_machine_output(30);
rom_mac_memory_double_mode <= rom_state_machine_output(31);
rom_mac_memory_only_write_mode <= rom_state_machine_output(32);
rom_base_address_generator_o_increment_previous_address <= rom_state_machine_output(33);

rom_last_state <= rom_state_machine_output(34);
rom_current_operand_size <= rom_state_machine_output(36 downto 35);
rom_next_operation_same_operand_size <= rom_state_machine_output(41 downto 37);
rom_next_operation_different_operand_size <= rom_state_machine_output(46 downto 42);

sm_rotation_size <= rom_sm_rotation_size when internal_sel_output_rom = '1' else internal_sm_rotation_size;
sm_circular_shift_enable <= internal_sm_circular_shift_enable;
sel_address_a <= rom_sel_address_a when internal_sel_output_rom = '1' else internal_sel_address_a;
sel_address_b_prime <= rom_sel_address_b_prime when internal_sel_output_rom = '1' else internal_sel_address_b_prime;
sm_specific_mac_address_a <= rom_sm_specific_mac_address_a when internal_sel_output_rom = '1' else internal_sm_specific_mac_address_a;
sm_specific_mac_address_b <= rom_sm_specific_mac_address_b when internal_sel_output_rom = '1' else internal_sm_specific_mac_address_b;
sm_specific_mac_address_o <= rom_sm_specific_mac_address_o when internal_sel_output_rom = '1' else internal_sm_specific_mac_address_o;
sm_specific_mac_next_address_o <= rom_sm_specific_mac_next_address_o when internal_sel_output_rom = '1' else internal_sm_specific_mac_next_address_o;
mac_enable_signed_a <= rom_mac_enable_signed_a when internal_sel_output_rom = '1' else internal_mac_enable_signed_a;
mac_enable_signed_b <= rom_mac_enable_signed_b when internal_sel_output_rom = '1' else internal_mac_enable_signed_b;
mac_sel_load_reg_a <= rom_mac_sel_load_reg_a when internal_sel_output_rom = '1' else internal_mac_sel_load_reg_a;
mac_clear_reg_b <= rom_mac_clear_reg_b when internal_sel_output_rom = '1' else internal_mac_clear_reg_b;
mac_clear_reg_acc <= rom_mac_clear_reg_acc when internal_sel_output_rom = '1' else internal_mac_clear_reg_acc;
mac_sel_shift_reg_o <= rom_mac_sel_shift_reg_o when internal_sel_output_rom = '1' else internal_mac_sel_shift_reg_o;
mac_enable_update_reg_s <= rom_mac_enable_update_reg_s when internal_sel_output_rom = '1' else internal_mac_enable_update_reg_s;
mac_sel_reg_s_reg_o_sign <= rom_mac_sel_reg_s_reg_o_sign when internal_sel_output_rom = '1' else internal_mac_sel_reg_s_reg_o_sign;
mac_reg_s_reg_o_positive <= rom_mac_reg_s_reg_o_positive when internal_sel_output_rom = '1' else internal_mac_reg_s_reg_o_positive;
sm_sign_a_mode <= rom_sm_sign_a_mode when internal_sel_output_rom = '1' else internal_sm_sign_a_mode;
sm_mac_operation_mode <= rom_sm_mac_operation_mode when internal_sel_output_rom = '1' else internal_sm_mac_operation_mode;
mac_enable_reg_s_mask <= rom_mac_enable_reg_s_mask when internal_sel_output_rom = '1' else internal_mac_enable_reg_s_mask;
mac_subtraction_reg_a_b <= rom_mac_subtraction_reg_a_b when internal_sel_output_rom = '1' else internal_mac_subtraction_reg_a_b;
mac_sel_multiply_two_a_b <= rom_mac_sel_multiply_two_a_b when internal_sel_output_rom = '1' else internal_mac_sel_multiply_two_a_b;
mac_sel_reg_y_output <= rom_mac_sel_reg_y_output when internal_sel_output_rom = '1' else internal_mac_sel_reg_y_output;
sm_mac_write_enable_output <= rom_sm_mac_write_enable_output when internal_sel_output_rom = '1' else internal_sm_mac_write_enable_output;
mac_memory_double_mode <= rom_mac_memory_double_mode when internal_sel_output_rom = '1' else internal_mac_memory_double_mode;
mac_memory_only_write_mode <= rom_mac_memory_only_write_mode when internal_sel_output_rom = '1' else internal_mac_memory_only_write_mode;
base_address_generator_o_increment_previous_address <= rom_base_address_generator_o_increment_previous_address when internal_sel_output_rom = '1' else internal_base_address_generator_o_increment_previous_address;
sm_free_flag <= internal_sm_free_flag;

end compact_memory_based;


architecture compact_memory_based_v2 of carmela_state_machine_v256 is

type romtype is array(integer range <>) of std_logic_vector(46 downto 0);

constant rom_state_machine_program : romtype(0 to 307) := (
-- 0000 multiplication with no reduction
-- -- In case of size 1
-- Multiplication direct 0
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; o1_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010000111000010000001000110100000000011",
                           
-- NOP 8 stages                         
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 2, 3, 4       
-- Multiplication direct 2          
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00101000010100001000010000001000000100000000011",
-- -- In case of size 2             
-- Multiplication direct 3          
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"00001000010100000000010000010000011001000100011",
-- Multiplication direct 4          
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o; o1_0 = reg_o; Enable sign b; operation : a*b + acc;
"00001000010100001000010000000000101001010000011",
-- Multiplication direct 5          
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 272; o2_0 = reg_o; o3_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010100111000010000010000111110010100011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 3, 4          
-- Multiplication direct 7          
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011000000000010000010000001001000100011",
-- Multiplication direct 8          
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000001001010000011",
-- Multiplication direct 9          
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00111000011000000000010000010000001110010100011",
-- -- In case of size 3             
-- Multiplication direct 10          
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"00001000011000000000010000000000101110100000011",
-- Multiplication direct 11          
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000001000010000000000011110001000011",
-- Multiplication direct 12          
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"00001000011000000000010000010000010011011000011",
-- Multiplication direct 13         
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign b; operation : a*b + acc; Increment o3_0 base address
"00001000011001001000010000000000100011100100011",
-- Multiplication direct 14         
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 272; o4_0 = reg_o; o5_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011000111000010000010000110100101000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 4             
-- Multiplication direct 16          
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000001110100000011",
-- Multiplication direct 17          
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001110001000011",
-- Multiplication direct 18          
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011100000000010000010000000011011000011",
-- Multiplication direct 19         
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000011100100011",
-- Multiplication direct 20         
-- reg_a = a3_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010011001100011",
-- Multiplication direct 21         
-- reg_a = a0_0; reg_b = b3_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign b; operation : a*b + acc; Increment o3_0 base address
"00001000011101001000010000000000100011110000011",
-- Multiplication direct 22         
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011100000000010000010000000100101000011",
-- Multiplication direct 23         
-- reg_a = a3_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100011100011",
-- Multiplication direct 24         
-- reg_a = a1_0; reg_b = b3_0; reg_acc = reg_o; o4_0 = reg_o; Enable sign b; operation : a*b + acc;
"00001000011100001000010000000000100100110100011",
-- Multiplication direct 25         
-- reg_a = a3_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"00001000011100000000010000010000011001101100011",
-- Multiplication direct 26         
-- reg_a = a2_0; reg_b = b3_0; reg_acc = reg_o; o5_0 = reg_o; Enable sign b; operation : a*b + acc;
"00001000011100001000010000000000101001111000011",
-- Multiplication direct 27         
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 272; o6_0 = reg_o; o7_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011100111000010000010000001110111100011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--- 29 Instructions                 
-------------------------------------------------------------
-- 0001 square with no reduction                                                                                           
--                                  
-- -- In case of size 1             
-- Square direct 0                  
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; o1_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010000111000010000001000110100000000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 2, 3, 4       
-- Square direct 2                  
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00100000010100001000010000001000000100000000011",
-- -- In case of size 2             
-- Square direct 3                  
-- reg_a = a1_0; reg_b = a0_0; reg_acc = reg_o >> 272; o1_0 = reg_o; Enable sign a; operation : 2*a*b + acc;
"00001000010100001010010000010000011001000100011",
-- Square direct 4                  
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 272; o2_0 = reg_o; o3_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010100111000010000010000111110010100011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- In case of 3, 4                  
-- Square direct 6                  
-- reg_a = a1_0; reg_b = a0_0; reg_acc = reg_o >> 272; o1_0 = reg_o; operation : 2*a*b + acc;
"00001000011000001010010000010000001001000100011",
-- Square direct 7                  
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00101000011000000000010000010000001110010100011",
-- -- In case of size 3             
-- Square direct 8                  
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign b; operation : 2*a*b + acc;
"00100000011000001010010000000000101110100000011",
-- Square direct 9                  
-- reg_a = a2_0; reg_b = a1_0; reg_acc = reg_o >> 272; o3_0 = reg_o; Enable sign a; operation : 2*a*b + acc; Increment o3_0 base address
"00001000011001001010010000010000010011011000011",
-- Square direct 10                  
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 272; o4_0 = reg_o; o5_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011000111000010000010000110100101000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 4             
-- Square direct 12                  
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; o2_0 = reg_o; operation : 2*a*b + acc;
"00001000011100001010010000000000001110100000011",
-- Square direct 13                 
-- reg_a = a2_0; reg_b = a1_0; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"00001000011100000010010000010000000011011000011",
-- Square direct 14                 
-- reg_a = a3_0; reg_b = a0_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign a; operation : 2*a*b + acc; Increment o3_0 base address
"00001000011101001010010000000000010011001100011",
-- Square direct 15                 
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011100000000010000010000000100101000011",
-- Square direct 16                 
-- reg_a = a3_0; reg_b = a1_0; reg_acc = reg_o; o4_0 = reg_o; Enable sign a; operation : 2*a*b + acc;
"00001000011100001010010000000000010100011100011",
-- Square direct 17                 
-- reg_a = a3_0; reg_b = a2_0; reg_acc = reg_o >> 272; o5_0 = reg_o; Enable sign a; operation : 2*a*b + acc;
"00001000011100001010010000010000011001101100011",
-- Square direct 18                 
-- reg_a = a3_0; reg_b = a3_0; reg_acc = reg_o >> 272; o6_0 = reg_o; o7_0 = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011100111000010000010000111110111100011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--- 49 Instructions                 
-------------------------------------------------------------
-- 0010 multiplication  with reduction and prime line not equal to 1
-- -- In case of size 1             
-- Multiplication with reduction 0  
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
-- Multiplication with reduction 1  
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010000001100011000000010000100000011011",
-- Multiplication with reduction 2  
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010000000000010000000001000100000010011",
-- Multiplication with reduction 3  
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 272; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 2, 3, 4       
-- Multiplication with reduction 5  
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; operation : a*b + acc;
"00001000010100000000010000001000000100000000011",
-- Multiplication with reduction 6  
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010000100000011011",
-- Multiplication with reduction 7  
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"01001000010100000000010000000001000100000010011",
-- -- In case of size 2             
-- Multiplication with reduction 8  
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000010100000000010000010000100100010000011",
-- Multiplication with reduction 9  
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000000000100010010111",
-- Multiplication with reduction 10 
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000010100000000010000000000010100000100011",
-- Multiplication with reduction 11 
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010001001000011011",
-- Multiplication with reduction 12 
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000001000100000010011",
-- Multiplication with reduction 13 
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
-- Multiplication with reduction 14 
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 272; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 3, 4          
-- Multiplication with reduction 16 
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011000000000010000010000000100010000011",
-- Multiplication with reduction 17 
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010010111",
-- Multiplication with reduction 18 
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100000100011",
-- Multiplication with reduction 19 
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001001000011011",
-- Multiplication with reduction 20 
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"01111000011000000000010000000001000100000010011",
-- -- In case of size 3             
-- Multiplication with reduction 21 
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011000000000010000010000100100100000011",
-- Multiplication with reduction 22 
-- reg_a = o0_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100010111",
-- Multiplication with reduction 23 
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
-- Multiplication with reduction 24 
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010110111",
-- Multiplication with reduction 25 
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000000000010000000000010100001000011",
-- Multiplication with reduction 26 
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001110000011011",
-- Multiplication with reduction 27 
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000001000100000010011",
-- Multiplication with reduction 28 
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011000000000010000010000100100100100011",
-- Multiplication with reduction 29 
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
-- Multiplication with reduction 30 
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000000000010000000000010100011000011",
-- Multiplication with reduction 31 
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
-- Multiplication with reduction 32 
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
-- Multiplication with reduction 33 
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 272; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 4             
-- Multiplication with reduction 35 
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011100000000010000010000000100100000011",
-- Multiplication with reduction 36 
-- reg_a = o0_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100010111",
-- Multiplication with reduction 37 
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010100011",
-- Multiplication with reduction 38 
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010110111",
-- Multiplication with reduction 39 
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100001000011",
-- Multiplication with reduction 40 
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010001110000011011",
-- Multiplication with reduction 41 
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
-- Multiplication with reduction 42 
-- reg_a = a0_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110000011",
-- Multiplication with reduction 43 
-- reg_a = o0_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
-- Multiplication with reduction 44 
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100100011",
-- Multiplication with reduction 45 
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
-- Multiplication with reduction 46 
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011000011",
-- Multiplication with reduction 47 
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011010111",
-- Multiplication with reduction 48 
-- reg_a = a3_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100001100011",
-- Multiplication with reduction 49 
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o3_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010000011000011011",
-- Multiplication with reduction 50 
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
-- Multiplication with reduction 51 
-- reg_a = a1_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110100011",
-- Multiplication with reduction 52 
-- reg_a = o1_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
-- Multiplication with reduction 53 
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
-- Multiplication with reduction 54 
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
-- Multiplication with reduction 55 
-- reg_a = a3_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100011100011",
-- Multiplication with reduction 56 
-- reg_a = o3_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
-- Multiplication with reduction 57 
-- reg_a = a2_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100111000011",
-- Multiplication with reduction 58 
-- reg_a = o2_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
-- Multiplication with reduction 59 
-- reg_a = a3_0; reg_b = b2_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100101100011",
-- Multiplication with reduction 60 
-- reg_a = o3_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
-- Multiplication with reduction 61 
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
-- Multiplication with reduction 62 
-- reg_a = o3_0; reg_b = prime3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 272; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--- 113 Instructions                
-------------------------------------------------------------
-- 0010 multiplication  with reduction and prime line equal to 1
-- -- In case of size 1             
--  Multiplication with reduction special prime 0
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
--  Multiplication with reduction special prime 1
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 272; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of sizes 2, 3, 4      
--  Multiplication with reduction special prime 3
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00111000010100001000010000001000000100000000011",
-- -- In case of size 2             
--  Multiplication with reduction special prime 4
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000010100000000010000010000100100010000011",
--  Multiplication with reduction special prime 5
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000000000100010010111",
--  Multiplication with reduction special prime 6
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; o1_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000010100001000010000000000011001000100011",
--  Multiplication with reduction special prime 7
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
--  Multiplication with reduction special prime 8
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 272; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of sizes 3, 4         
--  Multiplication with reduction special prime 10
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011000000000010000010000000100010000011",
--  Multiplication with reduction special prime 11
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010010111",
--  Multiplication with reduction special prime 12
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"01101000011000001000010000000000001001000100011",
-- -- In case of sizes 3            
--  Multiplication with reduction special prime 13
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011000000000010000010000100100100000011",
--  Multiplication with reduction special prime 14
-- reg_a = o0_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100010111",
--  Multiplication with reduction special prime 15
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
--  Multiplication with reduction special prime 16
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010110111",
--  Multiplication with reduction special prime 17
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000001000010000000000011110001000011",
--  Multiplication with reduction special prime 18
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011000000000010000010000100100100100011",
--  Multiplication with reduction special prime 19
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
--  Multiplication with reduction special prime 20
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000000000010000000000010100011000011",
--  Multiplication with reduction special prime 21
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
--  Multiplication with reduction special prime 22
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
--  Multiplication with reduction special prime 23
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 272; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of sizes 4            
--  Multiplication with reduction special prime 25
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o >> 272; operation : a*b + acc;
"00001000011100000000010000010000000100100000011",
--  Multiplication with reduction special prime 26
-- reg_a = o0_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100010111",
--  Multiplication with reduction special prime 27
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010100011",
--  Multiplication with reduction special prime 28
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010110111",
--  Multiplication with reduction special prime 29
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001110001000011",
--  Multiplication with reduction special prime 30
-- reg_a = a0_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110000011",
--  Multiplication with reduction special prime 31
-- reg_a = o0_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
--  Multiplication with reduction special prime 32
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100100011",
--  Multiplication with reduction special prime 33
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
--  Multiplication with reduction special prime 34
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011000011",
--  Multiplication with reduction special prime 35
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011010111",
--  Multiplication with reduction special prime 36
-- reg_a = a3_0; reg_b = b0_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100001000010000000000010011001100011",
--  Multiplication with reduction special prime 37
-- reg_a = a1_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110100011",
--  Multiplication with reduction special prime 38
-- reg_a = o1_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
--  Multiplication with reduction special prime 39
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
--  Multiplication with reduction special prime 40
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
--  Multiplication with reduction special prime 41
-- reg_a = a3_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100011100011",
--  Multiplication with reduction special prime 42
-- reg_a = o3_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
--  Multiplication with reduction special prime 43
-- reg_a = a2_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100111000011",
--  Multiplication with reduction special prime 44
-- reg_a = o2_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
--  Multiplication with reduction special prime 45
-- reg_a = a3_0; reg_b = b2_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100101100011",
--  Multiplication with reduction special prime 46
-- reg_a = o3_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
--  Multiplication with reduction special prime 47
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
--  Multiplication with reduction special prime 48
-- reg_a = o3_0; reg_b = primeSP3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 272; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--- 163  Instructions               
-------------------------------------------------------------
-- 0011 square with reduction and prime line not equal to 1
-- -- In case of size 1             
--  Square with reduction 0         
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
--  Square with reduction 1         
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010000001100011000000010000100000011011",
--  Square with reduction 2         
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010000000000010000000001000100000010011",
--  Square with reduction 3         
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 272; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 2, 3, 4       
--  Square with reduction 5         
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; operation : a*b + acc;
"00001000010100000000010000001000000100000000011",
--  Square with reduction 6         
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010000100000011011",
--  Square with reduction 7         
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"01000000010100000000010000000001000100000010011",
-- -- In case of size 2             
--  Square with reduction 8         
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000010100000010010000010000100100010000011",
--  Square with reduction 9         
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000000000100010010111",
--  Square with reduction 10         
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010001001000111011",
--  Square with reduction 11         
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000001000100000110011",
--  Square with reduction 12         
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
--  Square with reduction 13         
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 272; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 3, 4          
--  Square with reduction 15         
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"00001000011000000010010000010000000100010000011",
--  Square with reduction 16         
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010010111",
--  Square with reduction 17         
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001001000111011",
--  Square with reduction 18         
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"01101000011000000000010000000001000100000110011",
-- -- In case of size 3             
--  Square with reduction 19        
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000010000100100100000011",
--  Square with reduction 20        
-- reg_a = o0_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100010111",
--  Square with reduction 21        
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
--  Square with reduction 22        
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010110111",
--  Square with reduction 23        
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001110000011011",
--  Square with reduction 24        
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000001000100000010011",
--  Square with reduction 25        
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000010000100100100100011",
--  Square with reduction 26        
-- reg_a = o1_0; reg_b  = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
--  Square with reduction 27        
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
--  Square with reduction 28        
-- reg_a = a2_0; reg_b  = a2_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
--  Square with reduction 29        
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 272; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 4             
--  Square with reduction 31        
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"00001000011100000010010000010000000100100000011",
--  Square with reduction 32        
-- reg_a = o0_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100010111",
--  Square with reduction 33        
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010100011",
--  Square with reduction 34        
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010110111",
--  Square with reduction 35        
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010001110000011011",
--  Square with reduction 36        
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
--  Square with reduction 37        
-- reg_a = a0_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110000011",
--  Square with reduction 38        
-- reg_a = o0_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
--  Square with reduction 39        
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o; operation : 2*a*b + acc;
"00001000011100000010010000000000000100100100011",
--  Square with reduction 40        
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
--  Square with reduction 41        
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011010111",
--  Square with reduction 42        
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o3_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010000011000011011",
--  Square with reduction 43        
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
--  Square with reduction 44        
-- reg_a = a1_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110100011",
--  Square with reduction 45        
-- reg_a = o1_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
--  Square with reduction 46        
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
--  Square with reduction 47        
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
--  Square with reduction 48        
-- reg_a = o3_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
--  Square with reduction 49        
-- reg_a = a2_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100111000011",
--  Square with reduction 50        
-- reg_a = o2_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
--  Square with reduction 51        
-- reg_a = o3_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
--  Square with reduction 52        
-- reg_a = a3_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
--  Square with reduction 53        
-- reg_a = o3_0; reg_b = prime3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 272; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--- 218  Instructions               
-------------------------------------------------------------
-- 0011 square with reduction and prime line equal to 1
-- -- In case of size 1             
-- Square with reduction special prime 0
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
-- Square with reduction special prime 1
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 272; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 2, 3, 4       
-- Square with reduction special prime 3
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00110000010100001000010000001000000100000000011",
-- -- In case of size 2             
-- Square with reduction special prime 4
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000010100000010010000010000100100010000011",
-- Square with reduction special prime 5
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000010100001000010000000000001001010010111", 
-- Square with reduction special prime 6
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
-- Square with reduction special prime 7
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 272; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 3, 4          
-- Square with reduction special prime 9
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"00001000011000000010010000010000000100010000011",
-- Square with reduction special prime 10
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"01011000011000001000010000000000001001010010111", 
-- -- In case of size 3             
-- Square with reduction special prime 11
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000010000100100100000011",
-- Square with reduction special prime 12
-- reg_a = o0_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100010111",
-- Square with reduction special prime 13
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
-- Square with reduction special prime 14
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; o2_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000001110010110111",
-- Square with reduction special prime 15
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000010000100100100100011",
-- Square with reduction special prime 16
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
-- Square with reduction special prime 17
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
-- Square with reduction special prime 18
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
-- Square with reduction special prime 19
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 272; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
-- -- In case of size 4             
-- Square with reduction special prime 21
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"00001000011100000010010000010000000100100000011",
-- Square with reduction special prime 22
-- reg_a = o0_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100010111",
-- Square with reduction special prime 23
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100010100011",
-- Square with reduction special prime 24
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; o2_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001110010110111",
-- Square with reduction special prime 25
-- reg_a = a0_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110000011",
-- Square with reduction special prime 26
-- reg_a = o0_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
-- Square with reduction special prime 27
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o; operation : 2*a*b + acc;
"00001000011100000010010000000000000100100100011",
-- Square with reduction special prime 28
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
-- Square with reduction special prime 29
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; o3_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000011011010111",
-- Square with reduction special prime 30
-- reg_a = a1_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110100011",
-- Square with reduction special prime 31
-- reg_a = o1_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
-- Square with reduction special prime 32
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
-- Square with reduction special prime 33
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
-- Square with reduction special prime 34
-- reg_a = o3_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
-- Square with reduction special prime 35
-- reg_a = a2_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100111000011",
-- Square with reduction special prime 36
-- reg_a = o2_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
-- Square with reduction special prime 37
-- reg_a = o3_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
-- Square with reduction special prime 38
-- reg_a = a3_0; reg_b = a3_0; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
-- Square with reduction special prime 39
-- reg_a = o3_0; reg_b = primeSP3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 272; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
-- NOP 8 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--- 259  Instructions               
-------------------------------------------------------------
-- 0100 addition with no reduction    
-- -- In case of size 1               
-- Addition subtraction direct 0      
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000010000001000000100001000110100000000010",
-- NOP 4 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
-- -- In case of size 2, 3, 4       
-- Addition subtraction direct 2    
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : b +/- a + acc;
"00011000010100001000000100001000000100000000010",
-- -- In case of size 2             
-- Addition subtraction direct 3    
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 272; o1_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000010100001000000100010000111001010100010",
-- NOP 4 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
-- -- In case of size 3, 4          
-- Addition subtraction direct 5    
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 272; o1_0 = reg_o; operation : b +/- a + acc;
"00011000011000001000000100010000001001010100010",
-- -- In case of size 3             
-- Addition subtraction direct 6    
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 272; o2_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000011000001000000100010000110110101000010",
-- NOP 4 stages                     
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
-- -- In case of size 4             
-- Addition subtraction direct 8    
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 272; o2_0 = reg_o; operation : b +/- a + acc;
"00001000011000001000000100010000000110101000010",
-- Addition subtraction direct 9    
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 272; o3_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000011100001000000100010000110011111100010",
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--- 270  Instructions            
-------------------------------------------------------------
-- 0101 iterative modular reduction
-- -- In case of size 1             
-- Iterative modular reduction 0
"00001000010000000000001000001100110100000010010",
-- Iterative modular reduction 1
"00001000010000000001100011100011110100000010010",
-- Iterative modular reduction 2
"00001000010000000000101001100011110100000010010",
-- Iterative modular reduction 3
"00001000010000001000101001100011110100000010010",
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
-- -- In case of size 2             
-- Iterative modular reduction 5
"00001000010100000000001000001100110100000110010",
-- Iterative modular reduction 6
"00001000010100001001100011101000000100000010010",
-- Iterative modular reduction 7
"00001000010100001001100000010000111001010110010",
-- Iterative modular reduction 8
"00001000010100001000101001101000000100000010110",
-- Iterative modular reduction 9
"00001000010100001000101000010000111001010110110",
-- Iterative modular reduction 10
"00001000010100001000101001101000000100000010110",
-- Iterative modular reduction 11
"00001000010100001000101000010000111001010110110",
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
-- -- In case of size 3             
-- Iterative modular reduction 13
"00001000011000000000001000001100111110101010010",
-- Iterative modular reduction 14
"00001000011000001001100011101000000100000010010",
-- Iterative modular reduction 15
"00001000011000001001100000010000001001010110010",
-- Iterative modular reduction 16
"00001000011000001001100000010000111110101010010",
-- Iterative modular reduction 17
"00001000011000001000101001101000000100000010110",
-- Iterative modular reduction 18
"00001000011000001000101000010000001001010110110",
-- Iterative modular reduction 19
"00001000011000001000101000010000111110101010110",
-- Iterative modular reduction 20
"00001000011000001000101001101000000100000010110",
-- Iterative modular reduction 21
"00001000011000001000101000010000001001010110110",
-- Iterative modular reduction 22
"00001000011000001000101000010000111110101010110",
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
-- -- In case of size 4             
-- Iterative modular reduction 24
"00001000011100000000001000001100110011111110010",
-- Iterative modular reduction 25
"00001000011100001001100011101000000100000010010",
-- Iterative modular reduction 26
"00001000011100001001100000010000001001010110010",
-- Iterative modular reduction 27
"00001000011100001001100000010000001110101010010",
-- Iterative modular reduction 28
"00001000011100001001100000010000110011111110010",
-- Iterative modular reduction 29
"00001000011100001000101001101000000100000010110",
-- Iterative modular reduction 30
"00001000011100001000101000010000001001010110110",
-- Iterative modular reduction 31
"00001000011100001000101000010000001110101010110",
-- Iterative modular reduction 32
"00001000011100001000101000010000110011111110110",
-- Iterative modular reduction 33
"00001000011100001000101001101000000100000010110",
-- Iterative modular reduction 34
"00001000011100001000101000010000001001010110110",
-- Iterative modular reduction 35
"00001000011100001000101000010000001110101010110",
-- Iterative modular reduction 36
"00001000011100001000101000010000110011111110110",
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010"
--------- 308 Instructions                
-----------------------------------------------------------------
);



constant rom_state_machine_fill_nop : romtype(308 to 511) := (others => "00000000000010000000010000001111000100000000011");
constant rom_state_machine : romtype(0 to 511) := rom_state_machine_program & rom_state_machine_fill_nop;

signal rom_state_machine_address : std_logic_vector(8 downto 0);
signal rom_state_machine_output : std_logic_vector(46 downto 0);

signal rom_sm_rotation_size : std_logic_vector(1 downto 0);
signal rom_sel_address_a : std_logic;
signal rom_sel_address_b_prime : std_logic_vector(1 downto 0);
signal rom_sm_specific_mac_address_a : std_logic_vector(1 downto 0);
signal rom_sm_specific_mac_address_b : std_logic_vector(1 downto 0);
signal rom_sm_specific_mac_address_o : std_logic_vector(1 downto 0);
signal rom_sm_specific_mac_next_address_o : std_logic_vector(1 downto 0);
signal rom_mac_enable_signed_a : std_logic;
signal rom_mac_enable_signed_b : std_logic;
signal rom_mac_sel_load_reg_a : std_logic_vector(1 downto 0);
signal rom_mac_clear_reg_b : std_logic;
signal rom_mac_clear_reg_acc : std_logic;
signal rom_mac_sel_shift_reg_o : std_logic;
signal rom_mac_enable_update_reg_s : std_logic;
signal rom_mac_sel_reg_s_reg_o_sign : std_logic;
signal rom_mac_reg_s_reg_o_positive : std_logic;
signal rom_sm_sign_a_mode : std_logic;
signal rom_sm_mac_operation_mode : std_logic_vector(1 downto 0);
signal rom_mac_enable_reg_s_mask : std_logic;
signal rom_mac_subtraction_reg_a_b : std_logic;
signal rom_mac_sel_multiply_two_a_b : std_logic;
signal rom_mac_sel_reg_y_output : std_logic;
signal rom_mac_enable_sign_output : std_logic;
signal rom_sm_mac_write_enable_output : std_logic;
signal rom_mac_memory_double_mode : std_logic;
signal rom_mac_memory_only_write_mode : std_logic;
signal rom_base_address_generator_o_increment_previous_address : std_logic;

signal rom_last_state : std_logic;
signal rom_current_operand_size : std_logic_vector(1 downto 0);
signal rom_next_operation_same_operand_size : std_logic_vector(4 downto 0);
signal rom_next_operation_different_operand_size : std_logic_vector(4 downto 0);

signal adder_a : unsigned(8 downto 0);
signal adder_b : unsigned(4 downto 0);
signal adder_o : unsigned(8 downto 0);

signal ultimate_instruction : std_logic;

signal internal_sel_output_rom : std_logic;
signal internal_update_rom_address : std_logic;
signal internal_sel_load_new_rom_address : std_logic;
signal internal_sm_rotation_size : std_logic_vector(1 downto 0);
signal internal_sm_circular_shift_enable : std_logic;
signal internal_sel_address_a : std_logic;
signal internal_sel_address_b_prime : std_logic_vector(1 downto 0);
signal internal_sm_specific_mac_address_a : std_logic_vector(1 downto 0);
signal internal_sm_specific_mac_address_b : std_logic_vector(1 downto 0);
signal internal_sm_specific_mac_address_o : std_logic_vector(1 downto 0);
signal internal_sm_specific_mac_next_address_o : std_logic_vector(1 downto 0);
signal internal_mac_enable_signed_a : std_logic;
signal internal_mac_enable_signed_b : std_logic;
signal internal_mac_sel_load_reg_a : std_logic_vector(1 downto 0);
signal internal_mac_clear_reg_b : std_logic;
signal internal_mac_clear_reg_acc : std_logic;
signal internal_mac_sel_shift_reg_o : std_logic;
signal internal_mac_enable_update_reg_s : std_logic;
signal internal_mac_sel_reg_s_reg_o_sign : std_logic;
signal internal_mac_reg_s_reg_o_positive : std_logic;
signal internal_sm_sign_a_mode : std_logic;
signal internal_sm_mac_operation_mode : std_logic_vector(1 downto 0);
signal internal_mac_enable_reg_s_mask : std_logic;
signal internal_mac_subtraction_reg_a_b : std_logic;
signal internal_mac_sel_multiply_two_a_b : std_logic;
signal internal_mac_sel_reg_y_output : std_logic;
signal internal_sm_mac_write_enable_output : std_logic;
signal internal_mac_memory_double_mode : std_logic;
signal internal_mac_memory_only_write_mode : std_logic;
signal internal_base_address_generator_o_increment_previous_address : std_logic;
signal internal_sm_free_flag : std_logic;

-- 0000 multiplication with no reduction
constant first_state_multiplication_direct_operand_size_1 : std_logic_vector(8 downto 0)                                   := "0" & X"00";
constant first_state_multiplication_direct_operand_size_2_3_4 : std_logic_vector(8 downto 0)                               := "0" & X"02";
-- 0001 square with no reduction                                                                                           
constant first_state_square_direct_operand_size_1 : std_logic_vector(8 downto 0)                                           := "0" & X"1D";
constant first_state_square_direct_operand_size_2_3_4 : std_logic_vector(8 downto 0)                                       := "0" & X"1F";
-- 0010 multiplication with reduction and prime line not equal to 1
constant first_state_multiplication_with_reduction_operand_size_1 : std_logic_vector(8 downto 0)                           := "0" & X"31";
constant first_state_multiplication_with_reduction_operand_size_2_3_4 : std_logic_vector(8 downto 0)                       := "0" & X"36";
-- 0010 multiplication with reduction and prime line equal to 1
constant first_state_multiplication_with_reduction_special_prime_operand_size_1 : std_logic_vector(8 downto 0)             := "0" & X"71";
constant first_state_multiplication_with_reduction_special_prime_operand_size_2_3_4 : std_logic_vector(8 downto 0)         := "0" & X"74";
-- 0011 square with reduction and prime line not equal to 1
constant first_state_square_with_reduction_operand_size_1 : std_logic_vector(8 downto 0)                                   := "0" & X"A3";
constant first_state_square_with_reduction_operand_size_2_3_4 : std_logic_vector(8 downto 0)                               := "0" & X"A8";
-- 0011 square with reduction and prime line equal to 1
constant first_state_square_with_reduction_special_prime_operand_size_1 : std_logic_vector(8 downto 0)                     := "0" & X"DA";
constant first_state_square_with_reduction_special_prime_operand_size_2_3_4 : std_logic_vector(8 downto 0)                 := "0" & X"DD";
-- 0100 addition with no reduction
constant first_state_addition_subtraction_direct_operand_size_1 : std_logic_vector(8 downto 0)                             := "1" & X"03";
constant first_state_addition_subtraction_direct_operand_size_2_3_4 : std_logic_vector(8 downto 0)                         := "1" & X"05";
-- 0101 iterative modular reduction
constant first_state_iterative_modular_reduction_operand_size_1 : std_logic_vector(8 downto 0)                             := "1" & X"0E";
constant first_state_iterative_modular_reduction_operand_size_2 : std_logic_vector(8 downto 0)                             := "1" & X"13";
constant first_state_iterative_modular_reduction_operand_size_3 : std_logic_vector(8 downto 0)                             := "1" & X"1B";
constant first_state_iterative_modular_reduction_operand_size_4 : std_logic_vector(8 downto 0)                             := "1" & X"26";

type state is (reset, decode_instruction, instruction_execution);

signal actual_state, next_state : state;

signal internal_next_sel_output_rom : std_logic;
signal internal_next_update_rom_address : std_logic;
signal internal_next_sel_load_new_rom_address : std_logic;
signal internal_next_sm_rotation_size : std_logic_vector(1 downto 0);
signal internal_next_sm_circular_shift_enable : std_logic;
signal internal_next_sel_address_a : std_logic;
signal internal_next_sel_address_b_prime : std_logic_vector(1 downto 0);
signal internal_next_sm_specific_mac_address_a : std_logic_vector(1 downto 0);
signal internal_next_sm_specific_mac_address_b : std_logic_vector(1 downto 0);
signal internal_next_sm_specific_mac_address_o : std_logic_vector(1 downto 0);
signal internal_next_sm_specific_mac_next_address_o : std_logic_vector(1 downto 0);
signal internal_next_mac_enable_signed_a : std_logic;
signal internal_next_mac_enable_signed_b : std_logic;
signal internal_next_mac_sel_load_reg_a : std_logic_vector(1 downto 0);
signal internal_next_mac_clear_reg_b : std_logic;
signal internal_next_mac_clear_reg_acc : std_logic;
signal internal_next_mac_sel_shift_reg_o : std_logic;
signal internal_next_mac_enable_update_reg_s : std_logic;
signal internal_next_mac_sel_reg_s_reg_o_sign : std_logic;
signal internal_next_mac_reg_s_reg_o_positive : std_logic;
signal internal_next_sm_sign_a_mode : std_logic;
signal internal_next_sm_mac_operation_mode : std_logic_vector(1 downto 0);
signal internal_next_mac_enable_reg_s_mask : std_logic;
signal internal_next_mac_subtraction_reg_a_b : std_logic;
signal internal_next_mac_sel_multiply_two_a_b : std_logic;
signal internal_next_mac_sel_reg_y_output : std_logic;
signal internal_next_sm_mac_write_enable_output : std_logic;
signal internal_next_mac_memory_double_mode : std_logic;
signal internal_next_mac_memory_only_write_mode : std_logic;
signal internal_next_base_address_generator_o_increment_previous_address : std_logic;
signal internal_next_sm_free_flag : std_logic;

begin

registers_state : process(clk, rstn)
begin
    if(rstn = '0') then
        actual_state <= reset;
    elsif(rising_edge(clk)) then
        actual_state <= next_state;
    end if;
end process;

registers_state_output : process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            internal_sel_output_rom <= '0';
            internal_update_rom_address <= '1';
            internal_sel_load_new_rom_address <= '1';
            internal_sm_rotation_size <= "11";
            internal_sm_circular_shift_enable <= '0';
            internal_sel_address_a <= '0';
            internal_sel_address_b_prime <= "00";
            internal_sm_specific_mac_address_a <= "00";
            internal_sm_specific_mac_address_b <= "00";
            internal_sm_specific_mac_address_o <= "00";
            internal_sm_specific_mac_next_address_o <= "01";
            internal_mac_enable_signed_a <= '0';
            internal_mac_enable_signed_b <= '0';
            internal_mac_sel_load_reg_a <= "00";
            internal_mac_clear_reg_b <= '0';
            internal_mac_clear_reg_acc <= '0';
            internal_mac_sel_shift_reg_o <= '0';
            internal_mac_enable_update_reg_s <= '0';
            internal_mac_sel_reg_s_reg_o_sign <= '0';
            internal_mac_reg_s_reg_o_positive <= '0';
            internal_sm_sign_a_mode <= '0';
            internal_sm_mac_operation_mode <= "00";
            internal_mac_enable_reg_s_mask <= '0';
            internal_mac_subtraction_reg_a_b <= '0';
            internal_mac_sel_multiply_two_a_b <= '0';
            internal_mac_sel_reg_y_output <= '0';
            internal_sm_mac_write_enable_output <= '0';
            internal_mac_memory_double_mode <= '0';
            internal_mac_memory_only_write_mode <= '0';
            internal_base_address_generator_o_increment_previous_address <= '0';
            internal_sm_free_flag <= '0';
        else
            internal_sel_output_rom <= internal_next_sel_output_rom;
            internal_update_rom_address <= internal_next_update_rom_address;
            internal_sel_load_new_rom_address <= internal_next_sel_load_new_rom_address;
            internal_sm_rotation_size <= internal_next_sm_rotation_size;
            internal_sm_circular_shift_enable <= internal_next_sm_circular_shift_enable;
            internal_sel_address_a <= internal_next_sel_address_a;
            internal_sel_address_b_prime <= internal_next_sel_address_b_prime;
            internal_sm_specific_mac_address_a <= internal_next_sm_specific_mac_address_a;
            internal_sm_specific_mac_address_b <= internal_next_sm_specific_mac_address_b;
            internal_sm_specific_mac_address_o <= internal_next_sm_specific_mac_address_o;
            internal_sm_specific_mac_next_address_o <= internal_next_sm_specific_mac_next_address_o;
            internal_mac_enable_signed_a <= internal_next_mac_enable_signed_a;
            internal_mac_enable_signed_b <= internal_next_mac_enable_signed_b;
            internal_mac_sel_load_reg_a <= internal_next_mac_sel_load_reg_a;
            internal_mac_clear_reg_b <= internal_next_mac_clear_reg_b;
            internal_mac_clear_reg_acc <= internal_next_mac_clear_reg_acc;
            internal_mac_sel_shift_reg_o <= internal_next_mac_sel_shift_reg_o;
            internal_mac_enable_update_reg_s <= internal_next_mac_enable_update_reg_s;
            internal_mac_sel_reg_s_reg_o_sign <= internal_next_mac_sel_reg_s_reg_o_sign;
            internal_mac_reg_s_reg_o_positive <= internal_next_mac_reg_s_reg_o_positive;
            internal_sm_sign_a_mode <= internal_next_sm_sign_a_mode;
            internal_sm_mac_operation_mode <= internal_next_sm_mac_operation_mode;
            internal_mac_enable_reg_s_mask <= internal_next_mac_enable_reg_s_mask;
            internal_mac_subtraction_reg_a_b <= internal_next_mac_subtraction_reg_a_b;
            internal_mac_sel_multiply_two_a_b <= internal_next_mac_sel_multiply_two_a_b;
            internal_mac_sel_reg_y_output <= internal_next_mac_sel_reg_y_output;
            internal_sm_mac_write_enable_output <= internal_next_sm_mac_write_enable_output;
            internal_mac_memory_double_mode <= internal_next_mac_memory_double_mode;
            internal_mac_memory_only_write_mode <= internal_next_mac_memory_only_write_mode;
            internal_base_address_generator_o_increment_previous_address <= internal_next_base_address_generator_o_increment_previous_address;
            internal_sm_free_flag <= internal_next_sm_free_flag;
        end if;
    end if;
end process;

update_output : process(actual_state, instruction_values_valid, instruction_type)
begin
    case (actual_state) is
        when reset =>
            internal_next_sel_output_rom <= '0';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '1';
            internal_next_sm_rotation_size <= "11";
            internal_next_sm_circular_shift_enable <= '0';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "00";
            internal_next_sm_specific_mac_address_a <= "00";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '0';
            internal_next_mac_enable_signed_b <= '0';
            internal_next_mac_sel_load_reg_a <= "11";
            internal_next_mac_clear_reg_b <= '1';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '0';
            internal_next_sm_mac_operation_mode <= "10";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '0';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
            internal_next_sm_free_flag <= '1';
        when decode_instruction =>
            internal_next_sel_output_rom <= '0';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '1';
            internal_next_sm_free_flag <= '1';
            internal_next_sm_rotation_size <= "11";
            internal_next_sm_circular_shift_enable <= '0';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "00";
            internal_next_sm_specific_mac_address_a <= "00";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '0';
            internal_next_mac_enable_signed_b <= '0';
            internal_next_mac_sel_load_reg_a <= "11";
            internal_next_mac_clear_reg_b <= '1';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '0';
            internal_next_sm_mac_operation_mode <= "10";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '0';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
            if(instruction_values_valid = '1') then
                internal_next_sm_free_flag <= '0';
                internal_next_sel_output_rom <= '1';
                internal_next_update_rom_address <= '1';
                internal_next_sel_load_new_rom_address <= '0';
                internal_next_sm_free_flag <= '0';
                internal_next_sm_circular_shift_enable <= '1';
                if(instruction_type = "0000") then
                    internal_next_sm_rotation_size <= "11";
                elsif(instruction_type = "0001") then
                    internal_next_sm_rotation_size <= "11";
                elsif(instruction_type = "0010") then
                    internal_next_sm_rotation_size <= "11";
                elsif(instruction_type = "0011") then
                    internal_next_sm_rotation_size <= "11";
                elsif(instruction_type = "0100") then
                    internal_next_sm_rotation_size <= "10";
                elsif(instruction_type = "0101") then
                    internal_next_sm_rotation_size <= "10";
                end if;
            end if;
        when instruction_execution =>
            internal_next_sel_output_rom <= '1';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '0';
            internal_next_sm_free_flag <= '0';
            internal_next_sm_rotation_size <= "11";
            internal_next_sm_circular_shift_enable <= '1';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "00";
            internal_next_sm_specific_mac_address_a <= "00";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '0';
            internal_next_mac_enable_signed_b <= '0';
            internal_next_mac_sel_load_reg_a <= "11";
            internal_next_mac_clear_reg_b <= '1';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '0';
            internal_next_sm_mac_operation_mode <= "10";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '0';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
    end case;
end process;

update_state : process(actual_state, instruction_type, operands_size, instruction_values_valid, penultimate_operation, rom_last_state)
begin
case (actual_state) is
        when reset =>
            next_state <= decode_instruction;
        when decode_instruction =>
            next_state <= decode_instruction;
            if(instruction_values_valid = '1') then
                next_state <= instruction_execution;
            end if;
        when instruction_execution =>
            next_state <= instruction_execution;
            if((penultimate_operation = '1') and (rom_last_state = '1')) then
                next_state <= decode_instruction;
            end if;
end case;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            ultimate_instruction <= '0';
        else
            ultimate_instruction <= penultimate_operation;
        end if;
    end if;
end process;

adder_a <= unsigned(rom_state_machine_address);
adder_b <= unsigned(rom_next_operation_same_operand_size) when (rom_current_operand_size = operands_size) else unsigned(rom_next_operation_different_operand_size);

adder_o <= adder_a + resize(adder_b, 9);

process(clk)
begin
    if (rising_edge(clk)) then
        if(internal_update_rom_address = '1') then
            if(internal_sel_load_new_rom_address = '1') then
                if(instruction_values_valid = '1') then
                    if(instruction_type = "0000") then
                        if(operands_size = "00") then
                            rom_state_machine_address <= first_state_multiplication_direct_operand_size_1;
                        else
                            rom_state_machine_address <= first_state_multiplication_direct_operand_size_2_3_4;
                        end if;
                    elsif(instruction_type = "0001") then
                        if(operands_size = "00") then
                            rom_state_machine_address <= first_state_square_direct_operand_size_1;
                        else
                            rom_state_machine_address <= first_state_square_direct_operand_size_2_3_4;
                        end if;
                    elsif(instruction_type = "0010") then
                        if(prime_line_equal_one = '1') then
                            if(operands_size = "00") then
                                rom_state_machine_address <= first_state_multiplication_with_reduction_special_prime_operand_size_1;
                            else
                                rom_state_machine_address <= first_state_multiplication_with_reduction_special_prime_operand_size_2_3_4;
                            end if;
                        else
                            if(operands_size = "00") then
                                rom_state_machine_address <= first_state_multiplication_with_reduction_operand_size_1;
                            else
                                rom_state_machine_address <= first_state_multiplication_with_reduction_operand_size_2_3_4;
                            end if;
                        end if;
                    elsif(instruction_type = "0011") then
                        if(prime_line_equal_one = '1') then
                            if(operands_size = "00") then
                                rom_state_machine_address <= first_state_square_with_reduction_special_prime_operand_size_1;
                            else
                                rom_state_machine_address <= first_state_square_with_reduction_special_prime_operand_size_2_3_4;
                            end if;
                        else
                            if(operands_size = "00") then
                                rom_state_machine_address <= first_state_square_with_reduction_operand_size_1;
                            else
                                rom_state_machine_address <= first_state_square_with_reduction_operand_size_2_3_4;
                            end if;
                        end if;
                    elsif(instruction_type = "0100") then
                        if(operands_size = "00") then
                            rom_state_machine_address <= first_state_addition_subtraction_direct_operand_size_1;
                        else
                            rom_state_machine_address <= first_state_addition_subtraction_direct_operand_size_2_3_4;
                        end if;
                    elsif(instruction_type = "0101") then
                        if(operands_size = "00") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_1;
                        elsif(operands_size = "01") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_2;
                        elsif(operands_size = "10") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_3;
                        else
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_4;
                        end if;
                    end if;
                end if;
            elsif(ultimate_instruction = '1') then
                rom_state_machine_address <= std_logic_vector(adder_o);
            end if;
        end if;
    end if;
end process;

rom_state_machine_output <= rom_state_machine(to_integer(to_01(unsigned(rom_state_machine_address))));

rom_sm_rotation_size <= rom_state_machine_output(1 downto 0);
rom_sel_address_a <= rom_state_machine_output(2);
rom_sel_address_b_prime <= rom_state_machine_output(4 downto 3);
rom_sm_specific_mac_address_a <= rom_state_machine_output(6 downto 5);
rom_sm_specific_mac_address_b <= rom_state_machine_output(8 downto 7);
rom_sm_specific_mac_address_o <= rom_state_machine_output(10 downto 9);
rom_sm_specific_mac_next_address_o <= rom_state_machine_output(12 downto 11);
rom_mac_enable_signed_a <= rom_state_machine_output(13);
rom_mac_enable_signed_b <= rom_state_machine_output(14);
rom_mac_sel_load_reg_a <= rom_state_machine_output(16 downto 15);
rom_mac_clear_reg_b <= rom_state_machine_output(17);
rom_mac_clear_reg_acc <= rom_state_machine_output(18);
rom_mac_sel_shift_reg_o <= rom_state_machine_output(19);
rom_mac_enable_update_reg_s <= rom_state_machine_output(20);
rom_mac_sel_reg_s_reg_o_sign <= rom_state_machine_output(21);
rom_mac_reg_s_reg_o_positive <= rom_state_machine_output(22);
rom_sm_sign_a_mode <= rom_state_machine_output(23);
rom_sm_mac_operation_mode <= rom_state_machine_output(25 downto 24);
rom_mac_enable_reg_s_mask <= rom_state_machine_output(26);
rom_mac_subtraction_reg_a_b <= rom_state_machine_output(27);
rom_mac_sel_multiply_two_a_b <= rom_state_machine_output(28);
rom_mac_sel_reg_y_output <= rom_state_machine_output(29);
rom_sm_mac_write_enable_output <= rom_state_machine_output(30);
rom_mac_memory_double_mode <= rom_state_machine_output(31);
rom_mac_memory_only_write_mode <= rom_state_machine_output(32);
rom_base_address_generator_o_increment_previous_address <= rom_state_machine_output(33);

rom_last_state <= rom_state_machine_output(34);
rom_current_operand_size <= rom_state_machine_output(36 downto 35);
rom_next_operation_same_operand_size <= rom_state_machine_output(41 downto 37);
rom_next_operation_different_operand_size <= rom_state_machine_output(46 downto 42);

sm_rotation_size <= rom_sm_rotation_size when internal_sel_output_rom = '1' else internal_sm_rotation_size;
sm_circular_shift_enable <= internal_sm_circular_shift_enable;
sel_address_a <= rom_sel_address_a when internal_sel_output_rom = '1' else internal_sel_address_a;
sel_address_b_prime <= rom_sel_address_b_prime when internal_sel_output_rom = '1' else internal_sel_address_b_prime;
sm_specific_mac_address_a <= rom_sm_specific_mac_address_a when internal_sel_output_rom = '1' else internal_sm_specific_mac_address_a;
sm_specific_mac_address_b <= rom_sm_specific_mac_address_b when internal_sel_output_rom = '1' else internal_sm_specific_mac_address_b;
sm_specific_mac_address_o <= rom_sm_specific_mac_address_o when internal_sel_output_rom = '1' else internal_sm_specific_mac_address_o;
sm_specific_mac_next_address_o <= rom_sm_specific_mac_next_address_o when internal_sel_output_rom = '1' else internal_sm_specific_mac_next_address_o;
mac_enable_signed_a <= rom_mac_enable_signed_a when internal_sel_output_rom = '1' else internal_mac_enable_signed_a;
mac_enable_signed_b <= rom_mac_enable_signed_b when internal_sel_output_rom = '1' else internal_mac_enable_signed_b;
mac_sel_load_reg_a <= rom_mac_sel_load_reg_a when internal_sel_output_rom = '1' else internal_mac_sel_load_reg_a;
mac_clear_reg_b <= rom_mac_clear_reg_b when internal_sel_output_rom = '1' else internal_mac_clear_reg_b;
mac_clear_reg_acc <= rom_mac_clear_reg_acc when internal_sel_output_rom = '1' else internal_mac_clear_reg_acc;
mac_sel_shift_reg_o <= rom_mac_sel_shift_reg_o when internal_sel_output_rom = '1' else internal_mac_sel_shift_reg_o;
mac_enable_update_reg_s <= rom_mac_enable_update_reg_s when internal_sel_output_rom = '1' else internal_mac_enable_update_reg_s;
mac_sel_reg_s_reg_o_sign <= rom_mac_sel_reg_s_reg_o_sign when internal_sel_output_rom = '1' else internal_mac_sel_reg_s_reg_o_sign;
mac_reg_s_reg_o_positive <= rom_mac_reg_s_reg_o_positive when internal_sel_output_rom = '1' else internal_mac_reg_s_reg_o_positive;
sm_sign_a_mode <= rom_sm_sign_a_mode when internal_sel_output_rom = '1' else internal_sm_sign_a_mode;
sm_mac_operation_mode <= rom_sm_mac_operation_mode when internal_sel_output_rom = '1' else internal_sm_mac_operation_mode;
mac_enable_reg_s_mask <= rom_mac_enable_reg_s_mask when internal_sel_output_rom = '1' else internal_mac_enable_reg_s_mask;
mac_subtraction_reg_a_b <= rom_mac_subtraction_reg_a_b when internal_sel_output_rom = '1' else internal_mac_subtraction_reg_a_b;
mac_sel_multiply_two_a_b <= rom_mac_sel_multiply_two_a_b when internal_sel_output_rom = '1' else internal_mac_sel_multiply_two_a_b;
mac_sel_reg_y_output <= rom_mac_sel_reg_y_output when internal_sel_output_rom = '1' else internal_mac_sel_reg_y_output;
sm_mac_write_enable_output <= rom_sm_mac_write_enable_output when internal_sel_output_rom = '1' else internal_sm_mac_write_enable_output;
mac_memory_double_mode <= rom_mac_memory_double_mode when internal_sel_output_rom = '1' else internal_mac_memory_double_mode;
mac_memory_only_write_mode <= rom_mac_memory_only_write_mode when internal_sel_output_rom = '1' else internal_mac_memory_only_write_mode;
base_address_generator_o_increment_previous_address <= rom_base_address_generator_o_increment_previous_address when internal_sel_output_rom = '1' else internal_base_address_generator_o_increment_previous_address;
sm_free_flag <= internal_sm_free_flag;

end compact_memory_based_v2;