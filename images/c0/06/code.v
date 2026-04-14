module wait_state(
	CLK,
	nM1,
	nMREQ,
	nWAIT_M1,
	nWAIT_Mem
);
input wire	CLK;
input wire	nM1;
input wire	nMREQ;
output wire	nWAIT_M1;
output wire	nWAIT_Mem;
reg	SYNTHESIZED_WIRE_1;
reg	DFF_inst3;
reg	DFF_inst2;
reg	DFF_inst5;
wire	SYNTHESIZED_WIRE_0;
assign	nWAIT_M1 = DFF_inst2;
assign	SYNTHESIZED_WIRE_0 =  ~SYNTHESIZED_WIRE_1;
always@(posedge CLK or negedge DFF_inst3)
begin
if (!DFF_inst3)
	begin
	DFF_inst2 <= 1;
	end
else
	begin
	DFF_inst2 <= nM1;
	end
end
always@(posedge CLK)
begin
	begin
	DFF_inst3 <= DFF_inst2;
	end
end
always@(posedge CLK)
begin
	begin
	SYNTHESIZED_WIRE_1 <= nMREQ;
	end
end
always@(posedge CLK)
begin
	begin
	DFF_inst5 <= SYNTHESIZED_WIRE_1;
	end
end
assign	nWAIT_Mem = ~(DFF_inst5 & SYNTHESIZED_WIRE_0);
endmodule