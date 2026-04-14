module top_module(c,q);output [10:0] q; 
  reg [10:0] q; 
  input [14:0] c; 
  reg [3:0] pb; 
  reg [3:0] s; 
  reg [3:0] temp; 
  reg [14:0] inputs; 
  always @(c or q) 
  begin 
  pb[0]=c[2]^c[4]^c[6]^c[8]^c[10]^c[12]^c[14]; 
  pb[1]=c[2]^c[5]^c[6]^c[9]^c[10]^c[13]^c[14]; 
  pb[2]=c[4]^c[5]^c[6]^c[11]^c[12]^c[13]^c[14]; 
  pb[3]=c[8]^c[9]^c[10]^c[11]^c[12]^c[13]^c[14]; 
  s[0] = c[0]^pb[0]; 
  s[1] = c[1]^pb[1]; 
  s[2] = c[3]^pb[2]; 
  s[3] = c[7]^pb[3]; 
  inputs=c; 
  temp=s[0]*1; 
  temp=temp+s[1]*2; 
  temp=temp+s[2]*4; 
  temp=temp+s[3]*8-1; 
  inputs[temp]=c[temp]^1; 
  q[0]=inputs[2]; 
  q[1]=inputs[4]; 
  q[2]=inputs[5]; 
  q[3]=inputs[6]; 
  q[4]=inputs[8]; 
  q[5]=inputs[9]; 
  q[6]=inputs[10]; 
  q[7]=inputs[11]; 
  q[8]=inputs[12]; 
  q[9]=inputs[13]; 
  q[10]=inputs[14]; 
  end 
 endmodule