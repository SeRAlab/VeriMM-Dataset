module shift_reg(
    input clk,
    input load,
    input [3:0] data,

    output [3:0] q
);

reg [3:0] q;

always @(posedge clk)
begin
  if (load)
    q <= data;
  else
    q <= {1'b0, q[3:1]};
end

endmodule