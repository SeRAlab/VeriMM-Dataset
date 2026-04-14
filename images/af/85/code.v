module top_module(
    input clk,
    input gate,
    input rst,
    output reg gated_clk
);always @(posedge clk, negedge rst) begin
        if (~rst) begin
            gated_clk <= 1'b0;
        end else if (gate) begin
            gated_clk <= clk;
        end else begin
            gated_clk <= 1'b0;
        end
    end

endmodule