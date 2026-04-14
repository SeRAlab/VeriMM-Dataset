module top_module(
	input clk_1m,
	input[2:0] dir,
	input[1:0] choose,
	input[1:0] speed,
	output reg[2:0] state
);always@ (posedge clk_1m)
begin
	if(choose == 0 || choose == 3 || speed == 0)	
		state <= 3'b111;
	else if(choose == 2)	
		state <= 3'b010;
	else
		begin
			case(dir)
			
			3'b000: state <= 3'b000;
			3'b001: state <= 3'b000;
			3'b010: state <= 3'b000;
			
			3'b100: state <= 3'b011;
			3'b101: state <= 3'b011;
			3'b110: state <= 3'b011;
			
			default: state <= 3'b001;
			
			endcase
		end
end

endmodule