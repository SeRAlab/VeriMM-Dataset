module fir_filter (  
    input [3:0] x,  
    output reg [3:0] y  
);  
    // Fixed coefficients for the 4-tap FIR filter  
    reg [3:0] h [0:3];  
    always @(*) begin  
        // Initialize coefficients  
        h[0] = 4'b0001;  
        h[1] = 4'b0010;  
        h[2] = 4'b0011;  
        h[3] = 4'b0100;  
        
        // Compute the output using the coefficients  
        y = (x * h[0]) + (x * h[1]) + (x * h[2]) + (x * h[3]);  
    end  
endmodule