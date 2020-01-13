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

entity synth_base_alu_ram_v3 is
    Generic (
        small_bus_ram_address_size : integer;
        small_bus_ram_word_size : integer
    );
    Port (
        clk : in std_logic;
        enable : in std_logic;
        operation_mode : in std_logic;
        data_in        : in std_logic_vector((small_bus_ram_word_size - 1) downto 0);
        address_in     : in std_logic_vector((small_bus_ram_address_size - 1) downto 0);
        address_out_0  : in std_logic_vector((small_bus_ram_address_size - 1) downto 0);
        address_out_1  : in std_logic_vector((small_bus_ram_address_size - 1) downto 0);
        write_enable   : in std_logic;
        data_out_0     : out std_logic_vector((small_bus_ram_word_size - 1) downto 0);
        data_out_1     : out std_logic_vector((small_bus_ram_word_size - 1) downto 0)
    );
end synth_base_alu_ram_v3;

architecture behavioral of synth_base_alu_ram_v3 is

component synth_double_ram
    generic (
        ram_address_size : integer;
        ram_word_size : integer
    );
    port (
        enable_a : in std_logic;
        enable_b : in std_logic;
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

signal memory_ram_enable_a       : std_logic;
signal memory_ram_enable_b       : std_logic;
signal memory_ram_data_in_a      : std_logic_vector((small_bus_ram_word_size - 1) downto 0);
signal memory_ram_data_in_b      : std_logic_vector((small_bus_ram_word_size - 1) downto 0);
signal memory_ram_address_a_out  : std_logic_vector((small_bus_ram_address_size - 1) downto 0);
signal memory_ram_address_a      : std_logic_vector((small_bus_ram_address_size - 1) downto 0);
signal memory_ram_address_b_in   : std_logic_vector((small_bus_ram_address_size - 1) downto 0);
signal memory_ram_address_b_out  : std_logic_vector((small_bus_ram_address_size - 1) downto 0);
signal memory_ram_address_b      : std_logic_vector((small_bus_ram_address_size - 1) downto 0);
signal memory_ram_write_enable_a : std_logic;
signal memory_ram_write_enable_b : std_logic;
signal memory_ram_data_out_a     : std_logic_vector((small_bus_ram_word_size - 1) downto 0);
signal memory_ram_data_out_b     : std_logic_vector((small_bus_ram_word_size - 1) downto 0);

begin

memory_ram_enable_a           <= enable;
memory_ram_data_in_a          <= (others => '0');
memory_ram_address_a_out      <= address_out_0;
memory_ram_write_enable_a     <= '0';
data_out_0                    <= memory_ram_data_out_a;

memory_ram_enable_b           <= enable;
memory_ram_data_in_b          <= data_in;
memory_ram_address_b_in       <= address_in;
memory_ram_address_b_out      <= address_out_1;
memory_ram_write_enable_b     <= write_enable;
data_out_1                    <= memory_ram_data_out_b;

memory_ram_address_a          <= memory_ram_address_a_out;
memory_ram_address_b          <= memory_ram_address_b_in when operation_mode = '1' else
                                 memory_ram_address_b_out;

bram_0 : synth_double_ram
    generic map(
        ram_address_size => small_bus_ram_address_size,
        ram_word_size => small_bus_ram_word_size
    )
    port map(
        enable_a => memory_ram_enable_a,
        enable_b => memory_ram_enable_b,
        data_in_a => memory_ram_data_in_a, 
        data_in_b => memory_ram_data_in_b,
        read_write_a => memory_ram_write_enable_a,
        read_write_b => memory_ram_write_enable_b,
        clk => clk,
        address_a => memory_ram_address_a,
        address_b => memory_ram_address_b,
        data_out_a => memory_ram_data_out_a,
        data_out_b => memory_ram_data_out_b
    );

end behavioral;