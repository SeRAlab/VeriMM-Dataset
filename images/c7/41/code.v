module XOR_4bit(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Z
);

    assign Z = A ^ B;

endmodule