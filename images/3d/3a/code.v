module echo_cancellation(
    input clk,
    input reset,
    input [7:0] input_signal,
    output reg [7:0] output_signal
);
    reg [7:0] delayed_signal;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            delayed_signal <= 8'b0;
            output_signal <= 8'b0;
        end else begin
            output_signal <= input_signal - delayed_signal;
            delayed_signal <= input_signal;
        end
    end
endmodule