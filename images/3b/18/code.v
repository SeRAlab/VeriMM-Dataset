module fir_filter (
    input wire clk,
    input wire [15:0] x,           // 16-bit input signal
    output reg [15:0] y            // 16-bit output signal
);
    reg [15:0] coeffs [0:31];      // Coefficients
    reg [15:0] samples [0:31];     // Delay line for input samples
    integer i;

    initial begin
        // Initialize coefficients (example values)
        coeffs[0] = 16'h0001; coeffs[1] = 16'h0001; coeffs[2] = 16'h0001; coeffs[3] = 16'h0001;
        coeffs[4] = 16'h0001; coeffs[5] = 16'h0001; coeffs[6] = 16'h0001; coeffs[7] = 16'h0001;
        coeffs[8] = 16'h0001; coeffs[9] = 16'h0001; coeffs[10] = 16'h0001; coeffs[11] = 16'h0001;
        coeffs[12] = 16'h0001; coeffs[13] = 16'h0001; coeffs[14] = 16'h0001; coeffs[15] = 16'h0001;
        coeffs[16] = 16'h0001; coeffs[17] = 16'h0001; coeffs[18] = 16'h0001; coeffs[19] = 16'h0001;
        coeffs[20] = 16'h0001; coeffs[21] = 16'h0001; coeffs[22] = 16'h0001; coeffs[23] = 16'h0001;
        coeffs[24] = 16'h0001; coeffs[25] = 16'h0001; coeffs[26] = 16'h0001; coeffs[27] = 16'h0001;
        coeffs[28] = 16'h0001; coeffs[29] = 16'h0001; coeffs[30] = 16'h0001; coeffs[31] = 16'h0001;
    end

    always @(posedge clk) begin
        // Shift the samples
        for (i = 31; i > 0; i = i - 1) begin
            samples[i] <= samples[i-1];
        end
        samples[0] <= x;

        // Compute the output
        y <= 16'h0000; // Clear output
        for (i = 0; i < 32; i = i + 1) begin
            y <= y + (samples[i] * coeffs[i]);
        end
    end
endmodule