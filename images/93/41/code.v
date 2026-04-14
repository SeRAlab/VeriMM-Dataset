module top_module(clk,rst,data_in,data_out);parameter D_WIDTH = 16;
  input clk;
  input rst;
  input [D_WIDTH-1:0] data_in;
  output wire[D_WIDTH-1:0] data_out;
  
  assign data_out = data_in[D_WIDTH-1]?0:data_in;
endmodule