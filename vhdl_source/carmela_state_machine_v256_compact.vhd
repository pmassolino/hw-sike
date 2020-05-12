----------------------------------------------------------------------------------
-- Implementation by Pedro Maat C. Massolino,
-- hereby denoted as "the implementer".
--
-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

architecture compact_memory_based_v2 of carmela_state_machine_v256 is

type romtype is array(integer range <>) of std_logic_vector(46 downto 0);

constant rom_state_machine_program : romtype(0 to 336) := (
--  (0) multiplication_direct_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; o1_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010000111000010000001000110100000000011",
--  (1) multiplication_direct_1
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (2) multiplication_direct_2
-- -- Other cases
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00101000010100001000010000001000000100000000011",
--  (3) multiplication_direct_3
-- -- In case of size 2
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o >> 256; Enable sign a; operation : a*b + acc;
"00001000010100000000010000010000011001000100011",
--  (4) multiplication_direct_4
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o; o1_0 = reg_o; Enable sign b; operation : a*b + acc;
"00001000010100001000010000000000101001010000011",
--  (5) multiplication_direct_5
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 256; o2_0 = reg_o; o3_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010100111000010000010000001110010100011",
--  (6) multiplication_direct_6
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (7) multiplication_direct_7
-- -- In case of size 3, 4
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000001001000100011",
--  (8) multiplication_direct_8
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000001001010000011",
--  (9) multiplication_direct_9
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00111000011000000000010000010000001110010100011",
--  (10) multiplication_direct_10
-- -- In case of size 3
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"00001000011000000000010000000000101110100000011",
--  (11) multiplication_direct_11
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000001000010000000000011110001000011",
--  (12) multiplication_direct_12
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o >> 256; Enable sign a; operation : a*b + acc;
"00001000011000000000010000010000010011011000011",
--  (13) multiplication_direct_13
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign b; operation : a*b + acc; Increment o3_0 base address
"00001000011001001000010000000000100011100100011",
--  (14) multiplication_direct_14
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 256; o4_0 = reg_o; o5_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011000111000010000010000110100101000011",
--  (15) multiplication_direct_15
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (16) multiplication_direct_16
-- -- In case of size 4
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000001110100000011",
--  (17) multiplication_direct_17
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001110001000011",
--  (18) multiplication_direct_18
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011100000000010000010000000011011000011",
--  (19) multiplication_direct_19
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000011100100011",
--  (20) multiplication_direct_20
-- reg_a = a3_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010011001100011",
--  (21) multiplication_direct_21
-- reg_a = a0_0; reg_b = b3_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign b; operation : a*b + acc; Increment o3_0 base address
"00001000011101001000010000000000100011110000011",
--  (22) multiplication_direct_22
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011100000000010000010000000100101000011",
--  (23) multiplication_direct_23
-- reg_a = a3_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100011100011",
--  (24) multiplication_direct_24
-- reg_a = a1_0; reg_b = b3_0; reg_acc = reg_o; o4_0 = reg_o; Enable sign b; operation : a*b + acc;
"00001000011100001000010000000000100100110100011",
--  (25) multiplication_direct_25
-- reg_a = a3_0; reg_b = b2_0; reg_acc = reg_o >> 256; Enable sign a; operation : a*b + acc;
"00001000011100000000010000010000011001101100011",
--  (26) multiplication_direct_26
-- reg_a = a2_0; reg_b = b3_0; reg_acc = reg_o; o5_0 = reg_o; Enable sign b; operation : a*b + acc;
"00001000011100001000010000000000101001111000011",
--  (27) multiplication_direct_27
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 256; o6_0 = reg_o; o7_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011100111000010000010000111110111100011",
--  (28) multiplication_direct_28
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (29) square_direct_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; o1_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010000111000010000001000110100000000011",
--  (30) square_direct_1
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (31) square_direct_2
-- -- In case of sizes 2, 3, 4
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00100000010100001000010000001000000100000000011",
--  (32) square_direct_3
-- -- In case of size 2
-- reg_a = a1_0; reg_b = a0_0; reg_acc = reg_o >> 256; o1_0 = reg_o; Enable sign a; operation : 2*a*b + acc;
"00001000010100001010010000010000011001000100011",
--  (33) square_direct_4
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 256; o2_0 = reg_o; o3_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010100111000010000010000111110010100011",
--  (34) square_direct_5
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (35) square_direct_6
-- -- In case of sizes 3, 4
-- reg_a = a1_0; reg_b = a0_0; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : 2*a*b + acc;
"00001000011000001010010000010000001001000100011",
--  (36) square_direct_7
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00101000011000000000010000010000001110010100011",
--  (37) square_direct_8
-- -- In case of size 3
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign b; operation : 2*a*b + acc;
"00001000011000001010010000000000101110100000011",
--  (38) square_direct_9
-- reg_a = a2_0; reg_b = a1_0; reg_acc = reg_o >> 256; o3_0 = reg_o; Enable sign a; operation : 2*a*b + acc; Increment o3_0 base address
"00001000011001001010010000010000010011011000011",
--  (39) square_direct_10
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 256; o4_0 = reg_o; o5_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011000111000010000010000110100101000011",
--  (40) square_direct_11
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (41) square_direct_12
-- -- In case of size 4
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; o2_0 = reg_o; operation : 2*a*b + acc;
"00001000011100001010010000000000001110100000011",
--  (42) square_direct_13
-- reg_a = a2_0; reg_b = a1_0; reg_acc = reg_o >> 256; operation : 2*a*b + acc;
"00001000011100000010010000010000000011011000011",
--  (43) square_direct_14
-- reg_a = a3_0; reg_b = a0_0; reg_acc = reg_o; o3_0 = reg_o; operation : 2*a*b + acc; Enable sign a; Increment o3_0 base address
"00001000011101001010010000000000010011001100011",
--  (44) square_direct_15
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011100000000010000010000000100101000011",
--  (45) square_direct_16
-- reg_a = a3_0; reg_b = a1_0; reg_acc = reg_o; o4_0 = reg_o; Enable sign a; operation : 2*a*b + acc;
"00001000011100001010010000000000010100011100011",
--  (46) square_direct_17
-- reg_a = a3_0; reg_b = a2_0; reg_acc = reg_o >> 256; o5_0 = reg_o; Enable sign a; operation : 2*a*b + acc;
"00001000011100001010010000010000011001101100011",
--  (47) square_direct_18
-- reg_a = a3_0; reg_b = a3_0; reg_acc = reg_o >> 256; o6_0 = reg_o; o7_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011100111000010000010000111110111100011",
--  (48) square_direct_19
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (49) multiplication_with_reduction_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
--  (50) multiplication_with_reduction_1
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010000001100011000000010000100000011011",
--  (51) multiplication_with_reduction_2
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010000000000010000000001000100000010011",
--  (52) multiplication_with_reduction_3
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 256; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
--  (53) multiplication_with_reduction_4
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (54) multiplication_with_reduction_5
-- -- In case of sizes 2, 3, 4
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; operation : a*b + acc;
"00001000010100000000010000001000000100000000011",
--  (55) multiplication_with_reduction_6
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010000100000011011",
--  (56) multiplication_with_reduction_7
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"01001000010100000000010000000001000100000010011",
--  (57) multiplication_with_reduction_8
-- -- In case of size 2
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000010100000000010000010000100100010000011",
--  (58) multiplication_with_reduction_9
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000000000100010010111",
--  (59) multiplication_with_reduction_10
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000010100000000010000000000010100000100011",
--  (60) multiplication_with_reduction_11
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010001001000011011",
--  (61) multiplication_with_reduction_12
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000001000100000010011",
--  (62) multiplication_with_reduction_13
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
--  (63) multiplication_with_reduction_14
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 256; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
--  (64) multiplication_with_reduction_15
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (65) multiplication_with_reduction_16
-- -- In case of sizes 3, 4
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000000100010000011",
--  (66) multiplication_with_reduction_17
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010010111",
--  (67) multiplication_with_reduction_18
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100000100011",
--  (68) multiplication_with_reduction_19
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001001000011011",
--  (69) multiplication_with_reduction_20
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000001000100000010011",
--  (70) multiplication_with_reduction_21
-- reg_a = o0_0; reg_b = prime2; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000000100100010111",
--  (71) multiplication_with_reduction_22
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
--  (72) multiplication_with_reduction_23
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"01100000011000000000010000000000000100010110111",
--  (73) multiplication_with_reduction_24
-- -- In case of size 3
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"00001000011000000000010000000000100100100000011",
--  (74) multiplication_with_reduction_25
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000000000010000000000010100001000011",
--  (75) multiplication_with_reduction_26
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001110000011011",
--  (76) multiplication_with_reduction_27
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000001000100000010011",
--  (77) multiplication_with_reduction_28
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011000000000010000010000100100100100011",
--  (78) multiplication_with_reduction_29
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
--  (79) multiplication_with_reduction_30
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000000000010000000000010100011000011",
--  (80) multiplication_with_reduction_31
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
--  (81) multiplication_with_reduction_32
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
--  (82) multiplication_with_reduction_33
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 256; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
--  (83) multiplication_with_reduction_34
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (84) multiplication_with_reduction_35
-- -- In case of size 4
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100000011",
--  (85) multiplication_with_reduction_36
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100001000011",
--  (86) multiplication_with_reduction_37
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010001110000011011",
--  (87) multiplication_with_reduction_38
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
--  (88) multiplication_with_reduction_39
-- reg_a = a0_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110000011",
--  (89) multiplication_with_reduction_40
-- reg_a = o0_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
--  (90) multiplication_with_reduction_41
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100100011",
--  (91) multiplication_with_reduction_42
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
--  (92) multiplication_with_reduction_43
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011000011",
--  (93) multiplication_with_reduction_44
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011010111",
--  (94) multiplication_with_reduction_45
-- reg_a = a3_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100001100011",
--  (95) multiplication_with_reduction_46
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o3_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010000011000011011",
--  (96) multiplication_with_reduction_47
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
--  (97) multiplication_with_reduction_48
-- reg_a = a1_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110100011",
--  (98) multiplication_with_reduction_49
-- reg_a = o1_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
--  (99) multiplication_with_reduction_50
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
--  (100) multiplication_with_reduction_51
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
--  (101) multiplication_with_reduction_52
-- reg_a = a3_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100011100011",
--  (102) multiplication_with_reduction_53
-- reg_a = o3_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
--  (103) multiplication_with_reduction_54
-- reg_a = a2_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100111000011",
--  (104) multiplication_with_reduction_55
-- reg_a = o2_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
--  (105) multiplication_with_reduction_56
-- reg_a = a3_0; reg_b = b2_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100101100011",
--  (106) multiplication_with_reduction_57
-- reg_a = o3_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
--  (107) multiplication_with_reduction_58
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
--  (108) multiplication_with_reduction_59
-- reg_a = o3_0; reg_b = prime3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 256; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
--  (109) multiplication_with_reduction_60
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (110) multiplication_with_reduction_special_prime_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000000100000000011",
--  (111) multiplication_with_reduction_special_prime_1
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 256; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
--  (112) multiplication_with_reduction_special_prime_2
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (113) multiplication_with_reduction_special_prime_3
-- -- In case of sizes 2, 3, 4
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00111000010100001000010000001000000100000000011",
--  (114) multiplication_with_reduction_special_prime_4
-- -- In case of size 2
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000010100000000010000010000100100010000011",
--  (115) multiplication_with_reduction_special_prime_5
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000000000100010010111",
--  (116) multiplication_with_reduction_special_prime_6
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; o1_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000010100001000010000000000011001000100011",
--  (117) multiplication_with_reduction_special_prime_7
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
--  (118) multiplication_with_reduction_special_prime_8
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 256; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
--  (119) multiplication_with_reduction_special_prime_9
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (120) multiplication_with_reduction_special_prime_10
-- -- In case of sizes 3, 4
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000000100010000011",
--  (121) multiplication_with_reduction_special_prime_11
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010010111",
--  (122) multiplication_with_reduction_special_prime_12
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000001001000100011",
--  (123) multiplication_with_reduction_special_prime_13
-- reg_a = o0_X; reg_b = primeSP2; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000000100100010111",
--  (124) multiplication_with_reduction_special_prime_14
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
--  (125) multiplication_with_reduction_special_prime_15
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"01010000011000000000010000000000000100010110111",
--  (126) multiplication_with_reduction_special_prime_16
-- -- In case of size 3
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"00001000011000000000010000000000100100100000011",
--  (127) multiplication_with_reduction_special_prime_17
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000001000010000000000011110001000011",
--  (128) multiplication_with_reduction_special_prime_18
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011000000000010000010000100100100100011",
--  (129) multiplication_with_reduction_special_prime_19
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
--  (130) multiplication_with_reduction_special_prime_20
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000000000010000000000010100011000011",
--  (131) multiplication_with_reduction_special_prime_21
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
--  (132) multiplication_with_reduction_special_prime_22
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
--  (133) multiplication_with_reduction_special_prime_23
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 256; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
--  (134) multiplication_with_reduction_special_prime_24
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (135) multiplication_with_reduction_special_prime_25
-- -- In case of size 4
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100000011",
--  (136) multiplication_with_reduction_special_prime_26
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001110001000011",
--  (137) multiplication_with_reduction_special_prime_27
-- reg_a = o0_0; reg_b = primeSP3; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011100000000010000010000000100110010111",
--  (138) multiplication_with_reduction_special_prime_28
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100100011",
--  (139) multiplication_with_reduction_special_prime_29
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
--  (140) multiplication_with_reduction_special_prime_30
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011000011",
--  (141) multiplication_with_reduction_special_prime_31
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011010111",
--  (142) multiplication_with_reduction_special_prime_32
-- reg_a = a0_0; reg_b = b3_0; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"00001000011100000000010000000000100100110000011",
--  (143) multiplication_with_reduction_special_prime_33
-- reg_a = a3_0; reg_b = b0_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100001000010000000000010011001100011",
--  (144) multiplication_with_reduction_special_prime_34
-- reg_a = a1_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110100011",
--  (145) multiplication_with_reduction_special_prime_35
-- reg_a = o1_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
--  (146) multiplication_with_reduction_special_prime_36
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
--  (147) multiplication_with_reduction_special_prime_37
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
--  (148) multiplication_with_reduction_special_prime_38
-- reg_a = a3_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100011100011",
--  (149) multiplication_with_reduction_special_prime_39
-- reg_a = o3_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
--  (150) multiplication_with_reduction_special_prime_40
-- reg_a = a2_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100111000011",
--  (151) multiplication_with_reduction_special_prime_41
-- reg_a = o2_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
--  (152) multiplication_with_reduction_special_prime_42
-- reg_a = a3_0; reg_b = b2_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100101100011",
--  (153) multiplication_with_reduction_special_prime_43
-- reg_a = o3_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
--  (154) multiplication_with_reduction_special_prime_44
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
--  (155) multiplication_with_reduction_special_prime_45
-- reg_a = o3_0; reg_b = primeSP3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 256; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
--  (156) multiplication_with_reduction_special_prime_46
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (157) square_with_reduction_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
--  (158) square_with_reduction_1
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010000001100011000000010000100000011011",
--  (159) square_with_reduction_2
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010000000000010000000001000100000010011",
--  (160) square_with_reduction_3
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 256; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
--  (161) square_with_reduction_4
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (162) square_with_reduction_5
-- -- In case of 2, 3, 4
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; operation : a*b + acc;
"00001000010100000000010000001000000100000000011",
--  (163) square_with_reduction_6
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010000100000011011",
--  (164) square_with_reduction_7
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"01000000010100000000010000000001000100000010011",
--  (165) square_with_reduction_8
-- -- In case of size 2
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000010100000010010000010000100100010000011",
--  (166) square_with_reduction_9
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000000000100010010111",
--  (167) square_with_reduction_10
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010001001000111011",
--  (168) square_with_reduction_11
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000001000100000110011",
--  (169) square_with_reduction_12
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
--  (170) square_with_reduction_13
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 256; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
--  (171) square_with_reduction_14
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (172) square_with_reduction_15
-- -- In case of size 3, 4
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 256; operation : 2*a*b + acc;
"00001000011000000010010000010000000100010000011",
--  (173) square_with_reduction_16
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010010111",
--  (174) square_with_reduction_17
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001001000111011",
--  (175) square_with_reduction_18
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000001000100000110011",
--  (176) square_with_reduction_19
-- reg_a = o0_0; reg_b = prime2; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000000100100010111",
--  (177) square_with_reduction_20
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
--  (178) square_with_reduction_21
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"01010000011000000000010000000000000100010110111",
--  (179) square_with_reduction_22
-- -- In case of size 3
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000000000100100100000011",
--  (180) square_with_reduction_23
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001110000011011",
--  (181) square_with_reduction_24
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000001000100000010011",
--  (182) square_with_reduction_25
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000010000100100100100011",
--  (183) square_with_reduction_26
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
--  (184) square_with_reduction_27
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
--  (185) square_with_reduction_28
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
--  (186) square_with_reduction_29
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 256; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
--  (187) square_with_reduction_30
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (188) square_with_reduction_31
-- -- In case of size 4
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; operation : 2*a*b + acc;
"00001000011100000010010000000000000100100000011",
--  (189) square_with_reduction_32
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010001110000011011",
--  (190) square_with_reduction_33
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
--  (191) square_with_reduction_34
-- reg_a = a0_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110000011",
--  (192) square_with_reduction_35
-- reg_a = o0_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
--  (193) square_with_reduction_36
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o; operation : 2*a*b + acc;
"00001000011100000010010000000000000100100100011",
--  (194) square_with_reduction_37
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
--  (195) square_with_reduction_38
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011010111",
--  (196) square_with_reduction_39
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o3_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010000011000011011",
--  (197) square_with_reduction_40
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
--  (198) square_with_reduction_41
-- reg_a = a1_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110100011",
--  (199) square_with_reduction_42
-- reg_a = o1_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
--  (200) square_with_reduction_43
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
--  (201) square_with_reduction_44
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
--  (202) square_with_reduction_45
-- reg_a = o3_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
--  (203) square_with_reduction_46
-- reg_a = a2_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100111000011",
--  (204) square_with_reduction_47
-- reg_a = o2_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
--  (205) square_with_reduction_48
-- reg_a = o3_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
--  (206) square_with_reduction_49
-- reg_a = a3_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
--  (207) square_with_reduction_50
-- reg_a = o3_0; reg_b = prime3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 256; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
--  (208) square_with_reduction_51
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (209) square_with_reduction_special_prime_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
--  (210) square_with_reduction_special_prime_1
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 256; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
--  (211) square_with_reduction_special_prime_2
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (212) square_with_reduction_special_prime_3
-- -- In case of size 2, 3, 4
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00110000010100001000010000001000000100000000011",
--  (213) square_with_reduction_special_prime_4
-- -- In case of size 2
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000010100000010010000010000100100010000011",
--  (214) square_with_reduction_special_prime_5
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000010100001000010000000000001001010010111",
--  (215) square_with_reduction_special_prime_6
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
--  (216) square_with_reduction_special_prime_7
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 256; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
--  (217) square_with_reduction_special_prime_8
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (218) square_with_reduction_special_prime_9
-- -- In case of size 3, 4
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 256; operation : 2*a*b + acc;
"00001000011000000010010000010000000100010000011",
--  (219) square_with_reduction_special_prime_10
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000001001010010111",
--  (220) square_with_reduction_special_prime_11
-- reg_a = o0_0; reg_b = primeSP2; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000000100100010111",
--  (221) square_with_reduction_special_prime_12
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
--  (222) square_with_reduction_special_prime_13
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"01000000011000000000010000000000000100010110111",
--  (223) square_with_reduction_special_prime_14
-- -- In case of size 3
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign b; operation : 2*a*b + acc;
"00001000011000001010010000000000101110100000011",
--  (224) square_with_reduction_special_prime_15
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000010000100100100100011",
--  (225) square_with_reduction_special_prime_16
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
--  (226) square_with_reduction_special_prime_17
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
--  (227) square_with_reduction_special_prime_18
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
--  (228) square_with_reduction_special_prime_19
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 256; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
--  (229) square_with_reduction_special_prime_20
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (230) square_with_reduction_special_prime_21
-- -- In case of size 4
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; o2_0 = reg_o; operation : 2*a*b + acc;
"00001000011100001010010000000000001110100000011",
--  (231) square_with_reduction_special_prime_22
-- reg_a = a0_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110000011",
--  (232) square_with_reduction_special_prime_23
-- reg_a = o0_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
--  (233) square_with_reduction_special_prime_24
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o; operation : 2*a*b + acc;
"00001000011100000010010000000000000100100100011",
--  (234) square_with_reduction_special_prime_25
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
--  (235) square_with_reduction_special_prime_26
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; o3_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000011011010111",
--  (236) square_with_reduction_special_prime_27
-- reg_a = a1_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110100011",
--  (237) square_with_reduction_special_prime_28
-- reg_a = o1_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
--  (238) square_with_reduction_special_prime_29
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
--  (239) square_with_reduction_special_prime_30
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
--  (240) square_with_reduction_special_prime_31
-- reg_a = o3_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
--  (241) square_with_reduction_special_prime_32
-- reg_a = a2_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100111000011",
--  (242) square_with_reduction_special_prime_33
-- reg_a = o2_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
--  (243) square_with_reduction_special_prime_34
-- reg_a = o3_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
--  (244) square_with_reduction_special_prime_35
-- reg_a = a3_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
--  (245) square_with_reduction_special_prime_36
-- reg_a = o3_0; reg_b = primeSP3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 256; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
--  (246) square_with_reduction_special_prime_37
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (247) addition_subtraction_direct_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000010000001000000100001000110100000000010",
--  (248) addition_subtraction_direct_1
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (249) addition_subtraction_direct_2
-- -- In case of size 2, 3, 4
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : b +/- a + acc;
"00011000010100001000000100001000000100000000010",
--  (250) addition_subtraction_direct_3
-- -- In case of size 2
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 256; o1_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000010100001000000100010000111001010100010",
--  (251) addition_subtraction_direct_4
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (252) addition_subtraction_direct_5
-- -- In case of size 3, 4
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : b +/- a + acc;
"00011000011000001000000100010000001001010100010",
--  (253) addition_subtraction_direct_6
-- -- In case of size 3
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 256; o2_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000011000001000000100010000110110101000010",
--  (254) addition_subtraction_direct_7
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (255) addition_subtraction_direct_8
-- -- In case of size 4
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 256; o2_0 = reg_o; operation : b +/- a + acc;
"00001000011100001000000100010000000110101000010",
--  (256) addition_subtraction_direct_9
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 256; o3_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000011100001000000100010000110011111100010",
--  (257) addition_subtraction_direct_10
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (258) iterative_modular_reduction_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"00001000010000000000001000001100110100000010010",
--  (259) iterative_modular_reduction_1
-- reg_a = 0; reg_b = prime_0; reg_acc = reg_o; reg_s = reg_o_positive; Enable sign a,b; operation : -s*b + a + acc;
"00001000010000000001100011100011110100000010010",
--  (260) iterative_modular_reduction_2
-- reg_a = 0; reg_b = prime_0; reg_acc = reg_o; reg_s = reg_o_negative; Enable sign a,b; operation : s*b + a + acc;
"00001000010000000000101001100011110100000010010",
--  (261) iterative_modular_reduction_3
-- reg_a = 0; reg_b = prime_0; reg_acc = reg_o; o0_0 = reg_o; reg_s = reg_o_negative; Enable sign a,b; operation : s*b + a + acc;
"00001000010000001000101001100011110100000010010",
--  (262) iterative_modular_reduction_4
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (263) iterative_modular_reduction_5
-- -- In case of size 2
-- reg_a = a1_0; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"00001000010100000000001000001100110100000110010",
--  (264) iterative_modular_reduction_6
-- reg_a = a0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"00001000010100001001100011101000000100000010010",
--  (265) iterative_modular_reduction_7
-- reg_a = a1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; Enable sign a,b; operation : -s*b + a + acc
"00001000010100001001100000010000111001010110010",
--  (266) iterative_modular_reduction_8
-- reg_a = o0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"00001000010100001000101001101000000100000010110",
--  (267) iterative_modular_reduction_9
-- reg_a = o1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; Enable sign a,b operation : s*b + a + acc
"00001000010100001000101000010000111001010110110",
--  (268) iterative_modular_reduction_10
-- reg_a = o0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"00001000010100001000101001101000000100000010110",
--  (269) iterative_modular_reduction_11
-- reg_a = o1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; Enable sign a,b operation : s*b + a + acc
"00001000010100001000101000010000111001010110110",
--  (270) iterative_modular_reduction_12
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (271) iterative_modular_reduction_13
-- -- In case of size 3
-- reg_a = a2_0; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"00001000011000000000001000001100111110101010010",
--  (272) iterative_modular_reduction_14
-- reg_a = a0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"00001000011000001001100011101000000100000010010",
--  (273) iterative_modular_reduction_15
-- reg_a = a1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : -s*b + a + acc
"00001000011000001001100000010000001001010110010",
--  (274) iterative_modular_reduction_16
-- reg_a = a2_0; reg_b = prime_2; reg_acc = reg_o >> 256; o2_0 = reg_o; Enable sign a,b; operation : -s*b + a + acc
"00001000011000001001100000010000111110101010010",
--  (275) iterative_modular_reduction_17
-- reg_a = o0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"00001000011000001000101001101000000100000010110",
--  (276) iterative_modular_reduction_18
-- reg_a = o1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : s*b + a + acc
"00001000011000001000101000010000001001010110110",
--  (277) iterative_modular_reduction_19
-- reg_a = o2_0; reg_b = prime_2; reg_acc = reg_o >> 256; o2_0 = reg_o; Enable sign a,b operation : s*b + a + acc
"00001000011000001000101000010000111110101010110",
--  (278) iterative_modular_reduction_20
-- reg_a = o0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"00001000011000001000101001101000000100000010110",
--  (279) iterative_modular_reduction_21
-- reg_a = o1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : s*b + a + acc
"00001000011000001000101000010000001001010110110",
--  (280) iterative_modular_reduction_22
-- reg_a = o2_0; reg_b = prime_2; reg_acc = reg_o >> 256; o2_0 = reg_o; Enable sign a,b operation : s*b + a + acc
"00001000011000001000101000010000111110101010110",
--  (281) iterative_modular_reduction_23
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (282) iterative_modular_reduction_24
-- -- In case of size 4
-- reg_a = a3_0; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"00001000011100000000001000001100110011111110010",
--  (283) iterative_modular_reduction_25
-- reg_a = a0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"00001000011100001001100011101000000100000010010",
--  (284) iterative_modular_reduction_26
-- reg_a = a1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : -s*b + a + acc
"00001000011100001001100000010000001001010110010",
--  (285) iterative_modular_reduction_27
-- reg_a = a2_0; reg_b = prime_2; reg_acc = reg_o >> 256; o2_0 = reg_o; operation : -s*b + a + acc
"00001000011100001001100000010000001110101010010",
--  (286) iterative_modular_reduction_28
-- reg_a = a3_0; reg_b = prime_3; reg_acc = reg_o >> 256; o3_0 = reg_o; Enable sign a,b; operation : -s*b + a + acc
"00001000011100001001100000010000110011111110010",
--  (287) iterative_modular_reduction_29
-- reg_a = o0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"00001000011100001000101001101000000100000010110",
--  (288) iterative_modular_reduction_30
-- reg_a = o1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : s*b + a + acc
"00001000011100001000101000010000001001010110110",
--  (289) iterative_modular_reduction_31
-- reg_a = o2_0; reg_b = prime_2; reg_acc = reg_o >> 256; o2_0 = reg_o; operation : s*b + a + acc
"00001000011100001000101000010000001110101010110",
--  (290) iterative_modular_reduction_32
-- reg_a = o3_0; reg_b = prime_3; reg_acc = reg_o >> 256; o3_0 = reg_o; Enable sign a,b; operation : s*b + a + acc
"00001000011100001000101000010000110011111110110",
--  (291) iterative_modular_reduction_33
-- reg_a = o0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"00001000011100001000101001101000000100000010110",
--  (292) iterative_modular_reduction_34
-- reg_a = o1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : s*b + a + acc
"00001000011100001000101000010000001001010110110",
--  (293) iterative_modular_reduction_35
-- reg_a = o2_0; reg_b = prime_2; reg_acc = reg_o >> 256; o2_0 = reg_o; operation : s*b + a + acc
"00001000011100001000101000010000001110101010110",
--  (294) iterative_modular_reduction_36
-- reg_a = o3_0; reg_b = prime_3; reg_acc = reg_o >> 256; o3_0 = reg_o; Enable sign a,b; operation : s*b + a + acc
"00001000011100001000101000010000110011111110110",
--  (295) iterative_modular_reduction_37
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (296) addition_subtraction_with_reduction_0
-- Operands size 1
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_X = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000010000001000001100001000110100000000010",
--  (297) addition_subtraction_with_reduction_1
-- reg_a = 0; reg_b = 2prime0; reg_acc = reg_o; reg_s = reg_o_positive; o0_X = reg_o; Enable sign a,b; operation : -s*b + a + acc;
"00001000010000001001100011100011110100000001010",
--  (298) addition_subtraction_with_reduction_2
-- reg_a = 0; reg_b = 2prime0; reg_acc = reg_o; reg_s = reg_o_negative; o0_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000010000001000101001100011110100000001010",
--  (299) addition_subtraction_with_reduction_3
-- reg_a = 0; reg_b = 2prime0; reg_acc = reg_o; reg_s = reg_o_negative; o0_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000010000001000101001100011110100000001010",
--  (300) addition_subtraction_with_reduction_4
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (301) addition_subtraction_with_reduction_5
-- -- In case of sizes 2, 3, 4
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_X = reg_o; operation : b +/- a + acc;
"01001000010100001000000100001000000100000000010",
--  (302) addition_subtraction_with_reduction_6
-- -- In case of size 2
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o >> 256; o1_X = reg_o; Enable sign a, b; operation : b +/- a + acc;
"00001000010100001000000100010000111001010100010",
--  (303) addition_subtraction_with_reduction_7
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc;
"00001000010100001001100011101000000100000001110",
--  (304) addition_subtraction_with_reduction_8
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; Enable sign a,b; operation : -s*b + a + acc;
"00001000010100001001100000010000111001010101110",
--  (305) addition_subtraction_with_reduction_9
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc;
"00001000010100001000101001101000000100000001110",
--  (306) addition_subtraction_with_reduction_10
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000010100001000101000010000111001010101110",
--  (307) addition_subtraction_with_reduction_11
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc;
"00001000010100001000101001101000000100000001110",
--  (308) addition_subtraction_with_reduction_12
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000010100001000101000010000111001010101110",
--  (309) addition_subtraction_with_reduction_13
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (310) addition_subtraction_with_reduction_14
-- -- In case of sizes 3, 4
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o >> 256; o1_X = reg_o; operation : b +/- a + acc;
"01100000011000001000000100010000001001010100010",
--  (311) addition_subtraction_with_reduction_15
-- -- In case of size 3
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o >> 256; o2_X = reg_o; Enable sign a, b; operation : b +/- a + acc;
"00001000011000001000000100010000110110101000010",
--  (312) addition_subtraction_with_reduction_16
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc;
"00001000011000001001100011101000000100000001110",
--  (313) addition_subtraction_with_reduction_17
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; operation : -s*b + a + acc;
"00001000011000001001100000010000001001010101110",
--  (314) addition_subtraction_with_reduction_18
-- reg_a = o2_X; reg_b = 2prime2; reg_acc = reg_o >> 256; o2_X = reg_o; Enable sign a,b; operation : -s*b + a + acc;
"00001000011000001001100000010000111110101001110",
--  (315) addition_subtraction_with_reduction_19
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc;
"00001000011000001000101001101000000100000001110",
--  (316) addition_subtraction_with_reduction_20
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; operation : s*b + a + acc;
"00001000011000001000101000010000001001010101110",
--  (317) addition_subtraction_with_reduction_21
-- reg_a = o2_X; reg_b = 2prime2; reg_acc = reg_o >> 256; o2_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000011000001000101000010000111110101001110",
--  (318) addition_subtraction_with_reduction_22
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc;
"00001000011000001000101001101000000100000001110",
--  (319) addition_subtraction_with_reduction_23
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; operation : s*b + a + acc;
"00001000011000001000101000010000001001010101110",
--  (320) addition_subtraction_with_reduction_24
-- reg_a = o2_X; reg_b = 2prime2; reg_acc = reg_o >> 256; o2_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000011000001000101000010000111110101001110",
--  (321) addition_subtraction_with_reduction_25
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (322) addition_subtraction_with_reduction_26
-- -- In case of size 4
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o >> 256; o2_X = reg_o; operation : b +/- a + acc;
"00001000011100001000000100010000000110101000010",
--  (323) addition_subtraction_with_reduction_27
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o >> 256; o3_X = reg_o; Enable sign a, b; operation : b +/- a + acc;
"00001000011100001000000100010000110011111100010",
--  (324) addition_subtraction_with_reduction_28
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc;
"00001000011100001001100011101000000100000001110",
--  (325) addition_subtraction_with_reduction_29
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; operation : -s*b + a + acc;
"00001000011100001001100000010000001001010101110",
--  (326) addition_subtraction_with_reduction_30
-- reg_a = o2_X; reg_b = 2prime2; reg_acc = reg_o >> 256; o2_X = reg_o; operation : -s*b + a + acc;
"00001000011100001001100000010000001110101001110",
--  (327) addition_subtraction_with_reduction_31
-- reg_a = o3_X; reg_b = 2prime3; reg_acc = reg_o >> 256; o3_X = reg_o; Enable sign a,b; operation : -s*b + a + acc;
"00001000011100001001100000010000110011111101110",
--  (328) addition_subtraction_with_reduction_32
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc;
"00001000011100001000101001101000000100000001110",
--  (329) addition_subtraction_with_reduction_33
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; operation : s*b + a + acc;
"00001000011100001000101000010000001001010101110",
--  (330) addition_subtraction_with_reduction_34
-- reg_a = o2_X; reg_b = 2prime2; reg_acc = reg_o >> 256; o2_X = reg_o; operation : s*b + a + acc;
"00001000011100001000101000010000001110101001110",
--  (331) addition_subtraction_with_reduction_35
-- reg_a = o3_X; reg_b = 2prime3; reg_acc = reg_o >> 256; o3_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000011100001000101000010000110011111101110",
--  (332) addition_subtraction_with_reduction_36
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc;
"00001000011100001000101001101000000100000001110",
--  (333) addition_subtraction_with_reduction_37
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; operation : s*b + a + acc;
"00001000011100001000101000010000001001010101110",
--  (334) addition_subtraction_with_reduction_38
-- reg_a = o2_X; reg_b = 2prime2; reg_acc = reg_o >> 256; o2_X = reg_o; operation : s*b + a + acc;
"00001000011100001000101000010000001110101001110",
--  (335) addition_subtraction_with_reduction_39
-- reg_a = o3_X; reg_b = 2prime3; reg_acc = reg_o >> 256; o3_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000011100001000101000010000110011111101110",
--  (336) addition_subtraction_with_reduction_40
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010"
);



