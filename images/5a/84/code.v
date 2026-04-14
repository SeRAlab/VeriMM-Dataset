module top_module(input clk,rst,input[1:0] stackCntrl, input[11:0] pushValue, output[11:0] popValue);reg[2:0] stackPntr;
	reg[11:0] data[0:7];
	
	always@(posedge clk , posedge rst) 
		if(~rst)
		begin
		  #1;
			if(stackCntrl==2'b01)
			begin
				data[stackPntr] = pushValue+1;
				stackPntr = stackPntr+1;				
			end
			else if(stackCntrl == 2'b10) 
			begin
				stackPntr = stackPntr-1;
			end
		end
		else
			stackPntr = 3'b000;
	assign popValue = data[stackPntr];
endmodule