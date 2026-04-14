module top_module
(
    input clk,
    input areset,
    output reg [7:0] count
);always @(posedge clk or posedge areset)
        if (areset) begin
            count <= 8'b0;
        end else begin
            count <= count + 1;
        end
endmodule