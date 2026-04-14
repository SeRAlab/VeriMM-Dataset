module top_module(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [31:0] result,
    output cout
);wire [31:0] G;
wire [31:0] P;
wire [31:0] C;

assign G = a & b;
assign P = a | b;
assign C[0] = cin;

genvar i;
generate
    for (i = 0; i < 31; i = i + 1) begin : CLA_unit
        assign C[i+1] = G[i] | (P[i] & C[i]);
        assign result[i] = a[i] ^ b[i] ^ C[i];
    end
endgenerate

assign result[31] = a[31] ^ b[31] ^ C[31];
assign cout = C[31];

endmodule