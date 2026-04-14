module top_module(input ALUT, BLUT, C0, output Z);assign Z = C0 ? ALUT : BLUT;
	specify
		(ALUT => Z) = 98;
		(BLUT => Z) = 98;
		(C0 => Z) = 151;
	endspecify
endmodule