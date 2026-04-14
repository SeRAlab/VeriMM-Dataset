module top_module(
	output [31:0] capabilities
);wire memorycard;
wire ac97;
wire pfpu;
wire tmu;
wire ethernet;
wire fmlmeter;
wire videoin;
wire midi;
wire dmx;
wire ir;
wire usb;
wire memtest;

assign capabilities = {
	20'd0,
	memtest,
	usb,
	ir,
	dmx,
	midi,
	videoin,
	fmlmeter,
	ethernet,
	tmu,
	pfpu,
	ac97,
	memorycard
};

`ifdef ENABLE_MEMORYCARD
assign memorycard = 1'b1;
`else
assign memorycard = 1'b0;
`endif

`ifdef ENABLE_AC97
assign ac97 = 1'b1;
`else
assign ac97 = 1'b0;
`endif

`ifdef ENABLE_PFPU
assign pfpu = 1'b1;
`else
assign pfpu = 1'b0;
`endif

`ifdef ENABLE_TMU
assign tmu = 1'b1;
`else
assign tmu = 1'b0;
`endif

`ifdef ENABLE_ETHERNET
assign ethernet = 1'b1;
`else
assign ethernet = 1'b0;
`endif

`ifdef ENABLE_FMLMETER
assign fmlmeter = 1'b1;
`else
assign fmlmeter = 1'b0;
`endif

`ifdef ENABLE_VIDEOIN
assign videoin = 1'b1;
`else
assign videoin = 1'b0;
`endif

`ifdef ENABLE_MIDI
assign midi = 1'b1;
`else
assign midi = 1'b0;
`endif

`ifdef ENABLE_DMX
assign dmx = 1'b1;
`else
assign dmx = 1'b0;
`endif

`ifdef ENABLE_IR
assign ir = 1'b1;
`else
assign ir = 1'b0;
`endif

`ifdef ENABLE_USB
assign usb = 1'b1;
`else
assign usb = 1'b0;
`endif

`ifdef ENABLE_MEMTEST
assign memtest = 1'b1;
`else
assign memtest = 1'b0;
`endif

endmodule