module top_module(
   input wire [7:0] datain, 
	output reg [6:0] dataout
	);always@(datain)
	begin
		
		
				case(datain)
			    8'h16: begin
				 dataout<=7'b0001010; 
				
				 end
				 8'h1E: begin
				 dataout<=7'b0001111; 
				
				 end 
				 8'h26: begin
				 dataout<=7'b0010100; 
				 
				 end
				 8'h25: begin
				 dataout<=7'b0011001; 
				
				 end
				 8'h2E: begin
				 dataout<=7'b0011011; 
				 
				 end
				 8'h36: begin
				 dataout<=7'b0011110; 
				
				 end
				 8'h3D: begin
				 dataout<=7'b0100000; 
				
				 end
				 8'h3E: begin
				 dataout<=7'b0100011; 
				
				 end
				 8'h46: begin
				 dataout<=7'b0100111; 
				
				 end
				 8'h45: begin
				 dataout<=7'b0101001; 
				
				 end
				 8'h33: begin
				 dataout<=7'b0111100; 
				
				 end
				
				default: begin 
				dataout<=7'b0000000;	
				
				end
				endcase
		
	
	end

	 

endmodule