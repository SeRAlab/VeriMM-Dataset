module iir_filter (
    input clk,
    input rst,
    input signed [11:0] x_in,
    output reg signed [11:0] y_out
);
    reg signed [11:0] x [0:4]; // input buffer
    reg signed [11:0] y [0:4]; // output buffer

    // Coefficients (example values)
    parameter signed [11:0] b0 = 12'h01A; // b0
    parameter signed [11:0] b1 = 12'h02B; // b1
    parameter signed [11:0] b2 = 12'h03C; // b2
    parameter signed [11:0] b3 = 12'h04D; // b3
    parameter signed [11:0] b4 = 12'h05E; // b4

    parameter signed [11:0] a1 = 12'h06F; // a1
    parameter signed [11:0] a2 = 12'h07F; // a2
    parameter signed [11:0] a3 = 12'h08F; // a3
    parameter signed [11:0] a4 = 12'h09F; // a4

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 12'b0;
            x[0] <= 12'b0;
            x[1] <= 12'b0;
            x[2] <= 12'b0;
            x[3] <= 12'b0;
            x[4] <= 12'b0;
            y[0] <= 12'b0;
            y[1] <= 12'b0;
            y[2] <= 12'b0;
            y[3] <= 12'b0;
            y[4] <= 12'b0;
        end else begin
            // Shift input and output buffers
            x[4] <= x[3];
            x[3] <= x[2];
            x[2] <= x[1];
            x[1] <= x[0];
            x[0] <= x_in;

            y[4] <= y[3];
            y[3] <= y[2];
            y[2] <= y[1];
            y[1] <= y[0];

            // Compute output
            y_out <= (b0 * x[0] + b1 * x[1] + b2 * x[2] + b3 * x[3] + b4 * x[4]) >> 4; // b coefficients
            y_out <= y_out - (a1 * y[1] + a2 * y[2] + a3 * y[3] + a4 * y[4]) >> 4; // a coefficients
            y[0] <= y_out; // Store output
        end
    end
endmodule