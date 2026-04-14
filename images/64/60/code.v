module top_module(
input CLK,
input RESET,
input hundredth_of_second_passed,
output tenth_of_second_passed,
output reg [16:0] counter
);wire counted;
	assign counted = (counter == 17'd2);
	assign tenth_of_second_passed = (counted & hundredth_of_second_passed);
	always @(posedge CLK or posedge RESET) begin
		if (RESET) counter <= 0;
		else begin 
			if (hundredth_of_second_passed | counted) begin
				if (counted) counter <= 0;
				else counter <= counter + 1;
			end else counter <= counter;
		end
	end
	
endmodule