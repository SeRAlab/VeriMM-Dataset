module top_module(
    input [3:0] A,
    input [3:0] B,
    output EQ,
    output GT,
    output LT,
    output NE
);assign EQ = (A == B);
    assign GT = (A > B);
    assign LT = (A < B);
    assign NE = (A != B);
    
endmodule