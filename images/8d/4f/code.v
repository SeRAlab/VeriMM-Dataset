module top_module(currVal, stuckAtVal, ctrl, outVal);input currVal, stuckAtVal, ctrl;
	output outVal;
	
	assign outVal = ctrl ? stuckAtVal : currVal;endmodule