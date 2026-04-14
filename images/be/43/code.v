module top_module(
    input [7:0] a,      
    input [7:0] b,      
    input [2:0] op,     
    output [7:0] x,     
    output [7:0] y      
    );assign {y,x} = (op==0) ? (a + b)       : (                        
                   (op==1) ? (a - b)       : (                        
                   (op==2) ? (a * b)       : (                        
                   (op==3) ? {7'b0,a,1'b0} : (                  
                   (op==4) ? {9'b0,a[7:1]} : 16'b0))));    
endmodule