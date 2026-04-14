module top_module(A, B, EQ);input [3:0] A;
    input [3:0] B;
    output EQ;
    
    assign EQ = (A == B) ? 1'b1 : 1'b0;
endmodule