`timescale 1ns/1ns

module test;

  reg syscon_clk_o;
  reg syscon_rst_o;
  // I/O port bus
  wire       gumnut_port_cyc_o;
  wire       gumnut_port_stb_o;
  wire       gumnut_port_we_o;
  reg        gumnut_port_ack_i;
  wire [7:0] gumnut_port_adr_o;
  wire [7:0] gumnut_port_dat_o;
  reg  [7:0] gumnut_port_dat_i;
  // Interrupts
  reg        gumnut_int_req;
  wire       gumnut_int_ack;

  reg [7:0] input_data [0:31];
  integer next_input;
  
  initial $readmemh("test_data.dat", input_data);

  initial begin  // reset generator
    syscon_rst_o = 1'b1;
    #(25) syscon_rst_o = 1'b0;
  end

  always begin  // clock generator
    syscon_clk_o = 1'b1; #(5);
    syscon_clk_o = 1'b0; #(5);
  end

  gumnut_with_mem
    #(.debug(1'b1))
    core
    ( .clk_i(syscon_clk_o),
      .rst_i(syscon_rst_o),
      .port_cyc_o(gumnut_port_cyc_o),
      .port_stb_o(gumnut_port_stb_o),
      .port_we_o(gumnut_port_we_o),
      .port_ack_i(gumnut_port_ack_i),
      .port_adr_o(gumnut_port_adr_o),
      .port_dat_o(gumnut_port_dat_o),
      .port_dat_i(gumnut_port_dat_i),
      .int_req(gumnut_int_req),
      .int_ack(gumnut_int_ack) );

  initial begin  // interrupt generator
    gumnut_int_req = 1'b0;
    repeat (10) begin
      repeat (25) @(negedge syscon_clk_o);
      gumnut_int_req = 1'b1;
      @(negedge syscon_clk_o);
      while (!gumnut_int_ack) @(negedge syscon_clk_o);
      gumnut_int_req = 1'b0;
    end
  end

  initial begin  // I/O control
    next_input <= 0;
    gumnut_port_ack_i <= 1'b0;
    forever begin
      @(negedge syscon_clk_o);
      if (gumnut_port_cyc_o && gumnut_port_stb_o)
        if (!gumnut_port_we_o) begin
          $display("IO: port read; address = %d, data = %h",
                   gumnut_port_adr_o, input_data[next_input]);
          gumnut_port_dat_i <= input_data[next_input];
          next_input <= (next_input + 1) % 32;
          gumnut_port_ack_i <= 1'b1;
	end
        else begin
          $display("IO: port write; address = %d, data = %h",
                   gumnut_port_adr_o, gumnut_port_dat_o);
          gumnut_port_ack_i <= 1'b1;
        end
      else
        gumnut_port_ack_i = 1'b0;
    end
  end

endmodule
