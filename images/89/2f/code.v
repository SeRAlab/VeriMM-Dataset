module top_module(cout, sum,oper1, oper2, cin);input oper1; 
 input oper2; 
 input cin; 
 output cout; 
 output sum; 
 assign sum = oper1 ^ oper2 ^ cin ; 
 assign cout = ( cin & ( oper1 | oper2 ) ) | 
  ( oper1 & oper2 ) ; 
 endmodule