library ieee;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.my_pkg.all;

entity register_file is 
generic (
    NBIT_DATA : integer := 32;
    ADDRESS_BIT : integer := 5
);
port (
    clk : in std_logic;
    reset : in std_logic;
    write_enable : in std_logic;
    write_address : in std_logic_vector(ADDRESS_BIT-1 downto 0);
    write_data : in std_logic_vector(NBIT_DATA-1 downto 0);
    read_address1 : in std_logic_vector(ADDRESS_BIT-1 downto 0);
    read_address2 : in std_logic_vector(ADDRESS_BIT-1 downto 0);
    read_data1 : out std_logic_vector(NBIT_DATA-1 downto 0);
    read_data2 : out std_logic_vector(NBIT_DATA-1 downto 0)
);
end register_file;

architecture beh of register_file is
    type reg_array is array (0 to 2**ADDRESS_BIT-1) of std_logic_vector(NBIT_DATA-1 downto 0);
    signal reg : reg_array := (others => (others => '0'));

    begin 
  write_rf:  process(clk, reset)
        begin
            if reset = '1' then
                reg <= (others => (others => '0'));
            elsif rising_edge(clk) then
		reg(0) <= (others => '0');
                if write_enable = '1' then
                    reg(conv_integer(write_address)) <= write_data;
                end if;
            end if;
        end process;

    read_rf: process(clk, reset)
begin
    if reset = '1' then
        read_data1 <= (others => '0');
        read_data2 <= (others => '0');
        else
		if WRITE_ENABLE = '1' then
            if write_address = read_address1 and write_address /= read_address2 then
                read_data1 <= write_data;
                read_data2 <= reg(conv_integer(read_address2));
            elsif write_address = read_address2 and write_address /= read_address1 then
                read_data1 <= reg(conv_integer(read_address1));
                read_data2 <= write_data;
            elsif write_address = read_address1 and write_address = read_address2 then
                read_data1 <= write_data;
                read_data2 <= write_data;
            else
                read_data1 <= reg(conv_integer(read_address1));
                read_data2 <= reg(conv_integer(read_address2));
            end if;
	    end if;
	    end if;
end process;
end beh;