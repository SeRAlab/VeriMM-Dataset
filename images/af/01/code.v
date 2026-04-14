module top_module(
     input i0, i1,
	  output eq
    );wire p0, p1;

assign eq = p0 | p1;

assign p0 = ~i0 & ~i1;
assign p1 = i0 & i1;


endmodule