module echo_cancellation (
    input wire clk,
    input wire rst_n,
    input wire [7:0] signal_in,
    input wire [7:0] delayed_signal,
    output reg [7:0] signal_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            signal_out <= 8'b0;
        end else begin
            signal_out <= signal_in - delayed_signal;
        end
    end
endmodule