module top_module (
        input [3:1] d,
        input v,
        output reg D2,
        output reg D3);

	assign D2 = d[1]&~v | d[3]&~v;
	assign D3 = d[1]&v | d[2]&v;

endmodule