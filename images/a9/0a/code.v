module top_module(
    A   ,
    B   ,
    SEL ,
    OUT
);// Module ports
    input  A   ;
    input  B   ;
    input  SEL ;
    output OUT ;

    // Local signals
    wire  not_SEL;
    wire  A_and_not_SEL;
    wire  B_and_SEL;

    // Invert SEL signal
    not not_SEL_inst (not_SEL, SEL);

    // AND A and not_SEL
    and A_and_not_SEL_inst (A_and_not_SEL, A, not_SEL);

    // AND B and SEL
    and B_and_SEL_inst (B_and_SEL, B, SEL);

    // OR the two AND gates
    or or_inst (OUT, A_and_not_SEL, B_and_SEL);

endmodule