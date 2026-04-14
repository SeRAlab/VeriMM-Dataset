module fir_filter (  
    input [15:0] x0,  
    input [15:0] x1,  
    input [15:0] x2,  
    input [15:0] x3,  
    output reg [31:0] y  
);  
    // Coefficients (example values)  
    parameter [15:0] c0 = 16'h0001;  
    parameter [15:0] c1 = 16'h0002;  
    parameter [15:0] c2 = 16'h0003;  
    parameter [15:0] c3 = 16'h0004;  
    
    always @(*) begin  
        // Calculate output y  
        y = (c0 * x0) + (c1 * x1) + (c2 * x2) + (c3 * x3);  
    end  
endmodule