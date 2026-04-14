module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] input_sample,
    output reg signed [15:0] output_sample
);
    reg signed [15:0] output_reg [0:1];
    parameter signed [15:0] b0 = 16'h1A2B; // Example coefficient
    parameter signed [15:0] b1 = 16'h1B2C; // Example coefficient
    parameter signed [15:0] b2 = 16'h1C2D; // Example coefficient
    parameter signed [15:0] a1 = 16'h1D2E; // Example coefficient
    parameter signed [15:0] a2 = 16'h1E2F; // Example coefficient

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_sample <= 0;
            output_reg[0] <= 0;
            output_reg[1] <= 0;
        end else begin
            output_sample <= (b0 * input_sample + b1 * output_reg[0] + b2 * output_reg[1] - a1 * output_reg[0] - a2 * output_reg[1]) >>> 15; // Scale down
            output_reg[1] <= output_reg[0];
            output_reg[0] <= output_sample;
        end
    end
endmodule