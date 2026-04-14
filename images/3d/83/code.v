module dynamic_range_compressor (
    input wire clk,
    input wire rst,
    input wire signed [15:0] audio_in,
    input wire signed [15:0] threshold,
    input wire [7:0] compression_ratio, // 0-255 (0 means no compression, 255 means full compression)
    output reg signed [15:0] audio_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            audio_out <= 16'sd0;
        end else begin
            if (audio_in > threshold) begin
                audio_out <= (audio_in - threshold) * compression_ratio / 255 + threshold;
            end else begin
                audio_out <= audio_in;
            end
        end
    end
endmodule