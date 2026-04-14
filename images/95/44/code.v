module top_module(
				input control,
				input push,
				input clk,
				input [31:0] inc,
				input reset,
				input addcontrol,
				output [31:0] addr,
				output next
				
    );reg nex =1;
	 reg change =1;
	
	 reg [31:0] address = -1;
	
	assign next =nex;
	assign addr = address;
	always @(posedge clk )
	begin
		address <=(reset == 1)?0:address;
		begin
		if((control?1:push)&&addcontrol&&change)		
		begin
			address <= addr+inc+1;
			change <= 0;
		end
		else if((control?1:!push)&&(~addcontrol)&&(~change))
		begin
			change <= 1;
			nex <= 1;
		end
		
		if(push&&(!nex))
		begin
			nex <=1;
		end
		else if((!(control?1:push))&&(nex))
		begin
			nex <=0;
		end

		end
	end

	
endmodule