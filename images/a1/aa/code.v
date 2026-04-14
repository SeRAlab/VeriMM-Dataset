module top_module(currVal, ctrl, outVal);input currVal, ctrl;
	output outVal;
	
	assign outVal = ctrl ? ~currVal : currVal;endmodule