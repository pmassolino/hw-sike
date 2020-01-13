-- The Keccak sponge function, designed by Guido Bertoni, Joan Daemen,
-- Michaël Peeters and Gilles Van Assche. For more information, feedback or
-- questions, please refer to our website: http://keccak.noekeon.org/

-- Implementation by the designers,
-- hereby denoted as "the implementer".

-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/

-- Possible values for each generic:
-- (In case keccak_w = 64)
--constant bits_num_slices : integer := 1, 2, 3, 4, 5; 
-- (In case keccak_w = 32)
--constant bits_num_slices : integer := 1, 2, 3, 4; 
-- (In case keccak_w = 16)
--constant bits_num_slices : integer := 1, 2, 3; 
-- (In case keccak_w = 8)
--constant bits_num_slices : integer := 1, 2; 


--constant num_slices : integer := 2**bits_num_slices;
--constant bit_per_sub_lane : integer := keccak_w/(2**bits_num_slices);

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keccak is
generic(
    keccak_w : integer := 64;
    keccak_r : integer  := 1024;
    num_slices : integer := 32;
    bits_num_slices : integer := 5;
    bit_per_sub_lane : integer := 2;
    din_dout_length : integer := 64
);
  port (
    clk          : in  std_logic;
    rst_n        : in  std_logic;
    init         : in std_logic;
    go           : in std_logic;
    absorb_byte  : in std_logic;
    absorb       : in std_logic;
    squeeze_byte : in std_logic;
    squeeze      : in std_logic;
    din          : in  std_logic_vector((din_dout_length-1) downto 0);
    ready        : out std_logic;
    dout         : out std_logic_vector((din_dout_length-1) downto 0)
);
end keccak;

architecture rtl of keccak is

--components

component keccak_rho_pi
generic(
    keccak_w : integer := 64
);
port (

    rho_pi_in  : in  std_logic_vector((25*keccak_w-1) downto 0);
    rho_pi_out : out std_logic_vector((25*keccak_w-1) downto 0)
);
end component;

component keccak_chi_iota_theta
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
    theta_outp                 : out std_logic_vector((25*bit_per_sub_lane-1) downto 0)
    );
 end component;

component keccak_round_constants_gen
generic(
    keccak_w : integer := 64
);
port(
    round_number: in unsigned(4 downto 0);
    round_constant_signal_out : out std_logic_vector((keccak_w-1) downto 0)
);
 end component;

----------------------------------------------------------------------------
-- Internal signal declarations
----------------------------------------------------------------------------


signal reg_data,rho_pi_out : std_logic_vector((25*keccak_w-1) downto 0);


signal counter_nr_rounds : unsigned(4 downto 0);
signal counter_block : unsigned(bits_num_slices downto 0); -- here you need one more bit since it counts also rho-pi phase

signal round_constant_signal: std_logic_vector((keccak_w-1) downto 0);
signal permutation_computed : std_logic;

signal chi_inp,theta_inp : std_logic_vector((25*bit_per_sub_lane-1) downto 0);


signal k_slice_theta_p_in : std_logic_vector(24 downto 0);
signal theta_parity_inp : std_logic_vector(4 downto 0);
signal first_round : std_logic;
signal first_block : std_logic;
signal round_constant_signal_sub : std_logic_vector((bit_per_sub_lane-1) downto 0);
signal theta_parity_outp,theta_parity_reg : std_logic_vector(4 downto 0);
signal iota_outp : std_logic_vector((25*bit_per_sub_lane-1) downto 0);
signal theta_outp : std_logic_vector((25*bit_per_sub_lane-1) downto 0);

signal absorb_mask : std_logic_vector((din_dout_length-1) downto 0);
signal absorb_byte_mask : std_logic_vector(7 downto 0);
 
  
begin  -- Rtl

-- port map

rho_pi_map: keccak_rho_pi
generic map(
    keccak_w => keccak_w
)
port map
(
    rho_pi_in => reg_data,
    rho_pi_out => rho_pi_out
);


