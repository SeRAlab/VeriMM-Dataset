module top_module(Output,Input);output reg [11:0]Output;
	input [11:0]Input;
	reg [3:0]part1,part2,part3;
	reg c1,c2,c3;
	
	always @*
	begin
		part1=Input[3:0];
		part2=Input[7:4];
		part3=Input[11:8];
		
		part1=part1+4'd1;
		
		if(part1 > 4'd9)
		begin
			c1=1'b1;
			part1=part1+4'd6;
		end
		
		else
			c1=1'b0;
		
		if(c1 == 1'b1)
		begin
			part2=part2+4'd1;
			if(part2 > 4'd9)
			begin
				c2=1'b1;
				part2=part2+4'd6;
			end
			
			else
				c2=1'b0;
		end
		
		else
			c2=1'b0; 
		
		if(c2 == 1'b1)
		begin
			part3=part3+4'd1;
			if(part3 > 4'd9)
			begin
				c3=1'b1;
				part3=part3+4'd6;
			end
			
			else
				c3=1'b0;
		end
		
		else
			c3=1'b0;
		
		Output={part3,part2,part1};
	end
	
endmodule