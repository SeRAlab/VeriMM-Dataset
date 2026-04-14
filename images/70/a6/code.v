module top_module(
    input [31:0] inp1,inp2,
    output [31:0] result
  );wire[31:0] shifted_inp2;
	assign shifted_inp2 = inp2 << 2;
  assign result = inp1 + shifted_inp2;endmodule