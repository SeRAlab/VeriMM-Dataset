module adder_64bit (  
    input [63:0] A,  
    input [63:0] B,  
    output [63:0] SUM,  
    output COUT  
);  
    assign {COUT, SUM} = A + B;  
endmodule