module hazard_detection (
    input wire A,
    input wire B,
    output wire Y
);
    wire AB, A_bar, B_bar;

    assign A_bar = ~A;
    assign B_bar = ~B;
    
    // Generate the output Y with hazard detection
    assign Y = (A & B) | (A_bar & B) | (A & B_bar);
endmodule