module echo_cancellation(
    input clk,
    input reset,
    input [15:0] audio_signal,
    input [15:0] echo_signal,
    output reg [15:0] output_signal
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 16'b0;
        end else begin
            output_signal <= audio_signal - echo_signal;
        end
    end
endmodule