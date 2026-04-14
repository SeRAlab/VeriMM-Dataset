module top_module(a, b, cin, sum, p, g);input a, b, cin;
   output sum, p, g;
   assign sum = a ^ b ^ cin;
   assign p = a ^ b;
   assign g = a & b;
endmodule