module top_module(
  // inputs:
  input [1:0] address,
  input chipselect,
  input clk,
  input reset_n,
  input write_n,
  input [31:0] writedata,

  // outputs:
  output reg out_port,  // Changed to 'reg' for output
  output reg [31:0] readdata  // Changed to 'reg' for output
);wire clk_en;
  reg [31:0] data_out;  // Changed to array to match the size of writedata
  wire read_mux_out;

  assign clk_en = 1;

  // s1, which is an e_avalon_slave
  assign read_mux_out = (address == 0) ? data_out : 32'b0;  // Corrected to properly implement the multiplexer

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      data_out <= 32'b0;  // Initialize to 0 for 32-bit
    end else if (chipselect && ~write_n && (address == 0)) begin
      data_out <= writedata;
    end
  end

  always @(*) begin  // Added always block to drive readdata and out_port
    readdata = read_mux_out;  // Assign readdata from read_mux_out
    out_port = (address == 0);  // Drive out_port based on address
  end

endmodule