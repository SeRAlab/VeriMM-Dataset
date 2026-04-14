module top_module(_input, output_, switchRead, switchWrite, reset, clk, haveData);input [15:0] _input;
	output reg [31:0] output_;
	input switchRead, switchWrite;
	input reset;
	input clk;
	output haveData;
	reg[3:0] index;
	reg [31:0] ram[31:0];
	always @ (posedge clk) begin  
		if(reset)
			index <= 0;
		else if(switchRead) begin
			index <= index + 4'd1;
			output_ <= 32'd0;
			ram[index] <= _input;
		end
		else if(switchWrite) begin
			output_ <= ram[index];	
			index <= index - 4'd1;
		end
		else if(reset) begin
			index <= 4'd0;
			output_ <= 32'd0;
		end
	end
	assign haveData = index > 0;
endmodule