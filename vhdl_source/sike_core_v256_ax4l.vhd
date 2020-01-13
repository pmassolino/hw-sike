--
-- Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
--
-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sike_core_v256_ax4l is
port(
    aclk      : in std_logic;
    aresetn   : in std_logic;
    -- Write Address related signals --
    s_axi_awaddr    : in std_logic_vector(18 downto 0);
    s_axi_awprot    : in std_logic_vector(2 downto 0);
    s_axi_awvalid   : in std_logic;
    s_axi_awready   : out std_logic;
    -- Write data signals --
    s_axi_wdata     : in std_logic_vector(31 downto 0);
    s_axi_wstrb     : in std_logic_vector(3 downto 0);
    s_axi_wvalid    : in std_logic;
    s_axi_wready    : out std_logic;
    -- Response channel --
    s_axi_bresp     : out std_logic_vector(1 downto 0);
    s_axi_bvalid    : out std_logic;
    s_axi_bready    : in std_logic;
    -- Read Address related signals --
    s_axi_araddr    : in std_logic_vector(18 downto 0);
    s_axi_arprot    : in std_logic_vector(2 downto 0);
    s_axi_arvalid   : in std_logic;
    s_axi_arready   : out std_logic;
    -- Read data signals --
    s_axi_rdata     : out std_logic_vector(31 downto 0);
    s_axi_rresp     : out std_logic_vector(1 downto 0);
    s_axi_rvalid    : out std_logic;
    s_axi_rready    : in std_logic
);
end sike_core_v256_ax4l;

architecture behavioral of sike_core_v256_ax4l is

component sike_core_v256
    generic(
        mac_base_wide_adder_size : integer := 2;
        mac_base_word_size : integer := 16;
        mac_multiplication_factor : integer := 16;
        mac_multiplication_factor_log2 : integer := 4;
        mac_accumulator_extra_bits : integer := 32;
        mac_memory_address_size : integer := 10;
        mac_max_operands_size : integer := 2;
        prom_memory_size : integer := 11;
        prom_instruction_size : integer := 64;
        base_alu_ram_memory_size : integer := 10;
        base_alu_rotation_level : integer := 4;
        rd_ram_memory_size : integer := 5
    );
    port(
        rstn : in std_logic;
        clk : in std_logic;
        enable : in std_logic;
        data_in : in std_logic_vector((mac_base_word_size - 1) downto 0);
        data_in_valid : in std_logic;
        address_data_in_out : in std_logic_vector((mac_base_word_size - 1) downto 0);
        prom_address_region : in std_logic;
        write_enable : in std_logic;
        data_out : out std_logic_vector((mac_base_word_size - 1) downto 0);
        data_out_valid : out std_logic;
        core_free : out std_logic;
        flag : out std_logic
    );
end component;

signal reg_s_axi_awaddr    : std_logic_vector(18 downto 0);
signal reg_s_axi_awprot    : std_logic_vector(2 downto 0);
signal reg_s_axi_awvalid   : std_logic;
signal reg_s_axi_awready   : std_logic;

signal reg_s_axi_awaddr_is_good : std_logic;

signal reg_s_axi_wdata     : std_logic_vector(31 downto 0);
signal reg_s_axi_wstrb     : std_logic_vector(3 downto 0);
signal reg_s_axi_wvalid    : std_logic;
signal reg_s_axi_wready    : std_logic;

signal reg_s_axi_wdata_number_bytes : std_logic_vector(1 downto 0);

signal reg_s_axi_bresp     : std_logic_vector(1 downto 0);
signal reg_s_axi_bvalid    : std_logic;

signal reg_s_axi_araddr    : std_logic_vector(18 downto 0);
signal reg_s_axi_arprot    : std_logic_vector(2 downto 0);
signal reg_s_axi_arvalid   : std_logic;
signal reg_s_axi_arready   : std_logic;

signal reg_s_axi_araddr_is_good : std_logic;

signal reg_s_axi_rdata     : std_logic_vector(31 downto 0);
signal reg_s_axi_rresp     : std_logic_vector(1 downto 0);
signal reg_s_axi_rvalid    : std_logic;

