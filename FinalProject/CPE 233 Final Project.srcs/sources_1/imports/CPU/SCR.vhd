----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2016 02:07:09 PM
-- Design Name: 
-- Module Name: SCR - Behavioral
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

entity SCR is
    Port ( WE : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DATA_IN : in STD_LOGIC_VECTOR (9 downto 0);
           ADDR : in STD_LOGIC_VECTOR (7 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));
end SCR;

architecture Behavioral of SCR is

type ram_type is array (0 to 255) of std_logic_vector (9 downto 0);
signal gen_ram : ram_type := (others => (others => '0'));

begin

SCR_process: process (CLK, WE, DATA_IN)
begin
    if (rising_edge(CLK)) then
        if (WE = '1') then
            gen_ram(conv_integer(ADDR)) <= DATA_IN;
        end if;
    end if;
end process;

DATA_OUT <= gen_ram(conv_integer(ADDR));

end Behavioral;
