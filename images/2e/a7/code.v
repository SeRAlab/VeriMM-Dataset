module fir_filter (
    input wire clk,
    input wire reset,
    input wire [15:0] x,          // Input signal
    output reg [15:0] y           // Output signal
);
    reg [15:0] coeffs [0:7];      // Coefficients array
    reg [15:0] x_reg [0:7];       // Delay line for inputs
    integer i;

    initial begin
        // Example coefficients (these can be modified)
        coeffs[0] = 16'h0001;
        coeffs[1] = 16'h0002;
        coeffs[2] = 16'h0003;
        coeffs[3] = 16'h0004;
        coeffs[4] = 16'h0005;
        coeffs[5] = 16'h0006;
        coeffs[6] = 16'h0007;
        coeffs[7] = 16'h0008;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the delay line and output
            for (i = 0; i < 8; i = i + 1) begin
                x_reg[i] <= 16'h0000;
            end
            y <= 16'h0000;
        end else begin
            // Shift the delay line
            for (i = 7; i > 0; i = i - 1) begin
                x_reg[i] <= x_reg[i-1];
            end
            x_reg[0] <= x; // New input sample

            // Compute the output
            y <= 16'h0000; // Initialize output to zero
            for (i = 0; i < 8; i = i + 1) begin
                y <= y + (x_reg[i] * coeffs[i]);
            end
        end
    end
endmodule