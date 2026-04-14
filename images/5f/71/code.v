module top_module(
    input clk,
    input reset,
    input signed [7:0] a,
    input signed [7:0] b,
    input op,
    output reg signed [7:0] result,
    output reg overflow
);always @(posedge clk) begin
    if (reset) begin
        result <= 0;
        overflow <= 0;
    end
    else begin
        if (op == 0) begin // addition
            result <= a + b;
            overflow <= (result[7] != a[7] && result[7] != b[7]);
        end
        else begin // subtraction
            result <= a - b;
            overflow <= (result[7] != a[7] && result[7] == b[7]);
        end
    end
end

endmodule