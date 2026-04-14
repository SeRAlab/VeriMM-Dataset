module top_module(CLK, RESET, SystemCLKFreq, OutputCLKFreq, OutputCLK);parameter SystemClockSize = 10;
input [(SystemClockSize - 1):0] SystemCLKFreq, OutputCLKFreq;
input RESET, CLK;

output reg OutputCLK;


parameter INIT_COUNT = 16'd0;
reg [15:0] count;

always @(posedge CLK) begin
	if(RESET) begin
		count <= INIT_COUNT;
		OutputCLK <= 1'b0;
	end
	
	
	
	
	else if (count >= ((SystemCLKFreq / OutputCLKFreq) / 2) - 1) begin
		count <= INIT_COUNT;
		OutputCLK <= ~OutputCLK;
	end
	else begin
		count <= count + 1'b1;
		OutputCLK <= OutputCLK;
	end
end

endmodule