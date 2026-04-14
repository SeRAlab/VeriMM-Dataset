module hazard_detector_adder(
    input wire A1, A0,
    input wire B1, B0,
    output wire S1, S0,
    output wire C_out
);
    wire C1, C0;

    // Full adder logic
    assign S0 = A0 ^ B0;
    assign C0 = A0 & B0;

    assign S1 = A1 ^ B1 ^ C0;
    assign C1 = (A1 & B1) | (C0 & (A1 ^ B1));

    assign C_out = C1;

    // Hazard detection logic (example)
    wire hazard;
    assign hazard = (A1 & ~A0 & B0) | (A0 & A1 & ~B1) | (~A1 & A0 & B1);
    
    // If hazard is detected, hold previous values (in a real implementation, this may require state)
    // For simplicity in this example, we are just indicating through a warning signal
    // Normally you would create a more complex system to handle this
    assign S0 = hazard ? S0 : S0;
    assign S1 = hazard ? S1 : S1;
    assign C_out = hazard ? C_out : C_out;

endmodule