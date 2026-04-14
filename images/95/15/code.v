module top_module(

 
  input dataIn, 


  output reg[23:0] dataOut 
);always @ (*) 
	begin
		if(dataIn == 1'b1)
			begin
				dataOut <= 24'b111111111111111111111111;
			end
			
		else if(dataIn == 1'b0)
			begin
				dataOut <= 0;
			end
	end
endmodule