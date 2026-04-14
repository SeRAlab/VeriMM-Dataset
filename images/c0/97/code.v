module pin_control(
	fFetch,
	fMRead,
	fMWrite,
	fIORead,
	fIOWrite,
	T1,
	T2,
	T3,
	T4,
	bus_ab_pin_we,
	bus_db_pin_oe,
	bus_db_pin_re
);
input wire	fFetch;
input wire	fMRead;
input wire	fMWrite;
input wire	fIORead;
input wire	fIOWrite;
input wire	T1;
input wire	T2;
input wire	T3;
input wire	T4;
output wire	bus_ab_pin_we;
output wire	bus_db_pin_oe;
output wire	bus_db_pin_re;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;
assign	SYNTHESIZED_WIRE_9 = fFetch | fMWrite | fMRead | fIORead | fIOWrite | fIOWrite;
assign	SYNTHESIZED_WIRE_7 = T3 | T2;
assign	bus_db_pin_oe = SYNTHESIZED_WIRE_0 | SYNTHESIZED_WIRE_1;
assign	SYNTHESIZED_WIRE_3 = T3 & fIORead;
assign	bus_db_pin_re = SYNTHESIZED_WIRE_2 | SYNTHESIZED_WIRE_3 | SYNTHESIZED_WIRE_4;
assign	bus_ab_pin_we = SYNTHESIZED_WIRE_5 | SYNTHESIZED_WIRE_6;
assign	SYNTHESIZED_WIRE_8 = T2 | T3 | T4;
assign	SYNTHESIZED_WIRE_1 = fMWrite & SYNTHESIZED_WIRE_7;
assign	SYNTHESIZED_WIRE_0 = SYNTHESIZED_WIRE_8 & fIOWrite;
assign	SYNTHESIZED_WIRE_4 = T2 & fFetch;
assign	SYNTHESIZED_WIRE_2 = T2 & fMRead;
assign	SYNTHESIZED_WIRE_6 = T3 & fFetch;
assign	SYNTHESIZED_WIRE_5 = T1 & SYNTHESIZED_WIRE_9;
endmodule