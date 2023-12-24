# BP02-PSD02
Repository Github untuk project akhir PSD Kelompok BP02

# Program Description 
Proyek ini bertujuan untuk mengembangkan dan mengimplementasikan sistem berbasis FPGA untuk estimasi biaya konstruksi yang cepat dan akurat. Sistem akan dirancang untuk menghitung biaya konstruksi untuk 4 tipe bangunan, yaitu *commercial building, industrial building, infrastructure building, dan residential building*.

# Component Description
1. Decoder
   * Component Decoder berfungsi untuk me-*decode* *instruction* yang di-*input*, dan *output* dari component ini yaitu hasil *decode instruction* tersebut.
   *Instruction* terdiri dari 7 buah bit, dimana:

      *  Bit ke-0 akan di-*decode* sebagai **OP3_ADDR**
      *  Bit ke-1 dan 2 akan di-*decode* sebagai **OP2_ADDR**
      *  Bit ke-3 dan 4 akan di-*decode* sebagai **OP1_ADDR**
      *  Bit ke-5 dan 6 akan di-*decode* sebagai **opcode**
        
    * *Opcode* akan digunakan sebagai penentu *type building* apa yang akan dihitung biayanya.

2. Calculator
   * Component Calculator memiliki fungsi utama untuk melakukan perhitungan total biaya untuk tiap jenis bangunan. *Component* ini membutuhkan input berupa **PRG_CNT**(program counter), *opcode*, *operand-operand*, dan *cost* yang dibutuhkan. Sedangkan *output component* ini berupa hasil perhitungan total biaya yang dibutuhkan.
   Perhitungan biaya ditentukan dengan input *opcode*. Dimana :

      * Opcode 00 untuk *industrial building*
      * Opcode 01 untuk *residential building*
      * Opcode 10 untuk *commercial building*
      * Opcode 11 untuk *infrastructure building*

4. CostPlanner
   * Component CostPlanner berfungsi sebagai **main program**, karena *component* lain seperti **Calculator** dan **Decoder** digunakan di *component* ini. Di dalam *component* ini terdapat 5 buah *state* untuk menentukan proses apa yang sedang dilakukan oleh program. Berikut penjelasan dari setiap *state*:
     * State **IDLE** artinya program akan menunggu hingga enable bernilai 1.
     * State **FETCH** artinya program akan menerima *instruction input* dan *program counter* bertambah 1.
     * State **DECODE** artinya program memberikan parameter-parameter yang dibutuhkan oleh *component* **Decode** untuk melakukan *decoding* pada *instrcution input*.
     * State **EXECUTE** artinya program akan memberikan parameter-parameter yang dibutuhkan oleh *component* **Calculator** untuk melakukan perhitungan terhadap biaya pembangunan.
     * State **COMPLETE** artinya program sudah selesai melakukan perhitungan.
       
   * Alur program ini dimulai dari state IDLE -> FETCH -> DECODE -> EXECUTE -> COMPLETE.

# Modul Description
Berikut adalah penjelasan untuk penerapan tiap modul pada program ini :
* Modul 2 (Dataflow Style Programming In VHDL)
    * Menggunakan *conditional signal assignment* dan *selected signal assignment* selama proses perhitungan biaya. *Conditional signal assignment* **(if-else)** digunakan di dalam *function* perhitungan biaya, dan *selected signal assignment* **(switch-case)** digunakan pada kondisi state program.
    * Contoh Code:
      ```VHDL
      --Conditional Signal Assignment
        if regulations_bit = '1' then
            return safety_regulations_cost;
         else
            return 0;
        end if;

      --Selected Signal Assignment
      case opcode is
            when "01" => -- Residential
               -- Rest of Code
            when "10" => -- Commercial
                --Rest of Code
            when "00" => -- Industrial
                --Rest of Code
            when "11" => -- Infrastructure
             --Rest of Code
            when others =>
                --Rest of Code
            end case;
      ```
      
* Modul 3 (Behavioral Style Programming In VHDL)
    * Menggunakan *process*. Salah satu contoh penerapan process yaitu pada *component* **CostPlanner**, *process* ini memiliki *sensitivity list* berupa **CPU_CLK**. *Process* ini akan melakukan execution ketika **CPU_CLK** sedang *rising edge*.
    * Contoh Code:
      ```VHDL
          process (CPU_CLK)
          begin
            if rising_edge(CPU_CLK) then
              -- Rest of code
            end if;
          end process;```

* Modul 4 (TestBench)
    * Menggunakan testbench untuk melakukan pengujian terhadap program.
