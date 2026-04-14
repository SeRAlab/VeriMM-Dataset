module top_module(input[5:0] yIn , output[5:0] yOut);wire[5:0] inverted_yIn;
	assign inverted_yIn = ~yIn;
	assign yOut = yIn[5] ? ({yIn[5],inverted_yIn[4:0]}+6'b1) : yIn;
endmodule