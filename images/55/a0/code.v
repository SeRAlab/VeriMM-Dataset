module top_module(clock, clockT);input clock;
	output reg clockT;
	reg [31:0] count;
	always @(posedge clock)
		begin
			if (count == 32'b00000000000000000000000000001111)
				begin
					clockT <= ~clockT;
					count  <= 32'b00000000000000000000000000000000;
				end
			else
				begin
					count <= count + 1;
				end
		end
		
endmodule