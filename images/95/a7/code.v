module top_module(
    input in,
    input oe,
    output out,
    output outb
);wire inv_in = ~in;

// Output enable logic
wire oe_and_inv_in = oe & inv_in;
wire oe_and_in = oe & in;

// Positive output signal logic
wire out_and_inv_oe = out & ~oe;
wire out_and_inv_in = out & inv_in;
wire out_and_oe_and_in = out & oe_and_in;
wire out_mux = oe_and_inv_in | out_and_oe_and_in;
assign out = out_mux | out_and_inv_oe;

// Negative output signal logic
wire outb_and_inv_oe = outb & ~oe;
wire outb_and_in = outb & in;
wire outb_and_oe_and_inv_in = outb & oe_and_inv_in;
wire outb_mux = oe_and_in | outb_and_oe_and_inv_in;
assign outb = outb_mux | outb_and_inv_oe;

endmodule