signal sike_enable : std_logic;
signal sike_data_in : std_logic_vector(15 downto 0);
signal sike_data_in_valid : std_logic;
signal sike_address_data_in_out : std_logic_vector(15 downto 0);
signal sike_prom_address_region : std_logic;
signal sike_write_enable : std_logic;
signal sike_data_out : std_logic_vector(15 downto 0);
signal sike_data_out_valid : std_logic;
signal sike_core_free : std_logic;
signal sike_flag : std_logic;

signal reg_sike_data_out : std_logic_vector(15 downto 0);
signal reg_sike_data_out_valid : std_logic;

signal reg_s_axi_wait_read_value : std_logic;


begin

s_axi_awready   <= reg_s_axi_awready;

s_axi_wready    <= reg_s_axi_wready;

s_axi_bresp     <= reg_s_axi_bresp;
s_axi_bvalid    <= reg_s_axi_bvalid;

s_axi_arready   <= reg_s_axi_arready;

s_axi_rdata     <= reg_s_axi_rdata;
s_axi_rresp     <= reg_s_axi_rresp;
s_axi_rvalid    <= reg_s_axi_rvalid;

-- Input registers for Write address

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_awaddr <= (others => '0');
    elsif(rising_edge(aclk)) then
        if(s_axi_awvalid = '1') then
            reg_s_axi_awaddr <= s_axi_awaddr;
        end if;
    end if;
end process;

reg_s_axi_awaddr_is_good <= '1';

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_awprot <= (others => '0');
    elsif(rising_edge(aclk)) then
        if(s_axi_awvalid = '1') then
            reg_s_axi_awprot <= s_axi_awprot;
        end if;
    end if;
end process;

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_awvalid <= '0';
    elsif(rising_edge(aclk)) then
        if(reg_s_axi_awvalid = '0' or reg_s_axi_wvalid = '1') then
            reg_s_axi_awvalid <= s_axi_awvalid;
        end if;
    end if;
end process;

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_awready <= '0';
    elsif(rising_edge(aclk)) then
        reg_s_axi_awready <= '1';
    end if;
end process;

-- Input register for Write Data

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_wdata <= (others => '0');
    elsif(rising_edge(aclk)) then
        if(s_axi_wvalid = '1') then
            reg_s_axi_wdata <= s_axi_wdata;
        end if;
    end if;
end process;

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_wstrb <= (others => '0');
    elsif(rising_edge(aclk)) then
        if(s_axi_wvalid = '1') then
            reg_s_axi_wstrb <= s_axi_wstrb;
        end if;
    end if;
end process;

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_wvalid <= '0';
    elsif(rising_edge(aclk)) then
        if(reg_s_axi_wvalid = '0' or reg_s_axi_awvalid = '1') then
            reg_s_axi_wvalid <= s_axi_wvalid;
        end if;
    end if;
end process;

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_wready <= '0';
    elsif(rising_edge(aclk)) then
        reg_s_axi_wready <= '1';
    end if;
end process;

reg_s_axi_wdata_number_bytes <= "11" when reg_s_axi_wstrb = "1111" else
                            "10" when reg_s_axi_wstrb = "0111" else
                            "01" when reg_s_axi_wstrb = "0011" else
                            "00" when reg_s_axi_wstrb = "0001" else
                            "--";

-- Response channel --

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_bresp <= "00";
    elsif(rising_edge(aclk)) then
        if(reg_s_axi_awvalid = '1' and reg_s_axi_wvalid = '1') then
            if(reg_s_axi_awaddr_is_good = '0') then
                reg_s_axi_bresp <= "10";
            else
                reg_s_axi_bresp <= "00";
            end if;
        end if;
    end if;
end process;

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_bvalid <= '0';
    elsif(rising_edge(aclk)) then
        if(reg_s_axi_awvalid = '1' and reg_s_axi_wvalid = '1') then
            reg_s_axi_bvalid <= '1';
        elsif(reg_s_axi_bvalid = '1' and s_axi_bready = '1') then
            reg_s_axi_bvalid <= '0';
        end if;
    end if;
