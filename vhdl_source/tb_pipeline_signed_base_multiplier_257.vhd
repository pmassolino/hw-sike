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
use IEEE.STD_LOGIC_TEXTIO.ALL;

library STD;
use STD.TEXTIO.ALL;

entity tb_pipeline_signed_base_multiplier_257 is
Generic(
    PERIOD : time := 100 ns;
    maximum_number_of_tests : integer := 0;
    
    test_memory_file_karatsuba_multiplication_test : string := "../hw_sidh_tests_v257/multiplication_test_257.dat"
);
end tb_pipeline_signed_base_multiplier_257;

architecture behavioral of tb_pipeline_signed_base_multiplier_257 is

component pipeline_signed_base_multiplier_nbits_257
    Port(
        a : in std_logic_vector(256 downto 0);
        b : in std_logic_vector(256 downto 0);
        clk : in std_logic;
        o : out std_logic_vector(513 downto 0)
    );
end component;

signal test_a : std_logic_vector(256 downto 0);
signal test_b : std_logic_vector(256 downto 0);
signal test_o : std_logic_vector(513 downto 0);
signal true_o : std_logic_vector(513 downto 0);

signal test_error : std_logic := '0';
signal clk : std_logic := '1';
signal test_bench_finish : boolean := false;

constant tb_delay : time := (PERIOD/2);

begin

test : entity work.pipeline_signed_base_multiplier_257(tiled_behavioral_v2)
    Port Map(
        a => test_a,
        b => test_b,
        clk => clk,
        o => test_o
    );
    
clock : process
begin
while (not test_bench_finish ) loop
    wait for PERIOD/2;
    clk <= not clk;
end loop;
wait;
end process;

process
    FILE ram_file : text;
    variable line_n : line;
    variable number_of_tests : integer;
    variable read_a : std_logic_vector(256 downto 0);
    variable read_b : std_logic_vector(256 downto 0);
    variable read_o : std_logic_vector(513 downto 0);
    begin       
        test_error <= '0';
        test_a <= (others => '0');
        test_b <= (others => '0');
        true_o <= (others => '0');
        wait for PERIOD;
        wait for tb_delay;
        file_open(ram_file, test_memory_file_karatsuba_multiplication_test, READ_MODE);
        readline (ram_file, line_n);
        read (line_n, number_of_tests);
        wait for PERIOD;
        if((number_of_tests > maximum_number_of_tests) and (maximum_number_of_tests /= 0)) then
            number_of_tests := maximum_number_of_tests;
        end if;
        for I in 1 to number_of_tests loop
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_a);
            readline (ram_file, line_n);
            read (line_n, read_b);
            readline (ram_file, line_n);
            read (line_n, read_o);
            test_a <= std_logic_vector(signed(read_a));
            test_b <= std_logic_vector(signed(read_b));
            true_o <= std_logic_vector(signed(read_o));
            wait for PERIOD*6;
            if (true_o = test_o) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Computed values do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            wait for PERIOD;
        end loop;
        report "End of the test." severity note;
        test_bench_finish <= true;
        wait;
end process;


end behavioral;