module top_module(
    input [15:0] A,
    input [15:0] B,
    input sub,
    output [15:0] out
);assign out = sub ? (A - B) : (A + B);
endmodule