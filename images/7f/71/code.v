module top_module(outXor,R1,R2);input [7:0]R1,R2;
output [15:0]outXor;
assign outXor=R1^R2;endmodule