chi_iota_theta_map: keccak_chi_iota_theta 
generic map(
    keccak_w => keccak_w,
    bit_per_sub_lane => bit_per_sub_lane
)
port map
(
    chi_inp => chi_inp,
    theta_inp => theta_inp,
    k_slice_theta_p_in => k_slice_theta_p_in,
    theta_parity_inp => theta_parity_inp,
    first_round => first_round,
    first_block => first_block,
    round_constant_signal => round_constant_signal_sub,
    theta_parity_bit_iota_inp => round_constant_signal(keccak_w-1),
    theta_parity_outp => theta_parity_outp,
    iota_outp => iota_outp,
    theta_outp => theta_outp
);


round_constants_gen: keccak_round_constants_gen 
generic map(
    keccak_w => keccak_w
)
port map(
    round_number => counter_nr_rounds,
    round_constant_signal_out => round_constant_signal
);


absorb_mask <= (others=> absorb);
absorb_byte_mask <= (others=> absorb_byte);


-- state register and counter of the number of rounds

p_main : process (clk, rst_n)

begin  -- process p_main
    if(rst_n = '0') then                 -- asynchronous rst_n (active low)
        reg_data <= (others => '0');
        counter_nr_rounds <= (others => '0');
        counter_block <= (others => '0');
        permutation_computed <='1';
        first_block<='0';
        first_round<='0';
    elsif(rising_edge(clk)) then  -- rising clk edge
        if (init = '1') then
            reg_data <= (others => '0');
            counter_nr_rounds <= (others => '0');
            counter_block <= (others => '0');
            permutation_computed<='1';
            first_block<='0';
            first_round<='0';
        else
            if(go='1') then
                counter_nr_rounds <= (others => '0');
                counter_block <= (others => '0');
                permutation_computed<='0';
                first_block<='1';
                first_round<='1';
                -- do the first semi round
            else
                if(absorb = '1' or squeeze = '1') then
                    -- absorb the input
                    reg_data((keccak_r-1) downto 0) <= (reg_data((din_dout_length - 1) downto 0) xor (absorb_mask and din((din_dout_length - 1) downto 0))) & reg_data((keccak_r-1) downto din_dout_length);
                elsif(absorb_byte = '1' or squeeze_byte = '1') then
                    -- absorb the input
                    reg_data((keccak_r-1) downto 0) <= (reg_data(7 downto 0) xor (absorb_byte_mask and din(7 downto 0))) & reg_data((keccak_r-1) downto 8);
                
                else
                    if(permutation_computed = '0') then
                    --continue computation of the rounds
                        if(counter_block=0) then
                            first_block <='0';
                            counter_block<=counter_block+1;
                            for z in 0 to 24 loop
                                reg_data(((z+1)*keccak_w-1) downto z*keccak_w) <= theta_outp(((z+1)*bit_per_sub_lane - 1) downto z*bit_per_sub_lane) & reg_data(((z+1)*keccak_w-1) downto (z*keccak_w + bit_per_sub_lane));
                            end loop;
                        else
                            first_block <= '0';
                            counter_block <= counter_block+1;
                            if( counter_block = num_slices) then
                                reg_data <= rho_pi_out;
                                
                                counter_block <= (others => '0');
                                counter_nr_rounds<=counter_nr_rounds+1;
                                first_round <='0';
                                first_block <='1';
                            else
                                for z in 0 to 24 loop
                                    reg_data(((z+1)*keccak_w-1) downto z*keccak_w) <= theta_outp(((z+1)*bit_per_sub_lane - 1) downto z*bit_per_sub_lane) & reg_data(((z+1)*keccak_w-1) downto (z*keccak_w + bit_per_sub_lane));
                                end loop;
                            end if;
                        end if;
                        if( counter_nr_rounds = 24) then
                            counter_block<=counter_block+1;
                            for z in 0 to 24 loop
                                reg_data(((z+1)*keccak_w-1) downto z*keccak_w) <= iota_outp(((z+1)*bit_per_sub_lane - 1) downto z*bit_per_sub_lane) & reg_data(((z+1)*keccak_w-1) downto (z*keccak_w + bit_per_sub_lane));
                            end loop;
                            if(counter_block = (num_slices-1)) then
                                -- do the last part of the last round
                                permutation_computed<='1';
                                counter_nr_rounds<= (others => '0');
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end if;
end process p_main;

