module audio_mixer (
    input wire clk,
    input wire enable,
    input wire [7:0] audio_in1,
    input wire [7:0] audio_in2,
    output reg [7:0] mixed_out
);

    always @(posedge clk) begin
        if (enable) begin
            mixed_out <= (audio_in1 + audio_in2) >> 1; // Average the two audio signals
        end
    end
endmodule