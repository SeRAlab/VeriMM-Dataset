module top_module(
	input clk, reset, 
	input [31:0] nPC,
	output [10:0] Addr
    );reg [10:0] pc = 0;
	always @ (posedge clk, posedge reset) begin
		if(reset) begin
			pc <= 0;
		end
		else pc <= nPC;
	end
	assign Addr = pc;

endmodule