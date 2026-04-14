module top_module(LR_in, LR_out, clk, LR_load_en);input             clk;
  input             LR_load_en;		
  input       [7:0] LR_in;	 
  output reg  [7:0] LR_out;			 

  always @(posedge clk)
  begin
    if(LR_load_en)
      LR_out <= LR_in;              
	  
	else
      LR_out <= LR_out;             
  
  end
  
endmodule