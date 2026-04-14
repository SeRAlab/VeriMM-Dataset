module top_module(
    input clk,
    input run_game,
    output compute,
	 output hold
    );reg compute_reg = 0;
	 reg [2:0] counter = 0;
	 reg hold_reg = 0;
	 
	 always @(posedge clk)
	 begin
		if(run_game == 1)
		begin
			hold_reg = 1;
			counter = counter + 1;
			if(counter == 3'b101)
			begin
				compute_reg = 1;
				counter = 0;
			end
		end
		else
		begin
			compute_reg = 0;
			counter = 0;
			hold_reg = 0;
		end
	 end
	 
	 assign compute = compute_reg;
	 assign hold = hold_reg;

endmodule