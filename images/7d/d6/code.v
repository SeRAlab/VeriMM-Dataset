module top_module(clock,signal_uc, prog_or_kernel,reset);input signal_uc;
	input clock;
	input reset;
	output prog_or_kernel;
	reg state;
	
	
	always @(posedge clock) begin
		if(reset)begin
			state <= 0;
		end
		if((signal_uc == 1) && (state == 0))begin
			state <= 1;
		end 
		else if((signal_uc == 1) && (state == 1)) begin
			state <= 0;
		end
		
	end
	assign prog_or_kernel = state;


endmodule