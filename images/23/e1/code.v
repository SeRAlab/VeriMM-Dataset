module dynamic_range_compressor (
    input clk,
    input rst,
    input signed [3:0] audio_in,
    output reg signed [3:0] audio_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            audio_out <= 4'b0000;
        end else begin
            if (audio_in > 4'd7) begin
                audio_out <= audio_in - 4'd3; // compress the input
            end else begin
                audio_out <= audio_in; // no compression
            end
        end
    end
endmodule