module top_module(
	input wire       Clk,
	input wire       Reset,
	input wire       Enable,
	input wire [3:0] CountTo,
	output reg [3:0] Count,
	output reg       Overflow
);always @ (posedge Clk)
		begin
		if(Reset)
			begin
			Count <= 4'b0;
			Overflow <= 1'b0;
			end
		else if(Enable)
			begin
			if(Count == CountTo)
				begin
				Count <= 4'b0;
				Overflow <= 1'b1;
				end
			else
				begin
				Count <= Count + 1'b1;
				Overflow <= 1'b0;
				end
			end
		end

endmodule