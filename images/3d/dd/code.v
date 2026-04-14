module echo_cancellation (
    input [7:0] input_signal,
    input [7:0] echo_signal,
    output reg [7:0] output_signal
);
    always @(*) begin
        output_signal = input_signal - echo_signal;
    end
endmodule