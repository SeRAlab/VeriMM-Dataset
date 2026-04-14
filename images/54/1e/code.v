module top_module(
  input [1:0] address,
  input chipselect,
  input clk,
  input reset_n,
  input write_n,
  input [31:0] writedata,
  output [3:0] out_port,
  output [31:0] readdata
);wire clk_en;
  reg [3:0] data_out;
  wire [3:0] read_mux_out;

  assign clk_en = 1;
  
  assign read_mux_out = {4 {(address == 0)}} & data_out;
  
  always @(posedge clk or negedge reset_n) begin
    if (reset_n == 0) begin
      data_out <= 0;
    end else if (chipselect && ~write_n && (address == 0)) begin
      data_out <= writedata[3:0];
    end
  end
  
  assign readdata = {32'b0 | read_mux_out};
  assign out_port = data_out;
  
endmodule