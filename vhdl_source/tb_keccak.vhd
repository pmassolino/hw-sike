-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

library STD;
use STD.TEXTIO.ALL;

entity tb_keccak is
generic(
    PERIOD : time := 10 ns;

    keccak_w : integer := 64;
    num_slices : integer := 32;
    bits_num_slices : integer := 5;
    bit_per_sub_lane : integer := 2;
    din_dout_length : integer := 16;
    
    max_buffer_size : integer := 16384;
    
    maximum_number_of_tests : integer := 100;
    
    --keccak_r : integer := 576;
    --test_memory_file_keccak_permutation : string := "../data_tests/keccakf1600absorb_rate_576.dat"
    
    --keccak_r : integer := 832;
    --test_memory_file_keccak_permutation : string := "../data_tests/keccakf1600absorb_rate_832.dat"
    
    --keccak_r : integer := 1024;
    --test_memory_file_keccak_permutation : string := "../data_tests/keccakf1600absorb_rate_1024.dat"
    
    --keccak_r : integer := 1088;
    --test_memory_file_keccak_permutation : string := "../data_tests/keccakf1600absorb_rate_1088.dat"
    
    --keccak_r : integer := 1152;
    --test_memory_file_keccak_permutation : string := "../data_tests/keccakf1600absorb_rate_1152.dat"
    
    keccak_r : integer := 1344;
    test_memory_file_keccak_permutation : string := "../data_tests/keccakf1600absorb_rate_1344.dat"
);
end tb_keccak;

architecture behavioral of tb_keccak is

component keccak
generic(
    keccak_w : integer := 64;
    keccak_r : integer  := 1024;
    num_slices : integer := 32;
    bits_num_slices : integer := 5;
    bit_per_sub_lane : integer := 2;
    din_dout_length : integer := 64
);
  port (
    clk     : in  std_logic;
    rst_n   : in  std_logic;
    init    : in std_logic;
    go      : in std_logic;
    absorb  : in std_logic;
    squeeze : in std_logic;
    din     : in std_logic_vector((din_dout_length-1) downto 0);
    ready   : out std_logic;
    dout    : out std_logic_vector((din_dout_length-1) downto 0)
);
end component;

signal test_rst_n   : std_logic;
signal test_init    : std_logic;
signal test_go      : std_logic;
signal test_absorb  : std_logic;
signal test_squeeze : std_logic;
signal test_din     : std_logic_vector((din_dout_length-1) downto 0);
signal test_ready   : std_logic;
signal test_dout    : std_logic_vector((din_dout_length-1) downto 0);

signal test_input   : std_logic_vector((max_buffer_size-1) downto 0);
signal test_output  : std_logic_vector((max_buffer_size-1) downto 0);
signal true_output  : std_logic_vector((max_buffer_size-1) downto 0);

signal test_error : std_logic := '0';
signal test_verifying : std_logic := '0';
signal clk : std_logic := '0';
signal test_bench_finish : boolean := false;

constant tb_delay : time := (PERIOD/2);

begin

