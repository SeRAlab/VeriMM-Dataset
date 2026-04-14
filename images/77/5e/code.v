module top_module(
	output [CNTRL_WIDTH-1:0] CNTRL_bus_out,
	input [WORD_WIDTH-1:0] INSTR_bus_in
	);parameter WORD_WIDTH = 16;
parameter DR_WIDTH = 3;
parameter SB_WIDTH = DR_WIDTH;
parameter SA_WIDTH = DR_WIDTH;
parameter OPCODE_WIDTH = 7;
parameter CNTRL_WIDTH = DR_WIDTH+SB_WIDTH+SA_WIDTH+11;
parameter COUNTER_WIDTH = 4;

wire PL = CNTRL_bus_out[2];
wire JB = CNTRL_bus_out[1];
wire BC = CNTRL_bus_out[0];

assign CNTRL_bus_out[0] = INSTR_bus_in[9];
assign CNTRL_bus_out[1] = INSTR_bus_in[13];
assign CNTRL_bus_out[2] = INSTR_bus_in[15]&INSTR_bus_in[14];
assign CNTRL_bus_out[3] = ~INSTR_bus_in[15]&INSTR_bus_in[14];
assign CNTRL_bus_out[4] = ~INSTR_bus_in[14];
assign CNTRL_bus_out[5] = INSTR_bus_in[13];
assign CNTRL_bus_out[9:6] = {INSTR_bus_in[12:10],~CNTRL_bus_out[2]&INSTR_bus_in[9]};
assign CNTRL_bus_out[10] = INSTR_bus_in[15];
assign CNTRL_bus_out[13:11] = INSTR_bus_in[2:0];
assign CNTRL_bus_out[16:14] = INSTR_bus_in[5:3];
assign CNTRL_bus_out[19:17] = INSTR_bus_in[8:6];

endmodule