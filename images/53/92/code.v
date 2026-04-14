module top_module(i0,i1,i2,i3,i4,i5,i6,i7,a,out);input [2:0] a;

input i0,i1,i2,i3,i4,i5,i6,i7; 
output out;

wire w0,w1,w2,w3,w4,w5,w6,w7;

wire c0 ,c0n,c1,c1n,c2,c2n;

 assign c0=a[0];
 assign c1=a[1];
 assign c2=a[2];
not(c0n,c0);
not(c1n,c1);
not(c2n,c2);

and(w0,i0,c0n,c1n,c2n);
and(w1,i1,c0,c1n,c2n);
and(w2,i2,c0n,c1,c2n);
and(w3,i3,c0,c1,c2n);
and(w4,i4,c0n,c1n,c2);
and(w5,i5,c0,c1n,c2);
and(w6,i6,c0n,c1,c2);
and(w7,i7,c0,c1,c2);

or(out,w0,w1,w2,w3,w4,w5,w6,w7);endmodule