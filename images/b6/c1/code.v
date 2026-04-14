module top_module
(
    input clk,
    input sreset,
    output reg [5:0] count
);always @(posedge clk)
        if (sreset) begin
            count <= 6'b0;
        end else begin
            count <= {count[4:0], ~count[5]};
        end
endmodule