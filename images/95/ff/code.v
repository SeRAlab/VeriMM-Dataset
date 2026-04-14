module top_module(A, B, S, Cout);input [3:0] A;
input [3:0] B;
output [3:0] S;
output Cout;

wire [4:0] temp_sum;
assign temp_sum = A + B;

assign Cout = temp_sum[4];
assign S = temp_sum[3:0];

endmodule