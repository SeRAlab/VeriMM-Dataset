module top_module(
    input [3:0] binary,
    output [3:0] gray
);

    // Assign gray code outputs based on binary inputs
    assign gray[3] = binary[3];
    assign gray[2] = binary[3] ^ binary[2];
    assign gray[1] = binary[2] ^ binary[1];
    assign gray[0] = binary[1] ^ binary[0];

endmodule