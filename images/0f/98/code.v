module adder_16bit(  
    input [15:0] A,  
    input [15:0] B,  
    output [15:0] SUM,  
    output COUT  
);  
    assign {COUT, SUM} = A + B;  
endmodule