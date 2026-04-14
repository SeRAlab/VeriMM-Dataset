module top_module
(
    input clk,
    input sreset,
    output reg [8:0] q
);

always @(posedge clk)
    if (sreset) begin
        q <= 9'b100000000;
    end else begin
        q <= {q[7:0], q[8]};
    end
endmodule