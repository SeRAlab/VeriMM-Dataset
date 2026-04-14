module fir_filter (  
    input [3:0] x0, // most recent sample  
    input [3:0] x1,  
    input [3:0] x2,  
    input [3:0] x3, // oldest sample  
    output reg [7:0] y // 8-bit output to accommodate sum  
);  
    always @(*) begin  
        // Coefficients: {1, 2, 3, 4}  
        y = (1 * x0) + (2 * x1) + (3 * x2) + (4 * x3);  
    end  
endmodule