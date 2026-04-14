module top_module
(
    input clk,
    input areset,
    input enable,
    output reg [15:0] count
);always @(posedge clk or posedge areset)
        if (areset) begin
            count <= 16'b1111111111111111;
        end else if (enable) begin
            count <= count - 1;
        end
endmodule