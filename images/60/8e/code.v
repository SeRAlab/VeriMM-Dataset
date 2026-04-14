module top_module(
	input wire [1:0] round_mode,
	input wire or_info, 
	input wire xor_info, 
	output reg ctrl 
    );always @*
  case ({xor_info,or_info,round_mode})
 






	
	
	4'b0101: ctrl <= 1'b0;
	
	
	
	4'b1101: ctrl <= 1'b1;
	


	
	
	4'b0110: ctrl <= 1'b1;
	
	
	
	4'b1110: ctrl <= 1'b0;
	
   default: ctrl <= 1'b0; 
   endcase
			
endmodule