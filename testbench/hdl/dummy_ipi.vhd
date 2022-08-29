---------------------------------------------------------------------------------------------------
-- Copyright (c) 2022 by Paul Scherrer Institute, Switzerland
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Libraries
---------------------------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library work;

---------------------------------------------------------------------------------------------------
-- Entity Declaration
---------------------------------------------------------------------------------------------------
entity dummy_ipi is
    generic
    (
        Clk_FreqHz_g            : natural       := 150e6;
        M_Axi_DataWidth_g       : natural       := 32;
        M_Axi_AddrWidth_g       : natural       := 16;
        S_Axi_DataWidth_g       : natural       := 32;
        S_Axi_AddrWidth_g       : natural       := 16;
        M_Axis_TDataWidth_g     : natural       := 32;
        M_Axis_TUserWidth_g     : natural       := 0;
        S_Axis_TDataWidth_g     : natural       := 32;
        S_Axis_TUserWidth_g     : natural       := 0
    );
    port
    (
        -------------------------------------------------------------------------------------------
        -- Clock and Reset
        -------------------------------------------------------------------------------------------
        Clk             : in  std_logic;
        Rst             : in  std_logic;
                              
        Axi_Clk         : in  std_logic;
        Axi_ResetN      : in  std_logic;
                              
        Axis_Clk        : in  std_logic;
        Axis_ResetN     : in  std_logic;

        -------------------------------------------------------------------------------------------
        -- Interrupt [Clk]
        -------------------------------------------------------------------------------------------
        Interrupt       : out std_logic;
        
        -------------------------------------------------------------------------------------------
        -- UART [Clk]
        -------------------------------------------------------------------------------------------
        Uart_Tx         : out std_logic;
        Uart_Rx         : in  std_logic;
        
        -------------------------------------------------------------------------------------------
        -- AXI Master Interface [Axi_Clk]
        -------------------------------------------------------------------------------------------
        -- AXI Write Address Channel
        M_Axi_AwAddr    : out std_logic_vector(M_Axi_AddrWidth_g-1 downto 0);
        M_Axi_AwLen     : out std_logic_vector(7 downto 0);
        M_Axi_AwSize    : out std_logic_vector(2 downto 0);
        M_Axi_AwBurst   : out std_logic_vector(1 downto 0);
        M_Axi_AwLock    : out std_logic;
        M_Axi_AwCache   : out std_logic_vector(3 downto 0);
        M_Axi_AwProt    : out std_logic_vector(2 downto 0);
        M_Axi_AwValid   : out std_logic;
        M_Axi_AwReady   : in  std_logic                                         := '0';
        -- AXI Write Data Channel
        M_Axi_WData     : out std_logic_vector(M_Axi_DataWidth_g-1 downto 0);
        M_Axi_WStrb     : out std_logic_vector(M_Axi_DataWidth_g/8-1 downto 0);
        M_Axi_WLast     : out std_logic;
        M_Axi_WValid    : out std_logic;
        M_Axi_WReady    : in  std_logic                                         := '0';
        -- AXI Write Response Channel
        M_Axi_BResp     : in  std_logic_vector(1 downto 0)                      := (others => '0');
        M_Axi_BValid    : in  std_logic                                         := '0';
        M_Axi_BReady    : out std_logic;
        -- AXI Read Address Channel
        M_Axi_ArAddr    : out std_logic_vector(M_Axi_AddrWidth_g-1 downto 0);
        M_Axi_ArLen     : out std_logic_vector(7 downto 0);
        M_Axi_ArSize    : out std_logic_vector(2 downto 0);
        M_Axi_ArBurst   : out std_logic_vector(1 downto 0);
        M_Axi_ArLock    : out std_logic;
        M_Axi_ArCache   : out std_logic_vector(3 downto 0);
        M_Axi_ArProt    : out std_logic_vector(2 downto 0);
        M_Axi_ArValid   : out std_logic;
        M_Axi_ArReady   : in  std_logic                                         := '0';
        -- AXI Read Data Channel
        M_Axi_RData     : in  std_logic_vector(M_Axi_DataWidth_g-1 downto 0)    := (others => '0');
        M_Axi_RResp     : in  std_logic_vector(1 downto 0)                      := (others => '0');
        M_Axi_RLast     : in  std_logic                                         := '0';
        M_Axi_RValid    : in  std_logic                                         := '0';
        M_Axi_RReady    : out std_logic;
        
        -------------------------------------------------------------------------------------------
        -- AXI Slave Interface [Axi_Clk]
        -------------------------------------------------------------------------------------------
        -- AXI Write Address Channel
        S_Axi_AwAddr    : in  std_logic_vector(S_Axi_AddrWidth_g-1 downto 0)    := (others => '0');
        S_Axi_AwLen     : in  std_logic_vector(7 downto 0)                      := (others => '0');
        S_Axi_AwSize    : in  std_logic_vector(2 downto 0)                      := (others => '0');
        S_Axi_AwBurst   : in  std_logic_vector(1 downto 0)                      := (others => '0');
        S_Axi_AwLock    : in  std_logic                                         := '0';
        S_Axi_AwCache   : in  std_logic_vector(3 downto 0)                      := (others => '0');
        S_Axi_AwProt    : in  std_logic_vector(2 downto 0)                      := (others => '0');
        S_Axi_AwValid   : in  std_logic                                         := '0';
        S_Axi_AwReady   : out std_logic;

        -- AXI Write Data Channel
        S_Axi_WData     : in  std_logic_vector(S_Axi_DataWidth_g-1 downto 0)    := (others => '0');
        S_Axi_WStrb     : in  std_logic_vector(S_Axi_DataWidth_g/8-1 downto 0)  := (others => '0');
        S_Axi_WLast     : in  std_logic                                         := '0';
        S_Axi_WValid    : in  std_logic                                         := '0';
        S_Axi_WReady    : out std_logic;

        -- AXI Write Response Channel
        S_Axi_BResp     : out std_logic_vector(1 downto 0);
        S_Axi_BValid    : out std_logic;
        S_Axi_BReady    : in  std_logic                                         := '0';

        -- AXI Read Address Channel
        S_Axi_ArAddr    : in  std_logic_vector(S_Axi_AddrWidth_g-1 downto 0)    := (others => '0');
        S_Axi_ArLen     : in  std_logic_vector(7 downto 0)                      := (others => '0');
        S_Axi_ArSize    : in  std_logic_vector(2 downto 0)                      := (others => '0');
        S_Axi_ArBurst   : in  std_logic_vector(1 downto 0)                      := (others => '0');
        S_Axi_ArLock    : in  std_logic                                         := '0';
        S_Axi_ArCache   : in  std_logic_vector(3 downto 0)                      := (others => '0');
        S_Axi_ArProt    : in  std_logic_vector(2 downto 0)                      := (others => '0');
        S_Axi_ArValid   : in  std_logic                                         := '0';
        S_Axi_ArReady   : out std_logic;

        -- AXI Read Data Channel
        S_Axi_RData     : out std_logic_vector(S_Axi_DataWidth_g-1 downto 0);
        S_Axi_RResp     : out std_logic_vector(1 downto 0);
        S_Axi_RLast     : out std_logic;
        S_Axi_RValid    : out std_logic;
        S_Axi_RReady    : in  std_logic                                         := '0';
        
        -------------------------------------------------------------------------------------------
        -- AXI Stream Master Interface [Axis_Clk]
        -------------------------------------------------------------------------------------------
		M_Axis_TData    : out std_logic_vector(M_Axis_TDataWidth_g-1 downto 0);
		M_Axis_TStrb    : out std_logic_vector(M_Axis_TDataWidth_g/8-1 downto 0);
		M_Axis_TKeep    : out std_logic_vector(M_Axis_TDataWidth_g/8-1 downto 0);
		M_Axis_TUser    : out std_logic_vector(M_Axis_TUserWidth_g-1 downto 0);
		M_Axis_TLast    : out std_logic;
		M_Axis_TValid   : out std_logic;
		M_Axis_TReady   : in  std_logic                                         := '0';
        
        -------------------------------------------------------------------------------------------
        -- AXI Stream Slave Interface [Axis_Clk]
        -------------------------------------------------------------------------------------------
		S_Axis_TData    : in  std_logic_vector(S_Axis_TDataWidth_g-1 downto 0)  := (others => '0');
		S_Axis_TStrb    : in  std_logic_vector(S_Axis_TDataWidth_g/8-1 downto 0):= (others => '0');
		S_Axis_TKeep    : in  std_logic_vector(S_Axis_TDataWidth_g/8-1 downto 0):= (others => '0');
		S_Axis_TUser    : in  std_logic_vector(S_Axis_TUserWidth_g-1 downto 0)  := (others => '0');
		S_Axis_TLast    : in  std_logic                                         := '0';
		S_Axis_TValid   : in  std_logic                                         := '0';
		S_Axis_TReady   : out std_logic
    );
