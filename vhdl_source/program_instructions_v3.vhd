----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_instructions_v3 is
    Generic(
        memory_size : integer;
        small_bus_value_size : integer
    );
    Port(
        clk : in std_logic;
        small_bus_mode : in std_logic;
        small_bus_enable : in std_logic;
        full_bus_enable : in std_logic;
        load_instruction_small_bus_mode : in std_logic_vector((small_bus_value_size - 1) downto 0);
        address_instruction_full_bus_mode : in std_logic_vector((memory_size - 1) downto 0);
        address_data_in_instruction_small_bus_mode : in std_logic_vector((memory_size + 1) downto 0);
        address_data_out_instruction_small_bus_mode : in std_logic_vector((memory_size + 1) downto 0);
        load_mode_enable : in std_logic;
        current_instruction_full_bus_mode : out std_logic_vector((4*small_bus_value_size - 1) downto 0);
        current_instruction_small_bus_mode : out std_logic_vector((small_bus_value_size - 1) downto 0)
    );
end entity;

architecture behavioral of program_instructions_v3 is

type multiple_ramdata is array(integer range <>) of std_logic_vector((small_bus_value_size - 1) downto 0);

signal enable_program_memory : std_logic_vector(0 to 3);
signal data_in_program_memory : std_logic_vector((small_bus_value_size - 1) downto 0);
signal address_program_memory : std_logic_vector((memory_size - 1) downto 0);
signal data_out_program_memory : multiple_ramdata(0 to 3);

component synth_ram
    generic (
        ram_address_size : integer;
        ram_word_size : integer
    );
    port (
        enable : in std_logic;
        data_in : in std_logic_vector((ram_word_size - 1) downto 0);
        read_write : in std_logic;
        clk : in std_logic;
        address : in std_logic_vector((ram_address_size - 1) downto 0);
        data_out : out std_logic_vector((ram_word_size - 1) downto 0)
    );
end component;

begin

all_memories : for I in 0 to 3 generate

program_memory_I : synth_ram
    generic map(
        ram_address_size => memory_size,
        ram_word_size => small_bus_value_size
    )
    port map(
        enable => enable_program_memory(I),
        data_in => data_in_program_memory,
        read_write => load_mode_enable,
        clk => clk,
        address => address_program_memory,
        data_out => data_out_program_memory(I)
    );
    
enable_program_memory(I) <= full_bus_enable when (small_bus_mode = '0') else 
                            small_bus_enable when ((address_data_in_instruction_small_bus_mode(1 downto 0) = std_logic_vector(to_unsigned(I, 2))) or (address_data_out_instruction_small_bus_mode(1 downto 0) = std_logic_vector(to_unsigned(I, 2)))) else 
                            '0';

current_instruction_full_bus_mode(((I+1)*small_bus_value_size - 1) downto I*small_bus_value_size) <= data_out_program_memory(I);

end generate;

data_in_program_memory  <= load_instruction_small_bus_mode;
address_program_memory  <= address_instruction_full_bus_mode when (small_bus_mode = '0') else 
                           address_data_in_instruction_small_bus_mode((memory_size + 1) downto 2) when (load_mode_enable = '1') else
                           address_data_out_instruction_small_bus_mode((memory_size + 1) downto 2);

current_instruction_small_bus_mode <= data_out_program_memory(0) when (address_data_out_instruction_small_bus_mode(1 downto 0) = "00") else
                                      data_out_program_memory(1) when (address_data_out_instruction_small_bus_mode(1 downto 0) = "01") else
                                      data_out_program_memory(2) when (address_data_out_instruction_small_bus_mode(1 downto 0) = "10") else
                                      data_out_program_memory(3);

end behavioral;