constant rom_state_machine_fill_nop : romtype(337 to 511) := (others => "00000000000010000000010000001111000100000000011");
constant rom_state_machine : romtype(0 to 511) := rom_state_machine_program & rom_state_machine_fill_nop;

signal rom_state_machine_address : std_logic_vector(8 downto 0);
signal rom_state_machine_next_address : std_logic_vector(8 downto 0);
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
constant first_state_multiplication_direct_operand_size_1 : std_logic_vector(8 downto 0)                           := std_logic_vector(to_unsigned(0,9));
constant first_state_multiplication_direct_operand_size_2_3_4 : std_logic_vector(8 downto 0)                       := std_logic_vector(to_unsigned(2,9));
-- 0001 square with no reduction                                                                                   
constant first_state_square_direct_operand_size_1 : std_logic_vector(8 downto 0)                                   := std_logic_vector(to_unsigned(29,9));
constant first_state_square_direct_operand_size_2_3_4 : std_logic_vector(8 downto 0)                               := std_logic_vector(to_unsigned(31,9));
-- 0010 multiplication with reduction and prime line not equal to 1                                                
constant first_state_multiplication_with_reduction_operand_size_1 : std_logic_vector(8 downto 0)                   := std_logic_vector(to_unsigned(49,9));
constant first_state_multiplication_with_reduction_operand_size_2_3_4 : std_logic_vector(8 downto 0)               := std_logic_vector(to_unsigned(54,9));
-- 0010 multiplication with reduction and prime line equal to 1                                                    
constant first_state_multiplication_with_reduction_special_prime_operand_size_1 : std_logic_vector(8 downto 0)     := std_logic_vector(to_unsigned(110,9));
constant first_state_multiplication_with_reduction_special_prime_operand_size_2_3_4 : std_logic_vector(8 downto 0) := std_logic_vector(to_unsigned(113,9));
-- 0011 square with reduction and prime line not equal to 1
constant first_state_square_with_reduction_operand_size_1 : std_logic_vector(8 downto 0)                           := std_logic_vector(to_unsigned(157,9));
constant first_state_square_with_reduction_operand_size_2_3_4 : std_logic_vector(8 downto 0)                       := std_logic_vector(to_unsigned(162,9));
-- 0011 square with reduction and prime line equal to 1                                                            
constant first_state_square_with_reduction_special_prime_operand_size_1 : std_logic_vector(8 downto 0)             := std_logic_vector(to_unsigned(209,9));
constant first_state_square_with_reduction_special_prime_operand_size_2_3_4 : std_logic_vector(8 downto 0)         := std_logic_vector(to_unsigned(212,9));
-- 0100 addition with no reduction                                                                                 
constant first_state_addition_subtraction_direct_operand_size_1 : std_logic_vector(8 downto 0)                     := std_logic_vector(to_unsigned(247,9));
constant first_state_addition_subtraction_direct_operand_size_2_3_4 : std_logic_vector(8 downto 0)                 := std_logic_vector(to_unsigned(249,9));
-- 0101 iterative modular reduction                                                                                
constant first_state_iterative_modular_reduction_operand_size_1 : std_logic_vector(8 downto 0)                     := std_logic_vector(to_unsigned(258,9));
constant first_state_iterative_modular_reduction_operand_size_2 : std_logic_vector(8 downto 0)                     := std_logic_vector(to_unsigned(263,9));
constant first_state_iterative_modular_reduction_operand_size_3 : std_logic_vector(8 downto 0)                     := std_logic_vector(to_unsigned(271,9));
constant first_state_iterative_modular_reduction_operand_size_4 : std_logic_vector(8 downto 0)                     := std_logic_vector(to_unsigned(282,9));
-- 0110 addition with no reduction                                                                                 
constant first_state_addition_subtraction_with_reduction_operand_size_1 : std_logic_vector(8 downto 0)             := std_logic_vector(to_unsigned(296,9));
constant first_state_addition_subtraction_with_reduction_operand_size_2_3_4 : std_logic_vector(8 downto 0)         := std_logic_vector(to_unsigned(301,9));

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
                elsif(instruction_type = "0110") then
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
        rom_state_machine_address <= rom_state_machine_next_address;
    end if;
