module top_module(
  input [3:0] a,
  input [3:0] b,
  input cin,
  input ctrl,
  output [3:0] sum,
  output cout
);wire [3:0] temp_sum;
  wire temp_cout;

  assign {temp_cout, temp_sum} = (ctrl == 1) ? a + b + cin : {cin, a};
  assign cout = temp_cout;
  assign sum = (ctrl == 1) ? temp_sum : a;

endmodule