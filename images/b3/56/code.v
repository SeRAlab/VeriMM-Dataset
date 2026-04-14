module top_module(clk, clr, en, d, q, qn);input clk, clr, en, d;
output q, qn;
reg q, qn;

always @(posedge clk) begin
  if (clr == 1'b0) begin
    q <= 1'b0;
    qn <= 1'b1;
  end
  else if (en == 1'b1) begin
    q <= d;
    qn <= ~d;
  end
end

endmodule