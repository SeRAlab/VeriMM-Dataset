module xor_and(
        c_in,
        d_in,
        out1
    );

    // SIGNAL DECLARATIONS
    input c_in;
    input d_in;
    output out1;
    wire out1;
    wire temp;

    assign temp = c_in & d_in;
    assign out1 = temp ^ d_in;

endmodule