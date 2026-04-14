module top_module(input [3:0] bin, output reg [2:0] dec);always @ (bin)
		if (bin == 4'b0000)
			dec <= 3'b000;
		else if (bin == 4'b0001)
			dec <= 3'b001;
		else if (bin == 4'b0010)
			dec <= 3'b010;
		else if (bin == 4'b0011)
			dec <= 3'b011;
		else if (bin == 4'b0100)
			dec <= 3'b100;
		else if (bin == 4'b0101)
			dec <= 3'b101;
		else if (bin == 4'b0110)
			dec <= 3'b110;
		else if (bin == 4'b0111)
			dec <= 3'b111;
		else
			dec <= 3'b000; // default to 0, should not happen
endmodule