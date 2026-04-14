module fir_filter (
    input [4:0] x0, // Current input sample
    input [4:0] x1, // Previous input sample
    input [4:0] x2, // Two samples ago
    input [4:0] x3, // Three samples ago
    input [4:0] x4, // Four samples ago
    output reg [4:0] y // Output sample
);
    // Coefficients for the FIR filter
    reg [4:0] coeff [0:4];
    
    initial begin
        coeff[0] = 5'b00001; // Coefficient 1
        coeff[1] = 5'b00010; // Coefficient 2
        coeff[2] = 5'b00011; // Coefficient 3
        coeff[3] = 5'b00010; // Coefficient 2
        coeff[4] = 5'b00001; // Coefficient 1
    end
    
    always @(*) begin
        // Compute the output
        y = (x0 * coeff[0]) + (x1 * coeff[1]) + (x2 * coeff[2]) + (x3 * coeff[3]) + (x4 * coeff[4]);
    end
endmodule