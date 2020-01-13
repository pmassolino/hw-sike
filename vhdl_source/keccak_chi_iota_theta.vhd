-- The Keccak sponge function, designed by Guido Bertoni, Joan Daemen,
-- Michaël Peeters and Gilles Van Assche. For more information, feedback or
-- questions, please refer to our website: http://keccak.noekeon.org/

-- Implementation by the designers,
-- hereby denoted as "the implementer".

-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keccak_chi_iota_theta is
generic(
    keccak_w : integer := 64;
    bit_per_sub_lane : integer := 2
);
port (
    chi_inp                    : in std_logic_vector((25*bit_per_sub_lane-1) downto 0);
    theta_inp                  : in std_logic_vector((25*bit_per_sub_lane-1) downto 0);
    k_slice_theta_p_in         : in std_logic_vector(24 downto 0);
    theta_parity_inp           : in std_logic_vector(4 downto 0);
    first_round                : in std_logic;
    first_block                : in std_logic;
    round_constant_signal      : in std_logic_vector((bit_per_sub_lane-1) downto 0);
    theta_parity_bit_iota_inp  : in std_logic;
    theta_parity_outp          : out std_logic_vector(4 downto 0);
    iota_outp                  : out std_logic_vector((25*bit_per_sub_lane-1) downto 0);
    theta_outp                 : out std_logic_vector((25*bit_per_sub_lane-1) downto 0));
end keccak_chi_iota_theta;

architecture rtl of keccak_chi_iota_theta is


----------------------------------------------------------------------------
-- Internal signal declarations
----------------------------------------------------------------------------


signal theta_in,theta_out,chi_in,chi_out,iota_in,iota_out : std_logic_vector((25*bit_per_sub_lane-1) downto 0);
signal theta_parity,theta_parity_after_chi,theta_parity_first_round: std_logic_vector(4 downto 0);
signal sum_sheet: std_logic_vector((5*bit_per_sub_lane-1) downto 0);
signal chi_out_for_theta_p: std_logic_vector(24 downto 0);


begin  -- Rtl


--connections

--order theta, pi, rho, chi, iota
theta_in <= theta_inp when (first_round='1') else iota_out;



chi_in <= chi_inp;
iota_in <= chi_out;
iota_outp <= iota_out;

theta_outp <= theta_out;

