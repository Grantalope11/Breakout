----------------------------------------------------------------------------------
-- Name: 
-- Date: 
-- 
-- Description: Top Level RAT CPU
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity RAT_CPU is
    Port ( IN_PORT      : in  STD_LOGIC_VECTOR (7 downto 0);
           RESET    	: in  STD_LOGIC;
           CLK          : in  STD_LOGIC;
           INT          : in  STD_LOGIC;
           OUT_PORT     : out  STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID      : out  STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB      : out  STD_LOGIC);
end RAT_CPU;



architecture Behavioral of RAT_CPU is

   --declare all of your components here
   --hint (just copy the entities and change the word entity to component
   --and end with end component
component CONTROL_UNIT is
   Port ( CLK           : in   STD_LOGIC;
          C             : in   STD_LOGIC;
          Z             : in   STD_LOGIC;
          RESET         : in   STD_LOGIC;
          OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
          OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);
          INTER         : in   STD_LOGIC;
            
          I_SET         : out  STD_LOGIC;
          I_CLR         : out  STD_LOGIC;
            
          PC_LD         : out  STD_LOGIC;
          PC_INC        : out  STD_LOGIC;
          PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
          
          RF_WR         : out  STD_LOGIC;
          RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);
         
          ALU_OPY_SEL   : out  STD_LOGIC;
          ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);

          FLG_C_LD      : out  STD_LOGIC;
          FLG_C_SET     : out  STD_LOGIC;
          FLG_C_CLR     : out  STD_LOGIC;
          FLG_Z_CLR     : out  STD_LOGIC;
          FLG_Z_LD      : out  STD_LOGIC;
          FLG_LD_SEL    : out  STD_LOGIC;
          FLG_SHAD_LD   : out  STD_LOGIC;
         
          SP_LD         : out  STD_LOGIC;
          SP_INCR       : out  STD_LOGIC;
          SP_DECR       : out  STD_LOGIC;
          
          SCR_WE        : out  STD_LOGIC;
          SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
          SCR_DATA_SEL  : out  STD_LOGIC;
             
          RST           : out  STD_LOGIC;
          IO_STROBE     : out  STD_LOGIC);          
end component;

component Flag is
   Port ( LD       : in STD_LOGIC;
          CLR      : in STD_LOGIC;
          CLK      : in STD_LOGIC;
          SET      : in STD_LOGIC;
          DATA_IN  : in STD_LOGIC;
          DATA_OUT : out STD_LOGIC);
end component;

