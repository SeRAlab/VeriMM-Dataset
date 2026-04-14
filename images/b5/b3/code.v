module top_module(
	reset,
	clk,
	sig,
	counter,
);input 	reset;
input 	clk;
input 	sig;
output 	reg[31:0] counter;

reg sig_d1;
reg sig_d2;
	always @(posedge clk or negedge reset)
	begin
		if(!reset)
		begin
			sig_d1 <= 1'b0;
			sig_d2 <= 1'b0;
		end
		else
		begin
			sig_d1 <= sig;
			sig_d2 <= sig_d1;
		end
	end

	always @(posedge clk or negedge reset)
	begin
		if(!reset)
		begin
			counter <= 32'd0;
		end
		else if(sig_d2 == 1'b1)
		begin
			counter <= counter + 32'b1;
		end
	end
endmodule