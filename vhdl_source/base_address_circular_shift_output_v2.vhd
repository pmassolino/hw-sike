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

entity base_address_circular_shift_output_v2 is
    Generic(
        memory_base_address_size : integer
    );
    Port (
        clk : in std_logic;
        circular_shift_enable : in std_logic;
        load_new_values_enable : in std_logic;
        increment_previous_address : in std_logic;
        rotation_size : in std_logic_vector(1 downto 0);
        enable_new_address : in std_logic;
        load_new_address : in std_logic_vector((memory_base_address_size - 1) downto 0);
        current_address_enable : out std_logic;
        current_address : out std_logic_vector((memory_base_address_size - 1) downto 0)
    );
end base_address_circular_shift_output_v2;

architecture behavioral of base_address_circular_shift_output_v2 is

signal internal_memory_address_0 : std_logic_vector((memory_base_address_size) downto 0);
signal internal_memory_address_1 : std_logic_vector((memory_base_address_size) downto 0);
signal internal_memory_address_2 : std_logic_vector((memory_base_address_size) downto 0);
signal internal_memory_address_3 : std_logic_vector((memory_base_address_size) downto 0);
signal internal_memory_address_4 : std_logic_vector((memory_base_address_size) downto 0);
signal internal_memory_address_5 : std_logic_vector((memory_base_address_size) downto 0);
signal internal_memory_address_6 : std_logic_vector((memory_base_address_size) downto 0);
signal internal_memory_address_7 : std_logic_vector((memory_base_address_size) downto 0);

signal previous_memory_address : std_logic_vector((memory_base_address_size) downto 0);

begin

process(clk)
begin
    if(rising_edge(clk)) then
        if((load_new_values_enable = '1') or (circular_shift_enable = '1')) then
            if(load_new_values_enable = '1') then
                internal_memory_address_0 <= enable_new_address & load_new_address;
            else
                internal_memory_address_0 <= internal_memory_address_1;
            end if;
            internal_memory_address_1 <= internal_memory_address_2;
            internal_memory_address_2 <= internal_memory_address_3;
            if(rotation_size(0) = '0') then
                internal_memory_address_3 <= previous_memory_address;
            else
                internal_memory_address_3 <= internal_memory_address_4;
            end if;
            internal_memory_address_4 <= internal_memory_address_5;
            internal_memory_address_5 <= internal_memory_address_6;
            internal_memory_address_6 <= internal_memory_address_7;
            internal_memory_address_7 <= previous_memory_address;
        end if;
    end if;
end process;

previous_memory_address(memory_base_address_size) <= internal_memory_address_0(memory_base_address_size);
previous_memory_address((memory_base_address_size - 1) downto 0) <= std_logic_vector(unsigned(internal_memory_address_0((memory_base_address_size - 1) downto 0)) + to_unsigned(1, memory_base_address_size - 1)) when increment_previous_address = '1' else internal_memory_address_0((memory_base_address_size - 1) downto 0);

current_address_enable <= internal_memory_address_0(memory_base_address_size);
current_address <= internal_memory_address_0((memory_base_address_size - 1) downto 0);

end behavioral;