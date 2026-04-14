module top_module
(
    input clk,
    input sset,
    input [3:0] set_value,
    output reg [3:0] count
);always @(posedge clk)
        if (sset) begin
            count <= set_value;
        end else begin
            count <= count + 1;
        end
endmodule