module top_module
(
    input clk,
    input sreset,
    input areset,
    output reg [9:0] count
);always @(posedge clk or posedge areset)
        if (areset) begin
            count <= 10'b0;
        end else if (sreset) begin
            count <= 10'b0;
        end else begin
            count <= count + 1;
        end
endmodule