module top_module(
    input wire [15:0] in1,
    input wire [15:0] in2,
    input wire [3:0] shift_amt,
    input wire sel,
    output wire [15:0] out,
    output wire parity
);wire [15:0] shifted_input;

// Barrel shifter
assign shifted_input = (shift_amt[3]) ? {16{in1[15]}} & (in1 << shift_amt) : (in1 >> shift_amt);

// Multiplexer
assign out = (sel) ? shifted_input : in2;

// Parity bit generator
assign parity = ^out;

endmodule