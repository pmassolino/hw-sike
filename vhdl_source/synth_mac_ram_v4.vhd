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

entity synth_mac_ram_v4 is
    Generic (
        small_bus_ram_address_size : integer;
        full_bus_address_factor_size : integer;
        small_bus_ram_word_size : integer;
        multiplication_factor : integer
    );
    Port (
        clk : in std_logic;
        small_bus_mode : in std_logic;
        small_bus_enable : in std_logic;
        full_bus_enable : in std_logic;
        data_in_one_a_full_bus_mode : in std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_in_one_b_full_bus_mode : in std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_in_two_a_full_bus_mode : in std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_in_two_b_full_bus_mode : in std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        enable_write_one_a_full_bus_mode : in std_logic;
        enable_write_one_b_full_bus_mode : in std_logic;
        enable_write_two_a_full_bus_mode : in std_logic;
        enable_write_two_b_full_bus_mode : in std_logic;
        address_data_one_a_full_bus_mode : in std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);
        address_data_one_b_full_bus_mode : in std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);
        address_data_two_a_full_bus_mode : in std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);
        address_data_two_b_full_bus_mode : in std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);
        data_out_one_a_full_bus_mode : out std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_out_one_b_full_bus_mode : out std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_out_two_a_full_bus_mode : out std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_out_two_b_full_bus_mode : out std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);
        data_in_small_bus_mode : in std_logic_vector((small_bus_ram_word_size - 1) downto 0);
        enable_write_small_bus_mode : std_logic;
        address_data_in_small_bus_mode : in std_logic_vector((small_bus_ram_address_size - 1) downto 0);
        address_data_out_small_bus_mode : in std_logic_vector((small_bus_ram_address_size - 1) downto 0);
        data_out_small_bus_mode : out std_logic_vector((small_bus_ram_word_size - 1) downto 0)
    );
end synth_mac_ram_v4;

architecture behavioral_small_memories of synth_mac_ram_v4 is

component synth_double_ram
    generic (
        ram_address_size : integer;
        ram_word_size : integer
    );
    port (
        enable_a : std_logic;
        enable_b : std_logic;
        data_in_a : in std_logic_vector((ram_word_size - 1) downto 0);
        data_in_b : in std_logic_vector((ram_word_size - 1) downto 0);
        read_write_a : in std_logic;
        read_write_b : in std_logic;
        clk : in std_logic;
        address_a : in std_logic_vector((ram_address_size - 1) downto 0);
        address_b : in std_logic_vector((ram_address_size - 1) downto 0);
        data_out_a : out std_logic_vector((ram_word_size - 1) downto 0);
        data_out_b : out std_logic_vector((ram_word_size - 1) downto 0)
    );
end component;

signal address_data_in_small_bus_mode_high_address : std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);
signal address_data_in_small_bus_mode_low_address : unsigned((full_bus_address_factor_size - 1) downto 0);
signal address_data_out_small_bus_mode_high_address : std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);
signal address_data_out_small_bus_mode_low_address : unsigned((full_bus_address_factor_size - 1) downto 0);
signal reg_address_data_out_small_bus_mode_low_address : unsigned((full_bus_address_factor_size - 1) downto 0);

type multiple_ramdata is array(integer range <>) of std_logic_vector((small_bus_ram_word_size - 1) downto 0);
type multiple_ramaddress is array(integer range <>) of std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);

type multiple_debug_memories is array(integer range <>) of std_logic_vector((small_bus_ram_word_size*(2**(small_bus_ram_address_size-full_bus_address_factor_size)) - 1) downto 0);

signal memory_ram_one_enable_a : std_logic_vector(0 to (multiplication_factor-1));
signal memory_ram_one_enable_b : std_logic_vector(0 to (multiplication_factor-1));
signal memory_ram_one_data_in_a : multiple_ramdata(0 to (multiplication_factor-1));
signal memory_ram_one_data_in_b : multiple_ramdata(0 to (multiplication_factor-1));
signal memory_ram_one_rw_a : std_logic_vector(0 to (multiplication_factor-1));
signal memory_ram_one_rw_b : std_logic_vector(0 to (multiplication_factor-1));
signal memory_ram_one_address_a : multiple_ramaddress(0 to (multiplication_factor-1));
signal memory_ram_one_address_b : multiple_ramaddress(0 to (multiplication_factor-1));
signal memory_ram_one_data_out_a : multiple_ramdata(0 to (multiplication_factor-1));
signal memory_ram_one_data_out_b : multiple_ramdata(0 to (multiplication_factor-1));

signal memory_ram_two_enable_a : std_logic_vector(0 to (multiplication_factor-1));
signal memory_ram_two_enable_b : std_logic_vector(0 to (multiplication_factor-1));
signal memory_ram_two_data_in_a : multiple_ramdata(0 to (multiplication_factor-1));
signal memory_ram_two_data_in_b : multiple_ramdata(0 to (multiplication_factor-1));
signal memory_ram_two_rw_a : std_logic_vector(0 to (multiplication_factor-1));
signal memory_ram_two_rw_b : std_logic_vector(0 to (multiplication_factor-1));
signal memory_ram_two_address_a : multiple_ramaddress(0 to (multiplication_factor-1));
signal memory_ram_two_address_b : multiple_ramaddress(0 to (multiplication_factor-1));
signal memory_ram_two_data_out_a : multiple_ramdata(0 to (multiplication_factor-1));
signal memory_ram_two_data_out_b : multiple_ramdata(0 to (multiplication_factor-1));

