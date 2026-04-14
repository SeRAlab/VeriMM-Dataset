module fft_4point (
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

reg [15:0] temp_real[0:3];
reg [15:0] temp_imag[0:3];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        y0_real <= 0; y0_imag <= 0;
        y1_real <= 0; y1_imag <= 0;
        y2_real <= 0; y2_imag <= 0;
        y3_real <= 0; y3_imag <= 0;
    end else begin
        // Stage 1
        temp_real[0] <= x0_real + x1_real;
        temp_imag[0] <= x0_imag + x1_imag;
        temp_real[1] <= x0_real - x1_real;
        temp_imag[1] <= x0_imag - x1_imag;
        temp_real[2] <= x2_real + x3_real;
        temp_imag[2] <= x2_imag + x3_imag;
        temp_real[3] <= x2_real - x3_real;
        temp_imag[3] <= x2_imag - x3_imag;

        // Stage 2
        y0_real <= temp_real[0] + temp_real[2];
        y0_imag <= temp_imag[0] + temp_imag[2];
        y1_real <= temp_real[1] + (temp_real[3] * 0); // W = 1
        y1_imag <= temp_imag[1] + (temp_imag[3] * 0);
        y2_real <= temp_real[0] - temp_real[2];
        y2_imag <= temp_imag[0] - temp_imag[2];
        y3_real <= temp_real[1] - (temp_real[3] * 0);
        y3_imag <= temp_imag[1] - (temp_imag[3] * 0);
    end
end

endmodule