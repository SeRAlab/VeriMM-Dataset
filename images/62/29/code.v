module top_module(
    output reg [255:0] CFG
);// Device ID and Vendor ID
assign CFG[151:120] = 32'h0001_FEED;

// Class Code and Revision ID
assign CFG[183:152] = 32'h02000000;

// Subsystem ID and Subvendor ID
assign CFG[215:184] = 32'h0000_FEED;

// Base Address Register 0 (BAR0)
assign CFG[31:0] = 32'h0800_0001; // BAR0 with 128MB size
assign CFG[34:32] = 3'b000; // Assigning the remaining bits for the BAR

// Base Address Register 1 (BAR1)
assign CFG[37] = 1'b0; // Example value for BAR1

// Base Address Register 2 (BAR2)
assign CFG[74] = 1'b0; // Example value for BAR2

// Maximum Latency and Minimum Grant
assign CFG[231:224] = 8'h00;
assign CFG[223:216] = 8'h00;

// Latency Timer Enable and Interrupt Enable
assign CFG[112] = 1'b1;
assign CFG[113] = 1'b1;

// Capability List Enable, Capability List Pointer, User Config Space Enable, and Interrupt Acknowledge
assign CFG[116] = 1'b0;
assign CFG[239:232] = 8'h00;
assign CFG[118] = 1'b0;
assign CFG[240] = 1'b0;

// Enable 66 MHz
assign CFG[244] = 1'b0;

// Obsolete settings
assign CFG[111] = 1'b0;
assign CFG[117] = 1'b0;
assign CFG[119] = 1'b0;

// Other PCI options
assign CFG[254:245] = 10'b0010000000;

// Do Not Modify
assign CFG[115] = 1'b0;
assign CFG[241] = 1'b0;
assign CFG[242] = 1'b0;
assign CFG[243] = 1'b0;
assign CFG[255] = 1'b0;

endmodule