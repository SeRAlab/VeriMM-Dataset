module top_module(
  input [3:0] a,
  input [3:0] b,
  input cin,
  output [3:0] s,
  output cout
);reg [3:0] sum;

  always @(*) begin
    sum = a + b + cin;
  end

  assign s = sum[3:0];
  assign cout = (sum[4] == 1) ? 1 : 0;

endmodule