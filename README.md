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
      * Opcode 00 untuk industrial building
      * Opcode 01 untuk residential building
      * Opcode 10 untuk commercial building
      * Opcode 11 untuk infrastructure building

4. CostPlanner
   * Component CostPlanner berfungsi sebagai **main program**, karena *component* lain seperti **Calculator** dan **Decoder** digunakan di *component* ini. Di dalam *component* ini terdapat 5 buah *state* untuk menentukan proses apa yang sedang dilakukan oleh program. Berikut penjelasan dari setiap *state*:
     * State **IDLE** artinya program akan menunggu hingga enable bernilai 1.
     * State FETCH artinya program akan menerima instruction input dan program counter bertambah 1.
     * State DECODE artinya program memberikan parameter-parameter yang dibutuhkan oleh component Decode untuk melakukan decoding pada instrcution input.
     * State EXECUTE artinya program akan memberikan parameter-parameter yang dibutuhkan oleh component Calculator untuk melakukan perhitungan terhadap biaya pembangunan.
     * State COMPLETE artinya program sudah selesai melakukan perhitungan.
   * Alur program ini dimulai dari state IDLE -> FETCH -> DECODE -> EXECUTE -> COMPLETE.

# Modul Description
Berikut adalah penjelasan untuk penerapan tiap modul pada program ini :
* Modul 3 (Behavioral Style Programming In VHDL)
    * Menggunakan *process*. Salah satu contoh penerapan process yaitu pada *component* **CostPlanner**, *process* ini memiliki *sensitivity list* berupa **CPU_CLK**. *Process* ini akan melakukan execution ketika **CPU_CLK** sedang *rising edge*.
    * Contoh Code:
      ```python
          def hello_world():
          Sprint("Hello, World!")```

* Modul 4 (TestBench)
    * Menggunakan testbench untuk melakukan pengujian terhadap program.
* Modul 5 (Structural Style Programming In VHDL)
    * Menggunakan *component* **Decoder** dan **Calculator**, dan menggunakan *portmap* pada **CostPlanner** untuk menghubungkan *component* **Decoder** dan **Calculator** agar dapat digunakan.
* Modul 6 (Looping Construct)
    * Menggunakan looping dalam perhitungan biaya.
* Modul 7 (Procedure, Function, and Impure Function)
    * Menggunakan *function* di dalam *component* **Calculator**. Salah satu contoh penggunaan *function* yaitu *function* bernama **ApplySafetyCost**. *Function* tersebut berfungsi untuk menentukan apakah *user* ingin menggunakan *safety* lebih atau tidak, jika iya maka akan dikenakan biaya tambahan untuk *safety cost*.
* Modul 8 (Finite State Machine)
    * Menggunakan 5 *state* di dalam *component* **CostPlanner** sebagai penentu instruksi apa yang sedang dilakukan oleh program. 5 *state* yang digunakan yaitu IDLE, FETCH, DECODE, EXECUTE, dan COMPLETE.
* Modul 9 (Microprogramming)
    * Menggunakan *component* dan input dalam bentuk *opcode*. *Opcode* ini yang akan menentukan tipe bangunan apa yang diinginkan, dan *operand* apa saja yang akan digunakan sesuai dengan tipe bangunannya. 
   

