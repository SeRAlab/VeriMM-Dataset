module iir_filter (
    input wire clk,
    input wire reset,
    input wire signed [15:0] x, // Input sample
    output reg signed [15:0] y // Output sample
);
    parameter signed [15:0] a1 = 16'h1; // Example coefficient a1
    parameter signed [15:0] a2 = 16'h1; // Example coefficient a2
    parameter signed [15:0] b0 = 16'h1; // Example coefficient b0
    parameter signed [15:0] b1 = 16'h1; // Example coefficient b1

    reg signed [15:0] y_prev1; // y[n-1]
    reg signed [15:0] y_prev2; // y[n-2]
    reg signed [15:0] x_prev1; // x[n-1]

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 16'b0;
            y_prev1 <= 16'b0;
            y_prev2 <= 16'b0;
            x_prev1 <= 16'b0;
        end else begin
            y <= (a1 * y_prev1) + (a2 * y_prev2) + (b0 * x) + (b1 * x_prev1);
            y_prev2 <= y_prev1;
            y_prev1 <= y;
            x_prev1 <= x;
        end
    end
endmodule