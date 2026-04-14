module echo_cancellation (
    input clk,
    input reset,
    input signed [15:0] signal_in,
    input signed [15:0] delayed_signal,
    output reg signed [15:0] echo_cancelled_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            echo_cancelled_out <= 16'b0;
        end else begin
            echo_cancelled_out <= signal_in - delayed_signal;
        end
    end
endmodule