module top_module(
	input clk,
	input rst_n,
	output reg [7:0] counter,
	output C,
	input en,
	input clr
    );always @ (posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			counter <= 0;
		end
		else begin
			if(clr) begin
				counter <= 0;
			end
			else begin
				if(en) begin
					counter <= counter + 1;
				end
			end
		end
	end

	assign  C = (counter == 8'hff) & en & (~clr);endmodule