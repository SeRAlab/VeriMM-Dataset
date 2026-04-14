module fir_filter (
    input wire clk,
    input wire [31:0] x, // Input signal
    output reg [31:0] y // Output signal
);
    reg [31:0] h [0:31]; // Coefficients
    reg [31:0] x_reg [0:31]; // Delay line
    integer i;

    initial begin
        // Initialize coefficients (example coefficients)
        h[0] = 32'h0001; h[1] = 32'h0002; h[2] = 32'h0003; h[3] = 32'h0004;
        h[4] = 32'h0005; h[5] = 32'h0006; h[6] = 32'h0007; h[7] = 32'h0008;
        h[8] = 32'h0009; h[9] = 32'h000A; h[10] = 32'h000B; h[11] = 32'h000C;
        h[12] = 32'h000D; h[13] = 32'h000E; h[14] = 32'h000F; h[15] = 32'h0010;
        h[16] = 32'h0011; h[17] = 32'h0012; h[18] = 32'h0013; h[19] = 32'h0014;
        h[20] = 32'h0015; h[21] = 32'h0016; h[22] = 32'h0017; h[23] = 32'h0018;
        h[24] = 32'h0019; h[25] = 32'h001A; h[26] = 32'h001B; h[27] = 32'h001C;
        h[28] = 32'h001D; h[29] = 32'h001E; h[30] = 32'h001F; h[31] = 32'h0020;
    end

    always @(posedge clk) begin
        // Shift the input signal through the delay line
        for (i = 31; i > 0; i = i - 1) begin
            x_reg[i] <= x_reg[i - 1];
        end
        x_reg[0] <= x;

        // Compute the output using the FIR filter equation
        y <= 0; // Reset output
        for (i = 0; i < 32; i = i + 1) begin
            y <= y + (x_reg[i] * h[i]);
        end
    end
endmodule