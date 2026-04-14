module top_module(input A, B, C, input [1:0] S, output reg O);always @(*) begin
 
 if (S == 2'b00)   
      O <= A;
  else
  if (S == 2'b10)  
       O <= B;
  else 
  if (S == 2'b01) 
      O <= C;
    end 

endmodule