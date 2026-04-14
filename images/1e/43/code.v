module iir_filter (
    input clk,
    input reset,
    input signed [15:0] x, // Input sample
    output reg signed [15:0] y // Output sample
);
    // Coefficients (example values)
    parameter signed [15:0] a1 = 16'h0A00;
    parameter signed [15:0] a2 = 16'h0B00;
    parameter signed [15:0] a3 = 16'h0C00;
    parameter signed [15:0] a4 = 16'h0D00;
    parameter signed [15:0] b0 = 16'h1F00;
    parameter signed [15:0] b1 = 16'h1E00;
    parameter signed [15:0] b2 = 16'h1D00;
    parameter signed [15:0] b3 = 16'h1C00;
    parameter signed [15:0] b4 = 16'h1B00;

    // Internal variables
    reg signed [15:0] z [0:4]; // Delay elements
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 0;
            for (i = 0; i < 5; i = i + 1) begin
                z[i] <= 0;
            end
        end else begin
            // Shift delay elements
            z[4] <= z[3];
            z[3] <= z[2];
            z[2] <= z[1];
            z[1] <= z[0];
            z[0] <= x;

            // Compute output
            y <= (b0 * z[0] + b1 * z[1] + b2 * z[2] + b3 * z[3] + b4 * z[4]) >> 8
                 - (a1 * z[1] + a2 * z[2] + a3 * z[3] + a4 * z[4]) >> 8;
        end
    end
endmodule