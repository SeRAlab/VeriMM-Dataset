module top_module(outand,R1,R2);input [7:0]R1,R2;
output [15:0]outand;
assign outand=R1&R2;endmodule