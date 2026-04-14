module fir_filter (
    input wire clk,
    input wire [15:0] x_in,
    output reg [15:0] y_out
);
    reg [15:0] coeffs [0:31]; // Coefficients initialization
    reg [15:0] x_buf [0:31];  // Buffer for input samples
    integer i;

    initial begin
        // Example coefficients initialization, replace with actual values
        coeffs[0] = 16'h0001; coeffs[1] = 16'h0002; coeffs[2] = 16'h0003; coeffs[3] = 16'h0004;
        coeffs[4] = 16'h0005; coeffs[5] = 16'h0006; coeffs[6] = 16'h0007; coeffs[7] = 16'h0008;
        coeffs[8] = 16'h0009; coeffs[9] = 16'h000A; coeffs[10] = 16'h000B; coeffs[11] = 16'h000C;
        coeffs[12] = 16'h000D; coeffs[13] = 16'h000E; coeffs[14] = 16'h000F; coeffs[15] = 16'h0010;
        coeffs[16] = 16'h0011; coeffs[17] = 16'h0012; coeffs[18] = 16'h0013; coeffs[19] = 16'h0014;
        coeffs[20] = 16'h0015; coeffs[21] = 16'h0016; coeffs[22] = 16'h0017; coeffs[23] = 16'h0018;
        coeffs[24] = 16'h0019; coeffs[25] = 16'h001A; coeffs[26] = 16'h001B; coeffs[27] = 16'h001C;
        coeffs[28] = 16'h001D; coeffs[29] = 16'h001E; coeffs[30] = 16'h001F; coeffs[31] = 16'h0020;
    end

    always @(posedge clk) begin
        // Shift the input buffer
        for (i = 31; i > 0; i = i - 1) begin
            x_buf[i] = x_buf[i - 1];
        end
        x_buf[0] = x_in;

        // Compute the FIR output
        y_out = 16'h0000;
        for (i = 0; i < 32; i = i + 1) begin
            y_out = y_out + (x_buf[i] * coeffs[i]);
        end
    end
endmodule