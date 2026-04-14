module iir_filter(
    input clk,
    input rst,
    input signed [15:0] x,   // input sample
    output reg signed [15:0] y // output sample
);
    reg signed [15:0] x1, x2;  // previous inputs
    reg signed [15:0] y1, y2;  // previous outputs
    
    // Coefficients (example values, can be changed)
    parameter signed [15:0] a1 = 16'd16384; // 0.5 in fixed-point
    parameter signed [15:0] a2 = 16'd8192;  // 0.25 in fixed-point
    parameter signed [15:0] b0 = 16'd32768; // 1.0 in fixed-point
    parameter signed [15:0] b1 = 16'd16384; // 0.5 in fixed-point

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'd0;
            x1 <= 16'd0;
            x2 <= 16'd0;
            y1 <= 16'd0;
            y2 <= 16'd0;
        end else begin
            // Shift previous samples
            x2 <= x1;
            x1 <= x;
            y2 <= y1;
            // Calculate current output
            y <= (a1 * y1) + (a2 * y2) + (b0 * x) + (b1 * x1);
            y1 <= y; // Update previous output
        end
    end
endmodule