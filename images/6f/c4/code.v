module top_module(clk, led, dipswitch, key0, key1);input clk;
		input key0;
		input key1;
		input [3:0] dipswitch;
		
		output reg [7:0] led; 
	


reg [31:0] counter = 0;
integer i = 0;
reg [3:0] toggle = 0;

always @ (posedge clk)
begin
	
	
	if (counter <= 25000000)
	begin
		counter <= counter + 1;
	end

	else
	begin
		counter <= 0;	
	
		
		if (~key0)
		begin
			led[i] = 0;
			if (dipswitch[0] == 1)
			begin
				toggle = toggle + 1'b1;
			end
			if (dipswitch[1] == 1)
			begin
				toggle = toggle + 1'b1;
			end
			if (dipswitch[2] == 1)
			begin
				toggle = toggle + 1'b1;
			end
			if (dipswitch[3] == 1)
			begin
				toggle = toggle + 1'b1;
			end
			
			
			i = i + toggle;
			
			
			if (i > 7)
			begin
				i = i - 8;
			end
			
			led[i] = 1;
		
		end
		else if (~key1)
		begin
			led[i] = 0;
			if (dipswitch[0] == 1)
			begin
				toggle = toggle + 1'b1;
			end
			if (dipswitch[1] == 1)
			begin
				toggle = toggle + 1'b1;
			end
			if (dipswitch[2] == 1)
			begin
				toggle = toggle + 1'b1;
			end
			if (dipswitch[3] == 1)
			begin
				toggle = toggle + 1'b1;
			end
			
			
			i = i - toggle;
			
			
			if (i < 0)
			begin
				i = i + 8;
			end
			
			
			led[i] = 1;
		
		end

		else 
		begin
	
		end
		
		
		led[i] = ~led[i];	
		
		
		toggle = 0;
	end
	
	
end


endmodule