end process;

process(rom_state_machine_address, internal_update_rom_address, internal_sel_load_new_rom_address, instruction_values_valid, instruction_type, operands_size, prime_line_equal_one, ultimate_instruction, adder_o)
begin
    if(internal_update_rom_address = '0') then
        rom_state_machine_next_address <= rom_state_machine_address;
    else
        if(internal_sel_load_new_rom_address = '1') then
            if(instruction_values_valid = '1') then
                if(instruction_type = "0000") then
                    if(operands_size = "00") then
                        rom_state_machine_next_address <= first_state_multiplication_direct_operand_size_1;
                    else
                        rom_state_machine_next_address <= first_state_multiplication_direct_operand_size_2_3_4;
                    end if;
                elsif(instruction_type = "0001") then
                    if(operands_size = "00") then
                        rom_state_machine_next_address <= first_state_square_direct_operand_size_1;
                    else
                        rom_state_machine_next_address <= first_state_square_direct_operand_size_2_3_4;
                    end if;
                elsif(instruction_type = "0010") then
                    if(prime_line_equal_one = '1') then
                        if(operands_size = "00") then
                            rom_state_machine_next_address <= first_state_multiplication_with_reduction_special_prime_operand_size_1;
                        else
                            rom_state_machine_next_address <= first_state_multiplication_with_reduction_special_prime_operand_size_2_3_4;
                        end if;
                    else
                        if(operands_size = "00") then
                            rom_state_machine_next_address <= first_state_multiplication_with_reduction_operand_size_1;
                        else
                            rom_state_machine_next_address <= first_state_multiplication_with_reduction_operand_size_2_3_4;
                        end if;
                    end if;
                elsif(instruction_type = "0011") then
                    if(prime_line_equal_one = '1') then
                        if(operands_size = "00") then
                            rom_state_machine_next_address <= first_state_square_with_reduction_special_prime_operand_size_1;
                        else
                            rom_state_machine_next_address <= first_state_square_with_reduction_special_prime_operand_size_2_3_4;
                        end if;
                    else
                        if(operands_size = "00") then
                            rom_state_machine_next_address <= first_state_square_with_reduction_operand_size_1;
                        else
                            rom_state_machine_next_address <= first_state_square_with_reduction_operand_size_2_3_4;
                        end if;
                    end if;
                elsif(instruction_type = "0100") then
                    if(operands_size = "00") then
                        rom_state_machine_next_address <= first_state_addition_subtraction_direct_operand_size_1;
                    else
                        rom_state_machine_next_address <= first_state_addition_subtraction_direct_operand_size_2_3_4;
                    end if;
                elsif(instruction_type = "0101") then
                    if(operands_size = "00") then
                        rom_state_machine_next_address <= first_state_iterative_modular_reduction_operand_size_1;
                    elsif(operands_size = "01") then
                        rom_state_machine_next_address <= first_state_iterative_modular_reduction_operand_size_2;
                    elsif(operands_size = "10") then
                        rom_state_machine_next_address <= first_state_iterative_modular_reduction_operand_size_3;
                    else
                        rom_state_machine_next_address <= first_state_iterative_modular_reduction_operand_size_4;
                    end if;
                elsif(instruction_type = "0110") then
                    if(operands_size = "00") then
                        rom_state_machine_next_address <= first_state_addition_subtraction_with_reduction_operand_size_1;
                    else
                        rom_state_machine_next_address <= first_state_addition_subtraction_with_reduction_operand_size_2_3_4;
                    end if;
                else
                    rom_state_machine_next_address <= rom_state_machine_address;
                end if;
            else
                rom_state_machine_next_address <= rom_state_machine_address;
            end if;
        elsif(ultimate_instruction = '1') then
            rom_state_machine_next_address <= std_logic_vector(adder_o);
        else
            rom_state_machine_next_address <= rom_state_machine_address;
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









































