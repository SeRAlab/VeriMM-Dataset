module and_gate (
    input A,
    input B,
    input C,
    output Y
);

    // Voltage supply signals
    supply1 VDD;
    supply0 VSS;

    // AND gate logic
    assign Y = A & B & C;

endmodule