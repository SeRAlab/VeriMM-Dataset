module top_module(
  input sel,
  input clk,
  input en,
  input [3:0] in_a,
  input [3:0] in_b,
  output reg [3:0] out
);reg [3:0] reg_out;

  always @(posedge clk) begin
    if (en) begin
      if (sel) begin
        reg_out <= in_b;
      end else begin
        reg_out <= in_a;
      end
    end
  end

  always @(posedge clk) begin
    if (en) begin
      out <= reg_out;
    end
  end

endmodule