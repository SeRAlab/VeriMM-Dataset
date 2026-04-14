module top_module(
    input  A,
    input  B,
    input  C,
    input  D,
    output Y
);wire AB, CD, ABCD;
    
    // Implement NOR operation on AB and CD
    assign AB = ~(A | B);
    assign CD = ~(C | D);
    
    // Implement NOR operation on AB and CD
    assign ABCD = ~(AB | CD);
    
    // Output the result
    assign Y = ABCD;
endmodule