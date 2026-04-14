module echo_cancellation(
    input clk,
    input reset,
    input signed [15:0] input_signal,
    input signed [15:0] reference_signal,
    output reg signed [15:0] output_signal
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 16'b0;
        end else begin
            output_signal <= input_signal - reference_signal;
        end
    end
endmodule