end process;

-- Read Address related signals --

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_araddr <= (others => '0');
    elsif(rising_edge(aclk)) then
        if(s_axi_arvalid = '1') then
            reg_s_axi_araddr <= s_axi_araddr;
        end if;
    end if;
end process;

reg_s_axi_araddr_is_good <= '1';

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_arprot <= (others => '0');
    elsif(rising_edge(aclk)) then
        if(s_axi_arvalid = '1') then
            reg_s_axi_arprot <= s_axi_arprot;
        end if;
    end if;
end process;

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_arvalid <= '0';
    elsif(rising_edge(aclk)) then
        reg_s_axi_arvalid <= s_axi_arvalid;
    end if;
end process;

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_arready <= '0';
    elsif(rising_edge(aclk)) then
        reg_s_axi_arready <= '1';
    end if;
end process;

-- Read Data related signals --

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_rresp <= "00";
    elsif(rising_edge(aclk)) then
        if(reg_s_axi_arvalid = '1') then
            if(reg_s_axi_araddr_is_good = '0') then
                reg_s_axi_rresp <= "10";
            else
                reg_s_axi_rresp <= "00";
            end if;
        end if;
    end if;
end process;

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_wait_read_value <= '0';
    elsif(rising_edge(aclk)) then
        if(reg_s_axi_arvalid = '1') then
            reg_s_axi_wait_read_value <= '1';
        elsif(reg_sike_data_out_valid = '1') then
            reg_s_axi_wait_read_value <= '0';
        end if;
    end if;
end process;

process(aclk, aresetn)
begin
    if(aresetn = '0') then
        reg_s_axi_rvalid <= '0';
    elsif(rising_edge(aclk)) then
        if(reg_s_axi_rvalid = '1' and s_axi_rready = '1') then
            reg_s_axi_rvalid <= '0';
        elsif((reg_s_axi_wait_read_value = '1')) then
            reg_s_axi_rvalid <= reg_sike_data_out_valid;
        end if;
    end if;
end process;

sike : sike_core_v256
    generic map(
        mac_base_wide_adder_size => 2,
        mac_base_word_size => 16,
        mac_multiplication_factor => 16,
        mac_multiplication_factor_log2 => 4,
        mac_accumulator_extra_bits => 32,
        mac_memory_address_size => 10,
        mac_max_operands_size => 2,
        prom_memory_size => 11,
        prom_instruction_size => 64,
        base_alu_ram_memory_size => 10,
        base_alu_rotation_level => 4,
        rd_ram_memory_size => 5
    )
    port map(
        rstn => aresetn,
        clk => aclk,
        enable => sike_enable,
        data_in => sike_data_in,
        data_in_valid => sike_data_in_valid,
        address_data_in_out => sike_address_data_in_out,
        prom_address_region => sike_prom_address_region,
        write_enable => sike_write_enable,
        data_out => sike_data_out,
        data_out_valid => sike_data_out_valid,
        core_free => sike_core_free,
        flag => sike_flag
    );

process(aclk)
begin
    if(rising_edge(aclk)) then
        sike_data_in <= reg_s_axi_wdata(15 downto 0);
        sike_data_in_valid <= reg_s_axi_wvalid;
        sike_write_enable <= reg_s_axi_awvalid;
        reg_sike_data_out <= sike_data_out;
        if(reg_s_axi_awvalid = '1') then
            sike_address_data_in_out <= reg_s_axi_awaddr(17 downto 2);
            sike_prom_address_region <= reg_s_axi_awaddr(18);
        else
            sike_address_data_in_out <= reg_s_axi_araddr(17 downto 2);
            sike_prom_address_region <= reg_s_axi_araddr(18);
        end if;
        if(reg_s_axi_wait_read_value = '1') then
            reg_sike_data_out_valid <= sike_data_out_valid;
        else 
            reg_sike_data_out_valid <= '0';
        end if;
    end if;
end process;

sike_enable <= '1';

reg_s_axi_rdata(15 downto 0) <= reg_sike_data_out;
reg_s_axi_rdata(31 downto 16) <= (others => '0');

end behavioral;