module echo_cancellation(
    input clk,
    input reset,
    input [15:0] input_signal,
    input [15:0] delayed_signal,
    output reg [15:0] output_signal
);
    reg [15:0] history;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 16'b0;
            history <= 16'b0;
        end else begin
            history <= input_signal; // Store current input signal
            output_signal <= input_signal - delayed_signal; // Echo cancellation
        end
    end
endmodule