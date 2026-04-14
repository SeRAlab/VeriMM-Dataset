module top_module(
  input [1:0] a,
  input [1:0] b,
  input cin,
  input clk,
  output reg [1:0] sum,
  output reg cout
);always @(posedge clk) begin
    // calculate the sum
    sum[0] <= a[0] ^ b[0] ^ cin;
    sum[1] <= a[1] ^ b[1] ^ (a[0] & b[0]) ^ (a[0] & cin) ^ (b[0] & cin);

    // calculate the carry-out
    cout <= (a[0] & b[0]) | (a[1] & b[0]) | (a[0] & cin) | (a[1] & cin) | (b[1] & cin);
  end

endmodule