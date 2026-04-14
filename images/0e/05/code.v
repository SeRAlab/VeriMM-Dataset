module iir_filter (
    input wire clk,
    input wire rst,
    input wire signed [15:0] x, // Input sample
    output reg signed [15:0] y // Output sample
);
    // IIR filter coefficients
    parameter signed [15:0] b0 = 16'd1; // Feedforward coefficient
    parameter signed [15:0] a1 = 16'd1; // Feedback coefficient

    reg signed [15:0] prev_x; // Previous input sample
    reg signed [15:0] prev_y; // Previous output sample

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'd0;
            prev_x <= 16'd0;
            prev_y <= 16'd0;
        end else begin
            // IIR filter equation
            y <= b0 * x + a1 * prev_y;
            prev_x <= x;
            prev_y <= y;
        end
    end
endmodule