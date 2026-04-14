module hazard_detect_mux(
    input wire A,
    input wire B,
    input wire C,
    input wire S1,
    input wire S0,
    output wire Y
);
    wire Y_A, Y_B, Y_C;
    
    // Hazard detection logic: Use a simple OR gate to combine inputs before selection
    assign Y_A = A & ~S1 & ~S0; // Select A
    assign Y_B = B & ~S1 & S0;  // Select B
    assign Y_C = C & S1 & S0;   // Select C

    // Main output logic
    assign Y = Y_A | Y_B | Y_C;
endmodule