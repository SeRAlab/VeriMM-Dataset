module array_multiplier (  
    input [3:0] A,  
    input [3:0] B,  
    output [7:0] P  
);  
    wire [3:0] partial [3:0];  
    wire [7:0] sum [2:0];  

    // Generate partial products  
    assign partial[0] = A & {4{B[0]}};  
    assign partial[1] = A & {4{B[1]}} << 1;  
    assign partial[2] = A & {4{B[2]}} << 2;  
    assign partial[3] = A & {4{B[3]}} << 3;  

    // Sum the partial products  
    assign sum[0] = partial[0];  
    assign sum[1] = sum[0] + partial[1];  
    assign sum[2] = sum[1] + partial[2];  
    assign P = sum[2] + partial[3];  
endmodule