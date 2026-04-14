module top_module(
    input A,
    input B,
    input SEL,
    output Y
);wire SEL_B;
    
    // Instantiate a 2-to-1 multiplexer using gates
    assign SEL_B = SEL ? B : A; // Simplified logic for mux
    
    // Output Y is driven by the selected input
    assign Y = SEL ? B : A;

endmodule