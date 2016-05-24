----------------------------------------------------------------------------------
-- Company: RAT Technologies
-- Engineer: Ryan Rumsey
-- 
-- Create Date: 04/15/2016 01:47:38 PM
-- Design Name: 
-- Module Name: Pixel_Generator - Behavioral
-- Project Name: Bufferless VGA Driver
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      Outputs RGB Color based on which object is on at a given X and Y pixel
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
use IEEE.NUMERIC_STD.ALL;

entity Pixel_Generator is
    Port ( VGACLK : in STD_LOGIC;
           VIDEO_ON : in STD_LOGIC;
           X_POS_EN : in STD_LOGIC_VECTOR (7 downto 0); --7 bits of x pos, 1 bit enable
           Y_POS    : in STD_LOGIC_VECTOR (6 downto 0); --6 bits of y pos
           RGB_DATA_IN : in STD_LOGIC_VECTOR (7 downto 0); --8 bits of color
           OBJ_ADDR : in STD_LOGIC_VECTOR (7 downto 0); --object address
           X_PIXEL  : in STD_LOGIC_VECTOR (6 downto 0); --7 bits of x
           Y_PIXEL  : in STD_LOGIC_VECTOR (6 downto 0); --6 bits of y
           RGB_DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end Pixel_Generator;

architecture Behavioral of Pixel_Generator is
    --Constant Definitions
    constant BACKGROUND_COLOR : std_logic_vector (7 downto 0) := x"1F"; --teal
    --Object signals for RGB, On and WE
    -----------------------------------
    -- Modify here to change objects --
    signal obj0_rgb, obj1_rgb, obj2_rgb : std_logic_vector (7 downto 0);
    signal obj0_on, obj1_on, obj2_on : std_logic;
    signal obj0_we, obj1_we, obj2_we : std_logic;
    -----------------------------------
    --Object Components
    component Rectangle_Object
        port (
            VGACLK   : in STD_LOGIC;
            X_POS_EN : in STD_LOGIC_VECTOR (7 downto 0);
            Y_POS    : in STD_LOGIC_VECTOR (6 downto 0);
            RGB_DATA : in STD_LOGIC_VECTOR (7 downto 0);
            WE       : in STD_LOGIC;
            X_PIXEL  : in STD_LOGIC_VECTOR (6 downto 0);
            Y_PIXEL  : in STD_LOGIC_VECTOR (6 downto 0);
            RGB_OBJ  : out STD_LOGIC_VECTOR (7 downto 0);
            ON_OBJ   : out STD_LOGIC
        );
    end component;
    component Sprite_Object
        port (
            VGACLK   : in STD_LOGIC;
            X_POS_EN : in STD_LOGIC_VECTOR (7 downto 0);
            Y_POS    : in STD_LOGIC_VECTOR (6 downto 0);
            RGB_DATA : in STD_LOGIC_VECTOR (7 downto 0);
            WE       : in STD_LOGIC;
            X_PIXEL  : in STD_LOGIC_VECTOR (6 downto 0);
            Y_PIXEL  : in STD_LOGIC_VECTOR (6 downto 0);
            RGB_OBJ  : out STD_LOGIC_VECTOR (7 downto 0);
            ON_OBJ   : out STD_LOGIC
        );
    end component;
    component Sprite_MultiColor_Object
        port (
            VGACLK   : in STD_LOGIC;
            X_POS_EN : in STD_LOGIC_VECTOR (7 downto 0);
            Y_POS    : in STD_LOGIC_VECTOR (6 downto 0);
            WE       : in STD_LOGIC;
            X_PIXEL  : in STD_LOGIC_VECTOR (6 downto 0);
            Y_PIXEL  : in STD_LOGIC_VECTOR (6 downto 0);
            RGB_OBJ  : out STD_LOGIC_VECTOR (7 downto 0);
            ON_OBJ   : out STD_LOGIC
        );
    end component;
    
begin

    ------------------------------------
    -- Face Map - obj0
    ------------------------------------
    face : Sprite_MultiColor_Object
    port map (
        VGACLK   => VGACLK,
        X_POS_EN => X_POS_EN,
        Y_POS    => Y_POS,
        WE       => obj0_we,
        X_PIXEL  => X_PIXEL,
        Y_PIXEL  => Y_PIXEL,
        RGB_OBJ  => obj0_rgb,
        ON_OBJ   => obj0_on
    );
    
    ------------------------------------
    -- Square Map - obj1
    ------------------------------------
    square : Rectangle_Object
    port map (
        VGACLK   => VGACLK,
        X_POS_EN => X_POS_EN,
        Y_POS    => Y_POS,
        RGB_DATA => RGB_DATA_IN,
        WE       => obj1_we,
        X_PIXEL  => X_PIXEL,
        Y_PIXEL  => Y_PIXEL,
        RGB_OBJ  => obj1_rgb,
        ON_OBJ   => obj1_on
    );
    
    ------------------------------------
    -- Guy Map - obj2
    ------------------------------------
    guy : Sprite_Object
    port map (
        VGACLK   => VGACLK,
        X_POS_EN => X_POS_EN,
        Y_POS    => Y_POS,
        RGB_DATA => RGB_DATA_IN,
        WE       => obj2_we,
        X_PIXEL  => X_PIXEL,
        Y_PIXEL  => Y_PIXEL,
        RGB_OBJ  => obj2_rgb,
        ON_OBJ   => obj2_on
    );
    ---------------------------------------------------
    --Object Address Decoder
    -- Modify these to change how objects are addressed
    -- DO NOT USE OBJ_ADDR = x"00", THIS IS RESERVED FOR "NO OBJECT SELECTED"
    obj0_we <= '1' when OBJ_ADDR = x"01" else '0';
    obj1_we <= '1' when OBJ_ADDR = x"02" else '0';
    obj2_we <= '1' when OBJ_ADDR = x"03" else '0';

    --End Decoder
    ---------------------------------------------------
    
    ---------------------------------------------------
    --Object RGB Mux
    -- Modify the sensitivity list and elsif's to update objects
    rgb_sel_proc : process(VIDEO_ON, obj0_on, obj1_on, obj2_on,
                                     obj0_rgb,obj1_rgb,obj2_rgb) 
    begin
        if(VIDEO_ON = '0') then
            RGB_DATA_OUT <= (others => '0');
        else
            if(obj0_on = '1') then
                RGB_DATA_OUT <= obj0_rgb;
            elsif(obj1_on = '1') then
                RGB_DATA_OUT <= obj1_rgb;
            elsif(obj2_on = '1') then
                RGB_DATA_OUT <= obj2_rgb;
            --Add elsif's here to add more objects
            else
                RGB_DATA_OUT <= BACKGROUND_COLOR;
            end if;
        end if;
    end process rgb_sel_proc;
    --End RGB Mux
    ----------------------------------------------------

end Behavioral;
