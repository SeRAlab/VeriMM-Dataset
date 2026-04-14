module top_module(clk,immgenout,data_out);input [63:0] immgenout;
input clk;
output reg [63:0] data_out;

always@(posedge clk)
  data_out= immgenout <<1 ;

endmodule