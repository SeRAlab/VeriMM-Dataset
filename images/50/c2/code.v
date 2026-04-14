module top_module(
    input clk,
    input reset,
    input enable,
    input up,
    output reg [15:0] q);always @(posedge clk) begin
    if (reset)
        q <= 16'b0;
    else if (enable) begin
        if (up)
            q <= q + 1;
        else
            q <= q - 1;
    end
end
endmodule