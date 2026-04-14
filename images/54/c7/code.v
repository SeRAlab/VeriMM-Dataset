module top_module(
	input clk,
	input rst,
	input en,
	output reg last_phase_en
	);reg [9:0] num;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		num <= 0;
		last_phase_en <= 0;
	end
	else if (en) begin
		if (num < 10'd2) begin
			num <= num + 1;
			last_phase_en <= 0;
		end
		else begin
			num <= num;
			last_phase_en <= 1;
		end
	end
	else begin
		num <= 0;
		last_phase_en <= 0;
	end
end
endmodule