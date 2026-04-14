module top_module(d,v,en,pb);input [7:0]d;
 input v,en;
 output pb;
 wire w1,w2,w3,w4,w5,w6,w7;
 assign w1=(d[0]^d[1]);
 assign w2=(d[2]^d[3]);
 assign w3=(d[4]^d[5]);
 assign w4=(d[6]^d[7]);
 assign w5=w1^w2;
 assign w6=w3^w4;
 assign w7=w5^w6;
 assign pb=(w7^v)&en;
endmodule