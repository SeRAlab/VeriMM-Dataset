module top_module(input D0, D1, SD, output Z);assign Z = SD ? D1 : D0;
	specify
		(D0 => Z) = 140;
		(D1 => Z) = 141;
		(SD => Z) = 148;
	endspecify
endmodule