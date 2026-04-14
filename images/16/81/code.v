module audio_compressor (
    input clk,
    input rst,
    input enable,
    input [15:0] audio_in,
    input [15:0] threshold,
    input [15:0] gain,
    output reg [15:0] audio_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            audio_out <= 16'b0;
        end else if (enable) begin
            if (audio_in > threshold) begin
                audio_out <= audio_in * gain;
            end else begin
                audio_out <= audio_in;
            end
        end else begin
            audio_out <= 16'b0; // Default value when not enabled
        end
    end
endmodule