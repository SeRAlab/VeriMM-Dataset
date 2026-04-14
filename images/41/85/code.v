module top_module
(
    input clk,
    input areset,
    input enable,
    output reg [7:0] count
);always @(posedge clk or posedge areset)
        if (areset) begin
            count <= 8'b00000000;
        end else if (enable) begin
            count <= count + 1;
        end
endmodule