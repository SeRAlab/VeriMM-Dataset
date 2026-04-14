module top_module(
	input clock, reset,
	input [7:0] dividend, divisor,
	input Load_regs, Dec_div,
	output reg [15:0] QR,
	output Zero
);reg [7:0] AR, BR;
always @(posedge clock, posedge reset)
	if (reset) begin
		AR <= 8'b0;
		BR <= 8'b0;
		QR <= 16'b0;
	end else if (Load_regs) begin
		AR <= dividend;
		BR <= divisor;
		QR <= 16'b0;
	end else if (Dec_div) begin
		if (AR >= BR) begin
			AR <= AR - BR;
			QR <= QR + 1;
		end
	end

assign Zero = AR == 8'b0;
endmodule