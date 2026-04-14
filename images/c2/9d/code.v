module d_ff_ce_clr(clk, d, ce, clr, q);
input clk, d, ce, clr;
output q;
reg q;

always @(posedge clk) begin
  if (clr) begin
    q <= 1'b0;
  end else if (ce) begin
    q <= d;
  end
end

endmodule