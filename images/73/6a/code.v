module top_module(
    input [3:0] A,
    input [3:0] B,
    output [4:0] C
);wire [3:0] sum;
wire carry_out;

assign sum = A + B;
assign carry_out = (sum[3] & A[3]) | (sum[3] & B[3]) | (A[3] & B[3]);

assign C[3:0] = sum;
assign C[4] = carry_out;

endmodule