--chi
i0000: for i in 0 to (bit_per_sub_lane-1) generate
    chi_out((0)*bit_per_sub_lane + i) <= chi_in((0)*bit_per_sub_lane + i) xor  ( not(chi_in((1)*bit_per_sub_lane + i))and chi_in((2)*bit_per_sub_lane + i));
    chi_out((1)*bit_per_sub_lane + i) <= chi_in((1)*bit_per_sub_lane + i) xor  ( not(chi_in((2)*bit_per_sub_lane + i))and chi_in((3)*bit_per_sub_lane + i));
    chi_out((2)*bit_per_sub_lane + i) <= chi_in((2)*bit_per_sub_lane + i) xor  ( not(chi_in((3)*bit_per_sub_lane + i))and chi_in((4)*bit_per_sub_lane + i));
    chi_out((3)*bit_per_sub_lane + i) <= chi_in((3)*bit_per_sub_lane + i) xor  ( not(chi_in((4)*bit_per_sub_lane + i))and chi_in((0)*bit_per_sub_lane + i));
    chi_out((4)*bit_per_sub_lane + i) <= chi_in((4)*bit_per_sub_lane + i) xor  ( not(chi_in((0)*bit_per_sub_lane + i))and chi_in((1)*bit_per_sub_lane + i));

    chi_out((5)*bit_per_sub_lane + i) <= chi_in((5)*bit_per_sub_lane + i) xor  ( not(chi_in((6)*bit_per_sub_lane + i))and chi_in((7)*bit_per_sub_lane + i));
    chi_out((6)*bit_per_sub_lane + i) <= chi_in((6)*bit_per_sub_lane + i) xor  ( not(chi_in((7)*bit_per_sub_lane + i))and chi_in((8)*bit_per_sub_lane + i));
    chi_out((7)*bit_per_sub_lane + i) <= chi_in((7)*bit_per_sub_lane + i) xor  ( not(chi_in((8)*bit_per_sub_lane + i))and chi_in((9)*bit_per_sub_lane + i));
    chi_out((8)*bit_per_sub_lane + i) <= chi_in((8)*bit_per_sub_lane + i) xor  ( not(chi_in((9)*bit_per_sub_lane + i))and chi_in((5)*bit_per_sub_lane + i));
    chi_out((9)*bit_per_sub_lane + i) <= chi_in((9)*bit_per_sub_lane + i) xor  ( not(chi_in((5)*bit_per_sub_lane + i))and chi_in((6)*bit_per_sub_lane + i));

    chi_out((10)*bit_per_sub_lane + i) <= chi_in((10)*bit_per_sub_lane + i) xor  ( not(chi_in((11)*bit_per_sub_lane + i))and chi_in((12)*bit_per_sub_lane + i));
    chi_out((11)*bit_per_sub_lane + i) <= chi_in((11)*bit_per_sub_lane + i) xor  ( not(chi_in((12)*bit_per_sub_lane + i))and chi_in((13)*bit_per_sub_lane + i));
    chi_out((12)*bit_per_sub_lane + i) <= chi_in((12)*bit_per_sub_lane + i) xor  ( not(chi_in((13)*bit_per_sub_lane + i))and chi_in((14)*bit_per_sub_lane + i));
    chi_out((13)*bit_per_sub_lane + i) <= chi_in((13)*bit_per_sub_lane + i) xor  ( not(chi_in((14)*bit_per_sub_lane + i))and chi_in((10)*bit_per_sub_lane + i));
    chi_out((14)*bit_per_sub_lane + i) <= chi_in((14)*bit_per_sub_lane + i) xor  ( not(chi_in((10)*bit_per_sub_lane + i))and chi_in((11)*bit_per_sub_lane + i));

    chi_out((15)*bit_per_sub_lane + i) <= chi_in((15)*bit_per_sub_lane + i) xor  ( not(chi_in((16)*bit_per_sub_lane + i))and chi_in((17)*bit_per_sub_lane + i));
    chi_out((16)*bit_per_sub_lane + i) <= chi_in((16)*bit_per_sub_lane + i) xor  ( not(chi_in((17)*bit_per_sub_lane + i))and chi_in((18)*bit_per_sub_lane + i));
    chi_out((17)*bit_per_sub_lane + i) <= chi_in((17)*bit_per_sub_lane + i) xor  ( not(chi_in((18)*bit_per_sub_lane + i))and chi_in((19)*bit_per_sub_lane + i));
    chi_out((18)*bit_per_sub_lane + i) <= chi_in((18)*bit_per_sub_lane + i) xor  ( not(chi_in((19)*bit_per_sub_lane + i))and chi_in((15)*bit_per_sub_lane + i));
    chi_out((19)*bit_per_sub_lane + i) <= chi_in((19)*bit_per_sub_lane + i) xor  ( not(chi_in((15)*bit_per_sub_lane + i))and chi_in((16)*bit_per_sub_lane + i));

    chi_out((20)*bit_per_sub_lane + i) <= chi_in((20)*bit_per_sub_lane + i) xor  ( not(chi_in((21)*bit_per_sub_lane + i))and chi_in((22)*bit_per_sub_lane + i));
    chi_out((21)*bit_per_sub_lane + i) <= chi_in((21)*bit_per_sub_lane + i) xor  ( not(chi_in((22)*bit_per_sub_lane + i))and chi_in((23)*bit_per_sub_lane + i));
    chi_out((22)*bit_per_sub_lane + i) <= chi_in((22)*bit_per_sub_lane + i) xor  ( not(chi_in((23)*bit_per_sub_lane + i))and chi_in((24)*bit_per_sub_lane + i));
    chi_out((23)*bit_per_sub_lane + i) <= chi_in((23)*bit_per_sub_lane + i) xor  ( not(chi_in((24)*bit_per_sub_lane + i))and chi_in((20)*bit_per_sub_lane + i));
    chi_out((24)*bit_per_sub_lane + i) <= chi_in((24)*bit_per_sub_lane + i) xor  ( not(chi_in((20)*bit_per_sub_lane + i))and chi_in((21)*bit_per_sub_lane + i));
