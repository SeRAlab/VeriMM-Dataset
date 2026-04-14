module top_module(addOut, DOut2, DOut1);output [7:0] addOut;
input [7:0] DOut1;
input [7:0] DOut2;

	assign addOut = DOut1 + DOut2;

endmodule