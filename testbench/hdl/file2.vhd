---------------------------------------------------------------------------------------------------
-- Copyright (c) 2022 by Paul Scherrer Institute, Switzerland
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Libraries
---------------------------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

---------------------------------------------------------------------------------------------------
-- Entity Declaration
---------------------------------------------------------------------------------------------------
entity file2 is
    port
    (
        Clk             : in  std_logic;
        Rst             : in  std_logic;
        Tester          : out std_logic
        
    );
end entity file2;

---------------------------------------------------------------------------------------------------
-- Architecture Implementation
---------------------------------------------------------------------------------------------------
architecture struct of file2 is

    component test is
    generic(
        CLKIN_FREQ : integer
    );
    port(
        refclk : in std_logic;
        reset : in std_logic;
        clkout0 : out std_logic;
        dataout0 : out std_logic_vector(3 downto 0)
    );
    end component test;
    
begin
    Tester <= '0';
    
        i_xxx : component test
    generic map(
        CLKIN_FREQ => 1000
    )
    port map(
        refclk => '0',
        reset => '1',
        clkout0 => open,
        dataout0 => open
    );
    
end architecture struct;

---------------------------------------------------------------------------------------------------
-- EOF
---------------------------------------------------------------------------------------------------
