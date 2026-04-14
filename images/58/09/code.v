module mux4bit8to1 (
	input [2:0] sel,
	input [3:0] d0,
	input [3:0] d1,
	input [3:0] d2,
	input [3:0] d3,
	input [3:0] d4,
	input [3:0] d5,
	input [3:0] d6,
	input [3:0] d7,
	output [3:0] y
);assign y = sel == 3'b000 ? d0 :
           sel == 3'b001 ? d1 :
           sel == 3'b010 ? d2 :
           sel == 3'b011 ? d3 :
           sel == 3'b100 ? d4 :
           sel == 3'b101 ? d5 :
           sel == 3'b110 ? d6 : d7;

endmodule