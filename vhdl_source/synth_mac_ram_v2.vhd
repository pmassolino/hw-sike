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

entity synth_mac_ram_v2 is
    Generic (
        small_bus_ram_address_size : integer;
        small_bus_ram_word_size : integer
    );
    Port (
        clk : in std_logic;
        small_bus_mode : in std_logic;
        small_bus_enable : in std_logic;
        full_bus_enable : in std_logic;
        data_in_one_a_full_bus_mode : in std_logic_vector((16*small_bus_ram_word_size - 1) downto 0);
        data_in_one_b_full_bus_mode : in std_logic_vector((16*small_bus_ram_word_size - 1) downto 0);
        data_in_two_a_full_bus_mode : in std_logic_vector((16*small_bus_ram_word_size - 1) downto 0);
        data_in_two_b_full_bus_mode : in std_logic_vector((16*small_bus_ram_word_size - 1) downto 0);
        enable_write_one_a_full_bus_mode : in std_logic;
        enable_write_one_b_full_bus_mode : in std_logic;
        enable_write_two_a_full_bus_mode : in std_logic;
        enable_write_two_b_full_bus_mode : in std_logic;
        address_data_one_a_full_bus_mode : in std_logic_vector((small_bus_ram_address_size - 5) downto 0);
        address_data_one_b_full_bus_mode : in std_logic_vector((small_bus_ram_address_size - 5) downto 0);
        address_data_two_a_full_bus_mode : in std_logic_vector((small_bus_ram_address_size - 5) downto 0);
        address_data_two_b_full_bus_mode : in std_logic_vector((small_bus_ram_address_size - 5) downto 0);
        data_out_one_a_full_bus_mode : out std_logic_vector((16*small_bus_ram_word_size - 1) downto 0);
        data_out_one_b_full_bus_mode : out std_logic_vector((16*small_bus_ram_word_size - 1) downto 0);
        data_out_two_a_full_bus_mode : out std_logic_vector((16*small_bus_ram_word_size - 1) downto 0);
        data_out_two_b_full_bus_mode : out std_logic_vector((16*small_bus_ram_word_size - 1) downto 0);
        data_in_small_bus_mode : in std_logic_vector((small_bus_ram_word_size - 1) downto 0);
        enable_write_small_bus_mode : std_logic;
        address_data_in_small_bus_mode : in std_logic_vector((small_bus_ram_address_size - 1) downto 0);
        address_data_out_small_bus_mode : in std_logic_vector((small_bus_ram_address_size - 1) downto 0);
        data_out_small_bus_mode : out std_logic_vector((small_bus_ram_word_size - 1) downto 0)
    );
end synth_mac_ram_v2;

architecture behavioral_small_memories of synth_mac_ram_v2 is

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

type multiple_ramdata is array(integer range <>) of std_logic_vector((small_bus_ram_word_size - 1) downto 0);
type multiple_ramaddress is array(integer range <>) of std_logic_vector((small_bus_ram_address_size - 5) downto 0);

signal memory_ram_one_enable_a : std_logic_vector(0 to 15);
signal memory_ram_one_enable_b : std_logic_vector(0 to 15);
signal memory_ram_one_data_in_a : multiple_ramdata(0 to 15);
signal memory_ram_one_data_in_b : multiple_ramdata(0 to 15);
signal memory_ram_one_rw_a : std_logic_vector(0 to 15);
signal memory_ram_one_rw_b : std_logic_vector(0 to 15);
signal memory_ram_one_address_a : multiple_ramaddress(0 to 15);
signal memory_ram_one_address_b : multiple_ramaddress(0 to 15);
signal memory_ram_one_data_out_a : multiple_ramdata(0 to 15);
signal memory_ram_one_data_out_b : multiple_ramdata(0 to 15);

signal memory_ram_two_enable_a : std_logic_vector(0 to 15);
signal memory_ram_two_enable_b : std_logic_vector(0 to 15);
signal memory_ram_two_data_in_a : multiple_ramdata(0 to 15);
signal memory_ram_two_data_in_b : multiple_ramdata(0 to 15);
signal memory_ram_two_rw_a : std_logic_vector(0 to 15);
signal memory_ram_two_rw_b : std_logic_vector(0 to 15);
signal memory_ram_two_address_a : multiple_ramaddress(0 to 15);
signal memory_ram_two_address_b : multiple_ramaddress(0 to 15);
signal memory_ram_two_data_out_a : multiple_ramdata(0 to 15);
signal memory_ram_two_data_out_b : multiple_ramdata(0 to 15);

begin

all_memories : for I in 0 to 15 generate

memory_ram_one : synth_double_ram
    generic map(
        ram_address_size => small_bus_ram_address_size-4,
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
        ram_address_size => small_bus_ram_address_size-4,
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
                              small_bus_enable when (address_data_in_small_bus_mode(3 downto 0) = std_logic_vector(to_unsigned(I, 4))) else
                              '0';
memory_ram_one_enable_b(I) <= full_bus_enable when (small_bus_mode = '0') else
                              small_bus_enable when ((address_data_out_small_bus_mode(3 downto 0) = std_logic_vector(to_unsigned(I, 4)))) else
                              '0';
memory_ram_one_data_in_a(I) <= data_in_one_a_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size) when (small_bus_mode = '0') else
                               data_in_small_bus_mode;
memory_ram_one_data_in_b(I) <= data_in_one_b_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size);
memory_ram_one_rw_a(I) <= enable_write_one_a_full_bus_mode when (small_bus_mode = '0') else
                          enable_write_small_bus_mode;