end generate;


-- compute chi on the slice for theta parity
chi_out_for_theta_p(0) <= k_slice_theta_p_in(0) xor ( not(k_slice_theta_p_in(1))and k_slice_theta_p_in(2));
chi_out_for_theta_p(1) <= k_slice_theta_p_in(1) xor ( not(k_slice_theta_p_in(2))and k_slice_theta_p_in(3));
chi_out_for_theta_p(2) <= k_slice_theta_p_in(2) xor ( not(k_slice_theta_p_in(3))and k_slice_theta_p_in(4));
chi_out_for_theta_p(3) <= k_slice_theta_p_in(3) xor ( not(k_slice_theta_p_in(4))and k_slice_theta_p_in(0));
chi_out_for_theta_p(4) <= k_slice_theta_p_in(4) xor ( not(k_slice_theta_p_in(0))and k_slice_theta_p_in(1));
                                                                             
chi_out_for_theta_p(5) <= k_slice_theta_p_in(5) xor ( not(k_slice_theta_p_in(6))and k_slice_theta_p_in(7));
chi_out_for_theta_p(6) <= k_slice_theta_p_in(6) xor ( not(k_slice_theta_p_in(7))and k_slice_theta_p_in(8));
chi_out_for_theta_p(7) <= k_slice_theta_p_in(7) xor ( not(k_slice_theta_p_in(8))and k_slice_theta_p_in(9));
chi_out_for_theta_p(8) <= k_slice_theta_p_in(8) xor ( not(k_slice_theta_p_in(9))and k_slice_theta_p_in(5));
chi_out_for_theta_p(9) <= k_slice_theta_p_in(9) xor ( not(k_slice_theta_p_in(5))and k_slice_theta_p_in(6));
                    
chi_out_for_theta_p(10) <= k_slice_theta_p_in(10) xor ( not(k_slice_theta_p_in(11))and k_slice_theta_p_in(12));
chi_out_for_theta_p(11) <= k_slice_theta_p_in(11) xor ( not(k_slice_theta_p_in(12))and k_slice_theta_p_in(13));
chi_out_for_theta_p(12) <= k_slice_theta_p_in(12) xor ( not(k_slice_theta_p_in(13))and k_slice_theta_p_in(14));
chi_out_for_theta_p(13) <= k_slice_theta_p_in(13) xor ( not(k_slice_theta_p_in(14))and k_slice_theta_p_in(10));
chi_out_for_theta_p(14) <= k_slice_theta_p_in(14) xor ( not(k_slice_theta_p_in(10))and k_slice_theta_p_in(11));
                                                                               
chi_out_for_theta_p(15) <= k_slice_theta_p_in(15) xor ( not(k_slice_theta_p_in(16))and k_slice_theta_p_in(17));
chi_out_for_theta_p(16) <= k_slice_theta_p_in(16) xor ( not(k_slice_theta_p_in(17))and k_slice_theta_p_in(18));
chi_out_for_theta_p(17) <= k_slice_theta_p_in(17) xor ( not(k_slice_theta_p_in(18))and k_slice_theta_p_in(19));
chi_out_for_theta_p(18) <= k_slice_theta_p_in(18) xor ( not(k_slice_theta_p_in(19))and k_slice_theta_p_in(15));
chi_out_for_theta_p(19) <= k_slice_theta_p_in(19) xor ( not(k_slice_theta_p_in(15))and k_slice_theta_p_in(16));
                                                                               
