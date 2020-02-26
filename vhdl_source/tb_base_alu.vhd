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
use IEEE.STD_LOGIC_TEXTIO.ALL;

library STD;
use STD.TEXTIO.ALL;

entity tb_base_alu is
Generic(
    values_size : integer := 17;
    rotation_level : integer := 5;
    maximum_number_of_tests : integer := 0;
    PERIOD : time := 100 ns;
    
    test_memory_file_unsigned_values_test : string := "../hw_sidh_tests/base_ula_unsigned_values_test.dat";
    test_memory_file_signed_values_test : string := "../hw_sidh_tests/base_ula_signed_values_test.dat"
);
end tb_base_alu;

architecture behavioral of tb_base_alu is

component base_alu
    Generic (
        values_size : integer;
        rotation_level : integer
    );
    Port (
        a : in std_logic_vector((values_size - 1) downto 0);
        b : in std_logic_vector((values_size - 1) downto 0);
        operation_type : in std_logic_vector(1 downto 0);
        rotation_size : in std_logic_vector((rotation_level - 1) downto 0);
        left_rotation : in std_logic;
        shift_mode : in std_logic;
        math_operation : in std_logic_vector(1 downto 0);
        a_signed : in std_logic;
        b_signed : in std_logic;
        logic_operation : in std_logic_vector(1 downto 0);
        o : out std_logic_vector((2*values_size - 1) downto 0);
        o_equal_zero : out std_logic;
        o_change_sign_b : out std_logic
    );
end component;

signal test_a : std_logic_vector((values_size - 1) downto 0);
signal test_b : std_logic_vector((values_size - 1) downto 0);
signal test_operation_type : std_logic_vector(1 downto 0);
signal test_rotation_size : std_logic_vector((rotation_level - 1) downto 0);
signal test_left_rotation : std_logic;
signal test_shift_mode : std_logic;
signal test_math_operation : std_logic_vector(1 downto 0);
signal test_a_signed : std_logic;
signal test_b_signed : std_logic;
signal test_logic_operation : std_logic_vector(1 downto 0);
signal test_o : std_logic_vector((2*values_size - 1) downto 0);
signal test_o_equal_zero : std_logic;
signal test_o_change_sign_b : std_logic;

signal true_o : std_logic_vector((2*values_size - 1) downto 0);
signal true_o_equal_zero : std_logic;
signal true_o_change_sign_b : std_logic;

signal test_error : std_logic := '0';
signal clk : std_logic := '0';
signal test_bench_finish : BOOLEAN := false;

constant tb_delay : TIME := (PERIOD/2);

begin

test : base_alu
    Generic Map(
        values_size => values_size,
        rotation_level => rotation_level
    )
    Port Map(
        a => test_a,
        b => test_b,
        operation_type => test_operation_type,
        rotation_size => test_rotation_size,
        left_rotation => test_left_rotation,
        shift_mode => test_shift_mode,
        math_operation => test_math_operation,
        a_signed => test_a_signed,
        b_signed => test_b_signed,
        logic_operation => test_logic_operation,
        o => test_o,
        o_equal_zero => test_o_equal_zero,
        o_change_sign_b => test_o_change_sign_b
    );
    
clock : process
begin
while (not test_bench_finish ) loop
    clk <= not clk;
    wait for PERIOD/2;
end loop;
wait;
end process;

