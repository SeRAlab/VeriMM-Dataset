module top_module(In, S, Out0, Out1);input        In;
	input        S;
	output Out0, Out1;
	
    assign Out0 = In & (~S);
    assign Out1 = In & S;

endmodule