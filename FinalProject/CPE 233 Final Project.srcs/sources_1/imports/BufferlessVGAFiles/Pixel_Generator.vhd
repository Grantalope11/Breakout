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
    constant BACKGROUND_COLOR : std_logic_vector (7 downto 0) := x"00"; --black
    --Object signals for RGB, On and WE
    -----------------------------------
    -- Modify here to change objects --
    signal obj0_rgb, obj1_rgb, obj2_rgb, obj3_rgb, obj4_rgb, obj5_rgb, obj6_rgb, obj7_rgb,
           obj8_rgb, obj9_rgb, obj10_rgb, obj11_rgb, obj12_rgb, obj13_rgb, obj14_rgb, obj15_rgb,
           obj16_rgb, obj17_rgb, obj18_rgb, obj19_rgb, obj20_rgb, obj21_rgb, obj22_rgb, obj23_rgb,
           obj24_rgb, obj25_rgb, obj26_rgb, obj27_rgb, obj28_rgb : std_logic_vector (7 downto 0);
           
    signal obj0_on, obj1_on, obj2_on, obj3_on, obj4_on, obj5_on, obj6_on, obj7_on, 
           obj8_on, obj9_on, obj10_on, obj11_on, obj12_on, obj13_on, obj14_on, obj15_on,
           obj16_on, obj17_on, obj18_on, obj19_on, obj20_on, obj21_on, obj22_on, obj23_on,
           obj24_on, obj25_on, obj26_on, obj27_on, obj28_on : std_logic;
    
    signal obj0_we, obj1_we, obj2_we, obj3_we, obj4_we, obj5_we, obj6_we, obj7_we,
           obj8_we, obj9_we, obj10_we, obj11_we, obj12_we, obj13_we, obj14_we, obj15_we,
           obj16_we, obj17_we, obj18_we, obj19_we, obj20_we, obj21_we, obj22_we, obj23_we,
           obj24_we, obj25_we, obj26_we, obj27_we, obj28_we : std_logic;
    -----------------------------------
    --Object Components
    component red_Rectangle_Object
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
    component yellow_Rectangle_Object
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
    component green_Rectangle_Object
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
    component purple_Rectangle_Object
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
    component Ball_Object
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
    
