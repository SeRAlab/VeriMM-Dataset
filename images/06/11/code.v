module wallace_tree_multiplier(  
    input [3:0] A,  
    input [3:0] B,  
    output [7:0] P  
);  
    wire [3:0] pp0, pp1, pp2, pp3;  
    wire [4:0] s1, s2, s3;  
    wire [7:0] sum;  
      
    // Partial Products  
    assign pp0 = A & {4{B[0]}};  
    assign pp1 = A & {4{B[1]}} << 1;  
    assign pp2 = A & {4{B[2]}} << 2;  
    assign pp3 = A & {4{B[3]}} << 3;  
      
    // Sum first two partial products  
    assign s1 = pp0 + pp1;  
      
    // Add the next partial product  
    assign s2 = s1 + pp2;  
      
    // Final addition with the last partial product  
    assign P = s2 + pp3;  
endmodule