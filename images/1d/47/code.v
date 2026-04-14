module multiplier_16x16(  
    input [15:0] A,  
    input [15:0] B,  
    output [31:0] PRODUCT  
);  
    assign PRODUCT = A * B;  
endmodule