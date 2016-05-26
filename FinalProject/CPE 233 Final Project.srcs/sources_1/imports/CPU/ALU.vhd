----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2016 12:54:22 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( CIN : in STD_LOGIC;
           A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC_VECTOR (3 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC;
           RESULT : out STD_LOGIC_VECTOR (7 downto 0));
end ALU;

architecture Behavioral of ALU is
begin

ALU_process: process (SEL, A, B, CIN)
    
variable tempResult : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');

begin

    case (SEL) is
  
        --ADD
        when "0000" =>
            tempResult := ('0' & A) + ('0' & B);
        --ADDC    
        when "0001" =>
            tempResult := ('0' & A) + ('0' & B) + (x"00" & CIN);
        --SUB   
        when "0010" =>
            tempResult := ('0' & A) - ('0' & B);
        --SUBC
        when "0011" =>
            tempResult := ('0' & A) - ('0' & B) - (x"00" & CIN);
        --CMP
        when "0100" =>
            tempResult := ('0' & A) - ('0' & B);
        --AND
        when "0101" =>
            tempResult := ('0' & A) and ('0' & B);
        --OR
        when "0110" =>
            tempResult := ('0' & A) or ('0' & B);
        --EXOR
        when "0111" =>
            tempResult := ('0' & A) xor ('0' & B);
        --TEST
        when "1000" =>
            tempResult := ('0' & A) and ('0' & B);
        --LSL
        when "1001" =>
            tempResult := A & CIN;
        --LSR
        when "1010" =>
            tempResult := A(0) & CIN & A(7 downto 1);
        --ROL
        when "1011" =>
            tempResult := A & A (7);
        --ROR
        when "1100" =>
            tempResult := A(0) & A(0) & A(7 downto 1);
        --ASR
        when "1101" =>
            tempResult := A(0) & A(7) & A(7 downto 1);
        --MOV
        when "1110" =>
            tempResult := CIN & B;
            
        --catch all case            
        when others => 
            tempResult := (others => '0');
        end case;

    --assign Z and C flags
    C <= tempResult (8);
    if (tempResult(7 downto 0) = x"00") then
        Z <= '1';
    else
        Z <= '0';
    end if;
    Result <= tempResult(7 downto 0);    
end process ALU_process;


end Behavioral;
