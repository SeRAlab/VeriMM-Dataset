module top_module(
  input clk,
  input rst,
  input din,
  input set,
  input clr,
  input [1:0] ctrl,
  output reg dout,
  output reg q
);reg d, j, k, t, s, r;

  always @(posedge clk) begin
    if (rst) begin
      d <= 0;
      j <= 0;
      k <= 0;
      t <= 0;
      s <= 0;
      r <= 0;
      q <= 0;
    end else begin
      case (ctrl)
        0: d <= din;
        1: begin
             if (j & k) q <= ~q;
             else if (j) q <= 1;
             else if (k) q <= 0;
           end
        2: if (t) q <= ~q;
        3: begin
             if (s & ~r) q <= 1;
             else if (~s & r) q <= 0;
           end
      endcase
    end
  end

  always @(posedge clk) begin
    if (rst) dout <= 0;
    else dout <= q;
  end

endmodule