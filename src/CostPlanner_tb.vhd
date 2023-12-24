library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CostPlanner_tb is
end entity CostPlanner_tb;

architecture tb_arch of CostPlanner_tb is
    -- Constants and signals for testbench
    constant CLK_PERIOD : time := 10 ns; -- Define clock period
    signal CPU_CLK_tb : std_logic := '0';
    signal enable_tb : std_logic := '0';
    signal instruction_tb : std_logic_vector(6 downto 0) := (others => '0');
    signal Var1_tb, Var2_tb, Var3_tb : integer := 0;
    signal biaya_tb : integer;
    
    -- Instantiate the CostPlanner entity
    component CostPlanner is
        port (
            CPU_CLK : in std_logic;
            enable : in std_logic;
            instruction : in std_logic_vector(6 downto 0);
            Var1 : in integer;
            Var2 : in integer;
            Var3 : in integer;
            biaya : out integer
        );
    end component;

begin
    -- Clock process
    process
    begin
        while now < 100 ns loop -- Simulate for 100 ns
            CPU_CLK_tb <= not CPU_CLK_tb; -- Toggle clock
            wait for CLK_PERIOD / 2; -- Wait half a clock period
        end loop;
        wait; -- End simulation
    end process;

    -- Instantiate the CostPlanner entity
    UUT: CostPlanner
    port map (
        CPU_CLK => CPU_CLK_tb,
        enable => enable_tb,
        instruction => instruction_tb,
        Var1 => Var1_tb,
        Var2 => Var2_tb,
        Var3 => Var3_tb,
        biaya => biaya_tb
    );

    -- Stimulus process
    stimulus : process
        constant period: time := 10 ns;
        begin
            -- Initialize inputs
            enable_tb <= '1';
            instruction_tb <= "0010011"; -- Set an example instruction
            Var1_tb <= 10; -- production capacity
            Var2_tb <= 200; -- bulding area
            Var3_tb <= 5; -- equipment quantity
            wait for period;

            enable_tb <= '1';
            instruction_tb <= "0111000"; -- Set an example instruction
            Var1_tb <= 3; -- tingkat bangunan
            Var2_tb <= 200; -- luas tanah
            Var3_tb <= 0; -- dont care
            wait for period;

            enable_tb <= '1';
            instruction_tb <= "1011010"; -- Set an example instruction
            Var1_tb <= 200; -- luas tanah
            Var2_tb <= 10; -- area per customer
            Var3_tb <= 20; -- jumlah customer
            wait for period;

            enable_tb <= '1';
            instruction_tb <= "1100111"; -- Set an example instruction
            Var1_tb <= 500; -- project length
            Var2_tb <= 70; -- unit cost per meter
            Var3_tb <= 100; -- material cost
            wait for period;
            wait; -- End simulation
    end process;

end architecture tb_arch;