begin
    ------------------------------------
    -- red block Map - obj0
    ------------------------------------
    red_block0 : red_Rectangle_Object
    port map (
        VGACLK   => VGACLK,
        X_POS_EN => X_POS_EN,
        Y_POS    => Y_POS,
        RGB_DATA => RGB_DATA_IN,
        WE       => obj0_we,
        X_PIXEL  => X_PIXEL,
        Y_PIXEL  => Y_PIXEL,
        RGB_OBJ  => obj0_rgb,
        ON_OBJ   => obj0_on
    );
    ------------------------------------
    -- red block Map - obj1                
    ------------------------------------
    red_block1 : red_Rectangle_Object    
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
    -- red block Map - obj2                
    ------------------------------------
    red_block2 : red_Rectangle_Object    
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
    ------------------------------------
    -- red block Map - obj3                
    ------------------------------------
    red_block3 : red_Rectangle_Object    
    port map (                          
        VGACLK   => VGACLK,             
        X_POS_EN => X_POS_EN,           
        Y_POS    => Y_POS,              
        RGB_DATA => RGB_DATA_IN,        
        WE       => obj3_we,            
        X_PIXEL  => X_PIXEL,            
        Y_PIXEL  => Y_PIXEL,            
        RGB_OBJ  => obj3_rgb,           
        ON_OBJ   => obj3_on             
    );
    ------------------------------------
    -- red block Map - obj4                
    ------------------------------------
    red_block4 : red_Rectangle_Object    
    port map (                          
        VGACLK   => VGACLK,             
        X_POS_EN => X_POS_EN,           
        Y_POS    => Y_POS,              
        RGB_DATA => RGB_DATA_IN,        
        WE       => obj4_we,            
        X_PIXEL  => X_PIXEL,            
        Y_PIXEL  => Y_PIXEL,            
        RGB_OBJ  => obj4_rgb,           
        ON_OBJ   => obj4_on             
    );                                 
    ------------------------------------
    -- red block Map - obj5                
    ------------------------------------
    red_block5 : red_Rectangle_Object    
    port map (                          
        VGACLK   => VGACLK,             
        X_POS_EN => X_POS_EN,           
        Y_POS    => Y_POS,              
        RGB_DATA => RGB_DATA_IN,        
        WE       => obj5_we,            
        X_PIXEL  => X_PIXEL,            
        Y_PIXEL  => Y_PIXEL,            
        RGB_OBJ  => obj5_rgb,           
        ON_OBJ   => obj5_on             
    );                                  
    ------------------------------------
    -- red block Map - obj6                
    ------------------------------------
    red_block6 : red_Rectangle_Object    
    port map (                          
        VGACLK   => VGACLK,             
        X_POS_EN => X_POS_EN,           
        Y_POS    => Y_POS,              
        RGB_DATA => RGB_DATA_IN,        
        WE       => obj6_we,            
        X_PIXEL  => X_PIXEL,            
        Y_PIXEL  => Y_PIXEL,            
        RGB_OBJ  => obj6_rgb,           
        ON_OBJ   => obj6_on             
    );                                  
    ------------------------------------   
    -- yellow block Map - obj7
    ------------------------------------
    yellow_block0 : yellow_Rectangle_Object
    port map (
        VGACLK   => VGACLK,
        X_POS_EN => X_POS_EN,
        Y_POS    => Y_POS,
        RGB_DATA => RGB_DATA_IN,
        WE       => obj7_we,
        X_PIXEL  => X_PIXEL,
        Y_PIXEL  => Y_PIXEL,
        RGB_OBJ  => obj7_rgb,
        ON_OBJ   => obj7_on
    );
    ------------------------------------   
    -- yellow block Map - obj8             
    ------------------------------------   
    yellow_block1 : yellow_Rectangle_Object 
    port map (                             
        VGACLK   => VGACLK,                
        X_POS_EN => X_POS_EN,              
        Y_POS    => Y_POS,                 
        RGB_DATA => RGB_DATA_IN,           
        WE       => obj8_we,               
        X_PIXEL  => X_PIXEL,               
        Y_PIXEL  => Y_PIXEL,               
        RGB_OBJ  => obj8_rgb,              
        ON_OBJ   => obj8_on                
    );                                     
    ------------------------------------   
    -- yellow block Map - obj9             
    ------------------------------------   
    yellow_block2 : yellow_Rectangle_Object 
    port map (                             
        VGACLK   => VGACLK,                
        X_POS_EN => X_POS_EN,              
        Y_POS    => Y_POS,                 
        RGB_DATA => RGB_DATA_IN,           
        WE       => obj9_we,               
        X_PIXEL  => X_PIXEL,               
        Y_PIXEL  => Y_PIXEL,               
        RGB_OBJ  => obj9_rgb,              
        ON_OBJ   => obj9_on                
    );                                     
    ------------------------------------   
    -- yellow block Map - obj10             
    ------------------------------------   
    yellow_block3 : yellow_Rectangle_Object 
    port map (                             
        VGACLK   => VGACLK,                
        X_POS_EN => X_POS_EN,              
        Y_POS    => Y_POS,                 
        RGB_DATA => RGB_DATA_IN,           
        WE       => obj10_we,               
        X_PIXEL  => X_PIXEL,               
        Y_PIXEL  => Y_PIXEL,               
        RGB_OBJ  => obj10_rgb,              
        ON_OBJ   => obj10_on                
    );                                     
    ------------------------------------   
    -- yellow block Map - obj11             
    ------------------------------------   
    yellow_block4 : yellow_Rectangle_Object 
    port map (                             
        VGACLK   => VGACLK,                
        X_POS_EN => X_POS_EN,              
        Y_POS    => Y_POS,                 
        RGB_DATA => RGB_DATA_IN,           
        WE       => obj11_we,               
        X_PIXEL  => X_PIXEL,               
        Y_PIXEL  => Y_PIXEL,               
        RGB_OBJ  => obj11_rgb,              
        ON_OBJ   => obj11_on                
    );                                     
    ------------------------------------   
    -- yellow block Map - obj12             
    ------------------------------------   
    yellow_block5 : yellow_Rectangle_Object 
    port map (                             
        VGACLK   => VGACLK,                
        X_POS_EN => X_POS_EN,              
        Y_POS    => Y_POS,                 
        RGB_DATA => RGB_DATA_IN,           
        WE       => obj12_we,               
        X_PIXEL  => X_PIXEL,               
        Y_PIXEL  => Y_PIXEL,               
        RGB_OBJ  => obj12_rgb,              
        ON_OBJ   => obj12_on                
    );                                     
    ------------------------------------   
    -- yellow block Map - obj13             
    ------------------------------------   
    yellow_block6 : yellow_Rectangle_Object 
    port map (                             
        VGACLK   => VGACLK,                
        X_POS_EN => X_POS_EN,              
        Y_POS    => Y_POS,                 
        RGB_DATA => RGB_DATA_IN,           
        WE       => obj13_we,               
        X_PIXEL  => X_PIXEL,               
        Y_PIXEL  => Y_PIXEL,               
        RGB_OBJ  => obj13_rgb,              
        ON_OBJ   => obj13_on                
    );                                     
    ------------------------------------  
    -- green block Map - obj14
    ------------------------------------
    green_block0 : green_Rectangle_Object
    port map (
        VGACLK   => VGACLK,
        X_POS_EN => X_POS_EN,
        Y_POS    => Y_POS,
        RGB_DATA => RGB_DATA_IN,
        WE       => obj14_we,
        X_PIXEL  => X_PIXEL,
        Y_PIXEL  => Y_PIXEL,
        RGB_OBJ  => obj14_rgb,
        ON_OBJ   => obj14_on
    );
    ------------------------------------  
    -- green block Map - obj15            
    ------------------------------------  
    green_block1 : green_Rectangle_Object 
    port map (                            
        VGACLK   => VGACLK,               
        X_POS_EN => X_POS_EN,             
        Y_POS    => Y_POS,                
        RGB_DATA => RGB_DATA_IN,          
        WE       => obj15_we,              
        X_PIXEL  => X_PIXEL,              
        Y_PIXEL  => Y_PIXEL,              
        RGB_OBJ  => obj15_rgb,             
        ON_OBJ   => obj15_on               
    );
    ------------------------------------  
    -- green block Map - obj16            
    ------------------------------------  
    green_block2 : green_Rectangle_Object 
    port map (                            
        VGACLK   => VGACLK,               
        X_POS_EN => X_POS_EN,             
        Y_POS    => Y_POS,                
        RGB_DATA => RGB_DATA_IN,          
        WE       => obj16_we,              
        X_PIXEL  => X_PIXEL,              
        Y_PIXEL  => Y_PIXEL,              
        RGB_OBJ  => obj16_rgb,             
        ON_OBJ   => obj16_on               
    );                                    
    ------------------------------------  
    -- green block Map - obj17            
    ------------------------------------  
    green_block3 : green_Rectangle_Object 
    port map (                            
        VGACLK   => VGACLK,               
        X_POS_EN => X_POS_EN,             
        Y_POS    => Y_POS,                
        RGB_DATA => RGB_DATA_IN,          
        WE       => obj17_we,              
        X_PIXEL  => X_PIXEL,              
        Y_PIXEL  => Y_PIXEL,              
        RGB_OBJ  => obj17_rgb,             
        ON_OBJ   => obj17_on               
    );                                    
    ------------------------------------  
    -- green block Map - obj18            
    ------------------------------------  
    green_block4 : green_Rectangle_Object 
    port map (                            
        VGACLK   => VGACLK,               
        X_POS_EN => X_POS_EN,             
        Y_POS    => Y_POS,                
        RGB_DATA => RGB_DATA_IN,          
        WE       => obj18_we,              
        X_PIXEL  => X_PIXEL,              
        Y_PIXEL  => Y_PIXEL,              
        RGB_OBJ  => obj18_rgb,             
        ON_OBJ   => obj18_on               
    );                                    
    ------------------------------------  
    -- green block Map - obj19            
    ------------------------------------  
    green_block5 : green_Rectangle_Object 
    port map (                            
        VGACLK   => VGACLK,               
        X_POS_EN => X_POS_EN,             
        Y_POS    => Y_POS,                
        RGB_DATA => RGB_DATA_IN,          
        WE       => obj19_we,              
        X_PIXEL  => X_PIXEL,              
        Y_PIXEL  => Y_PIXEL,              
        RGB_OBJ  => obj19_rgb,             
        ON_OBJ   => obj19_on               
    );                                    
    ------------------------------------  
    -- green block Map - obj20            
    ------------------------------------  
    green_block6 : green_Rectangle_Object 
    port map (                            
        VGACLK   => VGACLK,               
        X_POS_EN => X_POS_EN,             
        Y_POS    => Y_POS,                
        RGB_DATA => RGB_DATA_IN,          
        WE       => obj20_we,              
        X_PIXEL  => X_PIXEL,              
        Y_PIXEL  => Y_PIXEL,              
        RGB_OBJ  => obj20_rgb,             
        ON_OBJ   => obj20_on               
    );
    ------------------------------------    
    -- purple block Map - obj21
    ------------------------------------
    purple_block0 : purple_Rectangle_Object 
    port map (
        VGACLK   => VGACLK,
        X_POS_EN => X_POS_EN,
        Y_POS    => Y_POS,
        RGB_DATA => RGB_DATA_IN,
        WE       => obj21_we,
        X_PIXEL  => X_PIXEL,
        Y_PIXEL  => Y_PIXEL,
        RGB_OBJ  => obj21_rgb,
        ON_OBJ   => obj21_on
    );
    ------------------------------------    
    -- purple block Map - obj22             
    ------------------------------------    
    purple_block1 : purple_Rectangle_Object 
    port map (                              
        VGACLK   => VGACLK,                 
        X_POS_EN => X_POS_EN,               
        Y_POS    => Y_POS,                  
        RGB_DATA => RGB_DATA_IN,            
        WE       => obj22_we,                
        X_PIXEL  => X_PIXEL,                
        Y_PIXEL  => Y_PIXEL,                
        RGB_OBJ  => obj22_rgb,               
        ON_OBJ   => obj22_on                 
    );                                      
    ------------------------------------    
    -- purple block Map - obj23             
    ------------------------------------    
    purple_block2 : purple_Rectangle_Object 
    port map (                              
        VGACLK   => VGACLK,                 
        X_POS_EN => X_POS_EN,               
        Y_POS    => Y_POS,                  
        RGB_DATA => RGB_DATA_IN,            
        WE       => obj23_we,                
        X_PIXEL  => X_PIXEL,                
        Y_PIXEL  => Y_PIXEL,                
        RGB_OBJ  => obj23_rgb,               
        ON_OBJ   => obj23_on                 
    );                                      
    ------------------------------------    
    -- purple block Map - obj24             
    ------------------------------------    
    purple_block3 : purple_Rectangle_Object 
    port map (                              
        VGACLK   => VGACLK,                 
        X_POS_EN => X_POS_EN,               
        Y_POS    => Y_POS,                  
        RGB_DATA => RGB_DATA_IN,            
        WE       => obj24_we,                
        X_PIXEL  => X_PIXEL,                
        Y_PIXEL  => Y_PIXEL,                
        RGB_OBJ  => obj24_rgb,               
        ON_OBJ   => obj24_on                 
    );                                      
    ------------------------------------    
    -- purple block Map - obj25             
    ------------------------------------    
    purple_block4 : purple_Rectangle_Object 
    port map (                              
        VGACLK   => VGACLK,                 
        X_POS_EN => X_POS_EN,               
        Y_POS    => Y_POS,                  
        RGB_DATA => RGB_DATA_IN,            
        WE       => obj25_we,                
        X_PIXEL  => X_PIXEL,                
        Y_PIXEL  => Y_PIXEL,                
        RGB_OBJ  => obj25_rgb,               
        ON_OBJ   => obj25_on                 
    );                                      
    ------------------------------------    
    -- purple block Map - obj26             
    ------------------------------------    
    purple_block5 : purple_Rectangle_Object 
    port map (                              
        VGACLK   => VGACLK,                 
        X_POS_EN => X_POS_EN,               
        Y_POS    => Y_POS,                  
        RGB_DATA => RGB_DATA_IN,            
        WE       => obj26_we,                
        X_PIXEL  => X_PIXEL,                
        Y_PIXEL  => Y_PIXEL,                
        RGB_OBJ  => obj26_rgb,               
        ON_OBJ   => obj26_on                 
    );                                      
    ------------------------------------    
    -- purple block Map - obj27             
    ------------------------------------    
    purple_block6 : purple_Rectangle_Object 
    port map (                              
        VGACLK   => VGACLK,                 
        X_POS_EN => X_POS_EN,               
        Y_POS    => Y_POS,                  
        RGB_DATA => RGB_DATA_IN,            
        WE       => obj27_we,                
        X_PIXEL  => X_PIXEL,                
        Y_PIXEL  => Y_PIXEL,                
        RGB_OBJ  => obj27_rgb,               
        ON_OBJ   => obj27_on                 
    );
    ------------------------------------
    -- Ball Map - obj28
    ------------------------------------
    Ball : Ball_Object
    port map (
        VGACLK   => VGACLK,
        X_POS_EN => X_POS_EN,
        Y_POS    => Y_POS,
        RGB_DATA => RGB_DATA_IN,
        WE       => obj28_we,
        X_PIXEL  => X_PIXEL,
        Y_PIXEL  => Y_PIXEL,
        RGB_OBJ  => obj28_rgb,
        ON_OBJ   => obj28_on
    );
    ---------------------------------------------------
    --Object Address Decoder
    -- Modify these to change how objects are addressed
    -- DO NOT USE OBJ_ADDR = x"00", THIS IS RESERVED FOR "NO OBJECT SELECTED"
    obj0_we <= '1' when OBJ_ADDR = x"01" else '0';
    obj1_we <= '1' when OBJ_ADDR = x"02" else '0';
    obj2_we <= '1' when OBJ_ADDR = x"03" else '0';
    obj3_we <= '1' when OBJ_ADDR = x"04" else '0';
    obj4_we <= '1' when OBJ_ADDR = x"05" else '0';
    obj5_we <= '1' when OBJ_ADDR = x"06" else '0';
    obj6_we <= '1' when OBJ_ADDR = x"07" else '0';
    obj7_we <= '1' when OBJ_ADDR = x"08" else '0';
    obj8_we <= '1' when OBJ_ADDR = x"09" else '0';
    obj9_we <= '1' when OBJ_ADDR = x"0A" else '0';
    obj10_we <= '1' when OBJ_ADDR = x"0B" else '0';
    obj11_we <= '1' when OBJ_ADDR = x"0C" else '0';
    obj12_we <= '1' when OBJ_ADDR = x"0D" else '0';
    obj13_we <= '1' when OBJ_ADDR = x"0E" else '0';
    obj14_we <= '1' when OBJ_ADDR = x"0F" else '0';
    obj15_we <= '1' when OBJ_ADDR = x"10" else '0';
    obj16_we <= '1' when OBJ_ADDR = x"11" else '0';
    obj17_we <= '1' when OBJ_ADDR = x"12" else '0';
    obj18_we <= '1' when OBJ_ADDR = x"13" else '0';
    obj19_we <= '1' when OBJ_ADDR = x"14" else '0';
    obj20_we <= '1' when OBJ_ADDR = x"15" else '0';
    obj21_we <= '1' when OBJ_ADDR = x"16" else '0';
    obj22_we <= '1' when OBJ_ADDR = x"17" else '0';
    obj23_we <= '1' when OBJ_ADDR = x"18" else '0';
    obj24_we <= '1' when OBJ_ADDR = x"19" else '0';
    obj25_we <= '1' when OBJ_ADDR = x"1A" else '0';
    obj26_we <= '1' when OBJ_ADDR = x"1B" else '0';
    obj27_we <= '1' when OBJ_ADDR = x"1C" else '0';
    obj28_we <= '1' when OBJ_ADDR = x"1D" else '0'; --> this one is the ball (sorry guys)
    ---------------------------------------------------
    --End Decoder
    ---------------------------------------------------
    
    ---------------------------------------------------
    --Object RGB Mux
    -- Modify the sensitivity list and elsif's to update objects
    rgb_sel_proc : process(VIDEO_ON, 
                           obj0_on, obj1_on, obj2_on, obj3_on, obj4_on, obj5_on, obj6_on, obj7_on, 
                           obj8_on, obj9_on, obj10_on, obj11_on, obj12_on, obj13_on, obj14_on, obj15_on,
                           obj16_on, obj17_on, obj18_on, obj19_on, obj20_on, obj21_on, obj22_on, obj23_on,
                           obj24_on, obj25_on, obj26_on, obj27_on, obj28_on,
                           
                           obj0_rgb, obj1_rgb, obj2_rgb, obj3_rgb, obj4_rgb, obj5_rgb, obj6_rgb, obj7_rgb,
                           obj8_rgb, obj9_rgb, obj10_rgb, obj11_rgb, obj12_rgb, obj13_rgb, obj14_rgb, obj15_rgb,
                           obj16_rgb, obj17_rgb, obj18_rgb, obj19_rgb, obj20_rgb, obj21_rgb, obj22_rgb, obj23_rgb,
                           obj24_rgb, obj25_rgb, obj26_rgb, obj27_rgb, obj28_rgb) 
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
            elsif(obj3_on = '1') then
                RGB_DATA_OUT <= obj3_rgb;
            elsif(obj4_on = '1') then    
                RGB_DATA_OUT <= obj4_rgb;
            elsif(obj5_on = '1') then    
                RGB_DATA_OUT <= obj5_rgb;
            elsif(obj6_on = '1') then    
                RGB_DATA_OUT <= obj6_rgb;
            elsif(obj7_on = '1') then
                RGB_DATA_OUT <= obj7_rgb;
            elsif(obj8_on = '1') then                
                RGB_DATA_OUT <= obj8_rgb;                                        
            elsif(obj9_on = '1') then    
                RGB_DATA_OUT <= obj9_rgb;    
            elsif(obj10_on = '1') then
                RGB_DATA_OUT <= obj10_rgb;
            elsif(obj11_on = '1') then
                RGB_DATA_OUT <= obj11_rgb;
            elsif(obj12_on = '1') then
                RGB_DATA_OUT <= obj12_rgb;
            elsif(obj13_on = '1') then
                RGB_DATA_OUT <= obj13_rgb;
            elsif(obj14_on = '1') then
                RGB_DATA_OUT <= obj14_rgb;
            elsif(obj15_on = '1') then
                RGB_DATA_OUT <= obj15_rgb;
            elsif(obj16_on = '1') then
                RGB_DATA_OUT <= obj16_rgb;
            elsif(obj17_on = '1') then
                RGB_DATA_OUT <= obj17_rgb;
            elsif(obj18_on = '1') then
                RGB_DATA_OUT <= obj18_rgb;
            elsif(obj19_on = '1') then 
                RGB_DATA_OUT <= obj19_rgb;  
            elsif(obj20_on = '1') then 
                RGB_DATA_OUT <= obj20_rgb;  
            elsif(obj21_on = '1') then 
                RGB_DATA_OUT <= obj21_rgb;  
            elsif(obj22_on = '1') then 
                RGB_DATA_OUT <= obj22_rgb;  
            elsif(obj23_on = '1') then 
                RGB_DATA_OUT <= obj23_rgb;  
            elsif(obj24_on = '1') then 
                RGB_DATA_OUT <= obj24_rgb;  
            elsif(obj25_on = '1') then 
                RGB_DATA_OUT <= obj25_rgb;  
            elsif(obj26_on = '1') then 
                RGB_DATA_OUT <= obj26_rgb;  
            elsif(obj27_on = '1') then 
                RGB_DATA_OUT <= obj27_rgb;  
            elsif(obj28_on = '1') then  
                RGB_DATA_OUT <= obj28_rgb;                   
            else                            
                RGB_DATA_OUT <= BACKGROUND_COLOR;
            end if;
        end if;
    end process rgb_sel_proc;
    --End RGB Mux
    ----------------------------------------------------

end Behavioral;
