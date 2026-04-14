module top_module(input[9:0] x, y, output reg[2:0] rgb);always@(*) begin
		if(y <= 368 && y >= 112 && ((y - 112) % 51 == 0))
			rgb <= 3'b111;
		else if (y < 368 && y > 112 && (x % 51 == 0))
			rgb <= 3'b111;
		else rgb <= 3'b000;
	end
endmodule