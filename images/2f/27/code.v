module audio_compressor (
    input clk,
    input reset,
    input [15:0] audio_sample,
    output reg [7:0] compressed_output,
    output reg valid
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            compressed_output <= 8'b0;
            valid <= 0;
        end else begin
            compressed_output <= audio_sample[15:8]; // Retain the most significant 8 bits
            valid <= 1; // Signal that valid output is ready
        end
    end
endmodule