module shift_register(
    input clk,
    input load,
    input [3:0] d,
    input s_in,

    output [3:0] q
);

reg [3:0] q;

always @(posedge clk)
begin
  if (load)
    q <= d;
  else
    q <= {s_in, q[3:1]};
end

endmodule