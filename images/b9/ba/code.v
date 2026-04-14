module top_module(
    input clk,
    input enable,
    output reg clk_gated
);always @ (posedge clk) begin
    if (enable) begin
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

endmodule