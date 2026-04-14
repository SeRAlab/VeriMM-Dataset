module top_module (
	input clk,
	input reset,
	input start,
	input stop,
	output reg [6:0] display);reg [5:0] count;
	reg running;
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			count <= 0;
			running <= 0;
		end else if (start) begin
			running <= 1;
		end else if (stop) begin
			running <= 0;
		end else if (running) begin
			if (count == 59) begin
				count <= 0;
			end else begin
				count <= count + 1;
			end
		end
	end
	
	always @(*) begin
		case (count)
			6'd0: display = 7'b1000000;
			6'd1: display = 7'b1111001;
			6'd2: display = 7'b0100100;
			6'd3: display = 7'b0110000;
			6'd4: display = 7'b0011001;
			6'd5: display = 7'b0010010;
			6'd6: display = 7'b0000010;
			6'd7: display = 7'b1111000;
			6'd8: display = 7'b0000000;
			6'd9: display = 7'b0010000;
			// Add cases for 10 to 59 here
			default: display = 7'b1111111;
		endcase
	end
	
endmodule