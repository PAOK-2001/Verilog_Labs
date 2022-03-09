module ALU_Gumnut( 
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
	 // Interrupts
	 input         int_req,
	 output        int_ack );
	 
parameter debug = 1'b0;
localparam [2:0] alu_fn_add  = 3'b000;
localparam [2:0] alu_fn_addc = 3'b001;
localparam [2:0] alu_fn_sub  = 3'b010;
localparam [2:0] alu_fn_subc = 3'b011;
localparam [2:0] alu_fn_and  = 3'b100;
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

reg [3:0] GPR_r2_addr;
reg [7:0] GPR_write_data;
reg [7:0] GPR [0:7];

reg [7:0] GPR_rs;
reg [7:0] GPR_r2;

reg [2:0] ALU_fn;
reg [7:0] ALU_right_operand;
reg [8:0] ALU_tmp_result;
reg [7:0] ALU_shift_result;

reg  [7:0] ALU_result;
wire ALU_Z;
reg  ALU_C;
reg  [7:0] ALU_out;

reg cc_Z;
reg cc_C;

// Logic to assign operation given the first four bits of the instruction	 
  always @*  // ALU
    if (IR_decode_alu_reg || IR_decode_alu_immed || IR_decode_mem) begin
      if (IR_decode_alu_reg) begin 
        ALU_fn = IR_alu_reg_fn;
        ALU_right_operand = GPR_r2;
      end
      else if (IR_decode_alu_immed) begin
        ALU_fn = IR_alu_immed_fn;
        ALU_right_operand = IR_immed;
      end
      else begin
        ALU_fn = alu_fn_add;
        ALU_right_operand = IR_offset;
      end
      case (ALU_fn)
        alu_fn_add:
          ALU_tmp_result = GPR_rs + ALU_right_operand;
        alu_fn_addc:
          ALU_tmp_result = GPR_rs + ALU_right_operand + cc_C;
        alu_fn_sub:
          ALU_tmp_result = GPR_rs - ALU_right_operand;
        alu_fn_subc:
          ALU_tmp_result = GPR_rs - ALU_right_operand - cc_C;
        alu_fn_and:
          ALU_tmp_result = GPR_rs & ALU_right_operand;
        alu_fn_or:
          ALU_tmp_result = GPR_rs | ALU_right_operand;
        alu_fn_xor:
          ALU_tmp_result = GPR_rs ^ ALU_right_operand;
        alu_fn_mask:
          ALU_tmp_result = GPR_rs & ~ALU_right_operand;
      endcase
      ALU_result = ALU_tmp_result[7:0];
      ALU_C = ALU_tmp_result[8];
    end
    else begin
      case (IR_shift_fn)
        shift_fn_shl:
	  begin
            ALU_tmp_result = GPR_rs << IR_count;
            ALU_shift_result = ALU_tmp_result[7:0];
            ALU_C = ALU_tmp_result[8];
	  end
        shift_fn_shr:
	  begin
            ALU_tmp_result = {GPR_rs, 1'b0} >> IR_count;
            ALU_shift_result = ALU_tmp_result[8:1];
            ALU_C = ALU_tmp_result[0];
	  end
        shift_fn_rol:
	  begin
            ALU_shift_result = (GPR_rs << IR_count) | (GPR_rs >> (8 - IR_count));
            ALU_C = ALU_shift_result[0];
	  end
        shift_fn_ror:
	  begin
            ALU_shift_result = (GPR_rs >> IR_count) | (GPR_rs << (8 - IR_count));
            ALU_C = ALU_shift_result[7];
	  end
      endcase
      ALU_result = ALU_shift_result;      
    end

  //assign ALU_Z = ALU_result == 0;
endmodule

