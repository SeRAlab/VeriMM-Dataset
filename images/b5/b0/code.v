module top_module(product, counter, multiplier, multiplicand, clk, ldrstcounter, ldencounter, ldp, ldlier, ldcand, ldsum, ldshift);output reg 	[63:0] 	product;
output reg 	[5:0] 	counter;

input 		[31:0]	multiplier;
input 		[31:0]	multiplicand;

input	clk, ldp, ldlier, ldcand, ldshift, ldencounter, ldrstcounter, ldsum;

reg			[31:0]	regcand;
reg						carry;

always @(posedge clk) begin
	
	if(ldrstcounter) 		counter <= 6'd0;
	else if(ldencounter) counter <= counter + 1;
	
	if(ldlier) 	product[31:0] <= multiplier;
	
	if(ldcand) 	regcand <= multiplicand;
	
	if(ldp)	begin
		if(ldsum) 	{carry, product[63:32]} <= product[63:32] + regcand; 
		else 			begin 
			product[63:32] <= 32'd0;
			carry <= 1'b0;
		end
			
	end
	
	if(ldshift) product <= {carry, product} >> 1;
	
		
end

endmodule