module iir_filter (
    input clk,
    input rst,
    input [15:0] x, // Input sample
    output reg [15:0] y // Output sample
);
    // Coefficients for the filter (these are example values)
    parameter signed [15:0] b0 = 16'h0A00; // Feedforward coefficient
    parameter signed [15:0] b1 = 16'h0A00;
    parameter signed [15:0] b2 = 16'h0A00;
    parameter signed [15:0] b3 = 16'h0A00;
    parameter signed [15:0] b4 = 16'h0A00;
    parameter signed [15:0] a1 = 16'hFF00; // Feedback coefficient
    parameter signed [15:0] a2 = 16'hFF00;
    parameter signed [15:0] a3 = 16'hFF00;
    parameter signed [15:0] a4 = 16'hFF00;

    reg signed [31:0] x_reg[0:4]; // Input history
    reg signed [31:0] y_reg[0:4]; // Output history

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'b0;
            x_reg[0] <= 32'b0;
            x_reg[1] <= 32'b0;
            x_reg[2] <= 32'b0;
            x_reg[3] <= 32'b0;
            x_reg[4] <= 32'b0;
            y_reg[0] <= 32'b0;
            y_reg[1] <= 32'b0;
            y_reg[2] <= 32'b0;
            y_reg[3] <= 32'b0;
            y_reg[4] <= 32'b0;
        end else begin
            // Shift the input samples
            x_reg[4] <= x_reg[3];
            x_reg[3] <= x_reg[2];
            x_reg[2] <= x_reg[1];
            x_reg[1] <= x_reg[0];
            x_reg[0] <= x;

            // Shift the output samples
            y_reg[4] <= y_reg[3];
            y_reg[3] <= y_reg[2];
            y_reg[2] <= y_reg[1];
            y_reg[1] <= y_reg[0];
            y_reg[0] <= y;

            // Calculate output
            y <= (b0 * x_reg[0] + b1 * x_reg[1] + b2 * x_reg[2] + b3 * x_reg[3] + b4 * x_reg[4]
                 - a1 * y_reg[1] - a2 * y_reg[2] - a3 * y_reg[3] - a4 * y_reg[4]) >> 15; // Adjust for fixed-point
        end
    end
endmodule