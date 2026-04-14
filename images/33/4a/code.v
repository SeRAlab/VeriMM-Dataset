module echo_cancellation (
    input clk,
    input rst,
    input [7:0] current_signal,
    output reg echo_detected
);
    reg [7:0] previous_signal;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            previous_signal <= 8'b0;
            echo_detected <= 1'b0;
        end else begin
            if (current_signal == previous_signal) begin
                echo_detected <= 1'b1; // Echo detected
            end else begin
                echo_detected <= 1'b0; // No echo
            end
            previous_signal <= current_signal; // Store current signal for next comparison
        end
    end
endmodule