memory_ram_one_rw_b(I) <= enable_write_one_b_full_bus_mode when (small_bus_mode = '0') else
                          '0';
memory_ram_one_address_a(I) <= address_data_one_a_full_bus_mode when (small_bus_mode = '0') else
                               address_data_in_small_bus_mode((small_bus_ram_address_size - 1) downto 4);
memory_ram_one_address_b(I) <= address_data_one_b_full_bus_mode when (small_bus_mode = '0') else
                               address_data_out_small_bus_mode((small_bus_ram_address_size - 1) downto 4);

memory_ram_two_enable_a(I) <= full_bus_enable when (small_bus_mode = '0') else
                              small_bus_enable when (address_data_in_small_bus_mode(3 downto 0) = std_logic_vector(to_unsigned(I, 4))) else
                              '0';
memory_ram_two_enable_b(I) <= full_bus_enable when (small_bus_mode = '0') else
                              small_bus_enable when (address_data_out_small_bus_mode(3 downto 0) = std_logic_vector(to_unsigned(I, 4))) else
                              '0';
memory_ram_two_data_in_a(I) <= data_in_two_a_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size) when (small_bus_mode = '0') else
                               data_in_small_bus_mode;
memory_ram_two_data_in_b(I) <= data_in_two_b_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size);
memory_ram_two_rw_a(I) <= enable_write_two_a_full_bus_mode when (small_bus_mode = '0') else
                          enable_write_small_bus_mode;
memory_ram_two_rw_b(I) <= enable_write_two_b_full_bus_mode when (small_bus_mode = '0') else
                          '0';
memory_ram_two_address_a(I) <= address_data_two_a_full_bus_mode when (small_bus_mode = '0') else
                               address_data_in_small_bus_mode((small_bus_ram_address_size - 1) downto 4);
memory_ram_two_address_b(I) <= address_data_two_b_full_bus_mode when (small_bus_mode = '0') else
                               address_data_out_small_bus_mode((small_bus_ram_address_size - 1) downto 4);

data_out_one_a_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size) <= memory_ram_one_data_out_a(I);
data_out_one_b_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size) <= memory_ram_one_data_out_b(I);
data_out_two_a_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size) <= memory_ram_two_data_out_a(I);
data_out_two_b_full_bus_mode(((I+1)*small_bus_ram_word_size - 1) downto I*small_bus_ram_word_size) <= memory_ram_two_data_out_b(I);

end generate;

data_out_small_bus_mode <= memory_ram_two_data_out_b(0)  when (address_data_out_small_bus_mode(3 downto 0) = "0000") else
                           memory_ram_two_data_out_b(1)  when (address_data_out_small_bus_mode(3 downto 0) = "0001") else
                           memory_ram_two_data_out_b(2)  when (address_data_out_small_bus_mode(3 downto 0) = "0010") else
                           memory_ram_two_data_out_b(3)  when (address_data_out_small_bus_mode(3 downto 0) = "0011") else
                           memory_ram_two_data_out_b(4)  when (address_data_out_small_bus_mode(3 downto 0) = "0100") else
                           memory_ram_two_data_out_b(5)  when (address_data_out_small_bus_mode(3 downto 0) = "0101") else
                           memory_ram_two_data_out_b(6)  when (address_data_out_small_bus_mode(3 downto 0) = "0110") else
                           memory_ram_two_data_out_b(7)  when (address_data_out_small_bus_mode(3 downto 0) = "0111") else
                           memory_ram_two_data_out_b(8)  when (address_data_out_small_bus_mode(3 downto 0) = "1000") else
                           memory_ram_two_data_out_b(9)  when (address_data_out_small_bus_mode(3 downto 0) = "1001") else
                           memory_ram_two_data_out_b(10) when (address_data_out_small_bus_mode(3 downto 0) = "1010") else
                           memory_ram_two_data_out_b(11) when (address_data_out_small_bus_mode(3 downto 0) = "1011") else
                           memory_ram_two_data_out_b(12) when (address_data_out_small_bus_mode(3 downto 0) = "1100") else
                           memory_ram_two_data_out_b(13) when (address_data_out_small_bus_mode(3 downto 0) = "1101") else
                           memory_ram_two_data_out_b(14) when (address_data_out_small_bus_mode(3 downto 0) = "1110") else
                           memory_ram_two_data_out_b(15);

end behavioral_small_memories;





architecture behavioral_one_memory of synth_mac_ram_v2 is

type memory_type is array(0 to (2**(small_bus_ram_address_size - 4)-1)) of std_logic_vector((16*small_bus_ram_word_size - 1) downto 0);

signal memory : memory_type;

signal address_data_in_small_bus_mode_high_address : std_logic_vector((small_bus_ram_address_size - 5) downto 0);
signal address_data_in_small_bus_mode_low_address : unsigned(3 downto 0);
signal address_data_out_small_bus_mode_high_address : std_logic_vector((small_bus_ram_address_size - 5) downto 0);
signal address_data_out_small_bus_mode_low_address : unsigned(3 downto 0);


begin

address_data_in_small_bus_mode_high_address  <= address_data_in_small_bus_mode((small_bus_ram_address_size - 1) downto 4);
address_data_in_small_bus_mode_low_address   <= unsigned(address_data_in_small_bus_mode(3 downto 0));
address_data_out_small_bus_mode_high_address <= address_data_out_small_bus_mode((small_bus_ram_address_size - 1) downto 4);
address_data_out_small_bus_mode_low_address  <= unsigned(address_data_out_small_bus_mode(3 downto 0));

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