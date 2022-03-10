module gumnut_with_mem
  ( input clk_i,
    input rst_i,
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

  // Instruction memory bus
  wire        inst_cyc_o;
  wire        inst_stb_o;
  wire        inst_ack_i;
  wire [11:0] inst_adr_o;
  wire [17:0] inst_dat_i;
  // Data memory bus
  wire        data_cyc_o;
  wire        data_stb_o;
  wire        data_we_o;
  wire        data_ack_i;
  wire  [7:0] data_adr_o;
  wire  [7:0] data_dat_o;
  wire  [7:0] data_dat_i;

  gumnut
    #(.debug(debug))
    core
    ( .clk_i(clk_i),
      .rst_i(rst_i),
      .inst_cyc_o(inst_cyc_o),
      .inst_stb_o(inst_stb_o),
      .inst_ack_i(inst_ack_i),
      .inst_adr_o(inst_adr_o),
      .inst_dat_i(inst_dat_i),
      .data_cyc_o(data_cyc_o),
      .data_stb_o(data_stb_o),
      .data_we_o(data_we_o),
      .data_ack_i(data_ack_i),
      .data_adr_o(data_adr_o),
      .data_dat_o(data_dat_o),
      .data_dat_i(data_dat_i),
      .port_cyc_o(port_cyc_o),
      .port_stb_o(port_stb_o),
      .port_we_o(port_we_o),
      .port_ack_i(port_ack_i),
      .port_adr_o(port_adr_o),
      .port_dat_o(port_dat_o),
      .port_dat_i(port_dat_i),
      .int_req(int_req),
      .int_ack(int_ack) );

  inst_mem core_inst_mem
    ( .clk_i(clk_i),
      .cyc_i(inst_cyc_o),
      .stb_i(inst_stb_o),
      .ack_o(inst_ack_i),
      .adr_i(inst_adr_o),
      .dat_o(inst_dat_i) );

  data_mem core_data_mem
    ( .clk_i(clk_i),
      .cyc_i(data_cyc_o),
      .stb_i(data_stb_o),
      .we_i(data_we_o),
      .ack_o(data_ack_i),
      .adr_i(data_adr_o),
      .dat_i(data_dat_o),
      .dat_o(data_dat_i) );

endmodule

