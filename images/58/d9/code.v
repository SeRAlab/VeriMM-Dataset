module top_module(
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C32
);wire [15:0] A0, B0, C0, S0, A1, B1, C1, S1;
wire C2;

assign {C1, S1} = A[31:16] + B[31:16] + C2;
assign {C0, S0} = A[15:0] + B[15:0] + C1;
assign C32 = C2;

assign S = {S1, S0};

endmodule