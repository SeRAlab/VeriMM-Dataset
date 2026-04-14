module fir_filter (  
    input [3:0] x0,  
    input [3:0] x1,  
    input [3:0] x2,  
    input [3:0] x3,  
    output reg [7:0] y  
);  
    always @(*) begin  
        y = (1 * x0) + (2 * x1) + (3 * x2) + (4 * x3);  
    end  
endmodule