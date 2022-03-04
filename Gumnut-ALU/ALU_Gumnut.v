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
	 
	 