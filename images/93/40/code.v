module top_module(
    input a,
    input b,
    input reset,
    output reg out
);always @(a, b, reset) begin
    if (reset == 1'b0) begin
        out <= 1'b0; // reset signal is asserted, output is 0
    end
    else begin
        out <= a & b; // reset signal is de-asserted, output is AND of a and b
    end
end

endmodule