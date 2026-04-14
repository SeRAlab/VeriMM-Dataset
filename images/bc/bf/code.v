module top_module(a,b,product);parameter       a_width = 8;
 parameter       b_width = 8;
 input   [a_width-1:0]   a;
 input   [b_width-1:0]   b;
 output  [a_width+b_width-1:0]   product;
         
 wire    sign;
 wire    [a_width-1:0]   temp_a;
 wire    [b_width-1:0]   temp_b;
 wire    [a_width+b_width-1:0]   long_temp;
           
 assign sign = a[a_width-1] ^ b[b_width-1];  
 assign temp_a = (a[a_width-1] == 1'b1)? ~(a - 1'b1) : a;   
 assign temp_b = (b[b_width-1] == 1'b1)? ~(b - 1'b1) : b;   
 assign long_temp = temp_a * temp_b; 
 assign product = (sign == 1'b1) ? ~(long_temp - 1'b1) : long_temp;   
 
 endmodule