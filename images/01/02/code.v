module fir_filter (  
    input [2:0] x,  
    output [4:0] y  
);  
    assign y = (x[2] * 1) + (x[1] * 2) + (x[0] * 1);  
endmodule