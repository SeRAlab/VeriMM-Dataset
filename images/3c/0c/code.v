module IIR_Filter (
    input clk,
    input reset,
    input signed [15:0] input_sample,
    output reg signed [15:0] output_sample
);
    parameter signed [15:0] a = 16'h0A00; // Example coefficient for 'a'
    parameter signed [15:0] b = 16'h0B00; // Example coefficient for 'b'

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_sample <= 16'b0;
        end else begin
            output_sample <= (a * input_sample + b * output_sample) >>> 10; // Shift right to adjust for fixed-point
        end
    end
endmodule