module top_module(address,write_signal_memory,memory_out,write_data,read_signal_memory,reset,clk);parameter word_size = 32;
parameter memory_bits = 5;
parameter memory_size = 32;
integer i;

input[memory_bits-1:0] address;
input write_signal_memory;
output[word_size-1:0] memory_out;
input[word_size-1:0] write_data;
input read_signal_memory;
input reset;
input clk;

reg[word_size-1:0] data[memory_size-1:0];
reg[word_size-1:0] memory_out;

always @(posedge clk)
		begin
		if(reset==1)
		begin
			for(i=0;i<memory_size;i++)
				data[i] = 0;
		end
		else if(write_signal_memory==1)
				data[address] = write_data;		
		end

always @(negedge clk)
		begin
			if(read_signal_memory==1)
				memory_out = data[address];
		end

endmodule