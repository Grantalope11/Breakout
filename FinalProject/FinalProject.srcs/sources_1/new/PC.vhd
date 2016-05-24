----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2016 01:20:17 PM
-- Design Name: 
-- Module Name: PC - Behavioral
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

entity PC is
    Port ( RST      : in STD_LOGIC;
           LD       : in STD_LOGIC;
           DIN      : in STD_LOGIC_VECTOR (9 downto 0);
           CLK      : in STD_LOGIC;
           INC      : in STD_LOGIC;
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0));
end PC;

architecture Behavioral of PC is
begin

PC_process: process (RST, DIN, LD, CLK, INC)

variable PC_CNT: STD_LOGIC_VECTOR (9 downto 0) := "0000000001";

begin
    if (RST = '1') then
        PC_CNT := "0000000001";
    elsif (rising_edge(CLK)) then
        if (INC = '1') then
            PC_CNT := PC_CNT + 1;
        elsif (LD = '1') then
            PC_CNT := DIN;
        end if;
    end if;
    
    PC_COUNT <= PC_CNT;
end process PC_process;
end Behavioral;
