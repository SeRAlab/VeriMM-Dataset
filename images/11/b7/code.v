module dynamic_range_compressor(
    input clk,
    input rst,
    input enable,
    input signed [15:0] audio_in,
    input [3:0] compression_ratio, // Compression ratio (1 to 15)
    output reg signed [15:0] audio_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            audio_out <= 16'b0;
        end else if (enable) begin
            if (audio_in > 0) begin
                audio_out <= audio_in / compression_ratio;
            end else begin
                audio_out <= audio_in / compression_ratio;
            end
        end else begin
            audio_out <= audio_in;
        end
    end
endmodule