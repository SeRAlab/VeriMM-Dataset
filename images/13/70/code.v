module wallace_tree_adder (  
    input [3:0] A,  
    input [3:0] B,  
    input [3:0] C,  
    output [4:0] SUM  
);  
    wire [7:0] P;  
    wire [4:0] S;  
    wire [3:0] carry;  

    assign P[0] = A[0] & B[0];  
    assign P[1] = A[0] & B[1];  
    assign P[2] = A[0] & B[2];  
    assign P[3] = A[0] & B[3];  
    assign P[4] = A[1] & B[0];  
    assign P[5] = A[1] & B[1];  
    assign P[6] = A[1] & B[2];  
    assign P[7] = A[1] & B[3];  
    // Additional products similar to above for A[2] and A[3]  

    assign S[0] = P[0];  
    assign S[1] = P[1] ^ P[4];  
    assign S[2] = P[2] ^ P[5] ^ P[6];  
    assign S[3] = P[3] ^ P[7];  
    assign carry[0] = P[1] & P[4];  
    assign carry[1] = (P[2] & P[5]) | (P[2] & P[6]) | (P[5] & P[6]);  
    assign carry[2] = (P[3] & P[7]);  

    assign SUM[0] = S[0];  
    assign SUM[1] = S[1];  
    assign SUM[2] = S[2] ^ carry[0];  
    assign SUM[3] = S[3] ^ carry[1];  
    assign SUM[4] = carry[2];  

endmodule