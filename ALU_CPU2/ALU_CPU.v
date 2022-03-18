module ALU_CPU (

	input clk_i,
	input rst_i,
	input inst_ack_i,
	input [17:0] IR,
	input int_req,
	input int_en,
	input data_ack_i,
	input port_ack_i,
	
	output reg [2:0] state_out, next_state_out

);

localparam [2:0] misc_fn_wait = 3'b100;
localparam [2:0] misc_fn_stby = 3'b101;
localparam [1:0] mem_fn_ldm = 2'b00;
localparam [1:0] mem_fn_stm = 2'b01;
localparam [1:0] mem_fn_inp = 2'b10;
localparam [1:0] mem_fn_out = 2'b11;

parameter [2:0] 	fetch_state      = 3'b000,
                  decode_state     = 3'b001,
                  execute_state    = 3'b010,
                  mem_state        = 3'b011,
                  write_back_state = 3'b100,
                  int_state        = 3'b101;
						
reg [2:0] state, next_state;

assign IR_decode_mem    = IR[17:16] == 2'b10;
assign IR_decode_jump   = IR[17:13] == 5'b11110;
assign IR_decode_branch = IR[17:12] == 6'b111110;
assign IR_decode_misc   = IR[17:11] == 7'b1111110;
assign IR_misc_fn		   = IR[10:8];
assign IR_mem_fn			= IR[15:14];

always @* 
begin 

    case(state)
      fetch_state:
        if(!inst_ack_i) 
				next_state = fetch_state;
        else            
				next_state = decode_state;
				
      decode_state:
        if(IR_decode_branch || IR_decode_jump || IR_decode_misc) 
		  begin
          if(IR_decode_misc && (IR_misc_fn == misc_fn_wait || IR_misc_fn == misc_fn_stby)
            && !(int_en && int_req))
					next_state = decode_state;
          else if(int_en && int_req) 
					next_state = int_state;
          else
					next_state = fetch_state;
        end
        else
          next_state = execute_state;
			 
      execute_state:
        if(IR_decode_mem) 
		  begin
          if((IR_mem_fn == mem_fn_ldm || IR_mem_fn == mem_fn_stm) && !data_ack_i)
					next_state = mem_state;
          else if((IR_mem_fn == mem_fn_inp || IR_mem_fn == mem_fn_out) && !port_ack_i)
					next_state = mem_state;
          else if(IR_mem_fn == mem_fn_ldm || IR_mem_fn == mem_fn_inp)
					next_state = write_back_state;
          else if(int_en && int_req)
					next_state = int_state;
          else
            next_state = fetch_state;
        end
        else
          next_state = write_back_state;
			 
      mem_state:
        if((IR_mem_fn == mem_fn_ldm || IR_mem_fn == mem_fn_stm) && !data_ack_i)
				next_state = mem_state;
        else if((IR_mem_fn == mem_fn_inp || IR_mem_fn == mem_fn_out) && !port_ack_i)
				next_state = mem_state;
        else if(IR_mem_fn == mem_fn_ldm || IR_mem_fn == mem_fn_inp)
				next_state = write_back_state;
        else if(int_en && int_req)
            next_state = int_state;
        else
				next_state = fetch_state;
				
      write_back_state:
        if(int_en && int_req) 
				next_state = int_state;
        else                   
				next_state = fetch_state;
				
      int_state:
        next_state = fetch_state;
		  
    endcase
	 
	 state_out <= state;
	 next_state_out <=next_state;
	 
end

always @(posedge clk_i or posedge rst_i)
begin
    if (rst_i) 
		state <= fetch_state;
    else       
		state <= next_state;
end

endmodule