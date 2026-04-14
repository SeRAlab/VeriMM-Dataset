module top_module(a, b, cin, sum, p, g);input a, b, cin;
   output sum, p, g;
   assign #2 sum = a ^ b ^ cin;
   assign #1 p = a ^ b;
   assign #1 g = a & b;
endmodule