architecture compact_memory_based_v3 of carmela_state_machine_v256 is

type romtype is array(integer range <>) of std_logic_vector(46 downto 0);

constant rom_state_machine_program : romtype(0 to 336) := (
--  (0) multiplication_direct_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; o1_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010000111000010000001000110100000000011",
--  (1) multiplication_direct_1
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (2) multiplication_direct_2
-- -- Other cases
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00101000010100001000010000001000000100000000011",
--  (3) multiplication_direct_3
-- -- In case of size 2
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o >> 256; Enable sign a; operation : a*b + acc;
"00001000010100000000010000010000011001000100011",
--  (4) multiplication_direct_4
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o; o1_0 = reg_o; Enable sign b; operation : a*b + acc;
"00001000010100001000010000000000101001010000011",
--  (5) multiplication_direct_5
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 256; o2_0 = reg_o; o3_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010100111000010000010000001110010100011",
--  (6) multiplication_direct_6
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (7) multiplication_direct_7
-- -- In case of size 3, 4
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000001001000100011",
--  (8) multiplication_direct_8
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000001001010000011",
--  (9) multiplication_direct_9
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00111000011000000000010000010000001110010100011",
--  (10) multiplication_direct_10
-- -- In case of size 3
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"00001000011000000000010000000000101110100000011",
--  (11) multiplication_direct_11
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000001000010000000000011110001000011",
--  (12) multiplication_direct_12
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o >> 256; Enable sign a; operation : a*b + acc;
"00001000011000000000010000010000010011011000011",
--  (13) multiplication_direct_13
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign b; operation : a*b + acc; Increment o3_0 base address
"00001000011001001000010000000000100011100100011",
--  (14) multiplication_direct_14
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 256; o4_0 = reg_o; o5_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011000111000010000010000110100101000011",
--  (15) multiplication_direct_15
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (16) multiplication_direct_16
-- -- In case of size 4
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000001110100000011",
--  (17) multiplication_direct_17
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001110001000011",
--  (18) multiplication_direct_18
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011100000000010000010000000011011000011",
--  (19) multiplication_direct_19
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000011100100011",
--  (20) multiplication_direct_20
-- reg_a = a3_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010011001100011",
--  (21) multiplication_direct_21
-- reg_a = a0_0; reg_b = b3_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign b; operation : a*b + acc; Increment o3_0 base address
"00001000011101001000010000000000100011110000011",
--  (22) multiplication_direct_22
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011100000000010000010000000100101000011",
--  (23) multiplication_direct_23
-- reg_a = a3_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100011100011",
--  (24) multiplication_direct_24
-- reg_a = a1_0; reg_b = b3_0; reg_acc = reg_o; o4_0 = reg_o; Enable sign b; operation : a*b + acc;
"00001000011100001000010000000000100100110100011",
--  (25) multiplication_direct_25
-- reg_a = a3_0; reg_b = b2_0; reg_acc = reg_o >> 256; Enable sign a; operation : a*b + acc;
"00001000011100000000010000010000011001101100011",
--  (26) multiplication_direct_26
-- reg_a = a2_0; reg_b = b3_0; reg_acc = reg_o; o5_0 = reg_o; Enable sign b; operation : a*b + acc;
"00001000011100001000010000000000101001111000011",
--  (27) multiplication_direct_27
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 256; o6_0 = reg_o; o7_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011100111000010000010000111110111100011",
--  (28) multiplication_direct_28
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (29) square_direct_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; o1_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010000111000010000001000110100000000011",
--  (30) square_direct_1
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (31) square_direct_2
-- -- In case of sizes 2, 3, 4
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00100000010100001000010000001000000100000000011",
--  (32) square_direct_3
-- -- In case of size 2
-- reg_a = a1_0; reg_b = a0_0; reg_acc = reg_o >> 256; o1_0 = reg_o; Enable sign a; operation : 2*a*b + acc;
"00001000010100001010010000010000011001000100011",
--  (33) square_direct_4
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 256; o2_0 = reg_o; o3_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010100111000010000010000111110010100011",
--  (34) square_direct_5
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (35) square_direct_6
-- -- In case of sizes 3, 4
-- reg_a = a1_0; reg_b = a0_0; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : 2*a*b + acc;
"00001000011000001010010000010000001001000100011",
--  (36) square_direct_7
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00101000011000000000010000010000001110010100011",
--  (37) square_direct_8
-- -- In case of size 3
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign b; operation : 2*a*b + acc;
"00001000011000001010010000000000101110100000011",
--  (38) square_direct_9
-- reg_a = a2_0; reg_b = a1_0; reg_acc = reg_o >> 256; o3_0 = reg_o; Enable sign a; operation : 2*a*b + acc; Increment o3_0 base address
"00001000011001001010010000010000010011011000011",
--  (39) square_direct_10
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 256; o4_0 = reg_o; o5_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011000111000010000010000110100101000011",
--  (40) square_direct_11
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (41) square_direct_12
-- -- In case of size 4
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; o2_0 = reg_o; operation : 2*a*b + acc;
"00001000011100001010010000000000001110100000011",
--  (42) square_direct_13
-- reg_a = a2_0; reg_b = a1_0; reg_acc = reg_o >> 256; operation : 2*a*b + acc;
"00001000011100000010010000010000000011011000011",
--  (43) square_direct_14
-- reg_a = a3_0; reg_b = a0_0; reg_acc = reg_o; o3_0 = reg_o; operation : 2*a*b + acc; Enable sign a; Increment o3_0 base address
"00001000011101001010010000000000010011001100011",
--  (44) square_direct_15
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011100000000010000010000000100101000011",
--  (45) square_direct_16
-- reg_a = a3_0; reg_b = a1_0; reg_acc = reg_o; o4_0 = reg_o; Enable sign a; operation : 2*a*b + acc;
"00001000011100001010010000000000010100011100011",
--  (46) square_direct_17
-- reg_a = a3_0; reg_b = a2_0; reg_acc = reg_o >> 256; o5_0 = reg_o; Enable sign a; operation : 2*a*b + acc;
"00001000011100001010010000010000011001101100011",
--  (47) square_direct_18
-- reg_a = a3_0; reg_b = a3_0; reg_acc = reg_o >> 256; o6_0 = reg_o; o7_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011100111000010000010000111110111100011",
--  (48) square_direct_19
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (49) multiplication_with_reduction_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
--  (50) multiplication_with_reduction_1
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010000001100011000000010000100000011011",
--  (51) multiplication_with_reduction_2
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010000000000010000000001000100000010011",
--  (52) multiplication_with_reduction_3
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 256; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
--  (53) multiplication_with_reduction_4
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (54) multiplication_with_reduction_5
-- -- In case of sizes 2, 3, 4
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; operation : a*b + acc;
"00001000010100000000010000001000000100000000011",
--  (55) multiplication_with_reduction_6
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010000100000011011",
--  (56) multiplication_with_reduction_7
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"01001000010100000000010000000001000100000010011",
--  (57) multiplication_with_reduction_8
-- -- In case of size 2
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000010100000000010000010000100100010000011",
--  (58) multiplication_with_reduction_9
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000000000100010010111",
--  (59) multiplication_with_reduction_10
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000010100000000010000000000010100000100011",
--  (60) multiplication_with_reduction_11
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010001001000011011",
--  (61) multiplication_with_reduction_12
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000001000100000010011",
--  (62) multiplication_with_reduction_13
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
--  (63) multiplication_with_reduction_14
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 256; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
--  (64) multiplication_with_reduction_15
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (65) multiplication_with_reduction_16
-- -- In case of sizes 3, 4
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000000100010000011",
--  (66) multiplication_with_reduction_17
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010010111",
--  (67) multiplication_with_reduction_18
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100000100011",
--  (68) multiplication_with_reduction_19
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001001000011011",
--  (69) multiplication_with_reduction_20
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000001000100000010011",
--  (70) multiplication_with_reduction_21
-- reg_a = o0_0; reg_b = prime2; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000000100100010111",
--  (71) multiplication_with_reduction_22
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
--  (72) multiplication_with_reduction_23
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"01100000011000000000010000000000000100010110111",
--  (73) multiplication_with_reduction_24
-- -- In case of size 3
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"00001000011000000000010000000000100100100000011",
--  (74) multiplication_with_reduction_25
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000000000010000000000010100001000011",
--  (75) multiplication_with_reduction_26
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001110000011011",
--  (76) multiplication_with_reduction_27
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000001000100000010011",
--  (77) multiplication_with_reduction_28
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011000000000010000010000100100100100011",
--  (78) multiplication_with_reduction_29
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
--  (79) multiplication_with_reduction_30
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000000000010000000000010100011000011",
--  (80) multiplication_with_reduction_31
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
--  (81) multiplication_with_reduction_32
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
--  (82) multiplication_with_reduction_33
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 256; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
--  (83) multiplication_with_reduction_34
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (84) multiplication_with_reduction_35
-- -- In case of size 4
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100000011",
--  (85) multiplication_with_reduction_36
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100001000011",
--  (86) multiplication_with_reduction_37
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010001110000011011",
--  (87) multiplication_with_reduction_38
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
--  (88) multiplication_with_reduction_39
-- reg_a = a0_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110000011",
--  (89) multiplication_with_reduction_40
-- reg_a = o0_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
--  (90) multiplication_with_reduction_41
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100100011",
--  (91) multiplication_with_reduction_42
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
--  (92) multiplication_with_reduction_43
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011000011",
--  (93) multiplication_with_reduction_44
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011010111",
--  (94) multiplication_with_reduction_45
-- reg_a = a3_0; reg_b = b0_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100001100011",
--  (95) multiplication_with_reduction_46
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o3_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010000011000011011",
--  (96) multiplication_with_reduction_47
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
--  (97) multiplication_with_reduction_48
-- reg_a = a1_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110100011",
--  (98) multiplication_with_reduction_49
-- reg_a = o1_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
--  (99) multiplication_with_reduction_50
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
--  (100) multiplication_with_reduction_51
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
--  (101) multiplication_with_reduction_52
-- reg_a = a3_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100011100011",
--  (102) multiplication_with_reduction_53
-- reg_a = o3_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
--  (103) multiplication_with_reduction_54
-- reg_a = a2_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100111000011",
--  (104) multiplication_with_reduction_55
-- reg_a = o2_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
--  (105) multiplication_with_reduction_56
-- reg_a = a3_0; reg_b = b2_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100101100011",
--  (106) multiplication_with_reduction_57
-- reg_a = o3_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
--  (107) multiplication_with_reduction_58
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
--  (108) multiplication_with_reduction_59
-- reg_a = o3_0; reg_b = prime3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 256; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
--  (109) multiplication_with_reduction_60
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (110) multiplication_with_reduction_special_prime_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000000100000000011",
--  (111) multiplication_with_reduction_special_prime_1
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 256; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
--  (112) multiplication_with_reduction_special_prime_2
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (113) multiplication_with_reduction_special_prime_3
-- -- In case of sizes 2, 3, 4
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00111000010100001000010000001000000100000000011",
--  (114) multiplication_with_reduction_special_prime_4
-- -- In case of size 2
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000010100000000010000010000100100010000011",
--  (115) multiplication_with_reduction_special_prime_5
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000000000100010010111",
--  (116) multiplication_with_reduction_special_prime_6
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; o1_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000010100001000010000000000011001000100011",
--  (117) multiplication_with_reduction_special_prime_7
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
--  (118) multiplication_with_reduction_special_prime_8
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 256; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
--  (119) multiplication_with_reduction_special_prime_9
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (120) multiplication_with_reduction_special_prime_10
-- -- In case of sizes 3, 4
-- reg_a = a0_0; reg_b = b1_0; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000000100010000011",
--  (121) multiplication_with_reduction_special_prime_11
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010010111",
--  (122) multiplication_with_reduction_special_prime_12
-- reg_a = a1_0; reg_b = b0_0; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000001001000100011",
--  (123) multiplication_with_reduction_special_prime_13
-- reg_a = o0_X; reg_b = primeSP2; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000000100100010111",
--  (124) multiplication_with_reduction_special_prime_14
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
--  (125) multiplication_with_reduction_special_prime_15
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"01010000011000000000010000000000000100010110111",
--  (126) multiplication_with_reduction_special_prime_16
-- -- In case of size 3
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"00001000011000000000010000000000100100100000011",
--  (127) multiplication_with_reduction_special_prime_17
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000001000010000000000011110001000011",
--  (128) multiplication_with_reduction_special_prime_18
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011000000000010000010000100100100100011",
--  (129) multiplication_with_reduction_special_prime_19
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
--  (130) multiplication_with_reduction_special_prime_20
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011000000000010000000000010100011000011",
--  (131) multiplication_with_reduction_special_prime_21
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
--  (132) multiplication_with_reduction_special_prime_22
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
--  (133) multiplication_with_reduction_special_prime_23
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 256; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
--  (134) multiplication_with_reduction_special_prime_24
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (135) multiplication_with_reduction_special_prime_25
-- -- In case of size 4
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100000011",
--  (136) multiplication_with_reduction_special_prime_26
-- reg_a = a2_0; reg_b = b0_0; reg_acc = reg_o; o2_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001110001000011",
--  (137) multiplication_with_reduction_special_prime_27
-- reg_a = o0_0; reg_b = primeSP3; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011100000000010000010000000100110010111",
--  (138) multiplication_with_reduction_special_prime_28
-- reg_a = a1_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100100011",
--  (139) multiplication_with_reduction_special_prime_29
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
--  (140) multiplication_with_reduction_special_prime_30
-- reg_a = a2_0; reg_b = b1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011000011",
--  (141) multiplication_with_reduction_special_prime_31
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011010111",
--  (142) multiplication_with_reduction_special_prime_32
-- reg_a = a0_0; reg_b = b3_0; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"00001000011100000000010000000000100100110000011",
--  (143) multiplication_with_reduction_special_prime_33
-- reg_a = a3_0; reg_b = b0_0; reg_acc = reg_o; o3_0 = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100001000010000000000010011001100011",
--  (144) multiplication_with_reduction_special_prime_34
-- reg_a = a1_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100110100011",
--  (145) multiplication_with_reduction_special_prime_35
-- reg_a = o1_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
--  (146) multiplication_with_reduction_special_prime_36
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
--  (147) multiplication_with_reduction_special_prime_37
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
--  (148) multiplication_with_reduction_special_prime_38
-- reg_a = a3_0; reg_b = b1_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100011100011",
--  (149) multiplication_with_reduction_special_prime_39
-- reg_a = o3_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
--  (150) multiplication_with_reduction_special_prime_40
-- reg_a = a2_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign b; operation : a*b + acc;
"00001000011100000000010000010000100100111000011",
--  (151) multiplication_with_reduction_special_prime_41
-- reg_a = o2_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
--  (152) multiplication_with_reduction_special_prime_42
-- reg_a = a3_0; reg_b = b2_0; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"00001000011100000000010000000000010100101100011",
--  (153) multiplication_with_reduction_special_prime_43
-- reg_a = o3_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
--  (154) multiplication_with_reduction_special_prime_44
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
--  (155) multiplication_with_reduction_special_prime_45
-- reg_a = o3_0; reg_b = primeSP3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 256; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
--  (156) multiplication_with_reduction_special_prime_46
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (157) square_with_reduction_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
--  (158) square_with_reduction_1
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010000001100011000000010000100000011011",
--  (159) square_with_reduction_2
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010000000000010000000001000100000010011",
--  (160) square_with_reduction_3
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 256; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
--  (161) square_with_reduction_4
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (162) square_with_reduction_5
-- -- In case of 2, 3, 4
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; operation : a*b + acc;
"00001000010100000000010000001000000100000000011",
--  (163) square_with_reduction_6
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010000100000011011",
--  (164) square_with_reduction_7
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"01000000010100000000010000000001000100000010011",
--  (165) square_with_reduction_8
-- -- In case of size 2
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000010100000010010000010000100100010000011",
--  (166) square_with_reduction_9
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000000000100010010111",
--  (167) square_with_reduction_10
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000010100001100011000000010001001000111011",
--  (168) square_with_reduction_11
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000010100000000010000000001000100000110011",
--  (169) square_with_reduction_12
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
--  (170) square_with_reduction_13
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 256; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
--  (171) square_with_reduction_14
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (172) square_with_reduction_15
-- -- In case of size 3, 4
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 256; operation : 2*a*b + acc;
"00001000011000000010010000010000000100010000011",
--  (173) square_with_reduction_16
-- reg_a = o0_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010010111",
--  (174) square_with_reduction_17
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001001000111011",
--  (175) square_with_reduction_18
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000001000100000110011",
--  (176) square_with_reduction_19
-- reg_a = o0_0; reg_b = prime2; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000000100100010111",
--  (177) square_with_reduction_20
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
--  (178) square_with_reduction_21
-- reg_a = o1_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"01010000011000000000010000000000000100010110111",
--  (179) square_with_reduction_22
-- -- In case of size 3
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000000000100100100000011",
--  (180) square_with_reduction_23
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011000001100011000000010001110000011011",
--  (181) square_with_reduction_24
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000001000100000010011",
--  (182) square_with_reduction_25
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000010000100100100100011",
--  (183) square_with_reduction_26
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
--  (184) square_with_reduction_27
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
--  (185) square_with_reduction_28
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
--  (186) square_with_reduction_29
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 256; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
--  (187) square_with_reduction_30
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (188) square_with_reduction_31
-- -- In case of size 4
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; operation : 2*a*b + acc;
"00001000011100000010010000000000000100100000011",
--  (189) square_with_reduction_32
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010001110000011011",
--  (190) square_with_reduction_33
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
--  (191) square_with_reduction_34
-- reg_a = a0_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110000011",
--  (192) square_with_reduction_35
-- reg_a = o0_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
--  (193) square_with_reduction_36
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o; operation : 2*a*b + acc;
"00001000011100000010010000000000000100100100011",
--  (194) square_with_reduction_37
-- reg_a = o1_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
--  (195) square_with_reduction_38
-- reg_a = o2_0; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100011010111",
--  (196) square_with_reduction_39
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o3_0 = reg_y; operation : keep accumulator;
"00001000011100001100011000000010000011000011011",
--  (197) square_with_reduction_40
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000001000100000010011",
--  (198) square_with_reduction_41
-- reg_a = a1_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110100011",
--  (199) square_with_reduction_42
-- reg_a = o1_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
--  (200) square_with_reduction_43
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
--  (201) square_with_reduction_44
-- reg_a = o2_0; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
--  (202) square_with_reduction_45
-- reg_a = o3_0; reg_b = prime1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
--  (203) square_with_reduction_46
-- reg_a = a2_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100111000011",
--  (204) square_with_reduction_47
-- reg_a = o2_0; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
--  (205) square_with_reduction_48
-- reg_a = o3_0; reg_b = prime2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
--  (206) square_with_reduction_49
-- reg_a = a3_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
--  (207) square_with_reduction_50
-- reg_a = o3_0; reg_b = prime3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 256; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
--  (208) square_with_reduction_51
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (209) square_with_reduction_special_prime_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"00001000010000000000010000001000110100000000011",
--  (210) square_with_reduction_special_prime_1
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 256; o0_0 = reg_o; operation : a*b + acc;
"00001000010000001000010000010111000100000000011",
--  (211) square_with_reduction_special_prime_2
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (212) square_with_reduction_special_prime_3
-- -- In case of size 2, 3, 4
-- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
"00110000010100001000010000001000000100000000011",
--  (213) square_with_reduction_special_prime_4
-- -- In case of size 2
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000010100000010010000010000100100010000011",
--  (214) square_with_reduction_special_prime_5
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000010100001000010000000000001001010010111",
--  (215) square_with_reduction_special_prime_6
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000010100000000010000010000110100010100011",
--  (216) square_with_reduction_special_prime_7
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; o1_0 = reg_o >> 256; operation : a*b + acc;
"00001000010100111000010000000000000100010110111",
--  (217) square_with_reduction_special_prime_8
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (218) square_with_reduction_special_prime_9
-- -- In case of size 3, 4
-- reg_a = a0_0; reg_b = a1_0; reg_acc = reg_o >> 256; operation : 2*a*b + acc;
"00001000011000000010010000010000000100010000011",
--  (219) square_with_reduction_special_prime_10
-- reg_a = o0_0; reg_b = primeSP1; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000001001010010111",
--  (220) square_with_reduction_special_prime_11
-- reg_a = o0_0; reg_b = primeSP2; reg_acc = reg_o >> 256; operation : a*b + acc;
"00001000011000000000010000010000000100100010111",
--  (221) square_with_reduction_special_prime_12
-- reg_a = a1_0; reg_b = a1_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100010100011",
--  (222) square_with_reduction_special_prime_13
-- reg_a = o1_0; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"01000000011000000000010000000000000100010110111",
--  (223) square_with_reduction_special_prime_14
-- -- In case of size 3
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; o2_0 = reg_o; Enable sign b; operation : 2*a*b + acc;
"00001000011000001010010000000000101110100000011",
--  (224) square_with_reduction_special_prime_15
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011000000010010000010000100100100100011",
--  (225) square_with_reduction_special_prime_16
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011000000000010000000000000100100110111",
--  (226) square_with_reduction_special_prime_17
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011000001000010000000000000100011010111",
--  (227) square_with_reduction_special_prime_18
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011000000000010000010000110100101000011",
--  (228) square_with_reduction_special_prime_19
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; o2_0 = reg_o >> 256; operation : a*b + acc;
"00001000011000111000010000000000001001101010111",
--  (229) square_with_reduction_special_prime_20
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (230) square_with_reduction_special_prime_21
-- -- In case of size 4
-- reg_a = a0_0; reg_b = a2_0; reg_acc = reg_o; o2_0 = reg_o; operation : 2*a*b + acc;
"00001000011100001010010000000000001110100000011",
--  (231) square_with_reduction_special_prime_22
-- reg_a = a0_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110000011",
--  (232) square_with_reduction_special_prime_23
-- reg_a = o0_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110010111",
--  (233) square_with_reduction_special_prime_24
-- reg_a = a1_0; reg_b = a2_0; reg_acc = reg_o; operation : 2*a*b + acc;
"00001000011100000010010000000000000100100100011",
--  (234) square_with_reduction_special_prime_25
-- reg_a = o1_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100100110111",
--  (235) square_with_reduction_special_prime_26
-- reg_a = o2_0; reg_b = primeSP1; reg_acc = reg_o; o3_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000011011010111",
--  (236) square_with_reduction_special_prime_27
-- reg_a = a1_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100110100011",
--  (237) square_with_reduction_special_prime_28
-- reg_a = o1_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100110110111",
--  (238) square_with_reduction_special_prime_29
-- reg_a = a2_0; reg_b = a2_0; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101000011",
--  (239) square_with_reduction_special_prime_30
-- reg_a = o2_0; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100101010111",
--  (240) square_with_reduction_special_prime_31
-- reg_a = o3_0; reg_b = primeSP1; reg_acc = reg_o; o0_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000000100011110111",
--  (241) square_with_reduction_special_prime_32
-- reg_a = a2_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign b; operation : 2*a*b + acc;
"00001000011100000010010000010000100100111000011",
--  (242) square_with_reduction_special_prime_33
-- reg_a = o2_0; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"00001000011100000000010000000000000100111010111",
--  (243) square_with_reduction_special_prime_34
-- reg_a = o3_0; reg_b = primeSP2; reg_acc = reg_o; o1_0 = reg_o; operation : a*b + acc;
"00001000011100001000010000000000001001101110111",
--  (244) square_with_reduction_special_prime_35
-- reg_a = a3_0; reg_b = a3_0; reg_acc = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
"00001000011100000000010000010000110100111100011",
--  (245) square_with_reduction_special_prime_36
-- reg_a = o3_0; reg_b = primeSP3; reg_acc = reg_o; o2_0 = reg_o; o3_0 = reg_o >> 256; operation : a*b + acc;
"00001000011100111000010000000000001110111110111",
--  (246) square_with_reduction_special_prime_37
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"00000000000010000000010000001111000100000000011",
--  (247) addition_subtraction_direct_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000010000001000000100001000110100000000010",
--  (248) addition_subtraction_direct_1
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (249) addition_subtraction_direct_2
-- -- In case of size 2, 3, 4
-- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : b +/- a + acc;
"00011000010100001000000100001000000100000000010",
--  (250) addition_subtraction_direct_3
-- -- In case of size 2
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 256; o1_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000010100001000000100010000111001010100010",
--  (251) addition_subtraction_direct_4
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (252) addition_subtraction_direct_5
-- -- In case of size 3, 4
-- reg_a = a1_0; reg_b = b1_0; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : b +/- a + acc;
"00011000011000001000000100010000001001010100010",
--  (253) addition_subtraction_direct_6
-- -- In case of size 3
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 256; o2_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000011000001000000100010000110110101000010",
--  (254) addition_subtraction_direct_7
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (255) addition_subtraction_direct_8
-- -- In case of size 4
-- reg_a = a2_0; reg_b = b2_0; reg_acc = reg_o >> 256; o2_0 = reg_o; operation : b +/- a + acc;
"00001000011100001000000100010000000110101000010",
--  (256) addition_subtraction_direct_9
-- reg_a = a3_0; reg_b = b3_0; reg_acc = reg_o >> 256; o3_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000011100001000000100010000110011111100010",
--  (257) addition_subtraction_direct_10
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (258) iterative_modular_reduction_0
-- -- In case of size 1
-- reg_a = a0_0; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"00001000010000000000001000001100110100000010010",
--  (259) iterative_modular_reduction_1
-- reg_a = 0; reg_b = prime_0; reg_acc = reg_o; reg_s = reg_o_positive; Enable sign a,b; operation : -s*b + a + acc;
"00001000010000000001100011100011110100000010010",
--  (260) iterative_modular_reduction_2
-- reg_a = 0; reg_b = prime_0; reg_acc = reg_o; reg_s = reg_o_negative; Enable sign a,b; operation : s*b + a + acc;
"00001000010000000000101001100011110100000010010",
--  (261) iterative_modular_reduction_3
-- reg_a = 0; reg_b = prime_0; reg_acc = reg_o; o0_0 = reg_o; reg_s = reg_o_negative; Enable sign a,b; operation : s*b + a + acc;
"00001000010000001000101001100011110100000010010",
--  (262) iterative_modular_reduction_4
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (263) iterative_modular_reduction_5
-- -- In case of size 2
-- reg_a = a1_0; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"00001000010100000000001000001100110100000110010",
--  (264) iterative_modular_reduction_6
-- reg_a = a0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"00001000010100001001100011101000000100000010010",
--  (265) iterative_modular_reduction_7
-- reg_a = a1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; Enable sign a,b; operation : -s*b + a + acc
"00001000010100001001100000010000111001010110010",
--  (266) iterative_modular_reduction_8
-- reg_a = o0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"00001000010100001000101001101000000100000010110",
--  (267) iterative_modular_reduction_9
-- reg_a = o1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; Enable sign a,b operation : s*b + a + acc
"00001000010100001000101000010000111001010110110",
--  (268) iterative_modular_reduction_10
-- reg_a = o0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"00001000010100001000101001101000000100000010110",
--  (269) iterative_modular_reduction_11
-- reg_a = o1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; Enable sign a,b operation : s*b + a + acc
"00001000010100001000101000010000111001010110110",
--  (270) iterative_modular_reduction_12
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (271) iterative_modular_reduction_13
-- -- In case of size 3
-- reg_a = a2_0; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"00001000011000000000001000001100111110101010010",
--  (272) iterative_modular_reduction_14
-- reg_a = a0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"00001000011000001001100011101000000100000010010",
--  (273) iterative_modular_reduction_15
-- reg_a = a1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : -s*b + a + acc
"00001000011000001001100000010000001001010110010",
--  (274) iterative_modular_reduction_16
-- reg_a = a2_0; reg_b = prime_2; reg_acc = reg_o >> 256; o2_0 = reg_o; Enable sign a,b; operation : -s*b + a + acc
"00001000011000001001100000010000111110101010010",
--  (275) iterative_modular_reduction_17
-- reg_a = o0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"00001000011000001000101001101000000100000010110",
--  (276) iterative_modular_reduction_18
-- reg_a = o1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : s*b + a + acc
"00001000011000001000101000010000001001010110110",
--  (277) iterative_modular_reduction_19
-- reg_a = o2_0; reg_b = prime_2; reg_acc = reg_o >> 256; o2_0 = reg_o; Enable sign a,b operation : s*b + a + acc
"00001000011000001000101000010000111110101010110",
--  (278) iterative_modular_reduction_20
-- reg_a = o0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"00001000011000001000101001101000000100000010110",
--  (279) iterative_modular_reduction_21
-- reg_a = o1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : s*b + a + acc
"00001000011000001000101000010000001001010110110",
--  (280) iterative_modular_reduction_22
-- reg_a = o2_0; reg_b = prime_2; reg_acc = reg_o >> 256; o2_0 = reg_o; Enable sign a,b operation : s*b + a + acc
"00001000011000001000101000010000111110101010110",
--  (281) iterative_modular_reduction_23
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (282) iterative_modular_reduction_24
-- -- In case of size 4
-- reg_a = a3_0; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"00001000011100000000001000001100110011111110010",
--  (283) iterative_modular_reduction_25
-- reg_a = a0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"00001000011100001001100011101000000100000010010",
--  (284) iterative_modular_reduction_26
-- reg_a = a1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : -s*b + a + acc
"00001000011100001001100000010000001001010110010",
--  (285) iterative_modular_reduction_27
-- reg_a = a2_0; reg_b = prime_2; reg_acc = reg_o >> 256; o2_0 = reg_o; operation : -s*b + a + acc
"00001000011100001001100000010000001110101010010",
--  (286) iterative_modular_reduction_28
-- reg_a = a3_0; reg_b = prime_3; reg_acc = reg_o >> 256; o3_0 = reg_o; Enable sign a,b; operation : -s*b + a + acc
"00001000011100001001100000010000110011111110010",
--  (287) iterative_modular_reduction_29
-- reg_a = o0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"00001000011100001000101001101000000100000010110",
--  (288) iterative_modular_reduction_30
-- reg_a = o1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : s*b + a + acc
"00001000011100001000101000010000001001010110110",
--  (289) iterative_modular_reduction_31
-- reg_a = o2_0; reg_b = prime_2; reg_acc = reg_o >> 256; o2_0 = reg_o; operation : s*b + a + acc
"00001000011100001000101000010000001110101010110",
--  (290) iterative_modular_reduction_32
-- reg_a = o3_0; reg_b = prime_3; reg_acc = reg_o >> 256; o3_0 = reg_o; Enable sign a,b; operation : s*b + a + acc
"00001000011100001000101000010000110011111110110",
--  (291) iterative_modular_reduction_33
-- reg_a = o0_0; reg_b = prime_0; reg_acc = 0; o0_0 = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"00001000011100001000101001101000000100000010110",
--  (292) iterative_modular_reduction_34
-- reg_a = o1_0; reg_b = prime_1; reg_acc = reg_o >> 256; o1_0 = reg_o; operation : s*b + a + acc
"00001000011100001000101000010000001001010110110",
--  (293) iterative_modular_reduction_35
-- reg_a = o2_0; reg_b = prime_2; reg_acc = reg_o >> 256; o2_0 = reg_o; operation : s*b + a + acc
"00001000011100001000101000010000001110101010110",
--  (294) iterative_modular_reduction_36
-- reg_a = o3_0; reg_b = prime_3; reg_acc = reg_o >> 256; o3_0 = reg_o; Enable sign a,b; operation : s*b + a + acc
"00001000011100001000101000010000110011111110110",
--  (295) iterative_modular_reduction_37
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (296) addition_subtraction_with_reduction_0
-- Operands size 1
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_X = reg_o; Enable sign a,b; operation : b +/- a + acc;
"00001000010000001000001100001000110100000000010",
--  (297) addition_subtraction_with_reduction_1
-- reg_a = 0; reg_b = 2prime0; reg_acc = reg_o; reg_s = reg_o_positive; o0_X = reg_o; Enable sign a,b; operation : -s*b + a + acc;
"00001000010000001001100011100011110100000001010",
--  (298) addition_subtraction_with_reduction_2
-- reg_a = 0; reg_b = 2prime0; reg_acc = reg_o; reg_s = reg_o_negative; o0_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000010000001000101001100011110100000001010",
--  (299) addition_subtraction_with_reduction_3
-- reg_a = 0; reg_b = 2prime0; reg_acc = reg_o; reg_s = reg_o_negative; o0_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000010000001000101001100011110100000001010",
--  (300) addition_subtraction_with_reduction_4
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (301) addition_subtraction_with_reduction_5
-- -- In case of sizes 2, 3, 4
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_X = reg_o; operation : b +/- a + acc;
"01001000010100001000000100001000000100000000010",
--  (302) addition_subtraction_with_reduction_6
-- -- In case of size 2
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o >> 256; o1_X = reg_o; Enable sign a, b; operation : b +/- a + acc;
"00001000010100001000000100010000111001010100010",
--  (303) addition_subtraction_with_reduction_7
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc;
"00001000010100001001100011101000000100000001110",
--  (304) addition_subtraction_with_reduction_8
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; Enable sign a,b; operation : -s*b + a + acc;
"00001000010100001001100000010000111001010101110",
--  (305) addition_subtraction_with_reduction_9
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc;
"00001000010100001000101001101000000100000001110",
--  (306) addition_subtraction_with_reduction_10
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000010100001000101000010000111001010101110",
--  (307) addition_subtraction_with_reduction_11
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc;
"00001000010100001000101001101000000100000001110",
--  (308) addition_subtraction_with_reduction_12
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000010100001000101000010000111001010101110",
--  (309) addition_subtraction_with_reduction_13
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (310) addition_subtraction_with_reduction_14
-- -- In case of sizes 3, 4
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o >> 256; o1_X = reg_o; operation : b +/- a + acc;
"01100000011000001000000100010000001001010100010",
--  (311) addition_subtraction_with_reduction_15
-- -- In case of size 3
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o >> 256; o2_X = reg_o; Enable sign a, b; operation : b +/- a + acc;
"00001000011000001000000100010000110110101000010",
--  (312) addition_subtraction_with_reduction_16
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc;
"00001000011000001001100011101000000100000001110",
--  (313) addition_subtraction_with_reduction_17
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; operation : -s*b + a + acc;
"00001000011000001001100000010000001001010101110",
--  (314) addition_subtraction_with_reduction_18
-- reg_a = o2_X; reg_b = 2prime2; reg_acc = reg_o >> 256; o2_X = reg_o; Enable sign a,b; operation : -s*b + a + acc;
"00001000011000001001100000010000111110101001110",
--  (315) addition_subtraction_with_reduction_19
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc;
"00001000011000001000101001101000000100000001110",
--  (316) addition_subtraction_with_reduction_20
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; operation : s*b + a + acc;
"00001000011000001000101000010000001001010101110",
--  (317) addition_subtraction_with_reduction_21
-- reg_a = o2_X; reg_b = 2prime2; reg_acc = reg_o >> 256; o2_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000011000001000101000010000111110101001110",
--  (318) addition_subtraction_with_reduction_22
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc;
"00001000011000001000101001101000000100000001110",
--  (319) addition_subtraction_with_reduction_23
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; operation : s*b + a + acc;
"00001000011000001000101000010000001001010101110",
--  (320) addition_subtraction_with_reduction_24
-- reg_a = o2_X; reg_b = 2prime2; reg_acc = reg_o >> 256; o2_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000011000001000101000010000111110101001110",
--  (321) addition_subtraction_with_reduction_25
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010",
--  (322) addition_subtraction_with_reduction_26
-- -- In case of size 4
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o >> 256; o2_X = reg_o; operation : b +/- a + acc;
"00001000011100001000000100010000000110101000010",
--  (323) addition_subtraction_with_reduction_27
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o >> 256; o3_X = reg_o; Enable sign a, b; operation : b +/- a + acc;
"00001000011100001000000100010000110011111100010",
--  (324) addition_subtraction_with_reduction_28
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc;
"00001000011100001001100011101000000100000001110",
--  (325) addition_subtraction_with_reduction_29
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; operation : -s*b + a + acc;
"00001000011100001001100000010000001001010101110",
--  (326) addition_subtraction_with_reduction_30
-- reg_a = o2_X; reg_b = 2prime2; reg_acc = reg_o >> 256; o2_X = reg_o; operation : -s*b + a + acc;
"00001000011100001001100000010000001110101001110",
--  (327) addition_subtraction_with_reduction_31
-- reg_a = o3_X; reg_b = 2prime3; reg_acc = reg_o >> 256; o3_X = reg_o; Enable sign a,b; operation : -s*b + a + acc;
"00001000011100001001100000010000110011111101110",
--  (328) addition_subtraction_with_reduction_32
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc;
"00001000011100001000101001101000000100000001110",
--  (329) addition_subtraction_with_reduction_33
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; operation : s*b + a + acc;
"00001000011100001000101000010000001001010101110",
--  (330) addition_subtraction_with_reduction_34
-- reg_a = o2_X; reg_b = 2prime2; reg_acc = reg_o >> 256; o2_X = reg_o; operation : s*b + a + acc;
"00001000011100001000101000010000001110101001110",
--  (331) addition_subtraction_with_reduction_35
-- reg_a = o3_X; reg_b = 2prime3; reg_acc = reg_o >> 256; o3_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000011100001000101000010000110011111101110",
--  (332) addition_subtraction_with_reduction_36
-- reg_a = o0_X; reg_b = 2prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc;
"00001000011100001000101001101000000100000001110",
--  (333) addition_subtraction_with_reduction_37
-- reg_a = o1_X; reg_b = 2prime1; reg_acc = reg_o >> 256; o1_X = reg_o; operation : s*b + a + acc;
"00001000011100001000101000010000001001010101110",
--  (334) addition_subtraction_with_reduction_38
-- reg_a = o2_X; reg_b = 2prime2; reg_acc = reg_o >> 256; o2_X = reg_o; operation : s*b + a + acc;
"00001000011100001000101000010000001110101001110",
--  (335) addition_subtraction_with_reduction_39
-- reg_a = o3_X; reg_b = 2prime3; reg_acc = reg_o >> 256; o3_X = reg_o; Enable sign a,b; operation : s*b + a + acc;
"00001000011100001000101000010000110011111101110",
--  (336) addition_subtraction_with_reduction_40
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"00000000000010000000001000001111000100000000010"
);



