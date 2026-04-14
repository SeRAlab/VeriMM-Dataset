module top_module(
    X   ,
    A   ,
    B   ,
    C   ,
    D   
);output X   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;

    wire [3:0] or_input;
    assign or_input = {A, B, C, D};
    
    // Using a local OR gate implementation instead of external module for compatibility
    assign X = or_input[0] | or_input[1] | or_input[2] | or_input[3];

endmodule