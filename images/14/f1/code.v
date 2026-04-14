module echo_cancellation #(parameter ECHO_FACTOR = 1)(
    input wire clk,
    input wire reset,
    input wire [15:0] input_signal,
    input wire [15:0] feedback_signal,
    output reg [15:0] output_signal
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 16'b0;
        end else begin
            output_signal <= input_signal - (ECHO_FACTOR * feedback_signal);
        end
    end
endmodule