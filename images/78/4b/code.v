module debouncer(
	input clk,
	input rst_n,
	input noisy,
	output reg clean
);

	reg [3:0] counter;
	reg stable_state;
	
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			counter <= 4'b0000;
			stable_state <= 0;
			clean <= 0;
		end else if(noisy == stable_state) begin
			if(counter < 4'd15)
				counter <= counter + 1'b1;
			else
				clean <= stable_state;
		end else begin
			counter <= 4'b0000;
			stable_state <= noisy;
		end
	end
	
endmodule