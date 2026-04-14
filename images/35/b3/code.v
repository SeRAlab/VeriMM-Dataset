module audio_mixer(
    input clk,
    input rst,
    input [7:0] audio_in1,
    input [7:0] audio_in2,
    output reg [7:0] audio_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            audio_out <= 8'b0;
        end else begin
            audio_out <= (audio_in1 + audio_in2) >> 1; // average of two inputs
        end
    end
endmodule