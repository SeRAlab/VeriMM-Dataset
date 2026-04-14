module audio_compressor (
    input clk,
    input [15:0] audio_in,
    output reg [7:0] audio_out
);

always @(posedge clk) begin
    audio_out <= audio_in[15:8]; // Take the most significant 8 bits
end

endmodule