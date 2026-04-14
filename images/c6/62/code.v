module bitwise_and_or_not(
    input A,
    input B,
    input C,
    input D,
    output Y
);

    wire A_and_B_and_C = A & B & C;
    wire not_D = ~D;
    
    assign Y = A_and_B_and_C | not_D;

endmodule