constant rom_state_machine_fill_nop : romtype(337 to 511) := (others => "00000000000010000000010000001111000100000000011");
constant rom_state_machine : romtype(0 to 511) := rom_state_machine_program & rom_state_machine_fill_nop;

signal rom_state_machine_address : std_logic_vector(8 downto 0);
signal rom_state_machine_next_address : std_logic_vector(8 downto 0);
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
signal reg_rom_last_state : std_logic;
signal rom_current_operand_size : std_logic_vector(1 downto 0);
signal rom_next_operation_same_operand_size : std_logic_vector(4 downto 0);
signal rom_next_operation_different_operand_size : std_logic_vector(4 downto 0);

signal adder_a : unsigned(8 downto 0);
signal adder_b : unsigned(4 downto 0);
signal adder_o : unsigned(8 downto 0);

signal ultimate_instruction : std_logic;

-- 0000 multiplication with no reduction
constant first_state_multiplication_direct_operand_size_1 : std_logic_vector(8 downto 0)                           := std_logic_vector(to_unsigned(0,9));
constant first_state_multiplication_direct_operand_size_2_3_4 : std_logic_vector(8 downto 0)                       := std_logic_vector(to_unsigned(2,9));
-- 0001 square with no reduction                                                                                   
constant first_state_square_direct_operand_size_1 : std_logic_vector(8 downto 0)                                   := std_logic_vector(to_unsigned(29,9));
constant first_state_square_direct_operand_size_2_3_4 : std_logic_vector(8 downto 0)                               := std_logic_vector(to_unsigned(31,9));
-- 0010 multiplication with reduction and prime line not equal to 1                                                
constant first_state_multiplication_with_reduction_operand_size_1 : std_logic_vector(8 downto 0)                   := std_logic_vector(to_unsigned(49,9));
constant first_state_multiplication_with_reduction_operand_size_2_3_4 : std_logic_vector(8 downto 0)               := std_logic_vector(to_unsigned(54,9));
-- 0010 multiplication with reduction and prime line equal to 1                                                    
constant first_state_multiplication_with_reduction_special_prime_operand_size_1 : std_logic_vector(8 downto 0)     := std_logic_vector(to_unsigned(110,9));
constant first_state_multiplication_with_reduction_special_prime_operand_size_2_3_4 : std_logic_vector(8 downto 0) := std_logic_vector(to_unsigned(113,9));
-- 0011 square with reduction and prime line not equal to 1
constant first_state_square_with_reduction_operand_size_1 : std_logic_vector(8 downto 0)                           := std_logic_vector(to_unsigned(157,9));
constant first_state_square_with_reduction_operand_size_2_3_4 : std_logic_vector(8 downto 0)                       := std_logic_vector(to_unsigned(162,9));
-- 0011 square with reduction and prime line equal to 1                                                            
constant first_state_square_with_reduction_special_prime_operand_size_1 : std_logic_vector(8 downto 0)             := std_logic_vector(to_unsigned(209,9));
constant first_state_square_with_reduction_special_prime_operand_size_2_3_4 : std_logic_vector(8 downto 0)         := std_logic_vector(to_unsigned(212,9));
-- 0100 addition with no reduction                                                                                 
constant first_state_addition_subtraction_direct_operand_size_1 : std_logic_vector(8 downto 0)                     := std_logic_vector(to_unsigned(247,9));
constant first_state_addition_subtraction_direct_operand_size_2_3_4 : std_logic_vector(8 downto 0)                 := std_logic_vector(to_unsigned(249,9));
-- 0101 iterative modular reduction                                                                                
constant first_state_iterative_modular_reduction_operand_size_1 : std_logic_vector(8 downto 0)                     := std_logic_vector(to_unsigned(258,9));
constant first_state_iterative_modular_reduction_operand_size_2 : std_logic_vector(8 downto 0)                     := std_logic_vector(to_unsigned(263,9));
constant first_state_iterative_modular_reduction_operand_size_3 : std_logic_vector(8 downto 0)                     := std_logic_vector(to_unsigned(271,9));
constant first_state_iterative_modular_reduction_operand_size_4 : std_logic_vector(8 downto 0)                     := std_logic_vector(to_unsigned(282,9));
-- 0110 addition with no reduction                                                                                 
constant first_state_addition_subtraction_with_reduction_operand_size_1 : std_logic_vector(8 downto 0)             := std_logic_vector(to_unsigned(296,9));
constant first_state_addition_subtraction_with_reduction_operand_size_2_3_4 : std_logic_vector(8 downto 0)         := std_logic_vector(to_unsigned(301,9));

