module top_module(
    input clk,
    input enable,
    input direction,
    output reg [15:0] q);always @(posedge clk) begin
    if (enable) begin
        if (direction)
            q <= q + 1;
        else
            q <= q - 1;
    end
end
endmodule