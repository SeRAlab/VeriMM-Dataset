module top_module(x, y, int_s0, int_s1, s0, s1, cout);input [7:0]x;
  input [7:0]y;
  input [5:0]int_s0;
  input [5:0]int_s1;
  output s0, s1;
  output [5:0]cout;

  wire [13:0]xnor_out;
  assign xnor_out[7:0] = x ~^ y;
  assign xnor_out[13:8] = int_s0;

  wire [12:0]sum_1;
  assign {s0, sum_1[6:0]}  = xnor_out[6:0] + xnor_out[13:7];
  assign sum_1[12:7] = int_s1;

  wire [5:0]sum_2;
  assign {s1, sum_2} = sum_1[5:0] + sum_1[11:6] + sum_1[12];
  assign cout = sum_2;endmodule