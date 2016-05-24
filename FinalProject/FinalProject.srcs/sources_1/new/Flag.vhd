----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2016 02:53:01 PM
-- Design Name: 
-- Module Name: Flag - Behavioral
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

entity Flag is
    Port ( LD       : in STD_LOGIC;
           CLR      : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           SET      : in STD_LOGIC;
           DATA_IN  : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC);
end Flag;

architecture Behavioral of Flag is
begin
Flag_process: process (LD, CLR, CLK, SET, DATA_IN)

variable DATA: STD_LOGIC;

begin
    if (rising_edge(CLK)) then
        if (CLR = '1') then
            DATA := '0';
        elsif (SET = '1') then
            DATA := '1';
        elsif (LD = '1') then
            DATA := DATA_IN;
        end if;
    end if;
    
    DATA_OUT <= DATA;
end process;
end Behavioral;
