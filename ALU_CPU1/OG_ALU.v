module gumnut( 
	 input clk_i,
    input rst_i,
    // Instruction memory bus 
    output        inst_cyc_o,
    output        inst_stb_o,
    input         inst_ack_i,
    output [11:0] inst_adr_o,
    input  [17:0] inst_dat_i,
    // Data memory bus
    output        data_cyc_o,
    output        data_stb_o,
    output        data_we_o,
    input         data_ack_i,
    output  [7:0] data_adr_o,
    output  [7:0] data_dat_o,
    input   [7:0] data_dat_i,
    // I/O port bus
    output        port_cyc_o,
    output        port_stb_o,
    output        port_we_o,
    input         port_ack_i,
    output  [7:0] port_adr_o,
    output  [7:0] port_dat_o,
    input   [7:0] port_dat_i,
    // Interrupts
    input         int_req,
    output        int_ack );
	 
  parameter debug = 1'b0;
  // Constantes que definen que tipo de operacion a realizar
  localparam [2:0] alu_fn_or   = 3'b101;
  localparam [2:0] alu_fn_xor  = 3'b110;
  localparam [2:0] alu_fn_mask = 3'b111;

  localparam [1:0] shift_fn_shl = 2'b00;
  localparam [1:0] shift_fn_shr = 2'b01;
  localparam [1:0] shift_fn_rol = 2'b10;
  localparam [1:0] shift_fn_ror = 2'b11;
  
  localparam [1:0] mem_fn_ldm = 2'b00;
  localparam [1:0] mem_fn_stm = 2'b01;
  localparam [1:0] mem_fn_inp = 2'b10;
  localparam [1:0] mem_fn_out = 2'b11;

  localparam [1:0] branch_fn_bz  = 2'b00;
  localparam [1:0] branch_fn_bnz = 2'b01;
  localparam [1:0] branch_fn_bc  = 2'b10;
  localparam [1:0] branch_fn_bnc = 2'b11;

  localparam [0:0] jump_fn_jmp = 1'b0;
  localparam [0:0] jump_fn_jsb = 1'b1;

  localparam [2:0] misc_fn_ret  	  = 3'b000;
  localparam [2:0] misc_fn_reti 	  = 3'b001;
  localparam [2:0] misc_fn_enai 	  = 3'b010;
  localparam [2:0] misc_fn_disi 	  = 3'b011;
  localparam [2:0] misc_fn_wait 	  = 3'b100;
  localparam [2:0] misc_fn_stby 	  = 3'b101;
  localparam [2:0] misc_fn_undef_6 = 3'b110;
  localparam [2:0] misc_fn_undef_7 = 3'b111;

  reg [11:0] PC;

  reg branch_taken;

  reg [17:0] IR; // Registro e instrucciones
  // Las siguiente declaraciones dice que parte del registro corresponde a ciertas operaciones
  
  wire [ 2: 0] IR_alu_reg_fn;   // Operacion code: operacion a ejecutar (para operaciones normales)
  wire [16:14] IR_alu_immed_fn; // Inmediate Operation code 
  wire [ 1: 0] IR_shift_fn;     // Indica el tipo de shifting a hacer
  wire [15:14] IR_mem_fn;
  wire [11:10] IR_branch_fn;
  wire [12:12] IR_jump_fn;
  wire [10: 8] IR_misc_fn;

  wire [13:11] IR_rd;
  wire [10: 8] IR_rs;
  wire [ 7: 5] IR_r2;
  wire [ 7: 0] IR_immed; // Right operand en instruccion inmedieta ie r2 = r3 + 2
  wire [ 7: 5] IR_count;
  wire [ 7: 0] IR_offset;
  wire [ 7: 0] IR_disp;
  wire [11: 0] IR_addr;
  
  wire IR_decode_alu_immed;
  wire IR_decode_mem;
  wire IR_decode_shift;
  wire IR_decode_alu_reg;
  wire IR_decode_jump;
  wire IR_decode_branch;
  wire IR_decode_misc;

  wire data_state;
  wire port_state;

  reg [11:0] int_PC;
  reg int_Z;
  reg int_C;
  reg int_en;

  localparam SP_length = 3;
  reg [SP_length - 1:0] SP;
  reg [11:0] stack_top;

  localparam stack_depth = 2**SP_length;
  reg [11:0] stack [0:stack_depth - 1];

  //Los registros de proposito general para almacenar valores
  reg [3:0] GPR_r2_addr;
  reg [7:0] GPR_write_data;
  reg [7:0] GPR [0:7];

  reg [7:0] GPR_rs;
  reg [7:0] GPR_r2; //segundo registro de proposito general, siempre funge como el "right operand" de ALU
  
 // Registros temporales para guardar valores de la ALU
  reg [2:0] ALU_fn;
  reg [7:0] ALU_right_operand;
  reg [8:0] ALU_tmp_result;
  reg [7:0] ALU_shift_result;

  reg  [7:0] ALU_result;
  wire ALU_Z; // Flag que dice si el resultado de la ALU es 0
  reg  ALU_C; // Flag que dice si hay un Carry Out
  reg  [7:0] ALU_out;

  reg cc_Z; // 0
  reg cc_C;// Carry Out

  reg [7:0] data_D;
  reg [7:0] port_D;
  
  parameter [2:0] fetch_state      = 3'b000,
                  decode_state     = 3'b001,
                  execute_state    = 3'b010,
                  mem_state        = 3'b011,
                  write_back_state = 3'b100,
                  int_state        = 3'b101;
  reg [2:0] state, next_state;

  assign IR_alu_reg_fn   = IR[2:0];
  assign IR_alu_immed_fn = IR[16:14];
  assign IR_shift_fn     = IR[1:0];
  assign IR_mem_fn       = IR[15:14];
  assign IR_branch_fn    = IR[11:10];
  assign IR_jump_fn      = IR[12:12];
  assign IR_misc_fn      = IR[10:8];

  assign IR_rd     = IR[13:11];
  assign IR_rs     = IR[10:8];
  assign IR_r2     = IR[7:5];
  assign IR_immed  = IR[7:0];
  assign IR_count  = IR[7:5];
  assign IR_offset = IR[7:0];
  assign IR_disp   = IR[7:0];
  assign IR_addr   = IR[11:0];
  // Flags que indican si cierta operacion esta presente en el IR
  assign IR_decode_alu_immed = IR[17]    == 1'b0;    // operacion INMEDIATA
  assign IR_decode_mem       = IR[17:16] == 2'b10;   // operacion de memoria
  assign IR_decode_shift     = IR[17:15] == 3'b110;  // operacion de shfiting
  assign IR_decode_alu_reg   = IR[17:14] == 4'b1110; // operacion de ALU_reg
  assign IR_decode_jump      = IR[17:13] == 5'b11110;
  assign IR_decode_branch    = IR[17:12] == 6'b111110;
  assign IR_decode_misc      = IR[17:11] == 7'b1111110;

  always @*  // next state logic
    case (state)
      fetch_state:
        if (!inst_ack_i) next_state = fetch_state;
        else             next_state = decode_state;
      decode_state:
        if (IR_decode_branch || IR_decode_jump || IR_decode_misc) begin
          if (IR_decode_misc
            && (IR_misc_fn == misc_fn_wait || IR_misc_fn == misc_fn_stby)
            && !(int_en && int_req))
            next_state = decode_state;
          else if (int_en && int_req)
            next_state = int_state;
          else
            next_state = fetch_state;
        end
        else
          next_state = execute_state;
      execute_state:
        if (IR_decode_mem) begin
          if ((IR_mem_fn == mem_fn_ldm || IR_mem_fn == mem_fn_stm)
              && !data_ack_i)
            next_state = mem_state;
          else if ((IR_mem_fn == mem_fn_inp || IR_mem_fn == mem_fn_out)
                   && !port_ack_i)
            next_state = mem_state;
          else if (IR_mem_fn == mem_fn_ldm || IR_mem_fn == mem_fn_inp)
            next_state = write_back_state;
          else if (int_en && int_req)
            next_state = int_state;
          else
            next_state = fetch_state;
        end
        else
          next_state = write_back_state;
      mem_state:
        if ((IR_mem_fn == mem_fn_ldm || IR_mem_fn == mem_fn_stm)
            && !data_ack_i)
          next_state = mem_state;
        else if ((IR_mem_fn == mem_fn_inp || IR_mem_fn == mem_fn_out)
                 && !port_ack_i)
          next_state = mem_state;
        else if (IR_mem_fn == mem_fn_ldm || IR_mem_fn == mem_fn_inp)
          next_state = write_back_state;
        else if (int_en && int_req)
            next_state = int_state;
        else
          next_state = fetch_state;
      write_back_state:
        if (int_en && int_req) next_state = int_state;
        else                   next_state = fetch_state;
      int_state:
        next_state = fetch_state;
    endcase

  always @(posedge clk_i or posedge rst_i) // state reg
    if (rst_i) state <= fetch_state;
    else       state <= next_state;

  always @*
    case (IR_branch_fn)
      branch_fn_bz:  branch_taken = cc_Z;
      branch_fn_bnz: branch_taken = !cc_Z;
      branch_fn_bc:  branch_taken = cc_C;
      branch_fn_bnc: branch_taken = !cc_C;
    endcase

  always @(posedge clk_i or posedge rst_i) // PC reg
    if (rst_i)
      PC <= 0;
    else if (state == fetch_state && inst_ack_i)
      PC <= PC + 1;
    else if (state == decode_state) begin
      if (IR_decode_branch && branch_taken)
        PC <= $unsigned($signed(PC) + $signed(IR_disp));
      else if (IR_decode_jump)
        PC <= IR_addr;
      else if (IR_decode_misc && IR_misc_fn == misc_fn_ret)
        PC <= stack_top;
      else if (IR_decode_misc && IR_misc_fn == misc_fn_reti)
        PC <= int_PC;
    end
    else if (state == int_state)
      PC <= 1;

  assign int_ack = state == int_state;

  always @(posedge clk_i or posedge rst_i) // interrupt reg
    if (rst_i)
      int_en <= 1'b0;shfiting