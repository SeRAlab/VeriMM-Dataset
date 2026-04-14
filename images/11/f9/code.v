module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x, // input sample
    output reg signed [15:0] y // output sample
);
    reg signed [15:0] z [0:4]; // delayed input samples
    reg signed [15:0] w [0:4]; // delayed output samples

    // Coefficients (example values)
    parameter signed [15:0] b0 = 16'h0001;
    parameter signed [15:0] b1 = 16'h0002;
    parameter signed [15:0] b2 = 16'h0001;
    parameter signed [15:0] b3 = 16'h0000;
    parameter signed [15:0] b4 = 16'h0000;
    parameter signed [15:0] a1 = 16'h0001;
    parameter signed [15:0] a2 = 16'h0000;
    parameter signed [15:0] a3 = 16'h0000;
    parameter signed [15:0] a4 = 16'h0000;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0000;
            z[0] <= 16'h0000;
            z[1] <= 16'h0000;
            z[2] <= 16'h0000;
            z[3] <= 16'h0000;
            z[4] <= 16'h0000;
            w[0] <= 16'h0000;
            w[1] <= 16'h0000;
            w[2] <= 16'h0000;
            w[3] <= 16'h0000;
            w[4] <= 16'h0000;
        end else begin
            // Update the delay lines
            z[4] <= z[3];
            z[3] <= z[2];
            z[2] <= z[1];
            z[1] <= z[0];
            z[0] <= x;

            w[4] <= w[3];
            w[3] <= w[2];
            w[2] <= w[1];
            w[1] <= w[0];
            w[0] <= y;

            // Calculate output
            y <= (b0 * z[0] + b1 * z[1] + b2 * z[2] + b3 * z[3] + b4 * z[4]) 
                - (a1 * w[1] + a2 * w[2] + a3 * w[3] + a4 * w[4]);
        end
    end
endmodule