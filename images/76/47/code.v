module top_module(
    input clk,
    input reset,
    input enable,
    input d,
    output reg q
);always @(posedge clk, negedge reset) begin
        if (!reset) begin
            q <= 0;
        end else if (!enable) begin
            q <= d;
        end
    end

endmodule