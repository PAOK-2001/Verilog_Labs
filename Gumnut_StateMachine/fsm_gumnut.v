module fsm_gumnut(
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
    output        int_ack

);
 // Partition of IR
  reg [17:0] IR;

  wire [ 2: 0] IR_alu_reg_fn;
  wire [16:14] IR_alu_immed_fn;
  wire [ 1: 0] IR_shift_fn;
  wire [15:14] IR_mem_fn;
  wire [11:10] IR_branch_fn;
  wire [12:12] IR_jump_fn;
  wire [10: 8] IR_misc_fn;

  wire [13:11] IR_rd;
  wire [10: 8] IR_rs;
  wire [ 7: 5] IR_r2;
  wire [ 7: 0] IR_immed;
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
 
  assign IR_decode_alu_immed = IR[17]    == 1'b0;
  assign IR_decode_mem       = IR[17:16] == 2'b10;
  assign IR_decode_shift     = IR[17:15] == 3'b110;
  assign IR_decode_alu_reg   = IR[17:14] == 4'b1110;
  assign IR_decode_jump      = IR[17:13] == 5'b11110;
  assign IR_decode_branch    = IR[17:12] == 6'b111110;
  assign IR_decode_misc      = IR[17:11] == 7'b1111110;

 
 // States of FSM
 parameter [2:0] fetch_state      = 3'b000,
                  decode_state     = 3'b001,
                  execute_state    = 3'b010,
                  mem_state        = 3'b011,
                  write_back_state = 3'b100,
                  int_state        = 3'b101;
  reg [2:0] state, next_state;


  always @(posedge clk_i or posedge rst_i) // state reg
    if (rst_i) state <= fetch_state;
    else       state <= next_state;

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

  
