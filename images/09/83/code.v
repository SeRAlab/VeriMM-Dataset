module echo_cancellation (
    input clk,
    input rst,
    input signed [15:0] audio_in,
    input signed [15:0] echo_in,
    output reg signed [15:0] audio_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            audio_out <= 16'b0;
        end else begin
            audio_out <= audio_in - echo_in;
        end
    end
endmodule