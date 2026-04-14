module iir_filter (
    input clk,
    input rst,
    input signed [7:0] x,   // Input signal
    output reg signed [7:0] y  // Filtered output signal
);
    // Coefficients (for example purposes)
    parameter signed [7:0] a1 = 8'b00001111;  // Coefficient for y[n-1]
    parameter signed [7:0] a2 = 8'b00000111;  // Coefficient for y[n-2]
    parameter signed [7:0] b1 = 8'b00001000;  // Coefficient for x[n-1]

    reg signed [7:0] y_prev1; // y[n-1]
    reg signed [7:0] y_prev2; // y[n-2]
    reg signed [7:0] x_prev;   // x[n-1]

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 8'b0;
            y_prev1 <= 8'b0;
            y_prev2 <= 8'b0;
            x_prev <= 8'b0;
        end else begin
            y <= (x * b1) + (y_prev1 * a1) + (y_prev2 * a2);
            // Update previous values
            y_prev2 <= y_prev1;
            y_prev1 <= y;
            x_prev <= x;
        end
    end
endmodule