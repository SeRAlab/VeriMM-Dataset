module top_module(clk, rst, enable, pulseOut);input clk, rst, enable;
	output reg pulseOut;
	reg [15:0] count;

	always @ (posedge clk)
		begin
			if(enable == 0)
				begin 

				end
			else
				begin
					if(rst == 0)
						begin
							count <= 0;
							pulseOut <= 0;
						end
					else 
						begin
						if((count == 49999) | (count > 49999)) 
						begin
							count <= 0;
							pulseOut <= 1;	
						end
						else 
						begin
							count <= count + 1;
							pulseOut <= 0;
						end
						end
				end
		end
endmodule