module iir_filter (
    input clk,
    input reset,
    input [15:0] x, // input sample
    output reg [15:0] y // output sample
);
    // Filter coefficients
    parameter [15:0] b0 = 16'h0001, b1 = 16'h0002, b2 = 16'h0003; // Feedforward coefficients
    parameter [15:0] a1 = 16'h0001, a2 = 16'h0002; // Feedback coefficients

    // Internal state variables
    reg [15:0] x1, x2, y1, y2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset states
            x1 <= 16'b0;
            x2 <= 16'b0;
            y1 <= 16'b0;
            y2 <= 16'b0;
            y <= 16'b0;
        end else begin
            // IIR filter equation
            y <= b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2;
            
            // Update states
            x2 <= x1;
            x1 <= x;
            y2 <= y1;
            y1 <= y;
        end
    end
endmodule