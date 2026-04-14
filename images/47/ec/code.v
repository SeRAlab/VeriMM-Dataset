module top_module(int_s0, int_s1, s0, s1, cout);input [5:0]int_s0;
  input [5:0]int_s1;
  output s0, s1;
  output [3:0]cout;

	wire [8:0]sum_0; 
	
  assign {s0, sum_0[2:0]}  = int_s0[2:0] + int_s0[5:3];
	assign sum_0[8:3] = int_s1;
	
	assign {s1, cout} = sum_0[3:0] + sum_0[7:4] + sum_0[8];endmodule