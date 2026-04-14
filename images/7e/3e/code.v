module top_module(
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    input [7:0] D,
    input [7:0] E,
    input [7:0] F,
    input [7:0] G,
    input [7:0] H,
    output [7:0] Y
);assign Y = (A + B) - (C + D) + (E + F) - (G + H);

endmodule