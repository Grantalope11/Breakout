----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2016 02:20:00 PM
-- Design Name: 
-- Module Name: SP - Behavioral
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

entity SP is
    Port ( RST      : in STD_LOGIC;
           LD       : in STD_LOGIC;
           INCR     : in STD_LOGIC;
           DECR     : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           DATA_IN  : in STD_LOGIC_VECTOR (7 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end SP;

architecture Behavioral of SP is

begin
SP_process: process (RST, CLK, INCR, DECR, LD, DATA_IN)

variable DATA: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin
    if (RST = '1') then
        DATA := (others => '0');
    elsif (rising_edge(clk)) then
        if (INCR = '1') then
            DATA := DATA + 1;
        elsif (DECR = '1') then
            DATA := DATA - 1;
        elsif (LD = '1') then
            DATA := DATA_IN;
        end if;
    end if;
    
    DATA_OUT <= DATA;
end process;
end Behavioral;
