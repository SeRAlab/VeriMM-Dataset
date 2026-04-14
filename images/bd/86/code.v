module top_module(
  input               a,
  input               b,
  input               sel_b1,
  input               sel_b2,
  input               clk,
  input               rst_n,
  output reg          out_always,
  output reg          rise,
  output reg          fall,
  output              final_output
);reg prev_a;
  reg sel;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      prev_a <= 1'b0;
      sel <= 1'b0;
      out_always <= 1'b0;
    end else begin
      prev_a <= a;
      sel <= sel_b1 & sel_b2;
      out_always <= sel ? b : a;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rise <= 1'b0;
      fall <= 1'b0;
    end else begin
      if (a & !prev_a) begin
        rise <= 1'b1;
      end else begin
        rise <= 1'b0;
      end

      if (!a & prev_a) begin
        fall <= 1'b1;
      end else begin
        fall <= 1'b0;
      end
    end
  end

  assign final_output = out_always ^ (rise | fall);

endmodule