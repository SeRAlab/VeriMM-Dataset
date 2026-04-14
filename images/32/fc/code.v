module fft_4point (
    input clk,
    input reset,
    input [15:0] x0, // First complex input (real: x0[15:8], imag: x0[7:0])
    input [15:0] x1, // Second complex input
    input [15:0] x2, // Third complex input
    input [15:0] x3, // Fourth complex input
    output reg [15:0] y0, // FFT output 0
    output reg [15:0] y1, // FFT output 1
    output reg [15:0] y2, // FFT output 2
    output reg [15:0] y3  // FFT output 3
);

reg [15:0] stage1[0:3];
reg [15:0] stage2[0:3];
integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        y0 <= 16'b0;
        y1 <= 16'b0;
        y2 <= 16'b0;
        y3 <= 16'b0;
    end else begin
        // Stage 1: Add and subtract
        stage1[0] = x0 + x1; // X0 + X1
        stage1[1] = x0 - x1; // X0 - X1
        stage1[2] = x2 + x3; // X2 + X3
        stage1[3] = x2 - x3; // X2 - X3
        
        // Stage 2: Combine results with twiddle factors
        y0 = stage1[0]; // Y0 = X0 + X1 + X2 + X3
        y1 = stage1[1] + stage1[2]; // Y1 = (X0 - X1) + (X2 + X3)
        y2 = stage1[1] - stage1[2]; // Y2 = (X0 - X1) - (X2 + X3)
        y3 = stage1[3]; // Y3 = X0 - X1 - X2 + X3
    end
end

endmodule