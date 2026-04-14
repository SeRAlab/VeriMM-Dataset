module adder_subtractor
    (
		input [31:0] a,
        input [31:0] b,
        input add_sub,
        output [31:0] result
    );

assign result = add_sub ? (a + b) : (a - b);

endmodule