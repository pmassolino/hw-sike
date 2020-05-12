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

entity synth_dist_ram is
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
end synth_dist_ram;

architecture behavioral of synth_dist_ram is

type ramtype is array(integer range 0 to (2**ram_address_size - 1)) of std_logic_vector((ram_word_size - 1) downto 0);

signal memory_ram : ramtype;

begin

process(clk)
    begin
        if (rising_edge(clk)) then
            if write_enable = '1' then
                memory_ram(to_integer(to_01(unsigned(address)))) <= data_in((ram_word_size - 1) downto (0));
            end if;
        end if;
end process;

data_out((ram_word_size - 1) downto (0)) <= memory_ram(to_integer(to_01(unsigned(address))));

end behavioral;