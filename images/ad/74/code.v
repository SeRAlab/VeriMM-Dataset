module top_module(
    input clk,
    input reset,
    input in_signal,
    output reg out_signal
);reg [2:0] buffer [0:2];

    always @(posedge clk) begin
        if (reset) begin
            buffer[0] <= 1'b0;
            buffer[1] <= 1'b0;
            buffer[2] <= 1'b0;
            out_signal <= 1'b0;
        end else begin
            buffer[0] <= in_signal;
            buffer[1] <= buffer[0];
            buffer[2] <= buffer[1];
            out_signal <= buffer[2];
        end
    end

endmodule