begin

address_data_in_small_bus_mode_high_address  <= address_data_in_small_bus_mode((small_bus_ram_address_size - 1) downto full_bus_address_factor_size);
address_data_in_small_bus_mode_low_address   <= unsigned(address_data_in_small_bus_mode((full_bus_address_factor_size - 1) downto 0));
address_data_out_small_bus_mode_high_address <= address_data_out_small_bus_mode((small_bus_ram_address_size - 1) downto full_bus_address_factor_size);
address_data_out_small_bus_mode_low_address  <= unsigned(address_data_out_small_bus_mode((full_bus_address_factor_size - 1) downto 0));

process(clk)
begin
    if(rising_edge(clk)) then
        reg_address_data_out_small_bus_mode_low_address <= address_data_out_small_bus_mode_low_address;
    end if;
end process;

all_memories : for I in 0 to (multiplication_factor-1) generate

memory_ram_one : synth_double_ram
    generic map(
        ram_address_size => small_bus_ram_address_size-full_bus_address_factor_size,
        ram_word_size => small_bus_ram_word_size
    )
    port map(
        enable_a => memory_ram_one_enable_a(I),
        enable_b => memory_ram_one_enable_b(I),
        data_in_a => memory_ram_one_data_in_a(I),
        data_in_b => memory_ram_one_data_in_b(I),
        read_write_a => memory_ram_one_rw_a(I),
        read_write_b => memory_ram_one_rw_b(I),
        clk => clk,
        address_a => memory_ram_one_address_a(I),
        address_b => memory_ram_one_address_b(I),
        data_out_a => memory_ram_one_data_out_a(I),
        data_out_b => memory_ram_one_data_out_b(I)
    );
    
memory_ram_two : synth_double_ram
    generic map(
        ram_address_size => small_bus_ram_address_size-full_bus_address_factor_size,
        ram_word_size => small_bus_ram_word_size
    )
    port map(
        enable_a => memory_ram_two_enable_a(I),
        enable_b => memory_ram_two_enable_b(I),
        data_in_a => memory_ram_two_data_in_a(I),
        data_in_b => memory_ram_two_data_in_b(I),
        read_write_a => memory_ram_two_rw_a(I),
        read_write_b => memory_ram_two_rw_b(I),
        clk => clk,
        address_a => memory_ram_two_address_a(I),
        address_b => memory_ram_two_address_b(I),
        data_out_a => memory_ram_two_data_out_a(I),
        data_out_b => memory_ram_two_data_out_b(I)
    );

memory_ram_one_enable_a(I) <= full_bus_enable when (small_bus_mode = '0') else
                              small_bus_enable when (to_01(address_data_in_small_bus_mode_low_address) = (to_unsigned(I, full_bus_address_factor_size))) else
                              '0';
memory_ram_one_enable_b(I) <= full_bus_enable when (small_bus_mode = '0') else
                              small_bus_enable when (to_01(address_data_out_small_bus_mode_low_address) = (to_unsigned(I, full_bus_address_factor_size))) else
                              '0';
memory_ram_one_data_in_a(I) <= data_in_one_a_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size) when (small_bus_mode = '0') else
                               data_in_small_bus_mode;
memory_ram_one_data_in_b(I) <= data_in_one_b_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size);
memory_ram_one_rw_a(I) <= enable_write_one_a_full_bus_mode when (small_bus_mode = '0') else
                          enable_write_small_bus_mode;
memory_ram_one_rw_b(I) <= enable_write_one_b_full_bus_mode when (small_bus_mode = '0') else
                          '0';
memory_ram_one_address_a(I) <= address_data_one_a_full_bus_mode when (small_bus_mode = '0') else
                               address_data_in_small_bus_mode_high_address;
memory_ram_one_address_b(I) <= address_data_one_b_full_bus_mode when (small_bus_mode = '0') else
                               address_data_out_small_bus_mode_high_address;

memory_ram_two_enable_a(I) <= full_bus_enable when (small_bus_mode = '0') else
                              small_bus_enable when (to_01(address_data_in_small_bus_mode_low_address) = (to_unsigned(I, full_bus_address_factor_size))) else
                              '0';
memory_ram_two_enable_b(I) <= full_bus_enable when (small_bus_mode = '0') else
                              small_bus_enable when (to_01(address_data_out_small_bus_mode_low_address) = (to_unsigned(I, full_bus_address_factor_size))) else
                              '0';
memory_ram_two_data_in_a(I) <= data_in_two_a_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size) when (small_bus_mode = '0') else
                               data_in_small_bus_mode;
