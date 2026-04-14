module top_module
(
    input clk,
    input sreset,
    input enable,
    output reg [3:0] count
);always @(posedge clk)
        if (sreset) begin
            count <= 4'b1111;
        end else if (enable) begin
            count <= count - 1;
        end
endmodule