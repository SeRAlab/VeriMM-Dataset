module top_module(
    COUT_N,
    SUM   ,
    A     ,
    B     ,
    CI
);output COUT_N;
    output SUM   ;
    input  A     ;
    input  B     ;
    input  CI    ;

    // Define intermediate signals
    wire a_xor_b;
    wire a_and_b;
    wire b_and_ci;
    wire a_and_ci;
    wire a_xor_b_and_ci;
    
    // Define the full adder logic
    assign a_xor_b = A ^ B;
    assign SUM = a_xor_b ^ CI;
    assign a_and_b = A & B;
    assign b_and_ci = B & CI;
    assign a_and_ci = A & CI;
    assign a_xor_b_and_ci = a_xor_b & CI;
    assign COUT_N = a_and_b | b_and_ci | a_and_ci | a_xor_b_and_ci;

endmodule