library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Calculator is
    port (
        PRG_CNT : in integer; -- Program counter
        opcode : in std_logic_vector (1 downto 0); -- Opcode for choose building type
        operand1 : in std_logic_vector (1 downto 0); -- select the first choice variable
        operand2 : in std_logic_vector (1 downto 0); -- select the second choice variable
        operand3 : in std_logic; -- condition bit
        Var1: in integer;
        Var2: in integer;
        Var3: in integer;
        biaya: out integer
    );
end entity Calculator;

architecture rtl of Calculator is
    -- Constants and variables for Industrial
    constant unit_cost_per_sqm_industrial: integer := 800;
    constant safety_regulations_cost: integer := 42000;
    type Array1 is array (0 to 3) of integer;
    constant unit_cost_per_unit: Array1 := (60, 70, 80, 90); -- kualitas unit untuk produksi
    type Array2 is array (0 to 3) of integer;
    constant equipment_cost: Array2 := (755, 1000, 12000, 20000); -- harga tipe alat yanag berbeda (light, medium, heavy, super)

    -- Constants and variables for Residential
    constant unit_cost_per_floor: integer := 1000;
    constant land_cost_per_sqm: integer := 300;
    type Array3 is array(0 to 3) of integer;
    constant cost_per_sqm_materials: Array3 := (6, 15, 19, 31); -- tipe material lantai (vynil, kayu, keramik, granit)
    type Array4 is array(0 to 3) of integer;
    constant amenities_cost: Array4 := (1000, 500, 300, 5000); -- biaya tambahan (halaman, garasi, sumur, kolam)
    
    -- Constants and variables for Commercial
    constant unit_cost_per_sqm: integer := 300;
    constant compliance_cost: integer := 40000;
    type Array5 is array(0 to 3) of integer;
    constant commercial_amenities: Array5 := (800, 1200, 1500, 500); -- tambahan (billboard, patung commercial, tempat parkir, storage room)

    -- Constants and variables for Infrastructure
    constant environmental_impact_multiplier: integer := 2;
    type Array6 is array(0 to 3) of integer;
    constant complexity_multiplier: Array6 := (10, 11, 15, 17); -- kompleksitas simple, advance, complex, high risk
    type Array7 is array(0 to 3) of integer;
    constant contingency_allowance_multiplier: Array7 := (0, 5, 10, 15);  -- persentase biaya cadangan jika terjadi sesuatu diluar perencanaan awal
    
    function CalculateCost(impact: std_logic) return integer is
    begin
        if impact = '1' then
            return environmental_impact_multiplier;
        else
            return 1;
        end if;
    end function;

    -- function for condition bit industrial and commercial
    function ApplyCost(features_bit: std_logic; Var: integer) return integer is
    begin
        if features_bit = '1' then
            return Var;
        else
            return 0;
        end if;
    end function ApplyCost;
    
begin
    alu_proc : process(PRG_CNT, operand1, operand2)
    begin
        case opcode is
            when "00" => -- Industrial
                biaya <= (Var1 * unit_cost_per_unit(to_integer(unsigned(operand1)))) +
                        (Var2 * unit_cost_per_sqm_industrial) +
                        (Var3 * equipment_cost(to_integer(unsigned(operand2)))) + 
                        ApplyCost(operand3, safety_regulations_cost);
            when "01" => -- Residential
                biaya <= (Var1 * unit_cost_per_floor) +
                        (Var2 * land_cost_per_sqm) +
                        (Var1 * Var2 * cost_per_sqm_materials(to_integer(unsigned(operand1)))) +
                        amenities_cost(to_integer(unsigned(operand2)));
            when "10" => -- Commercial
                biaya <= (Var1 * (land_cost_per_sqm + cost_per_sqm_materials(to_integer(unsigned(operand1))))) +
                        (Var2 * Var3 * unit_cost_per_sqm) + commercial_amenities(to_integer(unsigned(operand2))) + 
                        ApplyCost(operand3, compliance_cost);
            when "11" => -- Infrastructure
                biaya <= ((Var1 * ((Var2 * complexity_multiplier(to_integer(unsigned(operand1))) / 10) + Var3)) * 
                        CalculateCost(operand3) * contingency_allowance_multiplier(to_integer(unsigned(operand2))) / 100);
            when others =>
                biaya <= 0; -- Invalid opcode
        end case;
    end process;
end architecture rtl;