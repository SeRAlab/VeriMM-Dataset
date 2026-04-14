module butterworth_filter (
    input clk,
    input rst,
    input [3:0] x, // input signal
    output reg [3:0] y // output signal
);
    reg [3:0] x_prev1, x_prev2; // previous inputs
    reg [3:0] y_prev1, y_prev2; // previous outputs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_prev1 <= 4'b0000;
            x_prev2 <= 4'b0000;
            y_prev1 <= 4'b0000;
            y_prev2 <= 4'b0000;
            y <= 4'b0000;
        end else begin
            // Implementing Butterworth filter coefficients
            y <= (x + x_prev1 + x_prev2 - y_prev1 - y_prev2) >> 1;
            // Update previous values
            x_prev2 <= x_prev1;
            x_prev1 <= x;
            y_prev2 <= y_prev1;
            y_prev1 <= y;
        end
    end
endmodule