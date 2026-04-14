module top_module(rstn, clk, up, down, count);parameter WIDTH = 8;
	
	input rstn;
	input clk;
	input up;
	input down;
	output [WIDTH-1:0] count;
	
	reg[WIDTH-1:0] count_int = 0;
	
	assign count = count_int;
	
	always @ (posedge clk or negedge rstn) begin
		if(rstn == 0) begin
			count_int <= 0;
		end else begin		
			if(up == 1) begin
				count_int  <= count_int + 1'b1;
			end else if(down == 1) begin
				count_int <= count_int - 1'b1;
			end
		end
	end
endmodule