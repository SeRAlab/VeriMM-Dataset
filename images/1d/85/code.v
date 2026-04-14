module dynamic_range_compressor (
    input wire clk,
    input wire rst,
    input wire signed [15:0] input_signal,
    output reg signed [15:0] output_signal
);
    parameter THRESHOLD = 16'd1000; // Compression threshold
    parameter RATIO = 16'd2;         // Compression ratio

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_signal <= 16'd0;
        end else begin
            if (input_signal > THRESHOLD) begin
                output_signal <= THRESHOLD + (input_signal - THRESHOLD) / RATIO;
            end else begin
                output_signal <= input_signal;
            end
        end
    end
endmodule