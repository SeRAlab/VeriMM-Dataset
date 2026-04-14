module top_module(
  input [1:0] address,
  input chipselect,
  input clk,
  input reset_n,
  input write_n,
  input [31:0] writedata,
  output reg out_port,
  output reg [31:0] readdata
);wire clk_en;
  reg [31:0] data_out; // Change to 32-bit reg to store the entire writedata
  wire read_mux_out;

  assign clk_en = 1;

  // s1, which is an e_avalon_slave
  assign read_mux_out = (address == 2'b00) ? data_out : 32'b0; // Updated for clarity

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      data_out <= 32'b0; // Initialize to 32 bits
    end else if (chipselect && ~write_n && (address == 2'b00)) begin
      data_out <= writedata;
    end
  end

  always @(*) begin
    readdata = read_mux_out; // Use read_mux_out directly
    out_port = data_out[0];  // Assuming out_port represents the LSB of data_out
  end

endmodule