module top_module(
    input a,
    input b,
    input reset,
    output reg out
);always @(a, b, reset) begin
        if (reset) begin
            out <= 1'b0;
        end else begin
            out <= a | b;
        end
    end

endmodule