module complement (
    input  [3:0] A,
    output [3:0] Y
);

    // Local signals
    wire [3:0] not_A;

    // Complement A using NOT gates
    not #(4) not0 (not_A, A);

    // Output the complement
    assign Y = not_A;

endmodule