module DynamicRangeCompressor (
    input wire clk,
    input wire reset,
    input wire [15:0] input_signal, // 16-bit audio input
    input wire [15:0] threshold,     // 16-bit threshold value
    output reg [15:0] output_signal   // 16-bit processed output
);
    parameter RATIO = 4; // Compression ratio

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 16'b0;
        end else begin
            if (input_signal > threshold) begin
                output_signal <= input_signal / RATIO;
            end else begin
                output_signal <= input_signal;
            end
        end
    end
endmodule