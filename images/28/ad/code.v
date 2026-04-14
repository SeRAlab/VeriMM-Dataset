module echo_cancellation(
    input clk,
    input reset,
    input signed [15:0] input_signal,
    input signed [15:0] reference_signal,
    output reg signed [15:0] output_signal
);
    parameter signed [15:0] COEFFICIENT = 16'sd3; // simple gain for cancellation
    reg signed [15:0] delayed_reference;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 16'sd0;
            delayed_reference <= 16'sd0;
        end else begin
            delayed_reference <= reference_signal;
            output_signal <= input_signal - (COEFFICIENT * delayed_reference);
        end
    end
endmodule