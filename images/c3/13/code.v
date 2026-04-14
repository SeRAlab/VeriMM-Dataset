module clock_divider(input clk, input rst, output reg clk_out);

	//Lleva la cuenta de los ciclos de reloj transcurridos
   reg [25:0] counter;
		
	initial 
		begin
			counter <= 26'd0;
			clk_out <= 1'b1;
		end
			
	always @(posedge clk or posedge rst)
	begin
		if(rst)
			begin
				counter <= 26'd0;
				clk_out <= 1'b1; //reset output clock to 1
			end	
		else
			if(counter == 26'd25000000) //convert 50 MHz to 1 Hz
				begin
					counter <= 26'd0;
					clk_out <= ~clk_out; //toggle output clock
				end
			else
				begin
					counter <= counter+1;
				end
	end	
endmodule