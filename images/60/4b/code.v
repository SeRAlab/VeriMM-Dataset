module top_module(A, B, addSub, C);input [7:0] A, B;
input addSub;
output [7:0] C;

wire [7:0] sum, diff;

assign sum = A + B;
assign diff = A - B;

assign C = addSub ? diff : sum;

endmodule