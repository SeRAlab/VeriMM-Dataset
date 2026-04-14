module echo_cancellation (
    input wire clk,
    input wire rst,
    input wire [15:0] signal_in,
    input wire [15:0] delayed_signal_in,
    output reg [15:0] signal_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            signal_out <= 16'b0;
        end else begin
            signal_out <= signal_in - delayed_signal_in;
        end
    end
endmodule