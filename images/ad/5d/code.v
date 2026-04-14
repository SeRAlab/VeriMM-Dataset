module top_module(
    input [3:0] A,
    input [1:0] S,
    output reg out
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

// Stage 1
assign stage1_out[0] = ~(A[0] & S[0]);
assign stage1_out[1] = ~(A[1] & S[0]);
assign stage1_out[2] = ~(A[2] & S[0]);
assign stage1_out[3] = ~(A[3] & S[0]);

// Stage 2
assign stage2_out[0] = ~(stage1_out[0] & S[1]);
assign stage2_out[1] = ~(stage1_out[1] & S[1]);
assign stage2_out[2] = ~(stage1_out[2] & S[1]);
assign stage2_out[3] = ~(stage1_out[3] & S[1]);

// Output
assign out = stage2_out[0] & stage2_out[1] & stage2_out[2] & stage2_out[3];

endmodule