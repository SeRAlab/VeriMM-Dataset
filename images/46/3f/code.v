module top_module(
    input clk, reset,
    input [31:0] in_signal,
    output reg [15:0] out_signal
);always @ (posedge clk) begin
    if (reset) begin
        out_signal <= 16'hFFFF;
    end else begin
        if (in_signal == 32'h00000000) begin
            out_signal <= 16'hFFFF;
        end else begin
            out_signal <= in_signal[15:0];
        end
    end
end

endmodule