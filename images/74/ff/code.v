module top_module(
    input clk,
    input reset,
    input set,
    input clear,
    input d,
    output reg q
);always @(posedge clk or negedge reset) begin
        if (!reset) begin
            q <= 1'b0;
        end else if (clear) begin
            q <= 1'b0;
        end else if (set) begin
            q <= 1'b1;
        end else begin
            q <= d;
        end
    end

endmodule