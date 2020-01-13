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


entity keccak_rho_pi is
generic(
    keccak_w : integer := 64
);
port (
    rho_pi_in     : in  std_logic_vector((25*keccak_w-1) downto 0);
    rho_pi_out    : out std_logic_vector((25*keccak_w-1) downto 0));
end keccak_rho_pi;

architecture rtl of keccak_rho_pi is


----------------------------------------------------------------------------
-- Internal signal declarations
----------------------------------------------------------------------------

 
signal pi_in,pi_out,rho_in,rho_out : std_logic_vector((25*keccak_w-1) downto 0);

 
  
begin  -- RTL




--connections

--order theta, pi, rho, chi, iota
rho_in<=rho_pi_in;

pi_in<=rho_out;
rho_pi_out<=pi_out;


-- pi
i3000: for i in 0 to (keccak_w-1) generate
    pi_out((0)*keccak_w + i)  <= pi_in((0)*keccak_w + i);
    pi_out((10)*keccak_w + i) <= pi_in((1)*keccak_w + i);
    pi_out((20)*keccak_w + i) <= pi_in((2)*keccak_w + i);
    pi_out((5)*keccak_w + i)  <= pi_in((3)*keccak_w + i);
    pi_out((15)*keccak_w + i) <= pi_in((4)*keccak_w + i);

    pi_out((16)*keccak_w + i) <= pi_in((5)*keccak_w + i);
    pi_out((1)*keccak_w + i)  <= pi_in((6)*keccak_w + i);
    pi_out((11)*keccak_w + i) <= pi_in((7)*keccak_w + i);
    pi_out((21)*keccak_w + i) <= pi_in((8)*keccak_w + i);
    pi_out((6)*keccak_w + i)  <= pi_in((9)*keccak_w + i);

    pi_out((7)*keccak_w + i)  <= pi_in((10)*keccak_w + i);
    pi_out((17)*keccak_w + i) <= pi_in((11)*keccak_w + i);
    pi_out((2)*keccak_w + i)  <= pi_in((12)*keccak_w + i);
    pi_out((12)*keccak_w + i) <= pi_in((13)*keccak_w + i);
    pi_out((22)*keccak_w + i) <= pi_in((14)*keccak_w + i);

    pi_out((23)*keccak_w + i) <= pi_in((15)*keccak_w + i);
    pi_out((8)*keccak_w + i)  <= pi_in((16)*keccak_w + i);
    pi_out((18)*keccak_w + i) <= pi_in((17)*keccak_w + i);
    pi_out((3)*keccak_w + i)  <= pi_in((18)*keccak_w + i);
    pi_out((13)*keccak_w + i) <= pi_in((19)*keccak_w + i);

    pi_out((14)*keccak_w + i) <= pi_in((20)*keccak_w + i);
    pi_out((24)*keccak_w + i) <= pi_in((21)*keccak_w + i);
    pi_out((9)*keccak_w + i)  <= pi_in((22)*keccak_w + i);
    pi_out((19)*keccak_w + i) <= pi_in((23)*keccak_w + i);
    pi_out((4)*keccak_w + i)  <= pi_in((24)*keccak_w + i);
end generate;

--rho

i4000: for i in 0 to (keccak_w-1) generate
    rho_out((0)*keccak_w + i) <= rho_in((0)*keccak_w + ((i+64) mod keccak_w));
    rho_out((1)*keccak_w + i) <= rho_in((1)*keccak_w + ((i+64-1) mod keccak_w));
    rho_out((2)*keccak_w + i) <= rho_in((2)*keccak_w + ((i+64-62) mod keccak_w));
    rho_out((3)*keccak_w + i) <= rho_in((3)*keccak_w + ((i+64-28) mod keccak_w));
    rho_out((4)*keccak_w + i) <= rho_in((4)*keccak_w + ((i+64-27) mod keccak_w));
    rho_out((5)*keccak_w + i) <= rho_in((5)*keccak_w + ((i+64-36) mod keccak_w));
    rho_out((6)*keccak_w + i) <= rho_in((6)*keccak_w + ((i+64-44) mod keccak_w));
    rho_out((7)*keccak_w + i) <= rho_in((7)*keccak_w + ((i+64-6) mod keccak_w));
    rho_out((8)*keccak_w + i) <= rho_in((8)*keccak_w + ((i+64-55) mod keccak_w));
    rho_out((9)*keccak_w + i) <= rho_in((9)*keccak_w + ((i+64-20) mod keccak_w));
    rho_out((10)*keccak_w + i) <= rho_in((10)*keccak_w + ((i+64-3) mod keccak_w));
    rho_out((11)*keccak_w + i) <= rho_in((11)*keccak_w + ((i+64-10) mod keccak_w));
    rho_out((12)*keccak_w + i) <= rho_in((12)*keccak_w + ((i+64-43) mod keccak_w));
    rho_out((13)*keccak_w + i) <= rho_in((13)*keccak_w + ((i+64-25) mod keccak_w));
    rho_out((14)*keccak_w + i) <= rho_in((14)*keccak_w + ((i+64-39) mod keccak_w));
    rho_out((15)*keccak_w + i) <= rho_in((15)*keccak_w + ((i+64-41) mod keccak_w));
    rho_out((16)*keccak_w + i) <= rho_in((16)*keccak_w + ((i+64-45) mod keccak_w));
    rho_out((17)*keccak_w + i) <= rho_in((17)*keccak_w + ((i+64-15) mod keccak_w));
    rho_out((18)*keccak_w + i) <= rho_in((18)*keccak_w + ((i+64-21) mod keccak_w));
    rho_out((19)*keccak_w + i) <= rho_in((19)*keccak_w + ((i+64-8) mod keccak_w));
    rho_out((20)*keccak_w + i) <= rho_in((20)*keccak_w + ((i+64-18) mod keccak_w));
    rho_out((21)*keccak_w + i) <= rho_in((21)*keccak_w + ((i+64-2) mod keccak_w));
    rho_out((22)*keccak_w + i) <= rho_in((22)*keccak_w + ((i+64-61) mod keccak_w));
    rho_out((23)*keccak_w + i) <= rho_in((23)*keccak_w + ((i+64-56) mod keccak_w));
    rho_out((24)*keccak_w + i) <= rho_in((24)*keccak_w + ((i+64-14) mod keccak_w));
end generate;

end rtl;
