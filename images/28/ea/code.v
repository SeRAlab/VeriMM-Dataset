module iir_filter (
    input clk,
    input rst,
    input [15:0] x,  // Current input
    output reg [15:0] y // Current output
);
    parameter a = 16'h0001; // Feedforward coefficient
    parameter b = 16'h0001; // Feedback coefficient

    reg [15:0] y_prev; // Previous output

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0000;
            y_prev <= 16'h0000;
        end else begin
            y <= (a * x) + (b * y_prev);
            y_prev <= y;
        end
    end
endmodule