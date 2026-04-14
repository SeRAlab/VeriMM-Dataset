module top_module(
		
		
		
		input [15:0] sw, 				
		output reg [3:0] thousands, 
		output reg [3:0] hundreds, 
		output reg [3:0] tens, 		
		output reg [3:0] ones		
    );integer index; 
	 
	 always @(sw) 
	 begin
		
		thousands = 4'd0; 	
		hundreds = 4'd0; 	
		tens = 4'd0; 		
		ones = 4'd0; 		
		
		for (index = 15; index >= 0; index = index - 1) 
		begin
		
			
			if (thousands >= 5)
                thousands =  thousands + 3;

			if (hundreds >= 5)
				hundreds =  hundreds + 3;
				
			if (tens >= 5)
				tens =  tens + 3;
				
			if (ones >= 5)
				ones =  ones + 3;
				
			
			
			thousands = thousands << 1;	
            thousands[0] = hundreds[3];         

			hundreds = hundreds << 1;	
			hundreds[0] = tens[3]; 		
			
			tens = tens << 1; 	
			tens[0] = ones[3]; 	
			
			ones = ones << 1;		
			ones[0] = sw[index]; 
		end 
	end 
			
			
			
endmodule