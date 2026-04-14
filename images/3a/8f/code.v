module chebyshev_filter (  
    input [4:0] x,  
    output reg [4:0] y  
);  
    // Coefficients for a 5th order Chebyshev filter (example values)  
    parameter [4:0] a0 = 5'b00001;  
    parameter [4:0] a1 = 5'b00010;  
    parameter [4:0] a2 = 5'b00011;  
    parameter [4:0] a3 = 5'b00100;  
    parameter [4:0] a4 = 5'b00101;  

    always @(*) begin  
        // Simple filter equation: y = a0*x + a1*x + a2*x + a3*x + a4*x  
        y = (a0 * x + a1 * x + a2 * x + a3 * x + a4 * x) >> 2; // Right shift to scale  
    end  
endmodule