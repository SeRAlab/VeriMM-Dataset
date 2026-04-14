module top_module(
    input A,
    input B,
    output X
);// Voltage supply signals
    supply1 VDD;
    supply0 GND;

    // Simple AND logic
    assign X = A & B;

endmodule