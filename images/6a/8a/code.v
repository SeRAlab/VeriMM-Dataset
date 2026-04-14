module top_module(
    input A0,
    input A1,
    input A2,
    input A3,
    input [1:0] S,
    output X
);wire [1:0] notS;
assign notS = ~S;

wire w1, w2, w3, w4;
assign w1 = A0 & notS[1] & notS[0];
assign w2 = A1 & notS[1] & S[0];
assign w3 = A2 & S[1] & notS[0];
assign w4 = A3 & S[1] & S[0];

assign X = w1 | w2 | w3 | w4;

endmodule