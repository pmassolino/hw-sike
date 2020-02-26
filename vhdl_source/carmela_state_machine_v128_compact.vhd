----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

architecture compact_memory_based_v2 of carmela_state_machine_v128 is

type romtype is array(integer range <>) of std_logic_vector(53 downto 0);

constant rom_state_machine_program : romtype(0 to 1370) := (
--  (0) multiplication_direct_0
-- -- In case of size 1
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_X = reg_o; o1_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001000001110000100000010001100100000000000011",
--  (1) multiplication_direct_1
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (2) multiplication_direct_2
-- -- Other cases
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_X = reg_o; operation : a*b + acc; o0_X = reg_o;
"000010100001001000010000100000010000000100000000000011",
--  (3) multiplication_direct_3
-- -- In case of size 2
-- reg_a = a1_X; reg_b = b0_X; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"000000100001001000000000100000100000101000100000100011",
--  (4) multiplication_direct_4
-- reg_a = a0_X; reg_b = b1_X; reg_acc = reg_o; o1_X = reg_o; Enable sign b; operation : a*b + acc;
"000000100001001000010000100000000001001000100100000011",
--  (5) multiplication_direct_5
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o >> 272; o2_X = reg_o; o3_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001001001110000100000100000001101000100100011",
--  (6) multiplication_direct_6
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (7) multiplication_direct_7
-- -- Other cases
-- reg_a = a1_X; reg_b = b0_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001010000000000100000100000001000100000100011",
--  (8) multiplication_direct_8
-- reg_a = a0_X; reg_b = b1_X; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001010000010000100000000000001000100100000011",
--  (9) multiplication_direct_9
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000011100001010000000000100000100000001101000100100011",
--  (10) multiplication_direct_10
-- -- In case of size 3
-- reg_a = a0_X; reg_b = b2_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001010000000000100000000001001101001000000011",
--  (11) multiplication_direct_11
-- reg_a = a2_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; o2_X = reg_o; operation : a*b + acc;
"000000100001010000010000100000000000101101000001000011",
--  (12) multiplication_direct_12
-- reg_a = a2_X; reg_b = b1_X; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"000000100001010000000000100000100000110001100101000011",
--  (13) multiplication_direct_13
-- reg_a = a1_X; reg_b = b2_X; reg_acc = reg_o; o3_X = reg_o; Enable sign b; operation : a*b + acc;
"000000100001010000010000100000000001010001101000100011",
--  (14) multiplication_direct_14
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o >> 272; o4_X = reg_o; o5_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001010001110000100000100001110110001001000011",
--  (15) multiplication_direct_15
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (16) multiplication_direct_16
-- -- Other cases
-- reg_a = a0_0; reg_b = b2_0; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000001101001000000011",
--  (17) multiplication_direct_17
-- reg_a = a2_X; reg_b = b0_X; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001011000010000100000000000001101000001000011",
--  (18) multiplication_direct_18
-- reg_a = a2_X; reg_b = b1_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001011000000000100000100000010001100101000011",
--  (19) multiplication_direct_19
-- reg_a = a1_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000101000001011000000000100000000000010001101000100011",
--  (20) multiplication_direct_20
-- -- In case of size 4
-- reg_a = a3_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001011000000000100000000000110001100001100011",
--  (21) multiplication_direct_21
-- reg_a = a0_X; reg_b = b3_X; reg_acc = reg_o; o3_X = reg_o; Enable sign b; operation : a*b + acc;
"000000100001011000010000100000000001010001101100000011",
--  (22) multiplication_direct_22
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001011000000000100000100000010110001001000011",
--  (23) multiplication_direct_23
-- reg_a = a3_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001011000000000100000000000110110000101100011",
--  (24) multiplication_direct_24
-- reg_a = a1_X; reg_b = b3_X; reg_acc = reg_o; o4_X = reg_o; Enable sign b; operation : a*b + acc;
"000000100001011000010000100000000001010110001100100011",
--  (25) multiplication_direct_25
-- reg_a = a3_X; reg_b = b2_X; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"000000100001011000000000100000100000111010101001100011",
--  (26) multiplication_direct_26
-- reg_a = a2_X; reg_b = b3_X; reg_acc = reg_o; o5_X = reg_o; Enable sign b; operation : a*b + acc;
"000000100001011000010000100000000001011010101101000011",
--  (27) multiplication_direct_27
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o >> 272; o6_X = reg_o; o7_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001011001110000100000100001111111001101100011",
--  (28) multiplication_direct_28
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (29) multiplication_direct_29
-- -- Other cases
-- reg_a = a3_X; reg_b = b0_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000010001100001100011",
--  (30) multiplication_direct_30
-- reg_a = a0_X; reg_b = b3_X; reg_acc = reg_o; o3_0 = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000010001101100000011",
--  (31) multiplication_direct_31
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000010110001001000011",
--  (32) multiplication_direct_32
-- reg_a = a3_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000010110000101100011",
--  (33) multiplication_direct_33
-- reg_a = a1_X; reg_b = b3_X; reg_acc = reg_o; o4_0 = reg_o; operation : a*b + acc;
"000111000001100000010000100000000000010110001100100011",
--  (34) multiplication_direct_34
-- -- In case of size 5
-- reg_a = a4_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001100000000000100000000000110110000010000011",
--  (35) multiplication_direct_35
-- reg_a = a0_X; reg_b = b4_X; reg_acc = reg_o; o4_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001100000010000100000000001010110010000000011",
--  (36) multiplication_direct_36
-- reg_a = a3_X; reg_b = b2_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000011010101001100011",
--  (37) multiplication_direct_37
-- reg_a = a2_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000011010101101000011",
--  (38) multiplication_direct_38
-- reg_a = a4_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001100000000000100000000000111010100110000011",
--  (39) multiplication_direct_39
-- reg_a = a1_X; reg_b = b4_X; reg_acc = reg_o; o5_X = reg_o; Enable sign b; operation : a*b + acc;
"000000100001100000010000100000000001011010110000100011",
--  (40) multiplication_direct_40
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000011111001101100011",
--  (41) multiplication_direct_41
-- reg_a = a4_X; reg_b = b2_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001100000000000100000000000111111001010000011",
--  (42) multiplication_direct_42
-- reg_a = a2_X; reg_b = b4_X; reg_acc = reg_o; o6_X = reg_o; Enable sign b; operation : a*b + acc;
"000000100001100000010000100000000001011111010001000011",
--  (43) multiplication_direct_43
-- reg_a = a4_X; reg_b = b3_X; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"000000100001100000000000100000100000100011101110000011",
--  (44) multiplication_direct_44
-- reg_a = a3_X; reg_b = b4_X; reg_acc = reg_o; o7_X = reg_o; Enable sign b; operation : a*b + acc; Increment base address o;
"000000100001100010010000100000000001000011110001100011",
--  (45) multiplication_direct_45
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o >> 272; o8_X = reg_o; o9_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001100001110000100000100001100100010010000011",
--  (46) multiplication_direct_46
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (47) multiplication_direct_47
-- -- Other cases
-- reg_a = a4_X; reg_b = b0_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000010110000010000011",
--  (48) multiplication_direct_48
-- reg_a = a0_X; reg_b = b4_X; reg_acc = reg_o; o4_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000010110010000000011",
--  (49) multiplication_direct_49
-- reg_a = a3_X; reg_b = b2_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001101000000000100000100000011010101001100011",
--  (50) multiplication_direct_50
-- reg_a = a2_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000011010101101000011",
--  (51) multiplication_direct_51
-- reg_a = a4_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000011010100110000011",
--  (52) multiplication_direct_52
-- reg_a = a1_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"001001100001101000000000100000000000011010110000100011",
--  (53) multiplication_direct_53
-- -- In case of size 6
-- reg_a = a5_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000000000111010100010100011",
--  (54) multiplication_direct_54
-- reg_a = a0_X; reg_b = b5_X; reg_acc = reg_o; o5_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001101000010000100000000001011010110100000011",
--  (55) multiplication_direct_55
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001101000000000100000100000011111001101100011",
--  (56) multiplication_direct_56
-- reg_a = a2_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000011111010001000011",
--  (57) multiplication_direct_57
-- reg_a = a4_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000011111001010000011",
--  (58) multiplication_direct_58
-- reg_a = a5_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000000000111111000110100011",
--  (59) multiplication_direct_59
-- reg_a = a1_X; reg_b = b5_X; reg_acc = reg_o; o6_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001101000010000100000000001011111010100100011",
--  (60) multiplication_direct_60
-- reg_a = a4_X; reg_b = b3_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001101000000000100000100000000011101110000011",
--  (61) multiplication_direct_61
-- reg_a = a3_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000011110001100011",
--  (62) multiplication_direct_62
-- reg_a = a5_X; reg_b = b2_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000000000100011101010100011",
--  (63) multiplication_direct_63
-- reg_a = a2_X; reg_b = b5_X; reg_acc = reg_o; o7_0 = reg_o; Enable sign b; operation : a*b + acc; Increment base address o;
"000000100001101010010000100000000001000011110101000011",
--  (64) multiplication_direct_64
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001101000000000100000100000000100010010000011",
--  (65) multiplication_direct_65
-- reg_a = a5_X; reg_b = b3_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000000000100100001110100011",
--  (66) multiplication_direct_66
-- reg_a = a3_X; reg_b = b5_X; reg_acc = reg_o; o8_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001101000010000100000000001000100010101100011",
--  (67) multiplication_direct_67
-- reg_a = a5_X; reg_b = b4_X; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000100000101000110010100011",
--  (68) multiplication_direct_68
-- reg_a = a4_X; reg_b = b5_X; reg_acc = reg_o; o9_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001101000010000100000000001001000110110000011",
--  (69) multiplication_direct_69
-- reg_a = a5_X; reg_b = b5_X; reg_acc = reg_o >> 272; o10_X = reg_o; o11_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001101001110000100000100001101101010110100011",
--  (70) multiplication_direct_70
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (71) multiplication_direct_71
-- -- Other cases
-- reg_a = a5_X; reg_b = b0_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000011010100010100011",
--  (72) multiplication_direct_72
-- reg_a = a0_X; reg_b = b5_X; reg_acc = reg_o; o5_0 = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000011010110100000011",
--  (73) multiplication_direct_73
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000011111001101100011",
--  (74) multiplication_direct_74
-- reg_a = a4_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000011111001010000011",
--  (75) multiplication_direct_75
-- reg_a = a2_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000011111010001000011",
--  (76) multiplication_direct_76
-- reg_a = a5_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000011111000110100011",
--  (77) multiplication_direct_77
-- reg_a = a1_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"001100100001110000000000100000000000011111010100100011",
--  (78) multiplication_direct_78
-- -- In case of size 7
-- reg_a = a6_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000111111000011000011",
--  (79) multiplication_direct_79
-- reg_a = a0_X; reg_b = b6_X; reg_acc = reg_o; o6_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001110000010000100000000001011111011000000011",
--  (80) multiplication_direct_80
-- reg_a = a4_X; reg_b = b3_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000011101110000011",
--  (81) multiplication_direct_81
-- reg_a = a3_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000011110001100011",
--  (82) multiplication_direct_82
-- reg_a = a5_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000011101010100011",
--  (83) multiplication_direct_83
-- reg_a = a2_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000011110101000011",
--  (84) multiplication_direct_84
-- reg_a = a6_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000100011100111000011",
--  (85) multiplication_direct_85
-- reg_a = a1_X; reg_b = b6_X; reg_acc = reg_o; o7_0 = reg_o; Enable sign b; operation : a*b + acc; Increment base address o;
"000000100001110010010000100000000001000011111000100011",
--  (86) multiplication_direct_86
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100010010000011",
--  (87) multiplication_direct_87
-- reg_a = a5_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001110100011",
--  (88) multiplication_direct_88
-- reg_a = a3_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101100011",
--  (89) multiplication_direct_89
-- reg_a = a6_X; reg_b = b2_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000100100001011000011",
--  (90) multiplication_direct_90
-- reg_a = a2_X; reg_b = b6_X; reg_acc = reg_o; o8_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001110000010000100000000001000100011001000011",
--  (91) multiplication_direct_91
-- reg_a = a5_X; reg_b = b4_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000001000110010100011",
--  (92) multiplication_direct_92
-- reg_a = a4_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000001000110110000011",
--  (93) multiplication_direct_93
-- reg_a = a6_X; reg_b = b3_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000101000101111000011",
--  (94) multiplication_direct_94
-- reg_a = a3_X; reg_b = b6_X; reg_acc = reg_o; o9_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001110000010000100000000001001000111001100011",
--  (95) multiplication_direct_95
-- reg_a = a5_X; reg_b = b5_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000001101010110100011",
--  (96) multiplication_direct_96
-- reg_a = a6_X; reg_b = b4_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000101101010011000011",
--  (97) multiplication_direct_97
-- reg_a = a4_X; reg_b = b6_X; reg_acc = reg_o; o10_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001110000010000100000000001001101011010000011",
--  (98) multiplication_direct_98
-- reg_a = a6_X; reg_b = b5_X; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000100000110001110111000011",
--  (99) multiplication_direct_99
-- reg_a = a5_X; reg_b = b6_X; reg_acc = reg_o; o11_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001110000010000100000000001010001111010100011",
--  (100) multiplication_direct_100
-- reg_a = a6_X; reg_b = b6_X; reg_acc = reg_o >> 272; o12_X = reg_o; o13_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001110001110000100000100001110110011011000011",
--  (101) multiplication_direct_101
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (102) multiplication_direct_102
-- -- In case of size 8
-- reg_a = a6_X; reg_b = b0_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000011111000011000011",
--  (103) multiplication_direct_103
-- reg_a = a0_X; reg_b = b6_X; reg_acc = reg_o; o6_0 = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000011111011000000011",
--  (104) multiplication_direct_104
-- reg_a = a4_X; reg_b = b3_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000000011101110000011",
--  (105) multiplication_direct_105
-- reg_a = a3_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000011110001100011",
--  (106) multiplication_direct_106
-- reg_a = a5_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000011101010100011",
--  (107) multiplication_direct_107
-- reg_a = a2_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000011110101000011",
--  (108) multiplication_direct_108
-- reg_a = a6_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000011100111000011",
--  (109) multiplication_direct_109
-- reg_a = a1_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000011111000100011",
--  (110) multiplication_direct_110
-- reg_a = a7_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100011100011100011",
--  (111) multiplication_direct_111
-- reg_a = a0_X; reg_b = b7_X; reg_acc = reg_o; o7_0 = reg_o; Enable sign b; operation : a*b + acc; Increment base address o;
"000000100001111010010000100000000001000011111100000011",
--  (112) multiplication_direct_112
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000000100010010000011",
--  (113) multiplication_direct_113
-- reg_a = a5_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001110100011",
--  (114) multiplication_direct_114
-- reg_a = a3_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101100011",
--  (115) multiplication_direct_115
-- reg_a = a6_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001011000011",
--  (116) multiplication_direct_116
-- reg_a = a2_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001000011",
--  (117) multiplication_direct_117
-- reg_a = a7_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100100000111100011",
--  (118) multiplication_direct_118
-- reg_a = a1_X; reg_b = b7_X; reg_acc = reg_o; o8_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001111000010000100000000001000100011100100011",
--  (119) multiplication_direct_119
-- reg_a = a5_X; reg_b = b4_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000001000110010100011",
--  (120) multiplication_direct_120
-- reg_a = a4_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000001000110110000011",
--  (121) multiplication_direct_121
-- reg_a = a6_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000001000101111000011",
--  (122) multiplication_direct_122
-- reg_a = a3_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000001000111001100011",
--  (123) multiplication_direct_123
-- reg_a = a7_X; reg_b = b2_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000101000101011100011",
--  (124) multiplication_direct_124
-- reg_a = a2_X; reg_b = b7_X; reg_acc = reg_o; o9_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001111000010000100000000001001000111101000011",
--  (125) multiplication_direct_125
-- reg_a = a5_X; reg_b = b5_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000001101010110100011",
--  (126) multiplication_direct_126
-- reg_a = a6_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000001101010011000011",
--  (127) multiplication_direct_127
-- reg_a = a4_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000001101011010000011",
--  (128) multiplication_direct_128
-- reg_a = a7_X; reg_b = b3_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000101101001111100011",
--  (129) multiplication_direct_129
-- reg_a = a3_X; reg_b = b7_X; reg_acc = reg_o; o10_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001111000010000100000000001001101011101100011",
--  (130) multiplication_direct_130
-- reg_a = a6_X; reg_b = b5_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000010001110111000011",
--  (131) multiplication_direct_131
-- reg_a = a5_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000010001111010100011",
--  (132) multiplication_direct_132
-- reg_a = a7_X; reg_b = b4_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000110001110011100011",
--  (133) multiplication_direct_133
-- reg_a = a4_X; reg_b = b7_X; reg_acc = reg_o; o11_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001111000010000100000000001010001111110000011",
--  (134) multiplication_direct_134
-- reg_a = a6_X; reg_b = b6_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000010110011011000011",
--  (135) multiplication_direct_135
-- reg_a = a7_X; reg_b = b5_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000110110010111100011",
--  (136) multiplication_direct_136
-- reg_a = a5_X; reg_b = b7_X; reg_acc = reg_o; o12_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001111000010000100000000001010110011110100011",
--  (137) multiplication_direct_137
-- reg_a = a7_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000100000111010111011100011",
--  (138) multiplication_direct_138
-- reg_a = a6_X; reg_b = b7_X; reg_acc = reg_o; o13_0 = reg_o; Enable sign b; operation : a*b + acc;
"000000100001111000010000100000000001011010111111000011",
--  (139) multiplication_direct_139
-- reg_a = a7_X; reg_b = b7_X; reg_acc = reg_o >> 272; o14_X = reg_o; o15_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001111001110000100000100001111111011111100011",
--  (140) multiplication_direct_140
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (141) square_direct_0
-- -- In case of size 1
-- reg_a = a0_X; reg_b = a0_X; reg_acc = 0; o0_X = reg_o; o1_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001000001110000100000010001100100000000000011",
--  (142) square_direct_1
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (143) square_direct_2
-- -- In case of sizes 2, 3, 4, 5, 6, 7, 8
-- reg_a = a0_X; reg_b = a0_X; reg_acc = 0; o0_X = reg_o; operation : a*b + acc;
"000010000001001000010000100000010000000100000000000011",
--  (144) square_direct_3
-- -- In case of size 2
-- reg_a = a1_X; reg_b = a0_X; reg_acc = reg_o >> 272; o1_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001001000010100100000100000101000100000100011",
--  (145) square_direct_4
-- reg_a = a1_X; reg_b = a1_X; reg_acc = reg_o >> 272; o2_X = reg_o; o3_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001001001110000100000100001101101000100100011",
--  (146) square_direct_5
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (147) square_direct_6
-- -- Other cases
-- reg_a = a1_X; reg_b = a0_X; reg_acc = reg_o >> 272; o1_X = reg_o; operation : 2*a*b + acc;
"000000100001010000010100100000100000001000100000100011",
--  (148) square_direct_7
-- reg_a = a1_X; reg_b = a1_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000010100001010000000000100000100000001101000100100011",
--  (149) square_direct_8
-- -- In case of size 3
-- reg_a = a0_X; reg_b = a2_X; reg_acc = reg_o; o2_X = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001010000010100100000000001001101001000000011",
--  (150) square_direct_9
-- reg_a = a2_X; reg_b = a1_X; reg_acc = reg_o >> 272; o3_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001010000010100100000100000110001100101000011",
--  (151) square_direct_10
-- reg_a = a2_X; reg_b = a2_X; reg_acc = reg_o >> 272; o4_X = reg_o; o5_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001010001110000100000100001110110001001000011",
--  (152) square_direct_11
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (153) square_direct_12
-- -- Other cases
-- reg_a = a0_X; reg_b = a2_X; reg_acc = reg_o; o2_X = reg_o; operation : 2*a*b + acc;
"000000100001011000010100100000000000001101001000000011",
--  (154) square_direct_13
-- reg_a = a2_X; reg_b = a1_X; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"000011100001011000000100100000100000010001100101000011",
--  (155) square_direct_14
-- -- In case of size 4
-- reg_a = a3_X; reg_b = a0_X; reg_acc = reg_o; o3_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001011000010100100000000000110001100001100011",
--  (156) square_direct_15
-- reg_a = a2_X; reg_b = a2_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001011000000000100000100000010110001001000011",
--  (157) square_direct_16
-- reg_a = a3_X; reg_b = a1_X; reg_acc = reg_o; o4_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001011000010100100000000000110110000101100011",
--  (158) square_direct_17
-- reg_a = a3_X; reg_b = a2_X; reg_acc = reg_o >> 272; o5_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001011000010100100000100000111010101001100011",
--  (159) square_direct_18
-- reg_a = a3_X; reg_b = a3_X; reg_acc = reg_o >> 272; o6_X = reg_o; o7_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001011001110000100000100001111111001101100011",
--  (160) square_direct_19
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (161) square_direct_20
-- -- Other cases
-- reg_a = a3_X; reg_b = a0_X; reg_acc = reg_o; o3_X = reg_o; operation : 2*a*b + acc;
"000000100001100000010100100000000000010001100001100011",
--  (162) square_direct_21
-- reg_a = a2_X; reg_b = a2_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000010110001001000011",
--  (163) square_direct_22
-- reg_a = a3_X; reg_b = a1_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000100100001100000000100100000000000010110000101100011",
--  (164) square_direct_23
-- -- In case of size 5
-- reg_a = a4_X; reg_b = a0_X; reg_acc = reg_o; o4_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001100000010100100000000000110110000010000011",
--  (165) square_direct_24
-- reg_a = a3_X; reg_b = a2_X; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"000000100001100000000100100000100000011010101001100011",
--  (166) square_direct_25
-- reg_a = a4_X; reg_b = a1_X; reg_acc = reg_o; o5_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001100000010100100000000000111010100110000011",
--  (167) square_direct_26
-- reg_a = a3_X; reg_b = a3_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000011111011011000011",
--  (168) square_direct_27
-- reg_a = a4_X; reg_b = a2_X; reg_acc = reg_o; o6_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001100000010100100000000000111111001010000011",
--  (169) square_direct_28
-- reg_a = a4_X; reg_b = a3_X; reg_acc = reg_o >> 272; o7_X = reg_o; Enable sign a; operation : 2*a*b + acc; Increase base address o;
"000000100001100010010100100000100000100011101110000011",
--  (170) square_direct_29
-- reg_a = a4_X; reg_b = a4_X; reg_acc = reg_o >> 272; o8_X = reg_o; o9_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001100001110000100000100001100100010010000011",
--  (171) square_direct_30
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (172) square_direct_31
-- -- Other cases
-- reg_a = a4_X; reg_b = a0_X; reg_acc = reg_o; o4_X = reg_o; operation : 2*a*b + acc;
"000000100001101000010100100000000000010110000010000011",
--  (173) square_direct_32
-- reg_a = a3_X; reg_b = a2_X; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"000000100001101000000100100000100000010110001001100011",
--  (174) square_direct_33
-- reg_a = a4_X; reg_b = a1_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000110000001101000000100100000000000011010100110000011",
--  (175) square_direct_34
-- -- In case of size 6
-- reg_a = a5_X; reg_b = a0_X; reg_acc = reg_o; o5_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001101000010100100000000000111010100010100011",
--  (176) square_direct_35
-- reg_a = a3_X; reg_b = a3_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001101000000000100000100000011111001101100011",
--  (177) square_direct_36
-- reg_a = a4_X; reg_b = a2_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001101000000100100000000000011111001010000011",
--  (178) square_direct_37
-- reg_a = a5_X; reg_b = a1_X; reg_acc = reg_o; o6_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001101000010100100000000000111011000110100011",
--  (179) square_direct_38
-- reg_a = a4_X; reg_b = a3_X; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"000000100001101000000100100000100000000011101110000011",
--  (180) square_direct_39
-- reg_a = a5_X; reg_b = a2_X; reg_acc = reg_o; o7_X = reg_o; Enable sign a; operation : 2*a*b + acc; Increase base address o;
"000000100001101010010100100000000000100011101010100011",
--  (181) square_direct_40
-- reg_a = a4_X; reg_b = a4_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001101000000000100000100000000100010010000011",
--  (182) square_direct_41
-- reg_a = a5_X; reg_b = a3_X; reg_acc = reg_o; o8_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001101000010100100000000000100100001110100011",
--  (183) square_direct_42
-- reg_a = a5_X; reg_b = a4_X; reg_acc = reg_o >> 272; o9_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001101000010100100000100000101000110010100011",
--  (184) square_direct_43
-- reg_a = a5_X; reg_b = a5_X; reg_acc = reg_o >> 272; o10_X = reg_o; o11_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001101001110000100000100001101101010110100011",
--  (185) square_direct_44
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (186) square_direct_45
-- -- Other cases
-- reg_a = a5_X; reg_b = a0_X; reg_acc = reg_o; o5_X = reg_o; operation : 2*a*b + acc;
"000000100001110000010100100000000000011010100010100011",
--  (187) square_direct_46
-- reg_a = a3_X; reg_b = a3_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000011111001101100011",
--  (188) square_direct_47
-- reg_a = a4_X; reg_b = a2_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000011111001010000011",
--  (189) square_direct_48
-- reg_a = a5_X; reg_b = a1_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000111100001110000000100100000000000011111000110100011",
--  (190) square_direct_49
-- -- In case of size 7
-- reg_a = a6_X; reg_b = a0_X; reg_acc = reg_o; o6_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001110000010100100000000000111111000011000011",
--  (191) square_direct_50
-- reg_a = a4_X; reg_b = a3_X; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"000000100001110000000100100000100000000011101110000011",
--  (192) square_direct_51
-- reg_a = a5_X; reg_b = a2_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000011101010100011",
--  (193) square_direct_52
-- reg_a = a6_X; reg_b = a1_X; reg_acc = reg_o; o7_X = reg_o; Enable sign a; operation : 2*a*b + acc; Increase base address o;
"000000100001110010010100100000000000100011100111000011",
--  (194) square_direct_53
-- reg_a = a4_X; reg_b = a4_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100010010000011",
--  (195) square_direct_54
-- reg_a = a5_X; reg_b = a3_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100001110100011",
--  (196) square_direct_55
-- reg_a = a6_X; reg_b = a2_X; reg_acc = reg_o; o8_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001110000010100100000000000100100001011000011",
--  (197) square_direct_56
-- reg_a = a5_X; reg_b = a4_X; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"000000100001110000000100100000100000001000110010100011",
--  (198) square_direct_57
-- reg_a = a6_X; reg_b = a3_X; reg_acc = reg_o; o9_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001110000010100100000000000101000101111000011",
--  (199) square_direct_58
-- reg_a = a5_X; reg_b = a5_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000001101010110100011",
--  (200) square_direct_59
-- reg_a = a6_X; reg_b = a4_X; reg_acc = reg_o; o10_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001110000010100100000000000101101010011000011",
--  (201) square_direct_60
-- reg_a = a6_X; reg_b = a5_X; reg_acc = reg_o >> 272; o11_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001110000010100100000100000110001110111000011",
--  (202) square_direct_61
-- reg_a = a6_X; reg_b = a6_X; reg_acc = reg_o >> 272; o12_X = reg_o; o13_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001110001110000100000100001110110011011000011",
--  (203) square_direct_62
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (204) square_direct_63
-- -- In case of size 8
-- reg_a = a6_X; reg_b = a0_X; reg_acc = reg_o; o6_X = reg_o; operation : 2*a*b + acc;
"000000100001111000010100100000000000011111000011000011",
--  (205) square_direct_64
-- reg_a = a4_X; reg_b = a3_X; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"000000100001111000000100100000100000000011101110000011",
--  (206) square_direct_65
-- reg_a = a5_X; reg_b = a2_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000011101010100011",
--  (207) square_direct_66
-- reg_a = a6_X; reg_b = a1_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000011100111000011",
--  (208) square_direct_67
-- reg_a = a7_X; reg_b = a0_X; reg_acc = reg_o; o7_X = reg_o; Enable sign a; operation : 2*a*b + acc; Increase base address o;
"000000100001111010010100100000000000100011100011100011",
--  (209) square_direct_68
-- reg_a = a4_X; reg_b = a4_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000000100010010000011",
--  (210) square_direct_69
-- reg_a = a5_X; reg_b = a3_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100001110100011",
--  (211) square_direct_70
-- reg_a = a6_X; reg_b = a2_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100001011000011",
--  (212) square_direct_71
-- reg_a = a7_X; reg_b = a1_X; reg_acc = reg_o; o8_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001111000010100100000000000100100000111100011",
--  (213) square_direct_72
-- reg_a = a5_X; reg_b = a4_X; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"000000100001111000000100100000100000001000110010100011",
--  (214) square_direct_73
-- reg_a = a6_X; reg_b = a3_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000001000101111000011",
--  (215) square_direct_74
-- reg_a = a7_X; reg_b = a2_X; reg_acc = reg_o; o9_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001111000010100100000000000101000101011100011",
--  (216) square_direct_75
-- reg_a = a5_X; reg_b = a5_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000001101010110100011",
--  (217) square_direct_76
-- reg_a = a6_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000001101010011000011",
--  (218) square_direct_77
-- reg_a = a7_X; reg_b = a3_X; reg_acc = reg_o; o10_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001111000010100100000000000101101001111100011",
--  (219) square_direct_78
-- reg_a = a6_X; reg_b = a5_X; reg_acc = reg_o >> 272; operation : 2*a*b + acc;
"000000100001111000000100100000100000010001110111000011",
--  (220) square_direct_79
-- reg_a = a7_X; reg_b = a4_X; reg_acc = reg_o; o11_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001111000010100100000000000110001110011100011",
--  (221) square_direct_80
-- reg_a = a6_X; reg_b = a6_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000010110011011000011",
--  (222) square_direct_81
-- reg_a = a7_X; reg_b = a5_X; reg_acc = reg_o; o12_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001111000010100100000000000110110010111100011",
--  (223) square_direct_82
-- reg_a = a7_X; reg_b = a6_X; reg_acc = reg_o >> 272; o13_X = reg_o; Enable sign a; operation : 2*a*b + acc;
"000000100001111000010100100000100000111010111011100011",
--  (224) square_direct_83
-- reg_a = a7_X; reg_b = a7_X; reg_acc = reg_o >> 272; o14_X = reg_o; o15_X = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001111001110000100000100001111111011111100011",
--  (225) square_direct_84
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (226) multiplication_with_reduction_0
-- -- In case of size 1
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"000000100001000000000000100000010001100100000000000011",
--  (227) multiplication_with_reduction_1
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_X = reg_y; operation : keep accumulator;
"000000100001000000011000110000000100000100000000011011",
--  (228) multiplication_with_reduction_2
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001000000000000100000000010000100000000010011",
--  (229) multiplication_with_reduction_3
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 272; o0_X = reg_o; operation : a*b + acc;
"000000100001000000010000100000101110000100000000000011",
--  (230) multiplication_with_reduction_4
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (231) multiplication_with_reduction_5
-- -- In case of sizes 2, 3, 4, 5, 6, 7, 8
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; operation : a*b + acc;
"000000100001001000000000100000010000000100000000000011",
--  (232) multiplication_with_reduction_6
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_X = reg_y; operation : keep accumulator;
"000000100001001000011000110000000100000100000000011011",
--  (233) multiplication_with_reduction_7
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001001000000000100000000010000100000000010011",
--  (234) multiplication_with_reduction_8
--reg_a = o0_X; reg_b = prime1; reg_acc = reg_o >> 272; operation : a*b + acc;
"000100000001001000000000100000100000000100000100010111",
--  (235) multiplication_with_reduction_9
-- -- In case of size 2
-- reg_a = a0_X; reg_b = b1_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001001000000000100000000001000100000100000011",
--  (236) multiplication_with_reduction_10
-- reg_a = a1_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001001000000000100000000000100100000000100011",
--  (237) multiplication_with_reduction_11
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_X = reg_y; operation : keep accumulator;
"000000100001001000011000110000000100001000100000011011",
--  (238) multiplication_with_reduction_12
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001001000000000100000000010000100000000010011",
--  (239) multiplication_with_reduction_13
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001001000000000100000100001100100000100100011",
--  (240) multiplication_with_reduction_14
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; o1_X = reg_o >> 272; operation : a*b + acc;
"000000100001001001110000100000000000000100000100110111",
--  (241) multiplication_with_reduction_15
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (242) multiplication_with_reduction_16
-- -- Other cases
-- reg_a = a0_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000000000100000100000011",
--  (243) multiplication_with_reduction_17
-- reg_a = a1_X; reg_b = b0_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000000000100000000100011",
--  (244) multiplication_with_reduction_18
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_X = reg_y; operation : keep accumulator;
"000000100001010000011000110000000100001000100000011011",
--  (245) multiplication_with_reduction_19
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000010000100000000010011",
--  (246) multiplication_with_reduction_20
-- reg_a = o0_X; reg_b = prime2; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001010000000000100000100000000100001000010111",
--  (247) multiplication_with_reduction_21
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000000000100000100100011",
--  (248) multiplication_with_reduction_22
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"000110000001010000000000100000000000000100000100110111",
--  (249) multiplication_with_reduction_23
-- -- In case of size 3
-- reg_a = a0_X; reg_b = b2_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001010000000000100000000001000100001000000011",
--  (250) multiplication_with_reduction_24
-- reg_a = a2_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001010000000000100000000000100100000001000011",
--  (251) multiplication_with_reduction_25
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_X = reg_y; operation : keep accumulator;
"000000100001010000011000110000000100001101000000011011",
--  (252) multiplication_with_reduction_26
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000010000100000000010011",
--  (253) multiplication_with_reduction_27
-- reg_a = a1_X; reg_b = b2_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001010000000000100000100001000100001000100011",
--  (254) multiplication_with_reduction_28
-- reg_a = o1_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000000000100001000110111",
--  (255) multiplication_with_reduction_29
-- reg_a = a2_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001010000000000100000000000100100000101000011",
--  (256) multiplication_with_reduction_30
-- reg_a = o2_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001010000010000100000000000000100000101010111",
--  (257) multiplication_with_reduction_31
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o >> 272; Enable sign a, b; operation : a*b + acc;
"000000100001010000000000100000100001100100001001000011",
--  (258) multiplication_with_reduction_32
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o; o1_X = reg_o; o2_X = reg_o >> 272; operation : a*b + acc;
"000000100001010001110000100000000000001000101001010111",
--  (259) multiplication_with_reduction_33
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (260) multiplication_with_reduction_34
-- -- Other cases
-- reg_a = a0_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001000000011",
--  (261) multiplication_with_reduction_35
-- reg_a = a2_X; reg_b = b0_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100000001000011",
--  (262) multiplication_with_reduction_36
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_X = reg_y; operation : keep accumulator;
"000000100001011000011000110000000100001101000000011011",
--  (263) multiplication_with_reduction_37
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000010000100000000010011",
--  (264) multiplication_with_reduction_38
-- reg_a = o0_X; reg_b = prime3; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001011000000000100000100000000100001100010111",
--  (265) multiplication_with_reduction_39
-- reg_a = a1_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001000100011",
--  (266) multiplication_with_reduction_40
-- reg_a = o1_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001000110111",
--  (267) multiplication_with_reduction_41
-- reg_a = a2_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100000101000011",
--  (268) multiplication_with_reduction_42
-- reg_a = o2_X; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"001001000001011000000000100000000000000100000101010111",
--  (269) multiplication_with_reduction_43
-- -- In case of size 4
-- reg_a = a0_X; reg_b = b3_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001011000000000100000000001000100001100000011",
--  (270) multiplication_with_reduction_44
-- reg_a = a3_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001011000000000100000000000100100000001100011",
--  (271) multiplication_with_reduction_45
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o3_X = reg_y; operation : keep accumulator;
"000000100001011000011000110000000100000001100000011011",
--  (272) multiplication_with_reduction_46
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000010000100000000010011",
--  (273) multiplication_with_reduction_47
-- reg_a = a1_X; reg_b = b3_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001011000000000100000100001000100001100100011",
--  (274) multiplication_with_reduction_48
-- reg_a = o1_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001100110111",
--  (275) multiplication_with_reduction_49
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001001000011",
--  (276) multiplication_with_reduction_50
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001001010111",
--  (277) multiplication_with_reduction_51
-- reg_a = a3_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001011000000000100000000000100100000101100011",
--  (278) multiplication_with_reduction_52
-- reg_a = o3_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001011000010000100000000000000100000101110111",
--  (279) multiplication_with_reduction_53
-- reg_a = a2_X; reg_b = b3_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001011000000000100000100001000100001101000011",
--  (280) multiplication_with_reduction_54
-- reg_a = o2_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001101010111",
--  (281) multiplication_with_reduction_55
-- reg_a = a3_X; reg_b = b2_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001011000000000100000000000100100001001100011",
--  (282) multiplication_with_reduction_56
-- reg_a = o3_X; reg_b = prime2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001011000010000100000000000001000101001110111",
--  (283) multiplication_with_reduction_57
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o >> 272; Enable sign a, b; operation : a*b + acc;
"000000100001011000000000100000100001100100001101100011",
--  (284) multiplication_with_reduction_58
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o; o2_X = reg_o; o3_0 = reg_o >> 272; operation : a*b + acc;
"000000100001011001110000100000000000001101001101110111",
--  (285) multiplication_with_reduction_59
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (286) multiplication_with_reduction_60
-- -- Other cases
-- reg_a = a0_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001100000011",
--  (287) multiplication_with_reduction_61
-- reg_a = a3_X; reg_b = b0_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100000001100011",
--  (288) multiplication_with_reduction_62
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o3_X = reg_y; operation : keep accumulator;
"000000100001100000011000110000000100010001100000011011",
--  (289) multiplication_with_reduction_63
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000010000100000000010011",
--  (290) multiplication_with_reduction_64
-- reg_a = o0_X; reg_b = prime4; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000000100010000010111",
--  (291) multiplication_with_reduction_65
-- reg_a = a1_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001100100011",
--  (292) multiplication_with_reduction_66
-- reg_a = o1_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001100110111",
--  (293) multiplication_with_reduction_67
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001001000011",
--  (294) multiplication_with_reduction_68
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001001010111",
--  (295) multiplication_with_reduction_69
-- reg_a = a3_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100000101100011",
--  (296) multiplication_with_reduction_70
-- reg_a = o3_X; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"001101000001100000000000100000000000000100000101110111",
--  (297) multiplication_with_reduction_71
-- -- In case of size 5
-- reg_a = a0_X; reg_b = b4_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001100000000000100000000001000100010000000011",
--  (298) multiplication_with_reduction_72
-- reg_a = a4_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001100000000000100000000000100100000010000011",
--  (299) multiplication_with_reduction_73
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o4_X = reg_y; operation : keep accumulator;
"000000100001100000011000110000000100010110000000011011",
--  (300) multiplication_with_reduction_74
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000010000100000000010011",
--  (301) multiplication_with_reduction_75
-- reg_a = a1_X; reg_b = b4_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001100000000000100000100001000100010000100011",
--  (302) multiplication_with_reduction_76
-- reg_a = o1_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100010000110111",
--  (303) multiplication_with_reduction_77
-- reg_a = a2_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101000011",
--  (304) multiplication_with_reduction_78
-- reg_a = o2_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101010111",
--  (305) multiplication_with_reduction_79
-- reg_a = a3_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001001100011",
--  (306) multiplication_with_reduction_80
-- reg_a = o3_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001001110111",
--  (307) multiplication_with_reduction_81
-- reg_a = a4_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001100000000000100000000000100100000110000011",
--  (308) multiplication_with_reduction_82
-- reg_a = o4_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000000100000110010111",
--  (309) multiplication_with_reduction_83
-- reg_a = a2_X; reg_b = b4_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001100000000000100000100001000100010001000011",
--  (310) multiplication_with_reduction_84
-- reg_a = o2_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100010001010111",
--  (311) multiplication_with_reduction_85
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101100011",
--  (312) multiplication_with_reduction_86
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101110111",
--  (313) multiplication_with_reduction_87
-- reg_a = a4_X; reg_b = b2_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001100000000000100000000000100100001010000011",
--  (314) multiplication_with_reduction_88
-- reg_a = o4_X; reg_b = prime2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000001000101010010111",
--  (315) multiplication_with_reduction_89
-- reg_a = a3_X; reg_b = b4_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001100000000000100000100001000100010001100011",
--  (316) multiplication_with_reduction_90
-- reg_a = o3_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100010001110111",
--  (317) multiplication_with_reduction_91
-- reg_a = a4_X; reg_b = b3_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001100000000000100000000000100100001110000011",
--  (318) multiplication_with_reduction_92
-- reg_a = o4_X; reg_b = prime3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000001101001110010111",
--  (319) multiplication_with_reduction_93
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o >> 272; Enable sign a, b; operation : a*b + acc;
"000000100001100000000000100000100001100100010010000011",
--  (320) multiplication_with_reduction_94
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o; o3_X = reg_o; o4_0 = reg_o >> 272; operation : a*b + acc;
"000000100001100001110000100000000000010001110010010111",
--  (321) multiplication_with_reduction_95
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (322) multiplication_with_reduction_96
-- -- Other cases
-- reg_a = a0_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010000000011",
--  (323) multiplication_with_reduction_97
-- reg_a = a4_X; reg_b = b0_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100000010000011",
--  (324) multiplication_with_reduction_98
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o4_X = reg_y; operation : keep accumulator;
"000000100001101000011000110000000100010110000000011011",
--  (325) multiplication_with_reduction_99
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000010000100000000010011",
--  (326) multiplication_with_reduction_100
-- reg_a = o0_X; reg_b = prime5; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001101000000000100000100000000100010100010111",
--  (327) multiplication_with_reduction_101
-- reg_a = a1_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010000100011",
--  (328) multiplication_with_reduction_102
-- reg_a = o1_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010000110111",
--  (329) multiplication_with_reduction_103
-- reg_a = a2_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101000011",
--  (330) multiplication_with_reduction_104
-- reg_a = o2_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101010111",
--  (331) multiplication_with_reduction_105
-- reg_a = a3_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001001100011",
--  (332) multiplication_with_reduction_106
-- reg_a = o3_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001001110111",
--  (333) multiplication_with_reduction_107
-- reg_a = a4_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100000110000011",
--  (334) multiplication_with_reduction_108
-- reg_a = o4_X; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"010010000001101000000000100000000000000100000110010111",
--  (335) multiplication_with_reduction_109
-- -- In case of size 6
-- reg_a = a0_X; reg_b = b5_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001101000000000100000000001000100010100000011",
--  (336) multiplication_with_reduction_110
-- reg_a = a5_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000000000100100000010100011",
--  (337) multiplication_with_reduction_111
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o5_X = reg_y; operation : keep accumulator;
"000000100001101000011000110000000100011010100000011011",
--  (338) multiplication_with_reduction_112
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000010000100000000010011",
--  (339) multiplication_with_reduction_113
-- reg_a = a1_X; reg_b = b5_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001101000000000100000100001000100010100100011",
--  (340) multiplication_with_reduction_114
-- reg_a = o1_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010100110111",
--  (341) multiplication_with_reduction_115
-- reg_a = a2_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010001000011",
--  (342) multiplication_with_reduction_116
-- reg_a = o2_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010001010111",
--  (343) multiplication_with_reduction_117
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101100011",
--  (344) multiplication_with_reduction_118
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101110111",
--  (345) multiplication_with_reduction_119
-- reg_a = a4_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001010000011",
--  (346) multiplication_with_reduction_120
-- reg_a = o4_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001010010111",
--  (347) multiplication_with_reduction_121
-- reg_a = a5_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000000000100100000110100011",
--  (348) multiplication_with_reduction_122
-- reg_a = o5_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000000100000110110111",
--  (349) multiplication_with_reduction_123
-- reg_a = a2_X; reg_b = b5_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001101000000000100000100001000100010101000011",
--  (350) multiplication_with_reduction_124
-- reg_a = o2_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010101010111",
--  (351) multiplication_with_reduction_125
-- reg_a = a3_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010001100011",
--  (352) multiplication_with_reduction_126
-- reg_a = o3_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010001110111",
--  (353) multiplication_with_reduction_127
-- reg_a = a4_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001110000011",
--  (354) multiplication_with_reduction_128
-- reg_a = o4_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001110010111",
--  (355) multiplication_with_reduction_129
-- reg_a = a5_X; reg_b = b2_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000000000100100001010100011",
--  (356) multiplication_with_reduction_130
-- reg_a = o5_X; reg_b = prime2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000001000101010110111",
--  (357) multiplication_with_reduction_131
-- reg_a = a3_X; reg_b = b5_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001101000000000100000100001000100010101100011",
--  (358) multiplication_with_reduction_132
-- reg_a = o3_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010101110111",
--  (359) multiplication_with_reduction_133
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010010000011",
--  (360) multiplication_with_reduction_134
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010010010111",
--  (361) multiplication_with_reduction_135
-- reg_a = a5_X; reg_b = b3_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000000000100100001110100011",
--  (362) multiplication_with_reduction_136
-- reg_a = o5_X; reg_b = prime3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000001101001110110111",
--  (363) multiplication_with_reduction_137
-- reg_a = a4_X; reg_b = b5_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001101000000000100000100001000100010110000011",
--  (364) multiplication_with_reduction_138
-- reg_a = o4_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010110010111",
--  (365) multiplication_with_reduction_139
-- reg_a = a5_X; reg_b = b4_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000000000100100010010100011",
--  (366) multiplication_with_reduction_140
-- reg_a = o5_X; reg_b = prime4; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000010001110010110111",
--  (367) multiplication_with_reduction_141
-- reg_a = a5_X; reg_b = b5_X; reg_acc = reg_o >> 272; Enable sign a, b; operation : a*b + acc;
"000000100001101000000000100000100001100100010110100011",
--  (368) multiplication_with_reduction_142
-- reg_a = o5_X; reg_b = prime5; reg_acc = reg_o; o4_X = reg_o; o5_0 = reg_o >> 272; operation : a*b + acc;
"000000100001101001110000100000000000010110010110110111",
--  (369) multiplication_with_reduction_143
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (370) multiplication_with_reduction_144
-- -- Other cases
-- reg_a = a0_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010100000011",
--  (371) multiplication_with_reduction_145
-- reg_a = a5_X; reg_b = b0_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100000010100011",
--  (372) multiplication_with_reduction_146
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o5_X = reg_y; operation : keep accumulator;
"000000100001110000011000110000000100011010100000011011",
--  (373) multiplication_with_reduction_147
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000010000100000000010011",
--  (374) multiplication_with_reduction_148
-- reg_a = o0_X; reg_b = prime6; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100011000010111",
--  (375) multiplication_with_reduction_149
-- reg_a = a1_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010100100011",
--  (376) multiplication_with_reduction_150
-- reg_a = o1_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010100110111",
--  (377) multiplication_with_reduction_151
-- reg_a = a2_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010001000011",
--  (378) multiplication_with_reduction_152
-- reg_a = o2_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010001010111",
--  (379) multiplication_with_reduction_153
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001101100011",
--  (380) multiplication_with_reduction_154
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001101110111",
--  (381) multiplication_with_reduction_155
-- reg_a = a4_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001010000011",
--  (382) multiplication_with_reduction_156
-- reg_a = o4_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001010010111",
--  (383) multiplication_with_reduction_157
-- reg_a = a5_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100000110100011",
--  (384) multiplication_with_reduction_158
-- reg_a = o5_X; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"011000000001110000000000100000000000000100000110110111",
--  (385) multiplication_with_reduction_159
-- -- In case of size 7
-- reg_a = a0_X; reg_b = b6_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001110000000000100000000001000100011000000011",
--  (386) multiplication_with_reduction_160
-- reg_a = a6_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000100100000011000011",
--  (387) multiplication_with_reduction_161
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o6_X = reg_y; operation : keep accumulator;
"000000100001110000011000110000000100011111000000011011",
--  (388) multiplication_with_reduction_162
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000010000100000000010011",
--  (389) multiplication_with_reduction_163
-- reg_a = a1_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001110000000000100000100001000100011000100011",
--  (390) multiplication_with_reduction_164
-- reg_a = o1_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011000110111",
--  (391) multiplication_with_reduction_165
-- reg_a = a2_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101000011",
--  (392) multiplication_with_reduction_166
-- reg_a = o2_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101010111",
--  (393) multiplication_with_reduction_167
-- reg_a = a3_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010001100011",
--  (394) multiplication_with_reduction_168
-- reg_a = o3_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010001110111",
--  (395) multiplication_with_reduction_169
-- reg_a = a4_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001110000011",
--  (396) multiplication_with_reduction_170
-- reg_a = o4_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001110010111",
--  (397) multiplication_with_reduction_171
-- reg_a = a5_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001010100011",
--  (398) multiplication_with_reduction_172
-- reg_a = o5_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001010110111",
--  (399) multiplication_with_reduction_173
-- reg_a = a6_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000100100000111000011",
--  (400) multiplication_with_reduction_174
-- reg_a = o6_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000000100000111010111",
--  (401) multiplication_with_reduction_175
-- reg_a = a2_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001110000000000100000100001000100011001000011",
--  (402) multiplication_with_reduction_176
-- reg_a = o2_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011001010111",
--  (403) multiplication_with_reduction_177
-- reg_a = a3_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101100011",
--  (404) multiplication_with_reduction_178
-- reg_a = o3_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101110111",
--  (405) multiplication_with_reduction_179
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010000011",
--  (406) multiplication_with_reduction_180
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010010111",
--  (407) multiplication_with_reduction_181
-- reg_a = a5_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001110100011",
--  (408) multiplication_with_reduction_182
-- reg_a = o5_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001110110111",
--  (409) multiplication_with_reduction_183
-- reg_a = a6_X; reg_b = b2_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000100100001011000011",
--  (410) multiplication_with_reduction_184
-- reg_a = o6_X; reg_b = prime2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000001000101011010111",
--  (411) multiplication_with_reduction_185
-- reg_a = a3_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001110000000000100000100001000100011001100011",
--  (412) multiplication_with_reduction_186
-- reg_a = o3_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011001110111",
--  (413) multiplication_with_reduction_187
-- reg_a = a4_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110000011",
--  (414) multiplication_with_reduction_188
-- reg_a = o4_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110010111",
--  (415) multiplication_with_reduction_189
-- reg_a = a5_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010100011",
--  (416) multiplication_with_reduction_190
-- reg_a = o5_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010110111",
--  (417) multiplication_with_reduction_191
-- reg_a = a6_X; reg_b = b3_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000100100001111000011",
--  (418) multiplication_with_reduction_192
-- reg_a = o6_X; reg_b = prime3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000001101001111010111",
--  (419) multiplication_with_reduction_193
-- reg_a = a4_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001110000000000100000100001000100011010000011",
--  (420) multiplication_with_reduction_194
-- reg_a = o4_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011010010111",
--  (421) multiplication_with_reduction_195
-- reg_a = a5_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110100011",
--  (422) multiplication_with_reduction_196
-- reg_a = o5_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110110111",
--  (423) multiplication_with_reduction_197
-- reg_a = a6_X; reg_b = b4_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000100100010011000011",
--  (424) multiplication_with_reduction_198
-- reg_a = o6_X; reg_b = prime4; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000010001110011010111",
--  (425) multiplication_with_reduction_199
-- reg_a = a5_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001110000000000100000100001000100011010100011",
--  (426) multiplication_with_reduction_200
-- reg_a = o5_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011010110111",
--  (427) multiplication_with_reduction_201
-- reg_a = a6_X; reg_b = b5_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000100100010111000011",
--  (428) multiplication_with_reduction_202
-- reg_a = o6_X; reg_b = prime5; reg_acc = reg_o; o4_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000010110010111010111",
--  (429) multiplication_with_reduction_203
-- reg_a = a6_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign a, b; operation : a*b + acc;
"000000100001110000000000100000100001100100011011000011",
--  (430) multiplication_with_reduction_204
-- reg_a = o6_X; reg_b = prime6; reg_acc = reg_o; o5_X = reg_o; o6_0 = reg_o >> 272; operation : a*b + acc;
"000000100001110001110000100000000000011010111011010111",
--  (431) multiplication_with_reduction_205
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (432) multiplication_with_reduction_206
-- -- In case of size 8
-- reg_a = a0_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011000000011",
--  (433) multiplication_with_reduction_207
-- reg_a = a6_X; reg_b = b0_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100000011000011",
--  (434) multiplication_with_reduction_208
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o6_X = reg_y; operation : keep accumulator;
"000000100001111000011000110000000100011111000000011011",
--  (435) multiplication_with_reduction_209
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000010000100000000010011",
--  (436) multiplication_with_reduction_210
-- reg_a = o0_X; reg_b = prime7; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000000100011100010111",
--  (437) multiplication_with_reduction_211
-- reg_a = a1_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011000100011",
--  (438) multiplication_with_reduction_212
-- reg_a = o1_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011000110111",
--  (439) multiplication_with_reduction_213
-- reg_a = a2_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101000011",
--  (440) multiplication_with_reduction_214
-- reg_a = o2_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101010111",
--  (441) multiplication_with_reduction_215
-- reg_a = a3_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010001100011",
--  (442) multiplication_with_reduction_216
-- reg_a = o3_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010001110111",
--  (443) multiplication_with_reduction_217
-- reg_a = a4_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001110000011",
--  (444) multiplication_with_reduction_218
-- reg_a = o4_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001110010111",
--  (445) multiplication_with_reduction_219
-- reg_a = a5_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001010100011",
--  (446) multiplication_with_reduction_220
-- reg_a = o5_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001010110111",
--  (447) multiplication_with_reduction_221
-- reg_a = a6_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100000111000011",
--  (448) multiplication_with_reduction_222
-- reg_a = o6_X; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100000111010111",
--  (449) multiplication_with_reduction_223
-- reg_a = a0_X; reg_b = b7_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000000001000100011100000011",
--  (450) multiplication_with_reduction_224
-- reg_a = a7_X; reg_b = b0_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100100000011100011",
--  (451) multiplication_with_reduction_225
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o7_X = reg_y; operation : keep accumulator;
"000000100001111000011000110000000100011111100000011011",
--  (452) multiplication_with_reduction_226
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000010000100000000010011",
--  (453) multiplication_with_reduction_227
-- reg_a = a1_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000100001000100011100100011",
--  (454) multiplication_with_reduction_228
-- reg_a = o1_X; reg_b = prime7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011100110111",
--  (455) multiplication_with_reduction_229
-- reg_a = a2_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001000011",
--  (456) multiplication_with_reduction_230
-- reg_a = o2_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001010111",
--  (457) multiplication_with_reduction_231
-- reg_a = a3_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101100011",
--  (458) multiplication_with_reduction_232
-- reg_a = o3_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101110111",
--  (459) multiplication_with_reduction_233
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010000011",
--  (460) multiplication_with_reduction_234
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010010111",
--  (461) multiplication_with_reduction_235
-- reg_a = a5_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001110100011",
--  (462) multiplication_with_reduction_236
-- reg_a = o5_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001110110111",
--  (463) multiplication_with_reduction_237
-- reg_a = a6_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001011000011",
--  (464) multiplication_with_reduction_238
-- reg_a = o6_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001011010111",
--  (465) multiplication_with_reduction_239
-- reg_a = a7_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100100000111100011",
--  (466) multiplication_with_reduction_240
-- reg_a = o7_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000000100000111110111",
--  (467) multiplication_with_reduction_241
-- reg_a = a2_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000100001000100011101000011",
--  (468) multiplication_with_reduction_242
-- reg_a = o2_X; reg_b = prime7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011101010111",
--  (469) multiplication_with_reduction_243
-- reg_a = a3_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001100011",
--  (470) multiplication_with_reduction_244
-- reg_a = o3_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001110111",
--  (471) multiplication_with_reduction_245
-- reg_a = a4_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110000011",
--  (472) multiplication_with_reduction_246
-- reg_a = o4_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110010111",
--  (473) multiplication_with_reduction_247
-- reg_a = a5_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010100011",
--  (474) multiplication_with_reduction_248
-- reg_a = o5_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010110111",
--  (475) multiplication_with_reduction_249
-- reg_a = a6_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001111000011",
--  (476) multiplication_with_reduction_250
-- reg_a = o6_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001111010111",
--  (477) multiplication_with_reduction_251
-- reg_a = a7_X; reg_b = b2_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100100001011100011",
--  (478) multiplication_with_reduction_252
-- reg_a = o7_X; reg_b = prime2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000001000101011110111",
--  (479) multiplication_with_reduction_253
-- reg_a = a3_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000100001000100011101100011",
--  (480) multiplication_with_reduction_254
-- reg_a = o3_X; reg_b = prime7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011101110111",
--  (481) multiplication_with_reduction_255
-- reg_a = a4_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011010000011",
--  (482) multiplication_with_reduction_256
-- reg_a = o4_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011010010111",
--  (483) multiplication_with_reduction_257
-- reg_a = a5_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110100011",
--  (484) multiplication_with_reduction_258
-- reg_a = o5_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110110111",
--  (485) multiplication_with_reduction_259
-- reg_a = a6_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010011000011",
--  (486) multiplication_with_reduction_260
-- reg_a = o6_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010011010111",
--  (487) multiplication_with_reduction_261
-- reg_a = a7_X; reg_b = b3_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100100001111100011",
--  (488) multiplication_with_reduction_262
-- reg_a = o7_X; reg_b = prime3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000001101001111110111",
--  (489) multiplication_with_reduction_263
-- reg_a = a4_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000100001000100011110000011",
--  (490) multiplication_with_reduction_264
-- reg_a = o4_X; reg_b = prime7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011110010111",
--  (491) multiplication_with_reduction_265
-- reg_a = a5_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011010100011",
--  (492) multiplication_with_reduction_266
-- reg_a = o5_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011010110111",
--  (493) multiplication_with_reduction_267
-- reg_a = a6_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010111000011",
--  (494) multiplication_with_reduction_268
-- reg_a = o6_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010111010111",
--  (495) multiplication_with_reduction_269
-- reg_a = a7_X; reg_b = b4_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100100010011100011",
--  (496) multiplication_with_reduction_270
-- reg_a = o7_X; reg_b = prime4; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000010001110011110111",
--  (497) multiplication_with_reduction_271
-- reg_a = a5_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000100001000100011110100011",
--  (498) multiplication_with_reduction_272
-- reg_a = o5_X; reg_b = prime7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011110110111",
--  (499) multiplication_with_reduction_273
-- reg_a = a6_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011011000011",
--  (500) multiplication_with_reduction_274
-- reg_a = o6_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011011010111",
--  (501) multiplication_with_reduction_275
-- reg_a = a7_X; reg_b = b5_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100100010111100011",
--  (502) multiplication_with_reduction_276
-- reg_a = o7_X; reg_b = prime5; reg_acc = reg_o; o4_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000010110010111110111",
--  (503) multiplication_with_reduction_277
-- reg_a = a6_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000100001000100011111000011",
--  (504) multiplication_with_reduction_278
-- reg_a = o6_X; reg_b = prime7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011111010111",
--  (505) multiplication_with_reduction_279
-- reg_a = a7_X; reg_b = b6_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100100011011100011",
--  (506) multiplication_with_reduction_280
-- reg_a = o7_X; reg_b = prime6; reg_acc = reg_o; o5_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000011010111011110111",
--  (507) multiplication_with_reduction_281
-- reg_a = a7_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign a, b; operation : a*b + acc;
"000000100001111000000000100000100001100100011111100011",
--  (508) multiplication_with_reduction_282
-- reg_a = o7_X; reg_b = prime7; reg_acc = reg_o; o6_X = reg_o; o7_0 = reg_o >> 272; operation : a*b + acc;
"000000100001111001110000100000000000011111011111110111",
--  (509) multiplication_with_reduction_283
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (510) multiplication_with_reduction_special_prime_0
-- -- In case of size 1
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"000000100001000000000000100000010000000100000000000011",
--  (511) multiplication_with_reduction_special_prime_1
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 272; o0_X = reg_o; operation : a*b + acc;
"000000100001000000010000100000101110000100000000000011",
--  (512) multiplication_with_reduction_special_prime_2
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (513) multiplication_with_reduction_special_prime_3
-- -- In case of sizes 2, 3, 4
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_X = reg_o; operation : a*b + acc;
"000011100001001000010000100000010000000100000000000011",
--  (514) multiplication_with_reduction_special_prime_4
-- -- In case of size 2
-- reg_a = a0_X; reg_b = b1_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001001000000000100000100001000100000100000011",
--  (515) multiplication_with_reduction_special_prime_5
-- reg_a = o0_X; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"000000100001001000000000100000000000000100000100010111",
--  (516) multiplication_with_reduction_special_prime_6
-- reg_a = a1_X; reg_b = b0_X; reg_acc = reg_o; o1_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001001000010000100000000000101000100000100011",
--  (517) multiplication_with_reduction_special_prime_7
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001001000000000100000100001100100000100100011",
--  (518) multiplication_with_reduction_special_prime_8
-- reg_a = o1_X; reg_b = primeSP1; reg_acc = reg_o; o0_X = reg_o; o1_X = reg_o >> 272; operation : a*b + acc;
"000000100001001001110000100000000000000100000100110111",
--  (519) multiplication_with_reduction_special_prime_9
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (520) multiplication_with_reduction_special_prime_10
-- -- In case of sizes 3, 4
-- reg_a = a0_X; reg_b = b1_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001010000000000100000100000000100000100000011",
--  (521) multiplication_with_reduction_special_prime_11
-- reg_a = o0_X; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000000000100000100010111",
--  (522) multiplication_with_reduction_special_prime_12
-- reg_a = a1_X; reg_b = b0_X; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001010000010000100000000000001000100000100011",
--  (523) multiplication_with_reduction_special_prime_13
-- reg_a = o0_X; reg_b = primeSP2; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001010000000000100000100000000100001000010111",
--  (524) multiplication_with_reduction_special_prime_14
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000000000100000100100011",
--  (525) multiplication_with_reduction_special_prime_15
-- reg_a = o1_X; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"000101000001010000000000100000000000000100000100110111",
--  (526) multiplication_with_reduction_special_prime_16
-- -- In case of size 3
-- reg_a = a0_X; reg_b = b2_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001010000000000100000000001000100001000000011",
--  (527) multiplication_with_reduction_special_prime_17
-- reg_a = a2_X; reg_b = b0_X; reg_acc = reg_o; o2_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001010000010000100000000000101101000001000011",
--  (528) multiplication_with_reduction_special_prime_18
-- reg_a = a1_X; reg_b = b2_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001010000000000100000100001000100001000100011",
--  (529) multiplication_with_reduction_special_prime_19
-- reg_a = o1_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000000000100001000110111",
--  (530) multiplication_with_reduction_special_prime_20
-- reg_a = a2_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001010000000000100000000000100100000101000011",
--  (531) multiplication_with_reduction_special_prime_21
-- reg_a = o2_X; reg_b = primeSP1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001010000010000100000000000000100000101010111",
--  (532) multiplication_with_reduction_special_prime_22
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001010000000000100000100001100100001001000011",
--  (533) multiplication_with_reduction_special_prime_23
-- reg_a = o2_X; reg_b = primeSP2; reg_acc = reg_o; o1_X = reg_o; o2_X = reg_o >> 272; operation : a*b + acc;
"000000100001010001110000100000000000001000101001010111",
--  (534) multiplication_with_reduction_special_prime_24
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (535) multiplication_with_reduction_special_prime_25
-- -- In case of size 4
-- reg_a = a0_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001000000011",
--  (536) multiplication_with_reduction_special_prime_26
-- reg_a = a2_X; reg_b = b0_X; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001011000010000100000000000001101000001000011",
--  (537) multiplication_with_reduction_special_prime_27
-- reg_a = o0_X; reg_b = primeSP3; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001011000000000100000100000000100001100010111",
--  (538) multiplication_with_reduction_special_prime_28
-- reg_a = a1_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001000100011",
--  (539) multiplication_with_reduction_special_prime_29
-- reg_a = o1_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001000110111",
--  (540) multiplication_with_reduction_special_prime_30
-- reg_a = a2_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100000101000011",
--  (541) multiplication_with_reduction_special_prime_31
-- reg_a = o2_X; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100000101010111",
--  (542) multiplication_with_reduction_special_prime_32
-- reg_a = a0_X; reg_b = b3_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001011000000000100000000001000100001100000011",
--  (543) multiplication_with_reduction_special_prime_33
-- reg_a = a3_X; reg_b = b0_X; reg_acc = reg_o; o3_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001011000010000100000000000100001100001100011",
--  (544) multiplication_with_reduction_special_prime_34
-- reg_a = a1_X; reg_b = b3_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001011000000000100000100001000100001100100011",
--  (545) multiplication_with_reduction_special_prime_35
-- reg_a = o1_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001100110111",
--  (546) multiplication_with_reduction_special_prime_36
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001001000011",
--  (547) multiplication_with_reduction_special_prime_37
-- reg_a = o2_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001001010111",
--  (548) multiplication_with_reduction_special_prime_38
-- reg_a = a3_X; reg_b = b1_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001011000000000100000000000100100000101100011",
--  (549) multiplication_with_reduction_special_prime_39
-- reg_a = o3_X; reg_b = primeSP1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001011000010000100000000000000100000101110111",
--  (550) multiplication_with_reduction_special_prime_40
-- reg_a = a2_X; reg_b = b3_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001011000000000100000100001000100001101000011",
--  (551) multiplication_with_reduction_special_prime_41
-- reg_a = o2_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001101010111",
--  (552) multiplication_with_reduction_special_prime_42
-- reg_a = a3_X; reg_b = b2_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001011000000000100000000000100100001001100011",
--  (553) multiplication_with_reduction_special_prime_43
-- reg_a = o3_X; reg_b = primeSP2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001011000010000100000000000001000101001110111",
--  (554) multiplication_with_reduction_special_prime_44
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001011000000000100000100001100100001101100011",
--  (555) multiplication_with_reduction_special_prime_45
-- reg_a = o3_X; reg_b = primeSP3; reg_acc = reg_o; o2_X = reg_o; o3_X = reg_o >> 272; operation : a*b + acc;
"000000100001011001110000100000000000001101001101110111",
--  (556) multiplication_with_reduction_special_prime_46
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (557) multiplication_with_reduction_special_prime_47
-- -- In case of sizes 5, 6
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000010000000100000000000011",
--  (558) multiplication_with_reduction_special_prime_48
-- reg_a = a0_X; reg_b = b1_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000000100000100000011",
--  (559) multiplication_with_reduction_special_prime_49
-- reg_a = a1_X; reg_b = b0_X; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000001000100000100011",
--  (560) multiplication_with_reduction_special_prime_50
-- reg_a = o0_X; reg_b = primeSP2; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000000100001000010111",
--  (561) multiplication_with_reduction_special_prime_51
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100000100100011",
--  (562) multiplication_with_reduction_special_prime_52
-- reg_a = a0_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001000000011",
--  (563) multiplication_with_reduction_special_prime_53
-- reg_a = a2_X; reg_b = b0_X; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000001101000001000011",
--  (564) multiplication_with_reduction_special_prime_54
-- reg_a = o0_X; reg_b = primeSP3; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000000100001100010111",
--  (565) multiplication_with_reduction_special_prime_55
-- reg_a = a1_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001000100011",
--  (566) multiplication_with_reduction_special_prime_56
-- reg_a = o1_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001000110111",
--  (567) multiplication_with_reduction_special_prime_57
-- reg_a = a2_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100000101000011",
--  (568) multiplication_with_reduction_special_prime_58
-- reg_a = a0_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001100000011",
--  (569) multiplication_with_reduction_special_prime_59
-- reg_a = a3_X; reg_b = b0_X; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000010001100001100011",
--  (570) multiplication_with_reduction_special_prime_60
-- reg_a = o0_X; reg_b = primeSP4; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000000100010000010111",
--  (571) multiplication_with_reduction_special_prime_61
-- reg_a = a1_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001100100011",
--  (572) multiplication_with_reduction_special_prime_62
-- reg_a = o1_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001100110111",
--  (573) multiplication_with_reduction_special_prime_63
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001001000011",
--  (574) multiplication_with_reduction_special_prime_64
-- reg_a = o2_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001001010111",
--  (575) multiplication_with_reduction_special_prime_65
-- reg_a = a3_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"001011100001100000000000100000000000000100000101100011",
--  (576) multiplication_with_reduction_special_prime_66
-- In case of size 5
-- reg_a = a0_X; reg_b = b4_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001100000000000100000000001000100010000000011",
--  (577) multiplication_with_reduction_special_prime_67
-- reg_a = a4_X; reg_b = b0_X; reg_acc = reg_o; o4_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001100000010000100000000000100010000010000011",
--  (578) multiplication_with_reduction_special_prime_68
-- reg_a = a1_X; reg_b = b4_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001100000000000100000100001000100010000100011",
--  (579) multiplication_with_reduction_special_prime_69
-- reg_a = o1_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100010000110111",
--  (580) multiplication_with_reduction_special_prime_70
-- reg_a = a2_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101000011",
--  (581) multiplication_with_reduction_special_prime_71
-- reg_a = o2_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101010111",
--  (582) multiplication_with_reduction_special_prime_72
-- reg_a = a3_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001001100011",
--  (583) multiplication_with_reduction_special_prime_73
-- reg_a = o3_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001001110111",
--  (584) multiplication_with_reduction_special_prime_74
-- reg_a = a4_X; reg_b = b1_X; reg_acc = reg_o; o0_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001100000010000100000000000100100000110000011",
--  (585) multiplication_with_reduction_special_prime_75
-- reg_a = a2_X; reg_b = b4_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001100000000000100000100001000100010001000011",
--  (586) multiplication_with_reduction_special_prime_76
-- reg_a = o2_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100010001010111",
--  (587) multiplication_with_reduction_special_prime_77
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101100011",
--  (588) multiplication_with_reduction_special_prime_78
-- reg_a = o3_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101110111",
--  (589) multiplication_with_reduction_special_prime_79
-- reg_a = a4_X; reg_b = b2_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001100000000000100000000000100100001010000011",
--  (590) multiplication_with_reduction_special_prime_80
-- reg_a = o4_X; reg_b = primeSP2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000001000101010010111",
--  (591) multiplication_with_reduction_special_prime_81
-- reg_a = a3_X; reg_b = b4_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001100000000000100000100001000100010001100011",
--  (592) multiplication_with_reduction_special_prime_82
-- reg_a = o3_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100010001110111",
--  (593) multiplication_with_reduction_special_prime_83
-- reg_a = a4_X; reg_b = b3_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001100000000000100000000000100100001110000011",
--  (594) multiplication_with_reduction_special_prime_84
-- reg_a = o4_X; reg_b = primeSP3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000001101001110010111",
--  (595) multiplication_with_reduction_special_prime_85
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001100000000000100000100001100100010010000011",
--  (596) multiplication_with_reduction_special_prime_86
-- reg_a = o4_X; reg_b = primeSP4; reg_acc = reg_o; o3_X = reg_o; o4_X = reg_o >> 272; operation : a*b + acc;
"000000100001100001110000100000000000010001110010010111",
--  (597) multiplication_with_reduction_special_prime_87
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (598) multiplication_with_reduction_special_prime_88
-- -- In case of size 6
-- reg_a = a0_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010000000011",
--  (599) multiplication_with_reduction_special_prime_89
-- reg_a = a4_X; reg_b = b0_X; reg_acc = reg_o; o4_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000010010000010000011",
--  (600) multiplication_with_reduction_special_prime_90
-- reg_a = o0_X; reg_b = primeSP5; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001101000000000100000100000000100010100010111",
--  (601) multiplication_with_reduction_special_prime_91
-- reg_a = a1_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010000100011",
--  (602) multiplication_with_reduction_special_prime_92
-- reg_a = o1_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010000110111",
--  (603) multiplication_with_reduction_special_prime_93
-- reg_a = a2_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101000011",
--  (604) multiplication_with_reduction_special_prime_94
-- reg_a = o2_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101010111",
--  (605) multiplication_with_reduction_special_prime_95
-- reg_a = a3_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001001100011",
--  (606) multiplication_with_reduction_special_prime_96
-- reg_a = o3_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001001110111",
--  (607) multiplication_with_reduction_special_prime_97
-- reg_a = a4_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100000110000011",
--  (608) multiplication_with_reduction_special_prime_98
-- reg_a = a0_X; reg_b = b5_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001101000000000100000000001000100010100000011",
--  (609) multiplication_with_reduction_special_prime_99
-- reg_a = a5_X; reg_b = b0_X; reg_acc = reg_o; o5_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000010000100000000000100010100010100011",
--  (610) multiplication_with_reduction_special_prime_100
-- reg_a = a1_X; reg_b = b5_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001101000000000100000100001000100010100100011",
--  (611) multiplication_with_reduction_special_prime_101
-- reg_a = o1_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010100110111",
--  (612) multiplication_with_reduction_special_prime_102
-- reg_a = a2_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010001000011",
--  (613) multiplication_with_reduction_special_prime_103
-- reg_a = o2_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010001010111",
--  (614) multiplication_with_reduction_special_prime_104
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101100011",
--  (615) multiplication_with_reduction_special_prime_105
-- reg_a = o3_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101110111",
--  (616) multiplication_with_reduction_special_prime_106
-- reg_a = a4_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001010000011",
--  (617) multiplication_with_reduction_special_prime_107
-- reg_a = o4_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001010010111",
--  (618) multiplication_with_reduction_special_prime_108
-- reg_a = a5_X; reg_b = b1_X; reg_acc = reg_o; o0_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000010000100000000000100100000110100011",
--  (619) multiplication_with_reduction_special_prime_109
-- reg_a = a2_X; reg_b = b5_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001101000000000100000100001000100010101000011",
--  (620) multiplication_with_reduction_special_prime_110
-- reg_a = o2_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010101010111",
--  (621) multiplication_with_reduction_special_prime_111
-- reg_a = a3_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010001100011",
--  (622) multiplication_with_reduction_special_prime_112
-- reg_a = o3_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010001110111",
--  (623) multiplication_with_reduction_special_prime_113
-- reg_a = a4_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001110000011",
--  (624) multiplication_with_reduction_special_prime_114
-- reg_a = o4_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001110010111",
--  (625) multiplication_with_reduction_special_prime_115
-- reg_a = a5_X; reg_b = b2_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000000000100100001010100011",
--  (626) multiplication_with_reduction_special_prime_116
-- reg_a = o5_X; reg_b = primeSP2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000001000101010110111",
--  (627) multiplication_with_reduction_special_prime_117
-- reg_a = a3_X; reg_b = b5_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001101000000000100000100001000100010101100011",
--  (628) multiplication_with_reduction_special_prime_118
-- reg_a = o3_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010101110111",
--  (629) multiplication_with_reduction_special_prime_119
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010010000011",
--  (630) multiplication_with_reduction_special_prime_120
-- reg_a = o4_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010010010111",
--  (631) multiplication_with_reduction_special_prime_121
-- reg_a = a5_X; reg_b = b3_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000000000100100001110100011",
--  (632) multiplication_with_reduction_special_prime_122
-- reg_a = o5_X; reg_b = primeSP3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000001101001110110111",
--  (633) multiplication_with_reduction_special_prime_123
-- reg_a = a4_X; reg_b = b5_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001101000000000100000100001000100010110000011",
--  (634) multiplication_with_reduction_special_prime_124
-- reg_a = o4_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010110010111",
--  (635) multiplication_with_reduction_special_prime_125
-- reg_a = a5_X; reg_b = b4_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001101000000000100000000000100100010010100011",
--  (636) multiplication_with_reduction_special_prime_126
-- reg_a = o5_X; reg_b = primeSP4; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000010001110010110111",
--  (637) multiplication_with_reduction_special_prime_127
-- reg_a = a5_X; reg_b = b5_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001101000000000100000100001100100010110100011",
--  (638) multiplication_with_reduction_special_prime_128
-- reg_a = o5_X; reg_b = primeSP5; reg_acc = reg_o; o4_X = reg_o; o5_X = reg_o >> 272; operation : a*b + acc;
"000000100001101001110000100000000000010110010110110111",
--  (639) multiplication_with_reduction_special_prime_129
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (640) multiplication_with_reduction_special_prime_130
-- -- In case of sizes 7, 8
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000010000000100000000000011",
--  (641) multiplication_with_reduction_special_prime_131
-- reg_a = a0_X; reg_b = b1_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100000100000011",
--  (642) multiplication_with_reduction_special_prime_132
-- reg_a = a1_X; reg_b = b0_X; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000001000100000100011",
--  (643) multiplication_with_reduction_special_prime_133
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100000100100011",
--  (644) multiplication_with_reduction_special_prime_134
-- reg_a = a0_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001000000011",
--  (645) multiplication_with_reduction_special_prime_135
-- reg_a = a2_X; reg_b = b0_X; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000001101000001000011",
--  (646) multiplication_with_reduction_special_prime_136
-- reg_a = o0_X; reg_b = primeSP3; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100001100010111",
--  (647) multiplication_with_reduction_special_prime_137
-- reg_a = a1_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001000100011",
--  (648) multiplication_with_reduction_special_prime_138
-- reg_a = a2_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100000101000011",
--  (649) multiplication_with_reduction_special_prime_139
-- reg_a = a0_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001100000011",
--  (650) multiplication_with_reduction_special_prime_140
-- reg_a = a3_X; reg_b = b0_X; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000010001100001100011",
--  (651) multiplication_with_reduction_special_prime_141
-- reg_a = o0_X; reg_b = primeSP4; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100010000010111",
--  (652) multiplication_with_reduction_special_prime_142
-- reg_a = a1_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001100100011",
--  (653) multiplication_with_reduction_special_prime_143
-- reg_a = o1_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001100110111",
--  (654) multiplication_with_reduction_special_prime_144
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001001000011",
--  (655) multiplication_with_reduction_special_prime_145
-- reg_a = a3_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100000101100011",
--  (656) multiplication_with_reduction_special_prime_146
-- reg_a = a0_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010000000011",
--  (657) multiplication_with_reduction_special_prime_147
-- reg_a = a4_X; reg_b = b0_X; reg_acc = reg_o; o4_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000010110000010000011",
--  (658) multiplication_with_reduction_special_prime_148
-- reg_a = o0_X; reg_b = primeSP5; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100010100010111",
--  (659) multiplication_with_reduction_special_prime_149
-- reg_a = a1_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010000100011",
--  (660) multiplication_with_reduction_special_prime_150
-- reg_a = o1_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010000110111",
--  (661) multiplication_with_reduction_special_prime_151
-- reg_a = a2_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001101000011",
--  (662) multiplication_with_reduction_special_prime_152
-- reg_a = o2_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001101010111",
--  (663) multiplication_with_reduction_special_prime_153
-- reg_a = a3_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001001100011",
--  (664) multiplication_with_reduction_special_prime_154
-- reg_a = a4_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100000110000011",
--  (665) multiplication_with_reduction_special_prime_155
-- reg_a = a0_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010100000011",
--  (666) multiplication_with_reduction_special_prime_156
-- reg_a = a5_X; reg_b = b0_X; reg_acc = reg_o; o5_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000011010100010100011",
--  (667) multiplication_with_reduction_special_prime_157
-- reg_a = o0_X; reg_b = primeSP6; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100011000010111",
--  (668) multiplication_with_reduction_special_prime_158
-- reg_a = a1_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010100100011",
--  (669) multiplication_with_reduction_special_prime_159
-- reg_a = o1_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010100110111",
--  (670) multiplication_with_reduction_special_prime_160
-- reg_a = a2_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010001000011",
--  (671) multiplication_with_reduction_special_prime_161
-- reg_a = o2_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010001010111",
--  (672) multiplication_with_reduction_special_prime_162
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001101100011",
--  (673) multiplication_with_reduction_special_prime_163
-- reg_a = o3_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001101110111",
--  (674) multiplication_with_reduction_special_prime_164
-- reg_a = a4_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001010000011",
--  (675) multiplication_with_reduction_special_prime_165
-- reg_a = a5_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"010101100001110000000000100000000000000100000110100011",
--  (676) multiplication_with_reduction_special_prime_166
-- -- In case of size 7
-- reg_a = a0_X; reg_b = b6_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001110000000000100000000001000100011000000011",
--  (677) multiplication_with_reduction_special_prime_167
-- reg_a = a6_X; reg_b = b0_X; reg_acc = reg_o; o6_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000010000100000000000111111000011000011",
--  (678) multiplication_with_reduction_special_prime_168
-- reg_a = a1_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001110000000000100000100001000100011000100011",
--  (679) multiplication_with_reduction_special_prime_169
-- reg_a = o1_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011000110111",
--  (680) multiplication_with_reduction_special_prime_170
-- reg_a = a2_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101000011",
--  (681) multiplication_with_reduction_special_prime_171
-- reg_a = o2_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101010111",
--  (682) multiplication_with_reduction_special_prime_172
-- reg_a = a3_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010001100011",
--  (683) multiplication_with_reduction_special_prime_173
-- reg_a = o3_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010001110111",
--  (684) multiplication_with_reduction_special_prime_174
-- reg_a = a4_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001110000011",
--  (685) multiplication_with_reduction_special_prime_175
-- reg_a = o4_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001110010111",
--  (686) multiplication_with_reduction_special_prime_176
-- reg_a = a5_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001010100011",
--  (687) multiplication_with_reduction_special_prime_177
-- reg_a = a6_X; reg_b = b1_X; reg_acc = reg_o; o0_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000010000100000000000100100000111000011",
--  (688) multiplication_with_reduction_special_prime_178
-- reg_a = a2_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001110000000000100000100001000100011001000011",
--  (689) multiplication_with_reduction_special_prime_179
-- reg_a = o2_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011001010111",
--  (690) multiplication_with_reduction_special_prime_180
-- reg_a = a3_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101100011",
--  (691) multiplication_with_reduction_special_prime_181
-- reg_a = o3_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101110111",
--  (692) multiplication_with_reduction_special_prime_182
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010000011",
--  (693) multiplication_with_reduction_special_prime_183
-- reg_a = o4_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010010111",
--  (694) multiplication_with_reduction_special_prime_184
-- reg_a = a5_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001110100011",
--  (695) multiplication_with_reduction_special_prime_185
-- reg_a = o5_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001110110111",
--  (696) multiplication_with_reduction_special_prime_186
-- reg_a = a6_X; reg_b = b2_X; reg_acc = reg_o; o1_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000010000100000000000101000101011000011",
--  (697) multiplication_with_reduction_special_prime_187
-- reg_a = a3_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001110000000000100000100001000100011001100011",
--  (698) multiplication_with_reduction_special_prime_188
-- reg_a = o3_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011001110111",
--  (699) multiplication_with_reduction_special_prime_189
-- reg_a = a4_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110000011",
--  (700) multiplication_with_reduction_special_prime_190
-- reg_a = o4_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110010111",
--  (701) multiplication_with_reduction_special_prime_191
-- reg_a = a5_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010100011",
--  (702) multiplication_with_reduction_special_prime_192
-- reg_a = o5_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010110111",
--  (703) multiplication_with_reduction_special_prime_193
-- reg_a = a6_X; reg_b = b3_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000100100001111000011",
--  (704) multiplication_with_reduction_special_prime_194
-- reg_a = o6_X; reg_b = primeSP3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000001101001111010111",
--  (705) multiplication_with_reduction_special_prime_195
-- reg_a = a4_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001110000000000100000100001000100011010000011",
--  (706) multiplication_with_reduction_special_prime_196
-- reg_a = o4_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011010010111",
--  (707) multiplication_with_reduction_special_prime_197
-- reg_a = a5_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110100011",
--  (708) multiplication_with_reduction_special_prime_198
-- reg_a = o5_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110110111",
--  (709) multiplication_with_reduction_special_prime_199
-- reg_a = a6_X; reg_b = b4_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000100100010011000011",
--  (710) multiplication_with_reduction_special_prime_200
-- reg_a = o6_X; reg_b = primeSP4; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000010001110011010111",
--  (711) multiplication_with_reduction_special_prime_201
-- reg_a = a5_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001110000000000100000100001000100011010100011",
--  (712) multiplication_with_reduction_special_prime_202
-- reg_a = o5_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011010110111",
--  (713) multiplication_with_reduction_special_prime_203
-- reg_a = a6_X; reg_b = b5_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001110000000000100000000000100100010111000011",
--  (714) multiplication_with_reduction_special_prime_204
-- reg_a = o6_X; reg_b = primeSP5; reg_acc = reg_o; o4_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000010110010111010111",
--  (715) multiplication_with_reduction_special_prime_205
-- reg_a = a6_X; reg_b = b6_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001110000000000100000100001100100011011000011",
--  (716) multiplication_with_reduction_special_prime_206
-- reg_a = o6_X; reg_b = primeSP6; reg_acc = reg_o; o5_X = reg_o; o6_X = reg_o >> 272; operation : a*b + acc;
"000000100001110001110000100000000000011010111011010111",
--  (717) multiplication_with_reduction_special_prime_207
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (718) multiplication_with_reduction_special_prime_208
-- -- In case of size 8
-- reg_a = a0_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011000000011",
--  (719) multiplication_with_reduction_special_prime_209
-- reg_a = a6_X; reg_b = b0_X; reg_acc = reg_o; o6_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000011111000011000011",
--  (720) multiplication_with_reduction_special_prime_210
-- reg_a = o0_X; reg_b = primeSP7; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000000100011100010111",
--  (721) multiplication_with_reduction_special_prime_211
-- reg_a = a1_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011000100011",
--  (722) multiplication_with_reduction_special_prime_212
-- reg_a = o1_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011000110111",
--  (723) multiplication_with_reduction_special_prime_213
-- reg_a = a2_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101000011",
--  (724) multiplication_with_reduction_special_prime_214
-- reg_a = o2_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101010111",
--  (725) multiplication_with_reduction_special_prime_215
-- reg_a = a3_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010001100011",
--  (726) multiplication_with_reduction_special_prime_216
-- reg_a = o3_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010001110111",
--  (727) multiplication_with_reduction_special_prime_217
-- reg_a = a4_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001110000011",
--  (728) multiplication_with_reduction_special_prime_218
-- reg_a = o4_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001110010111",
--  (729) multiplication_with_reduction_special_prime_219
-- reg_a = a5_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001010100011",
--  (730) multiplication_with_reduction_special_prime_220
-- reg_a = a6_X; reg_b = b1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100000111000011",
--  (731) multiplication_with_reduction_special_prime_221
-- reg_a = a0_X; reg_b = b7_X; reg_acc = reg_o; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000000001000100011100000011",
--  (732) multiplication_with_reduction_special_prime_222
-- reg_a = a7_X; reg_b = b0_X; reg_acc = reg_o; o7_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000010000100000000000100011100011100011",
--  (733) multiplication_with_reduction_special_prime_223
-- reg_a = a1_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000100001000100011100100011",
--  (734) multiplication_with_reduction_special_prime_224
-- reg_a = o1_X; reg_b = primeSP7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011100110111",
--  (735) multiplication_with_reduction_special_prime_225
-- reg_a = a2_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001000011",
--  (736) multiplication_with_reduction_special_prime_226
-- reg_a = o2_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001010111",
--  (737) multiplication_with_reduction_special_prime_227
-- reg_a = a3_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101100011",
--  (738) multiplication_with_reduction_special_prime_228
-- reg_a = o3_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101110111",
--  (739) multiplication_with_reduction_special_prime_229
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010000011",
--  (740) multiplication_with_reduction_special_prime_230
-- reg_a = o4_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010010111",
--  (741) multiplication_with_reduction_special_prime_231
-- reg_a = a5_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001110100011",
--  (742) multiplication_with_reduction_special_prime_232
-- reg_a = o5_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001110110111",
--  (743) multiplication_with_reduction_special_prime_233
-- reg_a = a6_X; reg_b = b2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001011000011",
--  (744) multiplication_with_reduction_special_prime_234
-- reg_a = a7_X; reg_b = b1_X; reg_acc = reg_o; o0_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000010000100000000000100100000111100011",
--  (745) multiplication_with_reduction_special_prime_235
-- reg_a = a2_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000100001000100011101000011",
--  (746) multiplication_with_reduction_special_prime_236
-- reg_a = o2_X; reg_b = primeSP7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011101010111",
--  (747) multiplication_with_reduction_special_prime_237
-- reg_a = a3_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001100011",
--  (748) multiplication_with_reduction_special_prime_238
-- reg_a = o3_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001110111",
--  (749) multiplication_with_reduction_special_prime_239
-- reg_a = a4_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110000011",
--  (750) multiplication_with_reduction_special_prime_240
-- reg_a = o4_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110010111",
--  (751) multiplication_with_reduction_special_prime_241
-- reg_a = a5_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010100011",
--  (752) multiplication_with_reduction_special_prime_242
-- reg_a = o5_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010110111",
--  (753) multiplication_with_reduction_special_prime_243
-- reg_a = a6_X; reg_b = b3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001111000011",
--  (754) multiplication_with_reduction_special_prime_244
-- reg_a = o6_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001111010111",
--  (755) multiplication_with_reduction_special_prime_245
-- reg_a = a7_X; reg_b = b2_X; reg_acc = reg_o; o1_X = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000010000100000000000101000101011100011",
--  (756) multiplication_with_reduction_special_prime_246
-- reg_a = a3_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000100001000100011101100011",
--  (757) multiplication_with_reduction_special_prime_247
-- reg_a = o3_X; reg_b = primeSP7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011101110111",
--  (758) multiplication_with_reduction_special_prime_248
-- reg_a = a4_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011010000011",
--  (759) multiplication_with_reduction_special_prime_249
-- reg_a = o4_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011010010111",
--  (760) multiplication_with_reduction_special_prime_250
-- reg_a = a5_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110100011",
--  (761) multiplication_with_reduction_special_prime_251
-- reg_a = o5_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110110111",
--  (762) multiplication_with_reduction_special_prime_252
-- reg_a = a6_X; reg_b = b4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010011000011",
--  (763) multiplication_with_reduction_special_prime_253
-- reg_a = o6_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010011010111",
--  (764) multiplication_with_reduction_special_prime_254
-- reg_a = a7_X; reg_b = b3_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100100001111100011",
--  (765) multiplication_with_reduction_special_prime_255
-- reg_a = o7_X; reg_b = primeSP3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000001101001111110111",
--  (766) multiplication_with_reduction_special_prime_256
-- reg_a = a4_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000100001000100011110000011",
--  (767) multiplication_with_reduction_special_prime_257
-- reg_a = o4_X; reg_b = primeSP7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011110010111",
--  (768) multiplication_with_reduction_special_prime_258
-- reg_a = a5_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011010100011",
--  (769) multiplication_with_reduction_special_prime_259
-- reg_a = o5_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011010110111",
--  (770) multiplication_with_reduction_special_prime_260
-- reg_a = a6_X; reg_b = b5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010111000011",
--  (771) multiplication_with_reduction_special_prime_261
-- reg_a = o6_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010111010111",
--  (772) multiplication_with_reduction_special_prime_262
-- reg_a = a7_X; reg_b = b4_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100100010011100011",
--  (773) multiplication_with_reduction_special_prime_263
-- reg_a = o7_X; reg_b = primeSP4; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000010001110011110111",
--  (774) multiplication_with_reduction_special_prime_264
-- reg_a = a5_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000100001000100011110100011",
--  (775) multiplication_with_reduction_special_prime_265
-- reg_a = o5_X; reg_b = primeSP7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011110110111",
--  (776) multiplication_with_reduction_special_prime_266
-- reg_a = a6_X; reg_b = b6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011011000011",
--  (777) multiplication_with_reduction_special_prime_267
-- reg_a = o6_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011011010111",
--  (778) multiplication_with_reduction_special_prime_268
-- reg_a = a7_X; reg_b = b5_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100100010111100011",
--  (779) multiplication_with_reduction_special_prime_269
-- reg_a = o7_X; reg_b = primeSP5; reg_acc = reg_o; o4_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000010110010111110111",
--  (780) multiplication_with_reduction_special_prime_270
-- reg_a = a6_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign b; operation : a*b + acc;
"000000100001111000000000100000100001000100011111000011",
--  (781) multiplication_with_reduction_special_prime_271
-- reg_a = o6_X; reg_b = primeSP7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011111010111",
--  (782) multiplication_with_reduction_special_prime_272
-- reg_a = a7_X; reg_b = b6_X; reg_acc = reg_o; Enable sign a; operation : a*b + acc;
"000000100001111000000000100000000000100100011011100011",
--  (783) multiplication_with_reduction_special_prime_273
-- reg_a = o7_X; reg_b = primeSP6; reg_acc = reg_o; o5_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000011010111011110111",
--  (784) multiplication_with_reduction_special_prime_274
-- reg_a = a7_X; reg_b = b7_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001111000000000100000100001100100011111100011",
--  (785) multiplication_with_reduction_special_prime_275
-- reg_a = o7_X; reg_b = primeSP7; reg_acc = reg_o; o6_X = reg_o; o7_X = reg_o >> 272; operation : a*b + acc;
"000000100001111001110000100000000000011111011111110111",
--  (786) multiplication_with_reduction_special_prime_276
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (787) square_with_reduction_0
-- -- In case of size 1
-- reg_a = a0_X; reg_b = a0_X; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"000000100001000000000000100000010001100100000000000011",
--  (788) square_with_reduction_1
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_X = reg_y; operation : keep accumulator;
"000000100001000000011000110000000100000100000000011011",
--  (789) square_with_reduction_2
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001000000000000100000000010000100000000010011",
--  (790) square_with_reduction_3
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 272; o0_X = reg_o; operation : a*b + acc;
"000000100001000000010000100000101110000100000000000011",
--  (791) square_with_reduction_4
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (792) square_with_reduction_5
-- -- In case of 2, 3, 4, 5, 6, 7, 8
-- reg_a = a0_X; reg_b = a0_X; reg_acc = 0; operation : a*b + acc;
"000000100001001000000000100000010000000100000000000011",
--  (793) square_with_reduction_6
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o0_X = reg_y; operation : keep accumulator;
"000000100001001000011000110000000100000100000000011011",
--  (794) square_with_reduction_7
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001001000000000100000000010000100000000010011",
--  (795) square_with_reduction_8
-- reg_a = o0_X; reg_b = prime1; reg_acc = reg_o >> 272; operation : a*b + acc;
"000011100001001000000000100000100000000100000100010111",
--  (796) square_with_reduction_9
-- -- In case of size 2
-- reg_a = a0_X; reg_b = a1_X; reg_acc = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001001000000100100000000001000100000100000011",
--  (797) square_with_reduction_10
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_X = reg_y; operation : keep accumulator;
"000000100001001000011000110000000100001000100000111011",
--  (798) square_with_reduction_11
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001001000000000100000000010000100000000110011",
--  (799) square_with_reduction_12
-- reg_a = a1_X; reg_b = a1_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001001000000000100000100001100100000100100011",
--  (800) square_with_reduction_13
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; o1_X = reg_o >> 272; operation : a*b + acc;
"000000100001001001110000100000000000000100000100110111",
--  (801) square_with_reduction_14
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (802) square_with_reduction_15
-- -- Others cases
-- reg_a = a0_X; reg_b = a1_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001010000000100100000000000000100000100000011",
--  (803) square_with_reduction_16
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o1_X = reg_y; operation : keep accumulator;
"000000100001010000011000110000000100001000100000011011",
--  (804) square_with_reduction_17
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000010000100000000010011",
--  (805) square_with_reduction_18
-- reg_a = o0_X; reg_b = prime2; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001010000000000100000100000000100001000010111",
--  (806) square_with_reduction_19
-- reg_a = a1_X; reg_b = a1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000000000100000100100011",
--  (807) square_with_reduction_20
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"000101000001010000000000100000000000000100000100110111",
--  (808) square_with_reduction_21
-- -- In case of size 3
-- reg_a = a0_X; reg_b = a2_X; reg_acc = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001010000000100100000000001000100001000000011",
--  (809) square_with_reduction_22
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_X = reg_y; operation : keep accumulator;
"000000100001010000011000110000000100001101000000011011",
--  (810) square_with_reduction_23
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000010000100000000010011",
--  (811) square_with_reduction_24
-- reg_a = a1_X; reg_b = a2_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001010000000100100000100001000100001000100011",
--  (812) square_with_reduction_25
-- reg_a = o1_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000000000100001000110111",
--  (813) square_with_reduction_26
-- reg_a = o2_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001010000010000100000000000000100000101010111",
--  (814) square_with_reduction_27
-- reg_a = a2_X; reg_b = a2_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001010000000000100000100001100100001001000011",
--  (815) square_with_reduction_28
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o; o1_X = reg_o; o2_X = reg_o >> 272; operation : a*b + acc;
"000000100001010001110000100000000000001000101001010111",
--  (816) square_with_reduction_29
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (817) square_with_reduction_30
-- -- Other cases
-- reg_a = a0_X; reg_b = a2_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001011000000100100000000000000100001000000011",
--  (818) square_with_reduction_31
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o2_X = reg_y; operation : keep accumulator;
"000000100001011000011000110000000100001101000000011011",
--  (819) square_with_reduction_32
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000010000100000000010011",
--  (820) square_with_reduction_33
-- reg_a = o0_X; reg_b = prime3; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001011000000000100000100000000100001100010111",
--  (821) square_with_reduction_34
-- reg_a = a1_X; reg_b = a2_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001011000000100100000000000000100001000100011",
--  (822) square_with_reduction_35
-- reg_a = o1_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001000110111",
--  (823) square_with_reduction_36
-- reg_a = o2_X; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"000111100001011000000000100000000000000100000101010111",
--  (824) square_with_reduction_37
-- In case of size 4
-- reg_a = a0_X; reg_b = a3_X; reg_acc = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001011000000100100000000001000100001100000011",
--  (825) square_with_reduction_38
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o3_X = reg_y; operation : keep accumulator;
"000000100001011000011000110000000100010001100000011011",
--  (826) square_with_reduction_39
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000010000100000000010011",
--  (827) square_with_reduction_40
-- reg_a = a1_X; reg_b = a3_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001011000000100100000100001000100001100100011",
--  (828) square_with_reduction_41
-- reg_a = o1_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001100110111",
--  (829) square_with_reduction_42
-- reg_a = a2_X; reg_b = a2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001001000011",
--  (830) square_with_reduction_43
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001001010111",
--  (831) square_with_reduction_44
-- reg_a = o3_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001011000010000100000000000000100000101110111",
--  (832) square_with_reduction_45
-- reg_a = a2_X; reg_b = a3_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001011000000100100000100001000100001101000011",
--  (833) square_with_reduction_46
-- reg_a = o2_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001101010111",
--  (834) square_with_reduction_47
-- reg_a = o3_X; reg_b = prime2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001011000010000100000000000001000101001110111",
--  (835) square_with_reduction_48
-- reg_a = a3_X; reg_b = a3_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001011000000000100000100001100100001101100011",
--  (836) square_with_reduction_49
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o; o2_X = reg_o; o3_X = reg_o >> 272; operation : a*b + acc;
"000000100001011001110000100000000000001101001101110111",
--  (837) square_with_reduction_50
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (838) square_with_reduction_51
-- -- Other cases
-- reg_a = a0_X; reg_b = a3_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001100000000100100000000000000100001100000011",
--  (839) square_with_reduction_52
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o3_X = reg_y; operation : keep accumulator;
"000000100001100000011000110000000100010001100000011011",
--  (840) square_with_reduction_53
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000010000100000000010011",
--  (841) square_with_reduction_54
-- reg_a = o0_X; reg_b = prime4; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000000100010000010111",
--  (842) square_with_reduction_55
-- reg_a = a1_X; reg_b = a3_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001100000000100100000000000000100001100100011",
--  (843) square_with_reduction_56
-- reg_a = o1_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001100110111",
--  (844) square_with_reduction_57
-- reg_a = a2_X; reg_b = a2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001001000011",
--  (845) square_with_reduction_58
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001001010111",
--  (846) square_with_reduction_59
-- reg_a = o3_X; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"001010100001100000000000100000000000000100000101110111",
--  (847) square_with_reduction_60
-- -- In case of size 5
-- reg_a = a0_X; reg_b = a4_X; reg_acc = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001100000000100100000000001000100010000000011",
--  (848) square_with_reduction_61
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o4_X = reg_y; operation : keep accumulator;
"000000100001100000011000110000000100010110000000011011",
--  (849) square_with_reduction_62
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000010000100000000010011",
--  (850) square_with_reduction_63
-- reg_a = a1_X; reg_b = a4_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001100000000100100000100001000100010000100011",
--  (851) square_with_reduction_64
-- reg_a = o1_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100010000110111",
--  (852) square_with_reduction_65
-- reg_a = a2_X; reg_b = a3_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001100000000100100000000000000100001101000011",
--  (853) square_with_reduction_66
-- reg_a = o2_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101010111",
--  (854) square_with_reduction_67
-- reg_a = o3_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001001110111",
--  (855) square_with_reduction_68
-- reg_a = o4_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000000100000110010111",
--  (856) square_with_reduction_69
-- reg_a = a2_X; reg_b = a4_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001100000000100100000100001000100010001000011",
--  (857) square_with_reduction_70
-- reg_a = o2_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100010001010111",
--  (858) square_with_reduction_71
-- reg_a = a3_X; reg_b = a3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101100011",
--  (859) square_with_reduction_72
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101110111",
--  (860) square_with_reduction_73
-- reg_a = o4_X; reg_b = prime2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000001000101010010111",
--  (861) square_with_reduction_74
-- reg_a = a3_X; reg_b = a4_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001100000000100100000100001000100010001100011",
--  (862) square_with_reduction_75
-- reg_a = o3_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100010001110111",
--  (863) square_with_reduction_76
-- reg_a = o4_X; reg_b = prime3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000001101001110010111",
--  (864) square_with_reduction_77
-- reg_a = a4_X; reg_b = a4_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001100000000000100000100001100100010010000011",
--  (865) square_with_reduction_78
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o; o3_X = reg_o; o4_X = reg_o >> 272; operation : a*b + acc;
"000000100001100001110000100000000000010001110010010111",
--  (866) square_with_reduction_79
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (867) square_with_reduction_80
-- -- Other cases
-- reg_a = a0_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001101000000100100000000000000100010000000011",
--  (868) square_with_reduction_81
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o4_X = reg_y; operation : keep accumulator;
"000000100001101000011000110000000100010110000000011011",
--  (869) square_with_reduction_82
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000010000100000000010011",
--  (870) square_with_reduction_83
-- reg_a = o0_X; reg_b = prime5; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001101000000000100000100000000100010100010111",
--  (871) square_with_reduction_84
-- reg_a = a1_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001101000000100100000000000000100010000100011",
--  (872) square_with_reduction_85
-- reg_a = o1_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010000110111",
--  (873) square_with_reduction_86
-- reg_a = a2_X; reg_b = a3_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001101000000100100000000000000100001101000011",
--  (874) square_with_reduction_87
-- reg_a = o2_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101010111",
--  (875) square_with_reduction_88
-- reg_a = o3_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001001110111",
--  (876) square_with_reduction_89
-- reg_a = o4_X; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"001110100001101000000000100000000000000100000110010111",
--  (877) square_with_reduction_90
-- -- In case of size 6
-- reg_a = a0_X; reg_b = a5_X; reg_acc = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001101000000100100000000001000100010100000011",
--  (878) square_with_reduction_91
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o5_X = reg_y; operation : keep accumulator;
"000000100001101000011000110000000100011010100000011011",
--  (879) square_with_reduction_92
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000010000100000000010011",
--  (880) square_with_reduction_93
-- reg_a = a1_X; reg_b = a5_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001101000000100100000100001000100010100100011",
--  (881) square_with_reduction_94
-- reg_a = o1_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010100110111",
--  (882) square_with_reduction_95
-- reg_a = a2_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001101000000100100000000000000100010001000011",
--  (883) square_with_reduction_96
-- reg_a = o2_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010001010111",
--  (884) square_with_reduction_97
-- reg_a = a3_X; reg_b = a3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101100011",
--  (885) square_with_reduction_98
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101110111",
--  (886) square_with_reduction_99
-- reg_a = o4_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001010010111",
--  (887) square_with_reduction_100
-- reg_a = o5_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000000100000110110111",
--  (888) square_with_reduction_101
-- reg_a = a2_X; reg_b = a5_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001101000000100100000100001000100010101000011",
--  (889) square_with_reduction_102
-- reg_a = o2_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010101010111",
--  (890) square_with_reduction_103
-- reg_a = a3_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001101000000100100000000000000100010001100011",
--  (891) square_with_reduction_104
-- reg_a = o3_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010001110111",
--  (892) square_with_reduction_105
-- reg_a = o4_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001110010111",
--  (893) square_with_reduction_106
-- reg_a = o5_X; reg_b = prime2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000001000101010110111",
--  (894) square_with_reduction_107
-- reg_a = a3_X; reg_b = a5_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001101000000100100000100001000100010101100011",
--  (895) square_with_reduction_108
-- reg_a = o3_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010101110111",
--  (896) square_with_reduction_109
-- reg_a = a4_X; reg_b = a4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010010000011",
--  (897) square_with_reduction_110
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010010010111",
--  (898) square_with_reduction_111
-- reg_a = o5_X; reg_b = prime3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000001101001110110111",
--  (899) square_with_reduction_112
-- reg_a = a4_X; reg_b = a5_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001101000000100100000100001000100010110000011",
--  (900) square_with_reduction_113
-- reg_a = o4_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010110010111",
--  (901) square_with_reduction_114
-- reg_a = o5_X; reg_b = prime4; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000010001110010110111",
--  (902) square_with_reduction_115
-- reg_a = a5_X; reg_b = a5_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001101000000000100000100001100100010110100011",
--  (903) square_with_reduction_116
-- reg_a = o5_X; reg_b = prime5; reg_acc = reg_o; o4_X = reg_o; o5_X = reg_o >> 272; operation : a*b + acc;
"000000100001101001110000100000000000010110010110110111",
--  (904) square_with_reduction_117
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (905) square_with_reduction_118
-- -- Other cases
-- reg_a = a0_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010100000011",
--  (906) square_with_reduction_119
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o5_X = reg_y; operation : keep accumulator;
"000000100001110000011000110000000100010110100000011011",
--  (907) square_with_reduction_120
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000010000100000000010011",
--  (908) square_with_reduction_121
-- reg_a = o0_X; reg_b = prime6; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100011000010111",
--  (909) square_with_reduction_122
-- reg_a = a1_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010100100011",
--  (910) square_with_reduction_123
-- reg_a = o1_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010100110111",
--  (911) square_with_reduction_124
-- reg_a = a2_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010001000011",
--  (912) square_with_reduction_125
-- reg_a = o2_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010001010111",
--  (913) square_with_reduction_126
-- reg_a = a3_X; reg_b = a3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001101100011",
--  (914) square_with_reduction_127
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001101110111",
--  (915) square_with_reduction_128
-- reg_a = o4_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001010010111",
--  (916) square_with_reduction_129
-- reg_a = o5_X; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"010011000001110000000000100000000000000100000110110111",
--  (917) square_with_reduction_130
-- -- In case of size 7
-- reg_a = a0_X; reg_b = a6_X; reg_acc = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001110000000100100000000001000100011000000011",
--  (918) square_with_reduction_131
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o6_X = reg_y; operation : keep accumulator;
"000000100001110000011000110000000100011111000000011011",
--  (919) square_with_reduction_132
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000010000100000000010011",
--  (920) square_with_reduction_133
-- reg_a = a1_X; reg_b = a6_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001110000000100100000100001000100011000100011",
--  (921) square_with_reduction_134
-- reg_a = o1_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011000110111",
--  (922) square_with_reduction_135
-- reg_a = a2_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010101000011",
--  (923) square_with_reduction_136
-- reg_a = o2_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101010111",
--  (924) square_with_reduction_137
-- reg_a = a3_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010001100011",
--  (925) square_with_reduction_138
-- reg_a = o3_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010001110111",
--  (926) square_with_reduction_139
-- reg_a = o4_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001110010111",
--  (927) square_with_reduction_140
-- reg_a = o5_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001010110111",
--  (928) square_with_reduction_141
-- reg_a = o6_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000000100000111010111",
--  (929) square_with_reduction_142
-- reg_a = a2_X; reg_b = a6_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001110000000100100000100001000100011001000011",
--  (930) square_with_reduction_143
-- reg_a = o2_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011001010111",
--  (931) square_with_reduction_144
-- reg_a = a3_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010101100011",
--  (932) square_with_reduction_145
-- reg_a = o3_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101110111",
--  (933) square_with_reduction_146
-- reg_a = a4_X; reg_b = a4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010000011",
--  (934) square_with_reduction_147
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010010111",
--  (935) square_with_reduction_148
-- reg_a = o5_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001110110111",
--  (936) square_with_reduction_149
-- reg_a = o6_X; reg_b = prime2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000001000101011010111",
--  (937) square_with_reduction_150
-- reg_a = a3_X; reg_b = a6_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001110000000100100000100001000100011001100011",
--  (938) square_with_reduction_151
-- reg_a = o3_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011001110111",
--  (939) square_with_reduction_152
-- reg_a = a4_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010110000011",
--  (940) square_with_reduction_153
-- reg_a = o4_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110010111",
--  (941) square_with_reduction_154
-- reg_a = o5_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010110111",
--  (942) square_with_reduction_155
-- reg_a = o6_X; reg_b = prime3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000001101001111010111",
--  (943) square_with_reduction_156
-- reg_a = a4_X; reg_b = a6_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001110000000100100000100001000100011010000011",
--  (944) square_with_reduction_157
-- reg_a = o4_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011010010111",
--  (945) square_with_reduction_158
-- reg_a = a5_X; reg_b = a5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110100011",
--  (946) square_with_reduction_159
-- reg_a = o5_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110110111",
--  (947) square_with_reduction_160
-- reg_a = o6_X; reg_b = prime4; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000010001110011010111",
--  (948) square_with_reduction_161
-- reg_a = a5_X; reg_b = a6_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001110000000100100000100001000100011010100011",
--  (949) square_with_reduction_162
-- reg_a = o5_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011010110111",
--  (950) square_with_reduction_163
-- reg_a = o6_X; reg_b = prime5; reg_acc = reg_o; o4_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000010110010111010111",
--  (951) square_with_reduction_164
-- reg_a = a6_X; reg_b = a6_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001110000000000100000100001100100011011000011",
--  (952) square_with_reduction_165
-- reg_a = o6_X; reg_b = prime6; reg_acc = reg_o; o5_X = reg_o; o6_X = reg_o >> 272; operation : a*b + acc;
"000000100001110001110000100000000000011010111011010111",
--  (953) square_with_reduction_166
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (954) square_with_reduction_167
-- -- In case of size 8
-- reg_a = a0_X; reg_b = a6_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100011000000011",
--  (955) square_with_reduction_168
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o6_X = reg_y; operation : keep accumulator;
"000000100001111000011000110000000100011111000000011011",
--  (956) square_with_reduction_169
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000010000100000000010011",
--  (957) square_with_reduction_170
-- reg_a = o0_X; reg_b = prime7; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000000100011100010111",
--  (958) square_with_reduction_171
-- reg_a = a1_X; reg_b = a6_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100011000100011",
--  (959) square_with_reduction_172
-- reg_a = o1_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011000110111",
--  (960) square_with_reduction_173
-- reg_a = a2_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100010101000011",
--  (961) square_with_reduction_174
-- reg_a = o2_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101010111",
--  (962) square_with_reduction_175
-- reg_a = a3_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100010001100011",
--  (963) square_with_reduction_176
-- reg_a = o3_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010001110111",
--  (964) square_with_reduction_177
-- reg_a = o4_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001010010111",
--  (965) square_with_reduction_178
-- reg_a = o5_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001010110111",
--  (966) square_with_reduction_179
-- reg_a = o6_X; reg_b = prime1; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100000111010111",
--  (967) square_with_reduction_180
-- reg_a = a0_X; reg_b = a7_X; reg_acc = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000000001000100011100000011",
--  (968) square_with_reduction_181
-- reg_a = reg_o; reg_b = prime_line_0; reg_acc = reg_o; o7_X = reg_y; operation : keep accumulator;
"000000100001111000011000110000000100000011100000011011",
--  (969) square_with_reduction_182
-- reg_a = reg_y; reg_b = prime0; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000010000100000000010011",
--  (970) square_with_reduction_183
-- reg_a = a1_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000100001000100011100100011",
--  (971) square_with_reduction_184
-- reg_a = o1_X; reg_b = prime7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011100110111",
--  (972) square_with_reduction_185
-- reg_a = a2_X; reg_b = a6_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100011001000011",
--  (973) square_with_reduction_186
-- reg_a = o2_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001010111",
--  (974) square_with_reduction_187
-- reg_a = a3_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100010101100011",
--  (975) square_with_reduction_188
-- reg_a = o3_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101110111",
--  (976) square_with_reduction_189
-- reg_a = a4_X; reg_b = a4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010000011",
--  (977) square_with_reduction_190
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010010111",
--  (978) square_with_reduction_191
-- reg_a = o5_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001110110111",
--  (979) square_with_reduction_192
-- reg_a = o6_X; reg_b = prime2; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001011010111",
--  (980) square_with_reduction_193
-- reg_a = o7_X; reg_b = prime1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000000100000111110111",
--  (981) square_with_reduction_194
-- reg_a = a2_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000100001000100011101000011",
--  (982) square_with_reduction_195
-- reg_a = o2_X; reg_b = prime7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011101010111",
--  (983) square_with_reduction_196
-- reg_a = a3_X; reg_b = a6_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100011001100011",
--  (984) square_with_reduction_197
-- reg_a = o3_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001110111",
--  (985) square_with_reduction_198
-- reg_a = a4_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100010110000011",
--  (986) square_with_reduction_199
-- reg_a = o4_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110010111",
--  (987) square_with_reduction_200
-- reg_a = o5_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010110111",
--  (988) square_with_reduction_201
-- reg_a = o6_X; reg_b = prime3; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001111010111",
--  (989) square_with_reduction_202
-- reg_a = o7_X; reg_b = prime2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000001000101011110111",
--  (990) square_with_reduction_203
-- reg_a = a3_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000100001000100011101100011",
--  (991) square_with_reduction_204
-- reg_a = o3_X; reg_b = prime7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011101110111",
--  (992) square_with_reduction_205
-- reg_a = a4_X; reg_b = a6_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100011010000011",
--  (993) square_with_reduction_206
-- reg_a = o4_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011010010111",
--  (994) square_with_reduction_207
-- reg_a = a5_X; reg_b = a5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110100011",
--  (995) square_with_reduction_208
-- reg_a = o5_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110110111",
--  (996) square_with_reduction_209
-- reg_a = o6_X; reg_b = prime4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010011010111",
--  (997) square_with_reduction_210
-- reg_a = o7_X; reg_b = prime3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000001101001111110111",
--  (998) square_with_reduction_211
-- reg_a = a4_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000100001000100011110000011",
--  (999) square_with_reduction_212
-- reg_a = o4_X; reg_b = prime7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011110010111",
--  (1000) square_with_reduction_213
-- reg_a = a5_X; reg_b = a6_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100011010100011",
--  (1001) square_with_reduction_214
-- reg_a = o5_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011010110111",
--  (1002) square_with_reduction_215
-- reg_a = o6_X; reg_b = prime5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010111010111",
--  (1003) square_with_reduction_216
-- reg_a = o7_X; reg_b = prime4; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000010001110011110111",
--  (1004) square_with_reduction_217
-- reg_a = a5_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000100001000100011110100011",
--  (1005) square_with_reduction_218
-- reg_a = o5_X; reg_b = prime7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011110110111",
--  (1006) square_with_reduction_219
-- reg_a = a6_X; reg_b = a6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011011000011",
--  (1007) square_with_reduction_220
-- reg_a = o6_X; reg_b = prime6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011011010111",
--  (1008) square_with_reduction_221
-- reg_a = o7_X; reg_b = prime5; reg_acc = reg_o; o4_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000010110010111110111",
--  (1009) square_with_reduction_222
-- reg_a = a6_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000100001000100011111000011",
--  (1010) square_with_reduction_223
-- reg_a = o6_X; reg_b = prime7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011111010111",
--  (1011) square_with_reduction_224
-- reg_a = o7_X; reg_b = prime6; reg_acc = reg_o; o5_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000011010111011110111",
--  (1012) square_with_reduction_225
-- reg_a = a7_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001111000000000100000100001100100011111100011",
--  (1013) square_with_reduction_226
-- reg_a = o7_X; reg_b = prime7; reg_acc = reg_o; o6_X = reg_o; o7_X = reg_o >> 272; operation : a*b + acc;
"000000100001111001110000100000000000011111011111110111",
--  (1014) square_with_reduction_227
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (1015) square_with_reduction_special_prime_0
-- -- In case of size 1
-- reg_a = a0_X; reg_b = a0_X; reg_acc = 0; Enable sign a,b; operation : a*b + acc;
"000000100001000000000000100000010001100100000000000011",
--  (1016) square_with_reduction_special_prime_1
-- reg_a = 0; reg_b = 0; reg_acc = reg_o >> 272; o0_X = reg_o; operation : a*b + acc;
"000000100001000000010000100000101110000100000000000011",
--  (1017) square_with_reduction_special_prime_2
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (1018) square_with_reduction_special_prime_3
-- -- In case of size 2, 3, 4
-- reg_a = a0_X; reg_b = a0_X; reg_acc = 0; o0_X = reg_o; operation : a*b + acc;
"000000100001001000010000100000010000000100000000000011",
--  (1019) square_with_reduction_special_prime_4
-- reg_a = reg_o; reg_b = primeSP1; reg_acc = reg_o >> 272; operation : a*b + acc;
"000010100001001000000000100000100100001000100100010111",
--  (1020) square_with_reduction_special_prime_5
-- -- In case of size 2
-- reg_a = a0_X; reg_b = a1_X; reg_acc = reg_o; o1_X = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001001000010100100000000001001000100100000011",
--  (1021) square_with_reduction_special_prime_6
-- reg_a = a1_X; reg_b = a1_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001001000000000100000100001100100000100100011",
--  (1022) square_with_reduction_special_prime_7
-- reg_a = o1_X; reg_b = primeSP1; reg_acc = reg_o; o0_X = reg_o; o1_X = reg_o >> 272; operation : a*b + acc;
"000000100001001001110000100000000000000100000100110111",
--  (1023) square_with_reduction_special_prime_8
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (1024) square_with_reduction_special_prime_9
-- -- In case of size 3, 4
-- reg_a = a0_X; reg_b = a1_X; reg_acc = reg_o; o1_X = reg_o; operation : 2*a*b + acc;
"000000100001010000010100100000000000001000100100000011",
--  (1025) square_with_reduction_special_prime_10
-- reg_a = o0_X; reg_b = primeSP2; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001010000000000100000100000000100001000010111",
--  (1026) square_with_reduction_special_prime_11
-- reg_a = a1_X; reg_b = a1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000000000100000100100011",
--  (1027) square_with_reduction_special_prime_12
-- reg_a = o1_X; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"000100000001010000000000100000000000001101000100110111",
--  (1028) square_with_reduction_special_prime_13
-- -- In case of size 3
-- reg_a = a0_X; reg_b = a2_X; reg_acc = reg_o; o2_X = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001010000010100100000000001001101001000000011",
--  (1029) square_with_reduction_special_prime_14
-- reg_a = a1_X; reg_b = a2_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001010000000100100000100001000100001000100011",
--  (1030) square_with_reduction_special_prime_15
-- reg_a = o1_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001010000000000100000000000000100001000110111",
--  (1031) square_with_reduction_special_prime_16
-- reg_a = o2_X; reg_b = primeSP1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001010000010000100000000000000100000101010111",
--  (1032) square_with_reduction_special_prime_17
-- reg_a = a2_X; reg_b = a2_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001010000000000100000100001100100001001000011",
--  (1033) square_with_reduction_special_prime_18
-- reg_a = o2_X; reg_b = primeSP2; reg_acc = reg_o; o1_X = reg_o; o2_X = reg_o >> 272; operation : a*b + acc;
"000000100001010001110000100000000000001000101001010111",
--  (1034) square_with_reduction_special_prime_19
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (1035) square_with_reduction_special_prime_20
-- -- In case of size 4
-- reg_a = a0_X; reg_b = a2_X; reg_acc = reg_o; o2_X = reg_o; operation : 2*a*b + acc;
"000000100001011000010100100000000000001101001000000011",
--  (1036) square_with_reduction_special_prime_21
-- reg_a = o0_X; reg_b = primeSP3; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001011000000000100000100000000100001100010111",
--  (1037) square_with_reduction_special_prime_22
-- reg_a = a1_X; reg_b = a2_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001011000000100100000000000000100001000100011",
--  (1038) square_with_reduction_special_prime_23
-- reg_a = o1_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001000110111",
--  (1039) square_with_reduction_special_prime_24
-- reg_a = o2_X; reg_b = primeSP1; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100000101010111",
--  (1040) square_with_reduction_special_prime_25
-- reg_a = a0_X; reg_b = a3_X; reg_acc = reg_o; o3_X = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001011000010100100000000001010001101100000011",
--  (1041) square_with_reduction_special_prime_26
-- reg_a = a1_X; reg_b = a3_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001011000000100100000100001000100001100100011",
--  (1042) square_with_reduction_special_prime_27
-- reg_a = o1_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001100110111",
--  (1043) square_with_reduction_special_prime_28
-- reg_a = a2_X; reg_b = a2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001001000011",
--  (1044) square_with_reduction_special_prime_29
-- reg_a = o2_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001001010111",
--  (1045) square_with_reduction_special_prime_30
-- reg_a = o3_X; reg_b = primeSP1; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001011000010000100000000000000100000101110111",
--  (1046) square_with_reduction_special_prime_31
-- reg_a = a2_X; reg_b = a3_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001011000000100100000100001000100001101000011",
--  (1047) square_with_reduction_special_prime_32
-- reg_a = o2_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001011000000000100000000000000100001101010111",
--  (1048) square_with_reduction_special_prime_33
-- reg_a = o3_X; reg_b = primeSP2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001011000010000100000000000001000101001110111",
--  (1049) square_with_reduction_special_prime_34
-- reg_a = a3_X; reg_b = a3_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001011000000000100000100001100100001101100011",
--  (1050) square_with_reduction_special_prime_35
-- reg_a = o3_X; reg_b = primeSP3; reg_acc = reg_o; o2_X = reg_o; o3_X = reg_o >> 272; operation : a*b + acc;
"000000100001011001110000100000000000001101001101110111",
--  (1051) square_with_reduction_special_prime_36
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (1052) square_with_reduction_special_prime_37
-- -- In case of size 5, 6
-- reg_a = a0_X; reg_b = a0_X; reg_acc = 0; o0_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000010000000100000000000011",
--  (1053) square_with_reduction_special_prime_38
-- reg_a = a0_X; reg_b = a1_X; reg_acc = reg_o >> 272; o1_X = reg_o; operation : 2*a*b + acc;
"000000100001100000010100100000100000001000100100000011",
--  (1054) square_with_reduction_special_prime_39
-- reg_a = o0_X; reg_b = primeSP2; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000000100001000010111",
--  (1055) square_with_reduction_special_prime_40
-- reg_a = a1_X; reg_b = a1_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100000100100011",
--  (1056) square_with_reduction_special_prime_41
-- reg_a = a0_X; reg_b = a2_X; reg_acc = reg_o; o2_X = reg_o; operation : 2*a*b + acc;
"000000100001100000010100100000000000001101001000000011",
--  (1057) square_with_reduction_special_prime_42
-- reg_a = o0_X; reg_b = primeSP3; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000000100001100010111",
--  (1058) square_with_reduction_special_prime_43
-- reg_a = a1_X; reg_b = a2_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001100000000100100000000000000100001000100011",
--  (1059) square_with_reduction_special_prime_44
-- reg_a = o1_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001000110111",
--  (1060) square_with_reduction_special_prime_45
-- reg_a = a0_X; reg_b = a3_X; reg_acc = reg_o; o3_X = reg_o; operation : 2*a*b + acc;
"000000100001100000010100100000000000010001101100000011",
--  (1061) square_with_reduction_special_prime_46
-- reg_a = o0_X; reg_b = primeSP4; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001100000000000100000100000000100010000010111",
--  (1062) square_with_reduction_special_prime_47
-- reg_a = a1_X; reg_b = a3_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001100000000100100000000000000100001100100011",
--  (1063) square_with_reduction_special_prime_48
-- reg_a = o1_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001100110111",
--  (1064) square_with_reduction_special_prime_49
-- reg_a = a2_X; reg_b = a2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001001000011",
--  (1065) square_with_reduction_special_prime_50
-- reg_a = o2_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"001001000001100000000000100000000000000100001001010111",
--  (1066) square_with_reduction_special_prime_51
-- -- In case of size 5
-- reg_a = a0_X; reg_b = a4_X; reg_acc = reg_o; o4_X = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001100000010100100000000001010110010000000011",
--  (1067) square_with_reduction_special_prime_52
-- reg_a = a1_X; reg_b = a4_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001100000000100100000100001000100010000100011",
--  (1068) square_with_reduction_special_prime_53
-- reg_a = o1_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100010000110111",
--  (1069) square_with_reduction_special_prime_54
-- reg_a = a2_X; reg_b = a3_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001100000000100100000000000000100001101000011",
--  (1070) square_with_reduction_special_prime_55
-- reg_a = o2_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101010111",
--  (1071) square_with_reduction_special_prime_56
-- reg_a = o3_X; reg_b = primeSP2; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000000100001001110111",
--  (1072) square_with_reduction_special_prime_57
-- reg_a = a2_X; reg_b = a4_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001100000000100100000100001000100010001000011",
--  (1073) square_with_reduction_special_prime_58
-- reg_a = o2_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100010001010111",
--  (1074) square_with_reduction_special_prime_59
-- reg_a = a3_X; reg_b = a3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101100011",
--  (1075) square_with_reduction_special_prime_60
-- reg_a = o3_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100001101110111",
--  (1076) square_with_reduction_special_prime_61
-- reg_a = o4_X; reg_b = primeSP2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000001000101010010111",
--  (1077) square_with_reduction_special_prime_62
-- reg_a = a3_X; reg_b = a4_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001100000000100100000100001000100010001100011",
--  (1078) square_with_reduction_special_prime_63
-- reg_a = o3_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001100000000000100000000000000100010001110111",
--  (1079) square_with_reduction_special_prime_64
-- reg_a = o4_X; reg_b = primeSP3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001100000010000100000000000001101001110010111",
--  (1080) square_with_reduction_special_prime_65
-- reg_a = a4_X; reg_b = a4_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001100000000000100000100001100100010010000011",
--  (1081) square_with_reduction_special_prime_66
-- reg_a = o4_X; reg_b = primeSP4; reg_acc = reg_o; o3_X = reg_o; o4_X = reg_o >> 272; operation : a*b + acc;
"000000100001100001110000100000000000010001110010010111",
--  (1082) square_with_reduction_special_prime_67
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (1083) square_with_reduction_special_prime_68
-- -- In case of size 6
-- reg_a = a0_X; reg_b = a4_X; reg_acc = reg_o; o4_X = reg_o; operation : 2*a*b + acc;
"000000100001101000010100100000000000010110010000000011",
--  (1084) square_with_reduction_special_prime_69
-- reg_a = o0_X; reg_b = primeSP5; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001101000000000100000100000000100010100010111",
--  (1085) square_with_reduction_special_prime_70
-- reg_a = a1_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001101000000100100000000000000100010000100011",
--  (1086) square_with_reduction_special_prime_71
-- reg_a = o1_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010000110111",
--  (1087) square_with_reduction_special_prime_72
-- reg_a = a2_X; reg_b = a3_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001101000000100100000000000000100001101000011",
--  (1088) square_with_reduction_special_prime_73
-- reg_a = o2_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101010111",
--  (1089) square_with_reduction_special_prime_74
-- reg_a = o3_X; reg_b = primeSP2; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001001110111",
--  (1090) square_with_reduction_special_prime_75
-- reg_a = a0_X; reg_b = a5_X; reg_acc = reg_o; o5_X = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001101000010100100000000001011010110100000011",
--  (1091) square_with_reduction_special_prime_76
-- reg_a = a1_X; reg_b = a5_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001101000000100100000100001000100010100100011",
--  (1092) square_with_reduction_special_prime_77
-- reg_a = o1_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010100110111",
--  (1093) square_with_reduction_special_prime_78
-- reg_a = a2_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001101000000100100000000000000100010001000011",
--  (1094) square_with_reduction_special_prime_79
-- reg_a = o2_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010001010111",
--  (1095) square_with_reduction_special_prime_80
-- reg_a = a3_X; reg_b = a3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101100011",
--  (1096) square_with_reduction_special_prime_81
-- reg_a = o3_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001101110111",
--  (1097) square_with_reduction_special_prime_82
-- reg_a = o4_X; reg_b = primeSP2; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000000100001010010111",
--  (1098) square_with_reduction_special_prime_83
-- reg_a = a2_X; reg_b = a5_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001101000000100100000100001000100010101000011",
--  (1099) square_with_reduction_special_prime_84
-- reg_a = o2_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010101010111",
--  (1100) square_with_reduction_special_prime_85
-- reg_a = a3_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001101000000100100000000000000100010001100011",
--  (1101) square_with_reduction_special_prime_86
-- reg_a = o3_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010001110111",
--  (1102) square_with_reduction_special_prime_87
-- reg_a = o4_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100001110010111",
--  (1103) square_with_reduction_special_prime_88
-- reg_a = o5_X; reg_b = primeSP2; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000001000101010110111",
--  (1104) square_with_reduction_special_prime_89
-- reg_a = a3_X; reg_b = a5_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001101000000100100000100001000100010101100011",
--  (1105) square_with_reduction_special_prime_90
-- reg_a = o3_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010101110111",
--  (1106) square_with_reduction_special_prime_91
-- reg_a = a4_X; reg_b = a4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010010000011",
--  (1107) square_with_reduction_special_prime_92
-- reg_a = o4_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010010010111",
--  (1108) square_with_reduction_special_prime_93
-- reg_a = o5_X; reg_b = primeSP3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000001101001110110111",
--  (1109) square_with_reduction_special_prime_94
-- reg_a = a4_X; reg_b = a5_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001101000000100100000100001000100010110000011",
--  (1110) square_with_reduction_special_prime_95
-- reg_a = o4_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001101000000000100000000000000100010110010111",
--  (1111) square_with_reduction_special_prime_96
-- reg_a = o5_X; reg_b = primeSP4; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001101000010000100000000000010001110010110111",
--  (1112) square_with_reduction_special_prime_97
-- reg_a = a5_X; reg_b = a5_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001101000000000100000100001100100010110100011",
--  (1113) square_with_reduction_special_prime_98
-- reg_a = o5_X; reg_b = primeSP5; reg_acc = reg_o; o4_X = reg_o; o5_X = reg_o >> 272; operation : a*b + acc;
"000000100001101001110000100000000000010110010110110111",
--  (1114) square_with_reduction_special_prime_99
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (1115) square_with_reduction_special_prime_100
-- -- In case of size 7, 8
-- reg_a = a0_X; reg_b = a0_X; reg_acc = 0; o0_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000010000000100000000000011",
--  (1116) square_with_reduction_special_prime_101
-- reg_a = a0_X; reg_b = a1_X; reg_acc = reg_o >> 272; o1_X = reg_o; operation : 2*a*b + acc;
"000000100001110000010100100000100000001000100100000011",
--  (1117) square_with_reduction_special_prime_102
-- reg_a = a1_X; reg_b = a1_X; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100000100100011",
--  (1118) square_with_reduction_special_prime_103
-- reg_a = a0_X; reg_b = a2_X; reg_acc = reg_o; o2_X = reg_o; operation : 2*a*b + acc;
"000000100001110000010100100000000000001101001000000011",
--  (1119) square_with_reduction_special_prime_104
-- reg_a = o0_X; reg_b = primeSP3; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100001100010111",
--  (1120) square_with_reduction_special_prime_105
-- reg_a = a1_X; reg_b = a2_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100001000100011",
--  (1121) square_with_reduction_special_prime_106
-- reg_a = a0_X; reg_b = a3_X; reg_acc = reg_o; o3_X = reg_o; operation : 2*a*b + acc;
"000000100001110000010100100000000000010001101100000011",
--  (1122) square_with_reduction_special_prime_107
-- reg_a = o0_X; reg_b = primeSP4; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100010000010111",
--  (1123) square_with_reduction_special_prime_108
-- reg_a = a1_X; reg_b = a3_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100001100100011",
--  (1124) square_with_reduction_special_prime_109
-- reg_a = o1_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001100110111",
--  (1125) square_with_reduction_special_prime_110
-- reg_a = a2_X; reg_b = a2_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001001000011",
--  (1126) square_with_reduction_special_prime_111
-- reg_a = a0_X; reg_b = a4_X; reg_acc = reg_o; o4_X = reg_o; operation : 2*a*b + acc;
"000000100001110000010100100000000000010110010000000011",
--  (1127) square_with_reduction_special_prime_112
-- reg_a = o0_X; reg_b = primeSP5; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100010100010111",
--  (1128) square_with_reduction_special_prime_113
-- reg_a = a1_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010000100011",
--  (1129) square_with_reduction_special_prime_114
-- reg_a = o1_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010000110111",
--  (1130) square_with_reduction_special_prime_115
-- reg_a = a2_X; reg_b = a3_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100001101000011",
--  (1131) square_with_reduction_special_prime_116
-- reg_a = o2_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001101010111",
--  (1132) square_with_reduction_special_prime_117
-- reg_a = a0_X; reg_b = a5_X; reg_acc = reg_o; o5_X = reg_o; operation : 2*a*b + acc;
"000000100001110000010100100000000000011010110100000011",
--  (1133) square_with_reduction_special_prime_118
-- reg_a = o0_X; reg_b = primeSP6; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001110000000000100000100000000100011000010111",
--  (1134) square_with_reduction_special_prime_119
-- reg_a = a1_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010100100011",
--  (1135) square_with_reduction_special_prime_120
-- reg_a = o1_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010100110111",
--  (1136) square_with_reduction_special_prime_121
-- reg_a = a2_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010001000011",
--  (1137) square_with_reduction_special_prime_122
-- reg_a = o2_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010001010111",
--  (1138) square_with_reduction_special_prime_123
-- reg_a = a3_X; reg_b = a3_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100001101100011",
--  (1139) square_with_reduction_special_prime_124
-- reg_a = o3_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"010000100001110000000000100000000000000100001101110111",
--  (1140) square_with_reduction_special_prime_125
-- -- In case of size 7
-- reg_a = a0_X; reg_b = a6_X; reg_acc = reg_o; o6_X = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001110000010100100000000001011111011000000011",
--  (1141) square_with_reduction_special_prime_126
-- reg_a = a1_X; reg_b = a6_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001110000000100100000100001000100011000100011",
--  (1142) square_with_reduction_special_prime_127
-- reg_a = o1_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011000110111",
--  (1143) square_with_reduction_special_prime_128
-- reg_a = a2_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010101000011",
--  (1144) square_with_reduction_special_prime_129
-- reg_a = o2_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101010111",
--  (1145) square_with_reduction_special_prime_130
-- reg_a = a3_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010001100011",
--  (1146) square_with_reduction_special_prime_131
-- reg_a = o3_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010001110111",
--  (1147) square_with_reduction_special_prime_132
-- reg_a = o4_X; reg_b = primeSP3; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000000100001110010111",
--  (1148) square_with_reduction_special_prime_133
-- reg_a = a2_X; reg_b = a6_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001110000000100100000100001000100011001000011",
--  (1149) square_with_reduction_special_prime_134
-- reg_a = o2_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011001010111",
--  (1150) square_with_reduction_special_prime_135
-- reg_a = a3_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010101100011",
--  (1151) square_with_reduction_special_prime_136
-- reg_a = o3_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010101110111",
--  (1152) square_with_reduction_special_prime_137
-- reg_a = a4_X; reg_b = a4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010000011",
--  (1153) square_with_reduction_special_prime_138
-- reg_a = o4_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010010111",
--  (1154) square_with_reduction_special_prime_139
-- reg_a = o5_X; reg_b = primeSP3; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000001000101110110111",
--  (1155) square_with_reduction_special_prime_140
-- reg_a = a3_X; reg_b = a6_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001110000000100100000100001000100011001100011",
--  (1156) square_with_reduction_special_prime_141
-- reg_a = o3_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011001110111",
--  (1157) square_with_reduction_special_prime_142
-- reg_a = a4_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001110000000100100000000000000100010110000011",
--  (1158) square_with_reduction_special_prime_143
-- reg_a = o4_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110010111",
--  (1159) square_with_reduction_special_prime_144
-- reg_a = o5_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010010110111",
--  (1160) square_with_reduction_special_prime_145
-- reg_a = o6_X; reg_b = primeSP3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000001101001111010111",
--  (1161) square_with_reduction_special_prime_146
-- reg_a = a4_X; reg_b = a6_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001110000000100100000100001000100011010000011",
--  (1162) square_with_reduction_special_prime_147
-- reg_a = o4_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011010010111",
--  (1163) square_with_reduction_special_prime_148
-- reg_a = a5_X; reg_b = a5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110100011",
--  (1164) square_with_reduction_special_prime_149
-- reg_a = o5_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100010110110111",
--  (1165) square_with_reduction_special_prime_150
-- reg_a = o6_X; reg_b = primeSP4; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000010001110011010111",
--  (1166) square_with_reduction_special_prime_151
-- reg_a = a5_X; reg_b = a6_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001110000000100100000100001000100011010100011",
--  (1167) square_with_reduction_special_prime_152
-- reg_a = o5_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001110000000000100000000000000100011010110111",
--  (1168) square_with_reduction_special_prime_153
-- reg_a = o6_X; reg_b = primeSP5; reg_acc = reg_o; o4_X = reg_o; operation : a*b + acc;
"000000100001110000010000100000000000010110010111010111",
--  (1169) square_with_reduction_special_prime_154
-- reg_a = a6_X; reg_b = a6_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001110000000000100000100001100100011011000011",
--  (1170) square_with_reduction_special_prime_155
-- reg_a = o6_X; reg_b = primeSP6; reg_acc = reg_o; o5_X = reg_o; o6_X = reg_o >> 272; operation : a*b + acc;
"000000100001110001110000100000000000011010111011010111",
--  (1171) square_with_reduction_special_prime_156
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (1172) square_with_reduction_special_prime_157
-- -- In case of size 8
-- reg_a = a0_X; reg_b = a6_X; reg_acc = reg_o; o6_X = reg_o; operation : 2*a*b + acc;
"000000100001111000010100100000000000011011011000000011",
--  (1173) square_with_reduction_special_prime_158
-- reg_a = o0_X; reg_b = primeSP7; reg_acc = reg_o >> 272; operation : a*b + acc;
"000000100001111000000000100000100000000100011100010111",
--  (1174) square_with_reduction_special_prime_159
-- reg_a = a1_X; reg_b = a6_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100011000100011",
--  (1175) square_with_reduction_special_prime_160
-- reg_a = o1_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011000110111",
--  (1176) square_with_reduction_special_prime_161
-- reg_a = a2_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100010101000011",
--  (1177) square_with_reduction_special_prime_162
-- reg_a = o2_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101010111",
--  (1178) square_with_reduction_special_prime_163
-- reg_a = a3_X; reg_b = a4_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100010001100011",
--  (1179) square_with_reduction_special_prime_164
-- reg_a = o3_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010001110111",
--  (1180) square_with_reduction_special_prime_165
-- reg_a = o4_X; reg_b = primeSP3; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100001110010111",
--  (1181) square_with_reduction_special_prime_166
-- reg_a = a0_X; reg_b = a7_X; reg_acc = reg_o; o7_X = reg_o; Enable sign b; operation : 2*a*b + acc;
"000000100001111000010100100000000001011111111100000011",
--  (1182) square_with_reduction_special_prime_167
-- reg_a = a1_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000100001000100011100100011",
--  (1183) square_with_reduction_special_prime_168
-- reg_a = o1_X; reg_b = primeSP7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011100110111",
--  (1184) square_with_reduction_special_prime_169
-- reg_a = a2_X; reg_b = a6_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100011001000011",
--  (1185) square_with_reduction_special_prime_170
-- reg_a = o2_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001010111",
--  (1186) square_with_reduction_special_prime_171
-- reg_a = a3_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100010101100011",
--  (1187) square_with_reduction_special_prime_172
-- reg_a = o3_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010101110111",
--  (1188) square_with_reduction_special_prime_173
-- reg_a = a4_X; reg_b = a4_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010000011",
--  (1189) square_with_reduction_special_prime_174
-- reg_a = o4_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010010111",
--  (1190) square_with_reduction_special_prime_175
-- reg_a = o5_X; reg_b = primeSP3; reg_acc = reg_o; o0_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000000100001110110111",
--  (1191) square_with_reduction_special_prime_176
-- reg_a = a2_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000100001000100011101000011",
--  (1192) square_with_reduction_special_prime_177
-- reg_a = o2_X; reg_b = primeSP7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011101010111",
--  (1193) square_with_reduction_special_prime_178
-- reg_a = a3_X; reg_b = a6_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100011001100011",
--  (1194) square_with_reduction_special_prime_179
-- reg_a = o3_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011001110111",
--  (1195) square_with_reduction_special_prime_180
-- reg_a = a4_X; reg_b = a5_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100010110000011",
--  (1196) square_with_reduction_special_prime_181
-- reg_a = o4_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110010111",
--  (1197) square_with_reduction_special_prime_182
-- reg_a = o5_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010010110111",
--  (1198) square_with_reduction_special_prime_183
-- reg_a = o6_X; reg_b = primeSP3; reg_acc = reg_o; o1_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000001000101111010111",
--  (1199) square_with_reduction_special_prime_184
-- reg_a = a3_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000100001000100011101100011",
--  (1200) square_with_reduction_special_prime_185
-- reg_a = o3_X; reg_b = primeSP7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011101110111",
--  (1201) square_with_reduction_special_prime_186
-- reg_a = a4_X; reg_b = a6_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100011010000011",
--  (1202) square_with_reduction_special_prime_187
-- reg_a = o4_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011010010111",
--  (1203) square_with_reduction_special_prime_188
-- reg_a = a5_X; reg_b = a5_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110100011",
--  (1204) square_with_reduction_special_prime_189
-- reg_a = o5_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010110110111",
--  (1205) square_with_reduction_special_prime_190
-- reg_a = o6_X; reg_b = primeSP4; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010011010111",
--  (1206) square_with_reduction_special_prime_191
-- reg_a = o7_X; reg_b = primeSP3; reg_acc = reg_o; o2_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000001101001111110111",
--  (1207) square_with_reduction_special_prime_192
-- reg_a = a4_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000100001000100011110000011",
--  (1208) square_with_reduction_special_prime_193
-- reg_a = o4_X; reg_b = primeSP7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011110010111",
--  (1209) square_with_reduction_special_prime_194
-- reg_a = a5_X; reg_b = a6_X; reg_acc = reg_o; operation : 2*a*b + acc;
"000000100001111000000100100000000000000100011010100011",
--  (1210) square_with_reduction_special_prime_195
-- reg_a = o5_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011010110111",
--  (1211) square_with_reduction_special_prime_196
-- reg_a = o6_X; reg_b = primeSP5; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100010111010111",
--  (1212) square_with_reduction_special_prime_197
-- reg_a = o7_X; reg_b = primeSP4; reg_acc = reg_o; o3_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000010001110011110111",
--  (1213) square_with_reduction_special_prime_198
-- reg_a = a5_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000100001000100011110100011",
--  (1214) square_with_reduction_special_prime_199
-- reg_a = o5_X; reg_b = primeSP7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011110110111",
--  (1215) square_with_reduction_special_prime_200
-- reg_a = a6_X; reg_b = a6_X; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011011000011",
--  (1216) square_with_reduction_special_prime_201
-- reg_a = o6_X; reg_b = primeSP6; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011011010111",
--  (1217) square_with_reduction_special_prime_202
-- reg_a = o7_X; reg_b = primeSP5; reg_acc = reg_o; o4_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000010110010111110111",
--  (1218) square_with_reduction_special_prime_203
-- reg_a = a6_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign b; operation : 2*a*b + acc;
"000000100001111000000100100000100001000100011111000011",
--  (1219) square_with_reduction_special_prime_204
-- reg_a = o6_X; reg_b = primeSP7; reg_acc = reg_o; operation : a*b + acc;
"000000100001111000000000100000000000000100011111010111",
--  (1220) square_with_reduction_special_prime_205
-- reg_a = o7_X; reg_b = primeSP6; reg_acc = reg_o; o5_X = reg_o; operation : a*b + acc;
"000000100001111000010000100000000000011010111011110111",
--  (1221) square_with_reduction_special_prime_206
-- reg_a = a7_X; reg_b = a7_X; reg_acc = reg_o >> 272; Enable sign a,b; operation : a*b + acc;
"000000100001111000000000100000100001100100011111100011",
--  (1222) square_with_reduction_special_prime_207
-- reg_a = o7_X; reg_b = primeSP7; reg_acc = reg_o; o6_X = reg_o; o7_X = reg_o >> 272; operation : a*b + acc;
"000000100001111001110000100000000000011111011111110111",
--  (1223) square_with_reduction_special_prime_208
-- NOP 8 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : a*b + acc;
"000000000000000100000000100000011110000100000000000011",
--  (1224) addition_subtraction_direct_0
-- -- In case of size 1
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_0 = reg_o; Enable sign a,b; operation : b +/- a + acc;
"000000100001000000010000001000010001100100000000000010",
--  (1225) addition_subtraction_direct_1
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1226) addition_subtraction_direct_2
-- -- In case of size 2, 3, 4, 5, 6, 7, 8
-- reg_a = a0_X; reg_b = b0_X; reg_acc = 0; o0_X = reg_o; operation : b +/- a + acc;
"000001100001001000010000001000010000000100000000000010",
--  (1227) addition_subtraction_direct_3
-- -- In case of size 2
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o >> 272; o1_X = reg_o; Enable sign a, b; operation : b +/- a + acc;
"000000100001001000010000001000100001101000100100100010",
--  (1228) addition_subtraction_direct_4
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1229) addition_subtraction_direct_5
-- -- In case of size 3, 4, 5, 6, 7, 8
-- reg_a = a1_X; reg_b = b1_X; reg_acc = reg_o >> 272; o1_X = reg_o; operation : b +/- a + acc;
"000001100001010000010000001000100000001000100100100010",
--  (1230) addition_subtraction_direct_6
-- -- In case of size 3
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o >> 272; o2_X = reg_o; Enable sign a,b; operation : b +/- a + acc;
"000000100001010000010000001000100001100101001001000010",
--  (1231) addition_subtraction_direct_7
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1232) addition_subtraction_direct_8
-- -- In case of size 4, 5, 6, 7, 8
-- reg_a = a2_X; reg_b = b2_X; reg_acc = reg_o >> 272; o2_X = reg_o; operation : b +/- a + acc;
"000001100001011000010000001000100000000101001001000010",
--  (1233) addition_subtraction_direct_9
-- -- In case of size 4
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o >> 272; o3_X = reg_o; Enable sign a,b; operation : b +/- a + acc;
"000000100001011000010000001000100001110001101101100010",
--  (1234) addition_subtraction_direct_10
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1235) addition_subtraction_direct_11
-- -- In case of size 4, 5, 6, 7, 8
-- reg_a = a3_X; reg_b = b3_X; reg_acc = reg_o >> 272; o3_X = reg_o; operation : b +/- a + acc;
"000001100001100000010000001000100000010001101101100010",
--  (1236) addition_subtraction_direct_12
-- -- In case of size 5
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o >> 272; o4_X = reg_o; Enable sign a,b; operation : b +/- a + acc;
"000000100001100000010000001000100001110110010010000010",
--  (1237) addition_subtraction_direct_13
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1238) addition_subtraction_direct_14
-- -- In case of size 6, 7, 8
-- reg_a = a4_X; reg_b = b4_X; reg_acc = reg_o >> 272; o4_X = reg_o; operation : b +/- a + acc;
"000001100001101000010000001000100000010110010010000010",
--  (1239) addition_subtraction_direct_15
-- -- In case of size 6
-- reg_a = a5_X; reg_b = b5_X; reg_acc = reg_o >> 272; o5_X = reg_o; Enable sign a,b; operation : b +/- a + acc;
"000000100001101000010000001000100001111010110110100010",
--  (1240) addition_subtraction_direct_16
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1241) addition_subtraction_direct_17
-- -- In case of size 7, 8
-- reg_a = a5_X; reg_b = b5_X; reg_acc = reg_o >> 272; o5_X = reg_o; operation : b +/- a + acc;
"000001100001110000010000001000100000011010110110100010",
--  (1242) addition_subtraction_direct_18
-- -- In case of size 7
-- reg_a = a6_X; reg_b = b6_X; reg_acc = reg_o >> 272; o6_X = reg_o; Enable sign a,b; operation : b +/- a + acc;
"000000100001110000010000001000100001111111011011000010",
--  (1243) addition_subtraction_direct_19
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1244) addition_subtraction_direct_20
-- -- In case of size 8
-- reg_a = a6_X; reg_b = b6_X; reg_acc = reg_o >> 272; o6_X = reg_o; operation : b +/- a + acc;
"000000100001111000010000001000100000011111011011000010",
--  (1245) addition_subtraction_direct_21
-- reg_a = a7_X; reg_b = b7_X; reg_acc = reg_o >> 272; o7_X = reg_o; Enable sign a,b; operation : b +/- a + acc;
"000000100001111000010000001000100001100011111111100010",
--  (1246) addition_subtraction_direct_22
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1247) iterative_modular_reduction_0
-- -- In case of size 1
-- reg_a = a0_X; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"000000100001000000000000010000011001100100000000010010",
--  (1248) iterative_modular_reduction_1
-- reg_a = 0; reg_b = prime0; reg_acc = reg_o; reg_s = reg_o_positive; Enable sign a,b; operation : -s*b + a + acc
"000000100001000000000011000111000111100100000000010010",
--  (1249) iterative_modular_reduction_2
-- reg_a = 0; reg_b = prime0; reg_acc = reg_o; reg_s = reg_o_negative; Enable sign a,b; operation : s*b + a + acc
"000000100001000000000001010011000111100100000000010010",
--  (1250) iterative_modular_reduction_3
-- reg_a = 0; reg_b = prime0; reg_acc = reg_o; o0_X = reg_o; reg_s = reg_o_negative; Enable sign a,b; operation : s*b + a + acc
"000000100001000000010001010011000111100100000000010010",
--  (1251) iterative_modular_reduction_4
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1252) iterative_modular_reduction_5
-- -- In case of size 2
-- reg_a = a1_X; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"000000100001001000000000010000011001100100000000110010",
--  (1253) iterative_modular_reduction_6
-- reg_a = a0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"000000100001001000010011000111010000000100000000010010",
--  (1254) iterative_modular_reduction_7
-- reg_a = a1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; Enable sign a,b; operation : -s*b + a + acc
"000000100001001000010011000000100001101000100100110010",
--  (1255) iterative_modular_reduction_8
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001001000010001010011010000000100000000010110",
--  (1256) iterative_modular_reduction_9
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; Enable sign a,b operation : s*b + a + acc
"000000100001001000010001010000100001101000100100110110",
--  (1257) iterative_modular_reduction_10
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001001000010001010011010000000100000000010110",
--  (1258) iterative_modular_reduction_11
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; Enable sign a,b operation : s*b + a + acc
"000000100001001000010001010000100001101000100100110110",
--  (1259) iterative_modular_reduction_12
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1260) iterative_modular_reduction_13
-- -- In case of size 3
-- reg_a = a2_X; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"000000100001010000000000010000011001101101001001010010",
--  (1261) iterative_modular_reduction_14
-- reg_a = a0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"000000100001010000010011000111010000000100000000010010",
--  (1262) iterative_modular_reduction_15
-- reg_a = a1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : -s*b + a + acc
"000000100001010000010011000000100000001000100100110010",
--  (1263) iterative_modular_reduction_16
-- reg_a = a2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; Enable sign a,b; operation : -s*b + a + acc
"000000100001010000010011000000100001101101001001010010",
--  (1264) iterative_modular_reduction_17
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001010000010001010011010000000100000000010110",
--  (1265) iterative_modular_reduction_18
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : s*b + a + acc
"000000100001010000010001010000100000001000100100110110",
--  (1266) iterative_modular_reduction_19
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; Enable sign a,b operation : s*b + a + acc
"000000100001010000010001010000100001101101001001010110",
--  (1267) iterative_modular_reduction_20
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001010000010001010011010000000100000000010110",
--  (1268) iterative_modular_reduction_21
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : s*b + a + acc
"000000100001010000010001010000100000001000100100110110",
--  (1269) iterative_modular_reduction_22
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; Enable sign a,b operation : s*b + a + acc
"000000100001010000010001010000100001101101001001010110",
--  (1270) iterative_modular_reduction_23
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1271) iterative_modular_reduction_24
-- -- In case of size 4
-- reg_a = a3_X; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"000000100001011000000000010000011001100001101101110010",
--  (1272) iterative_modular_reduction_25
-- reg_a = a0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"000000100001011000010011000111010000000100000000010010",
--  (1273) iterative_modular_reduction_26
-- reg_a = a1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : -s*b + a + acc
"000000100001011000010011000000100000001000100100110010",
--  (1274) iterative_modular_reduction_27
-- reg_a = a2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : -s*b + a + acc
"000000100001011000010011000000100000001101001001010010",
--  (1275) iterative_modular_reduction_28
-- reg_a = a3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; Enable sign a,b; operation : -s*b + a + acc
"000000100001011000010011000000100001100001101101110010",
--  (1276) iterative_modular_reduction_29
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001011000010001010011010000000100000000010110",
--  (1277) iterative_modular_reduction_30
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : s*b + a + acc
"000000100001011000010001010000100000001000100100110110",
--  (1278) iterative_modular_reduction_31
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : s*b + a + acc
"000000100001011000010001010000100000001101001001010110",
--  (1279) iterative_modular_reduction_32
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; Enable sign a,b; operation : s*b + a + acc
"000000100001011000010001010000100001100001101101110110",
--  (1280) iterative_modular_reduction_33
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001011000010001010011010000000100000000010110",
--  (1281) iterative_modular_reduction_34
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : s*b + a + acc
"000000100001011000010001010000100000001000100100110110",
--  (1282) iterative_modular_reduction_35
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : s*b + a + acc
"000000100001011000010001010000100000001101001001010110",
--  (1283) iterative_modular_reduction_36
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; Enable sign a,b; operation : s*b + a + acc
"000000100001011000010001010000100001100001101101110110",
--  (1284) iterative_modular_reduction_37
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1285) iterative_modular_reduction_38
-- -- In case of size 5
-- reg_a = a4_X; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"000000100001100000000000010000011001110110010010010010",
--  (1286) iterative_modular_reduction_39
-- reg_a = a0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"000000100001100000010011000111010000000100000000010010",
--  (1287) iterative_modular_reduction_40
-- reg_a = a1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : -s*b + a + acc
"000000100001100000010011000000100000001000100100110010",
--  (1288) iterative_modular_reduction_41
-- reg_a = a2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : -s*b + a + acc
"000000100001100000010011000000100000001101001001010010",
--  (1289) iterative_modular_reduction_42
-- reg_a = a3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; operation : -s*b + a + acc
"000000100001100000010011000000100000010001101101110010",
--  (1290) iterative_modular_reduction_43
-- reg_a = a4_X; reg_b = prime4; reg_acc = reg_o >> 272; o4_X = reg_o; Enable sign a,b; operation : -s*b + a + acc
"000000100001100000010011000000100001110110010010010010",
--  (1291) iterative_modular_reduction_44
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001100000010001010011010000000100000000010110",
--  (1292) iterative_modular_reduction_45
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : s*b + a + acc
"000000100001100000010001010000100000001000100100110110",
--  (1293) iterative_modular_reduction_46
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : s*b + a + acc
"000000100001100000010001010000100000001101001001010110",
--  (1294) iterative_modular_reduction_47
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; operation : s*b + a + acc
"000000100001100000010001010000100000010001101101110110",
--  (1295) iterative_modular_reduction_48
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o >> 272; o4_X = reg_o; Enable sign a,b; operation : s*b + a + acc
"000000100001100000010001010000100001110110010010010110",
--  (1296) iterative_modular_reduction_49
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001100000010001010011010000000100000000010110",
--  (1297) iterative_modular_reduction_50
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : s*b + a + acc
"000000100001100000010001010000100000001000100100110110",
--  (1298) iterative_modular_reduction_51
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : s*b + a + acc
"000000100001100000010001010000100000001101001001010110",
--  (1299) iterative_modular_reduction_52
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; operation : s*b + a + acc
"000000100001100000010001010000100000010001101101110110",
--  (1300) iterative_modular_reduction_53
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o >> 272; o4_X = reg_o; Enable sign a,b; operation : s*b + a + acc
"000000100001100000010001010000100001110110010010010110",
--  (1301) iterative_modular_reduction_54
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1302) iterative_modular_reduction_55
-- -- In case of size 6
-- reg_a = a5_X; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"000000100001101000000000010000011001111010110110110010",
--  (1303) iterative_modular_reduction_56
-- reg_a = a0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"000000100001101000010011000111010000000100000000010010",
--  (1304) iterative_modular_reduction_57
-- reg_a = a1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : -s*b + a + acc
"000000100001101000010011000000100000001000100100110010",
--  (1305) iterative_modular_reduction_58
-- reg_a = a2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : -s*b + a + acc
"000000100001101000010011000000100000001101001001010010",
--  (1306) iterative_modular_reduction_59
-- reg_a = a3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; operation : -s*b + a + acc
"000000100001101000010011000000100000010001101101110010",
--  (1307) iterative_modular_reduction_60
-- reg_a = a4_X; reg_b = prime4; reg_acc = reg_o >> 272; o4_X = reg_o; operation : -s*b + a + acc
"000000100001101000010011000000100000010110010010010010",
--  (1308) iterative_modular_reduction_61
-- reg_a = a5_X; reg_b = prime5; reg_acc = reg_o >> 272; o5_X = reg_o; Enable sign a,b; operation : -s*b + a + acc
"000000100001101000010011000000100001111010110110110010",
--  (1309) iterative_modular_reduction_62
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001101000010001010011010000000100000000010110",
--  (1310) iterative_modular_reduction_63
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : s*b + a + acc
"000000100001101000010001010000100000001000100100110110",
--  (1311) iterative_modular_reduction_64
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : s*b + a + acc
"000000100001101000010001010000100000001101001001010110",
--  (1312) iterative_modular_reduction_65
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; operation : s*b + a + acc
"000000100001101000010001010000100000010001101101110110",
--  (1313) iterative_modular_reduction_66
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o >> 272; o4_X = reg_o; operation : s*b + a + acc
"000000100001101000010001010000100000010110010010010110",
--  (1314) iterative_modular_reduction_67
-- reg_a = o5_X; reg_b = prime5; reg_acc = reg_o >> 272; o5_X = reg_o; Enable sign a,b; operation : s*b + a + acc
"000000100001101000010001010000100001111010110110110110",
--  (1315) iterative_modular_reduction_68
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001101000010001010011010000000100000000010110",
--  (1316) iterative_modular_reduction_69
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : s*b + a + acc
"000000100001101000010001010000100000001000100100110110",
--  (1317) iterative_modular_reduction_70
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : s*b + a + acc
"000000100001101000010001010000100000001101001001010110",
--  (1318) iterative_modular_reduction_71
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; operation : s*b + a + acc
"000000100001101000010001010000100000010001101101110110",
--  (1319) iterative_modular_reduction_72
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o >> 272; o4_X = reg_o; operation : s*b + a + acc
"000000100001101000010001010000100000010110010010010110",
--  (1320) iterative_modular_reduction_73
-- reg_a = o5_X; reg_b = prime5; reg_acc = reg_o >> 272; o5_X = reg_o; Enable sign a,b; operation : s*b + a + acc
"000000100001101000010001010000100001111010110110110110",
--  (1321) iterative_modular_reduction_74
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1322) iterative_modular_reduction_75
-- -- In case of size 7
-- reg_a = a6_X; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"000000100001110000000000010000011001111111011011010010",
--  (1323) iterative_modular_reduction_76
-- reg_a = a0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"000000100001110000010011000111010000000100000000010010",
--  (1324) iterative_modular_reduction_77
-- reg_a = a1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : -s*b + a + acc
"000000100001110000010011000000100000001000100100110010",
--  (1325) iterative_modular_reduction_78
-- reg_a = a2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : -s*b + a + acc
"000000100001110000010011000000100000001101001001010010",
--  (1326) iterative_modular_reduction_79
-- reg_a = a3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; operation : -s*b + a + acc
"000000100001110000010011000000100000010001101101110010",
--  (1327) iterative_modular_reduction_80
-- reg_a = a4_X; reg_b = prime4; reg_acc = reg_o >> 272; o4_X = reg_o; operation : -s*b + a + acc
"000000100001110000010011000000100000010110010010010010",
--  (1328) iterative_modular_reduction_81
-- reg_a = a5_X; reg_b = prime5; reg_acc = reg_o >> 272; o5_X = reg_o; operation : -s*b + a + acc
"000000100001110000010011000000100000011010110110110010",
--  (1329) iterative_modular_reduction_82
-- reg_a = a6_X; reg_b = prime6; reg_acc = reg_o >> 272; o6_X = reg_o; Enable sign a,b; operation : -s*b + a + acc
"000000100001110000010011000000100001111111011011010010",
--  (1330) iterative_modular_reduction_83
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001110000010001010011010000000100000000010110",
--  (1331) iterative_modular_reduction_84
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : s*b + a + acc
"000000100001110000010001010000100000001000100100110110",
--  (1332) iterative_modular_reduction_85
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : s*b + a + acc
"000000100001110000010001010000100000001101001001010110",
--  (1333) iterative_modular_reduction_86
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; operation : s*b + a + acc
"000000100001110000010001010000100000010001101101110110",
--  (1334) iterative_modular_reduction_87
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o >> 272; o4_X = reg_o; operation : s*b + a + acc
"000000100001110000010001010000100000010110010010010110",
--  (1335) iterative_modular_reduction_88
-- reg_a = o5_X; reg_b = prime5; reg_acc = reg_o >> 272; o5_X = reg_o; operation : s*b + a + acc
"000000100001110000010001010000100000011010110110110110",
--  (1336) iterative_modular_reduction_89
-- reg_a = o6_X; reg_b = prime6; reg_acc = reg_o >> 272; o6_X = reg_o; Enable sign a,b; operation : s*b + a + acc
"000000100001110000010001010000100001111111011011010110",
--  (1337) iterative_modular_reduction_90
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001110000010001010011010000000100000000010110",
--  (1338) iterative_modular_reduction_91
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : s*b + a + acc
"000000100001110000010001010000100000001000100100110110",
--  (1339) iterative_modular_reduction_92
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : s*b + a + acc
"000000100001110000010001010000100000001101001001010110",
--  (1340) iterative_modular_reduction_93
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; operation : s*b + a + acc
"000000100001110000010001010000100000010001101101110110",
--  (1341) iterative_modular_reduction_94
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o >> 272; o4_X = reg_o; operation : s*b + a + acc
"000000100001110000010001010000100000010110010010010110",
--  (1342) iterative_modular_reduction_95
-- reg_a = o5_X; reg_b = prime5; reg_acc = reg_o >> 272; o5_X = reg_o; operation : s*b + a + acc
"000000100001110000010001010000100000011010110110110110",
--  (1343) iterative_modular_reduction_96
-- reg_a = o6_X; reg_b = prime6; reg_acc = reg_o >> 272; o6_X = reg_o; Enable sign a,b; operation : s*b + a + acc
"000000100001110000010001010000100001111111011011010110",
--  (1344) iterative_modular_reduction_97
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010",
--  (1345) iterative_modular_reduction_98
-- -- In case of size 8
-- reg_a = a7_X; reg_b = 0; reg_acc = 0; Enable sign a,b; operation : b + a + acc;
"000000100001111000000000010000011001100011111111110010",
--  (1346) iterative_modular_reduction_99
-- reg_a = a0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_positive; operation : -s*b + a + acc
"000000100001111000010011000111010000000100000000010010",
--  (1347) iterative_modular_reduction_100
-- reg_a = a1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : -s*b + a + acc
"000000100001111000010011000000100000001000100100110010",
--  (1348) iterative_modular_reduction_101
-- reg_a = a2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : -s*b + a + acc
"000000100001111000010011000000100000001101001001010010",
--  (1349) iterative_modular_reduction_102
-- reg_a = a3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; operation : -s*b + a + acc
"000000100001111000010011000000100000010001101101110010",
--  (1350) iterative_modular_reduction_103
-- reg_a = a4_X; reg_b = prime4; reg_acc = reg_o >> 272; o4_X = reg_o; operation : -s*b + a + acc
"000000100001111000010011000000100000010110010010010010",
--  (1351) iterative_modular_reduction_104
-- reg_a = a5_X; reg_b = prime5; reg_acc = reg_o >> 272; o5_X = reg_o; operation : -s*b + a + acc
"000000100001111000010011000000100000011010110110110010",
--  (1352) iterative_modular_reduction_105
-- reg_a = a6_X; reg_b = prime6; reg_acc = reg_o >> 272; o6_X = reg_o; operation : -s*b + a + acc
"000000100001111000010011000000100000011111011011010010",
--  (1353) iterative_modular_reduction_106
-- reg_a = a7_X; reg_b = prime7; reg_acc = reg_o >> 272; o7_X = reg_o; Enable sign a,b; operation : -s*b + a + acc
"000000100001111000010011000000100001100011111111110010",
--  (1354) iterative_modular_reduction_107
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001111000010001010011010000000100000000010110",
--  (1355) iterative_modular_reduction_108
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : s*b + a + acc
"000000100001111000010001010000100000001000100100110110",
--  (1356) iterative_modular_reduction_109
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : s*b + a + acc
"000000100001111000010001010000100000001101001001010110",
--  (1357) iterative_modular_reduction_110
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; operation : s*b + a + acc
"000000100001111000010001010000100000010001101101110110",
--  (1358) iterative_modular_reduction_111
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o >> 272; o4_X = reg_o; operation : s*b + a + acc
"000000100001111000010001010000100000010110010010010110",
--  (1359) iterative_modular_reduction_112
-- reg_a = o5_X; reg_b = prime5; reg_acc = reg_o >> 272; o5_X = reg_o; operation : s*b + a + acc
"000000100001111000010001010000100000011010110110110110",
--  (1360) iterative_modular_reduction_113
-- reg_a = o6_X; reg_b = prime6; reg_acc = reg_o >> 272; o6_X = reg_o; operation : s*b + a + acc
"000000100001111000010001010000100000011111011011010110",
--  (1361) iterative_modular_reduction_114
-- reg_a = o7_X; reg_b = prime7; reg_acc = reg_o >> 272; o7_X = reg_o; Enable sign a,b; operation : s*b + a + acc
"000000100001111000010001010000100001100011111111110110",
--  (1362) iterative_modular_reduction_115
-- reg_a = o0_X; reg_b = prime0; reg_acc = 0; o0_X = reg_o; reg_s = reg_o_negative; operation : s*b + a + acc
"000000100001111000010001010011010000000100000000010110",
--  (1363) iterative_modular_reduction_116
-- reg_a = o1_X; reg_b = prime1; reg_acc = reg_o >> 272; o1_X = reg_o; operation : s*b + a + acc
"000000100001111000010001010000100000001000100100110110",
--  (1364) iterative_modular_reduction_117
-- reg_a = o2_X; reg_b = prime2; reg_acc = reg_o >> 272; o2_X = reg_o; operation : s*b + a + acc
"000000100001111000010001010000100000001101001001010110",
--  (1365) iterative_modular_reduction_118
-- reg_a = o3_X; reg_b = prime3; reg_acc = reg_o >> 272; o3_X = reg_o; operation : s*b + a + acc
"000000100001111000010001010000100000010001101101110110",
--  (1366) iterative_modular_reduction_119
-- reg_a = o4_X; reg_b = prime4; reg_acc = reg_o >> 272; o4_X = reg_o; operation : s*b + a + acc
"000000100001111000010001010000100000010110010010010110",
--  (1367) iterative_modular_reduction_120
-- reg_a = o5_X; reg_b = prime5; reg_acc = reg_o >> 272; o5_X = reg_o; operation : s*b + a + acc
"000000100001111000010001010000100000011010110110110110",
--  (1368) iterative_modular_reduction_121
-- reg_a = o6_X; reg_b = prime6; reg_acc = reg_o >> 272; o6_X = reg_o; operation : s*b + a + acc
"000000100001111000010001010000100000011111011011010110",
--  (1369) iterative_modular_reduction_122
-- reg_a = o7_X; reg_b = prime7; reg_acc = reg_o >> 272; o7_X = reg_o; Enable sign a,b; operation : s*b + a + acc
"000000100001111000010001010000100001100011111111110110",
--  (1370) iterative_modular_reduction_123
-- NOP 4 stages                  
-- reg_a = 0; reg_b = 0; reg_acc = 0; operation : b + a + acc;
"000000000000000100000000010000011110000100000000000010"
);