chi_out_for_theta_p(20) <= k_slice_theta_p_in(20) xor ( not(k_slice_theta_p_in(21))and k_slice_theta_p_in(22));
chi_out_for_theta_p(21) <= k_slice_theta_p_in(21) xor ( not(k_slice_theta_p_in(22))and k_slice_theta_p_in(23));
chi_out_for_theta_p(22) <= k_slice_theta_p_in(22) xor ( not(k_slice_theta_p_in(23))and k_slice_theta_p_in(24));
chi_out_for_theta_p(23) <= k_slice_theta_p_in(23) xor ( not(k_slice_theta_p_in(24))and k_slice_theta_p_in(20));
chi_out_for_theta_p(24) <= k_slice_theta_p_in(24) xor ( not(k_slice_theta_p_in(20))and k_slice_theta_p_in(21));

theta_parity_after_chi(0) <= chi_out_for_theta_p(0) xor chi_out_for_theta_p(5) xor chi_out_for_theta_p(10) xor chi_out_for_theta_p(15) xor chi_out_for_theta_p(20) xor theta_parity_bit_iota_inp;
theta_parity_after_chi(1) <= chi_out_for_theta_p(1) xor chi_out_for_theta_p(6) xor chi_out_for_theta_p(11) xor chi_out_for_theta_p(16) xor chi_out_for_theta_p(21);
theta_parity_after_chi(2) <= chi_out_for_theta_p(2) xor chi_out_for_theta_p(7) xor chi_out_for_theta_p(12) xor chi_out_for_theta_p(17) xor chi_out_for_theta_p(22);
theta_parity_after_chi(3) <= chi_out_for_theta_p(3) xor chi_out_for_theta_p(8) xor chi_out_for_theta_p(13) xor chi_out_for_theta_p(18) xor chi_out_for_theta_p(23);
theta_parity_after_chi(4) <= chi_out_for_theta_p(4) xor chi_out_for_theta_p(9) xor chi_out_for_theta_p(14) xor chi_out_for_theta_p(19) xor chi_out_for_theta_p(24);

--theta

--compute sum of columns
i0100: for i in 0 to (bit_per_sub_lane-1) generate
    sum_sheet((0)*bit_per_sub_lane + i) <= theta_in((0)*bit_per_sub_lane + i) xor theta_in((5)*bit_per_sub_lane + i) xor theta_in((10)*bit_per_sub_lane + i) xor theta_in((15)*bit_per_sub_lane + i) xor theta_in((20)*bit_per_sub_lane + i);
    sum_sheet((1)*bit_per_sub_lane + i) <= theta_in((1)*bit_per_sub_lane + i) xor theta_in((6)*bit_per_sub_lane + i) xor theta_in((11)*bit_per_sub_lane + i) xor theta_in((16)*bit_per_sub_lane + i) xor theta_in((21)*bit_per_sub_lane + i);
    sum_sheet((2)*bit_per_sub_lane + i) <= theta_in((2)*bit_per_sub_lane + i) xor theta_in((7)*bit_per_sub_lane + i) xor theta_in((12)*bit_per_sub_lane + i) xor theta_in((17)*bit_per_sub_lane + i) xor theta_in((22)*bit_per_sub_lane + i);
    sum_sheet((3)*bit_per_sub_lane + i) <= theta_in((3)*bit_per_sub_lane + i) xor theta_in((8)*bit_per_sub_lane + i) xor theta_in((13)*bit_per_sub_lane + i) xor theta_in((18)*bit_per_sub_lane + i) xor theta_in((23)*bit_per_sub_lane + i);
    sum_sheet((4)*bit_per_sub_lane + i) <= theta_in((4)*bit_per_sub_lane + i) xor theta_in((9)*bit_per_sub_lane + i) xor theta_in((14)*bit_per_sub_lane + i) xor theta_in((19)*bit_per_sub_lane + i) xor theta_in((24)*bit_per_sub_lane + i);
end generate;

