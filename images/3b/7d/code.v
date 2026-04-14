module FIR_Filter (  
    input [4:0] x,  
    output [4:0] y  
);  
    wire [4:0] x_shifted1;  
    wire [4:0] x_shifted2;  

    assign x_shifted1 = {1'b0, x[4:1]};  
    assign x_shifted2 = {2'b00, x[4:2]};  

    assign y = (x * 1) + (x_shifted1 * 2) + (x_shifted2 * 1);  
endmodule