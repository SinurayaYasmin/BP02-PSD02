# BP02-PSD02
Repository Github untuk project akhir PSD Kelompok BP02

# Program Description 
Proyek ini bertujuan untuk mengembangkan dan mengimplementasikan sistem berbasis FPGA untuk estimasi biaya konstruksi yang cepat dan akurat. Sistem akan dirancang untuk menghitung biaya konstruksi untuk 4 tipe bangunan, yaitu commercial building, industrial building, infrastructure building, dan residential building.

# Component Description
1. Decoder
   * Component Decoder berfungsi untuk me-decode instruction yang diinput, dan output dari component ini yaitu hasil decode instruction tersebut.
   Instruction terdiri dari 7 buah bit, dimana bit ke-0 akan di-decode sebagai OP3_ADDR, bit ke-1 dan 2 akan di-decode sebagai OP2_ADDR, bit ke-3 dan 4 akan di-decode sebagai OP1_ADDR, dan bit ke-5 dan 6 akan di-decode sebagai opcode. Opcode akan digunakan sebagai penentu type building apa yang akan dihitung biayanya.

2. Calculator
   * Component Calculator memiliki fungsi utama untuk melakukan perhitungan total biaya untuk tiap jenis bangunan. Component ini membutuhkan input berupa PRG_CNT(program counter), opcode, operand-operand, dan cost yang dibutuhkan. Sedangkan output component ini berupa hasil perhitungan total biaya yang dibutuhkan.
   Perhitungan biaya ditentukan dengan input opcode. Dimana :
      * Opcode 00 untuk industrial building
      * Opcode 01 untuk residential building
      * Opcode 10 untuk commercial building
      * Opcode 11 untuk infrastructure building

4. CostPlanner
   Component CostPlanner berfungsi sebagai 'main program', karena component lain seperti Calculator dan Decoder digunakan di component ini. Di dalam component ini terdapat 5 buah state untuk menentukan proses apa yang sedang dilakukan oleh program. State IDLE artinya program akan menunggu hingga enable bernilai 1. State FETCH artinya program akan menerima instruction input dan program counter bertambah 1. State DECODE artinya program memberikan parameter-parameter yang dibutuhkan oleh component Decode untuk melakukan decoding pada instrcution input. State EXECUTE artinya program akan memberikan parameter-parameter yang dibutuhkan oleh component Calculator untuk melakukan perhitungan terhadap biaya pembangunan. State COMPLETE artinya program sudah selesai melakukan perhitungan.
   Alur program ini dimulai dari state IDLE -> FETCH -> DECODE -> EXECUTE -> COMPLETE.

# Modul Description
Berikut adalah penjelasan untuk penerapan tiap modul pada program ini :
1. Modul 3 (Behavioral Style Programming In VHDL) : Menggunakan process. Salah satu contoh penerapan process yaitu pada component CostPlanner, process ini memiliki sensitivity list berupa CPU_CLK. Process ini akan melakukan execution ketika CPU_CLK sedang rising_edge.
2. Modul 4
3. Modul 5
4. Modul 6
5. Modul 7
6. Modul 8
7. Modul 9
   