-- sum of columns for the first round
theta_parity_first_round(0) <= k_slice_theta_p_in(0) xor k_slice_theta_p_in(5) xor k_slice_theta_p_in(10) xor k_slice_theta_p_in(15) xor k_slice_theta_p_in(20);
theta_parity_first_round(1) <= k_slice_theta_p_in(1) xor k_slice_theta_p_in(6) xor k_slice_theta_p_in(11) xor k_slice_theta_p_in(16) xor k_slice_theta_p_in(21);
theta_parity_first_round(2) <= k_slice_theta_p_in(2) xor k_slice_theta_p_in(7) xor k_slice_theta_p_in(12) xor k_slice_theta_p_in(17) xor k_slice_theta_p_in(22);
theta_parity_first_round(3) <= k_slice_theta_p_in(3) xor k_slice_theta_p_in(8) xor k_slice_theta_p_in(13) xor k_slice_theta_p_in(18) xor k_slice_theta_p_in(23);
theta_parity_first_round(4) <= k_slice_theta_p_in(4) xor k_slice_theta_p_in(9) xor k_slice_theta_p_in(14) xor k_slice_theta_p_in(19) xor k_slice_theta_p_in(24);

-- send in output the sum of columns for the next block
theta_parity_outp(0) <= sum_sheet((1)*bit_per_sub_lane-1);
theta_parity_outp(1) <= sum_sheet((2)*bit_per_sub_lane-1);
theta_parity_outp(2) <= sum_sheet((3)*bit_per_sub_lane-1);
theta_parity_outp(3) <= sum_sheet((4)*bit_per_sub_lane-1);
theta_parity_outp(4) <= sum_sheet((5)*bit_per_sub_lane-1);


theta_out((0)*bit_per_sub_lane) <= theta_in((0)*bit_per_sub_lane) xor sum_sheet((4)*bit_per_sub_lane) xor theta_parity(1);
theta_out((1)*bit_per_sub_lane) <= theta_in((1)*bit_per_sub_lane) xor sum_sheet((0)*bit_per_sub_lane) xor theta_parity(2);
theta_out((2)*bit_per_sub_lane) <= theta_in((2)*bit_per_sub_lane) xor sum_sheet((1)*bit_per_sub_lane) xor theta_parity(3);
theta_out((3)*bit_per_sub_lane) <= theta_in((3)*bit_per_sub_lane) xor sum_sheet((2)*bit_per_sub_lane) xor theta_parity(4);
theta_out((4)*bit_per_sub_lane) <= theta_in((4)*bit_per_sub_lane) xor sum_sheet((3)*bit_per_sub_lane) xor theta_parity(0);

theta_out((5)*bit_per_sub_lane) <= theta_in((5)*bit_per_sub_lane) xor sum_sheet((4)*bit_per_sub_lane) xor theta_parity(1);
theta_out((6)*bit_per_sub_lane) <= theta_in((6)*bit_per_sub_lane) xor sum_sheet((0)*bit_per_sub_lane) xor theta_parity(2);
theta_out((7)*bit_per_sub_lane) <= theta_in((7)*bit_per_sub_lane) xor sum_sheet((1)*bit_per_sub_lane) xor theta_parity(3);
theta_out((8)*bit_per_sub_lane) <= theta_in((8)*bit_per_sub_lane) xor sum_sheet((2)*bit_per_sub_lane) xor theta_parity(4);
theta_out((9)*bit_per_sub_lane) <= theta_in((9)*bit_per_sub_lane) xor sum_sheet((3)*bit_per_sub_lane) xor theta_parity(0);

