module echo_cancel(
    input clk,
    input rst,
    input [7:0] input_signal,
    input [7:0] delayed_signal,
    output reg [7:0] output_signal
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_signal <= 8'b0;
        end else begin
            output_signal <= input_signal - delayed_signal;
        end
    end
endmodule