module top_module(    
	 input clk,				 
	 input rst,				 
	 input [1:0]EN,
    input aumento,	    
    input disminuye,	 
    output reg [3:0] cont_mes 
	 
	);always @(posedge clk )   
 begin
	 if (rst || cont_mes==4'd12)
		cont_mes <= 4'b0;    
	 else  if (EN==2'd1) begin
		 
		 if (aumento ) begin
				cont_mes <= cont_mes + 4'b1; 
				 end   
		else if (disminuye ) begin 
			if (cont_mes==4'd0) cont_mes<=0;
			else begin
				cont_mes <= cont_mes - 4'b1;      
				  end   end     
		else	begin

				cont_mes <= cont_mes;	
				
				end
	end
end
	
endmodule