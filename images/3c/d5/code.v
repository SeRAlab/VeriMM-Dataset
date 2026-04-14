module adder_32bit(  
    input [31:0] A,  
    input [31:0] B,  
    output [31:0] SUM,  
    output OVF  
);  
    assign {OVF, SUM} = A + B;  
endmodule