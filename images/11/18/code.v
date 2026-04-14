module fir_filter(  
    input wire [7:0] x0,  
    input wire [7:0] x1,  
    input wire [7:0] x2,  
    output wire [15:0] y  
);  
    assign y = (x0 * 1) + (x1 * 2) + (x2 * 1);  
endmodule