module top_module(
input sel,
input [7:0] pc_addr_in,data_addr_in,
output [7:0] mux8_out
);assign mux8_out = (sel==0? pc_addr_in:
							 sel==1? data_addr_in:0);endmodule