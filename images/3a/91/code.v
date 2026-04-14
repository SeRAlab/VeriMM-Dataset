module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x_in,
    output reg signed [15:0] y_out
);
    parameter signed [15:0] a1 = 16'h0001; // Example coefficients
    parameter signed [15:0] a2 = 16'h0001;
    parameter signed [15:0] b0 = 16'h0001;
    parameter signed [15:0] b1 = 16'h0001;
    
    reg signed [15:0] y1, y2;
    reg signed [15:0] x1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 0;
            y1 <= 0;
            y2 <= 0;
            x1 <= 0;
        end else begin
            y_out <= (a1 * y1) + (a2 * y2) + (b0 * x_in) + (b1 * x1);
            y2 <= y1;
            y1 <= y_out;
            x1 <= x_in;
        end
    end
endmodule