constant rom_state_machine_fill_nop : romtype(1371 to 2047) := (others => "000000000000000100000000100000011110000100000000000011");
constant rom_state_machine : romtype(0 to 2047) := rom_state_machine_program & rom_state_machine_fill_nop;

signal rom_state_machine_address : std_logic_vector(10 downto 0);
signal rom_state_machine_output : std_logic_vector(53 downto 0);

signal rom_sm_rotation_size : std_logic_vector(1 downto 0);
signal rom_sel_address_a : std_logic;
signal rom_sel_address_b_prime : std_logic_vector(1 downto 0);
signal rom_sm_specific_mac_address_a : std_logic_vector(2 downto 0);
signal rom_sm_specific_mac_address_b : std_logic_vector(2 downto 0);
signal rom_sm_specific_mac_address_o : std_logic_vector(2 downto 0);
signal rom_sm_specific_mac_next_address_o : std_logic_vector(2 downto 0);
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
signal rom_sm_mac_write_enable_output : std_logic;
signal rom_mac_memory_double_mode : std_logic;
signal rom_mac_memory_only_write_mode : std_logic;
signal rom_base_address_generator_o_increment_previous_address : std_logic;

signal rom_last_state : std_logic;
signal rom_current_operand_size : std_logic_vector(2 downto 0);
signal rom_next_operation_same_operand_size : std_logic_vector(4 downto 0);
signal rom_next_operation_different_operand_size : std_logic_vector(6 downto 0);

