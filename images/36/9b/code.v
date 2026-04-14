module DWT_Haar (  
    input [7:0] x0,  
    input [7:0] x1,  
    input [7:0] x2,  
    input [7:0] x3,  
    output [7:0] y0,  
    output [7:0] y1  
);  
assign y0 = (x0 + x1 + x2 + x3) >> 2;  // Average  
assign y1 = (x0 - x1 + x2 - x3) >> 2;  // Detail  
endmodule