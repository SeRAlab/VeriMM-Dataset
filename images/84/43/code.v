module top_module(
    input [31:0] A,
    input [31:0] B,
    input cin,
    output [31:0] sum
);assign sum = A + B + cin;

endmodule