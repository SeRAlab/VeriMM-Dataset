module iir_filter (
    input wire clk,
    input wire rst,
    input wire signed [15:0] x_in, // Input sample
    output reg signed [15:0] y_out // Output sample
);
    reg signed [15:0] x1, x2; // Previous inputs
    reg signed [15:0] y1, y2; // Previous outputs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x1 <= 0;
            x2 <= 0;
            y1 <= 0;
            y2 <= 0;
            y_out <= 0;
        end else begin
            // IIR filter equation: y[n] = b0*x[n] + b1*x[n-1] + b2*x[n-2] - a1*y[n-1] - a2*y[n-2]
            y_out <= x_in + (2 * x1) + x2 - y1 + (y2);
            // Update previous samples
            x2 <= x1;
            x1 <= x_in;
            y2 <= y1;
            y1 <= y_out;
        end
    end
endmodule