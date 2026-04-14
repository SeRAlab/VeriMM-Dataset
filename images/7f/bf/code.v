module top_module(address,clock,instruction);input[31:0] address;
input clock;
output [31:0] instruction;
integer flag=0;
reg[31:0] instrmem[31:0];

always @(posedge clock) begin

	if(flag==0) 
	begin
	
		
		
	
		
		
		
		
		

	
		
	
	
	
		
		
	
		
		
		
		
		flag<=1;
	end
end

assign instruction=instrmem[address];

endmodule