module top_module(
	input wire clk,
	input wire reset,
	input wire enable,
	output wire out
);reg [1:0] cnt = 0;

	always @(posedge clk) begin
		if(reset) begin
			cnt <= 0;
		end else if(enable && cnt != 3) begin
			cnt <= cnt + 2'b1;
		end else begin
			cnt <= 0;
		end
	end

	assign out = cnt == 3;

endmodule