module dwt_1d (  
    input clk,  
    input rst,  
    input [15:0] signal_in,  
    output reg [7:0] approx_out,  
    output reg [7:0] detail_out  
);  

    // Fixed coefficients for DWT (simple example, not actual wavelet coefficients)  
    parameter COEFF_LP = 8'h1C; // Low-pass filter coefficient  
    parameter COEFF_HP = 8'h1A; // High-pass filter coefficient  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            approx_out <= 8'b0;  
            detail_out <= 8'b0;  
        end else begin  
            approx_out <= (signal_in[15:8] * COEFF_LP) >> 8; // Approximation  
            detail_out <= (signal_in[7:0] * COEFF_HP) >> 8;  // Detail  
        end  
    end  
endmodule