module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] out
);// Implementation of Ripple Carry Adder
    assign out = sub ? (a - b) : (a + b);
endmodule