module top_module(b_output, b_input, enable);output [1:0] b_output;
input  enable ; 
input [3:0] b_input ;
 
reg [1:0] b_output;

always @(*) begin
if (enable) 
begin
b_output = 0;
  if(b_input==8)
    b_output=1;
  else if(b_input==4)
      b_output=2;
  else if(b_input==2)
      b_output=3;
  
end
end
endmodule