-- process for the register storing the parity of the previous block
p_reg_parity : process (clk, rst_n)   
begin  -- process p_reg_parity
    if rst_n = '0' then                 -- asynchronous rst_n (active low)
        theta_parity_reg <= (others=>'0');
    elsif rising_edge(clk) then  -- rising clk edge
        theta_parity_reg <= theta_parity_outp;
    end if;
end process p_reg_parity;

-- assign input of the comp block
theta_parity_inp<=theta_parity_reg;

i100: for z in 0 to 24 generate

theta_inp(((z+1)*bit_per_sub_lane - 1) downto z*bit_per_sub_lane)  <= reg_data((z*keccak_w + bit_per_sub_lane - 1) downto z*keccak_w);

chi_inp(((z+1)*bit_per_sub_lane - 1) downto z*bit_per_sub_lane)  <= reg_data((z*keccak_w + bit_per_sub_lane - 1) downto z*keccak_w);

k_slice_theta_p_in(z)  <= reg_data((z+1)*keccak_w-1);

end generate;

-- check bit order

i300: for i in 0 to (bit_per_sub_lane-1) generate

    i300_2: if num_slices = 2 generate
    -- for 2 blocks of slices
    round_constant_signal_sub(i) <= round_constant_signal(i) when (to_01(counter_block)=0) else
                                    round_constant_signal(i+bit_per_sub_lane);
    end generate i300_2;

    i300_4: if num_slices = 4 generate
    -- for 4 blocks of slices
    round_constant_signal_sub(i) <= round_constant_signal(i) when (to_01(counter_block)=0) else
                                    round_constant_signal(i+bit_per_sub_lane) when (counter_block=1) else
                                    round_constant_signal(i+ 2*bit_per_sub_lane) when (counter_block=2) else
                                    round_constant_signal(i+ 3*bit_per_sub_lane);
    end generate i300_4;

    i300_8: if num_slices = 8 generate
    -- for 8 blocks of slices
    round_constant_signal_sub(i) <= round_constant_signal(i) when (to_01(counter_block)=0) else
                                    round_constant_signal(i+bit_per_sub_lane) when (counter_block=1) else
                                    round_constant_signal(i+ 2*bit_per_sub_lane) when (counter_block=2) else
                                    round_constant_signal(i+ 3*bit_per_sub_lane) when (counter_block=3) else
                                    round_constant_signal(i+ 4*bit_per_sub_lane) when (counter_block=4) else
                                    round_constant_signal(i+ 5*bit_per_sub_lane) when (counter_block=5) else
                                    round_constant_signal(i+ 6*bit_per_sub_lane) when (counter_block=6) else
                                    round_constant_signal(i+ 7*bit_per_sub_lane);
    end generate i300_8;

    i300_16: if num_slices = 16 generate
    -- for 16 blocks of slices
    round_constant_signal_sub(i) <= round_constant_signal(i) when (to_01(counter_block)=0) else
                                    round_constant_signal(i+bit_per_sub_lane) when (counter_block=1) else
                                    round_constant_signal(i+ 2*bit_per_sub_lane) when (counter_block=2) else
                                    round_constant_signal(i+ 3*bit_per_sub_lane) when (counter_block=3) else
                                    round_constant_signal(i+ 4*bit_per_sub_lane) when (counter_block=4) else
                                    round_constant_signal(i+ 5*bit_per_sub_lane) when (counter_block=5) else
                                    round_constant_signal(i+ 6*bit_per_sub_lane) when (counter_block=6) else
                                    round_constant_signal(i+ 7*bit_per_sub_lane) when (counter_block=7) else
                                    round_constant_signal(i+ 8*bit_per_sub_lane) when (counter_block=8) else
                                    round_constant_signal(i+ 9*bit_per_sub_lane) when (counter_block=9) else
                                    round_constant_signal(i+ 10*bit_per_sub_lane) when (counter_block=10) else
                                    round_constant_signal(i+ 11*bit_per_sub_lane) when (counter_block=11) else
                                    round_constant_signal(i+ 12*bit_per_sub_lane) when (counter_block=12) else
                                    round_constant_signal(i+ 13*bit_per_sub_lane) when (counter_block=13) else
                                    round_constant_signal(i+ 14*bit_per_sub_lane) when (counter_block=14) else
                                    round_constant_signal(i+ 15*bit_per_sub_lane);
    end generate i300_16;

    i300_32: if num_slices = 32 generate
    -- for 32 blocks of slices
    round_constant_signal_sub(i) <= round_constant_signal(i) when (to_01(counter_block)=0) else
                                    round_constant_signal(i+bit_per_sub_lane) when (to_01(counter_block)=1) else
                                    round_constant_signal(i+ 2*bit_per_sub_lane) when (to_01(counter_block)=2) else
                                    round_constant_signal(i+ 3*bit_per_sub_lane) when (to_01(counter_block)=3) else
                                    round_constant_signal(i+ 4*bit_per_sub_lane) when (to_01(counter_block)=4) else
                                    round_constant_signal(i+ 5*bit_per_sub_lane) when (to_01(counter_block)=5) else
                                    round_constant_signal(i+ 6*bit_per_sub_lane) when (to_01(counter_block)=6) else
                                    round_constant_signal(i+ 7*bit_per_sub_lane) when (to_01(counter_block)=7) else
                                    round_constant_signal(i+ 8*bit_per_sub_lane) when (to_01(counter_block)=8) else
                                    round_constant_signal(i+ 9*bit_per_sub_lane) when (to_01(counter_block)=9) else
                                    round_constant_signal(i+ 10*bit_per_sub_lane) when (to_01(counter_block)=10) else
                                    round_constant_signal(i+ 11*bit_per_sub_lane) when (to_01(counter_block)=11) else
                                    round_constant_signal(i+ 12*bit_per_sub_lane) when (to_01(counter_block)=12) else
                                    round_constant_signal(i+ 13*bit_per_sub_lane) when (to_01(counter_block)=13) else
                                    round_constant_signal(i+ 14*bit_per_sub_lane) when (to_01(counter_block)=14) else
                                    round_constant_signal(i+ 15*bit_per_sub_lane) when (to_01(counter_block)=15) else
                                    round_constant_signal(i+ 16*bit_per_sub_lane) when (to_01(counter_block)=16) else
                                    round_constant_signal(i+ 17*bit_per_sub_lane) when (to_01(counter_block)=17) else
                                    round_constant_signal(i+ 18*bit_per_sub_lane) when (to_01(counter_block)=18) else
                                    round_constant_signal(i+ 19*bit_per_sub_lane) when (to_01(counter_block)=19) else
                                    round_constant_signal(i+ 20*bit_per_sub_lane) when (to_01(counter_block)=20) else
                                    round_constant_signal(i+ 21*bit_per_sub_lane) when (to_01(counter_block)=21) else
                                    round_constant_signal(i+ 22*bit_per_sub_lane) when (to_01(counter_block)=22) else
                                    round_constant_signal(i+ 23*bit_per_sub_lane) when (to_01(counter_block)=23) else
                                    round_constant_signal(i+ 24*bit_per_sub_lane) when (to_01(counter_block)=24) else
                                    round_constant_signal(i+ 25*bit_per_sub_lane) when (to_01(counter_block)=25) else
                                    round_constant_signal(i+ 26*bit_per_sub_lane) when (to_01(counter_block)=26) else
                                    round_constant_signal(i+ 27*bit_per_sub_lane) when (to_01(counter_block)=27) else
                                    round_constant_signal(i+ 28*bit_per_sub_lane) when (to_01(counter_block)=28) else
                                    round_constant_signal(i+ 29*bit_per_sub_lane) when (to_01(counter_block)=29) else
                                    round_constant_signal(i+ 30*bit_per_sub_lane) when (to_01(counter_block)=30) else
                                    round_constant_signal(i+ 31*bit_per_sub_lane);
    end generate i300_32;

end generate;

ready<=permutation_computed;

-- check if output order is correct or if dout should be connected to another register

dout((din_dout_length-1) downto 0) <= reg_data(din_dout_length-1 downto 0);

end rtl;