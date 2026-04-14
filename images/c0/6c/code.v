module control_pins_n(
	busack,
	CPUCLK,
	pin_control_oe,
	in_halt,
	pin_nWAIT,
	pin_nBUSRQ,
	pin_nINT,
	pin_nNMI,
	pin_nRESET,
	nM1_out,
	nRFSH_out,
	nRD_out,
	nWR_out,
	nIORQ_out,
	nMREQ_out,
	nmi,
	busrq,
	clk,
	intr,
	mwait,
	reset_in,
	pin_nM1,
	pin_nMREQ,
	pin_nIORQ,
	pin_nRD,
	pin_nWR,
	pin_nRFSH,
	pin_nHALT,
	pin_nBUSACK
);
input wire	busack;
input wire	CPUCLK;
input wire	pin_control_oe;
input wire	in_halt;
input wire	pin_nWAIT;
input wire	pin_nBUSRQ;
input wire	pin_nINT;
input wire	pin_nNMI;
input wire	pin_nRESET;
input wire	nM1_out;
input wire	nRFSH_out;
input wire	nRD_out;
input wire	nWR_out;
input wire	nIORQ_out;
input wire	nMREQ_out;
output wire	nmi;
output wire	busrq;
output wire	clk;
output wire	intr;
output wire	mwait;
output wire	reset_in;
output wire	pin_nM1;
output wire	pin_nMREQ;
output wire	pin_nIORQ;
output wire	pin_nRD;
output wire	pin_nWR;
output wire	pin_nRFSH;
output wire	pin_nHALT;
output wire	pin_nBUSACK;
assign	clk = CPUCLK;
assign	pin_nM1 = nM1_out;
assign	pin_nRFSH = nRFSH_out;
assign	pin_nMREQ = pin_control_oe ? nMREQ_out : 1'bz;
assign	pin_nIORQ = pin_control_oe ? nIORQ_out : 1'bz;
assign	pin_nRD = pin_control_oe ? nRD_out : 1'bz;
assign	pin_nWR = pin_control_oe ? nWR_out : 1'bz;
assign	busrq =  ~pin_nBUSRQ;
assign	pin_nHALT =  ~in_halt;
assign	mwait =  ~pin_nWAIT;
assign	pin_nBUSACK =  ~busack;
assign	intr =  ~pin_nINT;
assign	nmi =  ~pin_nNMI;
assign	reset_in =  ~pin_nRESET;
endmodule