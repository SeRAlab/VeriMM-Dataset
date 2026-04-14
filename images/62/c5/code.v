module mux2bit4to1 (
	input [1:0] sel,
	input [1:0] d0,
	input [1:0] d1,
	input [1:0] d2,
	input [1:0] d3,
	output [1:0] y
);assign y = (sel == 2'b00) ? d0 :
           (sel == 2'b01) ? d1 :
           (sel == 2'b10) ? d2 :
           d3;

endmodule