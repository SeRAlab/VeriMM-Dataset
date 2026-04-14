module binary_adder(  
    input [15:0] A,  
    input [15:0] B,  
    output [15:0] SUM  
);  
    assign SUM = A + B;  
endmodule