module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x, // Input sample
    output reg signed [15:0] y // Output sample
);
    // Coefficients (fixed values for simplicity)
    parameter signed [15:0] b0 = 16'h0A00; // Feedforward coefficient
    parameter signed [15:0] b1 = 16'h1400; // Feedforward coefficient
    parameter signed [15:0] b2 = 16'h0A00; // Feedforward coefficient
    parameter signed [15:0] a1 = 16'hE000; // Feedback coefficient
    parameter signed [15:0] a2 = 16'hC000; // Feedback coefficient

    reg signed [15:0] x1, x2; // Delay elements for inputs
    reg signed [15:0] y1, y2; // Delay elements for outputs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x1 <= 16'b0;
            x2 <= 16'b0;
            y1 <= 16'b0;
            y2 <= 16'b0;
            y <= 16'b0;
        end else begin
            // Apply the IIR filter equation
            y <= (b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >>> 14; // Normalize to fit in 16 bits
            
            // Shift the registers
            x2 <= x1;
            x1 <= x;
            y2 <= y1;
            y1 <= y;
        end
    end
endmodule