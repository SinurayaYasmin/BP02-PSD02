library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CostPlanner is
    port (
        CPU_CLK : in std_logic; 
        enable : in std_logic; 
        instruction : in std_logic_vector(6 downto 0); -- Instruction to be decoded
        Var1: in integer;
        Var2: in integer;
        Var3: in integer;
        biaya: out integer
    );
end entity CostPlanner;

architecture rtl of CostPlanner is
    component Decoder is
        port (
            PRG_CNT : in integer; -- Program counter
            instruction : in std_logic_vector(6 downto 0); -- Instruction to be decoded
            opcode : out std_logic_vector(1 downto 0); -- Opcode 
            OP1_ADDR : out std_logic_vector(1 downto 0); 
            OP2_ADDR : out std_logic_vector(1 downto 0); 
            OP3_ADDR : out std_logic
        );
    end component;

    component Calculator is
        port (
            PRG_CNT : in integer; -- Program counter
            opcode : in std_logic_vector (1 downto 0); -- Opcode of instruction 
            operand1 : in std_logic_vector (1 downto 0);
            operand2 : in std_logic_vector (1 downto 0); 
            operand3 : in std_logic;
            Var1: in integer;
            Var2: in integer;
            Var3: in integer;
            biaya: out integer
        );
    end component;

    signal instruction_in : std_logic_vector(6 downto 0);
    signal opcode : std_logic_vector(1 downto 0);
    signal OP1_ADDR : std_logic_vector(1 downto 0);
    signal OP2_ADDR : std_logic_vector(1 downto 0);
    signal OP3_ADDR : std_logic;
    signal opcode_input : std_logic_vector(1 downto 0);
    signal operand1_input : std_logic_vector(1 downto 0);
    signal operand2_input : std_logic_vector(1 downto 0);
    signal operand3_input : std_logic;
    
    TYPE stateType IS (IDLE, FETCH, DECODE, EXECUTE, COMPLETE);

    signal state : stateType := IDLE;
    
    signal counter : integer := 0;
begin
    DEC : Decoder port map (counter, instruction_in, opcode, OP1_ADDR, OP2_ADDR, OP3_ADDR);
    CALC : Calculator port map (counter, opcode_input, operand1_input, operand2_input, operand3_input, Var1, Var2, Var3, biaya);
    process (CPU_CLK)
    begin
        if rising_edge(CPU_CLK) then
            case state is 
                -- When idle state, wait for enable to 1
                when IDLE =>
                    if enable = '1' then 
                        state <= FETCH;
                        counter <= 0;
                    end if;
    
                -- When fetch, receive instruction input
                when FETCH =>
                    counter <= counter + 1;
                    if counter = 1 then
                        state <= DECODE;
                    end if;
    
                -- When decode, pass arguments to decoder component
                when DECODE =>
                    instruction_in <= instruction; 
                    counter <= counter + 1;
                    if counter = 2 then
                        state <= EXECUTE;
                    end if;
    
                When EXECUTE =>
                    opcode_input <= opcode;
                    operand1_input <= OP1_ADDR;
                    operand2_input <= OP2_ADDR;
                    operand3_input <= OP3_ADDR;
                    counter <= counter + 1;
                    if counter = 3 then
                        state <= COMPLETE;
                    end if;
    
                When COMPLETE =>
                    report "Instruction complete";
                    state <= IDLE;
            end case;
        end if;
    end process;
end architecture rtl;