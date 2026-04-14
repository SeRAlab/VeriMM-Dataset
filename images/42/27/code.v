module top_module
(
    input clk,
    input sreset,
    output reg [3:0] count
);always @(posedge clk)
        if (sreset) begin
            count <= 4'b0000;
        end else begin
            count <= count + 1;
        end
endmodule