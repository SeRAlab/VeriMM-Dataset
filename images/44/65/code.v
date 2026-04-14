module top_module
(
    input clk,
    input sreset,
    input enable,
    output reg [9:0] count
);always @(posedge clk)
        if (sreset) begin
            count <= 10'b1111111111;
        end else if (enable) begin
            count <= count - 1;
        end
endmodule