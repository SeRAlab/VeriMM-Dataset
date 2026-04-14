module top_module
(
    input clk,
    input sreset,
    input enable,
    input load,
    input [2:0] data,
    output reg [2:0] count
);always @(posedge clk)
        if (sreset) begin
            count <= 3'b0;
        end else if (load) begin
            count <= data;
        end else if (enable) begin
            count <= count + 1;
        end
endmodule