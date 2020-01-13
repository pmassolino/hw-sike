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

entity synth_double_ram is
    Generic (
        ram_address_size : integer;
        ram_word_size : integer
    );
    Port (
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
end synth_double_ram;

--architecture behavioral of synth_double_ram is
--
--type ramtype is array(integer range 0 to (2**ram_address_size - 1)) of std_logic_vector((ram_word_size - 1) downto 0);
--
--signal memory_ram : ramtype;
--
--begin
--
--process(clk)
--    begin
--        if (rising_edge(clk)) then
--            if(enable_a = '1') then
--                data_out_a((ram_word_size - 1) downto (0)) <= memory_ram(to_integer(to_01(unsigned(address_a))));
--                if read_write_a = '1' then
--                    memory_ram(to_integer(to_01(unsigned(address_a)))) <= data_in_a((ram_word_size - 1) downto (0));
--                end if;
--            end if;
--            if(enable_b = '1') then
--                data_out_b((ram_word_size - 1) downto (0)) <= memory_ram(to_integer(to_01(unsigned(address_b))));
--                if read_write_b = '1' then
--                    memory_ram(to_integer(to_01(unsigned(address_b)))) <= data_in_b((ram_word_size - 1) downto (0));
--                end if;
--            end if;
--        end if;
--end process;
--
--end behavioral;

architecture vivado_behavioral of synth_double_ram is

type ramtype is array(integer range 0 to (2**ram_address_size - 1)) of std_logic_vector((ram_word_size - 1) downto 0);

shared variable memory_ram : ramtype;

begin

process(clk)
    begin
        if (rising_edge(clk)) then
            if(enable_a = '1') then
                data_out_a((ram_word_size - 1) downto (0)) <= memory_ram(to_integer(to_01(unsigned(address_a))));
                if read_write_a = '1' then
                    memory_ram(to_integer(to_01(unsigned(address_a)))) := data_in_a((ram_word_size - 1) downto (0));
                end if;
            end if;
        end if;
end process;

process(clk)
    begin
        if (rising_edge(clk)) then
            if(enable_b = '1') then
                data_out_b((ram_word_size - 1) downto (0)) <= memory_ram(to_integer(to_01(unsigned(address_b))));
                if read_write_b = '1' then
                    memory_ram(to_integer(to_01(unsigned(address_b)))) := data_in_b((ram_word_size - 1) downto (0));
                end if;
            end if;
        end if;
end process;

end vivado_behavioral;