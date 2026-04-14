module top_module(
    input clk, rst, ctrl,
    input [7:0] a, b,
    output reg [15:0] sum
);always @(posedge clk) begin
    if (rst) begin
        sum <= 0;
    end else if (ctrl) begin
        sum <= a + b;
    end
end

endmodule