signal adder_a : unsigned(10 downto 0);
signal adder_b : unsigned(6 downto 0);
signal adder_o : unsigned(10 downto 0);

signal ultimate_instruction : std_logic;

signal internal_sel_output_rom : std_logic;
signal internal_update_rom_address : std_logic;
signal internal_sel_load_new_rom_address : std_logic;
signal internal_sm_rotation_size : std_logic_vector(1 downto 0);
signal internal_sm_circular_shift_enable : std_logic;
signal internal_sel_address_a : std_logic;
signal internal_sel_address_b_prime : std_logic_vector(1 downto 0);
signal internal_sm_specific_mac_address_a : std_logic_vector(2 downto 0);
signal internal_sm_specific_mac_address_b : std_logic_vector(2 downto 0);
signal internal_sm_specific_mac_address_o : std_logic_vector(2 downto 0);
signal internal_sm_specific_mac_next_address_o : std_logic_vector(2 downto 0);
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
constant first_state_multiplication_direct_operand_size_1 : std_logic_vector(10 downto 0)                                  := std_logic_vector(to_unsigned(0,11));
constant first_state_multiplication_direct_operand_size_2_3_4_5_6_7_8 : std_logic_vector(10 downto 0)                      := std_logic_vector(to_unsigned(2,11));
-- 0001 square with no reduction                                                                                           
constant first_state_square_direct_operand_size_1 : std_logic_vector(10 downto 0)                                          := std_logic_vector(to_unsigned(141,11));
constant first_state_square_direct_operand_size_2_3_4_5_6_7_8 : std_logic_vector(10 downto 0)                              := std_logic_vector(to_unsigned(143,11));
-- 0010 multiplication with reduction and prime line not equal to 1
constant first_state_multiplication_with_reduction_operand_size_1 : std_logic_vector(10 downto 0)                          := std_logic_vector(to_unsigned(226,11));
constant first_state_multiplication_with_reduction_operand_size_2_3_4_5_6_7_8 : std_logic_vector(10 downto 0)              := std_logic_vector(to_unsigned(231,11));
-- 0010 multiplication with reduction and prime line equal to 1                                                         
constant first_state_multiplication_with_reduction_special_prime_operand_size_1 : std_logic_vector(10 downto 0)            := std_logic_vector(to_unsigned(510,11));
constant first_state_multiplication_with_reduction_special_prime_operand_size_2_3_4 : std_logic_vector(10 downto 0)        := std_logic_vector(to_unsigned(513,11));
constant first_state_multiplication_with_reduction_special_prime_operand_size_5_6 : std_logic_vector(10 downto 0)          := std_logic_vector(to_unsigned(557,11));
constant first_state_multiplication_with_reduction_special_prime_operand_size_7_8 : std_logic_vector(10 downto 0)          := std_logic_vector(to_unsigned(640,11));
-- 0011 square with reduction and prime line not equal to 1                                                             
constant first_state_square_with_reduction_operand_size_1 : std_logic_vector(10 downto 0)                                  := std_logic_vector(to_unsigned(787,11));
constant first_state_square_with_reduction_operand_size_2_3_4_5_6_7_8 : std_logic_vector(10 downto 0)                      := std_logic_vector(to_unsigned(792,11));
-- 0011 square with reduction and prime line equal to 1                                                                 
constant first_state_square_with_reduction_special_prime_operand_size_1 : std_logic_vector(10 downto 0)                    := std_logic_vector(to_unsigned(1015,11));
constant first_state_square_with_reduction_special_prime_operand_size_2_3_4 : std_logic_vector(10 downto 0)                := std_logic_vector(to_unsigned(1018,11));
constant first_state_square_with_reduction_special_prime_operand_size_5_6 : std_logic_vector(10 downto 0)                  := std_logic_vector(to_unsigned(1052,11));
constant first_state_square_with_reduction_special_prime_operand_size_7_8 : std_logic_vector(10 downto 0)                  := std_logic_vector(to_unsigned(1115,11));
-- 0100 addition with no reduction                                                                                      
constant first_state_addition_subtraction_direct_operand_size_1 : std_logic_vector(10 downto 0)                            := std_logic_vector(to_unsigned(1224, 11));
constant first_state_addition_subtraction_direct_operand_size_2_3_4_5_6_7_8 : std_logic_vector(10 downto 0)                := std_logic_vector(to_unsigned(1226, 11));
-- 0101 iterative modular reduction                                                                                     
constant first_state_iterative_modular_reduction_operand_size_1 : std_logic_vector(10 downto 0)                            := std_logic_vector(to_unsigned(1247, 11));
constant first_state_iterative_modular_reduction_operand_size_2 : std_logic_vector(10 downto 0)                            := std_logic_vector(to_unsigned(1252, 11));
constant first_state_iterative_modular_reduction_operand_size_3 : std_logic_vector(10 downto 0)                            := std_logic_vector(to_unsigned(1260, 11));
constant first_state_iterative_modular_reduction_operand_size_4 : std_logic_vector(10 downto 0)                            := std_logic_vector(to_unsigned(1271, 11));
constant first_state_iterative_modular_reduction_operand_size_5 : std_logic_vector(10 downto 0)                            := std_logic_vector(to_unsigned(1285, 11));
constant first_state_iterative_modular_reduction_operand_size_6 : std_logic_vector(10 downto 0)                            := std_logic_vector(to_unsigned(1302, 11));
constant first_state_iterative_modular_reduction_operand_size_7 : std_logic_vector(10 downto 0)                            := std_logic_vector(to_unsigned(1322, 11));
constant first_state_iterative_modular_reduction_operand_size_8 : std_logic_vector(10 downto 0)                            := std_logic_vector(to_unsigned(1345, 11));

