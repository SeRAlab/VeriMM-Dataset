module top_module(input [7:0] in, output reg [7:0] reverseIn);integer i;


  
  always@(in)
  begin
    for (i = 0; i < 8; i = i + 1)	
    begin 
      reverseIn[i] = in[7-i];			
    end 
  end 

endmodule