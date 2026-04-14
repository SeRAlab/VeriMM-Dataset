module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output EQ
);

    wire [3:0] equal_bits;

    assign equal_bits = A ^ B;

    assign EQ = ~(|equal_bits);

endmodule