type state is (reset, decode_instruction, instruction_execution);

signal actual_state, next_state : state;

signal internal_next_sel_output_rom : std_logic;
signal internal_next_update_rom_address : std_logic;
signal internal_next_sel_load_new_rom_address : std_logic;
signal internal_next_sm_rotation_size : std_logic_vector(1 downto 0);
signal internal_next_sm_circular_shift_enable : std_logic;
signal internal_next_sel_address_a : std_logic;
signal internal_next_sel_address_b_prime : std_logic_vector(1 downto 0);
signal internal_next_sm_specific_mac_address_a : std_logic_vector(2 downto 0);
signal internal_next_sm_specific_mac_address_b : std_logic_vector(2 downto 0);
signal internal_next_sm_specific_mac_address_o : std_logic_vector(2 downto 0);
signal internal_next_sm_specific_mac_next_address_o : std_logic_vector(2 downto 0);
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
            internal_sm_specific_mac_address_a <= "000";
            internal_sm_specific_mac_address_b <= "000";
            internal_sm_specific_mac_address_o <= "000";
            internal_sm_specific_mac_next_address_o <= "001";
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
            internal_next_sm_specific_mac_address_a <= "000";
            internal_next_sm_specific_mac_address_b <= "000";
            internal_next_sm_specific_mac_address_o <= "000";
            internal_next_sm_specific_mac_next_address_o <= "001";
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
            internal_next_sm_specific_mac_address_a <= "000";
            internal_next_sm_specific_mac_address_b <= "000";
            internal_next_sm_specific_mac_address_o <= "000";
            internal_next_sm_specific_mac_next_address_o <= "001";
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
            internal_next_sm_specific_mac_address_a <= "000";
            internal_next_sm_specific_mac_address_b <= "000";
            internal_next_sm_specific_mac_address_o <= "000";
            internal_next_sm_specific_mac_next_address_o <= "001";
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
adder_b <= resize(unsigned(rom_next_operation_same_operand_size), 7) when (rom_current_operand_size = operands_size) else unsigned(rom_next_operation_different_operand_size);