type state is (reset, decode_instruction, instruction_execution, multiplication_direct_0, multiplication_direct_2, square_direct_0, square_direct_2, multiplication_with_reduction_special_prime_0, multiplication_with_reduction_special_prime_3, multiplication_with_reduction_0, multiplication_with_reduction_5, square_with_reduction_special_prime_0, square_with_reduction_special_prime_3, square_with_reduction_0, square_with_reduction_5, addition_subtraction_direct_0, addition_subtraction_direct_2, iterative_modular_reduction_0, iterative_modular_reduction_5, iterative_modular_reduction_13, iterative_modular_reduction_24, addition_subtraction_with_reduction_0, addition_subtraction_with_reduction_5);

signal actual_state, next_state : state;

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
            if(internal_sel_output_rom = '1') then
                internal_sm_rotation_size <= rom_sm_rotation_size;
                internal_sm_circular_shift_enable <= internal_next_sm_circular_shift_enable;
                internal_sel_address_a <= rom_sel_address_a;
                internal_sel_address_b_prime <= rom_sel_address_b_prime;
                internal_sm_specific_mac_address_a <= rom_sm_specific_mac_address_a;
                internal_sm_specific_mac_address_b <= rom_sm_specific_mac_address_b;
                internal_sm_specific_mac_address_o <= rom_sm_specific_mac_address_o;
                internal_sm_specific_mac_next_address_o <= rom_sm_specific_mac_next_address_o;
                internal_mac_enable_signed_a <= rom_mac_enable_signed_a;
                internal_mac_enable_signed_b <= rom_mac_enable_signed_b;
                internal_mac_sel_load_reg_a <= rom_mac_sel_load_reg_a;
                internal_mac_clear_reg_b <= rom_mac_clear_reg_b;
                internal_mac_clear_reg_acc <= rom_mac_clear_reg_acc;
                internal_mac_sel_shift_reg_o <= rom_mac_sel_shift_reg_o;
                internal_mac_enable_update_reg_s <= rom_mac_enable_update_reg_s;
                internal_mac_sel_reg_s_reg_o_sign <= rom_mac_sel_reg_s_reg_o_sign;
                internal_mac_reg_s_reg_o_positive <= rom_mac_reg_s_reg_o_positive;
                internal_sm_sign_a_mode <= rom_sm_sign_a_mode;
                internal_sm_mac_operation_mode <= rom_sm_mac_operation_mode;
                internal_mac_enable_reg_s_mask <= rom_mac_enable_reg_s_mask;
                internal_mac_subtraction_reg_a_b <= rom_mac_subtraction_reg_a_b;
                internal_mac_sel_multiply_two_a_b <= rom_mac_sel_multiply_two_a_b;
                internal_mac_sel_reg_y_output <= rom_mac_sel_reg_y_output;
                internal_sm_mac_write_enable_output <= rom_sm_mac_write_enable_output;
                internal_mac_memory_double_mode <= rom_mac_memory_double_mode;
                internal_mac_memory_only_write_mode <= rom_mac_memory_only_write_mode;
                internal_base_address_generator_o_increment_previous_address <= rom_base_address_generator_o_increment_previous_address;
                internal_sm_free_flag <= internal_next_sm_free_flag;
            else
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
    end if;
