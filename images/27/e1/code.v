module fir_filter #(parameter COEFF_WIDTH = 16, NUM_TAPS = 8) (
    input clk,
    input [15:0] x_in,
    output reg [15:0] y_out
);
    reg [15:0] coeffs [0:NUM_TAPS-1];
    reg [15:0] samples [0:NUM_TAPS-1];
    integer i;

    initial begin
        // Define coefficients (example values)
        coeffs[0] = 16'h0001;
        coeffs[1] = 16'h0002;
        coeffs[2] = 16'h0003;
        coeffs[3] = 16'h0004;
        coeffs[4] = 16'h0005;
        coeffs[5] = 16'h0006;
        coeffs[6] = 16'h0007;
        coeffs[7] = 16'h0008;
    end

    always @(posedge clk) begin
        // Shift samples
        for (i = NUM_TAPS-1; i > 0; i = i - 1) begin
            samples[i] <= samples[i-1];
        end
        samples[0] <= x_in;

        // Calculate output
        y_out <= 0;
        for (i = 0; i < NUM_TAPS; i = i + 1) begin
            y_out <= y_out + (samples[i] * coeffs[i]);
        end
    end
endmodule