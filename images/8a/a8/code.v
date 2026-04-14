module top_module(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    input [7:0] e,
    output [7:0] out
);wire [7:0] temp1;
    wire [7:0] temp2;

    assign temp1 = a & b;
    assign temp2 = c | d;

    assign out = temp1 ^ temp2;
    assign out = out + e;

endmodule