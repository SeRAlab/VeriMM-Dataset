module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x,        // Input
    output reg signed [15:0] y    // Output
);
    // Coefficients (scaled by 10 to avoid floating point)
    parameter signed [15:0] a0 = 16'd1;
    parameter signed [15:0] a1 = 16'd2;
    parameter signed [15:0] a2 = 16'd3;
    parameter signed [15:0] a3 = 16'd4;
    parameter signed [15:0] b0 = 16'd5;
    parameter signed [15:0] b1 = 16'd6;
    parameter signed [15:0] b2 = 16'd7;
    parameter signed [15:0] b3 = 16'd8;

    reg signed [15:0] x_prev[0:3]; // Previous inputs
    reg signed [15:0] y_prev[0:3]; // Previous outputs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 0;
            x_prev[0] <= 0; x_prev[1] <= 0; x_prev[2] <= 0; x_prev[3] <= 0;
            y_prev[0] <= 0; y_prev[1] <= 0; y_prev[2] <= 0; y_prev[3] <= 0;
        end else begin
            // Shift previous inputs and outputs
            x_prev[3] <= x_prev[2];
            x_prev[2] <= x_prev[1];
            x_prev[1] <= x_prev[0];
            x_prev[0] <= x;

            y_prev[3] <= y_prev[2];
            y_prev[2] <= y_prev[1];
            y_prev[1] <= y_prev[0];

            // Calculate output
            y <= (a0 * x_prev[0] + a1 * x_prev[1] + a2 * x_prev[2] + a3 * x_prev[3]
                 - b1 * y_prev[1] - b2 * y_prev[2] - b3 * y_prev[3]) >> 4; // Shifting to scale down
            y_prev[0] <= y;
        end
    end
endmodule