end entity dummy_ipi;

---------------------------------------------------------------------------------------------------
-- Architecture Implementation
---------------------------------------------------------------------------------------------------

architecture struct of dummy_ipi is

begin

        -- Misc [Clk]
        Interrupt       <= '0';
        Uart_Tx         <= '0';
        
        -- AXI Master Interface [Axi_Clk]
        M_Axi_AwAddr    <= (others => '0');
        M_Axi_AwLen     <= (others => '0');
        M_Axi_AwSize    <= (others => '0');
        M_Axi_AwBurst   <= (others => '0');
        M_Axi_AwLock    <= '0';
        M_Axi_AwCache   <= (others => '0');
        M_Axi_AwProt    <= (others => '0');
        M_Axi_AwValid   <= '0';
        M_Axi_WData     <= (others => '0');
        M_Axi_WStrb     <= (others => '0');
        M_Axi_WLast     <= '0';
        M_Axi_WValid    <= '0';
        M_Axi_BReady    <= '0';
        M_Axi_ArAddr    <= (others => '0');
        M_Axi_ArLen     <= (others => '0');
        M_Axi_ArSize    <= (others => '0');
        M_Axi_ArBurst   <= (others => '0');
        M_Axi_ArLock    <= '0';
        M_Axi_ArCache   <= (others => '0');
        M_Axi_ArProt    <= (others => '0');
        M_Axi_ArValid   <= '0';
        M_Axi_RReady    <= '0';
        
        -- AXI Slave Interface [Axi_Clk]
        S_Axi_AwReady   <= '0';
        S_Axi_WReady    <= '0';
        S_Axi_BResp     <= (others => '0');
        S_Axi_BValid    <= '0';
        S_Axi_ArReady   <= '0';
        S_Axi_RData     <= (others => '0');
        S_Axi_RResp     <= (others => '0');
        S_Axi_RLast     <= '0';
        S_Axi_RValid    <= '0';
        
        -- AXI Stream Master Interface [Axis_Clk]
		M_Axis_TData    <= (others => '0');
		M_Axis_TStrb    <= (others => '0');
		M_Axis_TKeep    <= (others => '0');
		M_Axis_TUser    <= (others => '0');
		M_Axis_TLast    <= '0';
		M_Axis_TValid   <= '0';
        
        -- AXI Stream Slave Interface [Axis_Clk]
		S_Axis_TReady   <= '0';
		
		
		i_test : entity work.file2
		port map(
        Clk => '1',
        Rst => '0',
        Tester => open
        );
    
end architecture struct;

---------------------------------------------------------------------------------------------------
-- EOF
---------------------------------------------------------------------------------------------------
