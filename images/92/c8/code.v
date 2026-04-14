module top_module
(
    input clk,
    input sreset,
    input sset,
    input [11:0] set_val,
    output reg [11:0] count
);

always @(posedge clk)
    if (sreset) begin
        count <= 12'b000000000000;
    end else if (sset) begin
        count <= set_val;
    end else begin
        count <= count + 1;
    end
endmodule