module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x, // input signal
    output reg signed [15:0] y // output signal
);  
    reg signed [15:0] a1, a2; // feedback coefficients
    reg signed [15:0] b0, b1, b2; // feedforward coefficients
    reg signed [15:0] x1, x2; // previous inputs
    reg signed [15:0] y1, y2; // previous outputs

    initial begin
        a1 = 16'sd1; // example coefficient
        a2 = 16'sd0; // example coefficient
        b0 = 16'sd1; // example coefficient
        b1 = 16'sd0; // example coefficient
        b2 = 16'sd0; // example coefficient
        x1 = 16'sd0; // initial state
        x2 = 16'sd0; // initial state
        y1 = 16'sd0; // initial state
        y2 = 16'sd0; // initial state
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x1 <= 16'sd0;
            x2 <= 16'sd0;
            y1 <= 16'sd0;
            y2 <= 16'sd0;
            y <= 16'sd0;
        end else begin
            // IIR filter formula
            y <= (b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >>> 15; // scale down
            // Update states
            x2 <= x1;
            x1 <= x;
            y2 <= y1;
            y1 <= y;
        end
    end  
endmodule