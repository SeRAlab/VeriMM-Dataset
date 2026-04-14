module top_module(
  input a,
  input b,
  input c,
  output [1:0] o
);parameter ALUTYPE = "ADD";

	generate
		case (ALUTYPE)
			"ADD": 		 assign o = a + b + c;
			"SUB": 		 assign o = a - b - c;
			"A_LE_B":    assign o = a - b - c;

			"ADD_CARRY":    assign o = {  a, 1'b0 };
			"SUB_CARRY":    assign o = { ~a, 1'b0 };
			"A_LE_B_CARRY": assign o = {  a, 1'b0 };
			default: assign o = a + b + c;
		endcase
	endgenerate	

endmodule