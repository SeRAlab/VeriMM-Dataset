module top_module
(
    input clk,
    input areset,
    input enable,
    input load,
    input [6:0] data,
    output reg [6:0] count
);always @(posedge clk or posedge areset)
        if (areset) begin
            count <= 7'b0;
        end else if (load) begin
            count <= data;
        end else if (enable) begin
            count <= count + 1;
        end
endmodule