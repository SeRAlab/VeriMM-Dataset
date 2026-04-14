module EchoCancellation(
    input clk,
    input rst,
    input signed [15:0] current_signal,
    input signed [15:0] delayed_signal,
    output reg signed [15:0] output_signal
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        output_signal <= 0;
    end else begin
        output_signal <= current_signal - delayed_signal;
    end
end

endmodule