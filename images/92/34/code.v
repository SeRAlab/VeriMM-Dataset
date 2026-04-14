module top_module
(
    input clk,
    input areset,
    input enable,
    output reg [1:0] count
);always @(posedge clk or posedge areset)
        if (areset) begin
            count <= 2'b00;
        end else if (enable) begin
            count <= count + 1;
        end
endmodule