theta_out((10)*bit_per_sub_lane) <= theta_in((10)*bit_per_sub_lane) xor sum_sheet((4)*bit_per_sub_lane) xor theta_parity(1);
theta_out((11)*bit_per_sub_lane) <= theta_in((11)*bit_per_sub_lane) xor sum_sheet((0)*bit_per_sub_lane) xor theta_parity(2);
theta_out((12)*bit_per_sub_lane) <= theta_in((12)*bit_per_sub_lane) xor sum_sheet((1)*bit_per_sub_lane) xor theta_parity(3);
theta_out((13)*bit_per_sub_lane) <= theta_in((13)*bit_per_sub_lane) xor sum_sheet((2)*bit_per_sub_lane) xor theta_parity(4);
theta_out((14)*bit_per_sub_lane) <= theta_in((14)*bit_per_sub_lane) xor sum_sheet((3)*bit_per_sub_lane) xor theta_parity(0);

theta_out((15)*bit_per_sub_lane) <= theta_in((15)*bit_per_sub_lane) xor sum_sheet((4)*bit_per_sub_lane) xor theta_parity(1);
theta_out((16)*bit_per_sub_lane) <= theta_in((16)*bit_per_sub_lane) xor sum_sheet((0)*bit_per_sub_lane) xor theta_parity(2);
theta_out((17)*bit_per_sub_lane) <= theta_in((17)*bit_per_sub_lane) xor sum_sheet((1)*bit_per_sub_lane) xor theta_parity(3);
theta_out((18)*bit_per_sub_lane) <= theta_in((18)*bit_per_sub_lane) xor sum_sheet((2)*bit_per_sub_lane) xor theta_parity(4);
theta_out((19)*bit_per_sub_lane) <= theta_in((19)*bit_per_sub_lane) xor sum_sheet((3)*bit_per_sub_lane) xor theta_parity(0);

theta_out((20)*bit_per_sub_lane) <= theta_in((20)*bit_per_sub_lane) xor sum_sheet((4)*bit_per_sub_lane) xor theta_parity(1);
theta_out((21)*bit_per_sub_lane) <= theta_in((21)*bit_per_sub_lane) xor sum_sheet((0)*bit_per_sub_lane) xor theta_parity(2);
theta_out((22)*bit_per_sub_lane) <= theta_in((22)*bit_per_sub_lane) xor sum_sheet((1)*bit_per_sub_lane) xor theta_parity(3);
theta_out((23)*bit_per_sub_lane) <= theta_in((23)*bit_per_sub_lane) xor sum_sheet((2)*bit_per_sub_lane) xor theta_parity(4);
theta_out((24)*bit_per_sub_lane) <= theta_in((24)*bit_per_sub_lane) xor sum_sheet((3)*bit_per_sub_lane) xor theta_parity(0);

