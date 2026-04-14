module bus_control(
	ctl_bus_ff_oe,
	ctl_bus_zero_oe,
	db
);
input wire	ctl_bus_ff_oe;
input wire	ctl_bus_zero_oe;
inout wire	[7:0] db;
wire	[7:0] bus;
wire	[7:0] vcc;
wire	SYNTHESIZED_WIRE_0;
assign	db[7] = SYNTHESIZED_WIRE_0 ? bus[7] : 1'bz;
assign	db[6] = SYNTHESIZED_WIRE_0 ? bus[6] : 1'bz;
assign	db[5] = SYNTHESIZED_WIRE_0 ? bus[5] : 1'bz;
assign	db[4] = SYNTHESIZED_WIRE_0 ? bus[4] : 1'bz;
assign	db[3] = SYNTHESIZED_WIRE_0 ? bus[3] : 1'bz;
assign	db[2] = SYNTHESIZED_WIRE_0 ? bus[2] : 1'bz;
assign	db[1] = SYNTHESIZED_WIRE_0 ? bus[1] : 1'bz;
assign	db[0] = SYNTHESIZED_WIRE_0 ? bus[0] : 1'bz;
assign	bus = {ctl_bus_ff_oe,ctl_bus_ff_oe,ctl_bus_ff_oe,ctl_bus_ff_oe,ctl_bus_ff_oe,ctl_bus_ff_oe,ctl_bus_ff_oe,ctl_bus_ff_oe} & vcc;
assign	SYNTHESIZED_WIRE_0 = ctl_bus_ff_oe | ctl_bus_zero_oe;
assign	vcc = 8'b11111111;
endmodule