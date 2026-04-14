module top_module
(
    input clk,
    input sreset,
    output reg [2:0] q
);

always @(posedge clk)
    if (sreset) begin
        q <= 3'b000;
    end else begin
        q <= {q[1:0], ~q[2]};
    end
endmodule