adder_o <= adder_a + resize(adder_b, 11);

process(clk)
begin
    if (rising_edge(clk)) then
        if(internal_update_rom_address = '1') then
            if(internal_sel_load_new_rom_address = '1') then
                if(instruction_values_valid = '1') then
                    if(instruction_type = "0000") then
                        if(operands_size = "000") then
                            rom_state_machine_address <= first_state_multiplication_direct_operand_size_1;
                        else
                            rom_state_machine_address <= first_state_multiplication_direct_operand_size_2_3_4_5_6_7_8;
                        end if;
                    elsif(instruction_type = "0001") then
                        if(operands_size = "000") then
                            rom_state_machine_address <= first_state_square_direct_operand_size_1;
                        else
                            rom_state_machine_address <= first_state_square_direct_operand_size_2_3_4_5_6_7_8;
                        end if;
                    elsif(instruction_type = "0010") then
                        if(prime_line_equal_one = '1') then
                            case (operands_size) is
                                when "000" =>
                                    rom_state_machine_address <= first_state_multiplication_with_reduction_special_prime_operand_size_1;
                                when "001"| "010"| "011" =>
                                    rom_state_machine_address <= first_state_multiplication_with_reduction_special_prime_operand_size_2_3_4;
                                when "100"| "101" =>
                                    rom_state_machine_address <= first_state_multiplication_with_reduction_special_prime_operand_size_5_6;
                                when others =>
                                    rom_state_machine_address <= first_state_multiplication_with_reduction_special_prime_operand_size_7_8;
                            end case;
                        else
                            if(operands_size = "000") then
                                rom_state_machine_address <= first_state_multiplication_with_reduction_operand_size_1;
                            else
                                rom_state_machine_address <= first_state_multiplication_with_reduction_operand_size_2_3_4_5_6_7_8;
                            end if;
                        end if;
                    elsif(instruction_type = "0011") then
                        if(prime_line_equal_one = '1') then
                            case (operands_size) is
                                when "000" =>
                                    rom_state_machine_address <= first_state_square_with_reduction_special_prime_operand_size_1;
                                when "001"| "010"| "011" =>
                                    rom_state_machine_address <= first_state_square_with_reduction_special_prime_operand_size_2_3_4;
                                when "100"| "101" =>
                                    rom_state_machine_address <= first_state_square_with_reduction_special_prime_operand_size_5_6;
                                when others =>
                                    rom_state_machine_address <= first_state_square_with_reduction_special_prime_operand_size_7_8;
                            end case;
                        else
                            if(operands_size = "000") then
                                rom_state_machine_address <= first_state_square_with_reduction_operand_size_1;
                            else
                                rom_state_machine_address <= first_state_square_with_reduction_operand_size_2_3_4_5_6_7_8;
                            end if;
                        end if;
                    elsif(instruction_type = "0100") then
                        if(operands_size = "000") then
                            rom_state_machine_address <= first_state_addition_subtraction_direct_operand_size_1;
                        else
                            rom_state_machine_address <= first_state_addition_subtraction_direct_operand_size_2_3_4_5_6_7_8;
                        end if;
                    elsif(instruction_type = "0101") then
                        if(operands_size = "000") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_1;
                        elsif(operands_size = "001") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_2;
                        elsif(operands_size = "010") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_3;
                        elsif(operands_size = "011") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_4;
                        elsif(operands_size = "100") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_5;
                        elsif(operands_size = "101") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_6;
                        elsif(operands_size = "110") then
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_7;
                        else
                            rom_state_machine_address <= first_state_iterative_modular_reduction_operand_size_8;
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
rom_sm_specific_mac_address_a <= rom_state_machine_output(7 downto 5);
rom_sm_specific_mac_address_b <= rom_state_machine_output(10 downto 8);
rom_sm_specific_mac_address_o <= rom_state_machine_output(13 downto 11);
rom_sm_specific_mac_next_address_o <= rom_state_machine_output(16 downto 14);
rom_mac_enable_signed_a <= rom_state_machine_output(17);
rom_mac_enable_signed_b <= rom_state_machine_output(18);
rom_mac_sel_load_reg_a <= rom_state_machine_output(20 downto 19);
rom_mac_clear_reg_b <= rom_state_machine_output(21);
rom_mac_clear_reg_acc <= rom_state_machine_output(22);
rom_mac_sel_shift_reg_o <= rom_state_machine_output(23);
rom_mac_enable_update_reg_s <= rom_state_machine_output(24);
rom_mac_sel_reg_s_reg_o_sign <= rom_state_machine_output(25);
rom_mac_reg_s_reg_o_positive <= rom_state_machine_output(26);
rom_sm_sign_a_mode <= rom_state_machine_output(27);
rom_sm_mac_operation_mode <= rom_state_machine_output(29 downto 28);
rom_mac_enable_reg_s_mask <= rom_state_machine_output(30);
rom_mac_subtraction_reg_a_b <= rom_state_machine_output(31);
rom_mac_sel_multiply_two_a_b <= rom_state_machine_output(32);
rom_mac_sel_reg_y_output <= rom_state_machine_output(33);
rom_sm_mac_write_enable_output <= rom_state_machine_output(34);
rom_mac_memory_double_mode <= rom_state_machine_output(35);
rom_mac_memory_only_write_mode <= rom_state_machine_output(36);
rom_base_address_generator_o_increment_previous_address <= rom_state_machine_output(37);

rom_last_state <= rom_state_machine_output(38);
rom_current_operand_size <= rom_state_machine_output(41 downto 39);
rom_next_operation_same_operand_size <= rom_state_machine_output(46 downto 42);
rom_next_operation_different_operand_size <= rom_state_machine_output(53 downto 47);

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