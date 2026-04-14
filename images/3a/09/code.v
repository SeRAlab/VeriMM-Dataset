module echo_cancellation(
    input clk,
    input rst,
    input [15:0] audio_in,
    input [15:0] echo_in,
    output reg [15:0] audio_out
);

    reg [15:0] processed_audio;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            processed_audio <= 16'b0;
            audio_out <= 16'b0;
        end else begin
            processed_audio <= audio_in - echo_in; // Simple subtraction for echo cancellation
            audio_out <= processed_audio;
        end
    end
endmodule