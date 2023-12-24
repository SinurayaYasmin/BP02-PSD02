library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decoder is
    port (
        PRG_CNT : in integer; -- Program counter
        instruction : in std_logic_vector(6 downto 0); -- Instruction to be decoded
        opcode : out std_logic_vector(1 downto 0); -- Opcode for choose building type
        OP1_ADDR : out std_logic_vector(1 downto 0); -- select the first choice variable
        OP2_ADDR : out std_logic_vector(1 downto 0); -- select the second choice variable
        OP3_ADDR : out std_logic -- condition bit
    );
end entity Decoder;

architecture rtl of Decoder is
    
begin
    DEC_PROC : process(PRG_CNT)
    begin 
        -- Parse dan decode instruction according to Instruction Definition table
        opcode <= INSTRUCTION(6 downto 5);
        OP1_ADDR <= INSTRUCTION(4 downto 3);
        OP2_ADDR <= INSTRUCTION(2 downto 1);
        OP3_ADDR <= INSTRUCTION(0);
    end process;
end architecture rtl;