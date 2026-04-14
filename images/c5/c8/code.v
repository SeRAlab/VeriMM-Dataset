module adder(
    input [31:0] A,
    input [31:0] B,
    input [31:0] C,
    input [31:0] D,
    output [31:0] Y
);

assign Y = A + B + C + D;

endmodule