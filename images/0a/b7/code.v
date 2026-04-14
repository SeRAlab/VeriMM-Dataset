module wallace_tree_multiplier(  
    input [3:0] A,  
    input [3:0] B,  
    output [7:0] P  
);  
    wire [3:0] pp[0:3]; // partial products  
    wire [7:0] sum;  
    wire [4:0] carry;  

    // Generate partial products  
    assign pp[0] = A & {4{B[0]}};  
    assign pp[1] = A & {4{B[1]}} << 1;  
    assign pp[2] = A & {4{B[2]}} << 2;  
    assign pp[3] = A & {4{B[3]}} << 3;  

    // Wallace Tree Reduction  
    // Stage 1: First level of reduction using 4 partial products  
    wire [3:0] s1, s2;  
    wire c1, c2;  
    
    // First Half Adder  
    assign s1 = pp[0] ^ pp[1];  
    assign c1 = pp[0] & pp[1];  
    
    // Second Half Adder  
    assign s2 = s1 ^ pp[2];  
    assign carry[0] = c1 | (s1 & pp[2]);  

    // Final summation  
    assign P[3:0] = s2 ^ pp[3];  
    assign carry[1] = carry[0] | (s2 & pp[3]);  
    assign P[7:4] = carry[1];  
  
endmodule