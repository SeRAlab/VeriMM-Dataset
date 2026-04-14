module top_module(
						input [7:0]din,
						output [7:0]dout
						);assign  dout= {din[1],din[0],din[3],din[2],din[5],din[4],din[7],din[6]};

endmodule