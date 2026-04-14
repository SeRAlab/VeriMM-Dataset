module echo_cancellation (
    input wire [15:0] audio_signal,
    input wire [15:0] echo_signal,
    output reg [15:0] output_signal
);
    always @(audio_signal, echo_signal) begin
        output_signal = audio_signal - echo_signal;
    end
endmodule