module array_multiplier_4bit(  
    input [3:0] A,  
    input [3:0] B,  
    output [7:0] P  
);  
    wire [3:0] partial[3:0];  
    wire [7:0] sum[2:0];  

    // Generate partial products  
    assign partial[0] = A & {4{B[0]}};  
    assign partial[1] = A & {4{B[1]}} << 1;  
    assign partial[2] = A & {4{B[2]}} << 2;  
    assign partial[3] = A & {4{B[3]}} << 3;  

    // Sum the partial products  
    assign sum[0] = {4'b0000, partial[0]};  
    assign sum[1] = {3'b000, partial[1], 1'b0};  
    assign sum[2] = {2'b00, partial[2], 2'b00};  
    assign P = sum[0] + sum[1] + sum[2] + {1'b0, partial[3], 3'b000};  
endmodule