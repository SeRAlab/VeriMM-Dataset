module top_module(
    output X,
    input  A,
    input  B,
    input  C,
    input  D
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire temp1, temp2;

    // Replace unknown module with AND gate implementation
    assign temp1 = A & B & C; // Represents AND3 functionality for inputs A, B, C
    assign temp2 = temp1 & D;  // Represents AND operation for temp1 and D

    assign X = temp2;

endmodule