module top_module(
  input [1:0] address,
  input chipselect,
  input clk,
  input reset_n,
  input write_n,
  input [31:0] writedata,
  output reg [7:0] out_port,
  output reg [31:0] readdata
);reg [7:0] data_out;
  wire clk_en;
  
  assign clk_en = 1;
  
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      data_out <= 0;
    end else if (chipselect && ~write_n && address == 0) begin
      data_out <= writedata[7:0];
    end
  end
  
  assign out_port = data_out;
  assign readdata = {32'b0, data_out};
  
endmodule