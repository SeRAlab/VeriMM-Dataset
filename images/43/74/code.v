module top_module(
  input clk,
  input rst_l,
  input [63:0] data_in,
  input size_in,
  output [63:0] data_out,
  output size_out
);wire [3:0] data_out_4;
  wire [63:0] data_out_64;
  
  // Convert 4-bit to 64-bit
  assign data_out_64 = {60'd0, data_in};
  assign data_out_4 = data_in[3:0];
  
  // Select output based on input size
  assign data_out = (size_in == 4) ? {60'd0, data_out_4} : data_out_64;
  assign size_out = (size_in == 4) ? 64 : 4;
  
endmodule