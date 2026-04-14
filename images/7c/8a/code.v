module shift_register (
    input [3:0] d,
    input clk,
    output reg [3:0] q);
always @(posedge clk) begin
    q <= {q[2:0], d[3]};
end
endmodule