i0200: for i in 1 to (bit_per_sub_lane-1) generate
    theta_out((0)*bit_per_sub_lane + i) <= theta_in((0)*bit_per_sub_lane + i) xor sum_sheet((4)*bit_per_sub_lane + i) xor sum_sheet((1)*bit_per_sub_lane + i-1);
    theta_out((1)*bit_per_sub_lane + i) <= theta_in((1)*bit_per_sub_lane + i) xor sum_sheet((0)*bit_per_sub_lane + i) xor sum_sheet((2)*bit_per_sub_lane + i-1);
    theta_out((2)*bit_per_sub_lane + i) <= theta_in((2)*bit_per_sub_lane + i) xor sum_sheet((1)*bit_per_sub_lane + i) xor sum_sheet((3)*bit_per_sub_lane + i-1);
    theta_out((3)*bit_per_sub_lane + i) <= theta_in((3)*bit_per_sub_lane + i) xor sum_sheet((2)*bit_per_sub_lane + i) xor sum_sheet((4)*bit_per_sub_lane + i-1);
    theta_out((4)*bit_per_sub_lane + i) <= theta_in((4)*bit_per_sub_lane + i) xor sum_sheet((3)*bit_per_sub_lane + i) xor sum_sheet((0)*bit_per_sub_lane + i-1);
    
    theta_out((5)*bit_per_sub_lane + i) <= theta_in((5)*bit_per_sub_lane + i) xor sum_sheet((4)*bit_per_sub_lane + i) xor sum_sheet((1)*bit_per_sub_lane + i-1);
    theta_out((6)*bit_per_sub_lane + i) <= theta_in((6)*bit_per_sub_lane + i) xor sum_sheet((0)*bit_per_sub_lane + i) xor sum_sheet((2)*bit_per_sub_lane + i-1);
    theta_out((7)*bit_per_sub_lane + i) <= theta_in((7)*bit_per_sub_lane + i) xor sum_sheet((1)*bit_per_sub_lane + i) xor sum_sheet((3)*bit_per_sub_lane + i-1);
    theta_out((8)*bit_per_sub_lane + i) <= theta_in((8)*bit_per_sub_lane + i) xor sum_sheet((2)*bit_per_sub_lane + i) xor sum_sheet((4)*bit_per_sub_lane + i-1);
    theta_out((9)*bit_per_sub_lane + i) <= theta_in((9)*bit_per_sub_lane + i) xor sum_sheet((3)*bit_per_sub_lane + i) xor sum_sheet((0)*bit_per_sub_lane + i-1);
    
    theta_out((10)*bit_per_sub_lane + i) <= theta_in((10)*bit_per_sub_lane + i) xor sum_sheet((4)*bit_per_sub_lane + i) xor sum_sheet((1)*bit_per_sub_lane + i-1);
    theta_out((11)*bit_per_sub_lane + i) <= theta_in((11)*bit_per_sub_lane + i) xor sum_sheet((0)*bit_per_sub_lane + i) xor sum_sheet((2)*bit_per_sub_lane + i-1);
    theta_out((12)*bit_per_sub_lane + i) <= theta_in((12)*bit_per_sub_lane + i) xor sum_sheet((1)*bit_per_sub_lane + i) xor sum_sheet((3)*bit_per_sub_lane + i-1);
    theta_out((13)*bit_per_sub_lane + i) <= theta_in((13)*bit_per_sub_lane + i) xor sum_sheet((2)*bit_per_sub_lane + i) xor sum_sheet((4)*bit_per_sub_lane + i-1);
    theta_out((14)*bit_per_sub_lane + i) <= theta_in((14)*bit_per_sub_lane + i) xor sum_sheet((3)*bit_per_sub_lane + i) xor sum_sheet((0)*bit_per_sub_lane + i-1);
    
    theta_out((15)*bit_per_sub_lane + i) <= theta_in((15)*bit_per_sub_lane + i) xor sum_sheet((4)*bit_per_sub_lane + i) xor sum_sheet((1)*bit_per_sub_lane + i-1);
    theta_out((16)*bit_per_sub_lane + i) <= theta_in((16)*bit_per_sub_lane + i) xor sum_sheet((0)*bit_per_sub_lane + i) xor sum_sheet((2)*bit_per_sub_lane + i-1);
    theta_out((17)*bit_per_sub_lane + i) <= theta_in((17)*bit_per_sub_lane + i) xor sum_sheet((1)*bit_per_sub_lane + i) xor sum_sheet((3)*bit_per_sub_lane + i-1);
    theta_out((18)*bit_per_sub_lane + i) <= theta_in((18)*bit_per_sub_lane + i) xor sum_sheet((2)*bit_per_sub_lane + i) xor sum_sheet((4)*bit_per_sub_lane + i-1);
    theta_out((19)*bit_per_sub_lane + i) <= theta_in((19)*bit_per_sub_lane + i) xor sum_sheet((3)*bit_per_sub_lane + i) xor sum_sheet((0)*bit_per_sub_lane + i-1);
    
    theta_out((20)*bit_per_sub_lane + i) <= theta_in((20)*bit_per_sub_lane + i) xor sum_sheet((4)*bit_per_sub_lane + i) xor sum_sheet((1)*bit_per_sub_lane + i-1);
    theta_out((21)*bit_per_sub_lane + i) <= theta_in((21)*bit_per_sub_lane + i) xor sum_sheet((0)*bit_per_sub_lane + i) xor sum_sheet((2)*bit_per_sub_lane + i-1);
    theta_out((22)*bit_per_sub_lane + i) <= theta_in((22)*bit_per_sub_lane + i) xor sum_sheet((1)*bit_per_sub_lane + i) xor sum_sheet((3)*bit_per_sub_lane + i-1);
    theta_out((23)*bit_per_sub_lane + i) <= theta_in((23)*bit_per_sub_lane + i) xor sum_sheet((2)*bit_per_sub_lane + i) xor sum_sheet((4)*bit_per_sub_lane + i-1);
    theta_out((24)*bit_per_sub_lane + i) <= theta_in((24)*bit_per_sub_lane + i) xor sum_sheet((3)*bit_per_sub_lane + i) xor sum_sheet((0)*bit_per_sub_lane + i-1);
