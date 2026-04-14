module audio_mixer (
    input clk,
    input [7:0] audio_in1,
    input [7:0] audio_in2,
    input [2:0] vol_ctrl1,
    input [2:0] vol_ctrl2,
    output reg [8:0] mixed_audio_out
);

    always @(posedge clk) begin
        mixed_audio_out <= (audio_in1 * vol_ctrl1) + (audio_in2 * vol_ctrl2);
    end

endmodule