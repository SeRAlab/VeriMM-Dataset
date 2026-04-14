module custom_logic (
	input e,
	input f,
	input g,
	input h,
	output reg r);assign r = e&~f&~g&~h | ~e&f&~g&h | ~e&~f&g&~h | e&f&g&~h | e&~f&~g&h;

endmodule