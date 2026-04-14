module FixedPointAdder (  
    input [15:0] a,  
    input [15:0] b,  
    output [15:0] sum  
);  
    assign sum = a + b;  
endmodule