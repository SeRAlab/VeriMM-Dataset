module add16(
  input [15:0] a,
  input [15:0] b,
  input cin,
  output [15:0] sum,
  output cout
);

  wire [15:0] sum_temp;
  wire [16:0] sum_extended;

  assign sum_extended = {1'b0, a} + {1'b0, b, cin};
  assign sum_temp = sum_extended[15:0];
  assign cout = sum_extended[16];

  assign sum = sum_temp;

endmodule