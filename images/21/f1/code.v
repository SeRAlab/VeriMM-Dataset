module dynamic_range_compressor (
    input clk,
    input rst,
    input signed [15:0] audio_in,
    input signed [15:0] threshold,
    input signed [15:0] ratio, // ratio * 256, so 1.0 = 256, 2.0 = 512, etc.
    output reg signed [15:0] audio_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            audio_out <= 16'd0;
        end else begin
            if (audio_in > threshold) begin
                audio_out <= (audio_in - threshold) * ratio / 256 + threshold;
            end else begin
                audio_out <= audio_in;
            end
        end
    end
endmodule