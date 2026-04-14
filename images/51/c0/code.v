module top_module(
    input CLOCK,
    input RESET,
    input [15:0] D,
    output reg [15:0] Q
    );always @(posedge CLOCK or posedge RESET) begin
		if (RESET) begin
			Q <= 0;
			
		end
		else begin
			Q <= D;
		end
	end

endmodule