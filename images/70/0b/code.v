module top_module(outOr,R1,R2);input [7:0]R1,R2;
output [15:0]outOr;
assign outOr=R1|R2;endmodule