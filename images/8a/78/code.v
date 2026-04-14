module top_module(inputA, inputB, subResult, result);input inputA, inputB, subResult;
	output result;
	
	wire xorResult;
	assign xorResult = inputA ^ inputB;
	
	wire noSubCase;
	assign noSubCase = xorResult & inputA;
	
	wire isBothAsserted;
	assign isBothAsserted = inputA & inputB;
	
	wire isNeitherAsserted;
	assign isNeitherAsserted = (!inputA) & (!inputB);
	
	wire lookAtSub;
	assign lookAtSub = isBothAsserted ^ isNeitherAsserted;
	
	wire resultIsSubMSB;
	assign resultIsSubMSB = lookAtSub & subResult;
	
	assign result = resultIsSubMSB | noSubCase;endmodule