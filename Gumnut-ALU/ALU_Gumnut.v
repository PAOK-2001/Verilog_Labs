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
	 
	 