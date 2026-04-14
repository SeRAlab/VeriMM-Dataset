module combinational_circuit (
    input [1:0] A1A2,
    input [1:0] B1B2,
    input [1:0] C1C2,
    output Y
);

    assign Y = (A1A2 & B1B2) | (~C1C2);

endmodule