end process;

update_output : process(next_state)
begin
    case (next_state) is
        when reset =>
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
        when multiplication_direct_0 =>
            -- multiplication_direct_0;
            -- -- In case of size 1
            -- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; o1_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
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
            internal_next_mac_enable_signed_a <= '1';
            internal_next_mac_enable_signed_b <= '1';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
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
            internal_next_sm_mac_write_enable_output <= '1';
            internal_next_mac_memory_double_mode <= '1';
            internal_next_mac_memory_only_write_mode <= '1';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when multiplication_direct_2 =>
            -- multiplication_direct_2;
            -- -- Other cases
            -- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
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
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
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
            internal_next_sm_mac_write_enable_output <= '1';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when square_direct_0 =>
            -- square_direct_0;
            -- -- In case of size 1
            -- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; o1_0 = reg_o >> 256; Enable sign a,b; operation : a*b + acc;
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
            internal_next_mac_enable_signed_a <= '1';
            internal_next_mac_enable_signed_b <= '1';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
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
            internal_next_sm_mac_write_enable_output <= '1';
            internal_next_mac_memory_double_mode <= '1';
            internal_next_mac_memory_only_write_mode <= '1';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when square_direct_2 =>
            -- square_direct_2;
            -- -- In case of sizes 2, 3, 4
            -- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
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
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
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
            internal_next_sm_mac_write_enable_output <= '1';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when multiplication_with_reduction_special_prime_0 =>
            -- multiplication_with_reduction_special_prime_0;
            -- -- In case of size 1
            -- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
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
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
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
        when multiplication_with_reduction_special_prime_3 =>
            -- multiplication_with_reduction_special_prime_3;
            -- -- In case of sizes 2, 3, 4
            -- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
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
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
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
            internal_next_sm_mac_write_enable_output <= '1';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when multiplication_with_reduction_0 =>
            -- multiplication_with_reduction_0
            -- -- In case of size 1
            -- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
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
            internal_next_mac_enable_signed_a <= '1';
            internal_next_mac_enable_signed_b <= '1';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
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
        when multiplication_with_reduction_5 =>
            -- multiplication_with_reduction_5
            -- -- In case of sizes 2, 3, 4
            -- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; operation : a*b + acc;
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
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
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
        when square_with_reduction_special_prime_0 =>
            -- square_with_reduction_special_prime_0
            -- -- In case of size 1
            -- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
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
            internal_next_mac_enable_signed_a <= '1';
            internal_next_mac_enable_signed_b <= '1';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
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
        when square_with_reduction_special_prime_3 =>
            -- square_with_reduction_special_prime_3
            -- -- In case of size 2, 3, 4
            -- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; o0_0 = reg_o; operation : a*b + acc;
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
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
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
            internal_next_sm_mac_write_enable_output <= '1';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when square_with_reduction_0 =>
            -- square_with_reduction_0
            -- -- In case of size 1
            -- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
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
            internal_next_mac_enable_signed_a <= '1';
            internal_next_mac_enable_signed_b <= '1';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
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
        when square_with_reduction_5 =>
            -- square_with_reduction_5
            -- -- In case of 2, 3, 4
            -- reg_a = a0_0; reg_b = a0_0; reg_acc = 0; operation : a*b + acc;
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
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
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
        when addition_subtraction_direct_0 =>
            -- addition_subtraction_direct_0
            -- -- In case of size 1
            -- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
            internal_next_sel_output_rom <= '1';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '0';
            internal_next_sm_free_flag <= '0';
            internal_next_sm_rotation_size <= "10";
            internal_next_sm_circular_shift_enable <= '1';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "00";
            internal_next_sm_specific_mac_address_a <= "00";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '1';
            internal_next_mac_enable_signed_b <= '1';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '1';
            internal_next_sm_mac_operation_mode <= "00";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '1';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when addition_subtraction_direct_2 =>
            -- addition_subtraction_direct_2
            -- -- In case of size 2, 3, 4
            -- reg_a = a0_0; reg_b = b0_0; reg_acc = 0; o0_0 = reg_o; operation : b +/- a + acc;
            internal_next_sel_output_rom <= '1';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '0';
            internal_next_sm_free_flag <= '0';
            internal_next_sm_rotation_size <= "10";
            internal_next_sm_circular_shift_enable <= '1';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "00";
            internal_next_sm_specific_mac_address_a <= "00";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '0';
            internal_next_mac_enable_signed_b <= '0';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '1';
            internal_next_sm_mac_operation_mode <= "00";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '1';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when iterative_modular_reduction_0 =>
            -- iterative_modular_reduction_0
            -- reg_a = a0_0; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
            internal_next_sel_output_rom <= '1';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '0';
            internal_next_sm_free_flag <= '0';
            internal_next_sm_rotation_size <= "10";
            internal_next_sm_circular_shift_enable <= '1';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "10";
            internal_next_sm_specific_mac_address_a <= "00";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '1';
            internal_next_mac_enable_signed_b <= '1';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '1';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '0';
            internal_next_sm_mac_operation_mode <= "01";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '0';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when iterative_modular_reduction_5 =>
            -- iterative_modular_reduction_5
            -- reg_a = a1_0; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
            internal_next_sel_output_rom <= '1';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '0';
            internal_next_sm_free_flag <= '0';
            internal_next_sm_rotation_size <= "10";
            internal_next_sm_circular_shift_enable <= '1';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "10";
            internal_next_sm_specific_mac_address_a <= "01";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '1';
            internal_next_mac_enable_signed_b <= '1';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '1';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '0';
            internal_next_sm_mac_operation_mode <= "01";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '0';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when iterative_modular_reduction_13 =>
            -- iterative_modular_reduction_13
            -- reg_a = a2_0; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
            internal_next_sel_output_rom <= '1';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '0';
            internal_next_sm_free_flag <= '0';
            internal_next_sm_rotation_size <= "10";
            internal_next_sm_circular_shift_enable <= '1';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "10";
            internal_next_sm_specific_mac_address_a <= "10";
            internal_next_sm_specific_mac_address_b <= "10";
            internal_next_sm_specific_mac_address_o <= "10";
            internal_next_sm_specific_mac_next_address_o <= "11";
            internal_next_mac_enable_signed_a <= '1';
            internal_next_mac_enable_signed_b <= '1';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '1';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '0';
            internal_next_sm_mac_operation_mode <= "01";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '0';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when iterative_modular_reduction_24 =>
            -- iterative_modular_reduction_24
            -- reg_a = a3_0; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
            internal_next_sel_output_rom <= '1';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '0';
            internal_next_sm_free_flag <= '0';
            internal_next_sm_rotation_size <= "10";
            internal_next_sm_circular_shift_enable <= '1';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "10";
            internal_next_sm_specific_mac_address_a <= "11";
            internal_next_sm_specific_mac_address_b <= "11";
            internal_next_sm_specific_mac_address_o <= "11";
            internal_next_sm_specific_mac_next_address_o <= "00";
            internal_next_mac_enable_signed_a <= '1';
            internal_next_mac_enable_signed_b <= '1';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '1';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '0';
            internal_next_sm_mac_operation_mode <= "01";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '0';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when addition_subtraction_with_reduction_0 =>
            -- Operands size 1
            -- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_X = reg_o; Enable sign a,b; operation : b +/- a + acc;
            internal_next_sel_output_rom <= '1';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '0';
            internal_next_sm_free_flag <= '0';
            internal_next_sm_rotation_size <= "10";
            internal_next_sm_circular_shift_enable <= '1';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "00";
            internal_next_sm_specific_mac_address_a <= "00";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '1';
            internal_next_mac_enable_signed_b <= '1';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '1';
            internal_next_sm_mac_operation_mode <= "01";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '1';
            internal_next_mac_memory_double_mode <= '0';
            internal_next_mac_memory_only_write_mode <= '0';
            internal_next_base_address_generator_o_increment_previous_address <= '0';
        when addition_subtraction_with_reduction_5 =>
            -- -- In case of sizes 2, 3, 4
            -- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_X = reg_o; operation : b +/- a + acc;
            internal_next_sel_output_rom <= '1';
            internal_next_update_rom_address <= '1';
            internal_next_sel_load_new_rom_address <= '0';
            internal_next_sm_free_flag <= '0';
            internal_next_sm_rotation_size <= "10";
            internal_next_sm_circular_shift_enable <= '1';
            internal_next_sel_address_a <= '0';
            internal_next_sel_address_b_prime <= "00";
            internal_next_sm_specific_mac_address_a <= "00";
            internal_next_sm_specific_mac_address_b <= "00";
            internal_next_sm_specific_mac_address_o <= "00";
            internal_next_sm_specific_mac_next_address_o <= "01";
            internal_next_mac_enable_signed_a <= '0';
            internal_next_mac_enable_signed_b <= '0';
            internal_next_mac_sel_load_reg_a <= "00";
            internal_next_mac_clear_reg_b <= '0';
            internal_next_mac_clear_reg_acc <= '1';
            internal_next_mac_sel_shift_reg_o <= '0';
            internal_next_mac_enable_update_reg_s <= '0';
            internal_next_mac_sel_reg_s_reg_o_sign <= '0';
            internal_next_mac_reg_s_reg_o_positive <= '0';
            internal_next_sm_sign_a_mode <= '1';
            internal_next_sm_mac_operation_mode <= "00";
            internal_next_mac_enable_reg_s_mask <= '0';
            internal_next_mac_subtraction_reg_a_b <= '0';
            internal_next_mac_sel_multiply_two_a_b <= '0';
            internal_next_mac_sel_reg_y_output <= '0';
            internal_next_sm_mac_write_enable_output <= '1';
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

