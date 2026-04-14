module top_module(
    input [N-1:0] A,
    input [N-1:0] B,
    input Cin,
    output [M-1:0] S,
    output Cout
);parameter N = 4;
parameter M = 4;
parameter W = 4;

wire [N:0] C;
wire [N-1:0] S_int;
assign S_int = A ^ B ^ Cin;
assign C[0] = Cin;
genvar i;
generate
    for (i = 0; i < N; i = i + 1) begin : gen_adder
        assign C[i+1] = (A[i] & B[i]) | (A[i] & C[i]) | (B[i] & C[i]);
        assign S_int[i] = A[i] ^ B[i] ^ C[i];
    end
endgenerate
assign S = S_int;
assign Cout = C[N];

endmodule