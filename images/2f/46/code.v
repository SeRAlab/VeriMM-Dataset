module iir_filter(
    input clk,
    input rst,
    input signed [15:0] x_in,
    output reg signed [15:0] y_out
);

    parameter signed [15:0] b0 = 16'h0A00; // Feedforward coefficient
    parameter signed [15:0] b1 = 16'h0A00; // Feedforward coefficient
    parameter signed [15:0] b2 = 16'h0A00; // Feedforward coefficient
    parameter signed [15:0] a1 = 16'hF000; // Feedback coefficient
    parameter signed [15:0] a2 = 16'hF000; // Feedback coefficient

    reg signed [15:0] x_delay1, x_delay2;
    reg signed [15:0] y_delay1, y_delay2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_delay1 <= 16'h0000;
            x_delay2 <= 16'h0000;
            y_delay1 <= 16'h0000;
            y_delay2 <= 16'h0000;
            y_out <= 16'h0000;
        end else begin
            // Calculate output
            y_out <= b0 * x_in + b1 * x_delay1 + b2 * x_delay2 - a1 * y_delay1 - a2 * y_delay2;

            // Update the delay lines
            x_delay2 <= x_delay1;
            x_delay1 <= x_in;
            y_delay2 <= y_delay1;
            y_delay1 <= y_out;
        end
    end
endmodule