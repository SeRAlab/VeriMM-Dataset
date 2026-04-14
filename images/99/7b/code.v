module top_module(CLK, RES, CLK_OUT);input CLK;
	input RES;
	output reg CLK_OUT;
	reg [1:0] CNT;
	always@(posedge CLK)
	begin
		if (RES) begin
			CNT <= 0;
		end
		else begin
			CNT <= CNT + 1;
		end
		
	end
	always@(posedge CLK)
	begin
		if (RES) begin
			CLK_OUT <= 0;
		end
		else if (CNT == 3) begin
			CLK_OUT <= !CLK_OUT;
		end
	end

endmodule