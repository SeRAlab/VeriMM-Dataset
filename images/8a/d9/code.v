module top_module (
	input clk,
	input reset,
	input [7:0] temp,
	output reg [6:0] display);always @(posedge clk or posedge reset) begin
		if (reset) begin
			display <= 7'b1000000; // Display 0
		end else begin
			case (temp)
				8'd0: display = 7'b1000000;
				8'd1: display = 7'b1111001;
				8'd2: display = 7'b0100100;
				8'd3: display = 7'b0110000;
				8'd4: display = 7'b0011001;
				8'd5: display = 7'b0010010;
				8'd6: display = 7'b0000010;
				8'd7: display = 7'b1111000;
				8'd8: display = 7'b0000000;
				8'd9: display = 7'b0010000;
				// Add cases for 10 to 99 here
				default: display = 7'b1111111;
			endcase
		end
	end
	
endmodule