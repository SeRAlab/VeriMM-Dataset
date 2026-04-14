module top_module(
           clk,
           rst_n,
           sel,
           seg    
            );input clk;
input rst_n;

output [7:0]sel;
output [7:0]seg;



assign sel=8'b0000_0001;
assign seg=8'b0011_0000;

endmodule