module top_module(
  input [1:0] address,
  input chipselect,
  input clk,
  input reset_n,
  input write_n,
  input [31:0] writedata,
  output out_port,
  output [31:0] readdata
);reg [31:0] memory; // 32-bit register to store memory
  reg [31:0] readdata_reg; // 32-bit register to store read data
  wire clk_en; // clock enable signal

  // generate clock enable signal
  assign clk_en = 1;

  // write to memory when chipselect is asserted and write_n is deasserted
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      memory <= 0;
    end else if (chipselect && ~write_n && (address == 2'b00)) begin
      memory <= writedata;
    end
  end

  // read from memory when chipselect is asserted and write_n is asserted
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      readdata_reg <= 0;
    end else if (chipselect && write_n && (address == 2'b00)) begin
      readdata_reg <= memory;
    end
  end

  // assign outputs
  assign out_port = memory;
  assign readdata = readdata_reg;

endmodule