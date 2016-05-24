----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2016 01:21:38 PM
-- Design Name: 
-- Module Name: REG_FILE - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity REG_FILE is
    Port ( WR       : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           DIN      : in STD_LOGIC_VECTOR (7 downto 0);
           ADRX     : in STD_LOGIC_VECTOR (4 downto 0);
           ADRY     : in STD_LOGIC_VECTOR (4 downto 0);
           DX_OUT   : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT   : out STD_LOGIC_VECTOR (7 downto 0));
end REG_FILE;

architecture Behavioral of REG_FILE is

type ram_type is array (0 to 31) of std_logic_vector (7 downto 0);
signal gen_ram : ram_type := (others => (others => '0'));

begin
ram_write: process (CLK, WR, DIN)
begin
    if (rising_edge(CLK)) then
        if (WR = '1') then
            gen_ram(conv_integer(ADRX)) <= DIN;
        end if;
    end if;
end process;

DX_OUT <= gen_ram(conv_integer(ADRX));
DY_OUT <= gen_ram(conv_integer(ADRY));

end Behavioral;