component PC is
    Port ( RST      : in STD_LOGIC;
           LD       : in STD_LOGIC;
           DIN      : in STD_LOGIC_VECTOR (9 downto 0);
           CLK      : in STD_LOGIC;
           INC      : in STD_LOGIC;
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component REG_FILE is
    Port ( WR       : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           DIN      : in STD_LOGIC_VECTOR (7 downto 0);
           ADRX     : in STD_LOGIC_VECTOR (4 downto 0);
           ADRY     : in STD_LOGIC_VECTOR (4 downto 0);
           DX_OUT   : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT   : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component ALU is
    Port ( CIN      : in STD_LOGIC;
           A        : in STD_LOGIC_VECTOR (7 downto 0);
           B        : in STD_LOGIC_VECTOR (7 downto 0);
           SEL      : in STD_LOGIC_VECTOR (3 downto 0);
           C        : out STD_LOGIC;
           Z        : out STD_LOGIC;
           RESULT   : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component prog_rom  
  port (     ADDRESS : in std_logic_vector(9 downto 0); 
         INSTRUCTION : out std_logic_vector(17 downto 0); 
                 CLK : in std_logic);  
end component;

component SCR is
    Port ( WE       : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           DATA_IN  : in STD_LOGIC_VECTOR (9 downto 0);
           ADDR     : in STD_LOGIC_VECTOR (7 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component SP is
    Port ( RST      : in STD_LOGIC;
           LD       : in STD_LOGIC;
           INCR     : in STD_LOGIC;
           DECR     : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           DATA_IN  : in STD_LOGIC_VECTOR (7 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;
   -- declare intermediate signals here -----------
   -- these should match the signal names you hand drew on the diagram
signal PC_VAL, PC_C, SCR_OUT, SCR_IN : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
signal INSTR : STD_LOGIC_VECTOR (17 downto 0) := (others => '0');
signal REG_X, REG_Y, ALU_B, ALU_OUT, NEW_VAL, SP_OUT, 
        SCR_ADDR : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal SP_OM1 : STD_LOGIC_VECTOR (7 downto 0) := (SP_OUT - 1);
signal C_VAL, Z_VAL, C_FLG_IN, Z_FLG_IN, SHAD_C_OUT, SHAD_Z_OUT,
        I_SET, I_CLR, I_OUT, PC_LD, PC_INC, ALU_OPY_SEL, RF_WR, SP_LD,
        SP_INCR, SP_DECR, SCR_WE, SCR_DATA_SEL, FLG_C_SET, 
        FLG_C_CLR, FLG_C_LD, FLG_Z_LD, FLG_Z_CLR, FLG_LD_SEL, 
        FLG_SHAD_LD, C_FLAG, Z_FLAG, RST, IO_STROBE, INTER : STD_LOGIC := '0';
signal PC_MUX_SEL, RF_WR_SEL, SCR_ADDR_SEL : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
signal ALU_SEL : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

begin
    INTER <= INT and I_OUT;
    --begin your port map
    --remember to list all of the port names on the left and the signal they are being
    --ported to on the right.  Use the port map operator =>
carry_flag: Flag port map (
    LD          => FLG_C_LD,
    CLR         => FLG_C_CLR,
    CLK         => CLK,
    SET         => FLG_C_SET,
    DATA_IN     => C_FLG_IN,
    DATA_OUT    => C_FLAG);

zero_flag: Flag port map (
    LD          => FLG_Z_LD,
    CLR         => '0',
    CLK         => CLK,
    SET         => '0',
    DATA_IN     => Z_FLG_IN,
    DATA_OUT    => Z_FLAG);
    
shad_carry_flag: Flag port map (
    LD          => FLG_SHAD_LD,
    CLR         => '0',
    SET         => '0',
    CLK         => CLK,
    DATA_IN     => C_FLAG,
    DATA_OUT    => SHAD_C_OUT);
   
shad_zero_flag: Flag port map (
    LD          => FLG_SHAD_LD,
    CLR         => '0',
    SET         => '0',
    CLK         => CLK,
    DATA_IN     => Z_FLAG,
    DATA_OUT    => SHAD_Z_OUT);
    
interrupt_flag: Flag port map (
    LD          => '0',
    CLK         => CLK,
    CLR         => I_CLR,
    SET         => I_SET,
    DATA_IN     => '0',
    DATA_OUT    => I_OUT);
   
alu_port: ALU port map (
    CIN     => C_FLAG,
    A       => REG_X,
    B       => ALU_B,
    SEL     => ALU_SEL,
    C       => C_VAL,
    Z       => Z_VAL,
    RESULT  => ALU_OUT);
    
reg_file_port: REG_FILE port map (
    WR      => RF_WR,
    CLK     => CLK,
    DIN     => NEW_VAL,
    ADRX    => INSTR(12 downto 8),
    ADRY    => INSTR(7 downto 3),
    DX_OUT  => REG_X,
    DY_OUT  => REG_Y);
    
prog_rom_port: prog_rom port map (
    ADDRESS     => PC_C,
    INSTRUCTION => INSTR,
    CLK         => CLK);
    
pc_port: PC port map (
    RST         => RST,
    LD          => PC_LD,
    DIN         => PC_VAL,
    CLK         => CLK,
    INC         => PC_INC,
    PC_COUNT    => PC_C);
    
sp_port: SP port map (
    RST         => RST,
    LD          => SP_LD,
    INCR        => SP_INCR,
    DECR        => SP_DECR,
    DATA_IN     => REG_X,
    CLK         => CLK,
    DATA_OUT    => SP_OUT);
    
scr_port: SCR port map (
    DATA_IN     => SCR_IN,
    WE          => SCR_WE,
    ADDR        => SCR_ADDR,
    CLK         => CLK,
    DATA_OUT    => SCR_OUT);
    
control_unit_port: CONTROL_UNIT port map (
    CLK             => CLK,
    C               => C_FLAG,
    Z               => Z_FLAG,
    RESET           => RESET,
    OPCODE_HI_5     => INSTR(17 downto 13),
    OPCODE_LO_2     => INSTR(1 downto 0),
    PC_LD           => PC_LD,
    PC_INC          => PC_INC,
    PC_MUX_SEL      => PC_MUX_SEL,
    I_SET           => I_SET,
    I_CLR           => I_CLR,
    RF_WR           => RF_WR,
    RF_WR_SEL       => RF_WR_SEL,
    ALU_OPY_SEL     => ALU_OPY_SEL,
    ALU_SEL         => ALU_SEL,
    FLG_C_LD        => FLG_C_LD,
    FLG_C_SET       => FLG_C_SET,
    FLG_C_CLR       => FLG_C_CLR,
    FLG_Z_CLR       => FLG_Z_CLR,
    FLG_Z_LD        => FLG_Z_LD,
    FLG_LD_SEL      => FLG_LD_SEL,
    FLG_SHAD_LD     => FLG_SHAD_LD,
    SP_LD           => SP_LD,
    SP_INCR         => SP_INCR,
    SP_DECR         => SP_DECR,
    SCR_WE          => SCR_WE,
    SCR_ADDR_SEL    => SCR_ADDR_SEL,
    SCR_DATA_SEL    => SCR_DATA_SEL,
    RST             => RST,
    IO_STROBE       => IO_STROBE,
    INTER           => INTER);

OUT_PORT <= REG_X;
PORT_ID <= INSTR(7 downto 0);
IO_STRB <= IO_STROBE;

    --REG_MUX
    with RF_WR_SEL select
        NEW_VAL <= ALU_OUT when "00",
                   SCR_OUT(7 downto 0) when "01",
                   SP_OUT when "10",
                   IN_PORT when others;
    --ALU_MUX
    with ALU_OPY_SEL select
        ALU_B <= REG_Y when '0',
                 INSTR(7 downto 0) when others;
    --PC_MUX
    with PC_MUX_SEL select
        PC_VAL <= INSTR(12 downto 3) when "00",
                  SCR_OUT when "01",
                  "1111111111" when "10",
                  (others => '0') when others;
    --SCR_ADDR_MUX
    with SCR_ADDR_SEL select
        SCR_ADDR <= REG_Y when "00",
                    INSTR (7 downto 0) when "01",
                    SP_OUT when "10",
                    SP_OM1 when others;
    --SCR_IN_MUX
    with SCR_DATA_SEL select
        SCR_IN <= "00" & REG_X when '0',
                  PC_C when others;
    --Z_FLG_MUX
    with FLG_LD_SEL select
        Z_FLG_IN <= Z_VAL when '0',
                  SHAD_Z_OUT when others;

    --C_FLG_MUX
    with FLG_LD_SEL select
        C_FLG_IN <= C_VAL when '0',
                  SHAD_C_OUT when others;

end Behavioral;