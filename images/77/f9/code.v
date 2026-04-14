module top_module(a, b, cin, sum, cout);input [3:0] a;
   input [3:0] b;
   input cin;
   output [3:0] sum;
   output cout;

   wire [3:0] temp_sum;
   wire temp_cout;

   assign temp_sum = a + b + cin;
   assign sum = temp_sum[3:0];
   assign temp_cout = (temp_sum > 4'hF);
   assign cout = temp_cout;

endmodule