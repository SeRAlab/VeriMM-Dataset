module csa_4bit(  
    input [3:0] A,  
    input [3:0] B,  
    input [3:0] C,  
    output [4:0] SUM  
);  
    wire [3:0] P, Q;  
    // Partial sums  
    assign P = A ^ B ^ C;  
    // Carry outputs  
    assign Q = (A & B) | (B & C) | (C & A);  
    // Final output sum  
    assign SUM = {1'b0, P} + Q;  
endmodule