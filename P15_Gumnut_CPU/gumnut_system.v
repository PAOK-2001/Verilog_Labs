module gumnut_system
  ( input clk_i,
    input rst_i );  // add ports for I/O

  // I/O port bus
  wire       port_cyc_o;
  wire       port_stb_o;
  wire       port_we_o;
  wire       port_ack_i;
  wire [7:0] port_adr_o;
  wire [7:0] port_dat_o;
  wire [7:0] port_dat_i;
  // Interrupts
  wire       int_req;
  wire       int_ack;

  // Add signals for internal connections
  // ...

  gumnut_with_mem
    #(.debug(1'b0))
    core
    ( .clk_i(clk_i),
      .rst_i(rst_i),
      .port_cyc_o(port_cyc_o),
      .port_stb_o(port_stb_o),
      .port_we_o(port_we_o),
      .port_ack_i(port_ack_i),
      .port_adr_o(port_adr_o),
      .port_dat_o(port_dat_o),
      .port_dat_i(port_dat_i),
      .int_req(int_req),
      .int_ack(int_ack) );

  // Add internal I/O controller instances
  // ...

endmodule
