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

entity tb_wide_adder_carry_select is
Generic(
    wide_adder_base_size : integer := 3;
    wide_adder_total_size : integer := 544;
    PERIOD : time := 100 ns
);
end tb_wide_adder_carry_select;

architecture behavioral of tb_wide_adder_carry_select is

component wide_adder_carry_select
    Generic(
        base_size : integer;
        total_size : integer
    );
    Port (
        a : in std_logic_vector((total_size - 1) downto 0);
        b : in std_logic_vector((total_size - 1) downto 0);
        cin : in std_logic_vector(0 downto 0);
        o : out std_logic_vector((total_size - 1) downto 0)
    );
end component;

type input_vector is array (natural range <>) of STD_LOGIC_VECTOR(543 downto 0);

constant test_inputs : input_vector(0 to 9) := (
X"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
X"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
X"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001",
X"369AB15925A43780C001F23A21F36A1F2212C2A321B221E6F8962A95351C546B123A5432245a1c23b241e5f7549a845c45b654f546854a654546c45454e613a745546321",
X"5418912536AC12321F2E2D1C95A721C895A3B12C2F1A304A54E2C121351E32193A2187AC25A43780C001F23A21F36A1F2212C2A321B221E6F8962A95351C546B123A5432",
X"5418912536AC12321F2E2D1C95A721C895A3B12C2F1A304A54E2C121351E32193A2187AC25A43780C001F23A21F36A1F2212C2A321B221E6F8962A95351C546B123A5432",
X"524513252A361B515151C515121E51531F110615C5616556156E1515156156C16515F015616A51510561561D5065E1501561561561561A651561056E1051C516515615C9",
X"9987A4A7412A85412A5640A565C012132F120601E220F12312C3543E1350132C1321356135A13550135A1355649664453135135A5435013415313505531C035351135778",
X"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
X"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
);

signal test_a : STD_LOGIC_VECTOR(543 downto 0);
signal test_b : STD_LOGIC_VECTOR(543 downto 0);
signal test_cin : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal test_o_aam : STD_LOGIC_VECTOR(543 downto 0);
signal test_o_cca : STD_LOGIC_VECTOR(543 downto 0);
signal true_o : STD_LOGIC_VECTOR(543 downto 0);

signal test_error_aam : STD_LOGIC := '0';
signal test_error_cca : STD_LOGIC := '0';
signal clk : STD_LOGIC := '0';
signal test_bench_finish : BOOLEAN := false;

constant tb_delay : TIME := (PERIOD/2);

begin

test_aam : entity work.wide_adder_carry_select(behavioral_aam)
    Generic Map(
        base_size => wide_adder_base_size,
        total_size => wide_adder_total_size
    )
    Port Map(
        a => test_a,
        b => test_b,
        cin  => test_cin,
        o => test_o_aam
    );

test_cca : entity work.wide_adder_carry_select(behavioral_cca)
    Generic Map(
        base_size => wide_adder_base_size,
        total_size => wide_adder_total_size
    )
    Port Map(
        a => test_a,
        b => test_b,
        cin  => test_cin,
        o => test_o_cca
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
    variable number_of_tests : integer;
    variable before_time : time;
    variable after_time : time;
    variable i : integer;
    begin       
        test_a <= (others => '0');
        test_b <= (others => '0');
        test_error_aam <= '0';
        test_error_cca <= '0';
        number_of_tests := 0;
        i := 0;
        wait for PERIOD*10;
        wait for tb_delay;
        while(i < test_inputs'length) loop
            test_a <= test_inputs(i);
            test_b <= test_inputs(i+1);
            true_o <= std_logic_vector(unsigned(test_inputs(i)) + unsigned(test_inputs(i+1)));
            i := i + 2;
            wait for PERIOD;
            if(test_o_aam = true_o) then
                test_error_aam <= '0';
            else
                test_error_aam <= '1';
                report "Error in AAM architecture at number " & integer'image(i/2);
            end if;
            wait for PERIOD;
            if(test_o_cca = true_o) then
                test_error_cca <= '0';
            else
                test_error_cca <= '1';
                report "Error in CCA architecture at number " & integer'image(i/2);
            end if;
            wait for PERIOD;
        end loop;
        wait for PERIOD;
        report "End of the test." severity note;
        test_bench_finish <= true;
        wait;
end process;


end behavioral;