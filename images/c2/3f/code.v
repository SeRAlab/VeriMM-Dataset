module adder_4bit (
  input [3:0] a,
  input [3:0] b,
  input cin,
  output [3:0] s,
  output cout
);

  reg [3:0] sum;
  reg cout;

  always @(*) begin
    sum = a + b + cin;
    cout = (sum[4] == 1) ? 1 : 0;
  end

  assign s = sum[3:0];
  assign cout = cout;

endmodule
