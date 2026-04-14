module top_module(q, d, clk, en);output reg q;
  input d, clk, en;

  always @(posedge clk) begin
    if (en) begin
      q <= d;
    end
  end
endmodule