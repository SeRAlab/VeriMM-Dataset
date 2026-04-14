module and_gate (
    input  A1,
    input  A2,
    input  A3,
    input  A4,
    output Y
);

    // Logic to check if all inputs are high
    assign Y = A1 & A2 & A3 & A4;

endmodule