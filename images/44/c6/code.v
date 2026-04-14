module top_module(a,b,out);output reg [14:0] out; 
  input [14:0] a; 
  input [15:1] b; 
  always @(*) 
  begin 
  out[0]=a[0]^b[1]; 
  out[1]=a[1]^b[2]; 
  out[2]=a[2]^b[3]; 
  out[3]=a[3]^b[4]; 
  out[4]=a[4]^b[5]; 
  out[5]=a[5]^b[6]; 
  out[6]=a[6]^b[7]; 
  out[7]=a[7]^b[8]; 
  out[8]=a[8]^b[9]; 
  out[9]=a[9]^b[10]; 
  out[10]=a[10]^b[11]; 
  out[11]=a[11]^b[12]; 
  out[12]=a[12]^b[13]; 
  out[13]=a[13]^b[14]; 
  out[14]=a[14]^b[15]; 
  end 
 endmodule