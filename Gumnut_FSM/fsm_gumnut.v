module fsm_gumnut(
	 input            clk_i,  // Clock
    input            rst_i,  // Reset
	 input[17:0]      IR,     // Instruction Register
	 // Interrupts
    input            int_req, // Interrupt request
	 input            int_en,  // Interrupt enable
	 input            inst_ack_i, //Enable for decode
	 input            data_ack_i, //Enable for data entry
	 input		      port_ack_i, // Enable for IO entry
	 output reg [2:0] state   // FSM state

);

// Constant
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

//IR Partition
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

assign IR_decode_alu_immed = IR[17]    == 1'b0;
assign IR_decode_mem       = IR[17:16] == 2'b10;
assign IR_decode_shift     = IR[17:15] == 3'b110;
assign IR_decode_alu_reg   = IR[17:14] == 4'b1110;
assign IR_decode_jump      = IR[17:13] == 5'b11110;
assign IR_decode_branch    = IR[17:12] == 6'b111110;
assign IR_decode_misc      = IR[17:11] == 7'b1111110;

// FSM State Definition
parameter [2:0] fetch_state      = 3'b000,
					decode_state     = 3'b001,
					execute_state    = 3'b010,
					mem_state        = 3'b011,
					write_back_state = 3'b100,
					int_state        = 3'b101;
reg [2:0] next_state;

// Control Unit State Machine  
always @*  // next state logic
 case (state)
	fetch_state: // Get instruction from IR
	  if (!inst_ack_i) next_state = fetch_state; // If inst_ack_i is LOW, stay in FETCH
	  else             next_state = decode_state; // If inst_ack_i is HIGH, go to decode
	  
	decode_state: // Identifies the type of operations, contained in IR
	  if (IR_decode_branch || IR_decode_jump || IR_decode_misc) begin// If instruction type BRANCH, JUMP OR MISC 
		 if (IR_decode_misc
			&& (IR_misc_fn == misc_fn_wait || IR_misc_fn == misc_fn_stby) // If WAIT or STANDBY
			&& !(int_en && int_req))
			next_state = decode_state; //and INT_EN = 0 INT_REQ = 0. Stay in Decode
		 else if (int_en && int_req)  // if INT_EN and INT_REQ are HIGH go to int_state
			next_state = int_state;
		 else 
			next_state = fetch_state;
	  end
	  else // ANY other type of operation, go to execute
		 next_state = execute_state;
		
	execute_state: // Do necessary operation given the instruction
	  if (IR_decode_mem) begin
		 if ((IR_mem_fn == mem_fn_ldm || IR_mem_fn == mem_fn_stm)
			  && !data_ack_i) // If memory operation but memory not enabled go to mem_state
			next_state = mem_state;
		 else if ((IR_mem_fn == mem_fn_inp || IR_mem_fn == mem_fn_out) // If memory operation but port not enabled go to mem_state
					 && !port_ack_i)
			next_state = mem_state;
		 else if (IR_mem_fn == mem_fn_ldm || IR_mem_fn == mem_fn_inp) 
			next_state = write_back_state; //If memory operation AND memory enabled go to write_back_state
		 else if (int_en && int_req)// If interupt, go to interrupt state
			next_state = int_state;
		 else
			next_state = fetch_state;
	  end
	  else
		 next_state = write_back_state;
		 
	mem_state:// Wait for data and/or port to be ENABLED for memory opertion
	  if ((IR_mem_fn == mem_fn_ldm || IR_mem_fn == mem_fn_stm)
			&& !data_ack_i)
		 next_state = mem_state;
	  else if ((IR_mem_fn == mem_fn_inp || IR_mem_fn == mem_fn_out)
				  && !port_ack_i)
		 next_state = mem_state;
	  else if (IR_mem_fn == mem_fn_ldm || IR_mem_fn == mem_fn_inp)
		 next_state = write_back_state;
	  else if (int_en && int_req) // Interupt
			next_state = int_state;
	  else // If operation changed (which should NOT be possible) go to FETCH
		 next_state = fetch_state;
		 
	write_back_state: // Execute write operations and go back to fetch
	  if (int_en && int_req) next_state = int_state; // Interrupt state
	  else                   next_state = fetch_state;
	  
	int_state:// transitory state, bc of interrupt
	  next_state = fetch_state;
 endcase

always @(posedge clk_i or posedge rst_i) // state reg
 if (rst_i) state <= fetch_state;
 else       state <= next_state;


endmodule
