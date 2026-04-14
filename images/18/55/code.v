module vector_adder (  
    input [4:0] A,  
    input [4:0] B,  
    output [5:0] SUM  
);  
    assign SUM = A + B;  
endmodule