module top_module(
    input [3:0] a,
    input [1:0] sel,
    output out);

assign out = a[sel];

endmodule