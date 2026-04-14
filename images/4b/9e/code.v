module top_module(out,a,b);input [3:0] a,b;
output [3:0] out;

and u0 (out[0],a[0],b[0]);
and u1 (out[1],a[1],b[1]);
and u2 (out[2],a[2],b[2]);
and u3 (out[3],a[3],b[3]);

endmodule