test : keccak
    generic map(
        keccak_w => keccak_w,
        keccak_r => keccak_r,
        num_slices => num_slices,
        bits_num_slices => bits_num_slices,
        bit_per_sub_lane => bit_per_sub_lane,
        din_dout_length => din_dout_length
    )
    port map(
        clk => clk,
        rst_n => test_rst_n,
        init => test_init,
        go => test_go,
        absorb => test_absorb,
        squeeze => test_squeeze,
        din => test_din,
        ready => test_ready,
        dout => test_dout
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

procedure absorb_buffer(
    signal test_buffer : in std_logic_vector((max_buffer_size-1) downto 0);
    test_buffer_bits_size : in integer) is
variable i : integer;
variable j : integer;
begin
    test_din <= (others => '0');
    test_absorb <= '0';
    while(test_ready /= '1') loop
        wait for (PERIOD);
    end loop;
    i := 0;
    j := 0;
    wait for PERIOD;
    while (i < test_buffer_bits_size) loop
        if(j >= keccak_r) then
            test_go <= '1';
            wait for (PERIOD);
            test_go <= '0';
            j := 0;
            wait for (PERIOD);
        end if;
        wait for (PERIOD);
        while(test_ready /= '1') loop
            wait for (PERIOD);
        end loop;
        test_din <= test_buffer((i+din_dout_length-1) downto i);
        test_absorb <= '1';
        wait for PERIOD;
        i := i + din_dout_length;
        j := j + din_dout_length;
        test_din <= (others => '0');
        test_absorb <= '0';
        wait for (PERIOD);
    end loop;
    test_din <= (others => '0');
    test_absorb <= '0';
    wait for PERIOD;
end absorb_buffer;

procedure squeeze_buffer(
    signal test_buffer : out std_logic_vector((max_buffer_size-1) downto 0);
    test_buffer_bits_size : in integer) is
variable i : integer;
variable j : integer;
begin
    test_squeeze <= '0';
    while(test_ready /= '1') loop
        wait for (PERIOD);
    end loop;
    i := 0;
    wait for PERIOD;
    while (i < test_buffer_bits_size) loop
        test_buffer((i+din_dout_length-1) downto i) <= test_dout;
        test_squeeze <= '1';
        wait for PERIOD;
        i := i + din_dout_length;
        test_squeeze <= '0';
        wait for (PERIOD);
        while(test_ready /= '1') loop
            wait for (PERIOD);
        end loop;
    end loop;
    test_squeeze <= '0';
    wait for PERIOD;
end squeeze_buffer;

FILE ram_file : text;
variable line_n : line;
variable number_of_tests : integer;
variable test_input_bytes_size : integer;
variable test_output_bytes_size : integer;
variable read_buffer_byte : std_logic_vector(7 downto 0);
variable buffer_index : integer;
begin
    test_rst_n <= '0';
    test_init <= '0';
    test_go <= '0';
    test_absorb <= '0';
    test_squeeze <= '0';
    test_din <= (others => '0');
    test_error <= '0';
    test_verifying <= '0';
    test_input <= (others => '0');
    test_output <= (others => '0');
    true_output <= (others => '0');
    wait for PERIOD;
    wait for tb_delay;
    test_rst_n <= '1';
    wait for (PERIOD*2);
    file_open(ram_file, test_memory_file_keccak_permutation, READ_MODE);
    readline (ram_file, line_n);
    read (line_n, number_of_tests); 
    wait for PERIOD;
    if((number_of_tests > maximum_number_of_tests) and (maximum_number_of_tests /= 0)) then
        number_of_tests := maximum_number_of_tests;
    end if;
    for I in 1 to number_of_tests loop
        test_error <= '0';
        test_input <= (others => '0');
        test_output <= (others => '0');
        true_output <= (others => '0');
        wait for PERIOD;
        readline (ram_file, line_n);
        read (line_n, test_input_bytes_size);
        buffer_index := 0;
        for j in 1 to test_input_bytes_size loop
            readline (ram_file, line_n);
            read (line_n, read_buffer_byte);
            test_input((buffer_index + 7) downto buffer_index) <= read_buffer_byte;
            buffer_index := buffer_index + 8;
        end loop;
        readline (ram_file, line_n);
        read (line_n, test_output_bytes_size);
        buffer_index := 0;
        for j in 1 to test_output_bytes_size loop
            readline (ram_file, line_n);
            read (line_n, read_buffer_byte);
            true_output((buffer_index + 7) downto buffer_index) <= read_buffer_byte;
            buffer_index := buffer_index + 8;
        end loop;
        wait for PERIOD;
        test_init <= '1';
        wait for PERIOD;
        test_init <= '0';
        wait for PERIOD;
        absorb_buffer(test_input, test_input_bytes_size*8);
        wait for PERIOD;
        test_go <= '1';
        wait for PERIOD;
        test_go <= '0';
        wait for (PERIOD*2);
        squeeze_buffer(test_output, test_output_bytes_size*8);
        wait for PERIOD;
        test_verifying <= '1';
        if (true_output = test_output) then
            test_error <= '0';
        else
            test_error <= '1';
            report "Computed values do not match expected ones" severity error;
        end if;
        wait for PERIOD;
        test_verifying <= '0';
        test_error <= '0';
        wait for PERIOD;
    end loop;
    report "End of the test." severity note;
    test_bench_finish <= true;
    wait;
end process;


end behavioral;