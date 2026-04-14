module multiplier_32bit(  
    input [31:0] a,  
    input [31:0] b,  
    output [63:0] result  
);  
    assign result = a * b;  
endmodule