module top_module(
	 input InterruptRequest,
    input clk,
    input reset,
    input ErrorOvE,
    output reg ErrorOvM = 0,
	 input ErrorRlE,
	 output reg ErrorRlM = 0,
    input [31:0] PCE,
    output reg [31:0] PCM = 0
    );always @(posedge clk) begin
		if (reset || InterruptRequest) begin
			ErrorRlM <= 0;
			ErrorRlM <= 0;
			PCM <= 0;
		end
		else begin
			ErrorRlM <= ErrorRlE;
			ErrorOvM <= ErrorOvE;
			PCM <= PCE;
		end 
 	end

endmodule