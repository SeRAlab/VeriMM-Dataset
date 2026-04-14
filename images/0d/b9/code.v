module audio_compressor(
    input clk,
    input reset,
    input signed [15:0] audio_in,
    input signed [15:0] threshold,
    input signed [15:0] compression_factor,
    output reg signed [15:0] audio_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            audio_out <= 16'b0;
        end else begin
            if (audio_in > threshold) begin
                audio_out <= audio_in / compression_factor;
            end else begin
                audio_out <= audio_in;
            end
        end
    end
endmodule