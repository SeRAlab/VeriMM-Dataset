module d_ff_async_set_reset(clk, rst, set, d, q, q_bar);

  input clk, rst, set, d;
  output reg q, q_bar;

  always @(posedge clk) begin
    if (rst) begin
      q <= 1'b0;
      q_bar <= 1'b1;
    end else if (set) begin
      q <= 1'b1;
      q_bar <= 1'b0;
    end else begin
      q <= d;
      q_bar <= ~q;
    end
  end

endmodule