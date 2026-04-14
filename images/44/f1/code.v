module top_module(
    input [3:0] binary,
    output [3:0] gray
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    // Intermediate signals
    wire [3:0] xor_out;

    // Gray code output logic
    assign gray[0] = binary[0];                     // MSB of Gray code is same as LSB of binary
    assign gray[1] = binary[1] ^ binary[0];        // 1st bit of Gray code
    assign gray[2] = binary[2] ^ binary[1];        // 2nd bit of Gray code
    assign gray[3] = binary[3] ^ binary[2];        // 3rd bit of Gray code

endmodule