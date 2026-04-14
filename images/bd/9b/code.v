module top_module(
	input clock, reset,
	input [7:0] multiplicand, multiplier,
	input Load_regs, Add_dec,
	output reg [15:0] PR,
	output Zero
);reg [7:0] AR, BR;
always @(posedge clock, posedge reset)
	if (reset) begin
		AR <= 8'b0;
		BR <= 8'b0;
		PR <= 16'b0;
	end else if (Load_regs) begin
		AR <= multiplier;
		BR <= multiplicand;
		PR <= 16'b0;
	end else if (Add_dec) begin
		PR <= PR + BR;
		AR <= AR - 1;
	end

assign Zero = AR == 8'b0;
endmodule