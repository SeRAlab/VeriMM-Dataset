module top_module(cout, gout, pout, g, p, cin);output [2:0] cout;
   output gout;
   output pout;
   input [3:0] g;
   input [3:0] p;
   input cin;
   
   wire a1_out, a2_out, a3_out, a4_out, a5_out, a6_out;
   wire a7_out, a8_out, a9_out;

   and a1(a1_out, p[0], cin);
   or  o1(cout[0], g[0], a1_out);

   and a2(a2_out, p[1], g[0]);
   
   assign a3_out = p[1] & p[0] & cin;
   
   
   assign cout[1] = g[1] | a2_out | a2_out;

   and a4(a4_out, p[2], g[1]);
   
   assign a5_out = p[2] & p[1] & g[0];
   
   
   assign a6_out = p[2]& p[1]& p[0]& cin;
   
   
   assign cout[2] = g[2] | a4_out |  a5_out | a6_out;
	 
   and a7(a7_out, p[3], g[2]);
   
   assign a8_out = p[3] & p[2] & g[1];
   
   
   assign a9_out = p[3] & p[2] & p[1] & g[0];
   
   
   assign gout= g[3]| a7_out| a8_out| a9_out;
   
   
   assign pout= p[0]& p[1]& p[2]& p[3];
   
endmodule