end generate;

-- select which theta parity to choose
theta_parity <= theta_parity_first_round when(first_round ='1' and first_block ='1') else
                theta_parity_after_chi when(first_block='1') else
                theta_parity_inp;
--iota
i5000: for i in 0 to (bit_per_sub_lane-1) generate
    iota_out((0)*bit_per_sub_lane + i) <= iota_in((0)*bit_per_sub_lane + i) xor round_constant_signal(i);
    iota_out((1)*bit_per_sub_lane + i) <= iota_in((1)*bit_per_sub_lane + i);
    iota_out((2)*bit_per_sub_lane + i) <= iota_in((2)*bit_per_sub_lane + i);
    iota_out((3)*bit_per_sub_lane + i) <= iota_in((3)*bit_per_sub_lane + i);
    iota_out((4)*bit_per_sub_lane + i) <= iota_in((4)*bit_per_sub_lane + i);
    
    iota_out((5)*bit_per_sub_lane + i) <= iota_in((5)*bit_per_sub_lane + i);
    iota_out((6)*bit_per_sub_lane + i) <= iota_in((6)*bit_per_sub_lane + i);
    iota_out((7)*bit_per_sub_lane + i) <= iota_in((7)*bit_per_sub_lane + i);
    iota_out((8)*bit_per_sub_lane + i) <= iota_in((8)*bit_per_sub_lane + i);
    iota_out((9)*bit_per_sub_lane + i) <= iota_in((9)*bit_per_sub_lane + i);
    
    iota_out((10)*bit_per_sub_lane + i) <= iota_in((10)*bit_per_sub_lane + i);
    iota_out((11)*bit_per_sub_lane + i) <= iota_in((11)*bit_per_sub_lane + i);
    iota_out((12)*bit_per_sub_lane + i) <= iota_in((12)*bit_per_sub_lane + i);
    iota_out((13)*bit_per_sub_lane + i) <= iota_in((13)*bit_per_sub_lane + i);
    iota_out((14)*bit_per_sub_lane + i) <= iota_in((14)*bit_per_sub_lane + i);
    
    iota_out((15)*bit_per_sub_lane + i) <= iota_in((15)*bit_per_sub_lane + i);
    iota_out((16)*bit_per_sub_lane + i) <= iota_in((16)*bit_per_sub_lane + i);
    iota_out((17)*bit_per_sub_lane + i) <= iota_in((17)*bit_per_sub_lane + i);
    iota_out((18)*bit_per_sub_lane + i) <= iota_in((18)*bit_per_sub_lane + i);
    iota_out((19)*bit_per_sub_lane + i) <= iota_in((19)*bit_per_sub_lane + i);
    
    iota_out((20)*bit_per_sub_lane + i) <= iota_in((20)*bit_per_sub_lane + i);
    iota_out((21)*bit_per_sub_lane + i) <= iota_in((21)*bit_per_sub_lane + i);
    iota_out((22)*bit_per_sub_lane + i) <= iota_in((22)*bit_per_sub_lane + i);
    iota_out((23)*bit_per_sub_lane + i) <= iota_in((23)*bit_per_sub_lane + i);
    iota_out((24)*bit_per_sub_lane + i) <= iota_in((24)*bit_per_sub_lane + i);
end generate;

end rtl;
