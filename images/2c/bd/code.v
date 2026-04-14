module audio_compressor (
    input wire clk,
    input wire [7:0] audio_in,
    output reg [3:0] audio_out
);
    always @(posedge clk) begin
        audio_out <= audio_in[7:4]; // take the most significant 4 bits
    end
endmodule