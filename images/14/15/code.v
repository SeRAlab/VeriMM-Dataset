module audio_compressor (
    input wire clk,
    input wire [15:0] audio_in,
    input wire [1:0] compression_select,
    output reg [15:0] audio_out
);
    
    always @(posedge clk) begin
        case (compression_select)
            2'b00: audio_out <= audio_in; // No compression
            2'b01: audio_out <= audio_in >> 1; // Mild compression
            2'b10: audio_out <= audio_in >> 2; // Medium compression
            2'b11: audio_out <= audio_in >> 3; // High compression
            default: audio_out <= audio_in; // Default to no compression
        endcase
    end
endmodule