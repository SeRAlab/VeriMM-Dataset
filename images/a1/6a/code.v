module top_module(
    input [7:0] a,
    input [7:0] b,
    output out,
    output out_bar);assign out = a == b;
    assign out_bar = ~out;
endmodule