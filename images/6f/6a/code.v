module top_module(a,b,so,co);input a,b;
 output so;
 output co;
 assign so=a^b;
 assign co=a&b;endmodule