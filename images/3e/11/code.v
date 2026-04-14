module dynamic_range_compressor (
    input wire clk,
    input wire [11:0] audio_in,
    input wire [1:0] gain_factor,  // 0: 1x, 1: 1.5x, 2: 2x, 3: 3x
    input wire [11:0] threshold,
    output reg [11:0] audio_out
);
    always @(posedge clk) begin
        if (audio_in > threshold) begin
            case (gain_factor)
                2'b00: audio_out <= audio_in; // No compression
                2'b01: audio_out <= audio_in >> 1; // 1.5x compression (approx)
                2'b10: audio_out <= audio_in >> 1; // 2x compression
                2'b11: audio_out <= audio_in >> 2; // 3x compression
                default: audio_out <= audio_in;
            endcase
        end else begin
            audio_out <= audio_in; // No change for signals below threshold
        end
    end
endmodule