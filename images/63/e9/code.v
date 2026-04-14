module top_module (
        input clk,
        input areset,
        input timer,
        output reg [1:0] signal);parameter Walk=2'b01, Dont_Walk=2'b10;
	reg [1:0] state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Walk;
		else begin
			case (state)
				Walk: state <= timer ? Dont_Walk : Walk;
				Dont_Walk: state <= timer ? Walk : Dont_Walk;
			endcase
		end
	end
	
	assign signal = state;
	
endmodule