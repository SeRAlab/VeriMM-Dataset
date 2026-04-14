module top_module( clk, d, q, r);input  clk;
	input  d;
  input  r;
	output q;  
	
  reg q_reg;
  
	always@(posedge clk or negedge r) begin
		if(!r)
      q_reg <= 1'b0;
    else 
      q_reg <= d;
    
  end
    
assign q = q_reg;endmodule