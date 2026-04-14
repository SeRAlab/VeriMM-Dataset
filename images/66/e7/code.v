module top_module(
    input [31:0]a,b,
    input cin,
    output [31:0]out );assign out = a + b + cin;endmodule