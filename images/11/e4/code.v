module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x_n,
    input signed [15:0] x_n_1,
    output reg signed [15:0] y_n
);
    
    // Filter coefficients
    parameter signed [15:0] b0 = 16'h0A00; // Example coefficient
    parameter signed [15:0] b1 = 16'h0A00; // Example coefficient
    parameter signed [15:0] b2 = 16'h0A00; // Example coefficient
    parameter signed [15:0] a1 = 16'hF000; // Example coefficient
    parameter signed [15:0] a2 = 16'hF000; // Example coefficient
    
    reg signed [15:0] y_n_1;
    reg signed [15:0] y_n_2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_n <= 16'b0;
            y_n_1 <= 16'b0;
            y_n_2 <= 16'b0;
        end else begin
            y_n <= b0 * x_n + b1 * x_n_1 - a1 * y_n_1 - a2 * y_n_2;
            y_n_2 <= y_n_1;
            y_n_1 <= y_n;
        end
    end
endmodule