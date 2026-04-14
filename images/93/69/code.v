module top_module(output reg Q,input enable,D);always @(enable,D)
	if(enable) Q <= D;endmodule