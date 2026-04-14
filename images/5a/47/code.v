module top_module(
    input A, 
    input B, 
    input C, 
    input D, 
    input S0, 
    input S1, 
    output Y);assign Y = (S1 == 0 && S0 == 0) ? A :
               (S1 == 0 && S0 == 1) ? B :
               (S1 == 1 && S0 == 0) ? C :
                                      D ;

endmodule