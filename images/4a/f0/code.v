module top_module(
	areset,
	inclk0,
	c0,
	c1,
	c2,
	c3,
	c4);input	  areset;
	input	  inclk0;
	output reg c0; // Changed to reg
	output reg c1; // Changed to reg
	output reg c2; // Changed to reg
	output reg c3; // Changed to reg
	output reg c4; // Changed to reg

	reg [4:0] count;
	reg [4:0] compare_value;
	reg [4:0] feedback_value;

	always @(posedge inclk0 or negedge areset) begin
		if (!areset) begin
			count <= 5'b0;
			compare_value <= 5'b0;
			feedback_value <= 5'b0;
		end else begin
			count <= count + 1;
			if (count == compare_value) begin
				count <= 5'b0;
			end
		end
	end

	always @(posedge inclk0 or negedge areset) begin
		if (!areset) begin
			c0 <= 1'b0;
			c1 <= 1'b0;
			c2 <= 1'b0;
			c3 <= 1'b0;
			c4 <= 1'b0;
		end else begin
			feedback_value <= {feedback_value[3:0], count[0]};
			if (feedback_value == compare_value) begin
				c0 <= ~c0;
				if (c0 == 1'b0) begin
					c1 <= ~c1;
					if (c1 == 1'b0) begin
						c2 <= ~c2;
						if (c2 == 1'b0) begin
							c3 <= ~c3;
							if (c3 == 1'b0) begin
								c4 <= ~c4;
							end
						end
					end
				end
			end
		end
	end

	always @(posedge inclk0 or negedge areset) begin
		if (!areset) begin
			compare_value <= 5'b0;
		end else begin
			case (compare_value)
				5'b00001: compare_value <= 5'b00010;
				5'b00010: compare_value <= 5'b00100;
				5'b00100: compare_value <= 5'b01000;
				5'b01000: compare_value <= 5'b10000;
				5'b10000: compare_value <= 5'b00001;
			endcase
		end
	end

endmodule