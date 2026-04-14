module top_module(doorOpen, fiveMinTillArriv, diffOk, whatGate, poundOccu, ctrl, reset);output doorOpen;
	input fiveMinTillArriv, diffOk, whatGate, poundOccu, ctrl, reset;
	
	assign doorOpen = ctrl && ((~whatGate && diffOk) || 			
		(whatGate && diffOk && ~poundOccu && fiveMinTillArriv));	
endmodule