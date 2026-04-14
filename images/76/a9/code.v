module top_module(a, b, op, res, over);parameter N = 3;

(* altera_attribute = "-name IO_STANDARD \"2.5V\"", chip_pin = "46,25,24" *)
input [N-1:0] a;
(* altera_attribute = "-name IO_STANDARD \"2.5V\"", chip_pin = "90,91,49" *)
input [N-1:0] b;
(* altera_attribute = "-name IO_STANDARD \"2.5V\"", chip_pin = "88,89" *)
input [1:0] op;
(* altera_attribute = "-name IO_STANDARD \"2.5V\"", chip_pin = "69" *)
output reg [N-1:0] res;
(* altera_attribute = "-name IO_STANDARD \"2.5V\"", chip_pin = "70,71,72" *)
output reg over;

localparam SUM = 1, SUB = 2, MULT = 3;

always @* begin
	over <= 1'b0;
	case (op)
		SUM:
			{over, res} <= {1'b0, a} + {1'b0, b};
		SUB:
			{over, res} <= {1'b0, a} - {1'b0, b};
		MULT: 
			res <= a > b ? a : b;
		default:
			res <= 0;
	endcase
end

assign led = {over, res};

endmodule