module fir_filter(  
    input [7:0] x0,  // First input sample  
    input [7:0] x1,  // Second input sample  
    input [7:0] x2,  // Third input sample  
    output reg [9:0] y  // Output sample  
);  
    always @(*) begin  
        y = (1 * x0) + (2 * x1) + (1 * x2);  
    end  
endmodule