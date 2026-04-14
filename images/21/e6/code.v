module fft_4point (
    input clk,
    input [15:0] x0, // First input sample (real, imaginary)
    input [15:0] x1, // Second input sample (real, imaginary)
    input [15:0] x2, // Third input sample (real, imaginary)
    input [15:0] x3, // Fourth input sample (real, imaginary)
    output reg [15:0] y0, // Output sample 0
    output reg [15:0] y1, // Output sample 1
    output reg [15:0] y2, // Output sample 2
    output reg [15:0] y3  // Output sample 3
);
    reg [15:0] stage0 [0:3]; // Internal storage for stage 0 results
    reg [15:0] stage1 [0:3]; // Internal storage for stage 1 results
    
    always @(posedge clk) begin
        // Stage 0: Calculate the basic butterflies
        stage0[0] <= x0 + x1; // Y0 = X0 + X1
        stage0[1] <= x0 - x1; // Y1 = X0 - X1
        stage0[2] <= x2 + x3; // Y2 = X2 + X3
        stage0[3] <= x2 - x3; // Y3 = X2 - X3
        
        // Stage 1: Calculate the final butterflies
        y0 <= stage0[0] + stage0[2]; // Y0 = Y0 + Y2
        y1 <= stage0[1] + (stage0[3] * 16'h0_0000); // Y1 = Y1 + j*Y3
        y2 <= stage0[0] - stage0[2]; // Y2 = Y0 - Y2
        y3 <= stage0[1] - (stage0[3] * 16'h0_0000); // Y3 = Y1 - j*Y3
    end
endmodule