module top_module(a, b, cin, sum, cout);input [3:0] a;
   input [3:0] b;
   input cin;
   output [3:0] sum;
   output cout;

   wire [3:0] sum_temp;
   wire [3:0] carry_temp;

   assign sum_temp = a + b + cin;
   assign sum = sum_temp;
   assign cout = carry_temp[3];

   assign carry_temp[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
   assign carry_temp[1] = (a[1] & b[1]) | (a[1] & carry_temp[0]) | (b[1] & carry_temp[0]);
   assign carry_temp[2] = (a[2] & b[2]) | (a[2] & carry_temp[1]) | (b[2] & carry_temp[1]);
   assign carry_temp[3] = (a[3] & b[3]) | (a[3] & carry_temp[2]) | (b[3] & carry_temp[2]);

endmodule