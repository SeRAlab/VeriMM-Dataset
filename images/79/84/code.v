module top_module(
		input clk, rst,
		output reg t0, t1, t2, t3
	);always @(posedge clk) begin
		if (rst) begin
			t0 <= 1'b1;
			t1 <= 1'b0;
			t2 <= 1'b0;
			t3 <= 1'b0;
		end
		else if (t0) begin
			t0 <= 1'b0;
			t1 <= 1'b1;
		end
		else if (t1) begin
			t1 <= 1'b0;
			t2 <= 1'b1;
		end
		else if (t2) begin
			t2 <= 1'b0;
			t3 <= 1'b1;
		end
		else if (t3) begin
			t3 <= 1'b0;
			t0 <= 1'b1;
		end
	end

endmodule