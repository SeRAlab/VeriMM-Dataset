module top_module(
	input clk,
	output reg flag_U,
	output reg flag_V,
	output reg flag_W
	);reg[8:0] cnt = 9'b0;
	reg state = 0;
	
	always@(posedge clk && state == 0) begin
		flag_U <= 1;
		if(cnt == 9'b101101000) begin 
			cnt <= cnt;
			state <= 1;
		end else if(cnt == 9'b1111000) begin 
			flag_V <= 1;
			cnt <= cnt + 9'b1;
		end else if(cnt == 9'b11110000) begin 
			flag_W <= 1;
			cnt <= cnt + 9'b1;
		end else begin
			cnt <= cnt + 9'b1;
		end
	end
endmodule