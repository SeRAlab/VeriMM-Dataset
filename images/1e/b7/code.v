module chebyshev_filter (  
    input wire [15:0] x1,  
    input wire [15:0] x2,  
    output wire [15:0] y  
);  
    parameter a0 = 16'h1F; // Coefficient for x1  
    parameter a1 = 16'h1E; // Coefficient for x2  
    parameter b1 = 16'h1D; // Feedback coefficient for y  
   
    reg [15:0] y_reg;  
   
    always @(*) begin  
        y_reg = (a0 * x1 + a1 * x2 - b1 * y_reg) >> 8;  
    end  
   
    assign y = y_reg;  
endmodule