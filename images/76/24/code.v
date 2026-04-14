module top_module(
input [1:0] sel,
input [15:0] alu_in, mem_in, cntrl_in,
output [15:0] mux16_out
);assign mux16_out = (sel==0? alu_in:
							  sel==1? mem_in:
							  sel==2? cntrl_in: 0);endmodule