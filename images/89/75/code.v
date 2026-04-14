module top_module(
    input [71:0] I0,
    input [71:0] I1,
    input S,
    output [71:0] O
    );assign O = S?I1:I0;

endmodule