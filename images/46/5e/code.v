module top_module(address,ValidOut,write_signal,reset,clk);parameter index = 3;
	parameter cachesize = 8;
	input[index-1:0] address;
	input write_signal;
	input reset;
	input clk;
	output ValidOut;
	integer i;
	reg ValidOut;
	reg Validbits[cachesize-1:0];
	always@(posedge clk)       
		begin
			if(write_signal==1&&reset==0)
				Validbits[address] = 1;
			else if(reset==1)
			begin
					for(i=0;i<cachesize;i++)
							Validbits[i] = 0;
			end
		end
	always@(negedge clk)	  
		begin
			ValidOut = Validbits[address];
		end
endmodule