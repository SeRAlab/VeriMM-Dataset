module top_module(clk, A, B, RES);parameter WIDTHA =  6;
parameter WIDTHB =  9;
input clk;
input [WIDTHA-1:0] A;
input [WIDTHB-1:0] B;
output [WIDTHA+WIDTHB-1:0] RES;
reg [WIDTHA-1:0] rA;
reg [WIDTHB-1:0] rB;
reg [WIDTHA+WIDTHB-1:0] M [3:0];
integer i;
always @(posedge clk)
 begin
 rA <= A;
 rB <= B;
 M[0] <= rA * rB;
 for (i = 0; i < 3; i = i+1)
 M[i+1] <= M[i];
 end
assign RES = M[3];
endmodule