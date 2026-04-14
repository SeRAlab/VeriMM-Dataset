module array_multiplier (  
    input [3:0] A,  
    input [3:0] B,  
    output [7:0] P  
);  
    wire [3:0] pp [0:3]; // Partial products  

    // Generate partial products  
    assign pp[0] = A & {4{B[0]}};  
    assign pp[1] = A & {4{B[1]}} << 1;  
    assign pp[2] = A & {4{B[2]}} << 2;  
    assign pp[3] = A & {4{B[3]}} << 3;  

    // Sum the partial products to get the final product  
    assign P = pp[0] + pp[1] + pp[2] + pp[3];  
endmodule