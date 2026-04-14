module butterworth_filter (
    input [4:0] x,      // 5-bit input
    input clk,          // Clock signal (not used in combinational logic)
    output reg [4:0] y  // 5-bit output
);
    reg [4:0] x_prev1, x_prev2;  // Previous inputs
    reg [4:0] y_prev1, y_prev2;  // Previous outputs

    always @(*) begin
        // Butterworth filter difference equation
        y = (x + x_prev1 + x_prev2 - y_prev1 - y_prev2) >> 2; // Simple example equation
        // Update previous values
        x_prev2 = x_prev1;
        x_prev1 = x;
        y_prev2 = y_prev1;
        y_prev1 = y;
    end
endmodule