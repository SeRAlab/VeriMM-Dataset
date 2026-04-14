module top_module(
		input AS_L,						
		input DramSelect_H,			
	   input DramDtack_L,			
		input CanBusSelect_H,		
		input CanBusDtack_L, 		

	   output reg DtackOut_L 		

	);always@(*)	begin

		DtackOut_L <= 1 ;					

		
		
		
		
		
		
		

		if(AS_L == 0)							
		begin
			DtackOut_L <= 0 ;				
													
													

			
			
			
			
			
			
			
			
			

			
			
			
			
			if (DramSelect_H==1)
				DtackOut_L<= DramDtack_L;
			else if(CanBusSelect_H == 1)					
				DtackOut_L <= CanBusDtack_L;		



		end
	end
endmodule