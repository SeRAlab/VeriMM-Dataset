module xor_8bit (
    input [7:0] A,
    input [7:0] B,
    output [7:0] Z
);

    assign Z = A ^ B;

endmodule