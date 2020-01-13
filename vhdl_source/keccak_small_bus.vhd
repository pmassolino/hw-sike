--
-- Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
--
-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keccak_small_bus is
generic(
    small_bus_word_size : integer := 16;
    small_bus_address_size : integer := 11
);
  port (
    clk     : in  std_logic;
    rstn    : in  std_logic;
    init    : in std_logic;
    go      : in std_logic;
    ready   : out std_logic;
    small_bus_enable : in std_logic;
    small_bus_data_in : in std_logic_vector((small_bus_word_size - 1) downto 0);
    small_bus_write_enable : in std_logic;
    small_bus_address_data_in : in std_logic_vector((small_bus_address_size - 1) downto 0);
    small_bus_address_data_out : in std_logic_vector((small_bus_address_size - 1) downto 0);
    small_bus_data_out : out std_logic_vector((small_bus_word_size - 1) downto 0)
);
end keccak_small_bus;

architecture behavioral of keccak_small_bus is

component keccak
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
    din          : in std_logic_vector((din_dout_length-1) downto 0);
    ready        : out std_logic;
    dout         : out std_logic_vector((din_dout_length-1) downto 0)
);
end component;

signal shake256_init : std_logic;
signal shake256_go : std_logic;
signal shake256_absorb_byte : std_logic;
signal shake256_absorb : std_logic;
signal shake256_squeeze_byte : std_logic;
signal shake256_squeeze : std_logic;
signal shake256_din : std_logic_vector((small_bus_word_size-1) downto 0);
signal shake256_ready : std_logic;
signal shake256_dout : std_logic_vector((small_bus_word_size-1) downto 0);

constant shake256_absorb_byte_lsb_start_address   : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#00000#, small_bus_address_size);
constant shake256_absorb_byte_lsb_last_address    : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#0007F#, small_bus_address_size);
constant shake256_absorb_byte_msb_start_address   : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#00080#, small_bus_address_size);
constant shake256_absorb_byte_msb_last_address    : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#000FF#, small_bus_address_size);
constant shake256_absorb_word_start_address       : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#00100#, small_bus_address_size);
constant shake256_absorb_word_last_address        : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#0017F#, small_bus_address_size);
constant shake256_absorb_word_swp_start_address   : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#00180#, small_bus_address_size);
constant shake256_absorb_word_swp_last_address    : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#001FF#, small_bus_address_size);

constant shake256_squeeze_byte_start_address      : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#00200#, small_bus_address_size);
constant shake256_squeeze_byte_last_address       : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#002FF#, small_bus_address_size);
constant shake256_squeeze_word_start_address      : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#00300#, small_bus_address_size);
constant shake256_squeeze_word_last_address       : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#003FF#, small_bus_address_size);
constant shake256_dout_address                    : unsigned(small_bus_address_size - 1 downto 0) := to_unsigned(16#00400#, small_bus_address_size);

begin

process(clk, rstn)
begin
    if(rstn = '0') then
        shake256_absorb_byte <= '0';
    elsif(rising_edge(clk)) then
        if((small_bus_enable = '1') and (small_bus_write_enable = '1') and (small_bus_address_data_in(10 downto 8) = "000")) then
            shake256_absorb_byte <= '1';
        else
            shake256_absorb_byte <= '0';
        end if;
    end if;
end process;

process(clk, rstn)
begin
    if(rstn = '0') then
        shake256_absorb <= '0';
    elsif(rising_edge(clk)) then
        if((small_bus_enable = '1') and (small_bus_write_enable = '1') and (small_bus_address_data_in(10 downto 8) = "001")) then
            shake256_absorb <= '1';
        else
            shake256_absorb <= '0';
        end if;
    end if;
end process;

process(clk, rstn)
begin
    if(rstn = '0') then
        shake256_squeeze_byte <= '0';
    elsif(rising_edge(clk)) then
        if((small_bus_enable = '1') and (small_bus_write_enable = '1') and (small_bus_address_data_in(10 downto 8) = "010")) then
            shake256_squeeze_byte <= '1';
        else
            shake256_squeeze_byte <= '0';
        end if;
    end if;
end process;

process(clk, rstn)
begin
    if(rstn = '0') then
        shake256_squeeze <= '0';
    elsif(rising_edge(clk)) then
        if((small_bus_enable = '1') and (small_bus_write_enable = '1') and (small_bus_address_data_in(10 downto 8) = "011")) then
            shake256_squeeze <= '1';
        else
            shake256_squeeze <= '0';
        end if;
    end if;
end process;

process(clk, rstn)
begin
    if(rstn = '0') then
        shake256_din <= (others => '0');
    elsif(rising_edge(clk)) then
        if((small_bus_address_data_in(10 downto 7) = "0001") or (small_bus_address_data_in(10 downto 7) = "0011")) then
            shake256_din <= small_bus_data_in(7 downto 0) & small_bus_data_in(15 downto 8);
        else
            shake256_din <= small_bus_data_in;
        end if;
    end if;
end process;

process(clk, rstn)
begin
    if(rstn = '0') then
        small_bus_data_out <= (others => '0');
    elsif(rising_edge(clk)) then
        if((small_bus_enable = '1') and (small_bus_address_data_out = std_logic_vector(shake256_dout_address))) then
            small_bus_data_out <= shake256_dout;
        else
            small_bus_data_out <= (others => '0');
        end if;
    end if;
end process;

shake256_init <= init;
shake256_go <= go;

ready <= shake256_ready;

shake256 : keccak
generic map(
    keccak_w => 64,
    keccak_r => 1088,
    num_slices => 2,
    bits_num_slices => 1,
    bit_per_sub_lane => 32,
    din_dout_length => small_bus_word_size
    )
port map(
    clk          => clk,
    rst_n        => rstn,
    init         => shake256_init,
    go           => shake256_go,
    absorb_byte  => shake256_absorb_byte,
    absorb       => shake256_absorb,
    squeeze_byte => shake256_squeeze_byte,
    squeeze      => shake256_squeeze,
    din          => shake256_din,
    ready        => shake256_ready,
    dout         => shake256_dout
);

end behavioral;