module top_module(
	input clk,
	input [15:0] data,
	output reg [4:0] str
);reg [2:0] state = 0;
	reg [3:0] count = 0;
	reg [1:0] char_count = 0;
	reg [15:0] morse_code = 16'h0000;

	always @(posedge clk) begin
		case (state)
			0: begin
				if (data == 16'h0000) begin
					state <= 1;
					count <= 0;
				end
			end
			1: begin
				if (data == 16'h0001) begin
					state <= 2;
					count <= 0;
				end else if (count == 3) begin
					state <= 0;
				end else begin
					count <= count + 1;
				end
			end
			2: begin
				if (data == 16'h0000) begin
					morse_code[char_count*4 +: 4] <= count;
					char_count <= char_count + 1;
					if (char_count == 5) begin
						state <= 3;
						str <= {8'h68, 8'h65, 8'h6C, 8'h6C, 8'h6F};
					end else begin
						state <= 1;
					end
				end else if (count == 3) begin
					state <= 0;
				end else begin
					count <= count + 1;
				end
			end
			3: begin
				if (data == 16'h0000) begin
					state <= 1;
					count <= 0;
					char_count <= 0;
					morse_code <= 16'h0000;
				end
			end
			default: begin
				state <= 0;
			end
		endcase
	end

endmodule