module top_module(
    input clk_in,
    input latch_edge,
    output reg clk_out
);always @(posedge clk_in) begin
    if (latch_edge) begin
        clk_out <= 1'b1;
    end else begin
        clk_out <= 1'b0;
    end
end

endmodule