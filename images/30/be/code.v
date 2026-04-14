module multiplier_32bit (  
    input [31:0] A,  
    input [31:0] B,  
    output [63:0] P  
);  
    assign P = A * B;  
endmodule