process
    FILE ram_file : text;
    variable line_n : line;
    variable number_of_tests : integer;
    variable read_unsigned : std_logic_vector((values_size - 1) downto 0);
    variable read_signed : std_logic_vector((values_size - 1) downto 0);
    variable read_double_unsigned : std_logic_vector((2*values_size - 1) downto 0);
    variable read_double_signed : std_logic_vector((2*values_size - 1) downto 0);
    begin       
        test_error <= '0';
        test_a <= (others => '0');
        test_b <= (others => '0');
        test_operation_type <= "00";
        test_rotation_size <= (others => '0');
        test_left_rotation <= '0';
        test_shift_mode <= '0';
        test_math_operation <= "00";
        test_a_signed <= '0';
        test_b_signed <= '0';
        test_logic_operation <= "00";
        wait for PERIOD;
        wait for tb_delay;
        file_open(ram_file, test_memory_file_unsigned_values_test, READ_MODE);
        readline (ram_file, line_n);
        read (line_n, number_of_tests);
        wait for PERIOD;
        if((number_of_tests > maximum_number_of_tests) and (maximum_number_of_tests /= 0)) then
            number_of_tests := maximum_number_of_tests;
        end if;
        report "Unsigned inputs test" severity note;
        test_a_signed <= '0';
        test_b_signed <= '0';
        for I in 1 to number_of_tests loop
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            test_a <= read_unsigned;
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            test_b <= read_unsigned;
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            test_rotation_size <= read_unsigned((rotation_level - 1) downto 0);
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            true_o((values_size - 1) downto 0) <= read_unsigned;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "00";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "00";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Addition values do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            true_o((values_size - 1) downto 0) <= read_unsigned;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "00";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "01";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Subtraction values do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_double_unsigned);
            true_o <= read_double_unsigned;
            test_operation_type <= "00";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "10";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o = test_o) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Multiplication values do not match expected ones" severity error;
            end if;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            true_o((values_size - 1) downto 0) <= read_unsigned;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "01";
            test_left_rotation <= '0';
            test_shift_mode <= '1';
            test_math_operation <= "11";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Shift right do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            true_o((values_size - 1) downto 0) <= read_unsigned;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "01";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "11";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Rotation right do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            true_o((values_size - 1) downto 0) <= read_unsigned;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "01";
            test_left_rotation <= '1';
            test_shift_mode <= '1';
            test_math_operation <= "11";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Shift left do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            true_o((values_size - 1) downto 0) <= read_unsigned;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "01";
            test_left_rotation <= '1';
            test_shift_mode <= '0';
            test_math_operation <= "11";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Rotation left do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            true_o((true_o'length - 1) downto 0) <= (others => '0');
            true_o_equal_zero <= read_unsigned(0);
            test_operation_type <= "00";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "01";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o_equal_zero = test_o_equal_zero) then
                test_error <= '0';
            else
                test_error <= '1';
                report "A equal B output do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            true_o((true_o'length - 1) downto 0) <= (others => '0');
            true_o_change_sign_b <= read_unsigned(0);
            test_operation_type <= "00";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "01";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o_change_sign_b = test_o_change_sign_b) then
                test_error <= '0';
            else
                test_error <= '1';
                report "A >  B output do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            true_o((values_size - 1) downto 0) <= read_unsigned;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "10";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "00";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "A & B output do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            true_o((values_size - 1) downto 0) <= read_unsigned;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "10";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "00";
            test_logic_operation <= "01";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "A | B output do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_unsigned);
            true_o((values_size - 1) downto 0) <= read_unsigned;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "10";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "00";
            test_logic_operation <= "10";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "A ^ B output do not match expected ones" severity error;
            end if;
            wait for PERIOD;
        end loop;
        wait for PERIOD;
        file_close(ram_file);
        wait for PERIOD;
        file_open(ram_file, test_memory_file_signed_values_test, READ_MODE);
        readline (ram_file, line_n);
        read (line_n, number_of_tests);
        wait for PERIOD;
        if((number_of_tests > maximum_number_of_tests) and (maximum_number_of_tests /= 0)) then
            number_of_tests := maximum_number_of_tests;
        end if;
        report "Signed inputs test" severity note;
        test_a_signed <= '1';
        test_b_signed <= '1';
        for I in 1 to number_of_tests loop
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_signed);
            test_a <= read_signed;
            readline (ram_file, line_n);
            read (line_n, read_signed);
            test_b <= read_signed;
            readline (ram_file, line_n);
            read (line_n, read_signed);
            test_rotation_size <= read_signed((rotation_level - 1) downto 0);
            readline (ram_file, line_n);
            read (line_n, read_signed);
            true_o((values_size - 1) downto 0) <= read_signed;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "00";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "00";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Addition values do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_signed);
            true_o((values_size - 1) downto 0) <= read_signed;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "00";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "01";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Subtraction values do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_double_signed);
            true_o <= read_double_signed;
            test_operation_type <= "00";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "10";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o = test_o) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Multiplication values do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_signed);
            true_o((values_size - 1) downto 0) <= read_signed;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "01";
            test_left_rotation <= '0';
            test_shift_mode <= '1';
            test_math_operation <= "11";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Shift right do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_signed);
            true_o((values_size - 1) downto 0) <= read_signed;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "01";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "11";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Rotation right do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_signed);
            true_o((values_size - 1) downto 0) <= read_signed;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "01";
            test_left_rotation <= '1';
            test_shift_mode <= '1';
            test_math_operation <= "11";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Shift left do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_signed);
            true_o((values_size - 1) downto 0) <= read_signed;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "01";
            test_left_rotation <= '1';
            test_shift_mode <= '0';
            test_math_operation <= "11";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "Rotation left do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_signed);
            true_o((true_o'length - 1) downto 0) <= (others => '0');
            true_o_equal_zero <= read_signed(0);
            test_operation_type <= "00";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "01";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o_equal_zero = test_o_equal_zero) then
                test_error <= '0';
            else
                test_error <= '1';
                report "A equal B output do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_signed);
            true_o((true_o'length - 1) downto 0) <= (others => '0');
            true_o_change_sign_b <= read_signed(0);
            test_operation_type <= "00";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "01";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o_change_sign_b = test_o_change_sign_b) then
                test_error <= '0';
            else
                test_error <= '1';
                report "A >  B output do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_signed);
            true_o((values_size - 1) downto 0) <= read_signed;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "10";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "00";
            test_logic_operation <= "00";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "A & B output do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_signed);
            true_o((values_size - 1) downto 0) <= read_signed;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "10";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "00";
            test_logic_operation <= "01";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "A | B output do not match expected ones" severity error;
            end if;
            wait for PERIOD;
            test_error <= '0';
            readline (ram_file, line_n);
            read (line_n, read_signed);
            true_o((values_size - 1) downto 0) <= read_signed;
            true_o((true_o'length - 1) downto values_size) <= (others => '0');
            test_operation_type <= "10";
            test_left_rotation <= '0';
            test_shift_mode <= '0';
            test_math_operation <= "00";
            test_logic_operation <= "10";
            wait for PERIOD;
            if (true_o(values_size - 1 downto 0) = test_o(values_size - 1 downto 0)) then
                test_error <= '0';
            else
                test_error <= '1';
                report "A ^ B output do not match expected ones" severity error;
            end if;
            wait for PERIOD;
        end loop;
        report "End of the test." severity note;
        test_bench_finish <= true;
        wait;
end process;


end behavioral;