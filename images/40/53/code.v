module echo_cancellation (
    input clk,
    input reset,
    input [15:0] audio_in,    // Incoming audio signal
    input [15:0] echo_in,     // Delayed echo signal
    output reg [15:0] audio_out // Cleaned audio signal
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            audio_out <= 16'b0;
        end else begin
            audio_out <= audio_in - echo_in; // Basic echo cancellation
        end
    end
endmodule