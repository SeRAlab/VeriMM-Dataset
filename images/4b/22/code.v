module d_ff(
    input clk,
    input rst,
    input set,
    input d,

    output reg q
);

always @(posedge clk or posedge rst or posedge set)
begin
  if (rst)
    q <= 1'b0;
  else if (set)
    q <= 1'b1;
  else
    q <= d;
end

endmodule