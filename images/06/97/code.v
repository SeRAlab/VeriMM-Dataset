module IIR_Filter (
    input wire clk,
    input wire rst,
    input wire signed [15:0] x_in,
    output reg signed [15:0] y_out
);
    parameter signed [15:0] b0 = 16'h1A2B;
    parameter signed [15:0] b1 = 16'h0C3D;
    parameter signed [15:0] b2 = 16'h0B1C;
    parameter signed [15:0] a1 = 16'hF6E1;
    parameter signed [15:0] a2 = 16'hF97E;

    reg signed [15:0] x [0:2]; // Previous inputs
    reg signed [15:0] y [0:2]; // Previous outputs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x[0] <= 16'd0;
            x[1] <= 16'd0;
            x[2] <= 16'd0;
            y[0] <= 16'd0;
            y[1] <= 16'd0;
            y[2] <= 16'd0;
            y_out <= 16'd0;
        end else begin
            // Shift samples
            x[2] <= x[1];
            x[1] <= x[0];
            x[0] <= x_in;

            y[2] <= y[1];
            y[1] <= y[0];
            y[0] <= (b0 * x[0] + b1 * x[1] + b2 * x[2] - a1 * y[1] - a2 * y[2]) >>> 15; // Right shift to maintain scale

            y_out <= y[0];
        end
    end
endmodule