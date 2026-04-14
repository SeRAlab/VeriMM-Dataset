module top_module(Y,carryout,A,B,carryin);output [3:0]Y;
  output carryout;
  input [3:0]A,B;
  input carryin;

  wire [3:0]g,p;
  wire [4:0]c;
  wire z;
  
  assign c[0] = carryin; 
  
  genvar i;
  for (i=0; i<=3; i=i+1)
  begin
    assign p[i] = A[i] ^ B[i];
    assign c[i+1] = ( A[i] & B[i] ) | ( A[i] & c[i] ) | ( B[i] & c[i] );
    assign Y[i] = A[i] ^ B[i] ^ c[i];
  end
  
  
  assign z = p[0] & p [1] & p[2] & p[3];
  assign carryout = z ? carryin : c[4];

endmodule