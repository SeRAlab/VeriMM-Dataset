module top_module(
    A,
    B,
    SEL,
    Y
);// Module ports
    input  A;
    input  B;
    input  SEL;
    output Y;

    // Local signals
    wire not_SEL;
    
    // Invert SEL signal
    not not_SEL_inst (
        not_SEL,
        SEL
    );

    // Multiplexer
    assign Y = (SEL & A) | (not_SEL & B);

endmodule