module lcpmult(in1, in2, out);
   input [0:4] in1, in2; 
   output [0:4] out;
   wire [4:0] intvald; 
   wire [3:0] intvale; 
   wire intvale_0ax; 
   assign intvald[0] = in1[0] & in2[0];
   assign intvald[1] = (in1[1] & in2[0]) ^ (in1[0] & in2[1]);
   assign intvald[2] = (in1[2] & in2[0]) ^ ((in1[1] & in2[1]) ^ (in1[0] & in2[2]));
   assign intvald[3] = ((in1[3] & in2[0]) ^ (in1[2] & in2[1])) ^ ((in1[1] & in2[2]) ^ (in1[0] & in2[3]));
   assign intvald[4] = (((in1[4] & in2[0]) ^ (in1[3] & in2[1])) ^ (in1[2] & in2[2]))
                        ^ ((in1[1] & in2[3]) ^ (in1[0] & in2[4])); 
   assign intvale[0] = ((in1[4] & in2[1]) ^ (in1[3] & in2[2])) ^ ((in1[2] & in2[3]) ^ (in1[1] & in2[4]));
   assign intvale[1] = ((in1[4] & in2[2]) ^ (in1[3] & in2[3])) ^ (in1[2] & in2[4]);
   assign intvale[2] = (in1[4] & in2[3]) ^ (in1[3] & in2[4]);
   assign intvale[3] = in1[4] & in2[4];
   assign intvale_0ax = (intvale[0] ^ intvale[3]);
   assign out[0] = intvald[0] ^ intvale_0ax;
   assign out[1] = intvald[1] ^ intvale[1];
   assign out[2] = (intvald[2] ^ intvale[2]) ^ intvale_0ax;
   assign out[3] = (intvald[3] ^ intvale[1]) ^ intvale[3];
   assign out[4] = intvald[4] ^ intvale[2];
 endmodule