update_state : process(actual_state, instruction_type, operands_size, instruction_values_valid, prime_line_equal_one, ultimate_instruction, reg_rom_last_state)
begin
case (actual_state) is
        when reset =>
            next_state <= decode_instruction;
        when decode_instruction =>
            next_state <= decode_instruction;
            if(instruction_values_valid = '1') then
                if(instruction_type = "0000") then
                    if(operands_size = "00") then
                        next_state <= multiplication_direct_0;
                    else
                        next_state <= multiplication_direct_2;
                    end if;
                elsif(instruction_type = "0001") then
                    if(operands_size = "00") then
                        next_state <= square_direct_0;
                    else
                        next_state <= square_direct_2;
                    end if;
                elsif(instruction_type = "0010") then
                    if(prime_line_equal_one = '1') then
                        if(operands_size = "00") then
                            next_state <= multiplication_with_reduction_special_prime_0;
                        else
                            next_state <= multiplication_with_reduction_special_prime_3;
                        end if;
                    else
                        if(operands_size = "00") then
                            next_state <= multiplication_with_reduction_0;
                        else
                            next_state <= multiplication_with_reduction_5;
                        end if;
                    end if;
                elsif(instruction_type = "0011") then
                    if(prime_line_equal_one = '1') then
                        if(operands_size = "00") then
                            next_state <= square_with_reduction_special_prime_0;
                        else
                            next_state <= square_with_reduction_special_prime_3;
                        end if;
                    else
                        if(operands_size = "00") then
                            next_state <= square_with_reduction_0;
                        else
                            next_state <= square_with_reduction_5;
                        end if;
                    end if;
                elsif(instruction_type = "0100") then
                    if(operands_size = "00") then
                        next_state <= addition_subtraction_direct_0;
                    else
                        next_state <= addition_subtraction_direct_2;
                    end if;
                elsif(instruction_type = "0101") then
                    if(operands_size = "00") then
                        next_state <= iterative_modular_reduction_0;
                    elsif(operands_size = "01") then
                        next_state <= iterative_modular_reduction_5;
                    elsif(operands_size = "10") then
                        next_state <= iterative_modular_reduction_13;
                    else
                        next_state <= iterative_modular_reduction_24;
                    end if;
                elsif(instruction_type = "0110") then
                    if(operands_size = "00") then
                        next_state <= addition_subtraction_with_reduction_0;
                    else
                        next_state <= addition_subtraction_with_reduction_5;
                    end if;
                end if;
            end if;
        when multiplication_direct_0 =>
            next_state <= multiplication_direct_0;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when multiplication_direct_2 =>
            next_state <= multiplication_direct_2;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when square_direct_0 =>
            next_state <= square_direct_0;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when square_direct_2 =>
            next_state <= square_direct_2;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when multiplication_with_reduction_special_prime_0 =>
            next_state <= multiplication_with_reduction_special_prime_0;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when multiplication_with_reduction_special_prime_3 =>
            next_state <= multiplication_with_reduction_special_prime_3;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when multiplication_with_reduction_0 =>
            next_state <= multiplication_with_reduction_0;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when multiplication_with_reduction_5 =>
            next_state <= multiplication_with_reduction_5;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when square_with_reduction_special_prime_0 =>
            next_state <= square_with_reduction_special_prime_0;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when square_with_reduction_special_prime_3 =>
            next_state <= square_with_reduction_special_prime_3;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when square_with_reduction_0 =>
            next_state <= square_with_reduction_0;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when square_with_reduction_5 =>
            next_state <= square_with_reduction_5;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when addition_subtraction_direct_0 =>
            next_state <= addition_subtraction_direct_0;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when addition_subtraction_direct_2 =>
            next_state <= addition_subtraction_direct_2;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when iterative_modular_reduction_0 =>
            next_state <= iterative_modular_reduction_0;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when iterative_modular_reduction_5 =>
            next_state <= iterative_modular_reduction_5;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when iterative_modular_reduction_13 =>
            next_state <= iterative_modular_reduction_13;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when iterative_modular_reduction_24 =>
            next_state <= iterative_modular_reduction_24;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when addition_subtraction_with_reduction_0 =>
            next_state <= addition_subtraction_with_reduction_0;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when addition_subtraction_with_reduction_5 =>
            next_state <= addition_subtraction_with_reduction_5;
            if(ultimate_instruction = '1') then
                next_state <= instruction_execution;
            end if;
        when instruction_execution =>
            next_state <= instruction_execution;
            if((ultimate_instruction = '1') and (reg_rom_last_state = '1')) then
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
        rom_state_machine_address <= rom_state_machine_next_address;
    end if;
end process;

process(rom_state_machine_address, internal_update_rom_address, internal_sel_load_new_rom_address, instruction_values_valid, instruction_type, operands_size, prime_line_equal_one, penultimate_operation, adder_o)
begin
    if(internal_update_rom_address = '0') then
        rom_state_machine_next_address <= rom_state_machine_address;
    else
        if(internal_sel_load_new_rom_address = '1') then
            if(instruction_values_valid = '1') then
                if(instruction_type = "0000") then
                    if(operands_size = "00") then
                        rom_state_machine_next_address <= first_state_multiplication_direct_operand_size_1;
                    else
                        rom_state_machine_next_address <= first_state_multiplication_direct_operand_size_2_3_4;
                    end if;
                elsif(instruction_type = "0001") then
                    if(operands_size = "00") then
                        rom_state_machine_next_address <= first_state_square_direct_operand_size_1;
                    else
                        rom_state_machine_next_address <= first_state_square_direct_operand_size_2_3_4;
                    end if;
                elsif(instruction_type = "0010") then
                    if(prime_line_equal_one = '1') then
                        if(operands_size = "00") then
                            rom_state_machine_next_address <= first_state_multiplication_with_reduction_special_prime_operand_size_1;
                        else
                            rom_state_machine_next_address <= first_state_multiplication_with_reduction_special_prime_operand_size_2_3_4;
                        end if;
                    else
                        if(operands_size = "00") then
                            rom_state_machine_next_address <= first_state_multiplication_with_reduction_operand_size_1;
                        else
                            rom_state_machine_next_address <= first_state_multiplication_with_reduction_operand_size_2_3_4;
                        end if;
                    end if;
                elsif(instruction_type = "0011") then
                    if(prime_line_equal_one = '1') then
                        if(operands_size = "00") then
                            rom_state_machine_next_address <= first_state_square_with_reduction_special_prime_operand_size_1;
                        else
                            rom_state_machine_next_address <= first_state_square_with_reduction_special_prime_operand_size_2_3_4;
                        end if;
                    else
                        if(operands_size = "00") then
                            rom_state_machine_next_address <= first_state_square_with_reduction_operand_size_1;
                        else
                            rom_state_machine_next_address <= first_state_square_with_reduction_operand_size_2_3_4;
                        end if;
                    end if;
                elsif(instruction_type = "0100") then
                    if(operands_size = "00") then
                        rom_state_machine_next_address <= first_state_addition_subtraction_direct_operand_size_1;
                    else
                        rom_state_machine_next_address <= first_state_addition_subtraction_direct_operand_size_2_3_4;
                    end if;
                elsif(instruction_type = "0101") then
                    if(operands_size = "00") then
                        rom_state_machine_next_address <= first_state_iterative_modular_reduction_operand_size_1;
                    elsif(operands_size = "01") then
                        rom_state_machine_next_address <= first_state_iterative_modular_reduction_operand_size_2;
                    elsif(operands_size = "10") then
                        rom_state_machine_next_address <= first_state_iterative_modular_reduction_operand_size_3;
                    else
                        rom_state_machine_next_address <= first_state_iterative_modular_reduction_operand_size_4;
                    end if;
                elsif(instruction_type = "0110") then
                    if(operands_size = "00") then
                        rom_state_machine_next_address <= first_state_addition_subtraction_with_reduction_operand_size_1;
                    else
                        rom_state_machine_next_address <= first_state_addition_subtraction_with_reduction_operand_size_2_3_4;
                    end if;
                else
                    rom_state_machine_next_address <= rom_state_machine_address;
                end if;
            else
                rom_state_machine_next_address <= rom_state_machine_address;
            end if;
        elsif(penultimate_operation = '1') then
            rom_state_machine_next_address <= std_logic_vector(adder_o);
        else
            rom_state_machine_next_address <= rom_state_machine_address;
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

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstn = '0') then
            reg_rom_last_state <= '0';
        else
            reg_rom_last_state <= rom_last_state;
        end if;
    end if;
end process;

sm_rotation_size <= internal_sm_rotation_size;
sm_circular_shift_enable <= internal_sm_circular_shift_enable;
sel_address_a <= internal_sel_address_a;
sel_address_b_prime <= internal_sel_address_b_prime;
sm_specific_mac_address_a <= internal_sm_specific_mac_address_a;
sm_specific_mac_address_b <= internal_sm_specific_mac_address_b;
sm_specific_mac_address_o <= internal_sm_specific_mac_address_o;
sm_specific_mac_next_address_o <= internal_sm_specific_mac_next_address_o;
mac_enable_signed_a <= internal_mac_enable_signed_a;
mac_enable_signed_b <= internal_mac_enable_signed_b;
mac_sel_load_reg_a <= internal_mac_sel_load_reg_a;
mac_clear_reg_b <= internal_mac_clear_reg_b;
mac_clear_reg_acc <= internal_mac_clear_reg_acc;
mac_sel_shift_reg_o <= internal_mac_sel_shift_reg_o;
mac_enable_update_reg_s <= internal_mac_enable_update_reg_s;
mac_sel_reg_s_reg_o_sign <= internal_mac_sel_reg_s_reg_o_sign;
mac_reg_s_reg_o_positive <= internal_mac_reg_s_reg_o_positive;
sm_sign_a_mode <= internal_sm_sign_a_mode;
sm_mac_operation_mode <= internal_sm_mac_operation_mode;
mac_enable_reg_s_mask <= internal_mac_enable_reg_s_mask;
mac_subtraction_reg_a_b <= internal_mac_subtraction_reg_a_b;
mac_sel_multiply_two_a_b <= internal_mac_sel_multiply_two_a_b;
mac_sel_reg_y_output <= internal_mac_sel_reg_y_output;
sm_mac_write_enable_output <= internal_sm_mac_write_enable_output;
mac_memory_double_mode <= internal_mac_memory_double_mode;
mac_memory_only_write_mode <= internal_mac_memory_only_write_mode;
base_address_generator_o_increment_previous_address <= internal_base_address_generator_o_increment_previous_address;
sm_free_flag <= internal_sm_free_flag;

end compact_memory_based_v3;