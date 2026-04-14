module top_module(clk, arst, ena, pos, bin, one_bit);input clk, arst, ena;
input [2:0] pos;

output reg [2:0] one_bit;
output reg [3:0] bin;

always @ (posedge clk, negedge arst) begin
	if (!arst) begin
		one_bit <= 3'b000;
		bin <= 4'hF;
	end else if (ena) begin
		casex (pos)
			3'b1xx: begin 
						one_bit <= 3'b100;
						bin <= 4'h3;
					end
			3'b01x: begin 
						one_bit <= 3'b010;
						bin <= 4'h2;
					end
			3'b001: begin
						one_bit <= 3'b001;
						bin <= 4'h1;
					end
			default: begin	
						one_bit <= 3'b000;
						bin <= 4'hF;
					end
		endcase
	end
end

endmodule