module top_module(
    input  A0,
    input  A1,
    input  A2,
    input  A3,
    input  S0,
    input  S1,
    output X 
);wire not_S0;
    wire not_S1;
    wire A0_and_not_S0;
    wire A1_and_S0;
    wire A2_and_not_S1;
    wire A3_and_S1;
    wire A0_or_A1;
    wire A2_or_A3;

    // Using simple gate primitives for the multiplexer functionality
    not (not_S0, S0);
    not (not_S1, S1);
    
    and (A0_and_not_S0, A0, not_S0);
    and (A1_and_S0, A1, S0);
    and (A2_and_not_S1, A2, not_S1);
    and (A3_and_S1, A3, S1);
    
    or (A0_or_A1, A0_and_not_S0, A1_and_S0);
    or (A2_or_A3, A2_and_not_S1, A3_and_S1);
    
    or (X, A0_or_A1, A2_or_A3);

endmodule