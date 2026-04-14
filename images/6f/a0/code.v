module top_module(CLK,DO,DI,EI);parameter nb=16; 
  input CLK ; 
  wire CLK; 
  input [nb+1:0] DI ; 
  wire [nb+1:0] DI; 
  input EI ; 
  wire EI; 
  output [nb+1:0] DO ; 
  reg [nb+1:0] DO; 
  reg [nb+5 :0] dx5; 
  reg [nb+2 : 0] dt; 
  wire [nb+6 : 0] dx5p; 
  wire [nb+6 : 0] dot; 
  always @(posedge CLK) 
  begin 
  if (EI) begin 
  dx5<=DI+(DI <<2); 
  dt<=DI; 
  DO<=dot >>4; 
  end 
  end 
  assign dot= (dx5p+(dt>>4)+(dx5>>12)); 
  assign dx5p=(dx5<<1)+(dx5>>2); 
 endmodule