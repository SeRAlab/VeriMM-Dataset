module top_module(
    input A,
    input B,
    output [2:0] F
    );assign F[2] = ~A & B; 
    assign F[1] = A ~^ B; 
    assign F[0] = A & ~B; 
endmodule