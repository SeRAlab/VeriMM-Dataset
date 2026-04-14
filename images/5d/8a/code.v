module top_latch_module(
    input d,
    input enable,
    output reg q);always @(d or enable) begin
        if (enable) begin
            q <= d;
        end
    end

endmodule