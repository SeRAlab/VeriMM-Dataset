module top_module(
  input a,
  input b,
  input rst,
  output out
);reg out_reg;

  always @(a, b, rst) begin
    if (rst == 1'b0) begin
      out_reg <= 1'b0;
    end else begin
      out_reg <= a & b;
    end
  end

  assign out = out_reg;

endmodule