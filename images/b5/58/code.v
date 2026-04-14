module top_module(
    input [7:0] a,
    input [7:0] b,
    input ctrl,
    output [7:0] out
);assign out = ctrl ? ~(a ^ b) : (a ^ b);

endmodule