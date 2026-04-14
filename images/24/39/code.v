module dynamic_range_compressor(
    input clk,
    input rst,
    input signed [9:0] in_signal,
    input signed [9:0] threshold,
    input [3:0] compression_ratio, // Represents the amount of compression
    output reg signed [7:0] out_signal
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out_signal <= 8'b0;
    end else begin
        if (in_signal > threshold) begin
            // Compress the signal based on compression ratio
            out_signal <= in_signal >> compression_ratio; // Simple right shift for compression
        end else begin
            // Pass through
            out_signal <= in_signal[7:0]; // Truncate to 8 bits
        end
    end
end

endmodule