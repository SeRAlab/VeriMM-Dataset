module top_module
(
    input clk,
    input sreset,
    input enable,
    output reg [7:0] count
);always @(posedge clk)
        if (sreset) begin
            count <= 8'b00000000;
        end else if (enable) begin
            count <= {count[6:0], ~count[7]};
        end
endmodule