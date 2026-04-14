module audio_compressor(
    input wire clk,
    input wire reset,
    input wire [15:0] audio_in,
    output reg [7:0] audio_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        audio_out <= 8'b0;
    end else begin
        audio_out <= audio_in[15:8]; // Reduce to 8 bits by taking the upper 8 bits
    end
end

endmodule