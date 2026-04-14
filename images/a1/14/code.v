module top_module(
  input clk,
  input reset,
  input signed [7:0] a,
  input signed [7:0] b,
  output reg signed [7:0] s, // Changed to reg
  output reg ov
);always @(posedge clk) begin
    if (reset) begin
      s <= 0;
      ov <= 0;
    end else begin
      s <= a + b;
      if ((a[7] == b[7]) && (a[7] != s[7])) begin
        ov <= 1;
      end else begin
        ov <= 0;
      end
    end
  end

endmodule