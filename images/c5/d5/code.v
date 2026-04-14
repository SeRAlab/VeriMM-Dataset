module and_gate (
    // Inputs
    input A,
    input B,
    
    // Outputs
    output Y
);

    assign Y = ~(~A | ~B);

endmodule