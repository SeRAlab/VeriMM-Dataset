module top_module(
  input clk,
  input din,
  input set,
  input reset,
  input j,
  input k,
  input t,
  input s,
  input r,
  output dout,
  output jkout,
  output tout,
  output srout
);// D-latch implementation
  reg d_reg;
  always @(posedge clk) begin
    if (set) begin
      d_reg <= 1'b1;
    end else if (reset) begin
      d_reg <= 1'b0;
    end else begin
      d_reg <= din;
    end
  end
  assign dout = d_reg;

  // JK-latch implementation
  reg jk_reg;
  always @(posedge clk) begin
    if (set) begin
      jk_reg <= 1'b1;
    end else if (reset) begin
      jk_reg <= 1'b0;
    end else if (j && !k) begin
      jk_reg <= 1'b1;
    end else if (j && k) begin
      jk_reg <= ~jk_reg;
    end
  end
  assign jkout = jk_reg;

  // T-latch implementation
  reg t_reg;
  always @(posedge clk) begin
    if (set) begin
      t_reg <= 1'b1;
    end else if (reset) begin
      t_reg <= 1'b0;
    end else if (t) begin
      t_reg <= ~t_reg;
    end
  end
  assign tout = t_reg;

  // SR-latch implementation
  reg sr_reg;
  always @(posedge clk) begin
    if (set) begin
      sr_reg <= 1'b1;
    end else if (reset) begin
      sr_reg <= 1'b0;
    end else if (s && !r) begin
      sr_reg <= 1'b1;
    end else if (s && r) begin
      sr_reg <= 1'b0;
    end
  end
  assign srout = sr_reg;

endmodule