module echo_cancellation (
    input clk,
    input reset,
    input signed [15:0] received_signal,
    input signed [15:0] transmitted_signal,
    output reg signed [15:0] output_signal
);
    reg signed [15:0] previous_transmitted;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 16'b0;
            previous_transmitted <= 16'b0;
        end else begin
            output_signal <= received_signal - previous_transmitted;
            previous_transmitted <= transmitted_signal;
        end
    end
endmodule