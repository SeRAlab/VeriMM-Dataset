module multiplier_64bit (  
    input [63:0] a,  
    input [63:0] b,  
    output [127:0] result  
);  
    assign result = a * b;  
endmodule