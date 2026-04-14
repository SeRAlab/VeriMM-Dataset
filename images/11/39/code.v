module fir_filter(  
    input [7:0] x0,  
    input [7:0] x1,  
    input [7:0] x2,  
    input [7:0] x3,  
    output [15:0] y  
);  
    assign y = (1 * x0) + (2 * x1) + (3 * x2) + (4 * x3);  
endmodule