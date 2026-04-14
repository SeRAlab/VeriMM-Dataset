module butterworth_filter(
    input [3:0] x,       // 4-bit input signal
    input clk,           // Clock signal
    output reg [3:0] y   // 4-bit output signal
);
    reg [3:0] x_prev1, x_prev2; // Previous input values
    reg [3:0] y_prev1, y_prev2; // Previous output values

    always @(posedge clk) begin
        // Implementing a simple 2nd order Butterworth filter: 
        // y[n] = (b0*x[n] + b1*x[n-1] + b2*x[n-2] - a1*y[n-1] - a2*y[n-2]) / (b0 + b1 + b2)
        // For simplicity, let's assume b0, b1, b2 = 1 and a1, a2 = 2 to create a Butterworth-like response.
        y <= (x + x_prev1 + x_prev2 - 2*y_prev1 - 2*y_prev2) >> 2; // Right shift to divide by 4

        // Shift previous values
        x_prev2 <= x_prev1;
        x_prev1 <= x;
        y_prev2 <= y_prev1;
        y_prev1 <= y;
    end
endmodule