* Modul 5 (Structural Style Programming In VHDL)
    * Menggunakan *component* **Decoder** dan **Calculator**, dan menggunakan *portmap* pada **CostPlanner** untuk menghubungkan *component* **Decoder** dan **Calculator** agar dapat digunakan.
    * Contoh Code:
      ```VHDL
          --Memanggil Component Decoder
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
      
          --Menggunakan Port Map
          DEC : Decoder port map (counter, instruction_input, opcode, OP1_ADDR, OP2_ADDR, OP3_ADDR);
          CALC : Calculator port map (counter, opcode_input, operand1_input, operand2_input, operand3_input, cost1, cost2, cost3, cost4, biaya);
      ```
* Modul 7 (Procedure, Function, and Impure Function)
    * Menggunakan *function* di dalam *component* **Calculator**. Salah satu contoh penggunaan *function* yaitu *function* bernama **ApplySafetyCost**. *Function* tersebut berfungsi untuk menentukan apakah *user* ingin menggunakan *safety* lebih atau tidak, jika iya maka akan dikenakan biaya tambahan untuk *safety cost*.
    * Contoh Code:
      ```VHDL
      function ApplySafetyCost(regulations_bit: std_logic) return integer is
      begin
        if regulations_bit = '1' then
            return safety_regulations_cost;
         else
            return 0;
        end if;
      end function ApplySafetyCost;
      ```
* Modul 8 (Finite State Machine)
    * Menggunakan 5 *state* di dalam *component* **CostPlanner** sebagai penentu instruksi apa yang sedang dilakukan oleh program. 5 *state* yang digunakan yaitu IDLE, FETCH, DECODE, EXECUTE, dan COMPLETE.
    * Contoh Code:
      ```VHDL
          case state is 
                -- When idle state, wait for enable to 1
                when IDLE =>
                    if enable = '1' then 
                        state <= FETCH;
                        counter <= 0;
                    else 
                        state <= IDLE;
                    end if;
    
                -- When fetch, receive instruction input
                when FETCH =>
                    counter <= counter + 1;
                    if counter = 1 then
                        state <= DECODE;
                    end if;
    
                -- When decode, pass arguments to decoder component
                when DECODE =>
                    counter <= counter + 1;
                    instruction_input <= instruction;
                    if counter = 2 then
                        state <= EXECUTE;
                    end if;

                When EXECUTE =>
                    counter <= counter + 1;
                    opcode_input <= opcode;
                    operand1_input <= OP1_ADDR;
                    operand2_input <= OP2_ADDR;
                    operand3_input <= OP3_ADDR;
                    if counter = 3 then
                        state <= COMPLETE;
                    end if;
    
                When COMPLETE =>
                    report "Instruction complete";
                    state <= IDLE;
            end case;
      ```
* Modul 9 (Microprogramming)
    * Menggunakan *component* dan input dalam bentuk *opcode*. *Opcode* ini yang akan menentukan tipe bangunan apa yang diinginkan, dan *operand* apa saja yang akan digunakan sesuai dengan tipe bangunannya. Penentuan *opcode* ini sesuai dengan hasil *decode* dari *instruction input* yang diberikan.
    * Contoh Code:
      ```VHDL
      --Proses Decode Instruction Input
      DEC_PROC : process(PRG_CNT)
      begin 
        -- Parse dan decode instruction according to Instruction Definition table
        opcode <= INSTRUCTION(6 downto 5);
        OP1_ADDR <= INSTRUCTION(4 downto 3);
        OP2_ADDR <= INSTRUCTION(2 downto 1);
        OP3_ADDR <= INSTRUCTION(0);
      end process;

      --Process Perhitungan Biaya Berdasarkan Opcode
      case opcode is
            when "01" => -- Residential
                biaya <= (cost1 * unit_cost_per_floor) +
                        (cost2 * land_cost_per_sqm) +
                        (cost1 * cost2 * cost_per_sqm_materials(index_fasilitas)) +
                        amenities_cost(index_material);
            when "10" => -- Commercial
                biaya <= (cost1 * land_cost_per_sqm) +
                        (cost2 * cost3 * unit_cost_per_sqm) +
                        ApplyComplianceCost(operand3);
            when "00" => -- Industrial
                biaya <= (cost1 * unit_cost_per_unit(index_unit)) +
                        (cost2 * unit_cost_per_sqm_industrial) + (cost3 * equipment_cost(index_equipment))
                         + ApplySafetyCost(operand3);
            when "11" => -- Infrastructure
                biaya <= (cost1 * (cost2 + cost3)) + CalculateCost(operand3);
            when others =>
                biaya <= 0; -- Invalid opcode
      ```
      * Table Hasil Decoding:
          * | Bit ke 6 dan 5 | Bit ke 4 dan 3 | Bit ke 2 dan 1 |     Bit ke 0    |
            | ---------------|----------------|----------------|-----------------|
            | Opcode untuk   | Variabel       | Variabel       | Conditional bit |
            | memilih tipe   | Pilihan        | Pilihan        | penggunaan harga|
            | building       | Pertama        | Kedua          | tambahan        |

