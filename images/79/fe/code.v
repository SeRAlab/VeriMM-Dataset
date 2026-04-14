module top_module(
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] S,
    output Cout
);wire [31:0] C1, C2, P, G, D, E;
wire [31:0] S1, S2;

assign {C1, S1} = A + B;
assign {C2, S2} = S1 + Cin;

assign P = S1 ^ Cin;
assign G = C1 & Cin;
assign D = C2 & S1;
assign E = G | D;

assign S = E ^ Cin;
assign Cout = E;

endmodule