module IFFT_4point (
    input clk,
    input reset,
    input [15:0] x0_real, input [15:0] x0_imag,
    input [15:0] x1_real, input [15:0] x1_imag,
    input [15:0] x2_real, input [15:0] x2_imag,
    input [15:0] x3_real, input [15:0] x3_imag,
    output reg [15:0] y0_real, output reg [15:0] y0_imag,
    output reg [15:0] y1_real, output reg [15:0] y1_imag,
    output reg [15:0] y2_real, output reg [15:0] y2_imag,
    output reg [15:0] y3_real, output reg [15:0] y3_imag
);

    wire signed [15:0] temp_real [0:3];
    wire signed [15:0] temp_imag [0:3];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y0_real <= 0; y0_imag <= 0;
            y1_real <= 0; y1_imag <= 0;
            y2_real <= 0; y2_imag <= 0;
            y3_real <= 0; y3_imag <= 0;
        end else begin
            // Performing a simple IFFT operation (not the full algorithm)
            y0_real <= (x0_real + x1_real + x2_real + x3_real) >> 2;
            y0_imag <= (x0_imag + x1_imag + x2_imag + x3_imag) >> 2;
            y1_real <= (x0_real - x1_real + x2_real - x3_real) >> 2;
            y1_imag <= (x0_imag - x1_imag + x2_imag - x3_imag) >> 2;
            y2_real <= (x0_real + x1_real - x2_real - x3_real) >> 2;
            y2_imag <= (x0_imag + x1_imag - x2_imag - x3_imag) >> 2;
            y3_real <= (x0_real - x1_real - x2_real + x3_real) >> 2;
            y3_imag <= (x0_imag - x1_imag - x2_imag + x3_imag) >> 2;
        end
    end
endmodule