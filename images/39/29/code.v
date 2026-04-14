module fir_filter (  
    input [4:0] x0,  
    input [4:0] x1,  
    input [4:0] x2,  
    input [4:0] x3,  
    input [4:0] x4,  
    output reg [4:0] y  
);  
    always @(*) begin  
        y = x0 + x1 + x2 + x3 + x4;  
    end  
endmodule