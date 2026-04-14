module wallace_tree_multiplier(  
    input [3:0] A,  
    input [3:0] B,  
    output [7:0] P  
);  
    wire [3:0] pp [3:0]; // Partial products  
    wire [3:0] s1, s2, c1, c2; // Sum and carry wires  
    wire [7:0] p1, p2; // Intermediate products  

    // Generate partial products  
    assign pp[0] = A & {4{B[0]}};  
    assign pp[1] = A & {4{B[1]}} << 1;  
    assign pp[2] = A & {4{B[2]}} << 2;  
    assign pp[3] = A & {4{B[3]}} << 3;  

    // First stage of reduction  
    assign {c1, s1} = pp[0] + pp[1];  
    assign {c2, s2} = pp[2] + pp[3];  

    // Second stage of reduction  
    assign P = s1 + s2 + (c1 << 1) + (c2 << 2);  
endmodule