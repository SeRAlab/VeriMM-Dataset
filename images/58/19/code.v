module top_module(
  input c,
  input w,
  input [2:0] a,
  input [31:0] wd,
  output reg [31:0] rd,
  output reg uart
);always @(*) begin
    if (w == 0 || (w == 1 && a[2] == 0)) begin
      rd = wd;
      uart = 1;
    end else if (w == 1 && a[2] == 1) begin
      rd = 0;
      uart = c;
    end
  end

endmodule