module top_module(
    input ENA,
    output CLK
    );wire tmp[1:0];
	 
	 assign #10 CLK = ~(ENA & tmp[1]);
	 assign #10 tmp[0] = ~CLK;
	 assign #10 tmp[1] = ~tmp[0];

endmodule