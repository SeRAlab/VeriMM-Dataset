module FIR_Filter (  
    input [3:0] x,  
    output [4:0] y  
);  
    assign y = x + x + x + x; // 4 taps with coefficient 1  
endmodule