memory_ram_two_data_in_b(I) <= data_in_two_b_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size);
memory_ram_two_rw_a(I) <= enable_write_two_a_full_bus_mode when (small_bus_mode = '0') else
                          enable_write_small_bus_mode;
memory_ram_two_rw_b(I) <= enable_write_two_b_full_bus_mode when (small_bus_mode = '0') else
                          '0';
memory_ram_two_address_a(I) <= address_data_two_a_full_bus_mode when (small_bus_mode = '0') else
                               address_data_in_small_bus_mode_high_address;
memory_ram_two_address_b(I) <= address_data_two_b_full_bus_mode when (small_bus_mode = '0') else
                               address_data_out_small_bus_mode_high_address;

data_out_one_a_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size) <= memory_ram_one_data_out_a(I);
data_out_one_b_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size) <= memory_ram_one_data_out_b(I);
data_out_two_a_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size) <= memory_ram_two_data_out_a(I);
data_out_two_b_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size) <= memory_ram_two_data_out_b(I);

end generate;

data_out_small_bus_mode <= memory_ram_two_data_out_b(to_integer(to_01(reg_address_data_out_small_bus_mode_low_address)));

end behavioral_small_memories;




architecture behavioral_one_memory of synth_mac_ram_v4 is

type memory_type is array(0 to (2**(small_bus_ram_address_size - full_bus_address_factor_size)-1)) of std_logic_vector((multiplication_factor*small_bus_ram_word_size - 1) downto 0);

signal memory : memory_type;

signal address_data_in_small_bus_mode_high_address : std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);
signal address_data_in_small_bus_mode_low_address : unsigned((full_bus_address_factor_size - 1) downto 0);
signal address_data_out_small_bus_mode_high_address : std_logic_vector((small_bus_ram_address_size - full_bus_address_factor_size - 1) downto 0);
signal address_data_out_small_bus_mode_low_address : unsigned((full_bus_address_factor_size - 1) downto 0);


begin

address_data_in_small_bus_mode_high_address  <= address_data_in_small_bus_mode((small_bus_ram_address_size - 1) downto full_bus_address_factor_size);
address_data_in_small_bus_mode_low_address   <= unsigned(address_data_in_small_bus_mode((full_bus_address_factor_size - 1) downto 0));
address_data_out_small_bus_mode_high_address <= address_data_out_small_bus_mode((small_bus_ram_address_size - 1) downto full_bus_address_factor_size);
address_data_out_small_bus_mode_low_address  <= unsigned(address_data_out_small_bus_mode((full_bus_address_factor_size - 1) downto 0));

process(clk)
begin
    if(rising_edge(clk)) then
        if(small_bus_mode = '0') then
            if(full_bus_enable = '1') then
                if(enable_write_one_a_full_bus_mode = '1') then
                    memory(to_integer(to_01(unsigned(address_data_one_a_full_bus_mode)))) <= data_in_one_a_full_bus_mode;
                end if;
                data_out_one_a_full_bus_mode <= memory(to_integer(to_01(unsigned(address_data_one_a_full_bus_mode))));
                if(enable_write_one_b_full_bus_mode = '1') then
                    memory(to_integer(to_01(unsigned(address_data_one_b_full_bus_mode)))) <= data_in_one_b_full_bus_mode;
                end if;
                data_out_one_b_full_bus_mode <= memory(to_integer(to_01(unsigned(address_data_one_b_full_bus_mode))));
                
                if(enable_write_two_a_full_bus_mode = '1') then
                    memory(to_integer(to_01(unsigned(address_data_two_a_full_bus_mode)))) <= data_in_two_a_full_bus_mode;
                end if;
                data_out_two_a_full_bus_mode <= memory(to_integer(to_01(unsigned(address_data_two_a_full_bus_mode))));
                if(enable_write_two_b_full_bus_mode = '1') then
                    memory(to_integer(to_01(unsigned(address_data_two_b_full_bus_mode)))) <= data_in_two_b_full_bus_mode;
                end if;
                data_out_two_b_full_bus_mode <= memory(to_integer(to_01(unsigned(address_data_two_b_full_bus_mode))));
            end if;
        else 
            if(small_bus_enable = '1') then
                if(enable_write_small_bus_mode = '1') then
                    memory(to_integer(to_01(unsigned(address_data_in_small_bus_mode_high_address))))(((to_integer(to_01(address_data_in_small_bus_mode_low_address))+1)*(small_bus_ram_word_size) - 1) downto ((to_integer(to_01(address_data_in_small_bus_mode_low_address)))*small_bus_ram_word_size)) <= data_in_small_bus_mode;
                end if;
                data_out_small_bus_mode <= memory(to_integer(to_01(unsigned(address_data_out_small_bus_mode_high_address))))(((to_integer(to_01(address_data_out_small_bus_mode_low_address))+1)*(small_bus_ram_word_size) - 1) downto ((to_integer(to_01(unsigned(address_data_out_small_bus_mode_low_address))))*small_bus_ram_word_size));
            end if;
        end if;
    end if;
end process;

end behavioral_one_memory;