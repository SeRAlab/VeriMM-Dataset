module top_module(num, hex, bcd);input [7:0] num;
	input hex;
	output reg [7:0] bcd;
	
	always @ (num) begin
		if (hex) begin
			bcd[3:0] = num % 16;
			bcd[7:4] = num / 16;
		end else begin		
			bcd[3:0] = num % 10;
			bcd[7:4] = num / 10;
		end
	end
	
endmodule