module top_module(
  input do_sub,
  input [7:0] a,
  input [7:0] b,
  output reg [7:0] out,
  output reg carry_flag,
  output reg overflow_flag
);always @(*) begin
    if(do_sub == 1) begin
      out = a - b;
      carry_flag = ~(a < b);
      overflow_flag = (a[7] == b[7] && out[7] != a[7]);
    end else begin
      out = a + b;
      carry_flag = out[8];
      overflow_flag = (a[7] == b[7] && out[7] != a[7]);
    end
  end

endmodule