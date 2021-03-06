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

entity synth_rd_ram is
    Generic (
        ram_address_size : integer;
        ram_word_size : integer
    );
    Port (
        data_in : in std_logic_vector((ram_word_size - 1) downto 0);
        write_enable : in std_logic;
        clk : in std_logic;
        address_in : in std_logic_vector((ram_address_size - 1) downto 0);
        address_out_0 : in std_logic_vector((ram_address_size - 1) downto 0);
        address_out_1 : in std_logic_vector((ram_address_size - 1) downto 0);
        address_out_2 : in std_logic_vector((ram_address_size - 1) downto 0);
        address_out_3 : in std_logic_vector((ram_address_size - 1) downto 0);
        data_out_0 : out std_logic_vector((ram_word_size - 1) downto 0);
        data_out_1 : out std_logic_vector((ram_word_size - 1) downto 0);
        data_out_2 : out std_logic_vector((ram_word_size - 1) downto 0);
        data_out_3 : out std_logic_vector((ram_word_size - 1) downto 0)
    );
end synth_rd_ram;

architecture behavioral of synth_rd_ram is

component synth_dist_ram
    Generic (
        ram_address_size : integer;
        ram_word_size : integer
    );
    Port (
        data_in : in std_logic_vector((ram_word_size - 1) downto 0);
        write_enable : in std_logic;
        clk : in std_logic;
        address : in std_logic_vector((ram_address_size - 1) downto 0);
        data_out : out std_logic_vector((ram_word_size - 1) downto 0)
    );
end component;

signal dist_0_address : std_logic_vector((ram_address_size - 1) downto 0);
signal dist_0_data_out : std_logic_vector((ram_word_size - 1) downto 0);

signal dist_1_address : std_logic_vector((ram_address_size - 1) downto 0);
signal dist_1_data_out : std_logic_vector((ram_word_size - 1) downto 0);

signal dist_2_address : std_logic_vector((ram_address_size - 1) downto 0);
signal dist_2_data_out : std_logic_vector((ram_word_size - 1) downto 0);

signal dist_3_address : std_logic_vector((ram_address_size - 1) downto 0);
signal dist_3_data_out : std_logic_vector((ram_word_size - 1) downto 0);

begin

dist_0 : synth_dist_ram
    Generic Map(
        ram_address_size => ram_address_size,
        ram_word_size => ram_word_size
    )
    Port Map(
        data_in => data_in,
        write_enable => write_enable,
        clk => clk,
        address => dist_0_address,
        data_out => dist_0_data_out
    );

dist_0_address <= address_out_0 when write_enable = '0' else address_in;

dist_1 : synth_dist_ram
    Generic Map(
        ram_address_size => ram_address_size,
        ram_word_size => ram_word_size
    )
    Port Map(
        data_in => data_in,
        write_enable => write_enable,
        clk => clk,
        address => dist_1_address,
        data_out => dist_1_data_out
    );

dist_1_address <= address_out_1 when write_enable = '0' else address_in;

dist_2 : synth_dist_ram
    Generic Map(
        ram_address_size => ram_address_size,
        ram_word_size => ram_word_size
    )
    Port Map(
        data_in => data_in,
        write_enable => write_enable,
        clk => clk,
        address => dist_2_address,
        data_out => dist_2_data_out
    );

dist_2_address <= address_out_2 when write_enable = '0' else address_in;

dist_3 : synth_dist_ram
    Generic Map(
        ram_address_size => ram_address_size,
        ram_word_size => ram_word_size
    )
    Port Map(
        data_in => data_in,
        write_enable => write_enable,
        clk => clk,
        address => dist_3_address,
        data_out => dist_3_data_out
    );

dist_3_address <= address_out_3 when write_enable = '0' else address_in;

data_out_0 <= dist_0_data_out;
data_out_1 <= dist_1_data_out;
data_out_2 <= dist_2_data_out;
data_out_3 <= dist_3_data_out;

end behavioral;