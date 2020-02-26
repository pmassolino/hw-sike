----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012
-- Design Name:    Synth Double RAM 
-- Module Name:    Synth Double RAM
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Circuit to simulate the behavior of a double synthesizable RAM.
--
-- The circuits parameters
-- 
-- ram_address_size :
--
-- Address size of the synthesizable RAM used on the circuit.
--
-- ram_word_size :
--
-- The size of internal word on the synthesizable RAM.
--
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
-- 
-- Revision: 
-- Revision 1.1
-- Fixed some languages issues.
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
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