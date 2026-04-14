module top_module(input wire[31:0] input_0,input wire[31:0] input_1,input wire selector,output wire[31:0] write_data);assign write_data=(selector==0)? input_0:
		  (selector==1)?input_1:0;endmodule